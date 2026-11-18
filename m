Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026717;
	b=rZNHL01aGImvT5NZ3I4O1AOE5Q94ZucbJXFzC5Dv062gk1R0XRr/dzPx7PnZDkgu0x+i
	 6XYe3kQDEJpIJgE2pmQApLlu7pIlCpWUUr4nAuhefM1AhI/EXC8dkHY+GlStdndGdt576
	 NTPMt7TNFTOsoIRKd7mvQaluUC54nUMrPoFlZmNmxWkBusxAx7bNqGGaow4tJQUrVwepZ
	 D48ozDYo/UaJsYdp2zWPY69c5wKOuuZQIC2nVEvidTSAcO/whOTzyHGu4waT61wD7gMa1
	 /UvVk5tnk97aVyq1pYV2qQf8971JzI9laJciuzvq1APQhgKcGbTHhsU4QeAWxfwujyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026717;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uVoe/RI32w19iWnDszSmlW3Lr3478c0JmPzEB4GnoZ4=;
	b=D/LE4Orp0UNED3aV5g7VWwE4P5e19Qah6YvIo9Bav0ry8GRyfGmZv30a0awwiqtJRFZM
	 vd+EJqgSHazPP3W86nx+KWXW89v3amIcoj2yrkeTklZfCMLk9oE994B338M2VlOPjQkvO
	 QimJtP8NQqtCsKZo4a1KR/sI5RHvhx3LyW+Fo/74MNzk9+ix0aDNOwe065gFf8KaarVUD
	 fwbTXroBG7R72I/VIKAkm/+EZ0g4YAAhcMN0FPbPJHpPzEwu7KJ4Tls7ptOhsIdSsYnr/
	 A0TnqH1oVtDch3DrDOdSbdFg75znsZf3Eqbwh4EWdUpi90NxA8vQvJbv1BBxvJn4AvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ktxODDiR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A48D606A31C;
	Wed, 18 Nov 2026 18:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ktxODDiR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FD9D1F000C4;
	Wed, 18 Nov 2026 18:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026717;
	bh=uVoe/RI32w19iWnDszSmlW3Lr3478c0JmPzEB4GnoZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ktxODDiRhaXk+i3VV7EKOS5qEmq2PSJU6R0Yy9JATWpU0iqMQf3D4mgm64IyGI1tX
	 if8ywjXni/pvcqX4sj+ai4syZCVqi9zhHqA9K+R5DDzisb/kiBZ1/CRb6M2NUj9mIc
	 ZFtnFqFihLgEZibGoWUtVOW3aanebpN4Fc6IjhjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1534/2151] Bluetooth: HCI: Fix tracking of instances sharing handle 0x00
Date: Wed, 18 Nov 2026 15:54:29 +0100
Message-ID: <20261118150217.756502629@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 1bfecdbd031711e5205ae78f3b8c296e5a53bc55 ]

When the controller supports a single advertising set, instance 1 uses
handle 0x00 which is the same handle used by instance 0 (Global
Advertising), but hci_cc_le_set_ext_adv_enable would lookup the instance
using the handle as instance identifier, marking instance 0 as
enabled/disabled instead of instance 1, leaving its state out of sync.

Fix this by matching instances by handle and, for handle 0x00, using
hdev->cur_adv_instance, now set when enabling an instance, to determine
which instance owns the set. Also disable the instance sharing the
advertising set of instance 0 before overriding it.

Fixes: e77f43d531af ("Bluetooth: hci_core: Fix not handling hdev->le_num_of_adv_sets=1")
Assisted-by: OpenCode:claude-opus-5.5
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 47 ++++++++++++++++++++++++++++++---------
 net/bluetooth/hci_sync.c  | 35 ++++++++++++++++++++++++++++-
 2 files changed, 70 insertions(+), 12 deletions(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 1268318d5624e..572f195f09c13 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -1584,6 +1584,39 @@ static u8 hci_cc_le_set_adv_enable(struct hci_dev *hdev, void *data,
 	return rp->status;
 }
 
+/* Update the enabled state of the instance(s) using the advertising set
+ * identified by handle.
+ *
+ * Instances may share handle 0x00 with instance 0 (Global Advertising), e.g.
+ * when the controller supports a single advertising set, in which case the
+ * set is owned by the instance last enabled (hdev->cur_adv_instance) and any
+ * other instance sharing it shall be considered disabled.
+ */
+static void hci_le_ext_adv_set_enabled(struct hci_dev *hdev, u8 handle,
+				       bool enable)
+{
+	struct adv_info *adv;
+	bool owned = false;
+
+	list_for_each_entry(adv, &hdev->adv_instances, list) {
+		if (adv->handle != handle)
+			continue;
+
+		adv->enabled = enable &&
+			       (handle ||
+				adv->instance == hdev->cur_adv_instance);
+		owned |= adv->enabled;
+	}
+
+	if (handle)
+		return;
+
+	if (enable && !owned)
+		hci_dev_set_flag(hdev, HCI_LE_ADV_0);
+	else
+		hci_dev_clear_flag(hdev, HCI_LE_ADV_0);
+}
+
 static u8 hci_cc_le_set_ext_adv_enable(struct hci_dev *hdev, void *data,
 				       struct sk_buff *skb)
 {
@@ -1605,18 +1638,13 @@ static u8 hci_cc_le_set_ext_adv_enable(struct hci_dev *hdev, void *data,
 
 	hci_dev_lock(hdev);
 
-	if (cp->num_of_sets)
-		adv = hci_find_adv_instance(hdev, set->handle);
-
 	if (cp->enable) {
 		struct hci_conn *conn;
 
 		hci_dev_set_flag(hdev, HCI_LE_ADV);
 
-		if (adv)
-			adv->enabled = true;
-		else if (!set->handle)
-			hci_dev_set_flag(hdev, HCI_LE_ADV_0);
+		if (cp->num_of_sets)
+			hci_le_ext_adv_set_enabled(hdev, set->handle, true);
 
 		conn = hci_lookup_le_connect(hdev);
 		if (conn)
@@ -1625,10 +1653,7 @@ static u8 hci_cc_le_set_ext_adv_enable(struct hci_dev *hdev, void *data,
 					   conn->conn_timeout);
 	} else {
 		if (cp->num_of_sets) {
-			if (adv)
-				adv->enabled = false;
-			else if (!set->handle)
-				hci_dev_clear_flag(hdev, HCI_LE_ADV_0);
+			hci_le_ext_adv_set_enabled(hdev, set->handle, false);
 
 			/* If just one instance was disabled check if there are
 			 * any other instance enabled, including instance 0,
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 05926993f34ed..b592dd152b5a9 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -1184,6 +1184,30 @@ int hci_update_random_address_sync(struct hci_dev *hdev, bool require_privacy,
 	return 0;
 }
 
+/* Check if the advertising set with handle 0x00 is in use, either by instance
+ * 0 or by an instance sharing its advertising set.
+ */
+static bool hci_ext_adv_handle_0_enabled(struct hci_dev *hdev)
+{
+	struct adv_info *adv;
+	bool enabled;
+
+	hci_dev_lock(hdev);
+
+	enabled = hci_dev_test_flag(hdev, HCI_LE_ADV_0);
+
+	list_for_each_entry(adv, &hdev->adv_instances, list) {
+		if (!adv->handle && adv->enabled) {
+			enabled = true;
+			break;
+		}
+	}
+
+	hci_dev_unlock(hdev);
+
+	return enabled;
+}
+
 int hci_disable_ext_adv_legacy_instance_sync(struct hci_dev *hdev)
 {
 	struct hci_cp_le_set_ext_adv_enable *cp;
@@ -1191,7 +1215,7 @@ int hci_disable_ext_adv_legacy_instance_sync(struct hci_dev *hdev)
 	u8 data[sizeof(*cp) + sizeof(*set) * 1];
 	u8 size;
 
-	if (!hci_dev_test_flag(hdev, HCI_LE_ADV_0))
+	if (!hci_ext_adv_handle_0_enabled(hdev))
 		return 0;
 
 	memset(data, 0, sizeof(data));
@@ -1435,6 +1459,9 @@ int hci_setup_ext_adv_instance_sync(struct hci_dev *hdev, u8 instance)
 			return -EINVAL;
 		}
 	} else {
+		/* Disable the advertising set with handle 0x00, including any
+		 * instance sharing it, since it is going to be overridden.
+		 */
 		err = hci_disable_ext_adv_legacy_instance_sync(hdev);
 		if (err)
 			return err;
@@ -1701,6 +1728,12 @@ int hci_enable_ext_advertising_sync(struct hci_dev *hdev, u8 instance)
 		set->duration = cpu_to_le16(duration / 10);
 	}
 
+	/* Track which instance owns the advertising set since the handle
+	 * alone is ambiguous when instances share handle 0x00, see
+	 * hci_cc_le_set_ext_adv_enable.
+	 */
+	hdev->cur_adv_instance = instance;
+
 	return __hci_cmd_sync_status(hdev, HCI_OP_LE_SET_EXT_ADV_ENABLE,
 				     sizeof(*cp) +
 				     sizeof(*set) * cp->num_of_sets,
-- 
2.53.0



