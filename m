Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EDB3383C86;
	Fri,  7 Aug 2026 14:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114593; cv=none; b=ZIhvchhmkBrovQgO/xHMyepibULOR2RjVOs3nLOXmenzjLgYnuMvIqJbAWKYTnBHgUgPHsja2ldGQDBxqo3v5FhzT/8JZjWOOe+aMXKIyWmKRz+0WyOb+2kcH01pCu1yybwEXtO037029mmSEgJxPZZzLbp5fefi6k0D2Vj0Axg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114593; c=relaxed/simple;
	bh=jh97WJ0fksw0Thx/edqhogGZ90wdVAJOk4V0onsX1z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YjpqDkuAcVqTrowjTVjbM4E1Yj+hviSQ9qAtRT9vye+WoPqO2cUbxdTnpg8j5Gvf33iNVWZ7RDtKu6gLsgqEk6nd56GCBHDNzoYxMGt2eQaq9XE7+qIM77Ld7zCQvII5ZxDkyUePYs89WnI9FmGC77hN4m8NoXaT0AbihC1PQb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VeAiMtvn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VeAiMtvn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8E0F1F00A3D;
	Fri,  7 Aug 2026 14:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114587;
	bh=MoSmHwbypCltRx0ZRoHw28dLIiIcSUlUP8/H22TSKqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VeAiMtvnWHC5P4domaVXYfRt9FtvK1z4k7HQ/wPQH/Ucq/B2PGn5/wezJCyqm/a/4
	 BqEEBU/08ka3dEkr5CgM0eTurudLpXBZWB7JP6dLJUDzoNaLm73ShWkSyamgUc3Hx0
	 yKZ4yY/WgGr7CBBIOeLt44oSQDUKJRUhd++J65Sk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 272/337] Bluetooth: ISO: fix CONNECTED -> CLOSED transition on shutdown/release
Date: Fri,  7 Aug 2026 16:37:55 +0200
Message-ID: <20260807143424.436513494@linuxfoundation.org>
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

commit 0786469ee242952008628ed0e2d386098e2065ab upstream.

Commit d57e506f6a1e ("Bluetooth: ISO: clear iso_data always when detaching conn from hcon")
merged a version of the UAF fix that breaks releasing connected
ISO sockets. Since hci_conn::iso_data is set to NULL, iso_chan_del() won't
be called when the hci_conn disconnects, and the ISO socket does not emit
POLLHUP correctly.

Fix by retaining full hci_conn <-> iso_conn association while in
BT_DISCONNECT state, so that local disconnect via shutdown() follows
similar ISO socket code path as remote disconnect.  Use a separate flag
to track whether hci_conn_drop() is needed, instead of setting
iso_conn::hcon = NULL

In iso_sock_ready(), disallow disconnecting socket going BT_CONNECTED,
in case hcon connects while its drop is pending.

Fixes: d57e506f6a1e ("Bluetooth: ISO: clear iso_data always when detaching conn from hcon")
Fixes: fbdc4bc47268 ("Bluetooth: ISO: Use defer setup to separate PA sync and BIG sync")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/iso.c |   26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -23,8 +23,14 @@ static struct bt_sock_list iso_sk_list =
 };
 
 /* ---- ISO connections ---- */
+enum {
+	ISO_CONN_DROPPED,
+	__ISO_CONN_NUM_FLAGS
+};
+
 struct iso_conn {
 	struct hci_conn	*hcon;
+	DECLARE_BITMAP(flags, __ISO_CONN_NUM_FLAGS);
 
 	/* @lock: spinlock protecting changes to iso_conn fields */
 	spinlock_t	lock;
@@ -105,7 +111,8 @@ static void iso_conn_free(struct kref *r
 
 	if (conn->hcon) {
 		conn->hcon->iso_data = NULL;
-		hci_conn_drop(conn->hcon);
+		if (!test_and_set_bit(ISO_CONN_DROPPED, conn->flags))
+			hci_conn_drop(conn->hcon);
 	}
 
 	kfree_skb(conn->rx_skb);
@@ -299,6 +306,7 @@ static int __iso_chan_add(struct iso_con
 
 	iso_pi(sk)->conn = conn;
 	conn->sk = sk;
+	clear_bit(ISO_CONN_DROPPED, conn->flags);
 
 	if (parent)
 		bt_accept_enqueue(parent, sk, true);
@@ -813,11 +821,8 @@ static void iso_sock_disconn(struct sock
 	}
 
 	sk->sk_state = BT_DISCONN;
-	iso_conn_lock(iso_pi(sk)->conn);
-	hci_conn_drop(iso_pi(sk)->conn->hcon);
-	iso_pi(sk)->conn->hcon->iso_data = NULL;
-	iso_pi(sk)->conn->hcon = NULL;
-	iso_conn_unlock(iso_pi(sk)->conn);
+	if (!test_and_set_bit(ISO_CONN_DROPPED, iso_pi(sk)->conn->flags))
+		hci_conn_drop(iso_pi(sk)->conn->hcon);
 }
 
 static void __iso_sock_close(struct sock *sk)
@@ -1894,9 +1899,18 @@ static void iso_sock_ready(struct sock *
 		return;
 
 	lock_sock(sk);
+
+	switch (sk->sk_state) {
+	case BT_DISCONN:
+	case BT_CLOSED:
+		release_sock(sk);
+		return;
+	}
+
 	iso_sock_clear_timer(sk);
 	sk->sk_state = BT_CONNECTED;
 	sk->sk_state_change(sk);
+
 	release_sock(sk);
 }
 


