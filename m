Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A690013A25F;
	Tue,  9 Jul 2024 11:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524318; cv=none; b=V8c+BEtDQmmWtVeMysatW9i8xOiZJhm2agi2gOocxd+hA+TbYue/4CkvuzoeG+ahmjjJ0WlSeGhYoo42GgaXStG0nepdSg5yoArguGqcwwolqDItH6dRb6/rhjNnQ6Jvpgr0N5HDUyfyR9qqAojJeXww6BIcUHUXDQEm/K0OuaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524318; c=relaxed/simple;
	bh=Ooyux5djmWFjBnyLEVYmhziBmNz+EHwErL+fjLw37fQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vims61Wc9vbuztDQESrzBwYwvgRTAveYkJu8Wp25lPQj7tTZggoshSzPBIdx99DUHstv6AoGWZfU4yhSDt7pIwxVhGUtKOCd0PJX0wHLfmbFfz0qh33RCE1bF7WMvhfLIMDWi+wdOfG7jMz0H0JS0GyOnRSo9UykhYBuo7LpSWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M9etB/pX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M9etB/pX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DCA0C3277B;
	Tue,  9 Jul 2024 11:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524318;
	bh=Ooyux5djmWFjBnyLEVYmhziBmNz+EHwErL+fjLw37fQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M9etB/pXqOSnnqFqh+EsPDb5j3U42IpZa6F0bIsEKp2usGE5hG35UlGCqwFEo9mX/
	 SDnbeoYeObu9AAqQXAuK3j+NoPIwLYMRgOhNpCWQ72dWUDlNoDbDuLZD/MHihPtkEG
	 JHSJ6SnSqpxSOHhGRokQzqeqHCK6F2CAGtZ6p+SQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Janne Grunau <j@jannau.net>,
	Sven Peter <sven@svenpeter.dev>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.9 144/197] Bluetooth: Add quirk to ignore reserved PHY bits in LE Extended Adv Report
Date: Tue,  9 Jul 2024 13:09:58 +0200
Message-ID: <20240709110714.524462651@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Peter <sven@svenpeter.dev>

commit ed2a2ef16a6b9197a0e452308bf6acee6e01f709 upstream.

Some Broadcom controllers found on Apple Silicon machines abuse the
reserved bits inside the PHY fields of LE Extended Advertising Report
events for additional flags. Add a quirk to drop these and correctly
extract the Primary/Secondary_PHY field.

The following excerpt from a btmon trace shows a report received with
"Reserved" for "Primary PHY" on a 4388 controller:

> HCI Event: LE Meta Event (0x3e) plen 26
      LE Extended Advertising Report (0x0d)
        Num reports: 1
        Entry 0
          Event type: 0x2515
            Props: 0x0015
              Connectable
              Directed
              Use legacy advertising PDUs
            Data status: Complete
            Reserved (0x2500)
         Legacy PDU Type: Reserved (0x2515)
          Address type: Random (0x01)
          Address: 00:00:00:00:00:00 (Static)
          Primary PHY: Reserved
          Secondary PHY: No packets
          SID: no ADI field (0xff)
          TX power: 127 dBm
          RSSI: -60 dBm (0xc4)
          Periodic advertising interval: 0.00 msec (0x0000)
          Direct address type: Public (0x00)
          Direct address: 00:00:00:00:00:00 (Apple, Inc.)
          Data length: 0x00

Cc: stable@vger.kernel.org
Fixes: 2e7ed5f5e69b ("Bluetooth: hci_sync: Use advertised PHYs on hci_le_ext_create_conn_sync")
Reported-by: Janne Grunau <j@jannau.net>
Closes: https://lore.kernel.org/all/Zjz0atzRhFykROM9@robin
Tested-by: Janne Grunau <j@jannau.net>
Signed-off-by: Sven Peter <sven@svenpeter.dev>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/hci_bcm4377.c |    8 ++++++++
 include/net/bluetooth/hci.h     |   11 +++++++++++
 net/bluetooth/hci_event.c       |    7 +++++++
 3 files changed, 26 insertions(+)

--- a/drivers/bluetooth/hci_bcm4377.c
+++ b/drivers/bluetooth/hci_bcm4377.c
@@ -495,6 +495,10 @@ struct bcm4377_data;
  *                  extended scanning
  * broken_mws_transport_config: Set to true if the chip erroneously claims to
  *                              support MWS Transport Configuration
+ * broken_le_ext_adv_report_phy: Set to true if this chip stuffs flags inside
+ *                               reserved bits of Primary/Secondary_PHY inside
+ *                               LE Extended Advertising Report events which
+ *                               have to be ignored
  * send_calibration: Optional callback to send calibration data
  * send_ptb: Callback to send "PTB" regulatory/calibration data
  */
@@ -513,6 +517,7 @@ struct bcm4377_hw {
 	unsigned long broken_ext_scan : 1;
 	unsigned long broken_mws_transport_config : 1;
 	unsigned long broken_le_coded : 1;
+	unsigned long broken_le_ext_adv_report_phy : 1;
 
 	int (*send_calibration)(struct bcm4377_data *bcm4377);
 	int (*send_ptb)(struct bcm4377_data *bcm4377,
@@ -2373,6 +2378,8 @@ static int bcm4377_probe(struct pci_dev
 		set_bit(HCI_QUIRK_BROKEN_EXT_SCAN, &hdev->quirks);
 	if (bcm4377->hw->broken_le_coded)
 		set_bit(HCI_QUIRK_BROKEN_LE_CODED, &hdev->quirks);
+	if (bcm4377->hw->broken_le_ext_adv_report_phy)
+		set_bit(HCI_QUIRK_FIXUP_LE_EXT_ADV_REPORT_PHY, &hdev->quirks);
 
 	pci_set_drvdata(pdev, bcm4377);
 	hci_set_drvdata(hdev, bcm4377);
@@ -2477,6 +2484,7 @@ static const struct bcm4377_hw bcm4377_h
 		.clear_pciecfg_subsystem_ctrl_bit19 = true,
 		.broken_mws_transport_config = true,
 		.broken_le_coded = true,
+		.broken_le_ext_adv_report_phy = true,
 		.send_calibration = bcm4387_send_calibration,
 		.send_ptb = bcm4378_send_ptb,
 	},
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -324,6 +324,17 @@ enum {
 	 * claim to support it.
 	 */
 	HCI_QUIRK_BROKEN_READ_ENC_KEY_SIZE,
+
+	/*
+	 * When this quirk is set, the reserved bits of Primary/Secondary_PHY
+	 * inside the LE Extended Advertising Report events are discarded.
+	 * This is required for some Apple/Broadcom controllers which
+	 * abuse these reserved bits for unrelated flags.
+	 *
+	 * This quirk can be set before hci_register_dev is called or
+	 * during the hdev->setup vendor callback.
+	 */
+	HCI_QUIRK_FIXUP_LE_EXT_ADV_REPORT_PHY,
 };
 
 /* HCI device flags */
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -6312,6 +6312,13 @@ static void hci_le_ext_adv_report_evt(st
 
 		evt_type = __le16_to_cpu(info->type) & LE_EXT_ADV_EVT_TYPE_MASK;
 		legacy_evt_type = ext_evt_type_to_legacy(hdev, evt_type);
+
+		if (test_bit(HCI_QUIRK_FIXUP_LE_EXT_ADV_REPORT_PHY,
+			     &hdev->quirks)) {
+			info->primary_phy &= 0x1f;
+			info->secondary_phy &= 0x1f;
+		}
+
 		if (legacy_evt_type != LE_ADV_INVALID) {
 			process_adv_report(hdev, legacy_evt_type, &info->bdaddr,
 					   info->bdaddr_type, NULL, 0,


