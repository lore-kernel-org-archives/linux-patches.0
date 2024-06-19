Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6BF144D3E;
	Wed, 19 Jun 2024 13:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803627; cv=none; b=fG7oDRkZjcqm0aRMhCYRMCp7YIuDK8k/BMeBhdhvxAIHuNZBUnDTK2A8Tleiko83CVbtHnvTxL8mY54MLnnx2DMLKRwRN39O+taV4vxhTinO0QqyTSlFkRn42L3EgQ4F1bqrwfDNDMW9zo3bsrJvvSHSKmOxgs5nFOzmC4W1x1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803627; c=relaxed/simple;
	bh=ccxqq7Nnk6ZAf/tCHgVp+ycUCSkvIq2iuIHesbNc2Ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gntSQOvIDyinV7+btNd6Q9fpAryNwH9/T8yOtJ3PLLQPDY3PvUrtQ7vkoaHBHNrAf8uDuMH/zcYpmV5atpQ0vQcwclmbdqvPBrltkjxLu2ZVokF/vcZo9ubT82a3Hr7adTXKC3OInMPrA2vRCjAZghUkX9zKMDYEDHtavQaXDPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rFNTnMY5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rFNTnMY5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35228C2BBFC;
	Wed, 19 Jun 2024 13:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803627;
	bh=ccxqq7Nnk6ZAf/tCHgVp+ycUCSkvIq2iuIHesbNc2Ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rFNTnMY5xeWlVhXnB6H8/bljSm2ko1qh5j5CAq8b5hy9vvCZt3KCveHaA5fke3rj3
	 NnyIMOhsMXz4R8+gcBY5d9SkdNOsN7j6aIdVj0fOVFMlzq0ExgpnNFNU+sP8SCUmJJ
	 FcFSu7RIVSr8MGCvhwcibuQyhpfzt/F+98NcTNJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Janaki Ramaiah Thota <quic_janathot@quicinc.com>,
	Matthias Kaehlcke <mka@chromium.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 050/217] Bluetooth: qca: fix invalid device address check
Date: Wed, 19 Jun 2024 14:54:53 +0200
Message-ID: <20240619125558.592625896@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit 32868e126c78876a8a5ddfcb6ac8cb2fffcf4d27 ]

Qualcomm Bluetooth controllers may not have been provisioned with a
valid device address and instead end up using the default address
00:00:00:00:5a:ad.

This was previously believed to be due to lack of persistent storage for
the address but it may also be due to integrators opting to not use the
on-chip OTP memory and instead store the address elsewhere (e.g. in
storage managed by secure world firmware).

According to Qualcomm, at least WCN6750, WCN6855 and WCN7850 have
on-chip OTP storage for the address.

As the device type alone cannot be used to determine when the address is
valid, instead read back the address during setup() and only set the
HCI_QUIRK_USE_BDADDR_PROPERTY flag when needed.

This specifically makes sure that controllers that have been provisioned
with an address do not start as unconfigured.

Reported-by: Janaki Ramaiah Thota <quic_janathot@quicinc.com>
Link: https://lore.kernel.org/r/124a7d54-5a18-4be7-9a76-a12017f6cce5@quicinc.com/
Fixes: 5971752de44c ("Bluetooth: hci_qca: Set HCI_QUIRK_USE_BDADDR_PROPERTY for wcn3990")
Fixes: e668eb1e1578 ("Bluetooth: hci_core: Don't stop BT if the BD address missing in dts")
Fixes: 6945795bc81a ("Bluetooth: fix use-bdaddr-property quirk")
Cc: stable@vger.kernel.org	# 6.5
Cc: Matthias Kaehlcke <mka@chromium.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reported-by: Janaki Ramaiah Thota <quic_janathot@quicinc.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btqca.c   | 38 +++++++++++++++++++++++++++++++++++++
 drivers/bluetooth/hci_qca.c |  2 --
 2 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/drivers/bluetooth/btqca.c b/drivers/bluetooth/btqca.c
index 2dda94a0875a6..8df2e53dcd63c 100644
--- a/drivers/bluetooth/btqca.c
+++ b/drivers/bluetooth/btqca.c
@@ -15,6 +15,8 @@
 
 #define VERSION "0.1"
 
+#define QCA_BDADDR_DEFAULT (&(bdaddr_t) {{ 0xad, 0x5a, 0x00, 0x00, 0x00, 0x00 }})
+
 int qca_read_soc_version(struct hci_dev *hdev, struct qca_btsoc_version *ver,
 			 enum qca_btsoc_type soc_type)
 {
@@ -682,6 +684,38 @@ int qca_set_bdaddr_rome(struct hci_dev *hdev, const bdaddr_t *bdaddr)
 }
 EXPORT_SYMBOL_GPL(qca_set_bdaddr_rome);
 
+static int qca_check_bdaddr(struct hci_dev *hdev)
+{
+	struct hci_rp_read_bd_addr *bda;
+	struct sk_buff *skb;
+	int err;
+
+	if (bacmp(&hdev->public_addr, BDADDR_ANY))
+		return 0;
+
+	skb = __hci_cmd_sync(hdev, HCI_OP_READ_BD_ADDR, 0, NULL,
+			     HCI_INIT_TIMEOUT);
+	if (IS_ERR(skb)) {
+		err = PTR_ERR(skb);
+		bt_dev_err(hdev, "Failed to read device address (%d)", err);
+		return err;
+	}
+
+	if (skb->len != sizeof(*bda)) {
+		bt_dev_err(hdev, "Device address length mismatch");
+		kfree_skb(skb);
+		return -EIO;
+	}
+
+	bda = (struct hci_rp_read_bd_addr *)skb->data;
+	if (!bacmp(&bda->bdaddr, QCA_BDADDR_DEFAULT))
+		set_bit(HCI_QUIRK_USE_BDADDR_PROPERTY, &hdev->quirks);
+
+	kfree_skb(skb);
+
+	return 0;
+}
+
 static void qca_generate_hsp_nvm_name(char *fwname, size_t max_size,
 		struct qca_btsoc_version ver, u8 rom_ver, u16 bid)
 {
@@ -888,6 +922,10 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
 		break;
 	}
 
+	err = qca_check_bdaddr(hdev);
+	if (err)
+		return err;
+
 	bt_dev_info(hdev, "QCA setup on UART is completed");
 
 	return 0;
diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index a0e2b5d992695..070014d0fc994 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -1853,8 +1853,6 @@ static int qca_setup(struct hci_uart *hu)
 	case QCA_WCN6750:
 	case QCA_WCN6855:
 	case QCA_WCN7850:
-		set_bit(HCI_QUIRK_USE_BDADDR_PROPERTY, &hdev->quirks);
-
 		qcadev = serdev_device_get_drvdata(hu->serdev);
 		if (qcadev->bdaddr_property_broken)
 			set_bit(HCI_QUIRK_BDADDR_PROPERTY_BROKEN, &hdev->quirks);
-- 
2.43.0



