Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590918;
	b=c3Gr1+V1w5wvTWgiaLW9SaDRy4Loi14uC0OyA+rSBgR+mRKnJerT0hHXxTM5D19ZFAZe
	 iafPfqpEvOpRQFHpee/mKuPS0rkaqVgzHjk9q/+0vG7Jb8d5ftXiYN+UT174Ms7JkZ88+
	 6exGK4nxFBthvcYtrX+wkIZB4b82kMzKPlO6aMKJ0obL+7zSl1J99qX5qTghMHaFUV9of
	 qNcaIWDUpxM4VioW2u3SS51v9E+PWZBzl+NIRjyL2zY/qR2e6eYhuJcd8SAdBEtp/qgyd
	 4Gj8nDEV2QPcdjSnnoZQs6nM/WUVZDGv/gV6g3JTGOWyqHwmzVy6eNqN3J3s3WJUtLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590918;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dqpQZvNflH/EPsb9rfk57tynD/kjPOWCTl9FKyjV2ZM=;
	b=YwXavvbVKvEUaJkZ/ivpvNSFG4Sxcu2Q79UpxYf6ttGQoY9pgdR4qNp0L5CJKlWDMDP0
	 5hXQQ3cHIhvg7Czv6JML/y57ece3eEI6yf6sVu4v7Pm+JGMf7X1eqBdSKMl9ffwZzPM80
	 45J9UqQKG/feuEnJ2esd7q/FMcodsE4hXGb+oyzM6Aa/zXnOnPcXejKuyN3mPwZv/vsff
	 +cH7YposeJLPjbQxXNLrPw8bxNg474SqiErslB+rsSmaAJdm7pmfHjXHCM7lahxzGep7L
	 4SjcQ7jwTFziaps38DJv2FpXrOumd+Rim40vQNdQw/P1YWvl0vo65tbq1lfC/UD6Nww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="dJLI+/qh";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC46606A327;
	Fri, 13 Nov 2026 17:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dJLI+/qh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B3641F000C4;
	Fri, 13 Nov 2026 17:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590918;
	bh=dqpQZvNflH/EPsb9rfk57tynD/kjPOWCTl9FKyjV2ZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dJLI+/qh8kPJUNLDfQo/xgybi8EPmw9BloiIks7TN8ZMpfmM2y53bli5d44OV+bk+
	 SMx6ssozgd+BQdJ6I1LhlBHkkj8h85dFzIVm+0PgjnTh3t59/n+3ShzsV5nhqBPq8t
	 r7meSQsHqTlGOjhViVXbVXYTxLcTWYdAqw9kUTkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 107/670] rose: dont give the same LCI to two calls placed at the same time
Date: Fri, 13 Nov 2026 10:44:31 -0500
Message-ID: <20261113153815.492608820@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d8a86006c7448..4be2dd8200b5a 100644
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



