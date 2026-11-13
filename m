Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590959;
	b=uGFS9zVGI0md+aFSZQwgppYnJ9wCUsLvo0/DNmVQGMOgM5vyEaMysis4sYwwI7aEweZQ
	 OqbjHteKgTRzFNBE/UInKxKrV47UvD6A5AjQ3M79pIpUXAypS40C2Y5Mk83OMjaAJUxhv
	 FfP6SPu6jRA9F4zmJ7Ga3X+7nMPn5iVkTmEmlOLt16zBjd7LD8yqwCl0BKu1HqaE7Tpm6
	 LzLvblAlel2AMUaDZtQ+snR9CTm5IZdE62ViCXVey9o34c9eRJzLaXAHa5gmqX54UJLMu
	 XRfM4awBlP/jx6SO/WJ/7r3Y3GLKxvTHgkSmrC+sYVMOf/GskqXywu1w1YH1TrVPXew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590959;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ttkzh6xf6x3TBhApU7HF3A3XbeYDfveQv5sIBsTa7mY=;
	b=JbpnX8uV9g223Qe6yf1aWuY6NNUvJNfk3fafOZjOhrXL1xXg4hF4R1m6OYFWy/dt0jSX
	 w0Re3/oGq5uqvgCiXUANGW/NdqptlwXotnN8LPr2OoHMYZK9xfrAeTUPK5fM4jMFpHEdz
	 XVqMlEQB6dCd2TzB3sa0pV+xwZHD6hnU3f5szpd2hrEskGtQhllpGcEywImJzpeukCq+V
	 ykkWCn8YFba+PCZdDQMQljmyGVeCAk0LlF8gvnU1NEWoaEs5wb6b77H6DSmi8J+gQFKeb
	 KfHEBFNT3MSLLPNcVK6T7Ud7vXqPWeLDRcXn01ifm2/g5K+u4CH16JC56uBaAfJOTtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QS2nf8x3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B756083165;
	Fri, 13 Nov 2026 17:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QS2nf8x3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B916C1F000C4;
	Fri, 13 Nov 2026 17:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590959;
	bh=ttkzh6xf6x3TBhApU7HF3A3XbeYDfveQv5sIBsTa7mY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QS2nf8x3zaOFCDJAlgsQwuhWmCE26xnWFJKchjcDsU4pm+RoBLoplv9Zat14tah1P
	 31Thwja6TAeIinWxQZAJFDB6UeppFZfNYO95aSkz3XBEDx5GiXsICG0aHb3yj6h6Ct
	 fEcUTFXDF/vLMnHTMTp0gn1Nym+OmMi4j5AJ41KA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 137/670] rose: hold the socket a received frame is delivered to
Date: Fri, 13 Nov 2026 10:45:01 -0500
Message-ID: <20261113153816.482677184@linuxfoundation.org>
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

rose_route_frame() and rose_loopback_timer() find the socket a frame
belongs to with rose_find_socket(), which returns it without a
reference once rose_list_lock is dropped, then hand the frame to
rose_rcv_frame(), which locks the socket and runs its state machine.
The socket can be destroyed in between: by rose_release() on another
CPU, or by its heartbeat, which reaps a dead socket in state 0 that
nobody owns, such as an incoming call left on the queue of a listener
that has been closed. Its LCI is not cleared then, so frames from the
neighbour still find it until it is reaped, and the reaping frees it
under the frame being delivered.

Take a reference in rose_find_socket() and drop it in its callers once
the frame has been handled. rose_new_lci() only needs to know whether
an LCI is in use: let it walk the socket list under rose_list_lock
itself instead of taking references.

A Call Request that arrives on the LCI of an existing socket tears the
old socket down. With the reference held, the socket may by then have
been disconnected or reaped, its neighbour reference dropped and
rose->neighbour cleared: lock the socket and only tear it down if it
still holds that LCI on that neighbour.

On a QEMU bench with two 4-CPU guests (KASAN, lockdep), A places eight
calls to B and sends a 100-byte message per second on each; B listens
without ever accepting, closes the listener after 10 s, and the calls
left on its queue are reaped 5 s later while A's messages keep coming.
With frames for sockets in state 0 held 2 s after rose_find_socket(),
before: KASAN reports a slab-use-after-free in rose_rcv_frame(), called
from rose_route_frame(), on the socket freed by the heartbeat timer;
after: no report in two runs, and no report without the delay either.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit 294cfbca864a2cf9d458fa1e8ee51f2cd8284b95)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rose/af_rose.c       | 42 ++++++++++++++++++++++++++++++----------
 net/rose/rose_loopback.c |  1 +
 net/rose/rose_route.c    | 37 +++++++++++++++++++++--------------
 3 files changed, 56 insertions(+), 24 deletions(-)

diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index f6f09590e86b5..93c43d42f1c20 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -312,20 +312,35 @@ static struct sock *rose_find_listener(rose_address *addr, ax25_address *call)
 
 /*
  *	Find a connected ROSE socket given my LCI and device.
+ *	The caller holds rose_list_lock.
  */
-struct sock *rose_find_socket(unsigned int lci, struct rose_neigh *neigh)
+static struct sock *__rose_find_socket(unsigned int lci, struct rose_neigh *neigh)
 {
 	struct sock *s;
 
-	spin_lock_bh(&rose_list_lock);
 	sk_for_each(s, &rose_list) {
 		struct rose_sock *rose = rose_sk(s);
 
 		if (rose->lci == lci && rose->neighbour == neigh)
-			goto found;
+			return s;
 	}
-	s = NULL;
-found:
+
+	return NULL;
+}
+
+/*
+ *	Find a connected ROSE socket given my LCI and device. A reference is
+ *	taken on the socket found: it can be released and destroyed as soon
+ *	as rose_list_lock is dropped.
+ */
+struct sock *rose_find_socket(unsigned int lci, struct rose_neigh *neigh)
+{
+	struct sock *s;
+
+	spin_lock_bh(&rose_list_lock);
+	s = __rose_find_socket(lci, neigh);
+	if (s)
+		sock_hold(s);
 	spin_unlock_bh(&rose_list_lock);
 	return s;
 }
@@ -336,19 +351,26 @@ struct sock *rose_find_socket(unsigned int lci, struct rose_neigh *neigh)
  */
 unsigned int rose_new_lci(struct rose_neigh *neigh)
 {
+	unsigned int res = 0;
 	int lci;
 
+	spin_lock_bh(&rose_list_lock);
 	if (neigh->dce_mode) {
 		for (lci = 1; lci <= sysctl_rose_maximum_vcs; lci++)
-			if (rose_find_socket(lci, neigh) == NULL && rose_route_free_lci(lci, neigh) == NULL)
-				return lci;
+			if (!__rose_find_socket(lci, neigh) && !rose_route_free_lci(lci, neigh)) {
+				res = lci;
+				break;
+			}
 	} else {
 		for (lci = sysctl_rose_maximum_vcs; lci > 0; lci--)
-			if (rose_find_socket(lci, neigh) == NULL && rose_route_free_lci(lci, neigh) == NULL)
-				return lci;
+			if (!__rose_find_socket(lci, neigh) && !rose_route_free_lci(lci, neigh)) {
+				res = lci;
+				break;
+			}
 	}
+	spin_unlock_bh(&rose_list_lock);
 
-	return 0;
+	return res;
 }
 
 /*
diff --git a/net/rose/rose_loopback.c b/net/rose/rose_loopback.c
index 4e4a473910cc8..6c5c35030e67b 100644
--- a/net/rose/rose_loopback.c
+++ b/net/rose/rose_loopback.c
@@ -109,6 +109,7 @@ static void rose_loopback_timer(struct timer_list *unused)
 		if (sk) {
 			if (rose_rcv_frame(sk, skb) == 0)
 				kfree_skb(skb);
+			sock_put(sk);
 			continue;
 		}
 
diff --git a/net/rose/rose_route.c b/net/rose/rose_route.c
index 87a33f5c65d8a..84d628a826b79 100644
--- a/net/rose/rose_route.c
+++ b/net/rose/rose_route.c
@@ -1054,25 +1054,34 @@ int rose_route_frame(struct sk_buff *skb, ax25_cb *ax25)
 		if (frametype == ROSE_CALL_REQUEST) {
 			struct rose_sock *rose = rose_sk(sk);
 
-			/* Remove an existing unused socket */
-			rose_clear_queues(sk);
-			rose->cause	 = ROSE_NETWORK_CONGESTION;
-			rose->diagnostic = 0;
-			rose_neigh_put(rose->neighbour);
-			rose->neighbour	 = NULL;
-			rose->lci	 = 0;
-			rose->state	 = ROSE_STATE_0;
-			sk->sk_state	 = TCP_CLOSE;
-			sk->sk_err	 = 0;
-			sk->sk_shutdown	 |= SEND_SHUTDOWN;
-			if (!sock_flag(sk, SOCK_DEAD)) {
-				sk->sk_state_change(sk);
-				sock_set_flag(sk, SOCK_DEAD);
+			/*
+			 * Remove an existing unused socket, unless it was
+			 * disconnected or reaped since it was found.
+			 */
+			bh_lock_sock(sk);
+			if (rose->lci == lci && rose->neighbour == rose_neigh) {
+				rose_clear_queues(sk);
+				rose->cause	 = ROSE_NETWORK_CONGESTION;
+				rose->diagnostic = 0;
+				rose_neigh_put(rose->neighbour);
+				rose->neighbour	 = NULL;
+				rose->lci	 = 0;
+				rose->state	 = ROSE_STATE_0;
+				sk->sk_state	 = TCP_CLOSE;
+				sk->sk_err	 = 0;
+				sk->sk_shutdown	 |= SEND_SHUTDOWN;
+				if (!sock_flag(sk, SOCK_DEAD)) {
+					sk->sk_state_change(sk);
+					sock_set_flag(sk, SOCK_DEAD);
+				}
 			}
+			bh_unlock_sock(sk);
+			sock_put(sk);
 		}
 		else {
 			skb_reset_transport_header(skb);
 			res = rose_rcv_frame(sk, skb);
+			sock_put(sk);
 			goto out;
 		}
 	}
-- 
2.53.0



