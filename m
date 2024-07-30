Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09EB1A6166;
	Tue, 30 Jul 2024 16:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356663; cv=none; b=qH+Vkjq7n/3WquXWhunBjmT/7P9M8gDEo6EGpJQJ+kpFtYdkS2sHu0PiFMyBBefQHFS0wyOeGzf33vNmzi2IGy9qfRS/UQ5wvrWXav5Crt7G1qb7NBKw0Bgm1MIMHcht02/fWOdogvGkfAd66BZ7ajqLEh34chaTXSD8hAFgJdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356663; c=relaxed/simple;
	bh=59Ffrha14k2Z9ls0N5xmWWWnG/slorgKNeLLAKFT+FU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ouD5VfmcOFXR2YUCjEO7WEk9AKkJo6MSVHKYapSBqwlO8fXza1ih7hJeXLfpBBetQ/VsQDo0YrA8sqITYH5cl5/o6dscestWdpGNefmTUu/P/Qbt8+EULcAW0SKquMcINgMzekbLXJIgUzbnpw2O0/J/lVHO9Om+a42NFS5NMJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0xsmCou9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0xsmCou9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC15C4AF11;
	Tue, 30 Jul 2024 16:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356662;
	bh=59Ffrha14k2Z9ls0N5xmWWWnG/slorgKNeLLAKFT+FU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0xsmCou9N1uo8hfSAR9Qrt3sG7++KPrRWx/ur2jwub7jNrfhVDWkiXfDQwuMbYCax
	 G6zbuXk5xFXoRUwqC2KJRiJ6Wj/fWwBI6Zcd6FfFcwBaOIOsGn+iCrbALnA6o+9OVG
	 wT0O1DzqnV2SDsRDAfTWSBWE6zdurYY+q9uDMWYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 171/568] Bluetooth: btintel: Refactor btintel_set_ppag()
Date: Tue, 30 Jul 2024 17:44:38 +0200
Message-ID: <20240730151646.568065367@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kiran K <kiran.k@intel.com>

[ Upstream commit 0a3e2eca1daa5627c8ecd1554e3146de82d61dd2 ]

Current flow iterates the ACPI table associated with Bluetooth
controller looking for PPAG method. Method name can be directly passed
to acpi_evaluate_object function instead of iterating the table.

Fixes: c585a92b2f9c ("Bluetooth: btintel: Set Per Platform Antenna Gain(PPAG)")
Signed-off-by: Kiran K <kiran.k@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel.c | 119 +++++++++++-------------------------
 1 file changed, 34 insertions(+), 85 deletions(-)

diff --git a/drivers/bluetooth/btintel.c b/drivers/bluetooth/btintel.c
index ac1562d9ef26b..3da3c266a66f3 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -26,21 +26,11 @@
 #define ECDSA_OFFSET		644
 #define ECDSA_HEADER_LEN	320
 
-#define BTINTEL_PPAG_NAME   "PPAG"
-
 enum {
 	DSM_SET_WDISABLE2_DELAY = 1,
 	DSM_SET_RESET_METHOD = 3,
 };
 
-/* structure to store the PPAG data read from ACPI table */
-struct btintel_ppag {
-	u32	domain;
-	u32     mode;
-	acpi_status status;
-	struct hci_dev *hdev;
-};
-
 #define CMD_WRITE_BOOT_PARAMS	0xfc0e
 struct cmd_write_boot_params {
 	__le32 boot_addr;
@@ -1312,65 +1302,6 @@ static int btintel_read_debug_features(struct hci_dev *hdev,
 	return 0;
 }
 
-static acpi_status btintel_ppag_callback(acpi_handle handle, u32 lvl, void *data,
-					 void **ret)
-{
-	acpi_status status;
-	size_t len;
-	struct btintel_ppag *ppag = data;
-	union acpi_object *p, *elements;
-	struct acpi_buffer string = {ACPI_ALLOCATE_BUFFER, NULL};
-	struct acpi_buffer buffer = {ACPI_ALLOCATE_BUFFER, NULL};
-	struct hci_dev *hdev = ppag->hdev;
-
-	status = acpi_get_name(handle, ACPI_FULL_PATHNAME, &string);
-	if (ACPI_FAILURE(status)) {
-		bt_dev_warn(hdev, "PPAG-BT: ACPI Failure: %s", acpi_format_exception(status));
-		return status;
-	}
-
-	len = strlen(string.pointer);
-	if (len < strlen(BTINTEL_PPAG_NAME)) {
-		kfree(string.pointer);
-		return AE_OK;
-	}
-
-	if (strncmp((char *)string.pointer + len - 4, BTINTEL_PPAG_NAME, 4)) {
-		kfree(string.pointer);
-		return AE_OK;
-	}
-	kfree(string.pointer);
-
-	status = acpi_evaluate_object(handle, NULL, NULL, &buffer);
-	if (ACPI_FAILURE(status)) {
-		ppag->status = status;
-		bt_dev_warn(hdev, "PPAG-BT: ACPI Failure: %s", acpi_format_exception(status));
-		return status;
-	}
-
-	p = buffer.pointer;
-	ppag = (struct btintel_ppag *)data;
-
-	if (p->type != ACPI_TYPE_PACKAGE || p->package.count != 2) {
-		kfree(buffer.pointer);
-		bt_dev_warn(hdev, "PPAG-BT: Invalid object type: %d or package count: %d",
-			    p->type, p->package.count);
-		ppag->status = AE_ERROR;
-		return AE_ERROR;
-	}
-
-	elements = p->package.elements;
-
-	/* PPAG table is located at element[1] */
-	p = &elements[1];
-
-	ppag->domain = (u32)p->package.elements[0].integer.value;
-	ppag->mode = (u32)p->package.elements[1].integer.value;
-	ppag->status = AE_OK;
-	kfree(buffer.pointer);
-	return AE_CTRL_TERMINATE;
-}
-
 static int btintel_set_debug_features(struct hci_dev *hdev,
 			       const struct intel_debug_features *features)
 {
@@ -2399,10 +2330,13 @@ static int btintel_configure_offload(struct hci_dev *hdev)
 
 static void btintel_set_ppag(struct hci_dev *hdev, struct intel_version_tlv *ver)
 {
-	struct btintel_ppag ppag;
 	struct sk_buff *skb;
 	struct hci_ppag_enable_cmd ppag_cmd;
 	acpi_handle handle;
+	struct acpi_buffer buffer = {ACPI_ALLOCATE_BUFFER, NULL};
+	union acpi_object *p, *elements;
+	u32 domain, mode;
+	acpi_status status;
 
 	/* PPAG is not supported if CRF is HrP2, Jfp2, JfP1 */
 	switch (ver->cnvr_top & 0xFFF) {
@@ -2420,22 +2354,34 @@ static void btintel_set_ppag(struct hci_dev *hdev, struct intel_version_tlv *ver
 		return;
 	}
 
-	memset(&ppag, 0, sizeof(ppag));
-
-	ppag.hdev = hdev;
-	ppag.status = AE_NOT_FOUND;
-	acpi_walk_namespace(ACPI_TYPE_PACKAGE, handle, 1, NULL,
-			    btintel_ppag_callback, &ppag, NULL);
-
-	if (ACPI_FAILURE(ppag.status)) {
-		if (ppag.status == AE_NOT_FOUND) {
+	status = acpi_evaluate_object(handle, "PPAG", NULL, &buffer);
+	if (ACPI_FAILURE(status)) {
+		if (status == AE_NOT_FOUND) {
 			bt_dev_dbg(hdev, "PPAG-BT: ACPI entry not found");
 			return;
 		}
+		bt_dev_warn(hdev, "PPAG-BT: ACPI Failure: %s", acpi_format_exception(status));
+		return;
+	}
+
+	p = buffer.pointer;
+	if (p->type != ACPI_TYPE_PACKAGE || p->package.count != 2) {
+		bt_dev_warn(hdev, "PPAG-BT: Invalid object type: %d or package count: %d",
+			    p->type, p->package.count);
+		kfree(buffer.pointer);
 		return;
 	}
 
-	if (ppag.domain != 0x12) {
+	elements = p->package.elements;
+
+	/* PPAG table is located at element[1] */
+	p = &elements[1];
+
+	domain = (u32)p->package.elements[0].integer.value;
+	mode = (u32)p->package.elements[1].integer.value;
+	kfree(buffer.pointer);
+
+	if (domain != 0x12) {
 		bt_dev_dbg(hdev, "PPAG-BT: Bluetooth domain is disabled in ACPI firmware");
 		return;
 	}
@@ -2446,19 +2392,22 @@ static void btintel_set_ppag(struct hci_dev *hdev, struct intel_version_tlv *ver
 	 * BIT 1 : 0 Disabled in China
 	 *         1 Enabled in China
 	 */
-	if ((ppag.mode & 0x01) != BIT(0) && (ppag.mode & 0x02) != BIT(1)) {
-		bt_dev_dbg(hdev, "PPAG-BT: EU, China mode are disabled in CB/BIOS");
+	mode &= 0x03;
+
+	if (!mode) {
+		bt_dev_dbg(hdev, "PPAG-BT: EU, China mode are disabled in BIOS");
 		return;
 	}
 
-	ppag_cmd.ppag_enable_flags = cpu_to_le32(ppag.mode);
+	ppag_cmd.ppag_enable_flags = cpu_to_le32(mode);
 
-	skb = __hci_cmd_sync(hdev, INTEL_OP_PPAG_CMD, sizeof(ppag_cmd), &ppag_cmd, HCI_CMD_TIMEOUT);
+	skb = __hci_cmd_sync(hdev, INTEL_OP_PPAG_CMD, sizeof(ppag_cmd),
+			     &ppag_cmd, HCI_CMD_TIMEOUT);
 	if (IS_ERR(skb)) {
 		bt_dev_warn(hdev, "Failed to send PPAG Enable (%ld)", PTR_ERR(skb));
 		return;
 	}
-	bt_dev_info(hdev, "PPAG-BT: Enabled (Mode %d)", ppag.mode);
+	bt_dev_info(hdev, "PPAG-BT: Enabled (Mode %d)", mode);
 	kfree_skb(skb);
 }
 
-- 
2.43.0



