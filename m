Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2748471436;
	Fri,  7 Aug 2026 15:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116898; cv=none; b=P5Q/va0Saklr/m70F4YUf5akyO1ms/F1oDSaYa8/qPzzEdPZhLbyaH2aqyu5jhoOaCc4xjMV/Gkv53yf5p0KnRz4vPc0SnfuwOkXTdniEStyUsbuH+t07aJBsK91gQI3UNErBfOmQhLfkWCIxLRtxwon9nP9oBTMFOWYG3O5WU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116898; c=relaxed/simple;
	bh=Q7wIv2n+mgVT6EiKSjPv1qLQ9+4/zMvDC7uSNTQc/g0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nF8pJyPBmxnP4yGnldxBBF1Go9UXcQIMAiwYNQc3kGhZcS1KGaNMIF3yygLVjQ/8KgE4eUAXEB8iHCZRPNskGO1zZUVpOI0QXGulY5qrdyfPG06QUVlKOcDco87T/gPLu5oFka3uCP39DIfL/VorX8jk/OvvjD75ewPSOkZv8oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=inYTCdkv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="inYTCdkv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E70CD1F000E9;
	Fri,  7 Aug 2026 15:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116897;
	bh=iMVERx464SUsKoAOwVzE4Qo/aYJQhiEm9vkxex+5VD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=inYTCdkv53N3wU8OE07KJeyFYK5MtppfvXTwV5I1dyW9Ato1/NC+KEyekBiaLG00B
	 ticTOrOGU5e9aT4xQTngnrPZs+Ru2FlLtILs70321erdiYrEHrk2kNY570hXqRNtqu
	 hu7/enb6fn++lBtUjuAvXLihYUuBGlVSvV2g+byw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 130/438] Bluetooth: ISO: fix CONNECTED -> CLOSED transition on shutdown/release
Date: Fri,  7 Aug 2026 16:35:26 +0200
Message-ID: <20260807143430.765153402@linuxfoundation.org>
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

[ Upstream commit 0786469ee242952008628ed0e2d386098e2065ab ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 6bbbbce4c5f27..f1399ddd6ad05 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -23,8 +23,14 @@ static struct bt_sock_list iso_sk_list = {
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
@@ -106,7 +112,8 @@ static void iso_conn_free(struct kref *ref)
 
 	if (conn->hcon) {
 		conn->hcon->iso_data = NULL;
-		hci_conn_drop(conn->hcon);
+		if (!test_and_set_bit(ISO_CONN_DROPPED, conn->flags))
+			hci_conn_drop(conn->hcon);
 	}
 
 	/* Ensure no more work items will run since hci_conn has been dropped */
@@ -305,6 +312,7 @@ static int __iso_chan_add(struct iso_conn *conn, struct sock *sk,
 
 	iso_pi(sk)->conn = conn;
 	conn->sk = sk;
+	clear_bit(ISO_CONN_DROPPED, conn->flags);
 
 	if (parent)
 		bt_accept_enqueue(parent, sk, true);
@@ -834,11 +842,8 @@ static void iso_sock_disconn(struct sock *sk)
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
@@ -2041,9 +2046,18 @@ static void iso_sock_ready(struct sock *sk)
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
 
-- 
2.53.0



