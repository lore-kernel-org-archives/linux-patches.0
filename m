Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11530348896;
	Tue, 16 Dec 2025 11:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885155; cv=none; b=pkOScYo+O6XJWMkQSXyG+LmkuKNtAtFXriCV6a3BXk2LNq/uSCmwR1owJ52EKRp3VMKa0ZFx/wIy/jfX8A0POAfiI6Si1KNiccwYGS47wG/KS0OOBE36hy0bINbXfbyU11kWqR3cFemFpJ2SxT3qV/Glvt8zJfvTxy9mPDN8em0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885155; c=relaxed/simple;
	bh=TmLa9oT5NHImxV/Ns7DpkZtDGfRn7QC5G0jJNq5rfEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QeVEplx1iiCASLQ+W6uvG3uhWsTcvHnFmXHdSQ5sM3Dk3QOWxokWJTXUJdHpgnTVqv2yvv9QBmf5adjkAXc6GYJSIr7yFOr8w02exs7tC4u8xxOZGKrqppiEN9SlXy8i7B6kj7BU8Xva2ZjTPCqnhApY9J+1VfLpKetGkRccnk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UT8dJfde; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UT8dJfde"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 118E8C4CEF1;
	Tue, 16 Dec 2025 11:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885154;
	bh=TmLa9oT5NHImxV/Ns7DpkZtDGfRn7QC5G0jJNq5rfEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UT8dJfdeYuf2abnf6AoXkrI7nj1Ec0ZVrjx2UStkmJAckCXqcBS5IAvgHpfrT6YyS
	 U5GVcChCnD7uIsobO7qUztojGdQ+V5kmIJI5K45zQoX5MtI3dBOHcvAOX+7S+vmgt+
	 bHSzyiwMCfkDgenkPQW+/DFCIzr1yer6nNDkSbtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 054/507] inet: Avoid ehash lookup race in inet_twsk_hashdance_schedule()
Date: Tue, 16 Dec 2025 12:08:15 +0100
Message-ID: <20251216111347.500908579@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>

[ Upstream commit b8ec80b130211e7bf076ef72365952979d5f7a72 ]

Since ehash lookups are lockless, if another CPU is converting sk to tw
concurrently, fetching the newly inserted tw with tw->tw_refcnt == 0 cause
lookup failure.

The call trace map is drawn as follows:
   CPU 0                                CPU 1
   -----                                -----
				     inet_twsk_hashdance_schedule()
				     spin_lock()
				     inet_twsk_add_node_rcu(tw, ...)
__inet_lookup_established()
(find tw, failure due to tw_refcnt = 0)
				     __sk_nulls_del_node_init_rcu(sk)
				     refcount_set(&tw->tw_refcnt, 3)
				     spin_unlock()

By replacing sk with tw atomically via hlist_nulls_replace_init_rcu() after
setting tw_refcnt, we ensure that tw is either fully initialized or not
visible to other CPUs, eliminating the race.

It's worth noting that we held lock_sock() before the replacement, so
there's no need to check if sk is hashed. Thanks to Kuniyuki Iwashima!

Fixes: 3ab5aee7fe84 ("net: Convert TCP & DCCP hash tables to use RCU / hlist_nulls")
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20251015020236.431822-4-xuanqiang.luo@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/inet_timewait_sock.c | 35 ++++++++++++-----------------------
 1 file changed, 12 insertions(+), 23 deletions(-)

diff --git a/net/ipv4/inet_timewait_sock.c b/net/ipv4/inet_timewait_sock.c
index 6fb9efdbee27a..2386552f4eee3 100644
--- a/net/ipv4/inet_timewait_sock.c
+++ b/net/ipv4/inet_timewait_sock.c
@@ -86,12 +86,6 @@ void inet_twsk_put(struct inet_timewait_sock *tw)
 }
 EXPORT_SYMBOL_GPL(inet_twsk_put);
 
-static void inet_twsk_add_node_rcu(struct inet_timewait_sock *tw,
-				   struct hlist_nulls_head *list)
-{
-	hlist_nulls_add_head_rcu(&tw->tw_node, list);
-}
-
 static void inet_twsk_schedule(struct inet_timewait_sock *tw, int timeo)
 {
 	__inet_twsk_schedule(tw, timeo, false);
@@ -111,13 +105,12 @@ void inet_twsk_hashdance_schedule(struct inet_timewait_sock *tw,
 {
 	const struct inet_sock *inet = inet_sk(sk);
 	const struct inet_connection_sock *icsk = inet_csk(sk);
-	struct inet_ehash_bucket *ehead = inet_ehash_bucket(hashinfo, sk->sk_hash);
 	spinlock_t *lock = inet_ehash_lockp(hashinfo, sk->sk_hash);
 	struct inet_bind_hashbucket *bhead, *bhead2;
 
-	/* Step 1: Put TW into bind hash. Original socket stays there too.
-	   Note, that any socket with inet->num != 0 MUST be bound in
-	   binding cache, even if it is closed.
+	/* Put TW into bind hash. Original socket stays there too.
+	 * Note, that any socket with inet->num != 0 MUST be bound in
+	 * binding cache, even if it is closed.
 	 */
 	bhead = &hashinfo->bhash[inet_bhashfn(twsk_net(tw), inet->inet_num,
 			hashinfo->bhash_size)];
@@ -139,19 +132,6 @@ void inet_twsk_hashdance_schedule(struct inet_timewait_sock *tw,
 
 	spin_lock(lock);
 
-	/* Step 2: Hash TW into tcp ehash chain */
-	inet_twsk_add_node_rcu(tw, &ehead->chain);
-
-	/* Step 3: Remove SK from hash chain */
-	if (__sk_nulls_del_node_init_rcu(sk))
-		sock_prot_inuse_add(sock_net(sk), sk->sk_prot, -1);
-
-
-	/* Ensure above writes are committed into memory before updating the
-	 * refcount.
-	 * Provides ordering vs later refcount_inc().
-	 */
-	smp_wmb();
 	/* tw_refcnt is set to 3 because we have :
 	 * - one reference for bhash chain.
 	 * - one reference for ehash chain.
@@ -161,6 +141,15 @@ void inet_twsk_hashdance_schedule(struct inet_timewait_sock *tw,
 	 */
 	refcount_set(&tw->tw_refcnt, 3);
 
+	/* Ensure tw_refcnt has been set before tw is published.
+	 * smp_wmb() provides the necessary memory barrier to enforce this
+	 * ordering.
+	 */
+	smp_wmb();
+
+	hlist_nulls_replace_init_rcu(&sk->sk_nulls_node, &tw->tw_node);
+	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, -1);
+
 	inet_twsk_schedule(tw, timeo);
 
 	spin_unlock(lock);
-- 
2.51.0



