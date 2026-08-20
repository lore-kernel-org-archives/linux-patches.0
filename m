Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8A319E992;
	Thu, 20 Aug 2026 17:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248481; cv=none; b=hZ9VH9pmj0rcnYrgfqrqN5gWcP9dEo7EIdSLiaVkcLW7kAvt0nH2+5oaduWza/gIm4k1n3Q4kYWvVlnspLPLfXYd8pPD3h24Jbe9pCHc8N2l0qQlNlHAgWHeToVNgD/iWiv7aJPEtucgKpSfa/z7mJSqkEx0cxpc4+JENKFRVeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248481; c=relaxed/simple;
	bh=MM6re+p3sxiric5rplYzW9aqUMKt0NTSNnrMvICCddg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LmHQtIk2f1mlBHxE0Ty/zpEMv7XQllufJIlyZEUedmt2isRmRknVz9D/KMj5t1Yd075f07F18WdiPwvZohFbMbfZap6Kc89foZQVhuji8XOH9nUZ3iuCN63qBqQUNeOFke9CVMcz2TgEKShf5VtZvgkqAYRmQfMfV2m46A6qAPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QZzhKeAe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QZzhKeAe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2506F1F000E9;
	Thu, 20 Aug 2026 17:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248479;
	bh=1et/wcbnlwCwC9TwUG1oGZ47FON/aogAlB+ddNb0UxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QZzhKeAehalG2wVfSQoLCj7EXlbBIBiQ64jWh20kbHUHz5zreRCGAopUmesLpGmKF
	 VPHawICnqs5yNy0yQxhKjx4aKd/L5FtPsuKrlIwE5rt7FBWa+lp/JMkAF2L3NhuTle
	 h6xUo8OagnW6V5JW21B/z20KJ8/Cy8VENYXVeb/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 243/303] Bluetooth: hci_conn, hci_sync: Use __counted_by() to avoid -Wfamnae warnings
Date: Thu, 20 Aug 2026 16:56:19 +0200
Message-ID: <20260820145300.750113570@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Gustavo A. R. Silva" <gustavoars@kernel.org>

[ Upstream commit c4585edf708edb5277a3cc4b8581ccb833f3307d ]

Prepare for the coming implementation by GCC and Clang of the
__counted_by attribute. Flexible array members annotated with
__counted_by can have their accesses bounds-checked at run-time
via CONFIG_UBSAN_BOUNDS (for array indexing) and CONFIG_FORTIFY_SOURCE
(for strcpy/memcpy-family functions).

Also, -Wflex-array-member-not-at-end is coming in GCC-14, and we are
getting ready to enable it globally.

So, use the `DEFINE_FLEX()` helper for multiple on-stack definitions
of a flexible structure where the size of the flexible-array member
is known at compile-time, and refactor the rest of the code,
accordingly.

Notice that, due to the use of `__counted_by()` in `struct
hci_cp_le_create_cis`, the for loop in function `hci_cs_le_create_cis()`
had to be modified. Once the index `i`, through which `cp->cis[i]` is
accessed, falls in the interval [0, cp->num_cis), `cp->num_cis` cannot
be decremented all the way down to zero while accessing `cp->cis[]`:

net/bluetooth/hci_event.c:4310:
4310    for (i = 0; cp->num_cis; cp->num_cis--, i++) {
                ...
4314            handle = __le16_to_cpu(cp->cis[i].cis_handle);

otherwise, only half (one iteration before `cp->num_cis == i`) or half
plus one (one iteration before `cp->num_cis < i`) of the items in the
array will be accessed before running into an out-of-bounds issue. So,
in order to avoid this, set `cp->num_cis` to zero just after the for
loop.

Also, make use of `aux_num_cis` variable to update `cmd->num_cis` after
a `list_for_each_entry_rcu()` loop.

With these changes, fix the following warnings:
net/bluetooth/hci_sync.c:1239:56: warning: structure containing a flexible
array member is not at the end of another structure
[-Wflex-array-member-not-at-end]
net/bluetooth/hci_sync.c:1415:51: warning: structure containing a flexible
array member is not at the end of another structure
[-Wflex-array-member-not-at-end]
net/bluetooth/hci_sync.c:1731:51: warning: structure containing a flexible
array member is not at the end of another structure
[-Wflex-array-member-not-at-end]
net/bluetooth/hci_sync.c:6497:45: warning: structure containing a flexible
array member is not at the end of another structure
[-Wflex-array-member-not-at-end]

Link: https://github.com/KSPP/linux/issues/202
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: cdc36db204ff ("Bluetooth: hci_sync: Fix advertising data UAFs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_event.c |    3 +-
 net/bluetooth/hci_sync.c  |   62 ++++++++++++++++++----------------------------
 2 files changed, 27 insertions(+), 38 deletions(-)

--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -4205,7 +4205,7 @@ static void hci_cs_le_create_cis(struct
 	hci_dev_lock(hdev);
 
 	/* Remove connection if command failed */
-	for (i = 0; cp->num_cis; cp->num_cis--, i++) {
+	for (i = 0; i < cp->num_cis; i++) {
 		struct hci_conn *conn;
 		u16 handle;
 
@@ -4218,6 +4218,7 @@ static void hci_cs_le_create_cis(struct
 			hci_conn_del(conn);
 		}
 	}
+	cp->num_cis = 0;
 
 	hci_dev_unlock(hdev);
 }
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -1285,32 +1285,28 @@ hci_set_ext_adv_params_sync(struct hci_d
 
 static int hci_set_ext_adv_data_sync(struct hci_dev *hdev, u8 instance)
 {
-	struct {
-		struct hci_cp_le_set_ext_adv_data cp;
-		u8 data[HCI_MAX_EXT_AD_LENGTH];
-	} pdu;
+	DEFINE_FLEX(struct hci_cp_le_set_ext_adv_data, pdu, data, length,
+		    HCI_MAX_EXT_AD_LENGTH);
 	u8 len;
 	struct adv_info *adv = NULL;
 	int err;
 
-	memset(&pdu, 0, sizeof(pdu));
-
 	if (instance) {
 		adv = hci_find_adv_instance(hdev, instance);
 		if (!adv || !adv->adv_data_changed)
 			return 0;
 	}
 
-	len = eir_create_adv_data(hdev, instance, pdu.data,
+	len = eir_create_adv_data(hdev, instance, pdu->data,
 				  HCI_MAX_EXT_AD_LENGTH);
 
-	pdu.cp.length = len;
-	pdu.cp.handle = instance;
-	pdu.cp.operation = LE_SET_ADV_DATA_OP_COMPLETE;
-	pdu.cp.frag_pref = LE_SET_ADV_DATA_NO_FRAG;
+	pdu->length = len;
+	pdu->handle = instance;
+	pdu->operation = LE_SET_ADV_DATA_OP_COMPLETE;
+	pdu->frag_pref = LE_SET_ADV_DATA_NO_FRAG;
 
 	err = __hci_cmd_sync_status(hdev, HCI_OP_LE_SET_EXT_ADV_DATA,
-				    sizeof(pdu.cp) + len, &pdu.cp,
+				    struct_size(pdu, data, len), pdu,
 				    HCI_CMD_TIMEOUT);
 	if (err)
 		return err;
@@ -1319,7 +1315,7 @@ static int hci_set_ext_adv_data_sync(str
 	if (adv) {
 		adv->adv_data_changed = false;
 	} else {
-		memcpy(hdev->adv_data, pdu.data, len);
+		memcpy(hdev->adv_data, pdu->data, len);
 		hdev->adv_data_len = len;
 	}
 
@@ -1502,31 +1498,27 @@ int hci_setup_ext_adv_instance_sync(stru
 
 static int hci_set_ext_scan_rsp_data_sync(struct hci_dev *hdev, u8 instance)
 {
-	struct {
-		struct hci_cp_le_set_ext_scan_rsp_data cp;
-		u8 data[HCI_MAX_EXT_AD_LENGTH];
-	} pdu;
+	DEFINE_FLEX(struct hci_cp_le_set_ext_scan_rsp_data, pdu, data, length,
+		    HCI_MAX_EXT_AD_LENGTH);
 	u8 len;
 	struct adv_info *adv = NULL;
 	int err;
 
-	memset(&pdu, 0, sizeof(pdu));
-
 	if (instance) {
 		adv = hci_find_adv_instance(hdev, instance);
 		if (!adv || !adv->scan_rsp_changed)
 			return 0;
 	}
 
-	len = eir_create_scan_rsp(hdev, instance, pdu.data);
+	len = eir_create_scan_rsp(hdev, instance, pdu->data);
 
-	pdu.cp.handle = instance;
-	pdu.cp.length = len;
-	pdu.cp.operation = LE_SET_ADV_DATA_OP_COMPLETE;
-	pdu.cp.frag_pref = LE_SET_ADV_DATA_NO_FRAG;
+	pdu->handle = instance;
+	pdu->length = len;
+	pdu->operation = LE_SET_ADV_DATA_OP_COMPLETE;
+	pdu->frag_pref = LE_SET_ADV_DATA_NO_FRAG;
 
 	err = __hci_cmd_sync_status(hdev, HCI_OP_LE_SET_EXT_SCAN_RSP_DATA,
-				    sizeof(pdu.cp) + len, &pdu.cp,
+				    struct_size(pdu, data, len), pdu,
 				    HCI_CMD_TIMEOUT);
 	if (err)
 		return err;
@@ -1534,7 +1526,7 @@ static int hci_set_ext_scan_rsp_data_syn
 	if (adv) {
 		adv->scan_rsp_changed = false;
 	} else {
-		memcpy(hdev->scan_rsp_data, pdu.data, len);
+		memcpy(hdev->scan_rsp_data, pdu->data, len);
 		hdev->scan_rsp_data_len = len;
 	}
 
@@ -1676,14 +1668,10 @@ static int hci_set_per_adv_params_sync(s
 
 static int hci_set_per_adv_data_sync(struct hci_dev *hdev, u8 instance)
 {
-	struct {
-		struct hci_cp_le_set_per_adv_data cp;
-		u8 data[HCI_MAX_PER_AD_LENGTH];
-	} pdu;
+	DEFINE_FLEX(struct hci_cp_le_set_per_adv_data, pdu, data, length,
+		    HCI_MAX_PER_AD_LENGTH);
 	u8 len;
 
-	memset(&pdu, 0, sizeof(pdu));
-
 	if (instance) {
 		struct adv_info *adv = hci_find_adv_instance(hdev, instance);
 
@@ -1691,14 +1679,14 @@ static int hci_set_per_adv_data_sync(str
 			return 0;
 	}
 
-	len = eir_create_per_adv_data(hdev, instance, pdu.data);
+	len = eir_create_per_adv_data(hdev, instance, pdu->data);
 
-	pdu.cp.length = len;
-	pdu.cp.handle = instance;
-	pdu.cp.operation = LE_SET_ADV_DATA_OP_COMPLETE;
+	pdu->length = len;
+	pdu->handle = instance;
+	pdu->operation = LE_SET_ADV_DATA_OP_COMPLETE;
 
 	return __hci_cmd_sync_status(hdev, HCI_OP_LE_SET_PER_ADV_DATA,
-				     sizeof(pdu.cp) + len, &pdu,
+				     struct_size(pdu, data, len), pdu,
 				     HCI_CMD_TIMEOUT);
 }
 


