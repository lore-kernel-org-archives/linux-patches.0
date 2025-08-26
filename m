Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6CBC353368;
	Tue, 26 Aug 2025 14:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218676; cv=none; b=IhNMyAKNQgvBZ8RJthkuEPjf28pwX3Acg4ZJSJJ/1KwxB5pDrOtnu00QxHAaxLuojvhj6kZRRD79uXdvU+/TukPHpSgw7aeYLTINk48Zmoq2fqjTXQu7bHiMiZFv1mqwQYCfRgoEnhQU94syNIdWDXMmU7W2DED28O5eqU5KTxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218676; c=relaxed/simple;
	bh=VUgys3ckiuyf6wKH7ZW/GQp9afnOLSTBKvJVgVKY2bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MBEGsdqjtHt7JGyZiu+XkYc26KjzWWcyUBtx9s4NFShroY2QwOEgs9GvLOHdxvz7lxmY8zBJ9pBmmm0uGqdLDgWlU1leCWQj0ELkQn/OU630lVboFbcR0ZbqU6TvxIRIqy89m5Luocuexx7XhmZANmFyki526EiFlAYTEvJblMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zgXWRhAj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zgXWRhAj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BE8AC4CEF1;
	Tue, 26 Aug 2025 14:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218676;
	bh=VUgys3ckiuyf6wKH7ZW/GQp9afnOLSTBKvJVgVKY2bs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zgXWRhAjj1gusk/kKgzqnxCYs44EZlk/wLlWUM2KSBMdIPrDZiFnIxSKpbB9T0K1b
	 W1xFh5VNPXLwLHjoHcJ8bGBQ3kfkHai10V176np/h9aDUAyLPiQMivSq+ZWurBjStN
	 guIhlTiTBknpBTvUavhzAPkBPkdtb5kdKskxm/8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Palmer <daniel@0x0f.com>,
	Finn Thain <fthain@linux-m68k.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 091/403] m68k: Dont unregister boot console needlessly
Date: Tue, 26 Aug 2025 13:06:57 +0200
Message-ID: <20250826110909.181612722@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit 83f672a7f69ec38b1bbb27221e342937f68c11c7 ]

When MACH_IS_MVME147, the boot console calls mvme147_scc_write() to
generate console output. That will continue to work even after
debug_cons_nputs() becomes unavailable so there's no need to
unregister the boot console.

Take the opportunity to remove a repeated MACH_IS_* test. Use the
actual .write method (instead of a wrapper) and test that pointer
instead. This means adding an unused parameter to debug_cons_nputs() for
consistency with the struct console API.

early_printk.c is only built when CONFIG_EARLY_PRINTK=y. As of late,
head.S is only built when CONFIG_MMU_MOTOROLA=y. So let the former symbol
depend on the latter, to obviate some ifdef conditionals.

Cc: Daniel Palmer <daniel@0x0f.com>
Fixes: 077b33b9e283 ("m68k: mvme147: Reinstate early console")
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Link: https://lore.kernel.org/d1d4328e5aa9a87bd8352529ce62b767731c0530.1743467205.git.fthain@linux-m68k.org
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/Kconfig.debug         |  2 +-
 arch/m68k/kernel/early_printk.c | 42 +++++++++++----------------------
 arch/m68k/kernel/head.S         |  8 +++----
 3 files changed, 19 insertions(+), 33 deletions(-)

diff --git a/arch/m68k/Kconfig.debug b/arch/m68k/Kconfig.debug
index f43643111eaf..f9fa89ba259d 100644
--- a/arch/m68k/Kconfig.debug
+++ b/arch/m68k/Kconfig.debug
@@ -10,7 +10,7 @@ config BOOTPARAM_STRING
 
 config EARLY_PRINTK
 	bool "Early printk"
-	depends on !(SUN3 || M68000 || COLDFIRE)
+	depends on MMU_MOTOROLA
 	help
           Write kernel log output directly to a serial port.
           Where implemented, output goes to the framebuffer as well.
diff --git a/arch/m68k/kernel/early_printk.c b/arch/m68k/kernel/early_printk.c
index f11ef9f1f56f..521cbb8a150c 100644
--- a/arch/m68k/kernel/early_printk.c
+++ b/arch/m68k/kernel/early_printk.c
@@ -16,25 +16,10 @@
 #include "../mvme147/mvme147.h"
 #include "../mvme16x/mvme16x.h"
 
-asmlinkage void __init debug_cons_nputs(const char *s, unsigned n);
-
-static void __ref debug_cons_write(struct console *c,
-				   const char *s, unsigned n)
-{
-#if !(defined(CONFIG_SUN3) || defined(CONFIG_M68000) || \
-      defined(CONFIG_COLDFIRE))
-	if (MACH_IS_MVME147)
-		mvme147_scc_write(c, s, n);
-	else if (MACH_IS_MVME16x)
-		mvme16x_cons_write(c, s, n);
-	else
-		debug_cons_nputs(s, n);
-#endif
-}
+asmlinkage void __init debug_cons_nputs(struct console *c, const char *s, unsigned int n);
 
 static struct console early_console_instance = {
 	.name  = "debug",
-	.write = debug_cons_write,
 	.flags = CON_PRINTBUFFER | CON_BOOT,
 	.index = -1
 };
@@ -44,6 +29,12 @@ static int __init setup_early_printk(char *buf)
 	if (early_console || buf)
 		return 0;
 
+	if (MACH_IS_MVME147)
+		early_console_instance.write = mvme147_scc_write;
+	else if (MACH_IS_MVME16x)
+		early_console_instance.write = mvme16x_cons_write;
+	else
+		early_console_instance.write = debug_cons_nputs;
 	early_console = &early_console_instance;
 	register_console(early_console);
 
@@ -51,20 +42,15 @@ static int __init setup_early_printk(char *buf)
 }
 early_param("earlyprintk", setup_early_printk);
 
-/*
- * debug_cons_nputs() defined in arch/m68k/kernel/head.S cannot be called
- * after init sections are discarded (for platforms that use it).
- */
-#if !(defined(CONFIG_SUN3) || defined(CONFIG_M68000) || \
-      defined(CONFIG_COLDFIRE))
-
 static int __init unregister_early_console(void)
 {
-	if (!early_console || MACH_IS_MVME16x)
-		return 0;
+	/*
+	 * debug_cons_nputs() defined in arch/m68k/kernel/head.S cannot be
+	 * called after init sections are discarded (for platforms that use it).
+	 */
+	if (early_console && early_console->write == debug_cons_nputs)
+		return unregister_console(early_console);
 
-	return unregister_console(early_console);
+	return 0;
 }
 late_initcall(unregister_early_console);
-
-#endif
diff --git a/arch/m68k/kernel/head.S b/arch/m68k/kernel/head.S
index a54788458ca3..692cdcfb3520 100644
--- a/arch/m68k/kernel/head.S
+++ b/arch/m68k/kernel/head.S
@@ -3242,8 +3242,8 @@ func_return	putn
  *	turns around and calls the internal routines.  This routine
  *	is used by the boot console.
  *
- *	The calling parameters are:
- *		void debug_cons_nputs(const char *str, unsigned length)
+ *	The function signature is -
+ *		void debug_cons_nputs(struct console *c, const char *s, unsigned int n)
  *
  *	This routine does NOT understand variable arguments only
  *	simple strings!
@@ -3252,8 +3252,8 @@ ENTRY(debug_cons_nputs)
 	moveml	%d0/%d1/%a0,%sp@-
 	movew	%sr,%sp@-
 	ori	#0x0700,%sr
-	movel	%sp@(18),%a0		/* fetch parameter */
-	movel	%sp@(22),%d1		/* fetch parameter */
+	movel	%sp@(22),%a0		/* char *s */
+	movel	%sp@(26),%d1		/* unsigned int n */
 	jra	2f
 1:
 #ifdef CONSOLE_DEBUG
-- 
2.39.5



