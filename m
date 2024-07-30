Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A15B8154C18;
	Tue, 30 Jul 2024 17:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360618; cv=none; b=eFjYLd7juZ32codOqWPHvY9cAbxw+RA7SO5jOb30sKe22svfh7enQDbkWUejDXD4+VschD3HYY9otQqyLIEUiOMnvaJmkwHMprq1Exj5V/qOONii2HCPuTm8HIg1wd5l7RB7pIfdPNqQsETSNcELLuVi6KukIuGXHuWnRnwK1dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360618; c=relaxed/simple;
	bh=fiVwnd19z3NjR0UpBVgFG7FQOHxSwCHU7DR+8+bWEwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oUJIZr/1cg9zQS7q6afYjLZKxFUjQYBY0X6Ny3IAPpgO6r+8HCjNmN4V0uOvlKLr6MmcVHbwEub1IXvzxqcwgupmtzxrCcRHrM/xO324H+XH8pTIfqajKhCvGL5F0PF5hkuxZ0yg5JeC60413OqZByhkg4rnlMg1X21UUcRvh6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MIIn/wVG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MIIn/wVG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BDC0C32782;
	Tue, 30 Jul 2024 17:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360618;
	bh=fiVwnd19z3NjR0UpBVgFG7FQOHxSwCHU7DR+8+bWEwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MIIn/wVGulZl3QqXQAoZ+q1v8vzKwbb8AVG9lHRFifDwdCbwvr5OMjR1jn3+5EbM0
	 XJYPW7qyqmz80z84qZifgK2XKjxuPb6mNIjKQLeItF/nVJ+BiciSJF1hYEKP7J2D5o
	 sjfPzZ5U0qebbesuKNX5T1613M5XpvWzwuTd1rbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.10 727/809] MIPS: Loongson64: reset: Prioritise firmware service
Date: Tue, 30 Jul 2024 17:50:03 +0200
Message-ID: <20240730151753.653362355@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
 
 #ifdef CONFIG_KEXEC_CORE
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
 
 #ifdef CONFIG_KEXEC_CORE
 	kexec_argv = kmalloc(KEXEC_ARGV_SIZE, GFP_KERNEL);


