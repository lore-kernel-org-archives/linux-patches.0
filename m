Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D4161C4EE6;
	Tue, 27 Aug 2024 15:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771315; cv=none; b=ZAEcetpkXxFKFZkBUAVtnryyXeWkHNoLlzQOwLw/idMXhEi4rd04FAPgdGQ6tAgiWeUd0iEWFPHrUZuMc98Y+YunNq8eDimeBwImOXWvhC3+XjEuytHOMvYR9iBrAojV11MNesMQHWx5ciDkIQpoTaNju9u/a9JkoEIqDmB4M9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771315; c=relaxed/simple;
	bh=BM06nNpE2dx7Zfno4zWRlaYwgIcqcrPcqn9WLvmLQtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hn4hC9+TVX9qad7I8e/VBZv6fvEN0qYRphQVnJKtBDxTMtmL/Vp5PnF93tYe5sCI5dBCxbVV6OWppjeCX9UL/C6dZqc7ESOqJUMqF+U3ZEne00764V9sJSjojRRnZaR5FgeaRK3FtpTN4c/o+uCpprjJKI4vIZU1jcUChWd+j+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h+825ees; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h+825ees"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5F52C61074;
	Tue, 27 Aug 2024 15:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771315;
	bh=BM06nNpE2dx7Zfno4zWRlaYwgIcqcrPcqn9WLvmLQtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h+825eesciYWv3dv/q9EKZvC1HpILfkQfNCPBBUlc7PDZrMTFdEKjXrKrsp9KmhQH
	 fmLYiueTYum2guRctUVCXCe1/ras+x3ZZDiwxnbX1C45huym3eBqWXED+KUQDXahwT
	 BG6azPupp4E38cH7aCKIhXhcquNYI8QnmYYsiR2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 151/273] Bluetooth: HCI: Invert LE State quirk to be opt-out rather then opt-in
Date: Tue, 27 Aug 2024 16:37:55 +0200
Message-ID: <20240827143839.150679498@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit aae6b81260fd9a7224f7eb4fc440d625852245bb ]

This inverts the LE State quirk so by default we assume the controllers
would report valid states rather than invalid which is how quirks
normally behave, also this would result in HCI command failing it the LE
States are really broken thus exposing the controllers that are really
broken in this respect.

Link: https://github.com/bluez/bluez/issues/584
Fixes: 220915857e29 ("Bluetooth: Adding driver and quirk defs for multi-role LE")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel.c      | 10 ----------
 drivers/bluetooth/btintel_pcie.c |  3 ---
 drivers/bluetooth/btmtksdio.c    |  3 ---
 drivers/bluetooth/btrtl.c        |  1 -
 drivers/bluetooth/btusb.c        |  4 ++--
 drivers/bluetooth/hci_qca.c      |  4 ++--
 drivers/bluetooth/hci_vhci.c     |  2 --
 include/net/bluetooth/hci.h      | 17 ++++++++++-------
 include/net/bluetooth/hci_core.h |  2 +-
 net/bluetooth/hci_event.c        |  2 +-
 10 files changed, 16 insertions(+), 32 deletions(-)

diff --git a/drivers/bluetooth/btintel.c b/drivers/bluetooth/btintel.c
index 93900c37349c1..c084dc88d3d91 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -2876,9 +2876,6 @@ static int btintel_setup_combined(struct hci_dev *hdev)
 					       INTEL_ROM_LEGACY_NO_WBS_SUPPORT))
 				set_bit(HCI_QUIRK_WIDEBAND_SPEECH_SUPPORTED,
 					&hdev->quirks);
-			if (ver.hw_variant == 0x08 && ver.fw_variant == 0x22)
-				set_bit(HCI_QUIRK_VALID_LE_STATES,
-					&hdev->quirks);
 
 			err = btintel_legacy_rom_setup(hdev, &ver);
 			break;
@@ -2887,7 +2884,6 @@ static int btintel_setup_combined(struct hci_dev *hdev)
 		case 0x12:      /* ThP */
 		case 0x13:      /* HrP */
 		case 0x14:      /* CcP */
-			set_bit(HCI_QUIRK_VALID_LE_STATES, &hdev->quirks);
 			fallthrough;
 		case 0x0c:	/* WsP */
 			/* Apply the device specific HCI quirks
@@ -2979,9 +2975,6 @@ static int btintel_setup_combined(struct hci_dev *hdev)
 		/* These variants don't seem to support LE Coded PHY */
 		set_bit(HCI_QUIRK_BROKEN_LE_CODED, &hdev->quirks);
 
-		/* Set Valid LE States quirk */
-		set_bit(HCI_QUIRK_VALID_LE_STATES, &hdev->quirks);
-
 		/* Setup MSFT Extension support */
 		btintel_set_msft_opcode(hdev, ver.hw_variant);
 
@@ -3003,9 +2996,6 @@ static int btintel_setup_combined(struct hci_dev *hdev)
 		 */
 		set_bit(HCI_QUIRK_WIDEBAND_SPEECH_SUPPORTED, &hdev->quirks);
 
-		/* Apply LE States quirk from solar onwards */
-		set_bit(HCI_QUIRK_VALID_LE_STATES, &hdev->quirks);
-
 		/* Setup MSFT Extension support */
 		btintel_set_msft_opcode(hdev,
 					INTEL_HW_VARIANT(ver_tlv.cnvi_bt));
diff --git a/drivers/bluetooth/btintel_pcie.c b/drivers/bluetooth/btintel_pcie.c
index b8120b98a2395..1fd3b7073ab90 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -1182,9 +1182,6 @@ static int btintel_pcie_setup(struct hci_dev *hdev)
 		 */
 		set_bit(HCI_QUIRK_WIDEBAND_SPEECH_SUPPORTED, &hdev->quirks);
 
-		/* Apply LE States quirk from solar onwards */
-		set_bit(HCI_QUIRK_VALID_LE_STATES, &hdev->quirks);
-
 		/* Setup MSFT Extension support */
 		btintel_set_msft_opcode(hdev,
 					INTEL_HW_VARIANT(ver_tlv.cnvi_bt));
diff --git a/drivers/bluetooth/btmtksdio.c b/drivers/bluetooth/btmtksdio.c
index 8ded9ef8089a2..bc4700ed3b782 100644
--- a/drivers/bluetooth/btmtksdio.c
+++ b/drivers/bluetooth/btmtksdio.c
@@ -1144,9 +1144,6 @@ static int btmtksdio_setup(struct hci_dev *hdev)
 			}
 		}
 
-		/* Valid LE States quirk for MediaTek 7921 */
-		set_bit(HCI_QUIRK_VALID_LE_STATES, &hdev->quirks);
-
 		break;
 	case 0x7663:
 	case 0x7668:
diff --git a/drivers/bluetooth/btrtl.c b/drivers/bluetooth/btrtl.c
index 4f1e37b4f7802..bfcb41a57655f 100644
--- a/drivers/bluetooth/btrtl.c
+++ b/drivers/bluetooth/btrtl.c
@@ -1287,7 +1287,6 @@ void btrtl_set_quirks(struct hci_dev *hdev, struct btrtl_device_info *btrtl_dev)
 	case CHIP_ID_8852C:
 	case CHIP_ID_8851B:
 	case CHIP_ID_8852BT:
-		set_bit(HCI_QUIRK_VALID_LE_STATES, &hdev->quirks);
 		set_bit(HCI_QUIRK_WIDEBAND_SPEECH_SUPPORTED, &hdev->quirks);
 
 		/* RTL8852C needs to transmit mSBC data continuously without
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 789c492df6fa2..0927f51867c26 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -4545,8 +4545,8 @@ static int btusb_probe(struct usb_interface *intf,
 	if (id->driver_info & BTUSB_WIDEBAND_SPEECH)
 		set_bit(HCI_QUIRK_WIDEBAND_SPEECH_SUPPORTED, &hdev->quirks);
 
-	if (id->driver_info & BTUSB_VALID_LE_STATES)
-		set_bit(HCI_QUIRK_VALID_LE_STATES, &hdev->quirks);
+	if (!(id->driver_info & BTUSB_VALID_LE_STATES))
+		set_bit(HCI_QUIRK_BROKEN_LE_STATES, &hdev->quirks);
 
 	if (id->driver_info & BTUSB_DIGIANSWER) {
 		data->cmdreq_type = USB_TYPE_VENDOR;
diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index 9a0bc86f9aace..34c36f0f781ea 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -2408,8 +2408,8 @@ static int qca_serdev_probe(struct serdev_device *serdev)
 			set_bit(HCI_QUIRK_WIDEBAND_SPEECH_SUPPORTED,
 				&hdev->quirks);
 
-		if (data->capabilities & QCA_CAP_VALID_LE_STATES)
-			set_bit(HCI_QUIRK_VALID_LE_STATES, &hdev->quirks);
+		if (!(data->capabilities & QCA_CAP_VALID_LE_STATES))
+			set_bit(HCI_QUIRK_BROKEN_LE_STATES, &hdev->quirks);
 	}
 
 	return 0;
diff --git a/drivers/bluetooth/hci_vhci.c b/drivers/bluetooth/hci_vhci.c
index 28750a40f0ed5..b652d68f0ee14 100644
--- a/drivers/bluetooth/hci_vhci.c
+++ b/drivers/bluetooth/hci_vhci.c
@@ -425,8 +425,6 @@ static int __vhci_create_device(struct vhci_data *data, __u8 opcode)
 	if (opcode & 0x80)
 		set_bit(HCI_QUIRK_RAW_DEVICE, &hdev->quirks);
 
-	set_bit(HCI_QUIRK_VALID_LE_STATES, &hdev->quirks);
-
 	if (hci_register_dev(hdev) < 0) {
 		BT_ERR("Can't register HCI device");
 		hci_free_dev(hdev);
diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index e372a88e8c3f6..d1d073089f384 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -206,14 +206,17 @@ enum {
 	 */
 	HCI_QUIRK_WIDEBAND_SPEECH_SUPPORTED,
 
-	/* When this quirk is set, the controller has validated that
-	 * LE states reported through the HCI_LE_READ_SUPPORTED_STATES are
-	 * valid.  This mechanism is necessary as many controllers have
-	 * been seen has having trouble initiating a connectable
-	 * advertisement despite the state combination being reported as
-	 * supported.
+	/* When this quirk is set, the LE states reported through the
+	 * HCI_LE_READ_SUPPORTED_STATES are invalid/broken.
+	 *
+	 * This mechanism is necessary as many controllers have been seen has
+	 * having trouble initiating a connectable advertisement despite the
+	 * state combination being reported as supported.
+	 *
+	 * This quirk can be set before hci_register_dev is called or
+	 * during the hdev->setup vendor callback.
 	 */
-	HCI_QUIRK_VALID_LE_STATES,
+	HCI_QUIRK_BROKEN_LE_STATES,
 
 	/* When this quirk is set, then erroneous data reporting
 	 * is ignored. This is mainly due to the fact that the HCI
diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index b15f51ae3bfd9..c97ff64c9189f 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -826,7 +826,7 @@ extern struct mutex hci_cb_list_lock;
 	} while (0)
 
 #define hci_dev_le_state_simultaneous(hdev) \
-	(test_bit(HCI_QUIRK_VALID_LE_STATES, &hdev->quirks) && \
+	(!test_bit(HCI_QUIRK_BROKEN_LE_STATES, &hdev->quirks) && \
 	 (hdev->le_states[4] & 0x08) &&	/* Central */ \
 	 (hdev->le_states[4] & 0x40) &&	/* Peripheral */ \
 	 (hdev->le_states[3] & 0x10))	/* Simultaneous */
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index a78f6d706cd43..59d9086db75fe 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -5921,7 +5921,7 @@ static struct hci_conn *check_pending_le_conn(struct hci_dev *hdev,
 	 * while we have an existing one in peripheral role.
 	 */
 	if (hdev->conn_hash.le_num_peripheral > 0 &&
-	    (!test_bit(HCI_QUIRK_VALID_LE_STATES, &hdev->quirks) ||
+	    (test_bit(HCI_QUIRK_BROKEN_LE_STATES, &hdev->quirks) ||
 	     !(hdev->le_states[3] & 0x10)))
 		return NULL;
 
-- 
2.43.0



