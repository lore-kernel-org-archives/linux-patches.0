Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 946F2199EA4;
	Thu,  5 Sep 2024 09:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529811; cv=none; b=L4DssUc1DWMzoFE4NgYK9uzX5k8hSQJxLktDx6w0o6xgMfPUx6/ElBFK6umfiRG1nAgC+4rwaW70ECM0qzbFNH27AVthEmYtZDlLvZfg4PeVm1Ebn3Xj/ar5b9oHSKGGONp8YmlJkgK7esjDEuJkQ5VzFSVEfXru2N2Zj0y2RhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529811; c=relaxed/simple;
	bh=r+dnPBFwH0g0DwoV/34GjCT/uXk9fPTlA2tr+/kWcvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FLB90bWU7QwEgugAG/471iDkMyo8LYX09R5TKACUoEwKIdelRin30FZBjazWWR8+nKObitBbAi+lP5wMNyRF81pYllX9I4S7pUYmwcU2DD1eRVb0QrIRkuDYZJA1CUEm2qdjZ9iTQWFanGbGWSVRNY2l0g2qT20+fRuXb5fG/h0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2FaNHm8l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2FaNHm8l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8DCAC4CEC3;
	Thu,  5 Sep 2024 09:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529811;
	bh=r+dnPBFwH0g0DwoV/34GjCT/uXk9fPTlA2tr+/kWcvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2FaNHm8lyl6AtNVge9+Ik512ocWkRxtuYqMiozoJqSDTF7+swEkHqlUG7sBJsPHDs
	 UucK+oX290mv0O0XNa07LImLGJ1m+H08RPZnUle+fqK75FWKmmjI4GHea6kReMjZiD
	 MulIkSZb+QTmQU2xhjPr4unAT+5xCJ9HlQETYeVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Florian Westphal <fw@strlen.de>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 149/184] net: tcp/dccp: prepare for tw_timer un-pinning
Date: Thu,  5 Sep 2024 11:41:02 +0200
Message-ID: <20240905093738.154812168@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Valentin Schneider <vschneid@redhat.com>

[ Upstream commit b334b924c9b709bc969644fb5c406f5c9d01dceb ]

The TCP timewait timer is proving to be problematic for setups where
scheduler CPU isolation is achieved at runtime via cpusets (as opposed to
statically via isolcpus=domains).

What happens there is a CPU goes through tcp_time_wait(), arming the
time_wait timer, then gets isolated. TCP_TIMEWAIT_LEN later, the timer
fires, causing interference for the now-isolated CPU. This is conceptually
similar to the issue described in commit e02b93124855 ("workqueue: Unbind
kworkers before sending them to exit()")

Move inet_twsk_schedule() to within inet_twsk_hashdance(), with the ehash
lock held. Expand the lock's critical section from inet_twsk_kill() to
inet_twsk_deschedule_put(), serializing the scheduling vs descheduling of
the timer. IOW, this prevents the following race:

			     tcp_time_wait()
			       inet_twsk_hashdance()
  inet_twsk_deschedule_put()
    del_timer_sync()
			       inet_twsk_schedule()

Thanks to Paolo Abeni for suggesting to leverage the ehash lock.

This also restores a comment from commit ec94c2696f0b ("tcp/dccp: avoid
one atomic operation for timewait hashdance") as inet_twsk_hashdance() had
a "Step 1" and "Step 3" comment, but the "Step 2" had gone missing.

inet_twsk_deschedule_put() now acquires the ehash spinlock to synchronize
with inet_twsk_hashdance_schedule().

To ease possible regression search, actual un-pin is done in next patch.

Link: https://lore.kernel.org/all/ZPhpfMjSiHVjQkTk@localhost.localdomain/
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Valentin Schneider <vschneid@redhat.com>
Co-developed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/inet_timewait_sock.h |  6 ++--
 net/dccp/minisocks.c             |  3 +-
 net/ipv4/inet_timewait_sock.c    | 52 +++++++++++++++++++++++++++-----
 net/ipv4/tcp_ipv4.c              |  2 +-
 net/ipv4/tcp_minisocks.c         |  3 +-
 5 files changed, 52 insertions(+), 14 deletions(-)

diff --git a/include/net/inet_timewait_sock.h b/include/net/inet_timewait_sock.h
index 2a536eea9424..5b43d220243d 100644
--- a/include/net/inet_timewait_sock.h
+++ b/include/net/inet_timewait_sock.h
@@ -93,8 +93,10 @@ struct inet_timewait_sock *inet_twsk_alloc(const struct sock *sk,
 					   struct inet_timewait_death_row *dr,
 					   const int state);
 
-void inet_twsk_hashdance(struct inet_timewait_sock *tw, struct sock *sk,
-			 struct inet_hashinfo *hashinfo);
+void inet_twsk_hashdance_schedule(struct inet_timewait_sock *tw,
+				  struct sock *sk,
+				  struct inet_hashinfo *hashinfo,
+				  int timeo);
 
 void __inet_twsk_schedule(struct inet_timewait_sock *tw, int timeo,
 			  bool rearm);
diff --git a/net/dccp/minisocks.c b/net/dccp/minisocks.c
index 251a57cf5822..deb52d7d31b4 100644
--- a/net/dccp/minisocks.c
+++ b/net/dccp/minisocks.c
@@ -59,11 +59,10 @@ void dccp_time_wait(struct sock *sk, int state, int timeo)
 		 * we complete the initialization.
 		 */
 		local_bh_disable();
-		inet_twsk_schedule(tw, timeo);
 		/* Linkage updates.
 		 * Note that access to tw after this point is illegal.
 		 */
-		inet_twsk_hashdance(tw, sk, &dccp_hashinfo);
+		inet_twsk_hashdance_schedule(tw, sk, &dccp_hashinfo, timeo);
 		local_bh_enable();
 	} else {
 		/* Sorry, if we're out of memory, just CLOSE this
diff --git a/net/ipv4/inet_timewait_sock.c b/net/ipv4/inet_timewait_sock.c
index e28075f0006e..628d33a41ce5 100644
--- a/net/ipv4/inet_timewait_sock.c
+++ b/net/ipv4/inet_timewait_sock.c
@@ -96,9 +96,13 @@ static void inet_twsk_add_node_rcu(struct inet_timewait_sock *tw,
  * Enter the time wait state. This is called with locally disabled BH.
  * Essentially we whip up a timewait bucket, copy the relevant info into it
  * from the SK, and mess with hash chains and list linkage.
+ *
+ * The caller must not access @tw anymore after this function returns.
  */
-void inet_twsk_hashdance(struct inet_timewait_sock *tw, struct sock *sk,
-			   struct inet_hashinfo *hashinfo)
+void inet_twsk_hashdance_schedule(struct inet_timewait_sock *tw,
+				  struct sock *sk,
+				  struct inet_hashinfo *hashinfo,
+				  int timeo)
 {
 	const struct inet_sock *inet = inet_sk(sk);
 	const struct inet_connection_sock *icsk = inet_csk(sk);
@@ -129,26 +133,33 @@ void inet_twsk_hashdance(struct inet_timewait_sock *tw, struct sock *sk,
 
 	spin_lock(lock);
 
+	/* Step 2: Hash TW into tcp ehash chain */
 	inet_twsk_add_node_rcu(tw, &ehead->chain);
 
 	/* Step 3: Remove SK from hash chain */
 	if (__sk_nulls_del_node_init_rcu(sk))
 		sock_prot_inuse_add(sock_net(sk), sk->sk_prot, -1);
 
-	spin_unlock(lock);
 
+	/* Ensure above writes are committed into memory before updating the
+	 * refcount.
+	 * Provides ordering vs later refcount_inc().
+	 */
+	smp_wmb();
 	/* tw_refcnt is set to 3 because we have :
 	 * - one reference for bhash chain.
 	 * - one reference for ehash chain.
 	 * - one reference for timer.
-	 * We can use atomic_set() because prior spin_lock()/spin_unlock()
-	 * committed into memory all tw fields.
 	 * Also note that after this point, we lost our implicit reference
 	 * so we are not allowed to use tw anymore.
 	 */
 	refcount_set(&tw->tw_refcnt, 3);
+
+	inet_twsk_schedule(tw, timeo);
+
+	spin_unlock(lock);
 }
-EXPORT_SYMBOL_GPL(inet_twsk_hashdance);
+EXPORT_SYMBOL_GPL(inet_twsk_hashdance_schedule);
 
 static void tw_timer_handler(struct timer_list *t)
 {
@@ -217,7 +228,34 @@ EXPORT_SYMBOL_GPL(inet_twsk_alloc);
  */
 void inet_twsk_deschedule_put(struct inet_timewait_sock *tw)
 {
-	if (del_timer_sync(&tw->tw_timer))
+	struct inet_hashinfo *hashinfo = tw->tw_dr->hashinfo;
+	spinlock_t *lock = inet_ehash_lockp(hashinfo, tw->tw_hash);
+
+	/* inet_twsk_purge() walks over all sockets, including tw ones,
+	 * and removes them via inet_twsk_deschedule_put() after a
+	 * refcount_inc_not_zero().
+	 *
+	 * inet_twsk_hashdance_schedule() must (re)init the refcount before
+	 * arming the timer, i.e. inet_twsk_purge can obtain a reference to
+	 * a twsk that did not yet schedule the timer.
+	 *
+	 * The ehash lock synchronizes these two:
+	 * After acquiring the lock, the timer is always scheduled (else
+	 * timer_shutdown returns false), because hashdance_schedule releases
+	 * the ehash lock only after completing the timer initialization.
+	 *
+	 * Without grabbing the ehash lock, we get:
+	 * 1) cpu x sets twsk refcount to 3
+	 * 2) cpu y bumps refcount to 4
+	 * 3) cpu y calls inet_twsk_deschedule_put() and shuts timer down
+	 * 4) cpu x tries to start timer, but mod_timer is a noop post-shutdown
+	 * -> timer refcount is never decremented.
+	 */
+	spin_lock(lock);
+	/*  Makes sure hashdance_schedule() has completed */
+	spin_unlock(lock);
+
+	if (timer_shutdown_sync(&tw->tw_timer))
 		inet_twsk_kill(tw);
 	inet_twsk_put(tw);
 }
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 3b7430201397..da0f50255399 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -159,7 +159,7 @@ int tcp_twsk_unique(struct sock *sk, struct sock *sktw, void *twp)
 	if (ts_recent_stamp &&
 	    (!twp || (reuse && time_after32(ktime_get_seconds(),
 					    ts_recent_stamp)))) {
-		/* inet_twsk_hashdance() sets sk_refcnt after putting twsk
+		/* inet_twsk_hashdance_schedule() sets sk_refcnt after putting twsk
 		 * and releasing the bucket lock.
 		 */
 		if (unlikely(!refcount_inc_not_zero(&sktw->sk_refcnt)))
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 5e4a12d01622..d5da3ec8f846 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -350,11 +350,10 @@ void tcp_time_wait(struct sock *sk, int state, int timeo)
 		 * we complete the initialization.
 		 */
 		local_bh_disable();
-		inet_twsk_schedule(tw, timeo);
 		/* Linkage updates.
 		 * Note that access to tw after this point is illegal.
 		 */
-		inet_twsk_hashdance(tw, sk, net->ipv4.tcp_death_row.hashinfo);
+		inet_twsk_hashdance_schedule(tw, sk, net->ipv4.tcp_death_row.hashinfo, timeo);
 		local_bh_enable();
 	} else {
 		/* Sorry, if we're out of memory, just CLOSE this
-- 
2.43.0



