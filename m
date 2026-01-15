Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0703BC4F3;
	Thu, 15 Jan 2026 17:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497146; cv=none; b=XFYe5Fv94KnxN45YyPESaVebXWnGvs6d9wjSg4V6Rj6Zt3H/xOvuFU04je3TQ2DzEIQFWzgz18F77/rKiEYmLFIQenLd9Zuic5Py08OfCScOkP9UZlx8NrC6Q1KCBs6DxI3XNeC5TGFaYw3lt7WAT8wNiPVy5ZqFeuYyRjyR/Gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497146; c=relaxed/simple;
	bh=iKq4VmdiswjhKTKQzNQaIgLe5HfApvbuou2AHhcR9is=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IG7vnKHlZ8LgmHbwGQ6edFGloPqftLHU3Qc2RbGfRnRCKwx5AVXtSm5iLXhsBxMU+7cM9KYwClx2AzzignWGK3N4q4E0aiKu+AxTP0z7NB+YOJtd5yNgzb2hHx/T+OMelWVS2bKWtdLSIlXuFdaZYCJcuGctx5a8rb3IHE31XPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VueLnBaX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VueLnBaX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E733DC116D0;
	Thu, 15 Jan 2026 17:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497146;
	bh=iKq4VmdiswjhKTKQzNQaIgLe5HfApvbuou2AHhcR9is=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VueLnBaXxiObTI2lc3s5gxybVGBFfsZbGIoYz40jmF44vaKRK7Vpsr4a8PTyqwqFu
	 eLzfhdF/nlPO6oAB/GYGzWChm6Wo+kJpuEBCi3I/RH8N7wALhFoj32p3cj4GJFga8K
	 weEHl/w322VnnWFqUEia47a59V1vHwtrPXFMyfI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Li <yang.li85200@gmail.com>,
	Guo Ren <guoren@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 19/72] csky: fix csky_cmpxchg_fixup not working
Date: Thu, 15 Jan 2026 17:48:29 +0100
Message-ID: <20260115164144.193358643@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164143.482647486@linuxfoundation.org>
References: <20260115164143.482647486@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Li <yang.li85200@gmail.com>

[ Upstream commit 809ef03d6d21d5fea016bbf6babeec462e37e68c ]

In the csky_cmpxchg_fixup function, it is incorrect to use the global
variable csky_cmpxchg_stw to determine the address where the exception
occurred.The global variable csky_cmpxchg_stw stores the opcode at the
time of the exception, while &csky_cmpxchg_stw shows the address where
the exception occurred.

Signed-off-by: Yang Li <yang.li85200@gmail.com>
Signed-off-by: Guo Ren <guoren@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/csky/mm/fault.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/csky/mm/fault.c b/arch/csky/mm/fault.c
index a885518ce1dd2..5226bc08c3360 100644
--- a/arch/csky/mm/fault.c
+++ b/arch/csky/mm/fault.c
@@ -45,8 +45,8 @@ static inline void csky_cmpxchg_fixup(struct pt_regs *regs)
 	if (trap_no(regs) != VEC_TLBMODIFIED)
 		return;
 
-	if (instruction_pointer(regs) == csky_cmpxchg_stw)
-		instruction_pointer_set(regs, csky_cmpxchg_ldw);
+	if (instruction_pointer(regs) == (unsigned long)&csky_cmpxchg_stw)
+		instruction_pointer_set(regs, (unsigned long)&csky_cmpxchg_ldw);
 	return;
 }
 #endif
-- 
2.51.0



