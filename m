Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB75933A9EB;
	Tue, 16 Jun 2026 16:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628302; cv=none; b=hjDiDJpu+EXeu8dau/8a6hGyvq8l/7+z5Vs5lWlFEWK9Nt2ohEHlctJT7twl1b1VZT2+vj+iqnS4AeEez4AHqQVu/C05QU5M4KDXViDNWTWcdCfp3SXgcVeE/lg/m9fJ95ZU/G0sjUQGJeI6VotvibAmX2ZR1KRAOgpFc2A20WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628302; c=relaxed/simple;
	bh=iW/GI3duvFR78LU2djya5qqAae/gzl1dFJhHqi1/l2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IBxFJ4FZzWiMeHQMh3/5qFVlHNG514UKsYuJqhLnm/VatPMMy32nzh3fkw2vBqJw5S6LjSDI4/qD+C3uL03U0wUpchOhQG4DHQQ5DYmDmhIs1gq2ikfg1MIlJ7/ojQ41NrnMLZIJx+oZD04E99DMmGun5STxynL70/Sx6CEpYuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k8auqMsm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k8auqMsm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC7801F000E9;
	Tue, 16 Jun 2026 16:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628300;
	bh=Bz+4eBy27iPGiSNhaQNxalsj29zF5VqgS29/csfdIWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k8auqMsm/89NZNx6DXGS2fdAn/FTxDVruhuRkKDI1mKbTVOfw73I0ILnEruSWlK5L
	 Nyng50bjUJP8Wc4VphdT95hbQB36XXZXKt1r9XMFEinFH54oUZ2Nm4ob7XnRNXP8DU
	 IfnTNPGT/Yl93KpAzaHKV81oLaIo0vQb470+I6vs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Rajani Kantha <681739313@139.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 068/452] inet: frags: flush pending skbs in fqdir_pre_exit()
Date: Tue, 16 Jun 2026 20:24:55 +0530
Message-ID: <20260616145121.505968271@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 006a5035b495dec008805df249f92c22c89c3d2e ]

We have been seeing occasional deadlocks on pernet_ops_rwsem since
September in NIPA. The stuck task was usually modprobe (often loading
a driver like ipvlan), trying to take the lock as a Writer.
lockdep does not track readers for rwsems so the read wasn't obvious
from the reports.

On closer inspection the Reader holding the lock was conntrack looping
forever in nf_conntrack_cleanup_net_list(). Based on past experience
with occasional NIPA crashes I looked thru the tests which run before
the crash and noticed that the crash follows ip_defrag.sh. An immediate
red flag. Scouring thru (de)fragmentation queues reveals skbs sitting
around, holding conntrack references.

The problem is that since conntrack depends on nf_defrag_ipv6,
nf_defrag_ipv6 will load first. Since nf_defrag_ipv6 loads first its
netns exit hooks run _after_ conntrack's netns exit hook.

Flush all fragment queue SKBs during fqdir_pre_exit() to release
conntrack references before conntrack cleanup runs. Also flush
the queues in timer expiry handlers when they discover fqdir->dead
is set, in case packet sneaks in while we're running the pre_exit
flush.

The commit under Fixes is not exactly the culprit, but I think
previously the timer firing would eventually unblock the spinning
conntrack.

Fixes: d5dd88794a13 ("inet: fix various use-after-free in defrags units")
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20251207010942.1672972-4-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Rajani Kantha <681739313@139.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/inet_frag.h  | 13 +------------
 include/net/ipv6_frag.h  |  9 ++++++---
 net/ipv4/inet_fragment.c | 36 ++++++++++++++++++++++++++++++++++++
 net/ipv4/ip_fragment.c   | 12 +++++++-----
 4 files changed, 50 insertions(+), 20 deletions(-)

diff --git a/include/net/inet_frag.h b/include/net/inet_frag.h
index 94edc0e130d2c4..fcabb34fff35de 100644
--- a/include/net/inet_frag.h
+++ b/include/net/inet_frag.h
@@ -123,18 +123,7 @@ void inet_frags_fini(struct inet_frags *);
 
 int fqdir_init(struct fqdir **fqdirp, struct inet_frags *f, struct net *net);
 
-static inline void fqdir_pre_exit(struct fqdir *fqdir)
-{
-	/* Prevent creation of new frags.
-	 * Pairs with READ_ONCE() in inet_frag_find().
-	 */
-	WRITE_ONCE(fqdir->high_thresh, 0);
-
-	/* Pairs with READ_ONCE() in inet_frag_kill(), ip_expire()
-	 * and ip6frag_expire_frag_queue().
-	 */
-	WRITE_ONCE(fqdir->dead, true);
-}
+void fqdir_pre_exit(struct fqdir *fqdir);
 void fqdir_exit(struct fqdir *fqdir);
 
 void inet_frag_kill(struct inet_frag_queue *q);
diff --git a/include/net/ipv6_frag.h b/include/net/ipv6_frag.h
index 7321ffe3a108c1..df61b98b521531 100644
--- a/include/net/ipv6_frag.h
+++ b/include/net/ipv6_frag.h
@@ -68,9 +68,6 @@ ip6frag_expire_frag_queue(struct net *net, struct frag_queue *fq)
 	struct sk_buff *head;
 
 	rcu_read_lock();
-	/* Paired with the WRITE_ONCE() in fqdir_pre_exit(). */
-	if (READ_ONCE(fq->q.fqdir->dead))
-		goto out_rcu_unlock;
 	spin_lock(&fq->q.lock);
 
 	if (fq->q.flags & INET_FRAG_COMPLETE)
@@ -79,6 +76,12 @@ ip6frag_expire_frag_queue(struct net *net, struct frag_queue *fq)
 	fq->q.flags |= INET_FRAG_DROP;
 	inet_frag_kill(&fq->q);
 
+	/* Paired with the WRITE_ONCE() in fqdir_pre_exit(). */
+	if (READ_ONCE(fq->q.fqdir->dead)) {
+		inet_frag_queue_flush(&fq->q, 0);
+		goto out;
+	}
+
 	dev = dev_get_by_index_rcu(net, fq->iif);
 	if (!dev)
 		goto out;
diff --git a/net/ipv4/inet_fragment.c b/net/ipv4/inet_fragment.c
index 1e390d24f11440..8cf88882d65e3e 100644
--- a/net/ipv4/inet_fragment.c
+++ b/net/ipv4/inet_fragment.c
@@ -219,6 +219,41 @@ static int __init inet_frag_wq_init(void)
 
 pure_initcall(inet_frag_wq_init);
 
+void fqdir_pre_exit(struct fqdir *fqdir)
+{
+	struct inet_frag_queue *fq;
+	struct rhashtable_iter hti;
+
+	/* Prevent creation of new frags.
+	 * Pairs with READ_ONCE() in inet_frag_find().
+	 */
+	WRITE_ONCE(fqdir->high_thresh, 0);
+
+	/* Pairs with READ_ONCE() in inet_frag_kill(), ip_expire()
+	 * and ip6frag_expire_frag_queue().
+	 */
+	WRITE_ONCE(fqdir->dead, true);
+
+	rhashtable_walk_enter(&fqdir->rhashtable, &hti);
+	rhashtable_walk_start(&hti);
+
+	while ((fq = rhashtable_walk_next(&hti))) {
+		if (IS_ERR(fq)) {
+			if (PTR_ERR(fq) != -EAGAIN)
+				break;
+			continue;
+		}
+		spin_lock_bh(&fq->lock);
+		if (!(fq->flags & INET_FRAG_COMPLETE))
+			inet_frag_queue_flush(fq, 0);
+		spin_unlock_bh(&fq->lock);
+	}
+
+	rhashtable_walk_stop(&hti);
+	rhashtable_walk_exit(&hti);
+}
+EXPORT_SYMBOL(fqdir_pre_exit);
+
 void fqdir_exit(struct fqdir *fqdir)
 {
 	INIT_WORK(&fqdir->destroy_work, fqdir_work_fn);
@@ -291,6 +326,7 @@ void inet_frag_queue_flush(struct inet_frag_queue *q,
 {
 	unsigned int sum;
 
+	reason = reason ?: SKB_DROP_REASON_FRAG_REASM_TIMEOUT;
 	sum = inet_frag_rbtree_purge(&q->rb_fragments, reason);
 	sub_frag_mem_limit(q->fqdir, sum);
 }
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index 7214d5bcc647e5..f5b5aa036cc668 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -148,11 +148,6 @@ static void ip_expire(struct timer_list *t)
 	net = qp->q.fqdir->net;
 
 	rcu_read_lock();
-
-	/* Paired with WRITE_ONCE() in fqdir_pre_exit(). */
-	if (READ_ONCE(qp->q.fqdir->dead))
-		goto out_rcu_unlock;
-
 	spin_lock(&qp->q.lock);
 
 	if (qp->q.flags & INET_FRAG_COMPLETE)
@@ -160,6 +155,13 @@ static void ip_expire(struct timer_list *t)
 
 	qp->q.flags |= INET_FRAG_DROP;
 	ipq_kill(qp);
+
+	/* Paired with WRITE_ONCE() in fqdir_pre_exit(). */
+	if (READ_ONCE(qp->q.fqdir->dead)) {
+		inet_frag_queue_flush(&qp->q, 0);
+		goto out;
+	}
+
 	__IP_INC_STATS(net, IPSTATS_MIB_REASMFAILS);
 	__IP_INC_STATS(net, IPSTATS_MIB_REASMTIMEOUT);
 
-- 
2.53.0



