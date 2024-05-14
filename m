Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFCB842A9C;
	Tue, 14 May 2024 10:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684130; cv=none; b=WThFAuAbOUvfuJpnybEIaktXsp8J0I98hE71H5Kx41JbLMUwn+y8nheFHk+HoXd+D1bIveKnnMeBhZTV+fD3LbyUBp+rwdJtms3BDvhL/7eFTlr2pkn/CvB2M/OzXQ634HuwNYNPcPziHMnoKTwsVLkuxFIYz7Rf2d2cjeHvmcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684130; c=relaxed/simple;
	bh=TR6K5EDpeEq1Q/eDOXT3H1nkZbzi1Y2W8iQxivNBuLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LYNBXs52fZPCvTr14czpHUr7zoRIagjpn7Nl/CVV6khCuGQwwyP4PeaH6XmobCpGncsPgA8JniBAW43eaAlJJxtiyAwGWlfZMScPOTIm95mfUK2kPGsDS+I6ceiYlSJg9S/IX3fCDJhA5Ez7i8zW45ge6bDpVp1o54hJGzr84pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vWHjiuWx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vWHjiuWx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0FB5C2BD10;
	Tue, 14 May 2024 10:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684129;
	bh=TR6K5EDpeEq1Q/eDOXT3H1nkZbzi1Y2W8iQxivNBuLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vWHjiuWx3FqRlWLXCp3XAqo86Xu8fkA/JS2bxFrZC9YAkQP9fRZ3eluRTnMMp3YsM
	 d1CC8ycba8ksthPXmmYRnBWV/qEtYapykq8ZbAtcFtIeQM/VXcr1d9NYgwUQtpBl1G
	 iWM9kZN+UjXD31o81EAm+fWNeUmFCVz3L6kTzJmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Janaki Ramaiah Thota <quic_janathot@quicinc.com>,
	Matthias Kaehlcke <mka@chromium.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.8 329/336] Bluetooth: qca: fix invalid device address check
Date: Tue, 14 May 2024 12:18:53 +0200
Message-ID: <20240514101051.043510908@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit 32868e126c78876a8a5ddfcb6ac8cb2fffcf4d27 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btqca.c   |   38 ++++++++++++++++++++++++++++++++++++++
 drivers/bluetooth/hci_qca.c |    2 --
 2 files changed, 38 insertions(+), 2 deletions(-)

--- a/drivers/bluetooth/btqca.c
+++ b/drivers/bluetooth/btqca.c
@@ -15,6 +15,8 @@
 
 #define VERSION "0.1"
 
+#define QCA_BDADDR_DEFAULT (&(bdaddr_t) {{ 0xad, 0x5a, 0x00, 0x00, 0x00, 0x00 }})
+
 int qca_read_soc_version(struct hci_dev *hdev, struct qca_btsoc_version *ver,
 			 enum qca_btsoc_type soc_type)
 {
@@ -612,6 +614,38 @@ int qca_set_bdaddr_rome(struct hci_dev *
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
@@ -818,6 +852,10 @@ int qca_uart_setup(struct hci_dev *hdev,
 		break;
 	}
 
+	err = qca_check_bdaddr(hdev);
+	if (err)
+		return err;
+
 	bt_dev_info(hdev, "QCA setup on UART is completed");
 
 	return 0;
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -1908,8 +1908,6 @@ retry:
 	case QCA_WCN6750:
 	case QCA_WCN6855:
 	case QCA_WCN7850:
-		set_bit(HCI_QUIRK_USE_BDADDR_PROPERTY, &hdev->quirks);
-
 		qcadev = serdev_device_get_drvdata(hu->serdev);
 		if (qcadev->bdaddr_property_broken)
 			set_bit(HCI_QUIRK_BDADDR_PROPERTY_BROKEN, &hdev->quirks);


