Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C6346AA62;
	Fri,  7 Aug 2026 15:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116918; cv=none; b=j2PJRZK9F+uE9A8cRyx9OmPg1O3Xdpgy0DGppeDjNp39ItlEm85BAnULNfNYCr7YdCrwkDOgjUqzWB4LuDKauR0rpf0BiIJUopP0YpKiyGrZ9Ptjr711BVf+fLcO3TPt3FBtYTzLGhU2x9CiIxX/K+g/fOVWWYHhJsVWt5y069U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116918; c=relaxed/simple;
	bh=idwGwJ6O/Y3oh0XvptHw6gStaHgTMIBeS6geGkyLUP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nO1nqnzE/iRQFPm3xzpuHgjsJ1CV6xfaT+R/6ILnQ+rmR1AiQzqhHhge0phlLyd3Nqza4ZNvXCPtHEUvTicxp3PyNOZUsm7dR4AHXPBd6kIUZjHK+VsLutekSzqLYC5QQLYf4O2gJ0yHrQSIKc6gfmzf3ZMQWyq6UduG2d8XSeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O4USUbwp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O4USUbwp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE0A51F000E9;
	Fri,  7 Aug 2026 15:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116917;
	bh=Gy35Vm3lgH2SFgKSFkBYpmKlYhEWLNjsUv3ldRKHe9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O4USUbwp3Pf+inTVk3a9zCv33YrhWeY4/phS+wEBR073NkfyZTdWKbKH65JoVbQpe
	 AGMFRNvt53t8cIVuRoHzOF0cQ0dqD9GtKwjFFPV066C3opA10u53gdGwmtbN5FMw/J
	 GUZFX1W6igqQNXJnYsDF7ocBTjDsfHhD+XNLf20c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 136/438] Bluetooth: ISO: fix leaking sk after socket release
Date: Fri,  7 Aug 2026 16:35:32 +0200
Message-ID: <20260807143430.904666028@linuxfoundation.org>
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
 net/bluetooth/iso.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 9d1ac27202664..1ca3576357006 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -61,6 +61,7 @@ static void iso_sock_kill(struct sock *sk);
 enum {
 	BT_SK_BIG_SYNC,
 	BT_SK_PA_SYNC,
+	BT_SK_KILLED,
 };
 
 struct iso_pinfo {
@@ -294,6 +295,7 @@ static void iso_conn_del(struct hci_conn *hcon, int err)
 	iso_sock_clear_timer(sk);
 	iso_chan_del(sk, err);
 	release_sock(sk);
+	iso_sock_kill(sk);
 	sock_put(sk);
 }
 
@@ -797,24 +799,29 @@ static void iso_sock_cleanup_listen(struct sock *parent)
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
 
 	/* Sock is dead, so set conn->sk to NULL to avoid possible UAF */
-	lock_sock(sk);
 	if (iso_pi(sk)->conn) {
 		iso_conn_lock(iso_pi(sk)->conn);
 		iso_pi(sk)->conn->sk = NULL;
 		iso_conn_unlock(iso_pi(sk)->conn);
 	}
-	release_sock(sk);
 
 	/* Kill poor orphan */
 	bt_sock_unlink(&iso_sk_list, sk);
 	sock_set_flag(sk, SOCK_DEAD);
+	set_bit(BT_SK_KILLED, &iso_pi(sk)->flags);
+
+	release_sock(sk);
 	sock_put(sk);
 }
 
@@ -891,7 +898,6 @@ static void iso_sock_close(struct sock *sk)
 	iso_sock_clear_timer(sk);
 	__iso_sock_close(sk);
 	release_sock(sk);
-	iso_sock_kill(sk);
 }
 
 static void iso_sock_init(struct sock *sk, struct sock *parent)
@@ -2039,8 +2045,16 @@ static int iso_sock_release(struct socket *sock)
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



