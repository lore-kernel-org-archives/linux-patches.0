Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85E337522C;
	Sat, 28 Feb 2026 17:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301558; cv=none; b=OR/QN+xSxmJvTAq4EnLCa6sPGcwHTBT2M9Ysu+5ucUNNPWhFqYRXJEBrhRLRkEtjdni52Z1vZ/XxV624/3hUZV/gCgiXMY91/7gxrsJ3kwmsZkRrtWSl/BE+lLGMS+NqiYnhY2yulfbP1MhksbpR/GgAPEL3NYqyIJ4KRzbBwYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301558; c=relaxed/simple;
	bh=Qma7NC5BURQs7e7UjsZJDrlGWn7LL53tfVNmQ/NvUsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bkhy9Ms934UdhNS9Eds+yPb14WsAcz4vKeXuSUOeAa5rBayOFKSqyNRo70vNRJqVVv0cwm/lQ12gHDYf9mLTLT5IW4bHw/KzD58h00F7kpsx3SuENRtY1SObmKNeBDXGEGhoXNeCFiqmj42LM2T5oxRzSqd+qIs4C21+KMu/J70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JRpwoRxE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JRpwoRxE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1701C2BC87;
	Sat, 28 Feb 2026 17:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301558;
	bh=Qma7NC5BURQs7e7UjsZJDrlGWn7LL53tfVNmQ/NvUsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JRpwoRxESpsN50Y5xsNUYsayRlelfnEXFb3A9u8+kbdaVHaz1yvKanxWPwLsmYgDf
	 UpxXtDavCnbAq1+TV325biNK5RWTHN77x0ApmVKGGPlKbO8r7Bagt4KYyXCT2ADaY9
	 f8kXfeUi1J/af3/rRoY8uZ0ldeK3C9wKwZwFv2Cmz9qvUCCAqOnpvY1X7buIOim9En
	 eFFtraLki2pU5RBjnTPiE8wROODKlxe3c3QfbAHok7pTn1GjdH5CiDGLI0r2YeQLv7
	 5ghY4KsX5dlw53vvzu4EVEBL5XUYR1EBn/xQ6Ej2x5xvYVCHX+cntOW1GrlJpOB3W4
	 GlQH9FWE9BeYQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Michael Thalmeier <michael.thalmeier@hale.at>,
	stable@vger.kernel.org,
	syzbot+740e04c2a93467a0f8c8@syzkaller.appspotmail.com,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 742/752] net: nfc: nci: Fix parameter validation for packet data
Date: Sat, 28 Feb 2026 12:47:33 -0500
Message-ID: <20260228174750.1542406-742-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Michael Thalmeier <michael.thalmeier@hale.at>

[ Upstream commit 571dcbeb8e635182bb825ae758399831805693c2 ]

Since commit 9c328f54741b ("net: nfc: nci: Add parameter validation for
packet data") communication with nci nfc chips is not working any more.

The mentioned commit tries to fix access of uninitialized data, but
failed to understand that in some cases the data packet is of variable
length and can therefore not be compared to the maximum packet length
given by the sizeof(struct).

Fixes: 9c328f54741b ("net: nfc: nci: Add parameter validation for packet data")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Thalmeier <michael.thalmeier@hale.at>
Reported-by: syzbot+740e04c2a93467a0f8c8@syzkaller.appspotmail.com
Link: https://patch.msgid.link/20260218083000.301354-1-michael.thalmeier@hale.at
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/nci/ntf.c | 159 ++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 141 insertions(+), 18 deletions(-)

diff --git a/net/nfc/nci/ntf.c b/net/nfc/nci/ntf.c
index 418b84e2b2605..c96512bb86531 100644
--- a/net/nfc/nci/ntf.c
+++ b/net/nfc/nci/ntf.c
@@ -58,7 +58,7 @@ static int nci_core_conn_credits_ntf_packet(struct nci_dev *ndev,
 	struct nci_conn_info *conn_info;
 	int i;
 
-	if (skb->len < sizeof(struct nci_core_conn_credit_ntf))
+	if (skb->len < offsetofend(struct nci_core_conn_credit_ntf, num_entries))
 		return -EINVAL;
 
 	ntf = (struct nci_core_conn_credit_ntf *)skb->data;
@@ -68,6 +68,10 @@ static int nci_core_conn_credits_ntf_packet(struct nci_dev *ndev,
 	if (ntf->num_entries > NCI_MAX_NUM_CONN)
 		ntf->num_entries = NCI_MAX_NUM_CONN;
 
+	if (skb->len < offsetofend(struct nci_core_conn_credit_ntf, num_entries) +
+			ntf->num_entries * sizeof(struct conn_credit_entry))
+		return -EINVAL;
+
 	/* update the credits */
 	for (i = 0; i < ntf->num_entries; i++) {
 		ntf->conn_entries[i].conn_id =
@@ -138,23 +142,48 @@ static int nci_core_conn_intf_error_ntf_packet(struct nci_dev *ndev,
 static const __u8 *
 nci_extract_rf_params_nfca_passive_poll(struct nci_dev *ndev,
 					struct rf_tech_specific_params_nfca_poll *nfca_poll,
-					const __u8 *data)
+					const __u8 *data, ssize_t data_len)
 {
+	/* Check if we have enough data for sens_res (2 bytes) */
+	if (data_len < 2)
+		return ERR_PTR(-EINVAL);
+
 	nfca_poll->sens_res = __le16_to_cpu(*((__le16 *)data));
 	data += 2;
+	data_len -= 2;
+
+	/* Check if we have enough data for nfcid1_len (1 byte) */
+	if (data_len < 1)
+		return ERR_PTR(-EINVAL);
 
 	nfca_poll->nfcid1_len = min_t(__u8, *data++, NFC_NFCID1_MAXSIZE);
+	data_len--;
 
 	pr_debug("sens_res 0x%x, nfcid1_len %d\n",
 		 nfca_poll->sens_res, nfca_poll->nfcid1_len);
 
+	/* Check if we have enough data for nfcid1 */
+	if (data_len < nfca_poll->nfcid1_len)
+		return ERR_PTR(-EINVAL);
+
 	memcpy(nfca_poll->nfcid1, data, nfca_poll->nfcid1_len);
 	data += nfca_poll->nfcid1_len;
+	data_len -= nfca_poll->nfcid1_len;
+
+	/* Check if we have enough data for sel_res_len (1 byte) */
+	if (data_len < 1)
+		return ERR_PTR(-EINVAL);
 
 	nfca_poll->sel_res_len = *data++;
+	data_len--;
+
+	if (nfca_poll->sel_res_len != 0) {
+		/* Check if we have enough data for sel_res (1 byte) */
+		if (data_len < 1)
+			return ERR_PTR(-EINVAL);
 
-	if (nfca_poll->sel_res_len != 0)
 		nfca_poll->sel_res = *data++;
+	}
 
 	pr_debug("sel_res_len %d, sel_res 0x%x\n",
 		 nfca_poll->sel_res_len,
@@ -166,12 +195,21 @@ nci_extract_rf_params_nfca_passive_poll(struct nci_dev *ndev,
 static const __u8 *
 nci_extract_rf_params_nfcb_passive_poll(struct nci_dev *ndev,
 					struct rf_tech_specific_params_nfcb_poll *nfcb_poll,
-					const __u8 *data)
+					const __u8 *data, ssize_t data_len)
 {
+	/* Check if we have enough data for sensb_res_len (1 byte) */
+	if (data_len < 1)
+		return ERR_PTR(-EINVAL);
+
 	nfcb_poll->sensb_res_len = min_t(__u8, *data++, NFC_SENSB_RES_MAXSIZE);
+	data_len--;
 
 	pr_debug("sensb_res_len %d\n", nfcb_poll->sensb_res_len);
 
+	/* Check if we have enough data for sensb_res */
+	if (data_len < nfcb_poll->sensb_res_len)
+		return ERR_PTR(-EINVAL);
+
 	memcpy(nfcb_poll->sensb_res, data, nfcb_poll->sensb_res_len);
 	data += nfcb_poll->sensb_res_len;
 
@@ -181,14 +219,29 @@ nci_extract_rf_params_nfcb_passive_poll(struct nci_dev *ndev,
 static const __u8 *
 nci_extract_rf_params_nfcf_passive_poll(struct nci_dev *ndev,
 					struct rf_tech_specific_params_nfcf_poll *nfcf_poll,
-					const __u8 *data)
+					const __u8 *data, ssize_t data_len)
 {
+	/* Check if we have enough data for bit_rate (1 byte) */
+	if (data_len < 1)
+		return ERR_PTR(-EINVAL);
+
 	nfcf_poll->bit_rate = *data++;
+	data_len--;
+
+	/* Check if we have enough data for sensf_res_len (1 byte) */
+	if (data_len < 1)
+		return ERR_PTR(-EINVAL);
+
 	nfcf_poll->sensf_res_len = min_t(__u8, *data++, NFC_SENSF_RES_MAXSIZE);
+	data_len--;
 
 	pr_debug("bit_rate %d, sensf_res_len %d\n",
 		 nfcf_poll->bit_rate, nfcf_poll->sensf_res_len);
 
+	/* Check if we have enough data for sensf_res */
+	if (data_len < nfcf_poll->sensf_res_len)
+		return ERR_PTR(-EINVAL);
+
 	memcpy(nfcf_poll->sensf_res, data, nfcf_poll->sensf_res_len);
 	data += nfcf_poll->sensf_res_len;
 
@@ -198,22 +251,49 @@ nci_extract_rf_params_nfcf_passive_poll(struct nci_dev *ndev,
 static const __u8 *
 nci_extract_rf_params_nfcv_passive_poll(struct nci_dev *ndev,
 					struct rf_tech_specific_params_nfcv_poll *nfcv_poll,
-					const __u8 *data)
+					const __u8 *data, ssize_t data_len)
 {
+	/* Skip 1 byte (reserved) */
+	if (data_len < 1)
+		return ERR_PTR(-EINVAL);
+
 	++data;
+	data_len--;
+
+	/* Check if we have enough data for dsfid (1 byte) */
+	if (data_len < 1)
+		return ERR_PTR(-EINVAL);
+
 	nfcv_poll->dsfid = *data++;
+	data_len--;
+
+	/* Check if we have enough data for uid (8 bytes) */
+	if (data_len < NFC_ISO15693_UID_MAXSIZE)
+		return ERR_PTR(-EINVAL);
+
 	memcpy(nfcv_poll->uid, data, NFC_ISO15693_UID_MAXSIZE);
 	data += NFC_ISO15693_UID_MAXSIZE;
+
 	return data;
 }
 
 static const __u8 *
 nci_extract_rf_params_nfcf_passive_listen(struct nci_dev *ndev,
 					  struct rf_tech_specific_params_nfcf_listen *nfcf_listen,
-					  const __u8 *data)
+					  const __u8 *data, ssize_t data_len)
 {
+	/* Check if we have enough data for local_nfcid2_len (1 byte) */
+	if (data_len < 1)
+		return ERR_PTR(-EINVAL);
+
 	nfcf_listen->local_nfcid2_len = min_t(__u8, *data++,
 					      NFC_NFCID2_MAXSIZE);
+	data_len--;
+
+	/* Check if we have enough data for local_nfcid2 */
+	if (data_len < nfcf_listen->local_nfcid2_len)
+		return ERR_PTR(-EINVAL);
+
 	memcpy(nfcf_listen->local_nfcid2, data, nfcf_listen->local_nfcid2_len);
 	data += nfcf_listen->local_nfcid2_len;
 
@@ -364,7 +444,7 @@ static int nci_rf_discover_ntf_packet(struct nci_dev *ndev,
 	const __u8 *data;
 	bool add_target = true;
 
-	if (skb->len < sizeof(struct nci_rf_discover_ntf))
+	if (skb->len < offsetofend(struct nci_rf_discover_ntf, rf_tech_specific_params_len))
 		return -EINVAL;
 
 	data = skb->data;
@@ -380,26 +460,42 @@ static int nci_rf_discover_ntf_packet(struct nci_dev *ndev,
 	pr_debug("rf_tech_specific_params_len %d\n",
 		 ntf.rf_tech_specific_params_len);
 
+	if (skb->len < (data - skb->data) +
+			ntf.rf_tech_specific_params_len + sizeof(ntf.ntf_type))
+		return -EINVAL;
+
 	if (ntf.rf_tech_specific_params_len > 0) {
 		switch (ntf.rf_tech_and_mode) {
 		case NCI_NFC_A_PASSIVE_POLL_MODE:
 			data = nci_extract_rf_params_nfca_passive_poll(ndev,
-				&(ntf.rf_tech_specific_params.nfca_poll), data);
+				&(ntf.rf_tech_specific_params.nfca_poll), data,
+				ntf.rf_tech_specific_params_len);
+			if (IS_ERR(data))
+				return PTR_ERR(data);
 			break;
 
 		case NCI_NFC_B_PASSIVE_POLL_MODE:
 			data = nci_extract_rf_params_nfcb_passive_poll(ndev,
-				&(ntf.rf_tech_specific_params.nfcb_poll), data);
+				&(ntf.rf_tech_specific_params.nfcb_poll), data,
+				ntf.rf_tech_specific_params_len);
+			if (IS_ERR(data))
+				return PTR_ERR(data);
 			break;
 
 		case NCI_NFC_F_PASSIVE_POLL_MODE:
 			data = nci_extract_rf_params_nfcf_passive_poll(ndev,
-				&(ntf.rf_tech_specific_params.nfcf_poll), data);
+				&(ntf.rf_tech_specific_params.nfcf_poll), data,
+				ntf.rf_tech_specific_params_len);
+			if (IS_ERR(data))
+				return PTR_ERR(data);
 			break;
 
 		case NCI_NFC_V_PASSIVE_POLL_MODE:
 			data = nci_extract_rf_params_nfcv_passive_poll(ndev,
-				&(ntf.rf_tech_specific_params.nfcv_poll), data);
+				&(ntf.rf_tech_specific_params.nfcv_poll), data,
+				ntf.rf_tech_specific_params_len);
+			if (IS_ERR(data))
+				return PTR_ERR(data);
 			break;
 
 		default:
@@ -596,7 +692,7 @@ static int nci_rf_intf_activated_ntf_packet(struct nci_dev *ndev,
 	const __u8 *data;
 	int err = NCI_STATUS_OK;
 
-	if (skb->len < sizeof(struct nci_rf_intf_activated_ntf))
+	if (skb->len < offsetofend(struct nci_rf_intf_activated_ntf, rf_tech_specific_params_len))
 		return -EINVAL;
 
 	data = skb->data;
@@ -628,26 +724,41 @@ static int nci_rf_intf_activated_ntf_packet(struct nci_dev *ndev,
 	if (ntf.rf_interface == NCI_RF_INTERFACE_NFCEE_DIRECT)
 		goto listen;
 
+	if (skb->len < (data - skb->data) + ntf.rf_tech_specific_params_len)
+		return -EINVAL;
+
 	if (ntf.rf_tech_specific_params_len > 0) {
 		switch (ntf.activation_rf_tech_and_mode) {
 		case NCI_NFC_A_PASSIVE_POLL_MODE:
 			data = nci_extract_rf_params_nfca_passive_poll(ndev,
-				&(ntf.rf_tech_specific_params.nfca_poll), data);
+				&(ntf.rf_tech_specific_params.nfca_poll), data,
+				ntf.rf_tech_specific_params_len);
+			if (IS_ERR(data))
+				return -EINVAL;
 			break;
 
 		case NCI_NFC_B_PASSIVE_POLL_MODE:
 			data = nci_extract_rf_params_nfcb_passive_poll(ndev,
-				&(ntf.rf_tech_specific_params.nfcb_poll), data);
+				&(ntf.rf_tech_specific_params.nfcb_poll), data,
+				ntf.rf_tech_specific_params_len);
+			if (IS_ERR(data))
+				return -EINVAL;
 			break;
 
 		case NCI_NFC_F_PASSIVE_POLL_MODE:
 			data = nci_extract_rf_params_nfcf_passive_poll(ndev,
-				&(ntf.rf_tech_specific_params.nfcf_poll), data);
+				&(ntf.rf_tech_specific_params.nfcf_poll), data,
+				ntf.rf_tech_specific_params_len);
+			if (IS_ERR(data))
+				return -EINVAL;
 			break;
 
 		case NCI_NFC_V_PASSIVE_POLL_MODE:
 			data = nci_extract_rf_params_nfcv_passive_poll(ndev,
-				&(ntf.rf_tech_specific_params.nfcv_poll), data);
+				&(ntf.rf_tech_specific_params.nfcv_poll), data,
+				ntf.rf_tech_specific_params_len);
+			if (IS_ERR(data))
+				return -EINVAL;
 			break;
 
 		case NCI_NFC_A_PASSIVE_LISTEN_MODE:
@@ -657,7 +768,9 @@ static int nci_rf_intf_activated_ntf_packet(struct nci_dev *ndev,
 		case NCI_NFC_F_PASSIVE_LISTEN_MODE:
 			data = nci_extract_rf_params_nfcf_passive_listen(ndev,
 				&(ntf.rf_tech_specific_params.nfcf_listen),
-				data);
+				data, ntf.rf_tech_specific_params_len);
+			if (IS_ERR(data))
+				return -EINVAL;
 			break;
 
 		default:
@@ -668,6 +781,13 @@ static int nci_rf_intf_activated_ntf_packet(struct nci_dev *ndev,
 		}
 	}
 
+	if (skb->len < (data - skb->data) +
+			sizeof(ntf.data_exch_rf_tech_and_mode) +
+			sizeof(ntf.data_exch_tx_bit_rate) +
+			sizeof(ntf.data_exch_rx_bit_rate) +
+			sizeof(ntf.activation_params_len))
+		return -EINVAL;
+
 	ntf.data_exch_rf_tech_and_mode = *data++;
 	ntf.data_exch_tx_bit_rate = *data++;
 	ntf.data_exch_rx_bit_rate = *data++;
@@ -679,6 +799,9 @@ static int nci_rf_intf_activated_ntf_packet(struct nci_dev *ndev,
 	pr_debug("data_exch_rx_bit_rate 0x%x\n", ntf.data_exch_rx_bit_rate);
 	pr_debug("activation_params_len %d\n", ntf.activation_params_len);
 
+	if (skb->len < (data - skb->data) + ntf.activation_params_len)
+		return -EINVAL;
+
 	if (ntf.activation_params_len > 0) {
 		switch (ntf.rf_interface) {
 		case NCI_RF_INTERFACE_ISO_DEP:
-- 
2.51.0

