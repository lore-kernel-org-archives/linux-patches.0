Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E6C18801A;
	Tue, 30 Jul 2024 16:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358322; cv=none; b=gnLitc5Tl6QjhUgZJVfzIok+yhsDpI9dnRB4a03hM6cT2ZXQu/YS8GG8QljaxNyhGNiSXjNJUOjBONGicUrvYYtITYNeTAB25kD1hjbmWAy0TH1IH30XwgPvjjruKA7TulDdSMp/fIyRsTgukliUpv5ZH/md2KCzywD4EOEN1k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358322; c=relaxed/simple;
	bh=NdXxuRrX2TzKEchvMEhBMbOi2oC3W0qutnQ+jI7kov0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BxRmjYjhTbD85Cf4o7RrhBVpJ4IVbPhqJZnCMwKAmYWMKbymvhTV7qZotOIei7cFwx99l5j4sSg1v7uzH2MyuZ2IfT+WYcvC0nu8OVph7OZSJT533rhxkTMdyOR2InhH8Z8jAL04FkBlzYepw/gEZfMCR83l5sQjVXwB5Uek9fY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y87qDs12; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y87qDs12"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC4E9C32782;
	Tue, 30 Jul 2024 16:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358322;
	bh=NdXxuRrX2TzKEchvMEhBMbOi2oC3W0qutnQ+jI7kov0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y87qDs123wp7p+/qlWfee3XNMq4Lsh9yKbkUloYvfF5IRAa4pjNFlMgmhubZ8asWs
	 nPu2O0Mj8ULet7pR6ieBCLPdG8T9mB7rhLiS2WX9y74FhIRSf6D7BBSxzasgBpxUvA
	 +OLZFj0dJjiiNS0po9dDv3pfBhh+psgJzoSl2IVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.1 377/440] MIPS: Loongson64: reset: Prioritise firmware service
Date: Tue, 30 Jul 2024 17:50:10 +0200
Message-ID: <20240730151630.536569987@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

commit 4e7ca0b57f3bc09ba3e4ab86bf6b7c35134bfd04 upstream.

We should always use firmware's poweroff & reboot service
if it's available as firmware may need to perform more task
than platform's syscon etc.

However _machine_restart & poweroff hooks are registered at
low priority, which means platform reboot driver can override
them.

Register firmware based reboot/poweroff implementation with
register_sys_off_handler with appropriate priority so that
they will be prioritised. Remove _machine_halt hook as it's
deemed to be unnecessary.

Cc: stable@vger.kernel.org
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/loongson64/reset.c |   38 ++++++++++++++++----------------------
 1 file changed, 16 insertions(+), 22 deletions(-)

--- a/arch/mips/loongson64/reset.c
+++ b/arch/mips/loongson64/reset.c
@@ -11,6 +11,7 @@
 #include <linux/init.h>
 #include <linux/kexec.h>
 #include <linux/pm.h>
+#include <linux/reboot.h>
 #include <linux/slab.h>
 
 #include <asm/bootinfo.h>
@@ -21,36 +22,21 @@
 #include <loongson.h>
 #include <boot_param.h>
 
-static void loongson_restart(char *command)
+static int firmware_restart(struct sys_off_data *unusedd)
 {
 
 	void (*fw_restart)(void) = (void *)loongson_sysconf.restart_addr;
 
 	fw_restart();
-	while (1) {
-		if (cpu_wait)
-			cpu_wait();
-	}
+	return NOTIFY_DONE;
 }
 
-static void loongson_poweroff(void)
+static int firmware_poweroff(struct sys_off_data *unused)
 {
 	void (*fw_poweroff)(void) = (void *)loongson_sysconf.poweroff_addr;
 
 	fw_poweroff();
-	while (1) {
-		if (cpu_wait)
-			cpu_wait();
-	}
-}
-
-static void loongson_halt(void)
-{
-	pr_notice("\n\n** You can safely turn off the power now **\n\n");
-	while (1) {
-		if (cpu_wait)
-			cpu_wait();
-	}
+	return NOTIFY_DONE;
 }
 
 #ifdef CONFIG_KEXEC
@@ -154,9 +140,17 @@ static void loongson_crash_shutdown(stru
 
 static int __init mips_reboot_setup(void)
 {
-	_machine_restart = loongson_restart;
-	_machine_halt = loongson_halt;
-	pm_power_off = loongson_poweroff;
+	if (loongson_sysconf.restart_addr) {
+		register_sys_off_handler(SYS_OFF_MODE_RESTART,
+				 SYS_OFF_PRIO_FIRMWARE,
+				 firmware_restart, NULL);
+	}
+
+	if (loongson_sysconf.poweroff_addr) {
+		register_sys_off_handler(SYS_OFF_MODE_POWER_OFF,
+				 SYS_OFF_PRIO_FIRMWARE,
+				 firmware_poweroff, NULL);
+	}
 
 #ifdef CONFIG_KEXEC
 	kexec_argv = kmalloc(KEXEC_ARGV_SIZE, GFP_KERNEL);


