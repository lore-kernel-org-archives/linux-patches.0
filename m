Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590177;
	b=h6hmU2ZK86tDgK5vYjTqQWK5EslHvQQvCSSgqzXCdtSAkdo/PSAC3BlSEL8dBrW74u39
	 8JVYlf9KsWVKv36LohjxJFUWRBBf3KqpvknHfF68ChB48LorGYOtvK4bmSkcJytt46sOB
	 W3OBg2+k7mjekt4CXNA8yZvMjGOt15/w8glcXrEaRm9Taq+FpxknxMJTseBtlrBa78cQd
	 iNdnuvdE6c0rvBSwdaVvwp9fqUSFoYQtg2acOjYQYmZHNXflyePqFi6WoI1bBTjeXFL1N
	 +AcKhONWp3jmznFS+iK0fHutstagoybRP0xKdBowP2L17W75Vc0jq0KggYV4+Uq87ww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590177;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MhQf6iHzPNpus/ynwNk7N498lqTkTz+LA8kl5jK3XM0=;
	b=PtVVm5VmdvYpU9nC1DiP/iTnTNKpNY54fhlSD+yoiwKMuu+GNYY9ipiDT2yJ7w/og9xl
	 f7rpvg793gYu5jNM7DG/ZmNHrIGENxCgCSnK5ARhtLNmVV6R5KWJ6ginL5DF1geShM7+e
	 MjrdxM7vOcCnk2YOJYvq7P+6nDyhhsG9X0sMRXJJh5Kp6aP+zDZ9fuIgVkfvjlau2aRTz
	 ARFEIIlETxVuI4pGaTlyx6Dy57K4Uwx6greJYSNzlNQtI3EKPaOPDCLQmICvImXnYkJPU
	 +W+2z1+qxgmeNcStLCZvl7eE2AUV+KL3zzIU2Xj5qFBoFE6ZCSRtkkZi7ZkLrXUfcNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zZUfE8dQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D1E0607141C;
	Fri, 13 Nov 2026 17:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zZUfE8dQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A88A1F000C8;
	Fri, 13 Nov 2026 17:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590177;
	bh=MhQf6iHzPNpus/ynwNk7N498lqTkTz+LA8kl5jK3XM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zZUfE8dQQJasmlrZYCZ7i6/OpNNBjU/lZoTsTiJZ+osyImKyMARkoKwesXLcJDRHl
	 RCOPUv5MoNrYnjtnShNgPVzP/yqgzWwU7kCfFhKrLFsMzFuQfDiqndumaIRVW3XrvP
	 AXm/WF30JcIAfFqOzFXmNImt5biIttXZoi1qOQ5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 143/686] rose: swap the AX.25 connection of a neighbour under a lock
Date: Fri, 13 Nov 2026 10:44:36 -0500
Message-ID: <20261113153825.646110626@linuxfoundation.org>
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

Each holder of neigh->ax25 owns a reference on the ax25_cb.
rose_send_frame() and rose_link_up() replace it by reading the old
pointer, storing the new connection and dropping the reference on the
old one. They run from process context (sendmsg, connect, release),
from softirq (frames routed or answered on receipt) and from the
neighbour timers, under no common lock, and rose_link_failed() clears
the pointer under rose_neigh_list_lock alone. When two of them run at
the same time for one neighbour, both drop the reference on the same
old ax25_cb, which is freed while still in use, and the reference taken
by one of them on the new connection is lost.

Do the swap under a spinlock of its own and drop the reference taken
off after it, so that it is dropped once; rose_link_failed() only
clears the pointer if it still holds the failed connection.

On a QEMU bench with two 4-CPU guests (KASAN, lockdep), four threads on
A placing calls to B and sending a message every 20 ms, each echoed by
a thread on B: with 50 ms between the read and the update of
neigh->ax25, before: KASAN reports a slab-use-after-free in
rose_send_frame(), from rose_sendmsg() on B, and refcount_t reports an
underflow on the ax25_cb; after: no report. Without the delay, no
report either way and the same traffic, 1220 messages.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit 2d8b7bf0ceb1ceffa4b19906b70b8b412292e531)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/rose.h    |  1 +
 net/rose/rose_link.c  | 61 ++++++++++++++++++++++++++++++++++---------
 net/rose/rose_route.c |  5 ++--
 3 files changed, 52 insertions(+), 15 deletions(-)

diff --git a/include/net/rose.h b/include/net/rose.h
index 7ee480e0a64e7..30b0809dd0a65 100644
--- a/include/net/rose.h
+++ b/include/net/rose.h
@@ -232,6 +232,7 @@ int rose_backlog_rcv(struct sock *sk, struct sk_buff *skb);
 
 /* rose_link.c */
 void rose_neigh_init_timers(struct rose_neigh *neigh);
+bool rose_neigh_clear_ax25(struct rose_neigh *neigh, ax25_cb *ax25);
 void rose_start_ftimer(struct rose_neigh *);
 void rose_stop_ftimer(struct rose_neigh *);
 void rose_stop_t0timer(struct rose_neigh *);
diff --git a/net/rose/rose_link.c b/net/rose/rose_link.c
index 49a45936eb2bd..912d26f1fe359 100644
--- a/net/rose/rose_link.c
+++ b/net/rose/rose_link.c
@@ -27,6 +27,47 @@
 static void rose_ftimer_expiry(struct timer_list *);
 static void rose_t0timer_expiry(struct timer_list *);
 
+/*
+ * neigh->ax25 is replaced when a frame is sent or the link is looked up,
+ * from process context, softirq and the neighbour timers, and cleared by
+ * rose_link_failed(). Each holder of the pointer owns a reference on the
+ * ax25_cb: swap the pointer under this lock, then drop the reference that
+ * was taken off, so that it is dropped once and none is lost.
+ */
+static DEFINE_SPINLOCK(rose_neigh_ax25_lock);
+
+static void rose_neigh_set_ax25(struct rose_neigh *neigh, ax25_cb *ax25)
+{
+	ax25_cb *old;
+
+	spin_lock_bh(&rose_neigh_ax25_lock);
+	old = neigh->ax25;
+	neigh->ax25 = ax25;
+	spin_unlock_bh(&rose_neigh_ax25_lock);
+
+	if (old)
+		ax25_cb_put(old);
+}
+
+/*
+ * Clear neigh->ax25 if it still is @ax25, and drop its reference.
+ */
+bool rose_neigh_clear_ax25(struct rose_neigh *neigh, ax25_cb *ax25)
+{
+	bool found;
+
+	spin_lock_bh(&rose_neigh_ax25_lock);
+	found = neigh->ax25 == ax25;
+	if (found)
+		neigh->ax25 = NULL;
+	spin_unlock_bh(&rose_neigh_ax25_lock);
+
+	if (found)
+		ax25_cb_put(ax25);
+
+	return found;
+}
+
 static void rose_transmit_restart_confirmation(struct rose_neigh *neigh);
 static void rose_transmit_restart_request(struct rose_neigh *neigh);
 
@@ -91,19 +132,17 @@ static void rose_t0timer_expiry(struct timer_list *t)
 static int rose_send_frame(struct sk_buff *skb, struct rose_neigh *neigh)
 {
 	const ax25_address *rose_call;
-	ax25_cb *ax25s;
+	ax25_cb *ax25;
 
 	if (ax25cmp(&rose_callsign, &null_ax25_address) == 0)
 		rose_call = (const ax25_address *)neigh->dev->dev_addr;
 	else
 		rose_call = &rose_callsign;
 
-	ax25s = neigh->ax25;
-	neigh->ax25 = ax25_send_frame(skb, 260, rose_call, &neigh->callsign, neigh->digipeat, neigh->dev);
-	if (ax25s)
-		ax25_cb_put(ax25s);
+	ax25 = ax25_send_frame(skb, 260, rose_call, &neigh->callsign, neigh->digipeat, neigh->dev);
+	rose_neigh_set_ax25(neigh, ax25);
 
-	return neigh->ax25 != NULL;
+	return !!ax25;
 }
 
 /*
@@ -114,19 +153,17 @@ static int rose_send_frame(struct sk_buff *skb, struct rose_neigh *neigh)
 static int rose_link_up(struct rose_neigh *neigh)
 {
 	const ax25_address *rose_call;
-	ax25_cb *ax25s;
+	ax25_cb *ax25;
 
 	if (ax25cmp(&rose_callsign, &null_ax25_address) == 0)
 		rose_call = (const ax25_address *)neigh->dev->dev_addr;
 	else
 		rose_call = &rose_callsign;
 
-	ax25s = neigh->ax25;
-	neigh->ax25 = ax25_find_cb(rose_call, &neigh->callsign, neigh->digipeat, neigh->dev);
-	if (ax25s)
-		ax25_cb_put(ax25s);
+	ax25 = ax25_find_cb(rose_call, &neigh->callsign, neigh->digipeat, neigh->dev);
+	rose_neigh_set_ax25(neigh, ax25);
 
-	return neigh->ax25 != NULL;
+	return !!ax25;
 }
 
 /*
diff --git a/net/rose/rose_route.c b/net/rose/rose_route.c
index 84d628a826b79..00fbe47fffe04 100644
--- a/net/rose/rose_route.c
+++ b/net/rose/rose_route.c
@@ -936,14 +936,13 @@ void rose_link_failed(ax25_cb *ax25, int reason)
 	spin_lock_bh(&rose_neigh_list_lock);
 	rose_neigh = rose_neigh_list;
 	while (rose_neigh != NULL) {
-		if (rose_neigh->ax25 == ax25)
+		if (READ_ONCE(rose_neigh->ax25) == ax25)
 			break;
 		rose_neigh = rose_neigh->next;
 	}
 
 	if (rose_neigh != NULL) {
-		rose_neigh->ax25 = NULL;
-		ax25_cb_put(ax25);
+		rose_neigh_clear_ax25(rose_neigh, ax25);
 
 		rose_del_route_by_neigh(rose_neigh);
 		rose_kill_by_neigh(rose_neigh);
-- 
2.53.0



