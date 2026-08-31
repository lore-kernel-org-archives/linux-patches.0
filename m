Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA1D4BB5D8;
	Mon, 31 Aug 2026 14:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184851; cv=none; b=RsNl2urITmJuNVDhoENz7nrs0XGogLp5puacgmVEyOl2su0ZXlfRl9wG/UFyIaLJUZkR0c/i8QK5xwcTLnyYphFBQa5bnSWedkNvqvNh2UsDnydViig1iJbHLdggUHUksE0QxE1kcTQi8crZVlwIOhf6UdeBpk/gT2CBIX6SSsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184851; c=relaxed/simple;
	bh=lSPDqRPkVqqdFcgoMXvWINUSxoF0wJ2zFEXXf8EzdNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K44xY52iJtjFWIKccLPAw7rgBwhapv+IVlpNZvnlmZGQ/8OrrdKKOV4rBy7XInr/5EFtdcyrOiWYUtkWDBY8HuGx5yRgw14+dJrMvDdnt2xPbGj1DcmdwYA2zhCkDtjtyW4H8OqyhcAnpH7ocQOCBsVkSqs2+jVgJ5N31nkG36w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q1x6uv1t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q1x6uv1t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 940DF1F00A3D;
	Mon, 31 Aug 2026 14:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184849;
	bh=iUsAcmf4brebkdsEuQ+l4G051HLDVjcDwu20ivks9C8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q1x6uv1tI4MHZxIjwHeIg9ZtwdeXUc0uRs05KJxaXTCxDlOjpa3FPWlC7BtSo5I48
	 kTYny2TvOXCpcDyyE4bLi2hXGNXCoHuhx8Sofk1yvO8cawRsR6TvbxxsbdOPZDpERR
	 nviaVpoxtTnehjTxtGbR0HyJjwNW77+lQxFX+Gkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 58/92] Bluetooth: ISO: use correct CIS order in Set CIG Parameters event
Date: Mon, 31 Aug 2026 15:34:56 +0200
Message-ID: <20260831133402.705000405@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.482388899@linuxfoundation.org>
References: <20260831133359.482388899@linuxfoundation.org>
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

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit 71e9588435c38112d6a8686d3d8e7cc1de8fe22c ]

The order of CIS handle array in Set CIG Parameters response shall match
the order of the CIS_ID array in the command (Core v5.3 Vol 4 Part E Sec
7.8.97).  We send CIS_IDs mainly in the order of increasing CIS_ID (but
with "last" CIS first if it has fixed CIG_ID).  In handling of the
reply, we currently assume this is also the same as the order of
hci_conn in hdev->conn_hash, but that is not true.

Match the correct hci_conn to the correct handle by matching them based
on the CIG+CIS combination.  The CIG+CIS combination shall be unique for
ISO_LINK hci_conn at state >= BT_BOUND, which we maintain in
hci_le_set_cig_params.

Fixes: 26afbd826ee3 ("Bluetooth: Add initial implementation of CIS connections")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 0acd4eeb4b22 ("Bluetooth: hci_event: validate LE Set CIG Parameters response")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/bluetooth/hci_core.h |    7 +++---
 net/bluetooth/hci_conn.c         |    4 +--
 net/bluetooth/hci_event.c        |   43 +++++++++++++++++++++++----------------
 3 files changed, 32 insertions(+), 22 deletions(-)

--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1192,14 +1192,15 @@ static inline struct hci_conn *hci_conn_
 			continue;
 
 		/* Match CIG ID if set */
-		if (cig != BT_ISO_QOS_CIG_UNSET && cig != c->iso_qos.ucast.cig)
+		if (cig != BT_ISO_QOS_CIG_UNSET && cig != c->iso_qos.cig)
 			continue;
 
 		/* Match CIS ID if set */
-		if (id != BT_ISO_QOS_CIS_UNSET && id != c->iso_qos.ucast.cis)
+		if (id != BT_ISO_QOS_CIS_UNSET && id != c->iso_qos.cis)
 			continue;
 
-		if (ba_type == c->dst_type && !bacmp(&c->dst, ba)) {
+		/* Match destination address if set */
+		if (!ba || (ba_type == c->dst_type && !bacmp(&c->dst, ba))) {
 			rcu_read_unlock();
 			return c;
 		}
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1862,8 +1862,8 @@ struct hci_conn *hci_bind_cis(struct hci
 {
 	struct hci_conn *cis;
 
-	cis = hci_conn_hash_lookup_cis(hdev, dst, dst_type, qos->ucast.cig,
-				       qos->ucast.cis);
+	cis = hci_conn_hash_lookup_cis(hdev, dst, dst_type, qos->cig,
+				       qos->cis);
 	if (!cis) {
 		cis = hci_conn_add_unset(hdev, ISO_LINK, dst, HCI_ROLE_MASTER);
 		if (!cis)
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3785,49 +3785,58 @@ static u8 hci_cc_le_set_cig_params(struc
 				   struct sk_buff *skb)
 {
 	struct hci_rp_le_set_cig_params *rp = data;
+	struct hci_cp_le_set_cig_params *cp;
 	struct hci_conn *conn;
-	int i = 0;
+	u8 status = rp->status;
+	int i;
 
 	bt_dev_dbg(hdev, "status 0x%2.2x", rp->status);
 
+	cp = hci_sent_cmd_data(hdev, HCI_OP_LE_SET_CIG_PARAMS);
+	if (!cp || rp->num_handles != cp->num_cis || rp->cig_id != cp->cig_id) {
+		bt_dev_err(hdev, "unexpected Set CIG Parameters response data");
+		status = HCI_ERROR_UNSPECIFIED;
+	}
+
 	hci_dev_lock(hdev);
 
-	if (rp->status) {
+	if (status) {
 		while ((conn = hci_conn_hash_lookup_cig(hdev, rp->cig_id))) {
 			conn->state = BT_CLOSED;
-			hci_connect_cfm(conn, rp->status);
+			hci_connect_cfm(conn, status);
 			hci_conn_del(conn);
 		}
 		goto unlock;
 	}
 
-	rcu_read_lock();
+	/* BLUETOOTH CORE SPECIFICATION Version 5.3 | Vol 4, Part E page 2553
+	 *
+	 * If the Status return parameter is zero, then the Controller shall
+	 * set the Connection_Handle arrayed return parameter to the connection
+	 * handle(s) corresponding to the CIS configurations specified in
+	 * the CIS_IDs command parameter, in the same order.
+	 */
+	for (i = 0; i < rp->num_handles; ++i) {
+		conn = hci_conn_hash_lookup_cis(hdev, NULL, 0, rp->cig_id,
+						cp->cis[i].cis_id);
+		if (!conn || !bacmp(&conn->dst, BDADDR_ANY))
+			continue;
 
-	list_for_each_entry_rcu(conn, &hdev->conn_hash.list, list) {
-		if (conn->type != ISO_LINK || conn->iso_qos.cig != rp->cig_id ||
-		    conn->state == BT_CONNECTED)
+		if (conn->state != BT_BOUND && conn->state != BT_CONNECT)
 			continue;
 
 		if (HCI_CONN_HANDLE_UNSET(conn->handle))
 			ida_free(&hdev->unset_handle_ida, conn->handle);
-		conn->handle = __le16_to_cpu(rp->handle[i++]);
+		conn->handle = __le16_to_cpu(rp->handle[i]);
 
 		bt_dev_dbg(hdev, "%p handle 0x%4.4x link %p", conn,
 			   conn->handle, conn->link);
 
 		/* Create CIS if LE is already connected */
-		if (conn->link && conn->link->state == BT_CONNECTED) {
-			rcu_read_unlock();
+		if (conn->link && conn->link->state == BT_CONNECTED)
 			hci_le_create_cis(conn->link);
-			rcu_read_lock();
-		}
-
-		if (i == rp->num_handles)
-			break;
 	}
 
-	rcu_read_unlock();
-
 unlock:
 	hci_dev_unlock(hdev);
 


