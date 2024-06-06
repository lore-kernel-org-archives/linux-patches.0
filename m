Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615331AC431;
	Thu,  6 Jun 2024 14:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683323; cv=none; b=LmU3ouA6RcCxSogQEi9xuzebyZZN9rf8y1EFxKmM279Hm9AmPS39IFlS9f17IeEv4WBNzvnyq7nmLmu+URH/qioWmycXLFWSd0QzlmgyJlmxEVUSWHB3XOoYZgapIXq1zvgFXny2qFuurEs/UBtNYDKRPCJumj1//qCnuQnjSv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683323; c=relaxed/simple;
	bh=+d21GlBZSfEvtNHqerw1y7bdoVwFpC1RILmTwGx8svo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tRwIFKKk+Zij92qROeRxWU86zKWiPros5OqGDQ0CFnU4RRt6RNqQg/DfixozIirAZwehjR+SUktX1bJS3Rz/KVD3Ctk9396piGYnFQhcV0iedtDWgBwxxnGA4RygV2pHgogW8AFElzrCCuMmdcKXGTkC4DfBw/TjyRDOCVMFsWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AY7XhJJL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AY7XhJJL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4277BC32781;
	Thu,  6 Jun 2024 14:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683323;
	bh=+d21GlBZSfEvtNHqerw1y7bdoVwFpC1RILmTwGx8svo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AY7XhJJL+bvY9FwJkIje0ewP2QZNX7qC8EcF9nagaQA0F94oNcOgwmUttfivCWgzR
	 jnMl4T+ldbwBiQR9XERFbUIeS/Hpae2eOsnZpEhHh3Dzzymr9lqiVjgKWOTMkVtUYo
	 I2vcPmGMjBAP8p3OieuAIOx8ur1og5GYjvxn0w+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iulia Tanasescu <iulia.tanasescu@nxp.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 263/744] Bluetooth: ISO: Fix BIS cleanup
Date: Thu,  6 Jun 2024 15:58:55 +0200
Message-ID: <20240606131740.833593086@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Iulia Tanasescu <iulia.tanasescu@nxp.com>

[ Upstream commit a254b90c9aac3d3d938a07e019773e35a977451b ]

This fixes the master BIS cleanup procedure - as opposed to CIS cleanup,
no HCI disconnect command should be issued. A master BIS should only be
terminated by disabling periodic and extended advertising, and terminating
the BIG.

In case of a Broadcast Receiver, all BIS and PA connections can be
cleaned up by calling hci_conn_failed, since it contains all function
calls that are necessary for successful cleanup.

Signed-off-by: Iulia Tanasescu <iulia.tanasescu@nxp.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 84a4bb6548a2 ("Bluetooth: HCI: Remove HCI_AMP support")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci_sync.h |  2 ++
 net/bluetooth/hci_conn.c         |  7 +++++++
 net/bluetooth/hci_sync.c         | 28 ++++++++++++----------------
 3 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/include/net/bluetooth/hci_sync.h b/include/net/bluetooth/hci_sync.h
index 268145efbe4cb..e2582c2425449 100644
--- a/include/net/bluetooth/hci_sync.h
+++ b/include/net/bluetooth/hci_sync.h
@@ -80,6 +80,8 @@ int hci_start_per_adv_sync(struct hci_dev *hdev, u8 instance, u8 data_len,
 			   u8 *data, u32 flags, u16 min_interval,
 			   u16 max_interval, u16 sync_interval);
 
+int hci_disable_per_advertising_sync(struct hci_dev *hdev, u8 instance);
+
 int hci_remove_advertising_sync(struct hci_dev *hdev, struct sock *sk,
 				u8 instance, bool force);
 int hci_disable_advertising_sync(struct hci_dev *hdev);
diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index aea7f06c107eb..707c7710d84ec 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -759,6 +759,7 @@ static int terminate_big_sync(struct hci_dev *hdev, void *data)
 
 	bt_dev_dbg(hdev, "big 0x%2.2x bis 0x%2.2x", d->big, d->bis);
 
+	hci_disable_per_advertising_sync(hdev, d->bis);
 	hci_remove_ext_adv_instance_sync(hdev, d->bis, NULL);
 
 	/* Only terminate BIG if it has been created */
@@ -1279,6 +1280,12 @@ void hci_conn_failed(struct hci_conn *conn, u8 status)
 		break;
 	}
 
+	/* In case of BIG/PA sync failed, clear conn flags so that
+	 * the conns will be correctly cleaned up by ISO layer
+	 */
+	test_and_clear_bit(HCI_CONN_BIG_SYNC_FAILED, &conn->flags);
+	test_and_clear_bit(HCI_CONN_PA_SYNC_FAILED, &conn->flags);
+
 	conn->state = BT_CLOSED;
 	hci_connect_cfm(conn, status);
 	hci_conn_del(conn);
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 1bc58b324b73e..40f5324e1e66f 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -1321,7 +1321,7 @@ int hci_start_ext_adv_sync(struct hci_dev *hdev, u8 instance)
 	return hci_enable_ext_advertising_sync(hdev, instance);
 }
 
-static int hci_disable_per_advertising_sync(struct hci_dev *hdev, u8 instance)
+int hci_disable_per_advertising_sync(struct hci_dev *hdev, u8 instance)
 {
 	struct hci_cp_le_set_per_adv_enable cp;
 	struct adv_info *adv = NULL;
@@ -5304,6 +5304,17 @@ static int hci_disconnect_sync(struct hci_dev *hdev, struct hci_conn *conn,
 	if (conn->type == AMP_LINK)
 		return hci_disconnect_phy_link_sync(hdev, conn->handle, reason);
 
+	if (test_bit(HCI_CONN_BIG_CREATED, &conn->flags)) {
+		/* This is a BIS connection, hci_conn_del will
+		 * do the necessary cleanup.
+		 */
+		hci_dev_lock(hdev);
+		hci_conn_failed(conn, reason);
+		hci_dev_unlock(hdev);
+
+		return 0;
+	}
+
 	memset(&cp, 0, sizeof(cp));
 	cp.handle = cpu_to_le16(conn->handle);
 	cp.reason = reason;
@@ -5456,21 +5467,6 @@ int hci_abort_conn_sync(struct hci_dev *hdev, struct hci_conn *conn, u8 reason)
 		err = hci_reject_conn_sync(hdev, conn, reason);
 		break;
 	case BT_OPEN:
-		hci_dev_lock(hdev);
-
-		/* Cleanup bis or pa sync connections */
-		if (test_and_clear_bit(HCI_CONN_BIG_SYNC_FAILED, &conn->flags) ||
-		    test_and_clear_bit(HCI_CONN_PA_SYNC_FAILED, &conn->flags)) {
-			hci_conn_failed(conn, reason);
-		} else if (test_bit(HCI_CONN_PA_SYNC, &conn->flags) ||
-			   test_bit(HCI_CONN_BIG_SYNC, &conn->flags)) {
-			conn->state = BT_CLOSED;
-			hci_disconn_cfm(conn, reason);
-			hci_conn_del(conn);
-		}
-
-		hci_dev_unlock(hdev);
-		return 0;
 	case BT_BOUND:
 		break;
 	default:
-- 
2.43.0



