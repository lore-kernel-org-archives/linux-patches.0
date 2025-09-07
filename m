Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F91189BB0;
	Sun,  7 Sep 2025 20:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276601; cv=none; b=O/UjdQZV56ruV6w2GRhNddAbxoRJcVPLDXSPbWdSY0qALGbt+V0MUE1KKKrjix1C3di4WrUuG2mxVLeQKBFDzUWAqIQl0uswOtbeAN3jCJHRMwOxpnFpfspzfgOmIj/kTMPEOfnwb5dy/hlhS7Unq5tObixA37sStKHWzVhY2NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276601; c=relaxed/simple;
	bh=YvjT7sXF/aTkFIVoZ1f48iVZzMDD9PgV/kbidwehzE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F6ugZ/VTgxPzMPPFhTosTq3rYjgrRqpcAgBgJMJF66kFPTDz7MOky8TysUVyPgM0wDHCSqtiYpeGCtDpUqElhimvaXFyf9CXQMtxHxk6p3AXCFW9K/HRAxxLyKidcVQ1ZGOcS8//VSQbXG9Ef9OABnc4dz8Xm44nJ9owwXi7axk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C/GK3J2o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C/GK3J2o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB29EC4CEF0;
	Sun,  7 Sep 2025 20:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276601;
	bh=YvjT7sXF/aTkFIVoZ1f48iVZzMDD9PgV/kbidwehzE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C/GK3J2oB88Gjv+oqPNnMP49VMYeaZ3vCyByV4EsPiGwZP0j5YT63cS+VuOF41jpf
	 +muzlvn7bmiyNHKxaZ06urHVMmIVwmqNCVihrraR1WLWg2d/Uo4kee2tfxcN1XRlXB
	 G8fgCOISno6c80FiAW33O5HIqGFC6aPPn5B1Ly4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hanlu Li <lihanlu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 008/121] LoongArch: Save LBT before FPU in setup_sigcontext()
Date: Sun,  7 Sep 2025 21:57:24 +0200
Message-ID: <20250907195610.029338010@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4a3686d133494..0e90cd2df0ea3 100644
--- a/arch/loongarch/kernel/signal.c
+++ b/arch/loongarch/kernel/signal.c
@@ -697,6 +697,11 @@ static int setup_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
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
@@ -704,11 +709,6 @@ static int setup_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
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



