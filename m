Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF9D471252;
	Fri,  7 Aug 2026 15:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116930; cv=none; b=Qutkaet2vbVMgD9twgpItdQwcntXqt9lu/zY1mDrdEeAkZO6lCQ/2rkZpNgbT5JoEa+SssYnMPviNvZe42gGqWNAd84Hj5g6JCn1WwZQcxIe0TyWmbYew0AvcN13MH9PuwwVDl/LTOTpDMFzhEmxpTutlmg0m4johzol6ksQ9ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116930; c=relaxed/simple;
	bh=P8UtPz5RAucGSyWkcr4GkA4XtPtIe0xsgKqztP82zQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CpchIoLy65XjuZPj6T5mbbYpeCa/rAybfyWLRpOLpndTkZJxIFXwV23SENFWw69LBW/eMvc4H4vzen/0d01D9hGN2aqr6+rVWheKfUBNfnDZlAmhZXo80SIfRKXDU6SW5SKa7/aaAdfGdux4yhlKBMjH4XfuYNTaWI+VG0SzMSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c4Ao929i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c4Ao929i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71A111F000E9;
	Fri,  7 Aug 2026 15:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116929;
	bh=3YnXRygvoH25N0Tgwe2w6XiYRQptc9lROALx049qHW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c4Ao929iaQvHocJj0JWoUbokq2Fqwvkt7wBrjmPzu/JUOPvQ0FLt8DXxSymK80mUU
	 uoSDzvOU4NAcIBNh34CtcmbyIqtYUyZBAfS8woaIZHZXE3LsOn+70MVR/KKSgH+0zD
	 WjneFJVrnc8uOhbyc0XMaibrDb5vUD67sTM1TW9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 140/438] Bluetooth: ISO: fix race of kfree vs kref_get_unless_zero
Date: Fri,  7 Aug 2026 16:35:36 +0200
Message-ID: <20260807143430.989718164@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit af24e338bf5dafb80f42baa9a0b9e9b57b1c5d9c ]

hci_conn::iso_data is accessed and modified without lock or RCU.
This leads to a race

    [Task hdev->workqueue]                 	[Task 2]
    iso_recv                                    iso_conn_put(conn)
      conn = LOAD hcon->iso_data                  iso_conn_free(conn)
      iso_conn_hold_unless_zero(conn)               hcon->iso_data = NULL
                                                    kfree(conn)
        kref_get_unless_zero(&conn->ref) /* UAF */

and also to races in iso_conn_add() vs. iso_conn_free().

Fix by adding spinlock hci_conn::proto_lock and using it to guard
hci_conn::iso_data.

Fixes: dc26097bdb86 ("Bluetooth: ISO: Use kref to track lifetime of iso_conn")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci_core.h |  4 +-
 net/bluetooth/hci_conn.c         |  2 +
 net/bluetooth/iso.c              | 64 ++++++++++++++++++++++++++------
 3 files changed, 58 insertions(+), 12 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 02ba1cba6b236..2c15c9d8dbf74 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -770,9 +770,11 @@ struct hci_conn {
 	struct dentry	*debugfs;
 
 	struct hci_dev	*hdev;
+
+	spinlock_t	proto_lock; /* lock guarding protocol data */
 	void		*l2cap_data;
 	void		*sco_data;
-	void		*iso_data;
+	void		*iso_data __guarded_by(&proto_lock);
 
 	struct list_head link_list;
 	struct hci_conn	*parent;
diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index eba4a548bef52..924c7795e368a 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1126,6 +1126,8 @@ static struct hci_conn *__hci_conn_add(struct hci_dev *hdev, int type,
 	INIT_DELAYED_WORK(&conn->idle_work, hci_conn_idle);
 	INIT_DELAYED_WORK(&conn->le_conn_timeout, le_conn_timeout);
 
+	spin_lock_init(&conn->proto_lock);
+
 	atomic_set(&conn->refcnt, 0);
 
 	hci_dev_hold(hdev);
diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 3b22193a9ec32..f946ef5f37b37 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -108,9 +108,16 @@ static void iso_conn_free(struct kref *ref)
 	BT_DBG("conn %p", conn);
 
 	if (conn->hcon) {
-		conn->hcon->iso_data = NULL;
-		if (!test_and_set_bit(ISO_CONN_DROPPED, conn->flags))
-			hci_conn_drop(conn->hcon);
+		spin_lock(&conn->hcon->proto_lock);
+
+		/* Check we are not racing with iso_conn_add */
+		if (conn->hcon->iso_data == conn) {
+			conn->hcon->iso_data = NULL;
+			if (!test_and_set_bit(ISO_CONN_DROPPED, conn->flags))
+				hci_conn_drop(conn->hcon);
+		}
+
+		spin_unlock(&conn->hcon->proto_lock);
 	}
 
 	kfree_skb(conn->rx_skb);
@@ -125,7 +132,21 @@ static void iso_conn_put(struct iso_conn *conn)
 
 	BT_DBG("conn %p refcnt %d", conn, kref_read(&conn->ref));
 
+	/* The following race vs. iso_conn_del() is possible:
+	 *
+	 * 1. conn->hcon != NULL here
+	 * 2. kref_put puts the last reference
+	 * 3. concurrent iso_conn_del() gets iso_conn_hold_unless_zero() -> NULL
+	 *    and returns immediately, so conn->hcon is not cleared
+	 * 4. iso_conn_free() dereferences conn->hcon
+	 *
+	 * To avoid UAF in step 4, take RCU before decrementing the refcount.
+	 */
+	rcu_read_lock();
+
 	kref_put(&conn->ref, iso_conn_free);
+
+	rcu_read_unlock();
 }
 
 static struct iso_conn *iso_conn_hold_unless_zero(struct iso_conn *conn)
@@ -204,22 +225,28 @@ static void iso_sock_disable_timer(struct sock *sk)
 
 /* ---- ISO connections ---- */
 static struct iso_conn *iso_conn_add(struct hci_conn *hcon)
+	__must_hold(&hcon->hdev->lock)
 {
-	struct iso_conn *conn = hcon->iso_data;
+	struct iso_conn *conn;
+
+	spin_lock(&hcon->proto_lock);
 
-	conn = iso_conn_hold_unless_zero(conn);
+	conn = iso_conn_hold_unless_zero(hcon->iso_data);
 	if (conn) {
 		if (!conn->hcon) {
 			iso_conn_lock(conn);
 			conn->hcon = hcon;
 			iso_conn_unlock(conn);
 		}
+		spin_unlock(&hcon->proto_lock);
 		return conn;
 	}
 
-	conn = kzalloc_obj(*conn);
-	if (!conn)
+	conn = kzalloc_obj(*conn, GFP_ATOMIC);
+	if (!conn) {
+		spin_unlock(&hcon->proto_lock);
 		return NULL;
+	}
 
 	kref_init(&conn->ref);
 	spin_lock_init(&conn->lock);
@@ -228,6 +255,8 @@ static struct iso_conn *iso_conn_add(struct hci_conn *hcon)
 	conn->hcon = hcon;
 	conn->tx_sn = 0;
 
+	spin_unlock(&hcon->proto_lock);
+
 	BT_DBG("hcon %p conn %p", hcon, conn);
 
 	return conn;
@@ -268,10 +297,12 @@ static void iso_chan_del(struct sock *sk, int err)
 static void iso_conn_del(struct hci_conn *hcon, int err)
 	__must_hold(&hcon->hdev->lock)
 {
-	struct iso_conn *conn = hcon->iso_data;
+	struct iso_conn *conn;
 	struct sock *sk;
 
-	conn = iso_conn_hold_unless_zero(conn);
+	spin_lock(&hcon->proto_lock);
+	conn = iso_conn_hold_unless_zero(hcon->iso_data);
+	spin_unlock(&hcon->proto_lock);
 	if (!conn)
 		return;
 
@@ -295,10 +326,12 @@ static void iso_conn_del(struct hci_conn *hcon, int err)
 
 done:
 	/* No sk access to conn->hcon any more (lock_sock + hdev->lock) */
+	spin_lock(&hcon->proto_lock);
 	iso_conn_lock(conn);
 	conn->hcon = NULL;
 	hcon->iso_data = NULL;
 	iso_conn_unlock(conn);
+	spin_unlock(&hcon->proto_lock);
 
 	iso_conn_put(conn);
 }
@@ -420,6 +453,8 @@ static int iso_connect_bis(struct sock *sk)
 			iso_pi(sk)->bc_sid = hcon->sid;
 	}
 
+	lockdep_assert_held(&hcon->hdev->lock);
+
 	conn = iso_conn_add(hcon);
 	if (!conn) {
 		hci_conn_drop(hcon);
@@ -523,6 +558,8 @@ static int iso_connect_cis(struct sock *sk)
 		}
 	}
 
+	lockdep_assert_held(&hcon->hdev->lock);
+
 	conn = iso_conn_add(hcon);
 	if (!conn) {
 		hci_conn_drop(hcon);
@@ -854,8 +891,8 @@ static void iso_sock_disconn(struct sock *sk)
 		 */
 		if (bis_sk) {
 			hcon->state = BT_OPEN;
-			hcon->iso_data = NULL;
-			iso_pi(sk)->conn->hcon = NULL;
+			set_bit(ISO_CONN_DROPPED, iso_pi(sk)->conn->flags);
+
 			iso_sock_clear_timer(sk);
 			iso_chan_del(sk, bt_to_errno(hcon->abort_reason));
 			sock_put(bis_sk);
@@ -1305,6 +1342,8 @@ static int iso_listen_bis(struct sock *sk)
 		goto unlock;
 	}
 
+	lockdep_assert_held(&hcon->hdev->lock);
+
 	conn = iso_conn_add(hcon);
 	if (!conn) {
 		hci_conn_drop(hcon);
@@ -2590,7 +2629,10 @@ int iso_recv(struct hci_dev *hdev, u16 handle, struct sk_buff *skb, u16 flags)
 		return -ENOENT;
 	}
 
+	spin_lock(&hcon->proto_lock);
 	conn = iso_conn_hold_unless_zero(hcon->iso_data);
+	spin_unlock(&hcon->proto_lock);
+
 	hcon = NULL;
 
 	hci_dev_unlock(hdev);
-- 
2.53.0



