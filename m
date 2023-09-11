Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E0811705
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:35:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4B5BC433C8;
	Mon, 11 Sep 2023 14:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442951;
	bh=cCaNfwQ8mTaXk/YNXxQGCJmV0hh8qQkSxgmT+1Znboo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VdDP/Df2P2OdgeCqcTEOyICuAHPdR8SBfD3Uxuza0LOzyJC52XqGBvqP3laXevIhP
	 fpsQq/3HXDgMpKCs4eLfv+dpHS6aVVIhusCOkz9E9d3PbTy79+TeRQpLiECgzHvUFR
	 RP4JvDs6jakKNROnTZBTElTUwGHA5Mkt5zLcLmQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 205/737] Bluetooth: hci_conn: Always allocate unique handles
Date: Mon, 11 Sep 2023 15:41:04 +0200
Message-ID: <20230911134656.323497620@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 9f78191cc9f1b34c2e2afd7b554a83bf034092dd ]

This attempts to always allocate a unique handle for connections so they
can be properly aborted by the likes of hci_abort_conn, so this uses the
invalid range as a pool of unset handles that way if userspace is trying
to create multiple connections at once each will be given a unique
handle which will be considered unset.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 66dee21524d9 ("Bluetooth: hci_event: drop only unbound CIS if Set CIG Parameters fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci_core.h |  2 +-
 net/bluetooth/hci_conn.c         | 25 ++++++++++++++++++++++---
 net/bluetooth/hci_event.c        |  6 +++---
 3 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index e30e091ef728e..2db826cdf76fa 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -321,8 +321,8 @@ struct adv_monitor {
 
 #define HCI_MAX_SHORT_NAME_LENGTH	10
 
-#define HCI_CONN_HANDLE_UNSET		0xffff
 #define HCI_CONN_HANDLE_MAX		0x0eff
+#define HCI_CONN_HANDLE_UNSET(_handle)	(_handle > HCI_CONN_HANDLE_MAX)
 
 /* Min encryption key size to match with SMP */
 #define HCI_MIN_ENC_KEY_SIZE		7
diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 7762161a3fc8b..7ced6077488f7 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -991,6 +991,25 @@ static void cis_cleanup(struct hci_conn *conn)
 	hci_le_remove_cig(hdev, conn->iso_qos.ucast.cig);
 }
 
+static u16 hci_conn_hash_alloc_unset(struct hci_dev *hdev)
+{
+	struct hci_conn_hash *h = &hdev->conn_hash;
+	struct hci_conn  *c;
+	u16 handle = HCI_CONN_HANDLE_MAX + 1;
+
+	rcu_read_lock();
+
+	list_for_each_entry_rcu(c, &h->list, list) {
+		/* Find the first unused handle */
+		if (handle == 0xffff || c->handle != handle)
+			break;
+		handle++;
+	}
+	rcu_read_unlock();
+
+	return handle;
+}
+
 struct hci_conn *hci_conn_add(struct hci_dev *hdev, int type, bdaddr_t *dst,
 			      u8 role)
 {
@@ -1004,7 +1023,7 @@ struct hci_conn *hci_conn_add(struct hci_dev *hdev, int type, bdaddr_t *dst,
 
 	bacpy(&conn->dst, dst);
 	bacpy(&conn->src, &hdev->bdaddr);
-	conn->handle = HCI_CONN_HANDLE_UNSET;
+	conn->handle = hci_conn_hash_alloc_unset(hdev);
 	conn->hdev  = hdev;
 	conn->type  = type;
 	conn->role  = role;
@@ -1117,7 +1136,7 @@ static void hci_conn_unlink(struct hci_conn *conn)
 			 */
 			if ((child->type == SCO_LINK ||
 			     child->type == ESCO_LINK) &&
-			    child->handle == HCI_CONN_HANDLE_UNSET)
+			    HCI_CONN_HANDLE_UNSET(child->handle))
 				hci_conn_del(child);
 		}
 
@@ -1968,7 +1987,7 @@ int hci_conn_check_create_cis(struct hci_conn *conn)
 		return -EINVAL;
 
 	if (!conn->parent || conn->parent->state != BT_CONNECTED ||
-	    conn->state != BT_CONNECT || conn->handle == HCI_CONN_HANDLE_UNSET)
+	    conn->state != BT_CONNECT || HCI_CONN_HANDLE_UNSET(conn->handle))
 		return 1;
 
 	return 0;
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index e3675d8a23e44..22fb9f9da866b 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3173,7 +3173,7 @@ static void hci_conn_complete_evt(struct hci_dev *hdev, void *data,
 	 * As the connection handle is set here for the first time, it indicates
 	 * whether the connection is already set up.
 	 */
-	if (conn->handle != HCI_CONN_HANDLE_UNSET) {
+	if (!HCI_CONN_HANDLE_UNSET(conn->handle)) {
 		bt_dev_err(hdev, "Ignoring HCI_Connection_Complete for existing connection");
 		goto unlock;
 	}
@@ -5008,7 +5008,7 @@ static void hci_sync_conn_complete_evt(struct hci_dev *hdev, void *data,
 	 * As the connection handle is set here for the first time, it indicates
 	 * whether the connection is already set up.
 	 */
-	if (conn->handle != HCI_CONN_HANDLE_UNSET) {
+	if (!HCI_CONN_HANDLE_UNSET(conn->handle)) {
 		bt_dev_err(hdev, "Ignoring HCI_Sync_Conn_Complete event for existing connection");
 		goto unlock;
 	}
@@ -5872,7 +5872,7 @@ static void le_conn_complete_evt(struct hci_dev *hdev, u8 status,
 	 * As the connection handle is set here for the first time, it indicates
 	 * whether the connection is already set up.
 	 */
-	if (conn->handle != HCI_CONN_HANDLE_UNSET) {
+	if (!HCI_CONN_HANDLE_UNSET(conn->handle)) {
 		bt_dev_err(hdev, "Ignoring HCI_Connection_Complete for existing connection");
 		goto unlock;
 	}
-- 
2.40.1



