Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CDD52E54BF;
	Tue, 15 Jul 2025 13:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585849; cv=none; b=EFxvbv6rcQJoEOxhihYXlqbhiwQo3tRPgCXD8zkdo2L8dw44QyobJnHLCVpbRarVfIgGv9L8oHvHq6xuLNvSnJr+NdjQ+ImZdXGzECsa7nGgu2a1JvbE7Z+yfH2/Bk0rhjpXc03ERG9nW7Qdl57NH2z+NIE4EoZyWZzu7TmYmdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585849; c=relaxed/simple;
	bh=inGbChr9GAp/KmMOqTsLQsepg0RkOvwLahTMTYub/yM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jNX24n9UGN7kotrmGlWTltmiCV5w6P23fNFfBEn3I+vPPg0qDT6F1W7blHWliwIU2QEuOezRncl150FxtZEK5TlcBAvOBow6D8c9IVnzxLjSF+Lwu59kFpBvSA0MgccGAkhwote/ndjC75WIhFOr+x57QC8wfIW8R1e5phpgjs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vPwvDf1F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vPwvDf1F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7373AC4CEF1;
	Tue, 15 Jul 2025 13:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585848;
	bh=inGbChr9GAp/KmMOqTsLQsepg0RkOvwLahTMTYub/yM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vPwvDf1FtduvYBwaHiVpaZ7y2JwHsP/arekquOwmzDAbZpnfS63o9yqXmlmMrB+GZ
	 adSV+TIgzzouot8agq20VaIVNPU2OgVN1gQ7HKeS065OvV+vvi8d0mE7+tVtd0NVqZ
	 87C0G8IvH8cnREreNhcHLz6NrXSNm+EwUtRadaWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Eggers <ceggers@arri.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 030/109] Bluetooth: HCI: Set extended advertising data synchronously
Date: Tue, 15 Jul 2025 15:12:46 +0200
Message-ID: <20250715130800.091071483@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130758.864940641@linuxfoundation.org>
References: <20250715130758.864940641@linuxfoundation.org>
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

From: Christian Eggers <ceggers@arri.de>

commit 89fb8acc38852116d38d721ad394aad7f2871670 upstream.

Currently, for controllers with extended advertising, the advertising
data is set in the asynchronous response handler for extended
adverstising params. As most advertising settings are performed in a
synchronous context, the (asynchronous) setting of the advertising data
is done too late (after enabling the advertising).

Move setting of adverstising data from asynchronous response handler
into synchronous context to fix ordering of HCI commands.

Signed-off-by: Christian Eggers <ceggers@arri.de>
Fixes: a0fb3726ba55 ("Bluetooth: Use Set ext adv/scan rsp data if controller supports")
Cc: stable@vger.kernel.org
v2: https://lore.kernel.org/linux-bluetooth/20250626115209.17839-1-ceggers@arri.de/
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
[ This patch deviates from the upstream version because 3 functions in
  hci_sync.c (hci_set_ext_adv_data_sync, hci_set_adv_data_sync and
  hci_update_adv_data_sync) had to be moved up within the file. The
  content of these functions differs between 6.6 and newer kernels. ]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_event.c |   36 -------
 net/bluetooth/hci_sync.c  |  213 ++++++++++++++++++++++++++++------------------
 2 files changed, 133 insertions(+), 116 deletions(-)

--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -2139,40 +2139,6 @@ static u8 hci_cc_set_adv_param(struct hc
 	return rp->status;
 }
 
-static u8 hci_cc_set_ext_adv_param(struct hci_dev *hdev, void *data,
-				   struct sk_buff *skb)
-{
-	struct hci_rp_le_set_ext_adv_params *rp = data;
-	struct hci_cp_le_set_ext_adv_params *cp;
-	struct adv_info *adv_instance;
-
-	bt_dev_dbg(hdev, "status 0x%2.2x", rp->status);
-
-	if (rp->status)
-		return rp->status;
-
-	cp = hci_sent_cmd_data(hdev, HCI_OP_LE_SET_EXT_ADV_PARAMS);
-	if (!cp)
-		return rp->status;
-
-	hci_dev_lock(hdev);
-	hdev->adv_addr_type = cp->own_addr_type;
-	if (!cp->handle) {
-		/* Store in hdev for instance 0 */
-		hdev->adv_tx_power = rp->tx_power;
-	} else {
-		adv_instance = hci_find_adv_instance(hdev, cp->handle);
-		if (adv_instance)
-			adv_instance->tx_power = rp->tx_power;
-	}
-	/* Update adv data as tx power is known now */
-	hci_update_adv_data(hdev, cp->handle);
-
-	hci_dev_unlock(hdev);
-
-	return rp->status;
-}
-
 static u8 hci_cc_read_rssi(struct hci_dev *hdev, void *data,
 			   struct sk_buff *skb)
 {
@@ -4153,8 +4119,6 @@ static const struct hci_cc {
 	HCI_CC(HCI_OP_LE_READ_NUM_SUPPORTED_ADV_SETS,
 	       hci_cc_le_read_num_adv_sets,
 	       sizeof(struct hci_rp_le_read_num_supported_adv_sets)),
-	HCI_CC(HCI_OP_LE_SET_EXT_ADV_PARAMS, hci_cc_set_ext_adv_param,
-	       sizeof(struct hci_rp_le_set_ext_adv_params)),
 	HCI_CC_STATUS(HCI_OP_LE_SET_EXT_ADV_ENABLE,
 		      hci_cc_le_set_ext_adv_enable),
 	HCI_CC_STATUS(HCI_OP_LE_SET_ADV_SET_RAND_ADDR,
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -1224,9 +1224,129 @@ static int hci_set_adv_set_random_addr_s
 				     sizeof(cp), &cp, HCI_CMD_TIMEOUT);
 }
 
+static int
+hci_set_ext_adv_params_sync(struct hci_dev *hdev, struct adv_info *adv,
+			    const struct hci_cp_le_set_ext_adv_params *cp,
+			    struct hci_rp_le_set_ext_adv_params *rp)
+{
+	struct sk_buff *skb;
+
+	skb = __hci_cmd_sync(hdev, HCI_OP_LE_SET_EXT_ADV_PARAMS, sizeof(*cp),
+			     cp, HCI_CMD_TIMEOUT);
+
+	/* If command return a status event, skb will be set to -ENODATA */
+	if (skb == ERR_PTR(-ENODATA))
+		return 0;
+
+	if (IS_ERR(skb)) {
+		bt_dev_err(hdev, "Opcode 0x%4.4x failed: %ld",
+			   HCI_OP_LE_SET_EXT_ADV_PARAMS, PTR_ERR(skb));
+		return PTR_ERR(skb);
+	}
+
+	if (skb->len != sizeof(*rp)) {
+		bt_dev_err(hdev, "Invalid response length for 0x%4.4x: %u",
+			   HCI_OP_LE_SET_EXT_ADV_PARAMS, skb->len);
+		kfree_skb(skb);
+		return -EIO;
+	}
+
+	memcpy(rp, skb->data, sizeof(*rp));
+	kfree_skb(skb);
+
+	if (!rp->status) {
+		hdev->adv_addr_type = cp->own_addr_type;
+		if (!cp->handle) {
+			/* Store in hdev for instance 0 */
+			hdev->adv_tx_power = rp->tx_power;
+		} else if (adv) {
+			adv->tx_power = rp->tx_power;
+		}
+	}
+
+	return rp->status;
+}
+
+static int hci_set_ext_adv_data_sync(struct hci_dev *hdev, u8 instance)
+{
+	struct {
+		struct hci_cp_le_set_ext_adv_data cp;
+		u8 data[HCI_MAX_EXT_AD_LENGTH];
+	} pdu;
+	u8 len;
+	struct adv_info *adv = NULL;
+	int err;
+
+	memset(&pdu, 0, sizeof(pdu));
+
+	if (instance) {
+		adv = hci_find_adv_instance(hdev, instance);
+		if (!adv || !adv->adv_data_changed)
+			return 0;
+	}
+
+	len = eir_create_adv_data(hdev, instance, pdu.data);
+
+	pdu.cp.length = len;
+	pdu.cp.handle = instance;
+	pdu.cp.operation = LE_SET_ADV_DATA_OP_COMPLETE;
+	pdu.cp.frag_pref = LE_SET_ADV_DATA_NO_FRAG;
+
+	err = __hci_cmd_sync_status(hdev, HCI_OP_LE_SET_EXT_ADV_DATA,
+				    sizeof(pdu.cp) + len, &pdu.cp,
+				    HCI_CMD_TIMEOUT);
+	if (err)
+		return err;
+
+	/* Update data if the command succeed */
+	if (adv) {
+		adv->adv_data_changed = false;
+	} else {
+		memcpy(hdev->adv_data, pdu.data, len);
+		hdev->adv_data_len = len;
+	}
+
+	return 0;
+}
+
+static int hci_set_adv_data_sync(struct hci_dev *hdev, u8 instance)
+{
+	struct hci_cp_le_set_adv_data cp;
+	u8 len;
+
+	memset(&cp, 0, sizeof(cp));
+
+	len = eir_create_adv_data(hdev, instance, cp.data);
+
+	/* There's nothing to do if the data hasn't changed */
+	if (hdev->adv_data_len == len &&
+	    memcmp(cp.data, hdev->adv_data, len) == 0)
+		return 0;
+
+	memcpy(hdev->adv_data, cp.data, sizeof(cp.data));
+	hdev->adv_data_len = len;
+
+	cp.length = len;
+
+	return __hci_cmd_sync_status(hdev, HCI_OP_LE_SET_ADV_DATA,
+				     sizeof(cp), &cp, HCI_CMD_TIMEOUT);
+}
+
+int hci_update_adv_data_sync(struct hci_dev *hdev, u8 instance)
+{
+	if (!hci_dev_test_flag(hdev, HCI_LE_ENABLED))
+		return 0;
+
+	if (ext_adv_capable(hdev))
+		return hci_set_ext_adv_data_sync(hdev, instance);
+
+	return hci_set_adv_data_sync(hdev, instance);
+}
+
 int hci_setup_ext_adv_instance_sync(struct hci_dev *hdev, u8 instance)
 {
 	struct hci_cp_le_set_ext_adv_params cp;
+	struct hci_rp_le_set_ext_adv_params rp;
 	bool connectable;
 	u32 flags;
 	bdaddr_t random_addr;
@@ -1333,8 +1453,12 @@ int hci_setup_ext_adv_instance_sync(stru
 		cp.secondary_phy = HCI_ADV_PHY_1M;
 	}
 
-	err = __hci_cmd_sync_status(hdev, HCI_OP_LE_SET_EXT_ADV_PARAMS,
-				    sizeof(cp), &cp, HCI_CMD_TIMEOUT);
+	err = hci_set_ext_adv_params_sync(hdev, adv, &cp, &rp);
+	if (err)
+		return err;
+
+	/* Update adv data as tx power is known now */
+	err = hci_set_ext_adv_data_sync(hdev, cp.handle);
 	if (err)
 		return err;
 
@@ -1859,82 +1983,6 @@ int hci_le_terminate_big_sync(struct hci
 				     sizeof(cp), &cp, HCI_CMD_TIMEOUT);
 }
 
-static int hci_set_ext_adv_data_sync(struct hci_dev *hdev, u8 instance)
-{
-	struct {
-		struct hci_cp_le_set_ext_adv_data cp;
-		u8 data[HCI_MAX_EXT_AD_LENGTH];
-	} pdu;
-	u8 len;
-	struct adv_info *adv = NULL;
-	int err;
-
-	memset(&pdu, 0, sizeof(pdu));
-
-	if (instance) {
-		adv = hci_find_adv_instance(hdev, instance);
-		if (!adv || !adv->adv_data_changed)
-			return 0;
-	}
-
-	len = eir_create_adv_data(hdev, instance, pdu.data);
-
-	pdu.cp.length = len;
-	pdu.cp.handle = instance;
-	pdu.cp.operation = LE_SET_ADV_DATA_OP_COMPLETE;
-	pdu.cp.frag_pref = LE_SET_ADV_DATA_NO_FRAG;
-
-	err = __hci_cmd_sync_status(hdev, HCI_OP_LE_SET_EXT_ADV_DATA,
-				    sizeof(pdu.cp) + len, &pdu.cp,
-				    HCI_CMD_TIMEOUT);
-	if (err)
-		return err;
-
-	/* Update data if the command succeed */
-	if (adv) {
-		adv->adv_data_changed = false;
-	} else {
-		memcpy(hdev->adv_data, pdu.data, len);
-		hdev->adv_data_len = len;
-	}
-
-	return 0;
-}
-
-static int hci_set_adv_data_sync(struct hci_dev *hdev, u8 instance)
-{
-	struct hci_cp_le_set_adv_data cp;
-	u8 len;
-
-	memset(&cp, 0, sizeof(cp));
-
-	len = eir_create_adv_data(hdev, instance, cp.data);
-
-	/* There's nothing to do if the data hasn't changed */
-	if (hdev->adv_data_len == len &&
-	    memcmp(cp.data, hdev->adv_data, len) == 0)
-		return 0;
-
-	memcpy(hdev->adv_data, cp.data, sizeof(cp.data));
-	hdev->adv_data_len = len;
-
-	cp.length = len;
-
-	return __hci_cmd_sync_status(hdev, HCI_OP_LE_SET_ADV_DATA,
-				     sizeof(cp), &cp, HCI_CMD_TIMEOUT);
-}
-
-int hci_update_adv_data_sync(struct hci_dev *hdev, u8 instance)
-{
-	if (!hci_dev_test_flag(hdev, HCI_LE_ENABLED))
-		return 0;
-
-	if (ext_adv_capable(hdev))
-		return hci_set_ext_adv_data_sync(hdev, instance);
-
-	return hci_set_adv_data_sync(hdev, instance);
-}
-
 int hci_schedule_adv_instance_sync(struct hci_dev *hdev, u8 instance,
 				   bool force)
 {
@@ -6253,6 +6301,7 @@ static int hci_le_ext_directed_advertisi
 						struct hci_conn *conn)
 {
 	struct hci_cp_le_set_ext_adv_params cp;
+	struct hci_rp_le_set_ext_adv_params rp;
 	int err;
 	bdaddr_t random_addr;
 	u8 own_addr_type;
@@ -6294,8 +6343,12 @@ static int hci_le_ext_directed_advertisi
 	if (err)
 		return err;
 
-	err = __hci_cmd_sync_status(hdev, HCI_OP_LE_SET_EXT_ADV_PARAMS,
-				    sizeof(cp), &cp, HCI_CMD_TIMEOUT);
+	err = hci_set_ext_adv_params_sync(hdev, NULL, &cp, &rp);
+	if (err)
+		return err;
+
+	/* Update adv data as tx power is known now */
+	err = hci_set_ext_adv_data_sync(hdev, cp.handle);
 	if (err)
 		return err;
 


