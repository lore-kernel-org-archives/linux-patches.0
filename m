Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86FC41DF246;
	Sun,  7 Sep 2025 20:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277471; cv=none; b=cjtWugUCAuaWpWFYCxDqnlFWOFekYaqqRIgKLi6YNxTHUM8JWrQdUkKYkrayVZLP+pF23kF8u4RN0hhV9HpIlk4ABdAribp/uJwxvrDCBCW5wVICPPObb5g9DDqEUg6LANJcOHE75n1SyyaG1F9KFoMU5KthgDEYuO5FHQbtboU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277471; c=relaxed/simple;
	bh=5jqmBrGWjeqgLSYfDH0U5NsidLnC2BaWgmcNC1PtMEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oTJmMAEDG401GDsuH5BvG9BEuHzJ33U7iCwAsHS344aqg2uyWPMg9gM/HGE037QFiRsoGF8VSdAzC5HRJthbmoBZgTzDJMyvRwoRulMq58fVIB0jSZNtPXO+fxgwRa9xKWcqX4EAVABIcx9lKT4IH2SMMK2jFgkJnUnfd5Uof78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aGS/PVls; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aGS/PVls"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08DA0C4CEF0;
	Sun,  7 Sep 2025 20:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277471;
	bh=5jqmBrGWjeqgLSYfDH0U5NsidLnC2BaWgmcNC1PtMEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aGS/PVlspEw9QUiFXqoC6tB+JzF6jCHd+RStfWj49D6Fc1MwcWpaCC8kZWhmR8O67
	 XN9MN+Gz+hH2OCs+MFBM1T32WAJwoPb3pc+TMz0nUzsAhcFctSR1W7gVYVv7WSBuPj
	 +51reZfFldrAMjiydfcgPYau582+1nhJJl8UTh+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hanlu Li <lihanlu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 008/183] LoongArch: Save LBT before FPU in setup_sigcontext()
Date: Sun,  7 Sep 2025 21:57:15 +0200
Message-ID: <20250907195615.993854673@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

[ Upstream commit 112ca94f6c3b3e0b2002a240de43c487a33e0234 ]

Now if preemption happens between protected_save_fpu_context() and
protected_save_lbt_context(), FTOP context is lost. Because FTOP is
saved by protected_save_lbt_context() but protected_save_fpu_context()
disables TM before that. So save LBT before FPU in setup_sigcontext()
to avoid this potential risk.

Signed-off-by: Hanlu Li <lihanlu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kernel/signal.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/loongarch/kernel/signal.c b/arch/loongarch/kernel/signal.c
index 4740cb5b23889..c9f7ca778364e 100644
--- a/arch/loongarch/kernel/signal.c
+++ b/arch/loongarch/kernel/signal.c
@@ -677,6 +677,11 @@ static int setup_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
 	for (i = 1; i < 32; i++)
 		err |= __put_user(regs->regs[i], &sc->sc_regs[i]);
 
+#ifdef CONFIG_CPU_HAS_LBT
+	if (extctx->lbt.addr)
+		err |= protected_save_lbt_context(extctx);
+#endif
+
 	if (extctx->lasx.addr)
 		err |= protected_save_lasx_context(extctx);
 	else if (extctx->lsx.addr)
@@ -684,11 +689,6 @@ static int setup_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
 	else if (extctx->fpu.addr)
 		err |= protected_save_fpu_context(extctx);
 
-#ifdef CONFIG_CPU_HAS_LBT
-	if (extctx->lbt.addr)
-		err |= protected_save_lbt_context(extctx);
-#endif
-
 	/* Set the "end" magic */
 	info = (struct sctx_info *)extctx->end.addr;
 	err |= __put_user(0, &info->magic);
-- 
2.50.1



