Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0063826AC1;
	Sun,  1 Sep 2024 17:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210411; cv=none; b=jPd3my7/lXmevIywauwtYzOu3mklfBppxIEbXKw8gALGU8oc9EzDKiV3W462PSeFJqd4UgeeMu9N3gJCcoSSNlnT6zDym1EmWBSat86yma5x8h8kq9149773lmECN9PRiaJ7GnxNlyxiFD6ekXdMgz9I42hVlH8rN6BKvZy/0y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210411; c=relaxed/simple;
	bh=7hvAP1NyfyCLHlA+Y1kCh2j4MjFToy75/S2ooaYLrm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tFT8a+10t3EVyB9gsPlkWjynzmwOu15gjlGUNRRdgu+MfCdPtJfDPPfoj4G6kRZuwBlJDi1kAJ81Bp04HufMI6BZZELtmJitRO8sP/LNodc9JiVMfGo+FISeQgJHXf3B02wljnxVSzfC3ep9vgpbMQgMXdIkn9Avsu/w/kJrE6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mdotIHr8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mdotIHr8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69BE5C4CEC3;
	Sun,  1 Sep 2024 17:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210410;
	bh=7hvAP1NyfyCLHlA+Y1kCh2j4MjFToy75/S2ooaYLrm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mdotIHr8XLOreZsHHX82bL5Kw/0Gd9dhBLPi/tcNiUsFpQAy/hQag8GzoAsbQ+BAz
	 DXSlhXlRg5UO6ytWlHD+mx0PIPiHzRFVk2iwpnh2GYZcp+eriU7drcGZLkr5xJ7uUG
	 ng537uBzhorhnutnCQSR775aXOK68xiI0tUL1q6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.15 182/215] Revert "MIPS: Loongson64: reset: Prioritise firmware service"
Date: Sun,  1 Sep 2024 18:18:14 +0200
Message-ID: <20240901160830.239694708@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 77011a1d7a1a973d1657d06b658ce20f94172827 which is
commit 4e7ca0b57f3bc09ba3e4ab86bf6b7c35134bfd04 upstream.

Turns out to break the 5.15.y build, it should not have been backported
that far.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Link: https://lore.kernel.org/r/135ef4fd-4fc9-40b4-b188-8e64946f47c4@roeck-us.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/loongson64/reset.c |   38 ++++++++++++++++++++++----------------
 1 file changed, 22 insertions(+), 16 deletions(-)

--- a/arch/mips/loongson64/reset.c
+++ b/arch/mips/loongson64/reset.c
@@ -11,7 +11,6 @@
 #include <linux/init.h>
 #include <linux/kexec.h>
 #include <linux/pm.h>
-#include <linux/reboot.h>
 #include <linux/slab.h>
 
 #include <asm/bootinfo.h>
@@ -22,21 +21,36 @@
 #include <loongson.h>
 #include <boot_param.h>
 
-static int firmware_restart(struct sys_off_data *unusedd)
+static void loongson_restart(char *command)
 {
 
 	void (*fw_restart)(void) = (void *)loongson_sysconf.restart_addr;
 
 	fw_restart();
-	return NOTIFY_DONE;
+	while (1) {
+		if (cpu_wait)
+			cpu_wait();
+	}
 }
 
-static int firmware_poweroff(struct sys_off_data *unused)
+static void loongson_poweroff(void)
 {
 	void (*fw_poweroff)(void) = (void *)loongson_sysconf.poweroff_addr;
 
 	fw_poweroff();
-	return NOTIFY_DONE;
+	while (1) {
+		if (cpu_wait)
+			cpu_wait();
+	}
+}
+
+static void loongson_halt(void)
+{
+	pr_notice("\n\n** You can safely turn off the power now **\n\n");
+	while (1) {
+		if (cpu_wait)
+			cpu_wait();
+	}
 }
 
 #ifdef CONFIG_KEXEC
@@ -140,17 +154,9 @@ static void loongson_crash_shutdown(stru
 
 static int __init mips_reboot_setup(void)
 {
-	if (loongson_sysconf.restart_addr) {
-		register_sys_off_handler(SYS_OFF_MODE_RESTART,
-				 SYS_OFF_PRIO_FIRMWARE,
-				 firmware_restart, NULL);
-	}
-
-	if (loongson_sysconf.poweroff_addr) {
-		register_sys_off_handler(SYS_OFF_MODE_POWER_OFF,
-				 SYS_OFF_PRIO_FIRMWARE,
-				 firmware_poweroff, NULL);
-	}
+	_machine_restart = loongson_restart;
+	_machine_halt = loongson_halt;
+	pm_power_off = loongson_poweroff;
 
 #ifdef CONFIG_KEXEC
 	kexec_argv = kmalloc(KEXEC_ARGV_SIZE, GFP_KERNEL);


