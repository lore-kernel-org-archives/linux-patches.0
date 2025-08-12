Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E1118FC91;
	Tue, 12 Aug 2025 18:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022312; cv=none; b=K4BUiHe/3QDDYz1aOor9u15UiGY8daA6gXgQg99mI2P5Pog4uAz2dHEWDDFJEyALLjC27N/9xeOldjkl6bQegpghm00Kg1ECz4WRoT/yO9p2ndsZb4XcC0p5htMiaW3C3jL4Ms+dsDUz30hfrD4Xaq9wgKUJKCnuJAm7r7NZzHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022312; c=relaxed/simple;
	bh=KIJjS0lKWz+fCMRsiYoynwh7V3DLSnxgKKnzlBEfnjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qKPPJ89Wr/yiEMS1igGYn9NTJgiVQrfc3gW1m8DV9hdCPzp9DXLiuk1R1wUoqQjJCHn3sGCy47k9kNbfOCuoNKROnTjBkP820s0ILKpPob3VwalPL20i7U9e+KFYp4ygfZCAenOKI3CLrt4YQ0zbJiLhHjHr0C3WjBtftFGk80Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H2Dp2qJS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H2Dp2qJS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77DF7C4CEF7;
	Tue, 12 Aug 2025 18:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022311;
	bh=KIJjS0lKWz+fCMRsiYoynwh7V3DLSnxgKKnzlBEfnjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H2Dp2qJS/1ta639DMPp0ptGvA3SKsh70RiTzNcXeKxEQI6kIlnzG/NbQwOJqoFh0H
	 MpihGAQj4whuX8al/jqe3E7tFCeOh8cH53woNvHJBrObl4XOSQXroGcFaCiFjTi6Sk
	 OYWyyLyj/5UynrkAk+b9pkucjEdbDYE2V/Tc95VE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Murad Masimov <m.masimov@mt-integration.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 119/369] wifi: plfxlc: Fix error handling in usb driver probe
Date: Tue, 12 Aug 2025 19:26:56 +0200
Message-ID: <20250812173019.242475128@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 82d1bf7edba2..a7f5d287e369 100644
--- a/drivers/net/wireless/purelifi/plfxlc/mac.c
+++ b/drivers/net/wireless/purelifi/plfxlc/mac.c
@@ -99,11 +99,6 @@ int plfxlc_mac_init_hw(struct ieee80211_hw *hw)
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
@@ -755,3 +750,9 @@ struct ieee80211_hw *plfxlc_mac_alloc_hw(struct usb_interface *intf)
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
index 9384acddcf26..56da502999c1 100644
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
index 7e7bfa532ed2..966a9e211963 100644
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



