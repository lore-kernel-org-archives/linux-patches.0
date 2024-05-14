Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F5F8D531;
	Tue, 14 May 2024 10:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684160; cv=none; b=qPHUAL/u9EdMyK1PzanADiVqLZzUFlt5rQLicssJri2INOUmnoVxvIBJ0CFs8GvvHs+SSQCE2W5568OFaJDIOJVNVHS92HskKPhEl0JefZIAd8CbcfR3m3HA1T+IteO7QMlBBSqWcIi+TNtmkAtx2CE53txTRJUM+MT5tUEO8vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684160; c=relaxed/simple;
	bh=yqZIjY4AUWeZYeQ1XrUpmAvpRlG743GuDaC3y/+QBas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X398pMvDQVBCDp8rngABLRRJrBYBPDxNSOyiFOusRE3/GSkTup3W8dCyeE6Z/MXY7Q3npOhN8WbgH9V3NgF4nhLh4MSFUCjYAldzeFfllh65uNsWqOdwRuTTPK+3re7nODXXBbpXViQWIt/o/QOM+pY9xveJrxqgney+0j42kv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rsHSMsiB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rsHSMsiB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8669EC2BD10;
	Tue, 14 May 2024 10:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684159;
	bh=yqZIjY4AUWeZYeQ1XrUpmAvpRlG743GuDaC3y/+QBas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rsHSMsiBuTcLdiUYAEVTUmeThp7fhfqydKGOY25pJbVkkMFDdweLlNGYY8A4aUNzq
	 gH/4+GTVKYXOlKpFE6/TEpawzYof1vkIcihfzWvDW40Gohj33NA4iubbmJSxFOlIm9
	 5/N6MUpU4A/5xsncydbIlsZIm8D9Yx5u70xE7LJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Anderson <dianders@chromium.org>,
	Janaki Ramaiah Thota <quic_janathot@quicinc.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.8 333/336] Bluetooth: qca: generalise device address check
Date: Tue, 14 May 2024 12:18:57 +0200
Message-ID: <20240514101051.199199830@linuxfoundation.org>
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

commit dd336649ba89789c845618dcbc09867010aec673 upstream.

The default device address apparently comes from the NVM configuration
file and can differ quite a bit between controllers.

Store the default address when parsing the configuration file and use it
to determine whether the controller has been provisioned with an
address.

This makes sure that devices without a unique address start as
unconfigured unless a valid address has been provided in the devicetree.

Fixes: 32868e126c78 ("Bluetooth: qca: fix invalid device address check")
Cc: stable@vger.kernel.org      # 6.5
Cc: Doug Anderson <dianders@chromium.org>
Cc: Janaki Ramaiah Thota <quic_janathot@quicinc.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Tested-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btqca.c |   21 ++++++++++++---------
 drivers/bluetooth/btqca.h |    2 ++
 2 files changed, 14 insertions(+), 9 deletions(-)

--- a/drivers/bluetooth/btqca.c
+++ b/drivers/bluetooth/btqca.c
@@ -15,9 +15,6 @@
 
 #define VERSION "0.1"
 
-#define QCA_BDADDR_DEFAULT (&(bdaddr_t) {{ 0xad, 0x5a, 0x00, 0x00, 0x00, 0x00 }})
-#define QCA_BDADDR_WCN3991 (&(bdaddr_t) {{ 0xad, 0x5a, 0x00, 0x00, 0x98, 0x39 }})
-
 int qca_read_soc_version(struct hci_dev *hdev, struct qca_btsoc_version *ver,
 			 enum qca_btsoc_type soc_type)
 {
@@ -387,6 +384,14 @@ static int qca_tlv_check_data(struct hci
 
 			/* Update NVM tags as needed */
 			switch (tag_id) {
+			case EDL_TAG_ID_BD_ADDR:
+				if (tag_len != sizeof(bdaddr_t))
+					return -EINVAL;
+
+				memcpy(&config->bdaddr, tlv_nvm->data, sizeof(bdaddr_t));
+
+				break;
+
 			case EDL_TAG_ID_HCI:
 				if (tag_len < 3)
 					return -EINVAL;
@@ -661,7 +666,7 @@ int qca_set_bdaddr_rome(struct hci_dev *
 }
 EXPORT_SYMBOL_GPL(qca_set_bdaddr_rome);
 
-static int qca_check_bdaddr(struct hci_dev *hdev)
+static int qca_check_bdaddr(struct hci_dev *hdev, const struct qca_fw_config *config)
 {
 	struct hci_rp_read_bd_addr *bda;
 	struct sk_buff *skb;
@@ -685,10 +690,8 @@ static int qca_check_bdaddr(struct hci_d
 	}
 
 	bda = (struct hci_rp_read_bd_addr *)skb->data;
-	if (!bacmp(&bda->bdaddr, QCA_BDADDR_DEFAULT) ||
-	    !bacmp(&bda->bdaddr, QCA_BDADDR_WCN3991)) {
+	if (!bacmp(&bda->bdaddr, &config->bdaddr))
 		set_bit(HCI_QUIRK_USE_BDADDR_PROPERTY, &hdev->quirks);
-	}
 
 	kfree_skb(skb);
 
@@ -716,7 +719,7 @@ int qca_uart_setup(struct hci_dev *hdev,
 		   enum qca_btsoc_type soc_type, struct qca_btsoc_version ver,
 		   const char *firmware_name)
 {
-	struct qca_fw_config config;
+	struct qca_fw_config config = {};
 	int err;
 	u8 rom_ver = 0;
 	u32 soc_ver;
@@ -901,7 +904,7 @@ int qca_uart_setup(struct hci_dev *hdev,
 		break;
 	}
 
-	err = qca_check_bdaddr(hdev);
+	err = qca_check_bdaddr(hdev, &config);
 	if (err)
 		return err;
 
--- a/drivers/bluetooth/btqca.h
+++ b/drivers/bluetooth/btqca.h
@@ -29,6 +29,7 @@
 #define EDL_PATCH_CONFIG_RES_EVT	(0x00)
 #define QCA_DISABLE_LOGGING_SUB_OP	(0x14)
 
+#define EDL_TAG_ID_BD_ADDR		2
 #define EDL_TAG_ID_HCI			(17)
 #define EDL_TAG_ID_DEEP_SLEEP		(27)
 
@@ -94,6 +95,7 @@ struct qca_fw_config {
 	uint8_t user_baud_rate;
 	enum qca_tlv_dnld_mode dnld_mode;
 	enum qca_tlv_dnld_mode dnld_type;
+	bdaddr_t bdaddr;
 };
 
 struct edl_event_hdr {


