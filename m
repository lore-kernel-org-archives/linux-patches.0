Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B621791F4;
	Mon,  6 Jan 2025 15:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177039; cv=none; b=u1wsXEo6lPBbCbhD8qRQ277xKGaWSHVDx6B/kG9WzFVXMvq8DDnhHx126RD173dhyvM4f0PD4RSREgYrITjI3Ml8wolKBQFwIjd/TuiJD4YioHXDAiwjEySS4d1yv61JpCoChZzVlLBEcoD+dV7RRnoUQfiSG/QPgg+zbvRGZYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177039; c=relaxed/simple;
	bh=Didsm0UOqtTvJiYl/CuuDFoqTRnqnl/KDeFH4w7i4FE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JT7bBr2v5lABc9kyM+uZ+hhLEv6iDlwgMrJRKJh+dFpr8VaTGcP2rSQK9WwAVpUSiybS9NQ09kGtEGaR0ZQ1u7Mcz9FFAWKpXEDIu3r7eXe//ad5Psei1v2ZbQOFcAN3M+MsKVHIXaL7Aa7r2caRXDewTXHpqyu1QVEt0Yj78lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pSVuMN3O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pSVuMN3O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0D9BC4CED2;
	Mon,  6 Jan 2025 15:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177039;
	bh=Didsm0UOqtTvJiYl/CuuDFoqTRnqnl/KDeFH4w7i4FE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pSVuMN3OLHOgmlkxk1qEOEx8uNmSZq75J2unb4wS4otHFI6fx+CfjBu6v5Z9sG1F+
	 33gegii/3flN6BKet6DWIN0UuIEU8+Azyr2uMpMka92ZS1yKxWTveR83i6+B2/3+1h
	 yyY0y8fgwwcp45hRrAgxRbpwXNKBtDGPBGtomf+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Robinson <pbrobinson@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 031/222] wifi: rtw88: use ieee80211_purge_tx_queue() to purge TX skb
Date: Mon,  6 Jan 2025 16:13:55 +0100
Message-ID: <20250106151151.780538115@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit 3e5e4a801aaf4283390cc34959c6c48f910ca5ea ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/sdio.c | 6 +++---
 drivers/net/wireless/realtek/rtw88/usb.c  | 5 +++--
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/sdio.c b/drivers/net/wireless/realtek/rtw88/sdio.c
index 0cae5746f540..5bd1ee81210d 100644
--- a/drivers/net/wireless/realtek/rtw88/sdio.c
+++ b/drivers/net/wireless/realtek/rtw88/sdio.c
@@ -1295,12 +1295,12 @@ static void rtw_sdio_deinit_tx(struct rtw_dev *rtwdev)
 	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
 	int i;
 
-	for (i = 0; i < RTK_MAX_TX_QUEUE_NUM; i++)
-		skb_queue_purge(&rtwsdio->tx_queue[i]);
-
 	flush_workqueue(rtwsdio->txwq);
 	destroy_workqueue(rtwsdio->txwq);
 	kfree(rtwsdio->tx_handler_data);
+
+	for (i = 0; i < RTK_MAX_TX_QUEUE_NUM; i++)
+		ieee80211_purge_tx_queue(rtwdev->hw, &rtwsdio->tx_queue[i]);
 }
 
 int rtw_sdio_probe(struct sdio_func *sdio_func,
diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wireless/realtek/rtw88/usb.c
index 04a64afcbf8a..8f1d653282b7 100644
--- a/drivers/net/wireless/realtek/rtw88/usb.c
+++ b/drivers/net/wireless/realtek/rtw88/usb.c
@@ -416,10 +416,11 @@ static void rtw_usb_tx_handler(struct work_struct *work)
 
 static void rtw_usb_tx_queue_purge(struct rtw_usb *rtwusb)
 {
+	struct rtw_dev *rtwdev = rtwusb->rtwdev;
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(rtwusb->tx_queue); i++)
-		skb_queue_purge(&rtwusb->tx_queue[i]);
+		ieee80211_purge_tx_queue(rtwdev->hw, &rtwusb->tx_queue[i]);
 }
 
 static void rtw_usb_write_port_complete(struct urb *urb)
@@ -801,9 +802,9 @@ static void rtw_usb_deinit_tx(struct rtw_dev *rtwdev)
 {
 	struct rtw_usb *rtwusb = rtw_get_usb_priv(rtwdev);
 
-	rtw_usb_tx_queue_purge(rtwusb);
 	flush_workqueue(rtwusb->txwq);
 	destroy_workqueue(rtwusb->txwq);
+	rtw_usb_tx_queue_purge(rtwusb);
 }
 
 static int rtw_usb_intf_init(struct rtw_dev *rtwdev,
-- 
2.39.5



