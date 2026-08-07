Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C4D324B0A;
	Fri,  7 Aug 2026 15:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114983; cv=none; b=tZ4gpBZmijgOezgNVVDgjk4w9fiSw4DdloVVwNNJPIMsqz74fwManQbCuvxvoLxxqJ7G428tBjScvSCBYRPfxDZeed9FYW4qtY/+NEzynmmhs1p844s26AmIcHQcLYTfrSXdBeKDfkC6KFJtfxF0m1JQr9X+plEFeL7carB0Z4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114983; c=relaxed/simple;
	bh=542qdbJABVP3duv6NPbC2tMMZw5Z+gYc8DP+HjU2Gb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D0bdHaw8WRCB4yqopbdCYd9kryLJGDf7w0iP0JrGr7rhS6k14OtVL9RZhir+JErdCAOiljpNr8zusOBRSlio4L5jbAHqdU4FNA0wKvv4lx1rH1aLg+LlULMbKoY0dJB9c3BjfPyu2xsPTWUWPU4pDAWKzoHvE5UfpfZkunYwIEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vqo2lltC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vqo2lltC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C5EC1F000E9;
	Fri,  7 Aug 2026 15:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114982;
	bh=dGizZ32ffdDEPTLxeQ0NoH2bE7smydBPlEzlmemixgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vqo2lltCFWDO9QVHZpOY+kkZh5zx6zMBBrPAvFjT/jViifVTb/jf6rBmKMYKzZi41
	 ScvhsptC7V1xibc6WCuapAzVVzaTwPH5NpVazxM+sq2l8Rq3dUEEQBzdVUpKnCzVHR
	 JVbG2n7jGM9DWuFwL3yYRha//o0G0RxYwRNromPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 116/396] Bluetooth: ISO: hold sk properly in iso_conn_ready
Date: Fri,  7 Aug 2026 16:34:36 +0200
Message-ID: <20260807143426.802664841@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index fb77a7e22a9dd..cb629734062a5 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -787,11 +787,13 @@ static void iso_sock_kill(struct sock *sk)
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
@@ -1965,23 +1967,17 @@ static void iso_sock_ready(struct sock *sk)
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
@@ -2006,7 +2002,7 @@ static bool iso_match_pa_sync_flag(struct sock *sk, void *data)
 static void iso_conn_ready(struct iso_conn *conn)
 {
 	struct sock *parent = NULL;
-	struct sock *sk = conn->sk;
+	struct sock *sk;
 	struct hci_ev_le_big_sync_established *ev = NULL;
 	struct hci_ev_le_pa_sync_established *ev2 = NULL;
 	struct hci_ev_le_per_adv_report *ev3 = NULL;
@@ -2014,7 +2010,22 @@ static void iso_conn_ready(struct iso_conn *conn)
 
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
@@ -2027,14 +2038,15 @@ static void iso_conn_ready(struct iso_conn *conn)
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



