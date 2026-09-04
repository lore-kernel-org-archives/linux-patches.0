Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 699C941A517;
	Fri,  4 Sep 2026 05:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499475; cv=none; b=aviMfqaOF7ivFykohJ3LuNcfGp54NBWU2sDieBNZWNb2sPVFvzSFpbqGsJ2TR3b9RrbQpMjCsUegZYzFNwoEcCirNtTScCHXQhvJym7hRlb4oWq6+GsbMexuzhrcu0ZhHoCxxPKevt+JTyeBySn+kzx5NsOQHJxu/H8YJe2vr64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499475; c=relaxed/simple;
	bh=tLv/J7LdB169sf7IIDZbkADhKnrMOCUzmBD/bauu5bo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dvwRNs9pgGUmonXVfxUshS+v/db3N9tRKKWNcW8OUuyf64di3ZIX1ZzQ8qgATYMRrTcD52FfdDjFACB99o/yN4IM4O7qidBWMd4Trb8TKEIdkRiZpUldmScZo3bB7nhJTGVxC/tlhGkHAwcbPQpRsoGRJyEP5eUODThd3a+t7Io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L0hkJCnQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L0hkJCnQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E0881F00A3D;
	Fri,  4 Sep 2026 05:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499474;
	bh=nd9hAUi0GMp8Q9XE6l1lFFXo8rL7x/kJy2Ebzut+qRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L0hkJCnQB970nLBqKH6k60hl8ZRzHfiz9pieuV4p88dzxpeQlhC7HgkLufp94yg8v
	 9IY5lHlZGyBaXS8w/Qr7rgxXbKfkaZhyUXbFQwXGJ0ABYwO8aAKpGDEiVcd6i345sl
	 ukaWQAHpRR/DTz5pklQv23xNtysEpkhwdhGFD7JI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Guan <guanwentao@uniontech.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 7.2 403/713] wifi: mt76: mt7925: cancel pending mlo_pm_work
Date: Fri,  4 Sep 2026 06:56:11 +0200
Message-ID: <20260904045812.857361491@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Guan <guanwentao@uniontech.com>

commit 2889e84282dda147f10b10d94cf0efd90a349c53 upstream.

If the device is reset, suspended or unregistered within that window,
the pending work can still run and access vif/bss data that may already
be freed, or send MCU commands while the firmware is not available.

Add cancel_delayed_work_sync(&dev->mlo_pm_work) in all relevant teardown
and suspend paths:

 - mt7925_mac_reset_work()        (chip reset recovery)
 - mt7925e_unregister_device()    (PCIe unbind)
 - mt7925_pci_suspend()           (PCIe bus suspend)
 - mt7925_suspend()               (mac80211 suspend)
 - mt7925u_suspend()              (USB bus / runtime suspend)

This ensures the work is stopped before the device state becomes
invalid.

Assisted-by: kimi-cli:kimi-k2.7 code
Assisted-by: atomcode:glm-5.2 #Reported-by

Fixes: 276a568832577 ("wifi: mt76: mt7925: update the power-saving flow")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Link: https://patch.msgid.link/20260630090218.3202029-1-guanwentao@uniontech.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mac.c  |    1 +
 drivers/net/wireless/mediatek/mt76/mt7925/main.c |    1 +
 drivers/net/wireless/mediatek/mt76/mt7925/pci.c  |    2 ++
 drivers/net/wireless/mediatek/mt76/mt7925/usb.c  |    1 +
 4 files changed, 5 insertions(+)

--- a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
@@ -1323,6 +1323,7 @@ void mt7925_mac_reset_work(struct work_s
 
 	cancel_delayed_work_sync(&dev->mphy.mac_work);
 	cancel_delayed_work_sync(&pm->ps_work);
+	cancel_delayed_work_sync(&dev->mlo_pm_work);
 	cancel_work_sync(&pm->wake_work);
 
 	for (i = 0; i < 10; i++) {
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -1640,6 +1640,7 @@ static int mt7925_suspend(struct ieee802
 	cancel_delayed_work_sync(&phy->mt76->mac_work);
 
 	cancel_delayed_work_sync(&dev->pm.ps_work);
+	cancel_delayed_work_sync(&dev->mlo_pm_work);
 	mt76_connac_free_pending_tx_skbs(&dev->pm, NULL);
 
 	mt792x_mutex_acquire(dev);
--- a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
@@ -48,6 +48,7 @@ static void mt7925e_unregister_device(st
 	mt76_for_each_q_rx(&dev->mt76, i)
 		napi_disable(&dev->mt76.napi[i]);
 	cancel_delayed_work_sync(&pm->ps_work);
+	cancel_delayed_work_sync(&dev->mlo_pm_work);
 	cancel_work_sync(&pm->wake_work);
 	cancel_work_sync(&dev->reset_work);
 
@@ -517,6 +518,7 @@ static int mt7925_pci_suspend(struct dev
 	dev->hif_resumed = false;
 	flush_work(&dev->reset_work);
 	cancel_delayed_work_sync(&pm->ps_work);
+	cancel_delayed_work_sync(&dev->mlo_pm_work);
 	cancel_work_sync(&pm->wake_work);
 
 	mt7925_roc_abort_sync(dev);
--- a/drivers/net/wireless/mediatek/mt76/mt7925/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/usb.c
@@ -269,6 +269,7 @@ static int mt7925u_suspend(struct usb_in
 	pm->suspended = true;
 	dev->hif_resumed = false;
 	flush_work(&dev->reset_work);
+	cancel_delayed_work_sync(&dev->mlo_pm_work);
 
 	mt76_connac_mcu_set_hif_suspend(&dev->mt76, true, false);
 	ret = wait_event_timeout(dev->wait,


