Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ECC142049;
	Thu, 15 Jan 2026 16:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496012; cv=none; b=Ry3MfZk8l6pZpbCRul5fc9Ws9gT1XMMLjndGD9gAkH6kfzE2eR+U2qUR4TJkd9/l3Yr9FgKO34p8060rah8MqlqXYbWqR/vDkKbOAFZd5nPWPmRSvihXFTbeDjHa0bfFoL2HWYvKEeeFZrjIa/lpEhlF8VDtYbOFsuywXysTYs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496012; c=relaxed/simple;
	bh=lBKqhwXjGR+Je++p8zJYmJYKPju9pScocNhAcHvdMMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ugwf0zjetZnPfqRK7yqqBObUXjxr0JQ4A+CTcqgBN18yzp9Us40A7nM5mc3V1s6mG6/KpKlGMCy2H9Bv9b7ozgfsrOFqFtYzzwT50R4zMEK8UvVOIk4HzYahKSfBpN2hMBNzeKlnlKeCXn9KsN7cESjJ4kX7YSNZsZGub8pflvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CJ2H0Iva; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CJ2H0Iva"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C248CC116D0;
	Thu, 15 Jan 2026 16:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496012;
	bh=lBKqhwXjGR+Je++p8zJYmJYKPju9pScocNhAcHvdMMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CJ2H0Ivam+kWlRo7b199OSkO/9wUDrw2B4JMMLXV7+UcApeY5YbOdgafv4amxjueC
	 NNDG/tA05rFULNS575DcQcvIHc/tPKRfoMNpTerH7GyP/vNemsq24Bvhnc1nJnW847
	 chzw5XEBG8+qagwtKFixdZg6ggdT1toTHD/u4XhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Li <yang.li85200@gmail.com>,
	Guo Ren <guoren@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 047/181] csky: fix csky_cmpxchg_fixup not working
Date: Thu, 15 Jan 2026 17:46:24 +0100
Message-ID: <20260115164204.027740275@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index a6ca7dff42153..7ff4011089850 100644
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



