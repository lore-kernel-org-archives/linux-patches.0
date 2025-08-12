Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AEAE26FA77;
	Tue, 12 Aug 2025 19:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025762; cv=none; b=bQs5uyE350GSCdKprkDryl4GLix9huFrars6rubaw8Pp93JzLO0cm3ujOqoYs4gPJtRD0Fl/2H+Gvh2xZPk6+e/Cc1qaieRcTssxYzbdf3Bea7wx/IxGn0M0vsYX63lSwMtzsGd7jXfNnAyN8uiookZLU9L5sDUFWzZlcgFlwWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025762; c=relaxed/simple;
	bh=V18m08pwqtrX23Qnv9GbBAQjnbFZZsOit9UkKMCeEB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s7ZXtJAdqx+cG66Fq0zcji/sjsLFjdvVeo8HkDHqfXhSdJWxuhaIPUb9vUP1pRpJhAU/ahPmE3z62UMP/tgsy7P/PSaOu2rOaBPT/YlObVNIczDexJrIYISjByyk8ZgzsB1h34+ukRi75PkZKEIzSQhbEP4Z6fl5dHpcVa+7Hxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DONRUTv3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DONRUTv3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC24BC4CEF0;
	Tue, 12 Aug 2025 19:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025762;
	bh=V18m08pwqtrX23Qnv9GbBAQjnbFZZsOit9UkKMCeEB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DONRUTv3GMBqJthrnUAA5lgeFuEhcK2ACOGMFQa9iWhKS1aiXZB/nBuPGetJayNro
	 iq1ZxXtr6iLfEOTSLCz9g31CBxCqExS/DC9ZPJfaME/GZ16Cuj+db+0HMn4UBESxeR
	 2mLSale12m5+EcWp4OKQcJZno9f4a9tbUGu/b/Ec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Palmer <daniel@0x0f.com>,
	Finn Thain <fthain@linux-m68k.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 136/480] m68k: Dont unregister boot console needlessly
Date: Tue, 12 Aug 2025 19:45:44 +0200
Message-ID: <20250812174403.136602808@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 30638a6e8edc..d036f903864c 100644
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
index 852255cf60de..ba22bc2f3d6d 100644
--- a/arch/m68k/kernel/head.S
+++ b/arch/m68k/kernel/head.S
@@ -3263,8 +3263,8 @@ func_return	putn
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
@@ -3273,8 +3273,8 @@ ENTRY(debug_cons_nputs)
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



