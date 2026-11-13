Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590110;
	b=rqa74RNUdo013qLK07zZVXvzFWRb8WlCZkGH7kHt3kvIiy/+FKGr58uKq3qaZ7eq5xDS
	 a3/zp1qymuUGhE89+ig3ZN51nIF60gI+SmiqJ5fXF7WGd3TV2hJd6nvXmNQ1r4Z8uKvUo
	 SruVZUXnSml+CmIbPkpEJ16cjRfKs9moAe0xqsLcBRVmHnnrP1YPqmBiPdlnoLvEGfgt4
	 jQ3aNZJa1nv0KCkAnOzL66DlVUVcyT4Qe7KdK5YR1uRQzewLOmG7XbaSsdISBYzGF7l1z
	 1pD74eygTC4IUz/PNKkpzlCAy/pbcYf99ClJhgYS8i32IXUqkWaZxZgWvxesuHFWjcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590110;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jJiUYm0lBXS5nX39owszS2wupEBJp9RQspzkPG03+NM=;
	b=BsAH7c/XgsvgLqWmdO+MJuqjE1oR1MsB5jn2IV9hcRIFrSKB2ch6F+C5F7cnfjZviy4/
	 V1+9Te/HaHBu24z0kyzcgv7lwg8OVaCyxefmb0FUdnv6Pys+51wbTFZQRaUZW4sOos2EZ
	 XkraiflHJ9kdVag5L9qHo8p4Vx7htEOY9MN56O+zELxYAp0yF75uGq66/H3FLaBk/Cs8E
	 XL7O19BrQDQ7bhfPbrMaScLXnnhTaHa+9cSCyZZhPBll5h9vqlbBvVjxNODPz88wTbcxX
	 vYSwBpqOf7zqkJfdzA2GwvsoQSszrWrzePj3VRlYWeeB7w+YE7tdcbwRCr8wdc4VdpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XVSnbYkF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE23E606B208;
	Fri, 13 Nov 2026 17:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XVSnbYkF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59AD71F000C4;
	Fri, 13 Nov 2026 17:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590110;
	bh=jJiUYm0lBXS5nX39owszS2wupEBJp9RQspzkPG03+NM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XVSnbYkF9Wc2xfHyA5tH8zrtBemIip1S+pIFpwme+DLVAXpIe2vnjpub+d7frLmvc
	 5ZoNUZNHU1WX8UlZT3u3pStZ0bj5xcBbHMgsn93bX9VLjGbsVtqFlc7WKB6n3dFnRi
	 fNuYp4gFx057M/YDrYIHWgEyArfCUiW6YCx8RaCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 131/686] netrom: dont give the same circuit ID to two sockets
Date: Fri, 13 Nov 2026 10:44:24 -0500
Message-ID: <20261113153825.256853784@linuxfoundation.org>
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

nr_connect() and nr_rx_frame() pick a circuit ID with
nr_find_next_circuit(), which looks for an ID that no socket on nr_list
uses, and then store it in the socket and advance the global circuit
counter. The search and the assignment are not done under one lock, and
in nr_rx_frame() the new socket only goes on nr_list at the end. Two
sockets doing it at the same time can get the same ID.

The far end then answers both circuits with the same ID: the CONNACK of
one goes to the socket found first, the other connect() never
completes, and the frames of the two circuits are mixed up.

Pick the ID and give it to the socket under nr_list_lock, with the
socket already on nr_list: nr_connect() runs once the socket is bound,
and nr_rx_frame() now puts the new socket on nr_list under the same
lock. The global counter is then also only changed under that lock.
nr_list_lock is still not taken under a socket lock.

This is the same fix as rose_assign_lci() for ROSE.

Tested on two QEMU guests (6.12.94, KASAN, lockdep) linked by KISS: A
starts eight connect() calls at the same time to a listening socket on
B, bound and unbound sockets alternately, six rounds, and looks for
duplicate circuit IDs in /proc/net/nr. The "slow" runs add mdelay(2)
between the choice of the ID and its assignment, to widen the window.

                 connected   duplicate pairs   rounds with duplicates
  before, slow     25/48           37                 6/6
  after, slow      48/48            0                 0/6
  before           48/48            0                 0/6
  after            48/48            0                 0/6

No kernel report in any run, and no lockdep report for the new
nr_list_lock taken in nr_rx_frame().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit 64166a6489d7eb3b7ba6bc8f534b008402a60fec)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netrom/af_netrom.c | 55 ++++++++++++++++++++++++------------------
 1 file changed, 32 insertions(+), 23 deletions(-)

diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
index e3daae77e43e5..e3392e6dbc2eb 100644
--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -208,29 +208,40 @@ static struct sock *nr_find_peer(unsigned char index, unsigned char id,
 }
 
 /*
- *	Find next free circuit ID.
+ *	Give a socket the next free circuit ID. The search and the assignment
+ *	are done under nr_list_lock, which the caller holds, with the socket
+ *	already on nr_list: two sockets cannot pick the same ID.
  */
-static unsigned short nr_find_next_circuit(void)
+static void nr_assign_circuit(struct nr_sock *nr)
 {
 	unsigned short id = circuit;
 	unsigned char i, j;
-	struct sock *sk;
+	struct sock *s;
+	bool used;
+
+	lockdep_assert_held(&nr_list_lock);
 
 	for (;;) {
 		i = id / 256;
 		j = id % 256;
 
 		if (i != 0 && j != 0) {
-			sk = nr_find_socket(i, j, NULL);
-			if (!sk)
+			used = false;
+			sk_for_each(s, &nr_list)
+				if (nr_sk(s)->my_index == i && nr_sk(s)->my_id == j) {
+					used = true;
+					break;
+				}
+			if (!used)
 				break;
-			sock_put(sk);
 		}
 
 		id++;
 	}
 
-	return id;
+	nr->my_index = i;
+	nr->my_id    = j;
+	circuit      = id + 1;
 }
 
 /*
@@ -709,14 +720,10 @@ static int nr_connect(struct socket *sock, struct sockaddr *uaddr,
 
 	nr->dest_addr = addr->sax25_call;
 
-	release_sock(sk);
-	circuit = nr_find_next_circuit();
-	lock_sock(sk);
-
-	nr->my_index = circuit / 256;
-	nr->my_id    = circuit % 256;
-
-	circuit++;
+	/* The socket is on nr_list now, so others see the ID it gets */
+	spin_lock_bh(&nr_list_lock);
+	nr_assign_circuit(nr);
+	spin_unlock_bh(&nr_list_lock);
 
 	/* Move to connecting socket, start sending Connect Requests */
 	sock->state  = SS_CONNECTING;
@@ -1013,15 +1020,19 @@ int nr_rx_frame(struct sk_buff *skb, struct net_device *dev)
 	nr_make->your_index  = circuit_index;
 	nr_make->your_id     = circuit_id;
 
+	/*
+	 * Put the new socket on nr_list as it gets its circuit ID, under the
+	 * same lock, so that no other socket can be given the same ID.
+	 * nr_list_lock is not taken under a socket lock (nr_info_show() takes
+	 * them the other way round).
+	 */
 	bh_unlock_sock(sk);
-	circuit = nr_find_next_circuit();
+	spin_lock_bh(&nr_list_lock);
+	nr_assign_circuit(nr_make);
+	sk_add_node(make, &nr_list);
+	spin_unlock_bh(&nr_list_lock);
 	bh_lock_sock(sk);
 
-	nr_make->my_index    = circuit / 256;
-	nr_make->my_id       = circuit % 256;
-
-	circuit++;
-
 	/* Window negotiation */
 	if (window < nr_make->window)
 		nr_make->window = window;
@@ -1056,8 +1067,6 @@ int nr_rx_frame(struct sk_buff *skb, struct net_device *dev)
 	bh_unlock_sock(sk);
 	sock_put(sk);
 
-	nr_insert_socket(make);
-
 	nr_start_heartbeat(make);
 	nr_start_idletimer(make);
 
-- 
2.53.0



