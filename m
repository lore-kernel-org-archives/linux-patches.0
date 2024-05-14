Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 571A6D531;
	Tue, 14 May 2024 10:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684147; cv=none; b=um2En9BqbFl8Cctko1+DWvg7ZtxyClNBKlYsdw6dqHYmtc5V5fcds2McB6NEMVahkiASbQBWa904nZlFH/6cmvIcGP16d6dROTl9uvjt6e8H6ZzxPB3jIifGM1WSNwRFjxAc0O90pSXUWTjGlR1XioqT209a74nHPIAJXQo01zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684147; c=relaxed/simple;
	bh=TEp2SUN4cAlVgvTUUid6Eb63PQfhkUXVigWwG4ldqs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pq5tqp4Hq+yKfe5QFRdrptmLfMyHOdshBIr9SYwgNJVtJYw6+OUZwXmrKvJ8lkHLSV3EeuBtuITS5PogtVKeBKgm3yR47by1czaqD2ffqP3YMPEPPnjggFXZRfUWWhJ/Gvdn8Cs2TD9BFZjaPOsxOaOqoV9rAZuw/mF27vtR3Ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a1FJHMwZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a1FJHMwZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 451ECC32786;
	Tue, 14 May 2024 10:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684147;
	bh=TEp2SUN4cAlVgvTUUid6Eb63PQfhkUXVigWwG4ldqs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a1FJHMwZNN3svEGZZ74cJrYMAiFwiIWpJ+5unTzjJyVCXFTh1QH4WCM/5j5HihsYi
	 Vr+xegHl00xElFWnrK0HBsgwE4sAdB8qnuKkuYzu/1vSdYzNoplmXWSEYuBx0Z/ykg
	 iX3mCTqwABeom6ld3rDRBFOsQmQ0axhybQWnrFCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.8 331/336] Bluetooth: qca: add missing firmware sanity checks
Date: Tue, 14 May 2024 12:18:55 +0200
Message-ID: <20240514101051.121591417@linuxfoundation.org>
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

commit 2e4edfa1e2bd821a317e7d006517dcf2f3fac68d upstream.

Add the missing sanity checks when parsing the firmware files before
downloading them to avoid accessing and corrupting memory beyond the
vmalloced buffer.

Fixes: 83e81961ff7e ("Bluetooth: btqca: Introduce generic QCA ROME support")
Cc: stable@vger.kernel.org	# 4.10
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btqca.c |   38 ++++++++++++++++++++++++++++++++------
 1 file changed, 32 insertions(+), 6 deletions(-)

--- a/drivers/bluetooth/btqca.c
+++ b/drivers/bluetooth/btqca.c
@@ -268,9 +268,10 @@ int qca_send_pre_shutdown_cmd(struct hci
 }
 EXPORT_SYMBOL_GPL(qca_send_pre_shutdown_cmd);
 
-static void qca_tlv_check_data(struct hci_dev *hdev,
+static int qca_tlv_check_data(struct hci_dev *hdev,
 			       struct qca_fw_config *config,
-		u8 *fw_data, enum qca_btsoc_type soc_type)
+			       u8 *fw_data, size_t fw_size,
+			       enum qca_btsoc_type soc_type)
 {
 	const u8 *data;
 	u32 type_len;
@@ -286,6 +287,9 @@ static void qca_tlv_check_data(struct hc
 
 	switch (config->type) {
 	case ELF_TYPE_PATCH:
+		if (fw_size < 7)
+			return -EINVAL;
+
 		config->dnld_mode = QCA_SKIP_EVT_VSE_CC;
 		config->dnld_type = QCA_SKIP_EVT_VSE_CC;
 
@@ -294,6 +298,9 @@ static void qca_tlv_check_data(struct hc
 		bt_dev_dbg(hdev, "File version      : 0x%x", fw_data[6]);
 		break;
 	case TLV_TYPE_PATCH:
+		if (fw_size < sizeof(struct tlv_type_hdr) + sizeof(struct tlv_type_patch))
+			return -EINVAL;
+
 		tlv = (struct tlv_type_hdr *)fw_data;
 		type_len = le32_to_cpu(tlv->type_len);
 		tlv_patch = (struct tlv_type_patch *)tlv->data;
@@ -333,6 +340,9 @@ static void qca_tlv_check_data(struct hc
 		break;
 
 	case TLV_TYPE_NVM:
+		if (fw_size < sizeof(struct tlv_type_hdr))
+			return -EINVAL;
+
 		tlv = (struct tlv_type_hdr *)fw_data;
 
 		type_len = le32_to_cpu(tlv->type_len);
@@ -341,17 +351,26 @@ static void qca_tlv_check_data(struct hc
 		BT_DBG("TLV Type\t\t : 0x%x", type_len & 0x000000ff);
 		BT_DBG("Length\t\t : %d bytes", length);
 
+		if (fw_size < length + (tlv->data - fw_data))
+			return -EINVAL;
+
 		idx = 0;
 		data = tlv->data;
-		while (idx < length) {
+		while (idx < length - sizeof(struct tlv_type_nvm)) {
 			tlv_nvm = (struct tlv_type_nvm *)(data + idx);
 
 			tag_id = le16_to_cpu(tlv_nvm->tag_id);
 			tag_len = le16_to_cpu(tlv_nvm->tag_len);
 
+			if (length < idx + sizeof(struct tlv_type_nvm) + tag_len)
+				return -EINVAL;
+
 			/* Update NVM tags as needed */
 			switch (tag_id) {
 			case EDL_TAG_ID_HCI:
+				if (tag_len < 3)
+					return -EINVAL;
+
 				/* HCI transport layer parameters
 				 * enabling software inband sleep
 				 * onto controller side.
@@ -367,6 +386,9 @@ static void qca_tlv_check_data(struct hc
 				break;
 
 			case EDL_TAG_ID_DEEP_SLEEP:
+				if (tag_len < 1)
+					return -EINVAL;
+
 				/* Sleep enable mask
 				 * enabling deep sleep feature on controller.
 				 */
@@ -375,14 +397,16 @@ static void qca_tlv_check_data(struct hc
 				break;
 			}
 
-			idx += (sizeof(u16) + sizeof(u16) + 8 + tag_len);
+			idx += sizeof(struct tlv_type_nvm) + tag_len;
 		}
 		break;
 
 	default:
 		BT_ERR("Unknown TLV type %d", config->type);
-		break;
+		return -EINVAL;
 	}
+
+	return 0;
 }
 
 static int qca_tlv_send_segment(struct hci_dev *hdev, int seg_size,
@@ -532,7 +556,9 @@ static int qca_download_firmware(struct
 	memcpy(data, fw->data, size);
 	release_firmware(fw);
 
-	qca_tlv_check_data(hdev, config, data, soc_type);
+	ret = qca_tlv_check_data(hdev, config, data, size, soc_type);
+	if (ret)
+		return ret;
 
 	segment = data;
 	remain = size;


