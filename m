Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F9733B97B;
	Tue, 13 Oct 2026 12:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895474; cv=none; b=YIJjmFa/2VvpsfW6ox3V2VfnzsotnJoV4rPJGF7yqveEmInrAKtImSvClYwkTeXp+eoKzbm7iAgi9TNOxjztE6NlhuvrX8UgXvtPVy8tamG+ISsdOy/bq5C9rPFVqhMMDc3Nfziaep9HlWXiuGYXazVoWpF6/l3iztQitcsytFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895474; c=relaxed/simple;
	bh=UMvIlBJHS6T70x8BA1uASjvz4hlFj4NYB5N6rH4wUrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LPiAqTzszXCP7+zCrR7slYjrkS1jYrHKACe+WCegrhdIakViH6XGOh71LZYH9tRfwqvV4+vJZ8rvDZ5jwLtxTyM8Ry882vrZISyJpLw1Jxo8p/gkX1UMXMzusTR0YI62iH52a5o1qPsg58Hnh+WCC81KEFDqelicdZaz0sfhya8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kg5I6Xsu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kg5I6Xsu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8DF81F000FF;
	Tue, 13 Oct 2026 12:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895472;
	bh=b071fzrDqNpIBsCfCr29xg3k0aOZeBd8TbP+1lSfTR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kg5I6XsuZzvyNUDikFPOcBZwW4qsgh7A+lBVh4NnfE/gYZK7jBSYxmGJhrO+5jjIn
	 uF4CaJ+BsGwV2ovj0KxUzJTge9xt9yFc6yd+KfMtAdQfOGswsbC6i4JyZIB4IhqNmz
	 aThxeg9L03/BmTiOtLYolpwSfku2JV5bi+k4Bte8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 287/497] Bluetooth: hci_core: Serialize SCO and ISO scheduling with teardown
Date: Tue, 13 Oct 2026 13:37:34 +0200
Message-ID: <20261013112914.707179500@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengfeng Ye <nicoyip.dev@gmail.com>

[ Upstream commit 848a7a91c7f03675d3bd8db6f7721cbf9cb50e21 ]

hci_low_sent() selects a connection under RCU but drops the read lock
before calculating its quota and returning it to the scheduler. The
connection is then used without lifetime protection by hci_sched_iso()
and hci_sched_sco().

After the TX worker drops the RCU read lock, hci_abort_conn_sync() on
hdev->req_workqueue can remove the connection from the hash, complete
synchronize_rcu(), purge its queues and release it. The TX worker on
hdev->workqueue can then access the freed connection in hci_quote_sent()
or while dequeuing packets and updating conn->sent.

KASAN reported:

  BUG: KASAN: slab-use-after-free in hci_low_sent+0x730/0x840
  Workqueue: hci0 hci_tx_work
  Call Trace:
   hci_low_sent+0x730/0x840
   hci_sched_iso+0x25e/0x4d0
   hci_tx_work+0x239/0xcb0

  Allocated by task 93:
   __hci_conn_add+0x16f/0x1b40
   hci_bind_bis+0x782/0x17b0
   hci_connect_bis+0xa0/0x510
   iso_sock_connect+0x589/0x1050

  Freed by task 88:
   kfree+0x131/0x3c0
   device_release+0xc8/0x240
   kobject_put+0x14d/0x280
   hci_conn_del+0x55a/0xe80
   hci_disconnect_sync+0x156/0x180
   hci_abort_conn_sync+0x3e7/0x940
   hci_cmd_sync_work+0x13c/0x290

Hold hci_dev_lock() across connection selection and transmission in both
SCO and ISO scheduling, serializing them with connection teardown. This
also prevents queuing completion timestamps after the connection queues
have been purged. Extending RCU across transmission would be unsafe
because the transmit path can sleep. Keep the ISO timeout check outside
the mutex since hci_link_tx_to() takes it itself.

The preceding channel fix already holds this mutex in the ACL and LE
schedulers, which call the SCO scheduler between packets. Move the SCO
body to __hci_sched_sco(), assert that its caller holds the mutex, and
use it directly from these locked paths. Keep a locking hci_sched_sco()
wrapper for the direct calls from hci_tx_work(). This avoids recursively
acquiring the device mutex while preserving the scheduling order.

Remove the obsolete claim that connection removal disables TX.

Fixes: bf4c63252490 ("Bluetooth: convert conn hash to RCU")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
[ sashal: Adjusted hci_sched_iso() lock placement around existing ISO/LE/ACL credit selection with no ISO timeout check. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 4f973e22ce86e..253ee56d7bf66 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3450,9 +3450,6 @@ static struct hci_conn *hci_low_sent(struct hci_dev *hdev, __u8 type,
 	struct hci_conn *conn = NULL, *c;
 	unsigned int num = 0, min = ~0;
 
-	/* We don't have to lock device here. Connections are always
-	 * added and removed with TX task disabled. */
-
 	rcu_read_lock();
 
 	list_for_each_entry_rcu(c, &h->list, list) {
@@ -3640,13 +3637,15 @@ static void __check_timeout(struct hci_dev *hdev, unsigned int cnt, u8 type)
 }
 
 /* Schedule SCO */
-static void hci_sched_sco(struct hci_dev *hdev, __u8 type)
+static void __hci_sched_sco(struct hci_dev *hdev, __u8 type)
 {
 	struct hci_conn *conn;
 	struct sk_buff *skb;
 	int quote, *cnt;
 	unsigned int pkts = hdev->sco_pkts;
 
+	lockdep_assert_held(&hdev->lock);
+
 	bt_dev_dbg(hdev, "type %u", type);
 
 	if (!hci_conn_num(hdev, type) || !pkts)
@@ -3681,6 +3680,13 @@ static void hci_sched_sco(struct hci_dev *hdev, __u8 type)
 		queue_work(hdev->workqueue, &hdev->tx_work);
 }
 
+static void hci_sched_sco(struct hci_dev *hdev, __u8 type)
+{
+	hci_dev_lock(hdev);
+	__hci_sched_sco(hdev, type);
+	hci_dev_unlock(hdev);
+}
+
 static void hci_sched_acl_pkt(struct hci_dev *hdev)
 {
 	unsigned int cnt = hdev->acl_cnt;
@@ -3716,8 +3722,8 @@ static void hci_sched_acl_pkt(struct hci_dev *hdev)
 			chan->conn->sent++;
 
 			/* Send pending SCO packets right away */
-			hci_sched_sco(hdev, SCO_LINK);
-			hci_sched_sco(hdev, ESCO_LINK);
+			__hci_sched_sco(hdev, SCO_LINK);
+			__hci_sched_sco(hdev, ESCO_LINK);
 		}
 	}
 
@@ -3776,8 +3782,8 @@ static void hci_sched_le(struct hci_dev *hdev)
 			chan->conn->sent++;
 
 			/* Send pending SCO packets right away */
-			hci_sched_sco(hdev, SCO_LINK);
-			hci_sched_sco(hdev, ESCO_LINK);
+			__hci_sched_sco(hdev, SCO_LINK);
+			__hci_sched_sco(hdev, ESCO_LINK);
 		}
 	}
 
@@ -3801,6 +3807,9 @@ static void hci_sched_iso(struct hci_dev *hdev, __u8 type)
 
 	cnt = hdev->iso_pkts ? &hdev->iso_cnt :
 		hdev->le_pkts ? &hdev->le_cnt : &hdev->acl_cnt;
+
+	hci_dev_lock(hdev);
+
 	while (*cnt && (conn = hci_low_sent(hdev, type, &quote))) {
 		while (quote-- && (skb = skb_dequeue(&conn->data_q))) {
 			BT_DBG("skb %p len %d", skb, skb->len);
@@ -3812,6 +3821,8 @@ static void hci_sched_iso(struct hci_dev *hdev, __u8 type)
 			(*cnt)--;
 		}
 	}
+
+	hci_dev_unlock(hdev);
 }
 
 static void hci_tx_work(struct work_struct *work)
-- 
2.53.0



