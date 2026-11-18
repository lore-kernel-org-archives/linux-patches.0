Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031916;
	b=evsbeIun1mi8DXl3vOCK2hOBkTSM8Nprf/D8GfoUMH5oGr4dSZN8nxovyLPLpi/GpFeq
	 wU05Jfm7ZLRxFhN2XY56NlFrXygNVUj5s6qPKUTzsWRz8HkYkTqj9NHN8W+bOi8mI/rQK
	 OR96uOV4Lj0S2pVSViMPX8SoBQVF7fBugVf2uFwmv6agtNfjfItdmJm1mvZGfpXSijmhg
	 C1dAq87/5nmkQkOGrEfMgvziNsunrkR1YrZ7o6lgK+TX7gLq9JSqkheAsBxKDHJhquX6I
	 e1JXiowFSJoGK7K2DQrFUOhGR5btyPzQqc5RAQX434gUZvB8E/aejYkEFjimxrmgZyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031916;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LTY8ZzsB+N/LGFlapJWMqU1UXBcClwUU15avvR2ura8=;
	b=VA0WAZibbNLmDq/EVmdSQZlY63fJtliUFmdkbnFaOVZveZ9CiBLcBYw2oBtSugTTqhWM
	 02fUyGVncReBbkKcOu33evr5optZr0JV09xW3ZqOAQ+59Ws1gJVJyfkT6bN8LyQ1npWYs
	 2nvRuxW9Bn3cyX0XUktcFiKPmv3K9mhjyfwhHdqGTpnvBIu2FMyMtU9/Q1sDIyFlaPgPz
	 earoo8xN2Tll8y2IA8Wvi5rvHEo7XjS1jPdSpI3CLulTJ5b57mGLHe8NZazvoJ1VlZFBu
	 px11VesJpR81zWo7FfpGmGE5O5ayt07/wD7aY27KG3880aHRq+1otxbPFcS236f/SBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FVQhEjVA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD3B6606A32F;
	Wed, 18 Nov 2026 19:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FVQhEjVA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0820C1F000C4;
	Wed, 18 Nov 2026 19:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031916;
	bh=LTY8ZzsB+N/LGFlapJWMqU1UXBcClwUU15avvR2ura8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FVQhEjVAxWI4yJMecUl47v8eqtLLItcDYQ6j4R4piU00tkXdJVtyBD6JOKg5MZziU
	 F+6VH7NP6MYbeDNLE5h+uos7eQmCrEVFzt5wbJ+m8gdDWNnzbczF5IXckGA0ZvXDu6
	 HAvryQSi05V9txR59oFuZQJIDp++1JKwP+uqRuHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1226/1756] Bluetooth: HCI: Fix tracking of instances sharing handle 0x00
Date: Wed, 18 Nov 2026 15:55:53 +0100
Message-ID: <20261118150058.622144096@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 849d4c2556cc8..bd30c00269698 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -1573,6 +1573,39 @@ static u8 hci_cc_le_set_adv_enable(struct hci_dev *hdev, void *data,
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
@@ -1594,18 +1627,13 @@ static u8 hci_cc_le_set_ext_adv_enable(struct hci_dev *hdev, void *data,
 
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
@@ -1614,10 +1642,7 @@ static u8 hci_cc_le_set_ext_adv_enable(struct hci_dev *hdev, void *data,
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
index da3ef487b2feb..0d47c5c9ef9d9 100644
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
@@ -1700,6 +1727,12 @@ int hci_enable_ext_advertising_sync(struct hci_dev *hdev, u8 instance)
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



