Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14864346FD2;
	Thu, 30 Jul 2026 14:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421446; cv=none; b=C61z+djvl3Zt95cvqmHjJNCNACrJE0n3LY8lbi8TDFvQt1ekr9EIxkYTdSZl5AVq4fovDX7+pQG567/LeiKArCbtteAnQy3vO6DLBw8uV5Uo1LL0rpC20oiHyLI0CpOuTLVZQBlFmoCNbmOlcL5j1uiCEXrHH44yNHAsEpEjVjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421446; c=relaxed/simple;
	bh=E2WcUBOxyIEnKezRJRdlI+jRDf4gsq/vOPUOy4X7J80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Er1NiT6obvw9z19VzSBIhaAoo8nnia4XVaf9fStoqlJluTBiUYoTqwsIiMKVmKTbvELhZyrh/iEW0pi7vd2GjXWEjL9u1WbA3m++v91i28tDbRPIVEwUeEAjhUTRKFP7GtQTjFAEPGkSTE2NPuWWbv0kzDbQK3xfgQgDLdnQW8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ahx5zK6d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ahx5zK6d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BF4B1F000E9;
	Thu, 30 Jul 2026 14:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421445;
	bh=6+qTUH8CQP6nI2pcY/uAImp2LM8MvsCSKGHDACIYcu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ahx5zK6dkkXC6mcdvVCQKpZd56AICecrLNZFjBxWQVXaN41RgFaWykiGSVmoC/Egg
	 byHU+c9Id5/VRwa5yUN8oUgJP0/b0jccK25wbUxY2fpgVLBgRsaMSNkfFdhRiHZ8n1
	 V4dUcFfXgMYIwN/iRU0hjdRlGY1aaK22Z8jOJF/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 106/744] Bluetooth: mgmt: Translate HCI reason in Device Disconnected event
Date: Thu, 30 Jul 2026 16:06:19 +0200
Message-ID: <20260730141446.531023747@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>

[ Upstream commit c1cec2bbbeb5922d42d28c6af1707c4f3f8647e3 ]

MGMT_EV_DEVICE_DISCONNECTED carries a reason field which is defined to
be one of MGMT_DEV_DISCONN_* (0x00..0x05). hci_disconn_complete_evt()
converts the HCI error with hci_to_mgmt_reason(), but two other paths
pass the raw HCI error straight through:

  hci_cs_disconnect()   -> cp->reason
  mgmt_connect_failed() -> status

The latter is reached whenever the adapter is powered off or suspended:
hci_disconnect_all_sync() aborts every link with
HCI_ERROR_REMOTE_POWER_OFF, hci_disconnect_sync() deliberately does not
wait for HCI_EV_DISCONN_COMPLETE for that reason, so that
hci_abort_conn_sync() finishes the connection off through
hci_conn_failed() instead.

As a result userspace sees an out of range reason:

  @ MGMT Event: Device Disconnected (0x000c) plen 8
        BR/EDR Address: 8C:A9:6F:2C:51:46
        Reason: Reserved (0x15)

  bluetoothd: btd_bearer_disconnected() Unknown disconnection value: 21
  bluetoothd: device_disconnected() Unknown disconnection value: 21

Export hci_to_mgmt_reason() and use it in both places, so that a power
off is reported as MGMT_DEV_DISCONN_REMOTE rather than as the raw
HCI_ERROR_REMOTE_POWER_OFF (0x15).

Fixes: d47da6bd4cfa ("Bluetooth: hci_core: Fix sending MGMT_EV_CONNECT_FAILED")
Fixes: 182ee45da083 ("Bluetooth: hci_sync: Rework hci_suspend_notifier")
Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci_core.h |  1 +
 net/bluetooth/hci_event.c        | 18 +-----------------
 net/bluetooth/mgmt.c             | 19 ++++++++++++++++++-
 3 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index aa554c34f9ec35..02ba1cba6b236c 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -2433,6 +2433,7 @@ void mgmt_new_link_key(struct hci_dev *hdev, struct link_key *key,
 		       bool persistent);
 void mgmt_device_connected(struct hci_dev *hdev, struct hci_conn *conn,
 			   u8 *name, u8 name_len);
+u8 hci_to_mgmt_reason(u8 err);
 void mgmt_device_disconnected(struct hci_dev *hdev, bdaddr_t *bdaddr,
 			      u8 link_type, u8 addr_type, u8 reason,
 			      bool mgmt_connected);
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 1cd5f97daafe32..55a2de5c8c8e5a 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -2766,7 +2766,7 @@ static void hci_cs_disconnect(struct hci_dev *hdev, u8 status)
 	}
 
 	mgmt_device_disconnected(hdev, &conn->dst, conn->type, conn->dst_type,
-				 cp->reason, mgmt_conn);
+				 hci_to_mgmt_reason(cp->reason), mgmt_conn);
 
 	hci_disconn_cfm(conn, cp->reason);
 
@@ -3384,22 +3384,6 @@ static void hci_conn_request_evt(struct hci_dev *hdev, void *data,
 	hci_dev_unlock(hdev);
 }
 
-static u8 hci_to_mgmt_reason(u8 err)
-{
-	switch (err) {
-	case HCI_ERROR_CONNECTION_TIMEOUT:
-		return MGMT_DEV_DISCONN_TIMEOUT;
-	case HCI_ERROR_REMOTE_USER_TERM:
-	case HCI_ERROR_REMOTE_LOW_RESOURCES:
-	case HCI_ERROR_REMOTE_POWER_OFF:
-		return MGMT_DEV_DISCONN_REMOTE;
-	case HCI_ERROR_LOCAL_HOST_TERM:
-		return MGMT_DEV_DISCONN_LOCAL_HOST;
-	default:
-		return MGMT_DEV_DISCONN_UNKNOWN;
-	}
-}
-
 static void hci_disconn_complete_evt(struct hci_dev *hdev, void *data,
 				     struct sk_buff *skb)
 {
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 9604c3025f7b7c..c18eea5eb78104 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -9911,6 +9911,22 @@ bool mgmt_powering_down(struct hci_dev *hdev)
 	return false;
 }
 
+u8 hci_to_mgmt_reason(u8 err)
+{
+	switch (err) {
+	case HCI_ERROR_CONNECTION_TIMEOUT:
+		return MGMT_DEV_DISCONN_TIMEOUT;
+	case HCI_ERROR_REMOTE_USER_TERM:
+	case HCI_ERROR_REMOTE_LOW_RESOURCES:
+	case HCI_ERROR_REMOTE_POWER_OFF:
+		return MGMT_DEV_DISCONN_REMOTE;
+	case HCI_ERROR_LOCAL_HOST_TERM:
+		return MGMT_DEV_DISCONN_LOCAL_HOST;
+	default:
+		return MGMT_DEV_DISCONN_UNKNOWN;
+	}
+}
+
 void mgmt_device_disconnected(struct hci_dev *hdev, bdaddr_t *bdaddr,
 			      u8 link_type, u8 addr_type, u8 reason,
 			      bool mgmt_connected)
@@ -9972,7 +9988,8 @@ void mgmt_connect_failed(struct hci_dev *hdev, struct hci_conn *conn, u8 status)
 
 	if (test_and_clear_bit(HCI_CONN_MGMT_CONNECTED, &conn->flags)) {
 		mgmt_device_disconnected(hdev, &conn->dst, conn->type,
-					 conn->dst_type, status, true);
+					 conn->dst_type,
+					 hci_to_mgmt_reason(status), true);
 		return;
 	}
 
-- 
2.53.0



