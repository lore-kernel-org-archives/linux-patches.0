Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215638;
	b=08kmLGayIQQ1ti7uuToqUo99fCuj/bDNHUaKzzItD8eqTa3MeIQDtlFOMI5V1Sh/Ufw7
	 B/JlnoKsnYDQ9V3lryPiOTZnX5P9QokTeQUKX8xdITXbuKl/hUfXG7m49AjDXnEY9GU7B
	 zY7yhEd7H7jsi/dtQ7wCS1L/kMi/cbjh4LHnQvfj6fWoqLpDZuoAPoWlGL21ds7WpGYmw
	 kBs9iG6ucS/j2bNQC8mpxbE2Na9XIBvl076jPAm47xZHXks9vtqHnozI7JKR0Rx/PcHij
	 kfrj2UKcXGOWlNgpVED60ogdPXpt4IbPwiCIv7U96/ng9JGez1nZ8XPfysSyw0gTtOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215638;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dpLJlhYcFtKcEIs9cd698Bjc3k115dV04ts/k8AOMWQ=;
	b=08RMkzjvrUz5fnN0fIUSobbqBbPAcnckUnvmuOTxPnC5X81wzSv9K4Zb1cQyU9YxzZn0
	 lJZdtsZxXfPHqbFwtnZPQ8ZYc5m3WlJQE36hW8/iohH4ntKc+bCYMPMs9FJAfZ2Lo7ZU4
	 xzixb11zpraeWFN1nR4emf3zNsapRgQ95kR0SID3d6IGrUESi3M2rueyq79TnW0qzWoK+
	 1BoeLmuVWDT7HIw5toVRWoK88XNLPQ8nPZ6lTDkhzfpDeVloiJ4hnaJw5kZ+wJLsiGGOM
	 C6L4Z/5pXN8SF8ZxYm5EPuDUtl8zKHt17j9QESGm9LWAaPfVrxTKQJAqaKwTFDQedkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pwBkYl9F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA9B606A31C;
	Wed, 28 Oct 2026 19:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pwBkYl9F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07F4F1F01825;
	Wed, 28 Oct 2026 19:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215637;
	bh=dpLJlhYcFtKcEIs9cd698Bjc3k115dV04ts/k8AOMWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pwBkYl9F0q78r+skvSbkD9W8O/M1ezs3yHKVm3umRezrZM2d89SZnx5+bGc/eYoF3
	 D2N26AACRyeVuxkRiCggqGe3GojoXhoyPN/qca7azIwHTjD1U4UEmf7ViKi5sFkgHL
	 YYeI14GGhbHSNsXJdFoJjsOF/CBh/nxFf8liarA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1281/1887] Bluetooth: ISO: hold sk properly in iso_conn_ready
Date: Wed, 28 Oct 2026 17:56:17 +0100
Message-ID: <20261028170528.577359665@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 net/bluetooth/iso.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 2281a915c6533..999ed7df4dfa3 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -1463,14 +1463,11 @@ static void iso_sock_ready(struct sock *sk)
 {
 	BT_DBG("sk %p", sk);
 
-	if (!sk)
-		return;
+	lockdep_assert(lockdep_sock_is_held(sk));
 
-	lock_sock(sk);
 	iso_sock_clear_timer(sk);
 	sk->sk_state = BT_CONNECTED;
 	sk->sk_state_change(sk);
-	release_sock(sk);
 }
 
 struct iso_list_data {
@@ -1488,14 +1485,32 @@ static bool iso_match_big(struct sock *sk, void *data)
 static void iso_conn_ready(struct iso_conn *conn)
 {
 	struct sock *parent;
-	struct sock *sk = conn->sk;
+	struct sock *sk;
 	struct hci_ev_le_big_sync_estabilished *ev;
 	struct hci_conn *hcon;
 
 	BT_DBG("conn %p", conn);
 
+	iso_conn_lock(conn);
+	sk = iso_sock_hold(conn);
+	iso_conn_unlock(conn);
+
 	if (sk) {
-		iso_sock_ready(conn->sk);
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
+		iso_sock_ready(sk);
+
+		release_sock(sk);
+		sock_put(sk);
 	} else {
 		hcon = conn->hcon;
 		if (!hcon)
-- 
2.53.0



