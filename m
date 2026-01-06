Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A353587DA;
	Tue,  6 Jan 2026 17:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721540; cv=none; b=MckgYEfPaR+y1AFg0ttvEB3u1goc/C0laFKKCxQyb4QUfCmp64R6BAFXKFvZ5OZeVohhlG4Ku9H+MbVZ/oePd4GlztrcZBcBRrg8ZtMHc2Q9ntB/MrNsem7F3ng6fGZ8lM+ZMHoj2w9ZfxKaUSDOQOd1k4fQfqDxSKOopFCW8MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721540; c=relaxed/simple;
	bh=3KPkF0nfD8NmX24I30ToKbOZExnfGnoENM6AI0r+GVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DOwVi/H4pI/RaaPZS0PYi+7LM5REsBPbxk7F8eqNDHhegkxzkEhUEJrkln/a7WU7g5G2ZHFo1dweGo+IOu6sr4Wk3Db5bqlB3U3EGd61UIoi4Avr2XDveFYoN8hrr+Ell13jjQRqYQkzcym1065hAb8YDKJlaprCamO1txU+ODU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yfAsMYf1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yfAsMYf1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A67DBC16AAE;
	Tue,  6 Jan 2026 17:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721540;
	bh=3KPkF0nfD8NmX24I30ToKbOZExnfGnoENM6AI0r+GVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yfAsMYf1Z3Ap/par2Zjj3cz7e9z/j24UcOJmtVh4Dcw105zRyGhhkSErQntEcDdV0
	 RJEIXdKmWJ2pu93rLPvYNv2Sc2GvfGDwbnXTbnfsFaJTyfb9hAid/gkf8TvdsqoPrb
	 s1UFGnyWuqe7icDZ9Pc1GuF1eU1LlSv3Sp5dO+HU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quan Zhou <quan.zhou@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Jan Kiszka <jan.kiszka@siemens.com>
Subject: [PATCH 6.12 534/567] wifi: mt76: mt7925: fix the unfinished command of regd_notifier before suspend
Date: Tue,  6 Jan 2026 18:05:16 +0100
Message-ID: <20260106170511.151675023@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quan Zhou <quan.zhou@mediatek.com>

[ Upstream commit 1b97fc8443aea01922560de9f24a6383e6eb6ae8 ]

Before entering suspend, we need to ensure that all MCU command are
completed. In some cases, such as with regd_notifier, there is a
chance that CLC commands, will be executed before suspend.

Signed-off-by: Quan Zhou <quan.zhou@mediatek.com>
Link: https://patch.msgid.link/3af7b4e5bf7437832b016e32743657d1d55b1f9d.1735910288.git.quan.zhou@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/init.c |    4 ++++
 drivers/net/wireless/mediatek/mt76/mt7925/pci.c  |    3 +++
 2 files changed, 7 insertions(+)

--- a/drivers/net/wireless/mediatek/mt76/mt7925/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/init.c
@@ -81,11 +81,14 @@ mt7925_regd_notifier(struct wiphy *wiphy
 	mdev->region = req->dfs_region;
 	dev->country_ie_env = req->country_ie_env;
 
+	dev->regd_in_progress = true;
 	mt792x_mutex_acquire(dev);
 	mt7925_mcu_set_clc(dev, req->alpha2, req->country_ie_env);
 	mt7925_mcu_set_channel_domain(hw->priv);
 	mt7925_set_tx_sar_pwr(hw, NULL);
 	mt792x_mutex_release(dev);
+	dev->regd_in_progress = false;
+	wake_up(&dev->wait);
 }
 
 static void mt7925_mac_init_basic_rates(struct mt792x_dev *dev)
@@ -235,6 +238,7 @@ int mt7925_register_device(struct mt792x
 	spin_lock_init(&dev->pm.wake.lock);
 	mutex_init(&dev->pm.mutex);
 	init_waitqueue_head(&dev->pm.wait);
+	init_waitqueue_head(&dev->wait);
 	spin_lock_init(&dev->pm.txq_lock);
 	INIT_DELAYED_WORK(&dev->mphy.mac_work, mt792x_mac_work);
 	INIT_DELAYED_WORK(&dev->phy.scan_work, mt7925_scan_work);
--- a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
@@ -455,6 +455,9 @@ static int mt7925_pci_suspend(struct dev
 	if (err < 0)
 		goto restore_suspend;
 
+	wait_event_timeout(dev->wait,
+			   !dev->regd_in_progress, 5 * HZ);
+
 	/* always enable deep sleep during suspend to reduce
 	 * power consumption
 	 */


