Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF3F3A0E94;
	Thu, 15 Jan 2026 17:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496824; cv=none; b=geWMYzaulZg2/HQ6pdaPfTwC7owndTdHcODnsrhR5hP8HWrQ89TjE3eGpRTaNg1pP9ul5vJq6vX2o7rqHeFif/brrrDkbOcjybSubA58LCTwcsgPvTw4VD+cqC3BQ1fIVp7M+iec10UnBtdfyIO8dPCXxQYKOj6HxxcrQMxuSIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496824; c=relaxed/simple;
	bh=7m+XyKE2ZPuiorwr+XGHXUO3fNGM0i3OsrSFCsPV7hk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X95BIpzBZWUPdD89yx8Fkr2Tx23QzfNCS2isaqb95fVOWCAtyDv5YlWhgNxZwGCANcKL+R4gQF0cB4ZF8uTP+Evlq8JchaBD8BoLSv4P2PA6iuREw0M0AN0cfcprKew6LjqU6uLvXpENVFHat0yIu2UoMhXH/L3JBOKBau6baic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gFZGHLDL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gFZGHLDL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FE96C116D0;
	Thu, 15 Jan 2026 17:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496824;
	bh=7m+XyKE2ZPuiorwr+XGHXUO3fNGM0i3OsrSFCsPV7hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gFZGHLDLgbDA+LcZdJrahEAw/lU0fp0wPj0a6jPP1NwWErF4CgVP8pmGuYOPsbdVo
	 hcWt4lMrx+p/vnxCiV7zmKc6bC0upBwChX2SERP65Y/mVeBvotd2a9QXVppYgXEFie
	 SQ8B4iOy3Qqg9Zij+YJ8a79S57H3/Ph8TIldTDT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Li <yang.li85200@gmail.com>,
	Guo Ren <guoren@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 28/88] csky: fix csky_cmpxchg_fixup not working
Date: Thu, 15 Jan 2026 17:48:11 +0100
Message-ID: <20260115164147.331144176@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164146.312481509@linuxfoundation.org>
References: <20260115164146.312481509@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



