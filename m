Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590094;
	b=3J1YJdVlHitCp+hdBxVcApud1v39x8ZNw2ssN8dEwZDJoHBpxllsFN9rUu3Ksfrr5BoM
	 EMvqwE+5pNnb43ddJjaujCf4ro5xAQpCxzxDMfZkiC5gipYXCHsMXZhsCNRlK54NNmOi4
	 UxXEAKz90c9wYm56XTFkxY4L499ZAH1YPADkng5O0ZOWJWehmf6mUTlBc1pZovTl3Ibkm
	 X/CPdgbHsGqxkMTeP8Tg40VuWrOAMeZPLc3YcisiOreH7UXNQttOVkAU0tYn8ZbsJRm2X
	 tpgqxcGtacQjZg/FEzUQ/xM4XgXsWqEHQvpTx5HTg1hGeNfJmgmxPGL/CVKvR73pgzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590094;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s1WGCq5cZD4T0mITXZSBdXP2p8pGXeL2fTY0fai0kDk=;
	b=hCMBSWB1HvDqG2l+5LyZb+UU/EUBSpSYutPE+OfE1vnH5AM4zG8WlBHf+ReiLJ5T8KGe
	 gp+MNhaVz8w7WtLyyQ8iXWsf9kQSaCm5U6QsTouix8A81cLlCc8Rb5+TDen1EsIk+E9t+
	 4NbPHjUDm7zFJeCg6TCByVfK6vuU5z7x20RUMjxqk+3ujjZoILWnuLCsU9XM9uac1PF//
	 5jKHz6jIvfsuNtOJfXBP+Ix2bBYW2m6QsYAajhZzjEoMDSQXBbBh41kN3qjnj0oArsU1W
	 0TgcPic0aCRWmUuivrCt4wOKS/zDxtYAhp3Gy7c+b6emwzHjRNoCBX1aUm/MLpkzNlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aatLT+H0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E52606C0BC;
	Fri, 13 Nov 2026 17:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aatLT+H0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 340081F000C4;
	Fri, 13 Nov 2026 17:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590094;
	bh=s1WGCq5cZD4T0mITXZSBdXP2p8pGXeL2fTY0fai0kDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aatLT+H0VYO79liXRo1V7OWrcSyfbQ5v48UphpukZV3ygUz6cn248u5AS3vepLi1s
	 u1KMPbE2YVbq7owkGo1PnoANdKNGZQnNI0n/36ZGNyQciyzPX67mRTAyLA7xh7aENh
	 hJczOwPob3ivTWhOR++glAdeSX6QOiq0gt/eUDQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 119/686] ax25: put an incoming connection on the listeners queue once it is set up
Date: Fri, 13 Nov 2026 10:44:12 -0500
Message-ID: <20261113153824.863916469@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

On a SABM for a listening socket, ax25_rcv() puts the skb on the
listener's receive queue as soon as the new socket is made, then
releases the listener and only afterwards fills in the connection:
addresses, digipeater path, modulus and window (read from the skb),
UA, state 3, ax25_cb_add() and the timers.

accept() can take the socket in between. If its owner closes it at
once, ax25_release() finds it in state 0 and frees it, and
ax25_rcv() goes on writing to the freed control block, adds it to
ax25_list and reads the freed skb.

Keep a place in the listener's backlog when the socket is made, and
put the skb on its queue once the connection is complete. If the
listener has been closed meanwhile, leave the connection to its
heartbeat, as ax25_destroy_socket() does with the connections that
were still waiting on its queue.

Tested on a QEMU bench (6.12.94 with KASAN and lockdep, two guests over
a KISS serial link). A listens on TESTA-9 and a thread calls accept()
in a loop on the non-blocking socket, closing each socket it gets at
once; B calls TESTA-9 five times:

  before: BUG: KASAN: slab-use-after-free in ax25_rcv (write of 7
          bytes), refcount_t: addition on 0, and a stale entry left in
          /proc/net/ax25, without any delay added
  after:  no report, ax25 refcount back to its starting value,
          /proc/net/ax25 empty, five runs out of five

With an mdelay(300) after the listener is released in ax25_rcv() the
results are the same. A third case closes the listener while
ax25_rcv() is held just before queueing the skb: the connection is
freed by its heartbeat, with no report and nothing left behind, three
runs out of three.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit d25d30927389f49e902185ef4647861f7654270e)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ax25/ax25_in.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/net/ax25/ax25_in.c b/net/ax25/ax25_in.c
index cb48a479ba3cc..fd8669e5b7313 100644
--- a/net/ax25/ax25_in.c
+++ b/net/ax25/ax25_in.c
@@ -401,11 +401,12 @@ static int ax25_rcv(struct sk_buff *skb, struct net_device *dev,
 			}
 		}
 
-		skb_set_owner_r(skb, make);
-		skb_queue_head(&sk->sk_receive_queue, skb);
-
-		make->sk_state = TCP_ESTABLISHED;
-
+		/*
+		 * Keep a place in the backlog, but put the skb on the
+		 * listener's queue only once the connection is set up
+		 * below: accept() takes it from there, and close() on the
+		 * new socket frees the connection.
+		 */
 		sk_acceptq_added(sk);
 		bh_unlock_sock(sk);
 	} else {
@@ -488,8 +489,25 @@ static int ax25_rcv(struct sk_buff *skb, struct net_device *dev,
 		ax25_kick(ax25);
 
 	if (sk) {
-		if (!sock_flag(sk, SOCK_DEAD))
+		bh_lock_sock(sk);
+		skb_set_owner_r(skb, make);
+		if (sk->sk_state == TCP_LISTEN && !sock_flag(sk, SOCK_DEAD)) {
+			skb_queue_head(&sk->sk_receive_queue, skb);
 			sk->sk_data_ready(sk);
+		} else {
+			/*
+			 * The listener was closed meanwhile: leave the
+			 * connection to its heartbeat, as
+			 * ax25_destroy_socket() does with the connections
+			 * that were still waiting on its queue.
+			 */
+			sk_acceptq_removed(sk);
+			kfree_skb(skb);
+			sock_orphan(make);
+			make->sk_state = TCP_LISTEN;
+			ax25->state = AX25_STATE_0;
+		}
+		bh_unlock_sock(sk);
 		sock_put(sk);
 	} else {
 free:
-- 
2.53.0



