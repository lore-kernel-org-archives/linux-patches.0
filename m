Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB24C492515;
	Mon, 31 Aug 2026 14:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788185135; cv=none; b=naLaLLd7AL+LZLWDeWLGMPEsc3VSmnJBUcoInk7C9SIZCR++7/hmI98qvJHYVfproUtfTsHps1kSVYKoYVTyxJcMEBxGAyOJ4iQgkG06CvY0kjQ9lIFuI0z3oymlxc8KQunqLn9zEbo3QDHpvskaTxatlamX/p7fMDYuCbmZN5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788185135; c=relaxed/simple;
	bh=K1ejekOuMaVbkqVrcC9fLcfTcWbjm9L7i0AlQlEom6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ArpuYhEAMtSOTzziTNllPAzK3bUkX4QTA2bEJ+5BExfMXK4Fght7n8x5uumcGWWaDy6TScIZE3DBa2q+oONu0XwJxy5QcOI933O2ZvYxtpV5kdwOjDXKuclXfs8OK9hrGt9kj47HOo1su6NeA7R7Dz4rfvBETInJDcGx3HVMLRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OMDO5zCg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OMDO5zCg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8651E1F00A3F;
	Mon, 31 Aug 2026 14:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788185133;
	bh=vY0ai7rVZZ1Lt6gNOsdszWnwBY0fsoHXkm0ejJhuEFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OMDO5zCgZTPHmlr9oOFI1SDVwgnB2bRKf5VzozsqSPOQwWiTTL/4h22AdyDeBaitc
	 ewbivD2u6y3ZgoYg1v0uMbpG+A3b6eMtvz+wvfsOTO/7pOH4+Qm1Wvf28kxhN4xjs2
	 bvK4iOm82rQx3x8jbdEYD1KBdN4oPTT7MhRpLRi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 28/69] nfc: nci: add data_len bound checks to activation parameter extractors
Date: Mon, 31 Aug 2026 15:35:01 +0200
Message-ID: <20260831133359.870308911@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133358.601894154@linuxfoundation.org>
References: <20260831133358.601894154@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

[ Upstream commit 0428fa2c22e2ba0cff766d3b80d461e149102045 ]

nci_extract_activation_params_iso_dep() and
nci_extract_activation_params_nfc_dep() read an inner length byte from
the NCI RF_INTF_ACTIVATED_NTF payload and use it to memcpy() into fixed
kernel buffers, but neither function receives the caller-validated
activation_params_len.  A crafted NCI notification with
activation_params_len=1 and an inner length byte of up to 20 (NFC-A) or
50 (NFC-B) causes memcpy() to read that many bytes past the one valid
byte in the activation params region -- a slab out-of-bounds read of
kernel memory adjacent to the NCI skb.

The sibling nci_extract_rf_params_*() family was given equivalent
protection by commit 571dcbeb8e63 ("net: nfc: nci: Fix parameter
validation for packet data"), but the two activation parameter
extractors were not updated at that time.

Add a data_len parameter to both functions, guard against an empty
region before consuming the inner length byte, decrement the remaining
count after consuming it, and clamp the copy length to what is actually
available.  Update both call sites to pass ntf.activation_params_len,
which is already validated against the skb at ntf.c:801.

Fixes: e8c0dacd9836 ("NFC: Update names and structs to NCI spec 1.0 d18")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Link: https://patch.msgid.link/20260612-b4-disp-6d52d8b0-v3-1-e26221f8826d@proton.me
Signed-off-by: David Heidelberg <david@ixit.cz>
[ Replaced `NFC_ATS_MAXSIZE` with the literal `20` since that macro doesn't exist in this tree. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/nfc/nci/ntf.c |   26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

--- a/net/nfc/nci/ntf.c
+++ b/net/nfc/nci/ntf.c
@@ -525,15 +525,19 @@ static int nci_rf_discover_ntf_packet(st
 
 static int nci_extract_activation_params_iso_dep(struct nci_dev *ndev,
 						 struct nci_rf_intf_activated_ntf *ntf,
-						 const __u8 *data)
+						 const __u8 *data, __u8 data_len)
 {
 	struct activation_params_nfca_poll_iso_dep *nfca_poll;
 	struct activation_params_nfcb_poll_iso_dep *nfcb_poll;
 
 	switch (ntf->activation_rf_tech_and_mode) {
 	case NCI_NFC_A_PASSIVE_POLL_MODE:
+		if (data_len < 1)
+			return NCI_STATUS_RF_PROTOCOL_ERROR;
 		nfca_poll = &ntf->activation_params.nfca_poll_iso_dep;
 		nfca_poll->rats_res_len = min_t(__u8, *data++, 20);
+		data_len--;
+		nfca_poll->rats_res_len = min_t(__u8, nfca_poll->rats_res_len, data_len);
 		pr_debug("rats_res_len %d\n", nfca_poll->rats_res_len);
 		if (nfca_poll->rats_res_len > 0) {
 			memcpy(nfca_poll->rats_res,
@@ -542,8 +546,12 @@ static int nci_extract_activation_params
 		break;
 
 	case NCI_NFC_B_PASSIVE_POLL_MODE:
+		if (data_len < 1)
+			return NCI_STATUS_RF_PROTOCOL_ERROR;
 		nfcb_poll = &ntf->activation_params.nfcb_poll_iso_dep;
 		nfcb_poll->attrib_res_len = min_t(__u8, *data++, 50);
+		data_len--;
+		nfcb_poll->attrib_res_len = min_t(__u8, nfcb_poll->attrib_res_len, data_len);
 		pr_debug("attrib_res_len %d\n", nfcb_poll->attrib_res_len);
 		if (nfcb_poll->attrib_res_len > 0) {
 			memcpy(nfcb_poll->attrib_res,
@@ -562,7 +570,7 @@ static int nci_extract_activation_params
 
 static int nci_extract_activation_params_nfc_dep(struct nci_dev *ndev,
 						 struct nci_rf_intf_activated_ntf *ntf,
-						 const __u8 *data)
+						 const __u8 *data, __u8 data_len)
 {
 	struct activation_params_poll_nfc_dep *poll;
 	struct activation_params_listen_nfc_dep *listen;
@@ -570,9 +578,13 @@ static int nci_extract_activation_params
 	switch (ntf->activation_rf_tech_and_mode) {
 	case NCI_NFC_A_PASSIVE_POLL_MODE:
 	case NCI_NFC_F_PASSIVE_POLL_MODE:
+		if (data_len < 1)
+			return NCI_STATUS_RF_PROTOCOL_ERROR;
 		poll = &ntf->activation_params.poll_nfc_dep;
 		poll->atr_res_len = min_t(__u8, *data++,
 					  NFC_ATR_RES_MAXSIZE - 2);
+		data_len--;
+		poll->atr_res_len = min_t(__u8, poll->atr_res_len, data_len);
 		pr_debug("atr_res_len %d\n", poll->atr_res_len);
 		if (poll->atr_res_len > 0)
 			memcpy(poll->atr_res, data, poll->atr_res_len);
@@ -580,9 +592,13 @@ static int nci_extract_activation_params
 
 	case NCI_NFC_A_PASSIVE_LISTEN_MODE:
 	case NCI_NFC_F_PASSIVE_LISTEN_MODE:
+		if (data_len < 1)
+			return NCI_STATUS_RF_PROTOCOL_ERROR;
 		listen = &ntf->activation_params.listen_nfc_dep;
 		listen->atr_req_len = min_t(__u8, *data++,
 					    NFC_ATR_REQ_MAXSIZE - 2);
+		data_len--;
+		listen->atr_req_len = min_t(__u8, listen->atr_req_len, data_len);
 		pr_debug("atr_req_len %d\n", listen->atr_req_len);
 		if (listen->atr_req_len > 0)
 			memcpy(listen->atr_req, data, listen->atr_req_len);
@@ -790,12 +806,14 @@ static int nci_rf_intf_activated_ntf_pac
 		switch (ntf.rf_interface) {
 		case NCI_RF_INTERFACE_ISO_DEP:
 			err = nci_extract_activation_params_iso_dep(ndev,
-								    &ntf, data);
+								    &ntf, data,
+								    ntf.activation_params_len);
 			break;
 
 		case NCI_RF_INTERFACE_NFC_DEP:
 			err = nci_extract_activation_params_nfc_dep(ndev,
-								    &ntf, data);
+								    &ntf, data,
+								    ntf.activation_params_len);
 			break;
 
 		case NCI_RF_INTERFACE_FRAME:


