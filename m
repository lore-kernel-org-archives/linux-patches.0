Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590082;
	b=jEqN6G1JVf37LZlr/MvuILVt/BQ7JR5AG2zTwKtNs7a5uxNh60LbQWPXOTWJRsPinDPn
	 Ejp9TLzPxu+1d2wAVa99ZqJ2LYpBPJuEYC46yClis/w4Mk7f631UaV7hh0GuX2b/NClru
	 xTlFdxakbSLrOxtydqHCUDwxjg7EzzmZ5NkpswwFKV0kjnz/el8KOCu9sW/nwg282eQ0S
	 mTdon2ZfHtYAO9p/QvglPyi6cjYnRGly6vYijNW6mkoPijbLr9pWhd5KXAHgdvrgGCFQ/
	 SmWMuJksimVNgMzQa9t/4MsnkiWH2F/weM/Icyh3EIpwOsaOGUbOEXVOIX2l85J6msQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590082;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r79z9dHe80XgRHbGMcH173zt2eu4MjKPwesxmqDDa8A=;
	b=VgJdxHh2iR0pOSMJvpaBBt33NWOFPBP4jyEFGmCu/JFkdRWGLQg2JmH45UcbSBUiWmeF
	 CvwiFWhNhBJ4od0KnKOfcND2QTd95nism6M0cghPFAThtRw+99YzIV6NZU2y4LlpejRZJ
	 8VZgWKMmnRluSAaJdyMNG8fbOGztGmjFJji0knKCgB1OBuHLk1edcyE3jvrcoYIU3XG8r
	 kiNrKeK97yX6peRuUKPBQ90Zay7zpBEVPPI97heZfy+5paHDgD9FXx+ohA1kyt1HV1d80
	 RQveJMac3gA4Qedx5au2wlhfF/yULcfRNGpsOQRgDh46oK18gGhUBFwL4WI+asx1Lpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o8wOR0Hu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E310D606C09E;
	Fri, 13 Nov 2026 17:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o8wOR0Hu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EDDF1F000C4;
	Fri, 13 Nov 2026 17:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590081;
	bh=r79z9dHe80XgRHbGMcH173zt2eu4MjKPwesxmqDDa8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o8wOR0Hu8In816KsiTlZhIAQcYKpDL9FYR4J5sWZocr+dXB97RY1cNSGPKUOmUiOC
	 O6LrMJ8iZ6VzyPMF5R5PpTDvL/o2WTSxyqvJHDAIk7rRsyHNO41ShlhphXv58KHB1Y
	 chs5wKz8AAxQtVoTzwKRw92AC9fRk1CXgak01HKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 110/686] rose: dont give the same LCI to two calls placed at the same time
Date: Fri, 13 Nov 2026 10:44:03 -0500
Message-ID: <20261113153824.576361755@linuxfoundation.org>
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

rose_connect() picks the logical channel of a new call with
rose_new_lci(), which looks for an LCI used neither by a socket nor by
a through route on the neighbour, and stores the result in rose->lci
afterwards.  Nothing serialises the search and the store, so two
sockets calling through the same neighbour on two CPUs can pick the
same LCI.  An unbound socket is worse: it is only put on the socket
list by the autobind after its LCI was chosen, so it stays invisible
to the search for longer.  Both calls go out on the same channel, the
neighbour accepts one of them, and the other connect() hangs until T1
expires while the neighbour holds a circuit nobody uses.

rose_new_lci() also walks rose_route_list through
rose_route_free_lci() without rose_route_list_lock when called from
rose_connect(), while rose_route_frame() may add or remove routes on
another CPU.

Do the autobind first, so the socket is on the list before it gets an
LCI, then choose and store the LCI under rose_route_list_lock, as
rose_route_frame() already does for a through route.  Assert the lock
in rose_route_free_lci().

On a QEMU bench with two 4-CPU guests, eight connect() calls started at
the same time through one neighbour, six rounds: before, 14 duplicate
LCIs and 14 of the 48 calls timed out; after, no duplicate and 48/48
calls connected.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit 4e9d49c39bf7161e1b14493076816c715f9ed557)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/rose.h    |  1 +
 net/rose/af_rose.c    | 32 ++++++++++++++++----------------
 net/rose/rose_route.c | 19 +++++++++++++++++++
 3 files changed, 36 insertions(+), 16 deletions(-)

diff --git a/include/net/rose.h b/include/net/rose.h
index 83d6b611eb735..7ee480e0a64e7 100644
--- a/include/net/rose.h
+++ b/include/net/rose.h
@@ -267,6 +267,7 @@ void rose_link_device_down(struct net_device *);
 struct net_device *rose_dev_first(void);
 struct net_device *rose_dev_get(rose_address *);
 struct rose_route *rose_route_free_lci(unsigned int, struct rose_neigh *);
+unsigned int rose_assign_lci(struct sock *sk);
 struct rose_neigh *rose_get_neigh(rose_address *, unsigned char *,
 				  unsigned char *, int);
 int rose_rt_ioctl(unsigned int, void __user *);
diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index 4912138bb2f69..614d033410fa3 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -330,6 +330,7 @@ struct sock *rose_find_socket(unsigned int lci, struct rose_neigh *neigh)
 
 /*
  *	Find a unique LCI for a given device.
+ *	The caller holds rose_route_list_lock.
  */
 unsigned int rose_new_lci(struct rose_neigh *neigh)
 {
@@ -854,20 +855,6 @@ static int rose_connect(struct socket *sock, struct sockaddr *uaddr, int addr_le
 	sk->sk_state   = TCP_CLOSE;
 	sock->state = SS_UNCONNECTED;
 
-	rose->neighbour = rose_get_neigh(&addr->srose_addr, &cause,
-					 &diagnostic, 0);
-	if (!rose->neighbour) {
-		err = -ENETUNREACH;
-		goto out_release;
-	}
-
-	rose->lci = rose_new_lci(rose->neighbour);
-	if (!rose->lci) {
-		err = -ENETUNREACH;
-		rose_neigh_put(rose->neighbour);
-		goto out_release;
-	}
-
 	if (sock_flag(sk, SOCK_ZAPPED)) {	/* Must bind first - autobinding in this may or may not work */
 		struct net_device *dev;
 
@@ -876,14 +863,12 @@ static int rose_connect(struct socket *sock, struct sockaddr *uaddr, int addr_le
 		dev = rose_dev_first();
 		if (!dev) {
 			err = -ENETUNREACH;
-			rose_neigh_put(rose->neighbour);
 			goto out_release;
 		}
 
 		user = ax25_findbyuid(current_euid());
 		if (!user) {
 			err = -EINVAL;
-			rose_neigh_put(rose->neighbour);
 			dev_put(dev);
 			goto out_release;
 		}
@@ -897,6 +882,21 @@ static int rose_connect(struct socket *sock, struct sockaddr *uaddr, int addr_le
 
 		rose_insert_socket(sk);		/* Finish the bind */
 	}
+
+	rose->neighbour = rose_get_neigh(&addr->srose_addr, &cause,
+					 &diagnostic, 0);
+	if (!rose->neighbour) {
+		err = -ENETUNREACH;
+		goto out_release;
+	}
+
+	/* The socket is on the list now, so others see the LCI it gets */
+	if (!rose_assign_lci(sk)) {
+		err = -ENETUNREACH;
+		rose_neigh_put(rose->neighbour);
+		goto out_release;
+	}
+
 	rose->dest_addr   = addr->srose_addr;
 	rose->dest_call   = addr->srose_call;
 	rose->rand        = ((long)rose & 0xFFFF) + rose->lci;
diff --git a/net/rose/rose_route.c b/net/rose/rose_route.c
index 3499f034b83c6..87a33f5c65d8a 100644
--- a/net/rose/rose_route.c
+++ b/net/rose/rose_route.c
@@ -724,6 +724,8 @@ struct rose_route *rose_route_free_lci(unsigned int lci, struct rose_neigh *neig
 {
 	struct rose_route *rose_route;
 
+	lockdep_assert_held(&rose_route_list_lock);
+
 	for (rose_route = rose_route_list; rose_route != NULL; rose_route = rose_route->next)
 		if ((rose_route->neigh1 == neigh && rose_route->lci1 == lci) ||
 		    (rose_route->neigh2 == neigh && rose_route->lci2 == lci))
@@ -732,6 +734,23 @@ struct rose_route *rose_route_free_lci(unsigned int lci, struct rose_neigh *neig
 	return NULL;
 }
 
+/*
+ *	Give a socket placing a call a free LCI on its neighbour. As for a
+ *	through route in rose_route_frame(), the search and the assignment
+ *	are done under rose_route_list_lock, so two calls cannot pick the
+ *	same LCI. The socket must already be on the socket list.
+ */
+unsigned int rose_assign_lci(struct sock *sk)
+{
+	struct rose_sock *rose = rose_sk(sk);
+
+	spin_lock_bh(&rose_route_list_lock);
+	rose->lci = rose_new_lci(rose->neighbour);
+	spin_unlock_bh(&rose_route_list_lock);
+
+	return rose->lci;
+}
+
 /*
  *	Find a neighbour or a route given a ROSE address.
  */
-- 
2.53.0



