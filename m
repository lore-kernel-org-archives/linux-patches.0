Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D060B3C1092;
	Sat, 17 Oct 2026 17:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259358; cv=none; b=V3Z4wJn6x1S5Q8ixQsfGrt0hTEmfrQFm3eLundrKya1XklJbfxjzQstjJNnVRV1MMy/ch4Qm+AhovkvFtHbMZZlmponq0ut8cokUv0IqDFlv4K9g2lT4oB4AwnR4VDX0+31xAs2k2ZdjqnpDOwNcjGWYaLa2WpjfqVF42FAqqSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259358; c=relaxed/simple;
	bh=mruUy/Tu+OwzwddqrVWPL4uMQIHGS2Gh4huDwiVmESU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V2HiMZzzwSdoxBcpBb6U0WejybyrDZ9wnGq7zUbOmTLPAaJdZp9GnxuwAXP7GcsoxASBdv2FcAT/PEl80CXfXbKjH9BAFpu1ij4EqdbBnDWcyCOANpE555Bt1GNa3kA7Uh09ezErBCvtk9p+sQXTzTCZRCmqWn2XrkS8MkaQt3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2KjzJptt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2KjzJptt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F10D11F000C4;
	Sat, 17 Oct 2026 17:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259357;
	bh=svtDgu6IxeIAadRZIbkWdNy0NKDi7caDdgJG4ZKPRu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2KjzJptt8C2Euhs5hMIK71mv5yYdKZ8xXYHRjrX1e6krQQCtSPbp6VGfD/KhtnBfu
	 EArt8W3E4cKztbavm901uM6Kt7BogIbLG/8Sp765hbKxZyoIkd1P6UHlx4Zi52b+A7
	 JouQ06SprbxhUDfslJ/k77Vaqxb5xAOCcjzx4+44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1185/1674] Bluetooth: ISO: hold sk properly in iso_conn_ready
Date: Sat, 17 Oct 2026 17:57:37 +0200
Message-ID: <20261017160501.559959047@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 net/bluetooth/iso.c | 29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 2dd8e6e6beac5..0bce3f1759dd2 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -735,11 +735,13 @@ static void iso_sock_kill(struct sock *sk)
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
@@ -1696,14 +1698,11 @@ static void iso_sock_ready(struct sock *sk)
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
@@ -1726,7 +1725,7 @@ static bool iso_match_pa_sync_flag(struct sock *sk, void *data)
 static void iso_conn_ready(struct iso_conn *conn)
 {
 	struct sock *parent = NULL;
-	struct sock *sk = conn->sk;
+	struct sock *sk;
 	struct hci_ev_le_big_sync_estabilished *ev = NULL;
 	struct hci_ev_le_pa_sync_established *ev2 = NULL;
 	struct hci_evt_le_big_info_adv_report *ev3 = NULL;
@@ -1734,8 +1733,26 @@ static void iso_conn_ready(struct iso_conn *conn)
 
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



