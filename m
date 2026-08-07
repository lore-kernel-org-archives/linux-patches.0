Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41614303C97;
	Fri,  7 Aug 2026 14:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113978; cv=none; b=WpQjv9H5VREFWw4u6IatIyHCPX6HN+CMzKI+4pNH5qWsK0y8DA94ehx6ytacbuYyLkQ1ooqwIaLhjBvQHL+nWErcljETf1fC7V1Ic5uB6EK7Sw6ThJ89sTTDPZiofIX49LYvjUkRl9UGl58ut9CkgCbuQBzGb753jBfIzCnCPQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113978; c=relaxed/simple;
	bh=tt1Kxws8S/49Rl25gI1mbxI3K8SzjKBhZkb8ZQaojR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K+VID/gR8NmTtHpcql86wH6ilHXUNWogqHNjVpC/Gtw/ah5Dn253xtVUNC5vYB2mzJwU/weJ31t12q3c4he1kEoNcg0iaBslZCeqAKvVneNX/om+MrR3/Ogul105Fe7YCrpKVEbt1Y2edvtlB+VhB4q1OfZJc7+psc7tsf5bCVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qy6K69a7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qy6K69a7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 959F71F000E9;
	Fri,  7 Aug 2026 14:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113977;
	bh=lB820XcmtHIsIQS44q9C6dO6Y3WFCHCuiahGo4wGnt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qy6K69a7xvYc0Bas+KxaxzZ5BAT0E+bTP+s+gyR6AYiou5Sx9qDS9hx6mmya/i3Or
	 +rLxW5JzLMMM4LcyhmmTDqfmy8VpywpQY2tPRFRwuyTXs8s8S2i9ZaEIerucZDbQJh
	 e5l3Pt2x2xptB7lRFDCP5ez5cro8k0SqcAbplbBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 101/337] Bluetooth: ISO: avoid deadlocks in iso_sock_timeout
Date: Fri,  7 Aug 2026 16:35:04 +0200
Message-ID: <20260807143420.728110054@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit 200fa1629c57a3ca2b03d3ca63fd3a9bfd910c43 ]

iso_sock_timeout() takes lock_sock, so sync disabling the timer while
holding that lock may deadlock.

iso_sock_timeout() may also run concurrently with iso_conn_del(), which
leads to UAF

        [Task 1]                      [Task hdev->workqueue]
        iso_sock_timeout              iso_conn_del
          iso_conn_hold_unless_zero     iso_chan_del
                           `------------> iso_conn_put
                                      caller frees hcon
          iso_conn_put
            iso_conn_free
              conn->hcon->iso_data = NULL; /* UAF */

Fix the deadlock by removing the disable from the lock_sock sections.
Move the timer from iso_conn to iso_pinfo to decouple it from iso_conn
which may need to be freed in lock_sock section. Convert some of the
clear_timer to disable_timer.

Fixes: dc26097bdb86 ("Bluetooth: ISO: Use kref to track lifetime of iso_conn")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 60 ++++++++++++++++++++++-----------------------
 1 file changed, 29 insertions(+), 31 deletions(-)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index a1c350defcb3a..5b53de4589471 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -30,8 +30,6 @@ struct iso_conn {
 	spinlock_t	lock;
 	struct sock	*sk;
 
-	struct delayed_work	timeout_work;
-
 	struct sk_buff	*rx_skb;
 	__u32		rx_len;
 	__u16		tx_sn;
@@ -74,6 +72,7 @@ struct iso_pinfo {
 	__u8			base_len;
 	__u8			base[BASE_MAX_LENGTH];
 	struct iso_conn		*conn;
+	struct delayed_work	timeout_work;
 };
 
 static struct bt_iso_qos default_qos;
@@ -109,9 +108,6 @@ static void iso_conn_free(struct kref *ref)
 		hci_conn_drop(conn->hcon);
 	}
 
-	/* Ensure no more work items will run since hci_conn has been dropped */
-	disable_delayed_work_sync(&conn->timeout_work);
-
 	kfree_skb(conn->rx_skb);
 
 	kfree(conn);
@@ -152,48 +148,45 @@ static struct sock *iso_sock_hold(struct iso_conn *conn)
 
 static void iso_sock_timeout(struct work_struct *work)
 {
-	struct iso_conn *conn = container_of(work, struct iso_conn,
-					     timeout_work.work);
-	struct sock *sk;
-
-	conn = iso_conn_hold_unless_zero(conn);
-	if (!conn)
-		return;
-
-	iso_conn_lock(conn);
-	sk = iso_sock_hold(conn);
-	iso_conn_unlock(conn);
-	iso_conn_put(conn);
-
-	if (!sk)
-		return;
+	struct iso_pinfo *pi = container_of(work, struct iso_pinfo,
+					    timeout_work.work);
+	struct sock *sk = &pi->bt.sk;
 
 	BT_DBG("sock %p state %d", sk, sk->sk_state);
 
 	lock_sock(sk);
-	sk->sk_err = ETIMEDOUT;
-	sk->sk_state_change(sk);
+	if (!sock_flag(sk, SOCK_ZAPPED)) {
+		sk->sk_err = ETIMEDOUT;
+		sk->sk_state_change(sk);
+	}
 	release_sock(sk);
-	sock_put(sk);
 }
 
 static void iso_sock_set_timer(struct sock *sk, long timeout)
 {
+	lockdep_assert(lockdep_sock_is_held(sk));
+
+	cancel_delayed_work(&iso_pi(sk)->timeout_work);
+
 	if (!iso_pi(sk)->conn)
 		return;
 
 	BT_DBG("sock %p state %d timeout %ld", sk, sk->sk_state, timeout);
-	cancel_delayed_work(&iso_pi(sk)->conn->timeout_work);
-	schedule_delayed_work(&iso_pi(sk)->conn->timeout_work, timeout);
+	schedule_delayed_work(&iso_pi(sk)->timeout_work, timeout);
 }
 
 static void iso_sock_clear_timer(struct sock *sk)
 {
-	if (!iso_pi(sk)->conn)
-		return;
+	BT_DBG("sock %p state %d", sk, sk->sk_state);
+	cancel_delayed_work(&iso_pi(sk)->timeout_work);
+}
+
+static void iso_sock_disable_timer(struct sock *sk)
+{
+	lockdep_assert(!lockdep_sock_is_held(sk));
 
 	BT_DBG("sock %p state %d", sk, sk->sk_state);
-	cancel_delayed_work(&iso_pi(sk)->conn->timeout_work);
+	disable_delayed_work_sync(&iso_pi(sk)->timeout_work);
 }
 
 /* ---- ISO connections ---- */
@@ -218,7 +211,6 @@ static struct iso_conn *iso_conn_add(struct hci_conn *hcon)
 
 	kref_init(&conn->ref);
 	spin_lock_init(&conn->lock);
-	INIT_DELAYED_WORK(&conn->timeout_work, iso_sock_timeout);
 
 	hcon->iso_data = conn;
 	conn->hcon = hcon;
@@ -283,8 +275,9 @@ static void iso_conn_del(struct hci_conn *hcon, int err)
 		return;
 	}
 
+	iso_sock_disable_timer(sk);
+
 	lock_sock(sk);
-	iso_sock_clear_timer(sk);
 	iso_chan_del(sk, err);
 	release_sock(sk);
 	iso_sock_kill(sk);
@@ -766,6 +759,8 @@ static void iso_sock_cleanup_listen(struct sock *parent)
  */
 static void iso_sock_kill(struct sock *sk)
 {
+	iso_sock_disable_timer(sk);
+
 	lock_sock(sk);
 
 	if (!sock_flag(sk, SOCK_ZAPPED) || sk->sk_socket ||
@@ -864,8 +859,9 @@ static void __iso_sock_close(struct sock *sk)
 /* Must be called on unlocked socket. */
 static void iso_sock_close(struct sock *sk)
 {
+	iso_sock_disable_timer(sk);
+
 	lock_sock(sk);
-	iso_sock_clear_timer(sk);
 	__iso_sock_close(sk);
 	release_sock(sk);
 }
@@ -934,6 +930,8 @@ static struct sock *iso_sock_alloc(struct net *net, struct socket *sock,
 	iso_pi(sk)->qos = default_qos;
 	iso_pi(sk)->sync_handle = -1;
 
+	INIT_DELAYED_WORK(&iso_pi(sk)->timeout_work, iso_sock_timeout);
+
 	bt_sock_link(&iso_sk_list, sk);
 	return sk;
 }
-- 
2.53.0



