Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3A01D0791;
	Wed,  2 Oct 2024 13:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875891; cv=none; b=ImFTS+VyPjhpNRG+wzupqxzLOgEeepgS4H1V9gL3Ie+faXQ8kBjxHfTGOdOOLBsokUzSSXwrPyN0+aaVYVz1ExWxjg1wvAAcCTVYQKQcOK1ybewF2AYgNkmryWzRQG1DFIJ4a4/sn0PDp4L9aeTChpgJlegITyKk7yA3MCRTjIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875891; c=relaxed/simple;
	bh=X6dzoSp6q9leO15U6f8qd3F3AyXe5pXQdLiFpy8wyfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jdqBpYMzLs5ZGScr82psmyb5V4gq8PSquLZqsj72UiBExql2Wt0Lh5IuTcujWNHpuDvDBPDklD885osj2MEHN5V5hoMN1Vz3WNBsFZqpRcIVGJvwbou7yZ1fFJEDs8/59xiBuuHgJFFnVCRiP21bUMMZ/eJ0AAKDfbjrYQ3zbUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y2cwCfKl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y2cwCfKl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA8D8C4CECE;
	Wed,  2 Oct 2024 13:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875891;
	bh=X6dzoSp6q9leO15U6f8qd3F3AyXe5pXQdLiFpy8wyfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y2cwCfKlhaZs+1znx0UPrym/LBF4UghnirY55BvCfnv18evx+IMC6okhuEYF/YsTx
	 qczU0VhQKyRfjGv6zMMNrf3CSj65MHXZSjHMgwp0KQFcLWu4I+Zcxee8bF1abm+jDU
	 E4ptEpWUbA7jJN2ptoMjURBvzgFX0Voqtxi2PxII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 225/695] powerpc/vdso: Inconditionally use CFUNC macro
Date: Wed,  2 Oct 2024 14:53:43 +0200
Message-ID: <20241002125831.436996011@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 65948b0e716a47382731889ee6bbb18642b8b003 ]

During merge of commit 4e991e3c16a3 ("powerpc: add CFUNC assembly
label annotation") a fallback version of CFUNC macro was added at
the last minute, so it can be used inconditionally.

Fixes: 4e991e3c16a3 ("powerpc: add CFUNC assembly label annotation")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/0fa863f2f69b2ca4094ae066fcf1430fb31110c9.1724313540.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/vdso/gettimeofday.S | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/powerpc/kernel/vdso/gettimeofday.S b/arch/powerpc/kernel/vdso/gettimeofday.S
index 48fc6658053aa..894cb939cd2b3 100644
--- a/arch/powerpc/kernel/vdso/gettimeofday.S
+++ b/arch/powerpc/kernel/vdso/gettimeofday.S
@@ -38,11 +38,7 @@
 	.else
 	addi		r4, r5, VDSO_DATA_OFFSET
 	.endif
-#ifdef __powerpc64__
 	bl		CFUNC(DOTSYM(\funct))
-#else
-	bl		\funct
-#endif
 	PPC_LL		r0, PPC_MIN_STKFRM + PPC_LR_STKOFF(r1)
 #ifdef __powerpc64__
 	PPC_LL		r2, PPC_MIN_STKFRM + STK_GOT(r1)
-- 
2.43.0



