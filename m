Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C6E514A087;
	Tue, 25 Jun 2024 09:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309392; cv=none; b=C6P+usKP9+rJphelDCSxY3Gx5baBo3Qoggyjkn4ligp/ckKlhfnvZEHL5Ti8x8bOdmnLlN67wej9yDpmwjpAXFwBD8SEZGAfWm6Ea1qRw+SMFVn4RS8vRVm8DO/QRiXdnnG92Rph9Eix8oc9oxnxOA9+oI/78FETDK6wztozDsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309392; c=relaxed/simple;
	bh=5dbo6xFq9DCSziE4KxWGOFl8k4HJu3Wh7LqAGZ4UMBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J6xgb2T+nC3cjkRWUrZkIbA6BXnwCB/8BpBsNVwJSQEtAd44lVibN4haSC6dQ/rNgQhCVKirR7/USmtr2n/t2Djyi7R7+ap/i1kANXhoKLjk9qiDoJhnGEfs0uJPSsv1O1lWHwfvffBTLG9PTbsbLrL3W3Ef/nZ1bexg4x6/Yq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QahF4tSm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QahF4tSm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 965BBC32781;
	Tue, 25 Jun 2024 09:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309392;
	bh=5dbo6xFq9DCSziE4KxWGOFl8k4HJu3Wh7LqAGZ4UMBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QahF4tSmkgCv2eZF5MCmz6D2vhzAAyn8rUqfsYSrc1kg3AWzttFzz/XjGR0ZbhVuM
	 W8mds80nOX/kzIRlkzL3PLnWQMWUMdBHxQ8pjgPW8dDgfROTmDoXAykjFndBVwVtnD
	 6c73Qck/9nJ6+kx3RB+pYHBR+3FoW0QOm0fp+bkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Martinez Canillas <javierm@redhat.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Khalid Aziz <khalid@gonehiking.org>,
	Helge Deller <deller@gmx.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 183/192] vgacon: rework screen_info #ifdef checks
Date: Tue, 25 Jun 2024 11:34:15 +0200
Message-ID: <20240625085544.185461833@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 8a736ddfc861b2a217c935c2f461a8004add8247 ]

On non-x86 architectures, the screen_info variable is generally only
used for the VGA console where supported, and in some cases the EFI
framebuffer or vga16fb.

Now that we have a definite list of which architectures actually use it
for what, use consistent #ifdef checks so the global variable is only
defined when it is actually used on those architectures.

Loongarch and riscv have no support for vgacon or vga16fb, but
they support EFI firmware, so only that needs to be checked, and the
initialization can be removed because that is handled by EFI.
IA64 has both vgacon and EFI, though EFI apparently never uses
a framebuffer here.

Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Khalid Aziz <khalid@gonehiking.org>
Acked-by: Helge Deller <deller@gmx.de>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20231009211845.3136536-3-arnd@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: beb2800074c1 ("LoongArch: Fix entry point in kernel image header")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/kernel/setup.c      |  2 ++
 arch/alpha/kernel/sys_sio.c    |  2 ++
 arch/ia64/kernel/setup.c       |  6 ++++++
 arch/loongarch/kernel/setup.c  |  2 ++
 arch/mips/kernel/setup.c       |  2 +-
 arch/mips/sibyte/swarm/setup.c |  2 +-
 arch/mips/sni/setup.c          |  2 +-
 arch/riscv/kernel/setup.c      | 11 ++---------
 8 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/arch/alpha/kernel/setup.c b/arch/alpha/kernel/setup.c
index c80258ec332ff..85a679ce061c2 100644
--- a/arch/alpha/kernel/setup.c
+++ b/arch/alpha/kernel/setup.c
@@ -131,6 +131,7 @@ static void determine_cpu_caches (unsigned int);
 
 static char __initdata command_line[COMMAND_LINE_SIZE];
 
+#ifdef CONFIG_VGA_CONSOLE
 /*
  * The format of "screen_info" is strange, and due to early
  * i386-setup code. This is just enough to make the console
@@ -147,6 +148,7 @@ struct screen_info screen_info = {
 };
 
 EXPORT_SYMBOL(screen_info);
+#endif
 
 /*
  * The direct map I/O window, if any.  This should be the same
diff --git a/arch/alpha/kernel/sys_sio.c b/arch/alpha/kernel/sys_sio.c
index 7c420d8dac53d..7de8a5d2d2066 100644
--- a/arch/alpha/kernel/sys_sio.c
+++ b/arch/alpha/kernel/sys_sio.c
@@ -57,11 +57,13 @@ sio_init_irq(void)
 static inline void __init
 alphabook1_init_arch(void)
 {
+#ifdef CONFIG_VGA_CONSOLE
 	/* The AlphaBook1 has LCD video fixed at 800x600,
 	   37 rows and 100 cols. */
 	screen_info.orig_y = 37;
 	screen_info.orig_video_cols = 100;
 	screen_info.orig_video_lines = 37;
+#endif
 
 	lca_init_arch();
 }
diff --git a/arch/ia64/kernel/setup.c b/arch/ia64/kernel/setup.c
index 5a55ac82c13a4..d2c66efdde560 100644
--- a/arch/ia64/kernel/setup.c
+++ b/arch/ia64/kernel/setup.c
@@ -86,9 +86,13 @@ EXPORT_SYMBOL(local_per_cpu_offset);
 #endif
 unsigned long ia64_cycles_per_usec;
 struct ia64_boot_param *ia64_boot_param;
+#if defined(CONFIG_VGA_CONSOLE) || defined(CONFIG_EFI)
 struct screen_info screen_info;
+#endif
+#ifdef CONFIG_VGA_CONSOLE
 unsigned long vga_console_iobase;
 unsigned long vga_console_membase;
+#endif
 
 static struct resource data_resource = {
 	.name	= "Kernel data",
@@ -497,6 +501,7 @@ early_console_setup (char *cmdline)
 static void __init
 screen_info_setup(void)
 {
+#ifdef CONFIG_VGA_CONSOLE
 	unsigned int orig_x, orig_y, num_cols, num_rows, font_height;
 
 	memset(&screen_info, 0, sizeof(screen_info));
@@ -525,6 +530,7 @@ screen_info_setup(void)
 	screen_info.orig_video_mode = 3;	/* XXX fake */
 	screen_info.orig_video_isVGA = 1;	/* XXX fake */
 	screen_info.orig_video_ega_bx = 3;	/* XXX fake */
+#endif
 }
 
 static inline void
diff --git a/arch/loongarch/kernel/setup.c b/arch/loongarch/kernel/setup.c
index d7409a3e67a53..6748d7f3f2219 100644
--- a/arch/loongarch/kernel/setup.c
+++ b/arch/loongarch/kernel/setup.c
@@ -57,7 +57,9 @@
 #define SMBIOS_CORE_PACKAGE_OFFSET	0x23
 #define LOONGSON_EFI_ENABLE		(1 << 3)
 
+#ifdef CONFIG_EFI
 struct screen_info screen_info __section(".data");
+#endif
 
 unsigned long fw_arg0, fw_arg1, fw_arg2;
 DEFINE_PER_CPU(unsigned long, kernelsp);
diff --git a/arch/mips/kernel/setup.c b/arch/mips/kernel/setup.c
index f88a2f83c5eac..3f45b72561db9 100644
--- a/arch/mips/kernel/setup.c
+++ b/arch/mips/kernel/setup.c
@@ -54,7 +54,7 @@ struct cpuinfo_mips cpu_data[NR_CPUS] __read_mostly;
 
 EXPORT_SYMBOL(cpu_data);
 
-#ifdef CONFIG_VT
+#ifdef CONFIG_VGA_CONSOLE
 struct screen_info screen_info;
 #endif
 
diff --git a/arch/mips/sibyte/swarm/setup.c b/arch/mips/sibyte/swarm/setup.c
index 76683993cdd3a..37df504d3ecbb 100644
--- a/arch/mips/sibyte/swarm/setup.c
+++ b/arch/mips/sibyte/swarm/setup.c
@@ -129,7 +129,7 @@ void __init plat_mem_setup(void)
 	if (m41t81_probe())
 		swarm_rtc_type = RTC_M41T81;
 
-#ifdef CONFIG_VT
+#ifdef CONFIG_VGA_CONSOLE
 	screen_info = (struct screen_info) {
 		.orig_video_page	= 52,
 		.orig_video_mode	= 3,
diff --git a/arch/mips/sni/setup.c b/arch/mips/sni/setup.c
index efad85c8c823b..9984cf91be7d0 100644
--- a/arch/mips/sni/setup.c
+++ b/arch/mips/sni/setup.c
@@ -38,7 +38,7 @@ extern void sni_machine_power_off(void);
 
 static void __init sni_display_setup(void)
 {
-#if defined(CONFIG_VT) && defined(CONFIG_VGA_CONSOLE) && defined(CONFIG_FW_ARC)
+#if defined(CONFIG_VGA_CONSOLE) && defined(CONFIG_FW_ARC)
 	struct screen_info *si = &screen_info;
 	DISPLAY_STATUS *di;
 
diff --git a/arch/riscv/kernel/setup.c b/arch/riscv/kernel/setup.c
index e600aab116a40..ddadee6621f0d 100644
--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -40,15 +40,8 @@
 
 #include "head.h"
 
-#if defined(CONFIG_DUMMY_CONSOLE) || defined(CONFIG_EFI)
-struct screen_info screen_info __section(".data") = {
-	.orig_video_lines	= 30,
-	.orig_video_cols	= 80,
-	.orig_video_mode	= 0,
-	.orig_video_ega_bx	= 0,
-	.orig_video_isVGA	= 1,
-	.orig_video_points	= 8
-};
+#if defined(CONFIG_EFI)
+struct screen_info screen_info __section(".data");
 #endif
 
 /*
-- 
2.43.0



