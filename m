Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C86BF2D5C76;
	Tue, 12 Aug 2025 17:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021247; cv=none; b=Z+FjL9E38j8cFcDfh+WYJxWWoUqq2AKis6vEFqn7YNVqLDHQfoXsRAE7jIO/npno3WwUktKAHw5C5afKyUZ1LYs4CbgsFsCYzsz1uxY0cMNYdiCR84X/Nia280IxHTDqAqrd06rKifXQmf87S18AySzqn0aiNMbnahGmyzV/D/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021247; c=relaxed/simple;
	bh=WCirwuGTV4+dCB/BO3DlkBUSG/1WfeYFsc9rTvcUv8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A/4Xur1ZefO6qfqRE/xtrms0YTCrqhAF+RLy2poj3Y9bbh02gRzs5AA5XEAnQCPE+ZF3QKUoeAC9ozUfZenSFUYV0O8IVQj/LysCyM2t0P5BmyULfA5zXRm8g3g6HfquDTUFZ0zXKbsBTClMx66twekX2v/Qcm5wmEsCWSBRsWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zU9a4uML; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zU9a4uML"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 385EAC4CEF0;
	Tue, 12 Aug 2025 17:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021247;
	bh=WCirwuGTV4+dCB/BO3DlkBUSG/1WfeYFsc9rTvcUv8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zU9a4uMLdUJFEa5N/z16Tt3Wt5uSDNLZSFNG6oyK3IMWVH47ugsWpAZp8IyF7n1uZ
	 Kq+eR2c0RdSDqwQFBdRc3/kQ7DK588zf+TDrWQ2AvwzCa2JPTGuDeI2DqlAukccvob
	 ujB7dZl2P0ziG001ZWMceyj3OGCQ5hn7jJA5gjJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Murad Masimov <m.masimov@mt-integration.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 083/262] wifi: plfxlc: Fix error handling in usb driver probe
Date: Tue, 12 Aug 2025 19:27:51 +0200
Message-ID: <20250812172956.579270452@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

From: Murad Masimov <m.masimov@mt-integration.ru>

[ Upstream commit 3fe79a25c3cd54d25d30bc235c0c57f8a123d9d5 ]

If probe fails before ieee80211_register_hw() is successfully done,
ieee80211_unregister_hw() will be called anyway. This may lead to various
bugs as the implementation of ieee80211_unregister_hw() assumes that
ieee80211_register_hw() has been called.

Divide error handling section into relevant subsections, so that
ieee80211_unregister_hw() is called only when it is appropriate. Correct
the order of the calls: ieee80211_unregister_hw() should go before
plfxlc_mac_release(). Also move ieee80211_free_hw() to plfxlc_mac_release()
as it supposed to be the opposite to plfxlc_mac_alloc_hw() that calls
ieee80211_alloc_hw().

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: 68d57a07bfe5 ("wireless: add plfxlc driver for pureLiFi X, XL, XC devices")
Signed-off-by: Murad Masimov <m.masimov@mt-integration.ru>
Link: https://patch.msgid.link/20250321185226.71-3-m.masimov@mt-integration.ru
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/purelifi/plfxlc/mac.c | 11 ++++----
 drivers/net/wireless/purelifi/plfxlc/mac.h |  2 +-
 drivers/net/wireless/purelifi/plfxlc/usb.c | 29 +++++++++++-----------
 3 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/purelifi/plfxlc/mac.c b/drivers/net/wireless/purelifi/plfxlc/mac.c
index 7ebc0df0944c..f9f7532c32fd 100644
--- a/drivers/net/wireless/purelifi/plfxlc/mac.c
+++ b/drivers/net/wireless/purelifi/plfxlc/mac.c
@@ -100,11 +100,6 @@ int plfxlc_mac_init_hw(struct ieee80211_hw *hw)
 	return r;
 }
 
-void plfxlc_mac_release(struct plfxlc_mac *mac)
-{
-	plfxlc_chip_release(&mac->chip);
-}
-
 int plfxlc_op_start(struct ieee80211_hw *hw)
 {
 	plfxlc_hw_mac(hw)->chip.usb.initialized = 1;
@@ -752,3 +747,9 @@ struct ieee80211_hw *plfxlc_mac_alloc_hw(struct usb_interface *intf)
 	SET_IEEE80211_DEV(hw, &intf->dev);
 	return hw;
 }
+
+void plfxlc_mac_release_hw(struct ieee80211_hw *hw)
+{
+	plfxlc_chip_release(&plfxlc_hw_mac(hw)->chip);
+	ieee80211_free_hw(hw);
+}
diff --git a/drivers/net/wireless/purelifi/plfxlc/mac.h b/drivers/net/wireless/purelifi/plfxlc/mac.h
index 49b92413729b..c0445932b2e8 100644
--- a/drivers/net/wireless/purelifi/plfxlc/mac.h
+++ b/drivers/net/wireless/purelifi/plfxlc/mac.h
@@ -168,7 +168,7 @@ static inline u8 *plfxlc_mac_get_perm_addr(struct plfxlc_mac *mac)
 }
 
 struct ieee80211_hw *plfxlc_mac_alloc_hw(struct usb_interface *intf);
-void plfxlc_mac_release(struct plfxlc_mac *mac);
+void plfxlc_mac_release_hw(struct ieee80211_hw *hw);
 
 int plfxlc_mac_preinit_hw(struct ieee80211_hw *hw, const u8 *hw_address);
 int plfxlc_mac_init_hw(struct ieee80211_hw *hw);
diff --git a/drivers/net/wireless/purelifi/plfxlc/usb.c b/drivers/net/wireless/purelifi/plfxlc/usb.c
index 8151bc5e00cc..901e0139969e 100644
--- a/drivers/net/wireless/purelifi/plfxlc/usb.c
+++ b/drivers/net/wireless/purelifi/plfxlc/usb.c
@@ -604,7 +604,7 @@ static int probe(struct usb_interface *intf,
 	r = plfxlc_upload_mac_and_serial(intf, hw_address, serial_number);
 	if (r) {
 		dev_err(&intf->dev, "MAC and Serial upload failed (%d)\n", r);
-		goto error;
+		goto error_free_hw;
 	}
 
 	chip->unit_type = STA;
@@ -613,13 +613,13 @@ static int probe(struct usb_interface *intf,
 	r = plfxlc_mac_preinit_hw(hw, hw_address);
 	if (r) {
 		dev_err(&intf->dev, "Init mac failed (%d)\n", r);
-		goto error;
+		goto error_free_hw;
 	}
 
 	r = ieee80211_register_hw(hw);
 	if (r) {
 		dev_err(&intf->dev, "Register device failed (%d)\n", r);
-		goto error;
+		goto error_free_hw;
 	}
 
 	if ((le16_to_cpu(interface_to_usbdev(intf)->descriptor.idVendor) ==
@@ -632,7 +632,7 @@ static int probe(struct usb_interface *intf,
 	}
 	if (r != 0) {
 		dev_err(&intf->dev, "FPGA download failed (%d)\n", r);
-		goto error;
+		goto error_unreg_hw;
 	}
 
 	tx->mac_fifo_full = 0;
@@ -642,21 +642,21 @@ static int probe(struct usb_interface *intf,
 	r = plfxlc_usb_init_hw(usb);
 	if (r < 0) {
 		dev_err(&intf->dev, "usb_init_hw failed (%d)\n", r);
-		goto error;
+		goto error_unreg_hw;
 	}
 
 	msleep(PLF_MSLEEP_TIME);
 	r = plfxlc_chip_switch_radio(chip, PLFXLC_RADIO_ON);
 	if (r < 0) {
 		dev_dbg(&intf->dev, "chip_switch_radio_on failed (%d)\n", r);
-		goto error;
+		goto error_unreg_hw;
 	}
 
 	msleep(PLF_MSLEEP_TIME);
 	r = plfxlc_chip_set_rate(chip, 8);
 	if (r < 0) {
 		dev_dbg(&intf->dev, "chip_set_rate failed (%d)\n", r);
-		goto error;
+		goto error_unreg_hw;
 	}
 
 	msleep(PLF_MSLEEP_TIME);
@@ -664,7 +664,7 @@ static int probe(struct usb_interface *intf,
 			    hw_address, ETH_ALEN, USB_REQ_MAC_WR);
 	if (r < 0) {
 		dev_dbg(&intf->dev, "MAC_WR failure (%d)\n", r);
-		goto error;
+		goto error_unreg_hw;
 	}
 
 	plfxlc_chip_enable_rxtx(chip);
@@ -691,12 +691,12 @@ static int probe(struct usb_interface *intf,
 	plfxlc_mac_init_hw(hw);
 	usb->initialized = true;
 	return 0;
+
+error_unreg_hw:
+	ieee80211_unregister_hw(hw);
+error_free_hw:
+	plfxlc_mac_release_hw(hw);
 error:
-	if (hw) {
-		plfxlc_mac_release(plfxlc_hw_mac(hw));
-		ieee80211_unregister_hw(hw);
-		ieee80211_free_hw(hw);
-	}
 	dev_err(&intf->dev, "pureLifi:Device error");
 	return r;
 }
@@ -730,8 +730,7 @@ static void disconnect(struct usb_interface *intf)
 	 */
 	usb_reset_device(interface_to_usbdev(intf));
 
-	plfxlc_mac_release(mac);
-	ieee80211_free_hw(hw);
+	plfxlc_mac_release_hw(hw);
 }
 
 static void plfxlc_usb_resume(struct plfxlc_usb *usb)
-- 
2.39.5



