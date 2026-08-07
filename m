Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB20473C93;
	Fri,  7 Aug 2026 15:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116916; cv=none; b=SLulZwWkUYTJULdyAFvhPStvk3abSyRLqJytsScXacf0PoUonqmI/I5FUzW2ThOfBAtEeJe16nbrX58PUI6Y3p6fYVgMbT8vBoqheEHaxWuRni7fxL0MSMH3z0dmBWtQHgih22psXphiVo+mHvTxZfZClnhIwysxLRNFqYN669E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116916; c=relaxed/simple;
	bh=AOl4lHFsHnVDZm/HjSqQcTYlooxueqA4JuhpOJBQNFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E1XASpSnSzHPgtVsRRLeeuimFk6uDtqxZyavPwgcQur+xLZJOs5w9hug6tu0XZmS4vU3hkYCAIlVCqYPjmOHAzKfFnionj7mSeSk5P71h2dJUIp1eJFAZ1+O6GL/Dp+G/mBn9v9vqg4mujps5ytvhdmzxG/JY+Tqtb+DTywi9Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B2Iu4F9o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B2Iu4F9o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04C811F00A3D;
	Fri,  7 Aug 2026 15:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116914;
	bh=SC6EQiKBLXay9HdrapcTvR3oB5Tz4zyV95RkdxbhE/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B2Iu4F9o6HVNWINRhrlQXB7D05OXBbtZ0OBtD+EoL7t8iRA+1EzZF6pRflPHjDXv7
	 Q7i//L2GDAhcUXs1WWxrpX853gGKMAE1SSrPJkOj+TpOyzZmJbiu8URsLSMEYOeIoO
	 MJEQnvNrZjLes6npv8JtupQni5NywNr2NNt5uRPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 135/438] Bluetooth: ISO: hold sk properly in iso_conn_ready
Date: Fri,  7 Aug 2026 16:35:31 +0200
Message-ID: <20260807143430.881911597@linuxfoundation.org>
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

[ Upstream commit 0d255e63fcf3f13a570d7ac11678fa1164ac015c ]

sk deref in iso_conn_ready must be done either under conn->lock, or
holding a refcount, to avoid concurrent close. conn->sk is currently
accessed without either:

    [Task 1]            [Task 2]
                        iso_sock_release
    iso_conn_ready
      sk = conn->sk
                          lock_sock(sk)
                            conn->sk = NULL
      lock_sock(sk)
                          release_sock(sk)
                          iso_sock_kill(sk)
       UAF on sk deref

Fix possible UAF by holding sk refcount in iso_conn_ready().  Also
recheck after lock_sock that the socket is still valid.  Adjust locking
so conn->sk is cleared only under lock_sock.

Fixes: 27c24fda62b60 ("Bluetooth: switch to lock_sock in SCO")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 06b6fec364485..9d1ac27202664 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -804,11 +804,13 @@ static void iso_sock_kill(struct sock *sk)
 	BT_DBG("sk %p state %d", sk, sk->sk_state);
 
 	/* Sock is dead, so set conn->sk to NULL to avoid possible UAF */
+	lock_sock(sk);
 	if (iso_pi(sk)->conn) {
 		iso_conn_lock(iso_pi(sk)->conn);
 		iso_pi(sk)->conn->sk = NULL;
 		iso_conn_unlock(iso_pi(sk)->conn);
 	}
+	release_sock(sk);
 
 	/* Kill poor orphan */
 	bt_sock_unlink(&iso_sk_list, sk);
@@ -2046,23 +2048,17 @@ static void iso_sock_ready(struct sock *sk)
 {
 	BT_DBG("sk %p", sk);
 
-	if (!sk)
-		return;
-
-	lock_sock(sk);
+	lockdep_assert(lockdep_sock_is_held(sk));
 
 	switch (sk->sk_state) {
 	case BT_DISCONN:
 	case BT_CLOSED:
-		release_sock(sk);
 		return;
 	}
 
 	iso_sock_clear_timer(sk);
 	sk->sk_state = BT_CONNECTED;
 	sk->sk_state_change(sk);
-
-	release_sock(sk);
 }
 
 static bool iso_match_big(struct sock *sk, void *data)
@@ -2092,7 +2088,7 @@ static bool iso_match_dst(struct sock *sk, void *data)
 static void iso_conn_ready(struct iso_conn *conn)
 {
 	struct sock *parent = NULL;
-	struct sock *sk = conn->sk;
+	struct sock *sk;
 	struct hci_ev_le_big_sync_established *ev = NULL;
 	struct hci_ev_le_pa_sync_established *ev2 = NULL;
 	struct hci_ev_le_per_adv_report *ev3 = NULL;
@@ -2101,7 +2097,22 @@ static void iso_conn_ready(struct iso_conn *conn)
 
 	BT_DBG("conn %p", conn);
 
+	iso_conn_lock(conn);
+	sk = iso_sock_hold(conn);
+	iso_conn_unlock(conn);
+
 	if (sk) {
+		lock_sock(sk);
+
+		/* conn->sk may have become NULL if racing with sk close, but
+		 * due to held hdev->lock, it can't become different sk.
+		 */
+		if (!conn->sk) {
+			release_sock(sk);
+			sock_put(sk);
+			return;
+		}
+
 		/* Attempt to update source address in case of BIS Sender if
 		 * the advertisement is using a random address.
 		 */
@@ -2114,14 +2125,15 @@ static void iso_conn_ready(struct iso_conn *conn)
 			adv = hci_find_adv_instance(bis->hdev,
 						    bis->iso_qos.bcast.bis);
 			if (adv && bacmp(&adv->random_addr, BDADDR_ANY)) {
-				lock_sock(sk);
 				iso_pi(sk)->src_type = BDADDR_LE_RANDOM;
 				bacpy(&iso_pi(sk)->src, &adv->random_addr);
-				release_sock(sk);
 			}
 		}
 
-		iso_sock_ready(conn->sk);
+		iso_sock_ready(sk);
+
+		release_sock(sk);
+		sock_put(sk);
 	} else {
 		hcon = conn->hcon;
 		if (!hcon)
-- 
2.53.0



