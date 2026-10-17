Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA094CF489;
	Sat, 17 Oct 2026 16:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254584; cv=none; b=akUUFb/xwOKkTZJIwgiKUCN1V9z4piH2xDdUNj8OaO3qXBrzsTpJzSJH1zMO5rgmmi/2IWxnSppZmpG+ZwMj3z7fx8xQZm1XNddnVwbQ9aOyEr0BVcKIrLLp8YeLOzUmEVqnRBH8LKXj0VhmTQG9pRVHC3ydqMuzMJLw/mA/skg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254584; c=relaxed/simple;
	bh=IGx1oXKTdrKozXwRyYJXK8Go65Up65D6rDjV0B6l+Fs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oGxTRLzGRTUe1NNBuGJBShzSbIbkAeqfPvFh4xcDq76AovP0CPA0UJ+QQr11l+ox8pIiFnPSrmHQGn1nhWep5hjjCSdXER3P4YBfIJnu251bI69CZ43VGa+Simnsw9qLNVerRJYI8Dp50MImGJ8Zgxz8jxpqyci9M70QsSpO7Yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zX9Udn3v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zX9Udn3v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A5E01F000C4;
	Sat, 17 Oct 2026 16:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254582;
	bh=m+O1hV4AnbBPmPk+724O1//j3Xz2/zAiOhhwfIuoX2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zX9Udn3v9xZ6vhjXmdXUCg3d3NI7VruJ58XjnaZ/pkC9iFmAbka/+sgxHntDRbOzJ
	 6+srgyFc8RYSQGaCMTOZ/rZK9ybGpiq8BTq9KjpCkLlLIy+qHc8ggORaRJ8Qs4Z0/G
	 xnJBIb6rrXoZw7tiKOuA+zw3ZZBwTDLXp0GiqDvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 495/869] Bluetooth: ISO: hold sk properly in iso_conn_ready
Date: Sat, 17 Oct 2026 17:55:36 +0200
Message-ID: <20261017160049.802701522@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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
 net/bluetooth/iso.c | 30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 5b930d0e5a04c..89e59cdafd571 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -1980,23 +1980,17 @@ static void iso_sock_ready(struct sock *sk)
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
@@ -2014,7 +2008,7 @@ static bool iso_match_pa_sync_flag(struct sock *sk, void *data)
 static void iso_conn_ready(struct iso_conn *conn)
 {
 	struct sock *parent = NULL;
-	struct sock *sk = conn->sk;
+	struct sock *sk;
 	struct hci_ev_le_big_sync_estabilished *ev = NULL;
 	struct hci_ev_le_pa_sync_established *ev2 = NULL;
 	struct hci_ev_le_per_adv_report *ev3 = NULL;
@@ -2022,8 +2016,26 @@ static void iso_conn_ready(struct iso_conn *conn)
 
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



