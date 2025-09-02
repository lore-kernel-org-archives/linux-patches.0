Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95729304BA4;
	Tue,  2 Sep 2025 13:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819648; cv=none; b=HB0gPGmkjsxxTLg4pwTmApVkhpX4bgc46DLcIMYOFb+9/hMOf+a0CjMIVX3X/V4U0hqA5QDyVLi8NEFPzK4LOgnxHR73nhPb7rKdm16TqlHez5p5ERUZAQHB2R47+C3v4rQJ9YLjdNdcV6lOiMfZt+/v0/katgQ124Is/SwZUT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819648; c=relaxed/simple;
	bh=dgAZaGge23ID4Gtqih21ViQmaJsxqTkW/rTUI3Z+NJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iFN9VE2Y22p6ZXhcUrneBcMfn4E+hn9k8fABQCbh7skoQAXXbqghqDkTR4HLerpuqMyZC2sWcKb294k8Kly9iaZZ1TPb/N7bowRpMCq3Pwz97OD4KRlmzGWoFu8h0WPUZE5f+i/M9xSESne++wsy4wvslSEpLkzbKtaffoI7GOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SVoRAHWG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SVoRAHWG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 035BCC4CEED;
	Tue,  2 Sep 2025 13:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819648;
	bh=dgAZaGge23ID4Gtqih21ViQmaJsxqTkW/rTUI3Z+NJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SVoRAHWG+rNW0MqTrVRhGRlebbROdb06CACSH+3y7LiaYoIU1ThBJp52KOJoNCo8L
	 KZe/snKGIKyO842kmzHnNd8jKISsrqwrSuZxFOFEHfe29BdwNgZPvMS/fhm5XNXfuz
	 XzmOZnXt4hrINibU3oAVNsCkyz7UyETUvPTaVOzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Riabchun <ferr.lambarginio@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 066/142] mISDN: hfcpci: Fix warning when deleting uninitialized timer
Date: Tue,  2 Sep 2025 15:19:28 +0200
Message-ID: <20250902131950.787512902@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

From: Vladimir Riabchun <ferr.lambarginio@gmail.com>

[ Upstream commit 97766512a9951b9fd6fc97f1b93211642bb0b220 ]

With CONFIG_DEBUG_OBJECTS_TIMERS unloading hfcpci module leads
to the following splat:

[  250.215892] ODEBUG: assert_init not available (active state 0) object: ffffffffc01a3dc0 object type: timer_list hint: 0x0
[  250.217520] WARNING: CPU: 0 PID: 233 at lib/debugobjects.c:612 debug_print_object+0x1b6/0x2c0
[  250.218775] Modules linked in: hfcpci(-) mISDN_core
[  250.219537] CPU: 0 UID: 0 PID: 233 Comm: rmmod Not tainted 6.17.0-rc2-g6f713187ac98 #2 PREEMPT(voluntary)
[  250.220940] Hardware name: QEMU Ubuntu 24.04 PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[  250.222377] RIP: 0010:debug_print_object+0x1b6/0x2c0
[  250.223131] Code: fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 75 4f 41 56 48 8b 14 dd a0 4e 01 9f 48 89 ee 48 c7 c7 20 46 01 9f e8 cb 84d
[  250.225805] RSP: 0018:ffff888015ea7c08 EFLAGS: 00010286
[  250.226608] RAX: 0000000000000000 RBX: 0000000000000005 RCX: ffffffff9be93a95
[  250.227708] RDX: 1ffff1100d945138 RSI: 0000000000000008 RDI: ffff88806ca289c0
[  250.228993] RBP: ffffffff9f014a00 R08: 0000000000000001 R09: ffffed1002bd4f39
[  250.230043] R10: ffff888015ea79cf R11: 0000000000000001 R12: 0000000000000001
[  250.231185] R13: ffffffff9eea0520 R14: 0000000000000000 R15: ffff888015ea7cc8
[  250.232454] FS:  00007f3208f01540(0000) GS:ffff8880caf5a000(0000) knlGS:0000000000000000
[  250.233851] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  250.234856] CR2: 00007f32090a7421 CR3: 0000000004d63000 CR4: 00000000000006f0
[  250.236117] Call Trace:
[  250.236599]  <TASK>
[  250.236967]  ? trace_irq_enable.constprop.0+0xd4/0x130
[  250.237920]  debug_object_assert_init+0x1f6/0x310
[  250.238762]  ? __pfx_debug_object_assert_init+0x10/0x10
[  250.239658]  ? __lock_acquire+0xdea/0x1c70
[  250.240369]  __try_to_del_timer_sync+0x69/0x140
[  250.241172]  ? __pfx___try_to_del_timer_sync+0x10/0x10
[  250.242058]  ? __timer_delete_sync+0xc6/0x120
[  250.242842]  ? lock_acquire+0x30/0x80
[  250.243474]  ? __timer_delete_sync+0xc6/0x120
[  250.244262]  __timer_delete_sync+0x98/0x120
[  250.245015]  HFC_cleanup+0x10/0x20 [hfcpci]
[  250.245704]  __do_sys_delete_module+0x348/0x510
[  250.246461]  ? __pfx___do_sys_delete_module+0x10/0x10
[  250.247338]  do_syscall_64+0xc1/0x360
[  250.247924]  entry_SYSCALL_64_after_hwframe+0x77/0x7f

Fix this by initializing hfc_tl timer with DEFINE_TIMER macro.
Also, use mod_timer instead of manual timeout update.

Fixes: 87c5fa1bb426 ("mISDN: Add different different timer settings for hfc-pci")
Fixes: 175302f6b79e ("mISDN: hfcpci: Fix use-after-free bug in hfcpci_softirq")
Signed-off-by: Vladimir Riabchun <ferr.lambarginio@gmail.com>
Link: https://patch.msgid.link/aKiy2D_LiWpQ5kXq@vova-pc
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/isdn/hardware/mISDN/hfcpci.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcpci.c b/drivers/isdn/hardware/mISDN/hfcpci.c
index 2b05722d4dbe8..ea8a0ab47afd8 100644
--- a/drivers/isdn/hardware/mISDN/hfcpci.c
+++ b/drivers/isdn/hardware/mISDN/hfcpci.c
@@ -39,12 +39,13 @@
 
 #include "hfc_pci.h"
 
+static void hfcpci_softirq(struct timer_list *unused);
 static const char *hfcpci_revision = "2.0";
 
 static int HFC_cnt;
 static uint debug;
 static uint poll, tics;
-static struct timer_list hfc_tl;
+static DEFINE_TIMER(hfc_tl, hfcpci_softirq);
 static unsigned long hfc_jiffies;
 
 MODULE_AUTHOR("Karsten Keil");
@@ -2305,8 +2306,7 @@ hfcpci_softirq(struct timer_list *unused)
 		hfc_jiffies = jiffies + 1;
 	else
 		hfc_jiffies += tics;
-	hfc_tl.expires = hfc_jiffies;
-	add_timer(&hfc_tl);
+	mod_timer(&hfc_tl, hfc_jiffies);
 }
 
 static int __init
@@ -2332,10 +2332,8 @@ HFC_init(void)
 	if (poll != HFCPCI_BTRANS_THRESHOLD) {
 		printk(KERN_INFO "%s: Using alternative poll value of %d\n",
 		       __func__, poll);
-		timer_setup(&hfc_tl, hfcpci_softirq, 0);
-		hfc_tl.expires = jiffies + tics;
-		hfc_jiffies = hfc_tl.expires;
-		add_timer(&hfc_tl);
+		hfc_jiffies = jiffies + tics;
+		mod_timer(&hfc_tl, hfc_jiffies);
 	} else
 		tics = 0; /* indicate the use of controller's timer */
 
-- 
2.50.1



