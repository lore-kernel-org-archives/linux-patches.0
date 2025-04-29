Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38847221D92;
	Tue, 29 Apr 2025 18:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949894; cv=none; b=YdVEr0+6btD5F194pYZwr3RGpqcPW62HJGvEEM/zoDv30ndO5cXOXutxNAZpjACpnZb6Fllns1iSf5JHcDV74r0u0W44kP2vE8JPQAEBYuIyd16NI//K/XOsNCr6JKD02PODk40VqbAoSLHvlYh1Nb+U+OA9jcG6lWZ8wmF8jmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949894; c=relaxed/simple;
	bh=oCBE3xGyo7b1r5IFcMxvdLPtdPKjwVPERuMtpUCPKMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oN1PiT+hBUZAcimb6OEI7wVcHimi2HWevC/a/HOUe88/NkeWe6bfPPvl6GUwnts5j5YsSMEusYSvEaSawex77fGzlZQ+h3EiMrfW2Oinl0t4wE/JODIZrv9yo/2kA+03g3O47KzY1oRlF9P81cxQLKUJ6kFpHvjFxboFIOQ1R6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cgMo93qW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cgMo93qW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CF41C4CEE3;
	Tue, 29 Apr 2025 18:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949894;
	bh=oCBE3xGyo7b1r5IFcMxvdLPtdPKjwVPERuMtpUCPKMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cgMo93qWWs3i4RleNKwqYF8CvingAK6qU5VTQV2G0Se8oLMDhSo4bcf0631/3xfjz
	 0OIdJdoT7nSAmd143m0PxjN32taqgHNe0Hv5HKyh1FfwjAX7gHd2Gt51WHX/cZsnht
	 b7ZA8TUEcRnd3fskPvpW5t6e86oxvYCAI227C/0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Robinson <pbrobinson@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Ladislav Michl <ladis@triops.cz>
Subject: [PATCH 6.1 061/167] wifi: rtw88: use ieee80211_purge_tx_queue() to purge TX skb
Date: Tue, 29 Apr 2025 18:42:49 +0200
Message-ID: <20250429161054.240292255@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ping-Ke Shih <pkshih@realtek.com>

commit 3e5e4a801aaf4283390cc34959c6c48f910ca5ea upstream.

When removing kernel modules by:
   rmmod rtw88_8723cs rtw88_8703b rtw88_8723x rtw88_sdio rtw88_core

Driver uses skb_queue_purge() to purge TX skb, but not report tx status
causing "Have pending ack frames!" warning. Use ieee80211_purge_tx_queue()
to correct this.

Since ieee80211_purge_tx_queue() doesn't take locks, to prevent racing
between TX work and purge TX queue, flush and destroy TX work in advance.

   wlan0: deauthenticating from aa:f5:fd:60:4c:a8 by local
     choice (Reason: 3=DEAUTH_LEAVING)
   ------------[ cut here ]------------
   Have pending ack frames!
   WARNING: CPU: 3 PID: 9232 at net/mac80211/main.c:1691
       ieee80211_free_ack_frame+0x5c/0x90 [mac80211]
   CPU: 3 PID: 9232 Comm: rmmod Tainted: G         C
       6.10.1-200.fc40.aarch64 #1
   Hardware name: pine64 Pine64 PinePhone Braveheart
      (1.1)/Pine64 PinePhone Braveheart (1.1), BIOS 2024.01 01/01/2024
   pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
   pc : ieee80211_free_ack_frame+0x5c/0x90 [mac80211]
   lr : ieee80211_free_ack_frame+0x5c/0x90 [mac80211]
   sp : ffff80008c1b37b0
   x29: ffff80008c1b37b0 x28: ffff000003be8000 x27: 0000000000000000
   x26: 0000000000000000 x25: ffff000003dc14b8 x24: ffff80008c1b37d0
   x23: ffff000000ff9f80 x22: 0000000000000000 x21: 000000007fffffff
   x20: ffff80007c7e93d8 x19: ffff00006e66f400 x18: 0000000000000000
   x17: ffff7ffffd2b3000 x16: ffff800083fc0000 x15: 0000000000000000
   x14: 0000000000000000 x13: 2173656d61726620 x12: 6b636120676e6964
   x11: 0000000000000000 x10: 000000000000005d x9 : ffff8000802af2b0
   x8 : ffff80008c1b3430 x7 : 0000000000000001 x6 : 0000000000000001
   x5 : 0000000000000000 x4 : 0000000000000000 x3 : 0000000000000000
   x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff000003be8000
   Call trace:
    ieee80211_free_ack_frame+0x5c/0x90 [mac80211]
    idr_for_each+0x74/0x110
    ieee80211_free_hw+0x44/0xe8 [mac80211]
    rtw_sdio_remove+0x9c/0xc0 [rtw88_sdio]
    sdio_bus_remove+0x44/0x180
    device_remove+0x54/0x90
    device_release_driver_internal+0x1d4/0x238
    driver_detach+0x54/0xc0
    bus_remove_driver+0x78/0x108
    driver_unregister+0x38/0x78
    sdio_unregister_driver+0x2c/0x40
    rtw_8723cs_driver_exit+0x18/0x1000 [rtw88_8723cs]
    __do_sys_delete_module.isra.0+0x190/0x338
    __arm64_sys_delete_module+0x1c/0x30
    invoke_syscall+0x74/0x100
    el0_svc_common.constprop.0+0x48/0xf0
    do_el0_svc+0x24/0x38
    el0_svc+0x3c/0x158
    el0t_64_sync_handler+0x120/0x138
    el0t_64_sync+0x194/0x198
   ---[ end trace 0000000000000000 ]---

Reported-by: Peter Robinson <pbrobinson@gmail.com>
Closes: https://lore.kernel.org/linux-wireless/CALeDE9OAa56KMzgknaCD3quOgYuEHFx9_hcT=OFgmMAb+8MPyA@mail.gmail.com/
Tested-by: Ping-Ke Shih <pkshih@realtek.com> # 8723DU
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20240822014255.10211-2-pkshih@realtek.com
Signed-off-by: Ladislav Michl <ladis@triops.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtw88/main.c |    2 +-
 drivers/net/wireless/realtek/rtw88/tx.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -2146,7 +2146,7 @@ void rtw_core_deinit(struct rtw_dev *rtw
 
 	destroy_workqueue(rtwdev->tx_wq);
 	spin_lock_irqsave(&rtwdev->tx_report.q_lock, flags);
-	skb_queue_purge(&rtwdev->tx_report.queue);
+	ieee80211_purge_tx_queue(rtwdev->hw, &rtwdev->tx_report.queue);
 	skb_queue_purge(&rtwdev->coex.queue);
 	spin_unlock_irqrestore(&rtwdev->tx_report.q_lock, flags);
 
--- a/drivers/net/wireless/realtek/rtw88/tx.c
+++ b/drivers/net/wireless/realtek/rtw88/tx.c
@@ -169,7 +169,7 @@ void rtw_tx_report_purge_timer(struct ti
 	rtw_warn(rtwdev, "failed to get tx report from firmware\n");
 
 	spin_lock_irqsave(&tx_report->q_lock, flags);
-	skb_queue_purge(&tx_report->queue);
+	ieee80211_purge_tx_queue(rtwdev->hw, &tx_report->queue);
 	spin_unlock_irqrestore(&tx_report->q_lock, flags);
 }
 


