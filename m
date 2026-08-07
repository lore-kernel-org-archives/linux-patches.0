Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDE8303C97;
	Fri,  7 Aug 2026 14:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113975; cv=none; b=bZvClKwxXl5u4xZtxrMLl6mO+Cai1Vl4VU0X/uTVoMKCZUC4P0AOI5imgISkHikpn4MmHPwLZ/2+9/PUsgqqgSigiVBdxUddvLoxYTZ7Pd/y0XqeSWiq0KPCy6UUFCorRERdUI80sbBGzDosSC3ijE55ncH0Fhe/fj79tfavD9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113975; c=relaxed/simple;
	bh=iu5491i3bRrknRJcGymF7qQXBF1qdiPvAHlmXTJwdIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tq4hHmCmo5aaUMlvxI2yh6zUULbzGenX4ZwJpZ5YiEIHDWg+gnar8/yRQE4rC1Oaq8zhTD16CC+kBaPLQmJze2b3KeXrYBoFEAHhkJGbYTY0f14n1vwxuUuU057rphTi62vfRek8+GMTx2xU7serwHBEzyNC/qBeaUbHuEwWjjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0c8A5wl6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0c8A5wl6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A35871F000E9;
	Fri,  7 Aug 2026 14:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113974;
	bh=lzjLyMDGF7wCkJjcrKsNJKTNYYbVfSzyM4u/sb+cIj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0c8A5wl6eP82cV0u5/moXtawHHx3z/lcsrZfE+MdVfFLmDTt2uIPAYFcHKzs9j1yx
	 DXE90dkSufDwx750mr7R8HpKajhsU3QIxPFkiTODs59Z6znvukiHIwst748983kEeZ
	 4SCD+0xY2u7lz9tICstnQwXbffgwMPy0DfOF/XZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 100/337] Bluetooth: ISO: fix leaking sk after socket release
Date: Fri,  7 Aug 2026 16:35:03 +0200
Message-ID: <20260807143420.707978487@linuxfoundation.org>
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

[ Upstream commit ce57442a379212fe3fda59c9437ee8217eceb5b1 ]

iso_sock_kill() tests !sock_flag(sk, SOCK_ZAPPED) || sk->sk_socket ||
sock_flag(sk, SOCK_DEAD) for early return, but this is always true since
sock_orphan(sk) sets SOCK_DEAD, so the sk reference released by socket
always leaks, iso_sock_destruct is never called.

The socket reference also leaks when __iso_sock_close() does not set
SOCK_ZAPPED, since iso_conn_del() does not call iso_sock_kill() after
zapping.

Fix by replacing SOCK_DEAD by BT_SK_KILLED flag that is not used for
something else, and lock_sock to ensure iso_sock_kill() puts sk only
after socket release only once. Release and iso_conn_del may run
concurrently. Call iso_sock_kill() from iso_conn_del() to clean sk up
after zapping.

Remove call to iso_sock_kill() from iso_sock_close(), as it's generally
no-op there.

Fixes: ccf74f2390d6 ("Bluetooth: Add BTPROTO_ISO socket type")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 06c68e053b423..a1c350defcb3a 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -55,6 +55,7 @@ static void iso_sock_kill(struct sock *sk);
 enum {
 	BT_SK_BIG_SYNC,
 	BT_SK_PA_SYNC,
+	BT_SK_KILLED,
 };
 
 struct iso_pinfo {
@@ -286,6 +287,7 @@ static void iso_conn_del(struct hci_conn *hcon, int err)
 	iso_sock_clear_timer(sk);
 	iso_chan_del(sk, err);
 	release_sock(sk);
+	iso_sock_kill(sk);
 	sock_put(sk);
 }
 
@@ -764,9 +766,13 @@ static void iso_sock_cleanup_listen(struct sock *parent)
  */
 static void iso_sock_kill(struct sock *sk)
 {
+	lock_sock(sk);
+
 	if (!sock_flag(sk, SOCK_ZAPPED) || sk->sk_socket ||
-	    sock_flag(sk, SOCK_DEAD))
+	    test_bit(BT_SK_KILLED, &iso_pi(sk)->flags)) {
+		release_sock(sk);
 		return;
+	}
 
 	BT_DBG("sk %p state %d", sk, sk->sk_state);
 
@@ -780,6 +786,9 @@ static void iso_sock_kill(struct sock *sk)
 	/* Kill poor orphan */
 	bt_sock_unlink(&iso_sk_list, sk);
 	sock_set_flag(sk, SOCK_DEAD);
+	set_bit(BT_SK_KILLED, &iso_pi(sk)->flags);
+
+	release_sock(sk);
 	sock_put(sk);
 }
 
@@ -859,7 +868,6 @@ static void iso_sock_close(struct sock *sk)
 	iso_sock_clear_timer(sk);
 	__iso_sock_close(sk);
 	release_sock(sk);
-	iso_sock_kill(sk);
 }
 
 static void iso_sock_init(struct sock *sk, struct sock *parent)
@@ -1867,8 +1875,16 @@ static int iso_sock_release(struct socket *sock)
 		release_sock(sk);
 	}
 
+	/* Make sure sk is valid even if iso_conn_del() is concurrent */
+	sock_hold(sk);
+
+	lock_sock(sk);
 	sock_orphan(sk);
+	release_sock(sk);
+
 	iso_sock_kill(sk);
+
+	sock_put(sk);
 	return err;
 }
 
-- 
2.53.0



