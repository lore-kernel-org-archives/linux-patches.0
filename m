Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA1943AD539;
	Wed, 30 Sep 2026 18:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793303; cv=none; b=NPMNIXBZz3w1RvodvNaHrunmVxWX4O7eN4R9k5e7McNC+HhhGaG/Pgee7aw+KX64aLUslTshibkTbVWEpdE8O83iOz4PXUd3tDi21sCT5FPmhPEAHPEn24g+vrswZp3VmWOPBNcq2/TriL//xPGj3ZpvLHPz8OxFqOolK43zhE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793303; c=relaxed/simple;
	bh=9SFRrXlv1NQiHbA6AlODlkoBh5aX5GAL83Hd2WqIjYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V4iBU24474TgsEBUPiSPfaJ6caWSAXH62sMQ6dWpdcdTtlhqrJ2Khs9GYvhd0b/zEvHH0nllXKDhCidniNz91MTdOwO/gvK0qejpLzgvBbWEUsCxzbvGL5uJJ0/nKYv3Amit+pWgSWI3YH0nR4h/VdnpWPuLFDkuiw4ff3aP6Xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UemxkGbA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UemxkGbA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A8D1F000FF;
	Wed, 30 Sep 2026 18:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793302;
	bh=33EQwm/vXUqz/6RsaXIL2EaU6MkaV633cAgLcYGObOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UemxkGbAzcg6sxzxGcKS1yEBsj7P78ZkyZa+WUtWZX8OB/qqrmvvJhXKDHhoPgU5r
	 Jaap1EWCb8ZDMbkjTIrgQD2wyIij8BJSPUgSz2WI0LlsgIOJYqBN0iBdA3UuehbhPv
	 ydZ+QdXxTg3uuwnysJ8iFDzwo7AoIIcQ2HtnHfDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	stable@kernel.org
Subject: [PATCH 6.18 206/395] x86/mce: Fix hardware debug register corruption on task migration
Date: Wed, 30 Sep 2026 17:27:48 +0200
Message-ID: <20260930152345.119224667@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit b8d1d5b63a8ef532038eebd9d97d406860385668 upstream.

In exc_machine_check_user(), local_db_save() and local_db_restore() are
invoked in the outer entry stubs (DEFINE_IDTENTRY_MCE_USER,
DEFINE_FREDENTRY_MCE, and DEFINE_IDTENTRY_RAW), surrounding
exc_machine_check_user().

However, exc_machine_check_user() calls irqentry_exit_to_user_mode(), which
handles pending thread work and may schedule() if TIF_NEED_RESCHED is set. If
the task migrates to another CPU during schedule(), local_db_restore() runs on
the new CPU with the dr7 state saved from the old CPU. This corrupts the new
CPU's DR7 hardware debug register and leaves the old CPU's DR7 disabled.  In
short, local_db_save() and local_db_restore() pair must be run on the same
CPU.

To fix this, move local_db_save() and local_db_restore() inside
exc_machine_check_user() and exc_machine_check_kernel(). In
exc_machine_check_user(), DR7 is saved and restored strictly around
do_machine_check() to avoid schedule() during migration. In
exc_machine_check_kernel(), local_db_save() is called at the entry point to
prevent early memory accesses from triggering nested #DB exceptions, and
restored on all exits.

Fixes: cd840e424f27 ("x86/entry, mce: Disallow #DB during #MC")
Assisted-by: LLM
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: <stable@kernel.org>
Link: https://patch.msgid.link/179005109564.388919.3937970081044095776.stgit@devnote2
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/mce/core.c |   27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -2078,6 +2078,9 @@ bool filter_mce(struct mce *m)
 static __always_inline void exc_machine_check_kernel(struct pt_regs *regs)
 {
 	irqentry_state_t irq_state;
+	unsigned long dr7;
+
+	dr7 = local_db_save();
 
 	WARN_ON_ONCE(user_mode(regs));
 
@@ -2086,20 +2089,26 @@ static __always_inline void exc_machine_
 	 * mce_check_crashing_cpu() for details.
 	 */
 	if (mca_cfg.initialized && mce_check_crashing_cpu())
-		return;
+		goto out;
 
 	irq_state = irqentry_nmi_enter(regs);
 
 	do_machine_check(regs);
 
 	irqentry_nmi_exit(regs, irq_state);
+out:
+	local_db_restore(dr7);
 }
 
 static __always_inline void exc_machine_check_user(struct pt_regs *regs)
 {
+	unsigned long dr7;
+
 	irqentry_enter_from_user_mode(regs);
 
+	dr7 = local_db_save();
 	do_machine_check(regs);
+	local_db_restore(dr7);
 
 	irqentry_exit_to_user_mode(regs);
 }
@@ -2108,21 +2117,13 @@ static __always_inline void exc_machine_
 /* MCE hit kernel mode */
 DEFINE_IDTENTRY_MCE(exc_machine_check)
 {
-	unsigned long dr7;
-
-	dr7 = local_db_save();
 	exc_machine_check_kernel(regs);
-	local_db_restore(dr7);
 }
 
 /* The user mode variant. */
 DEFINE_IDTENTRY_MCE_USER(exc_machine_check)
 {
-	unsigned long dr7;
-
-	dr7 = local_db_save();
 	exc_machine_check_user(regs);
-	local_db_restore(dr7);
 }
 
 #ifdef CONFIG_X86_FRED
@@ -2139,28 +2140,20 @@ DEFINE_IDTENTRY_MCE_USER(exc_machine_che
  */
 DEFINE_FREDENTRY_MCE(exc_machine_check)
 {
-	unsigned long dr7;
-
-	dr7 = local_db_save();
 	if (user_mode(regs))
 		exc_machine_check_user(regs);
 	else
 		exc_machine_check_kernel(regs);
-	local_db_restore(dr7);
 }
 #endif
 #else
 /* 32bit unified entry point */
 DEFINE_IDTENTRY_RAW(exc_machine_check)
 {
-	unsigned long dr7;
-
-	dr7 = local_db_save();
 	if (user_mode(regs))
 		exc_machine_check_user(regs);
 	else
 		exc_machine_check_kernel(regs);
-	local_db_restore(dr7);
 }
 #endif
 


