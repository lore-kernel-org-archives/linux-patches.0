Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83AE117E90E;
	Mon, 27 May 2024 19:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837045; cv=none; b=A2dwsMsoLqWJWzLBpQ6WUSTC5rPvadevcHrhfIMY0jM/RPfZmhyQ41s/B4Q6tSf7jJFlZ/sBefywXWjI3WUgo919YTg13nCBEDhkxqHNrphxjftfSre7N/MVYyfcdQ1UMMZtAnRtKw1WPBwN4OKpG7wAfwSRrhfNEQgYtnXUk0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837045; c=relaxed/simple;
	bh=1FRquM9QUc+xY8movR//Iw5rBmQEP4glLN4rop6zJNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o0lSYN3HmkbQQe05If6P2nKHiksJWdqUJ+hQ4yB38X/6XMiwRYvLeMSLxZy12VPgsksdSqRRQ5ij03WN3X7r8McPHIRcG6e3K6k7pvdihZuwmRRlsJuyzvD8hRBraaZS5+DtOuYSAlDls8vajAlaReyggZlT95ywv9sOlAC24G4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VTJgg3YA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VTJgg3YA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A92CC2BBFC;
	Mon, 27 May 2024 19:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837045;
	bh=1FRquM9QUc+xY8movR//Iw5rBmQEP4glLN4rop6zJNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VTJgg3YAKo4UekWey4AX+QmQT5KeCuXGxVvVZvPWLAhlp9q/sFLsoImMVtktJXM0h
	 oSnugkjj7iZX90Ul9OaMZc6fE8iTlhci8HoX2QTDs7erAVpTxYtVcsIuA73Bf0kbOf
	 z1D7wE3yZIKj8jM1lj9HjqPhXOdmvQVpwXg/P/30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 272/427] Bluetooth: hci_conn, hci_sync: Use __counted_by() to avoid -Wfamnae warnings
Date: Mon, 27 May 2024 20:55:19 +0200
Message-ID: <20240527185627.855956313@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

From: Gustavo A. R. Silva <gustavoars@kernel.org>

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
Stable-dep-of: e77f43d531af ("Bluetooth: hci_core: Fix not handling hdev->le_num_of_adv_sets=1")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci.h |  8 ++--
 net/bluetooth/hci_event.c   |  3 +-
 net/bluetooth/hci_sync.c    | 84 +++++++++++++++----------------------
 3 files changed, 40 insertions(+), 55 deletions(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 4dd540a3f9250..f187510428ca6 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -1921,7 +1921,7 @@ struct hci_cp_le_set_ext_adv_data {
 	__u8  operation;
 	__u8  frag_pref;
 	__u8  length;
-	__u8  data[];
+	__u8  data[] __counted_by(length);
 } __packed;
 
 #define HCI_OP_LE_SET_EXT_SCAN_RSP_DATA		0x2038
@@ -1930,7 +1930,7 @@ struct hci_cp_le_set_ext_scan_rsp_data {
 	__u8  operation;
 	__u8  frag_pref;
 	__u8  length;
-	__u8  data[];
+	__u8  data[] __counted_by(length);
 } __packed;
 
 #define HCI_OP_LE_SET_EXT_ADV_ENABLE		0x2039
@@ -1956,7 +1956,7 @@ struct hci_cp_le_set_per_adv_data {
 	__u8  handle;
 	__u8  operation;
 	__u8  length;
-	__u8  data[];
+	__u8  data[] __counted_by(length);
 } __packed;
 
 #define HCI_OP_LE_SET_PER_ADV_ENABLE		0x2040
@@ -2057,7 +2057,7 @@ struct hci_cis {
 
 struct hci_cp_le_create_cis {
 	__u8    num_cis;
-	struct hci_cis cis[];
+	struct hci_cis cis[] __counted_by(num_cis);
 } __packed;
 
 #define HCI_OP_LE_REMOVE_CIG			0x2065
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 33fac5cab1a8d..cce73749f2dce 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -4250,7 +4250,7 @@ static void hci_cs_le_create_cis(struct hci_dev *hdev, u8 status)
 	hci_dev_lock(hdev);
 
 	/* Remove connection if command failed */
-	for (i = 0; cp->num_cis; cp->num_cis--, i++) {
+	for (i = 0; i < cp->num_cis; i++) {
 		struct hci_conn *conn;
 		u16 handle;
 
@@ -4266,6 +4266,7 @@ static void hci_cs_le_create_cis(struct hci_dev *hdev, u8 status)
 			hci_conn_del(conn);
 		}
 	}
+	cp->num_cis = 0;
 
 	if (pending)
 		hci_le_create_cis_pending(hdev);
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 5e4ec698e6e3b..4f736ff4cda23 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -1235,31 +1235,27 @@ int hci_setup_ext_adv_instance_sync(struct hci_dev *hdev, u8 instance)
 
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
@@ -1267,7 +1263,7 @@ static int hci_set_ext_scan_rsp_data_sync(struct hci_dev *hdev, u8 instance)
 	if (adv) {
 		adv->scan_rsp_changed = false;
 	} else {
-		memcpy(hdev->scan_rsp_data, pdu.data, len);
+		memcpy(hdev->scan_rsp_data, pdu->data, len);
 		hdev->scan_rsp_data_len = len;
 	}
 
@@ -1411,14 +1407,10 @@ static int hci_set_per_adv_params_sync(struct hci_dev *hdev, u8 instance,
 
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
 
@@ -1426,14 +1418,14 @@ static int hci_set_per_adv_data_sync(struct hci_dev *hdev, u8 instance)
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
 
@@ -1727,31 +1719,27 @@ int hci_le_terminate_big_sync(struct hci_dev *hdev, u8 handle, u8 reason)
 
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
 
-	len = eir_create_adv_data(hdev, instance, pdu.data);
+	len = eir_create_adv_data(hdev, instance, pdu->data);
 
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
@@ -1760,7 +1748,7 @@ static int hci_set_ext_adv_data_sync(struct hci_dev *hdev, u8 instance)
 	if (adv) {
 		adv->adv_data_changed = false;
 	} else {
-		memcpy(hdev->adv_data, pdu.data, len);
+		memcpy(hdev->adv_data, pdu->data, len);
 		hdev->adv_data_len = len;
 	}
 
@@ -6389,10 +6377,8 @@ static int hci_le_create_conn_sync(struct hci_dev *hdev, void *data)
 
 int hci_le_create_cis_sync(struct hci_dev *hdev)
 {
-	struct {
-		struct hci_cp_le_create_cis cp;
-		struct hci_cis cis[0x1f];
-	} cmd;
+	DEFINE_FLEX(struct hci_cp_le_create_cis, cmd, cis, num_cis, 0x1f);
+	size_t aux_num_cis = 0;
 	struct hci_conn *conn;
 	u8 cig = BT_ISO_QOS_CIG_UNSET;
 
@@ -6419,8 +6405,6 @@ int hci_le_create_cis_sync(struct hci_dev *hdev)
 	 * remains pending.
 	 */
 
-	memset(&cmd, 0, sizeof(cmd));
-
 	hci_dev_lock(hdev);
 
 	rcu_read_lock();
@@ -6457,7 +6441,7 @@ int hci_le_create_cis_sync(struct hci_dev *hdev)
 		goto done;
 
 	list_for_each_entry_rcu(conn, &hdev->conn_hash.list, list) {
-		struct hci_cis *cis = &cmd.cis[cmd.cp.num_cis];
+		struct hci_cis *cis = &cmd->cis[aux_num_cis];
 
 		if (hci_conn_check_create_cis(conn) ||
 		    conn->iso_qos.ucast.cig != cig)
@@ -6466,25 +6450,25 @@ int hci_le_create_cis_sync(struct hci_dev *hdev)
 		set_bit(HCI_CONN_CREATE_CIS, &conn->flags);
 		cis->acl_handle = cpu_to_le16(conn->parent->handle);
 		cis->cis_handle = cpu_to_le16(conn->handle);
-		cmd.cp.num_cis++;
+		aux_num_cis++;
 
-		if (cmd.cp.num_cis >= ARRAY_SIZE(cmd.cis))
+		if (aux_num_cis >= 0x1f)
 			break;
 	}
+	cmd->num_cis = aux_num_cis;
 
 done:
 	rcu_read_unlock();
 
 	hci_dev_unlock(hdev);
 
-	if (!cmd.cp.num_cis)
+	if (!aux_num_cis)
 		return 0;
 
 	/* Wait for HCI_LE_CIS_Established */
 	return __hci_cmd_sync_status_sk(hdev, HCI_OP_LE_CREATE_CIS,
-					sizeof(cmd.cp) + sizeof(cmd.cis[0]) *
-					cmd.cp.num_cis, &cmd,
-					HCI_EVT_LE_CIS_ESTABLISHED,
+					struct_size(cmd, cis, cmd->num_cis),
+					cmd, HCI_EVT_LE_CIS_ESTABLISHED,
 					conn->conn_timeout, NULL);
 }
 
-- 
2.43.0



