Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8102F745E;
	Tue, 16 Jun 2026 16:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628291; cv=none; b=ecnfnDu++ZGcGg5ICrEGjP/vSHnlIrKySRBitCI6Vv4Z4LnmHQsw5M4yWU4BMUKJwEO4bKE6qmMOeSzN/0qbQEqDBtdZAo/3s2VoxvtsSBMrQg/x38YcMPaJbSvq3PpXdLVXkd0BdqZ1MSdYanbr5aPJw973+xp9a7/fJrc4DYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628291; c=relaxed/simple;
	bh=9Ms2/AOQJ21mnM0u/bZZF8bfcZ53zEh3oIvL++CZub4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RHGtuhlhVR//2zipiS7B+oU1a4mCpfla6bIR1AmImspNKwh+41WKjEgNYDKQ2hFWb/IgpA5EZxmKzBcvnXTDFFF0Yge+9/ujaHy8mlAPUX4ewLDqDBTwUqHWHVmymWYA9oj5zaSrC/8vFy36b/CNKpvpy/Zy8pNLIHWA/+7T6yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e4RbV1PF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e4RbV1PF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE3D1F000E9;
	Tue, 16 Jun 2026 16:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628290;
	bh=+GlUeeZcUnoLpYbYe2e6z4ODrLyfz7Xwlj+Ytn+q0EU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e4RbV1PFOMapKy5WelCdp0u79WcuHykLDgxOW7uoXtUSjG+X4Coaw9AB4Rlidbsak
	 EcE/nCozNifJyxS2a5B8ElwfG/4tRAmN0/VdgGrKFaiIbxIBTPPt5LSdezGg3D9IlV
	 ams/ev+WqQE3SngRGIrjQ405uceVEcsrYMgmsnao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Rajani Kantha <681739313@139.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 067/452] inet: frags: add inet_frag_queue_flush()
Date: Tue, 16 Jun 2026 20:24:54 +0530
Message-ID: <20260616145121.458781338@linuxfoundation.org>
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

[ Upstream commit 1231eec6994be29d6bb5c303dfa54731ed9fc0e6 ]

Instead of exporting inet_frag_rbtree_purge() which requires that
caller takes care of memory accounting, add a new helper. We will
need to call it from a few places in the next patch.

Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20251207010942.1672972-3-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Rajani Kantha <681739313@139.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/inet_frag.h  |  5 ++---
 net/ipv4/inet_fragment.c | 15 ++++++++++++---
 net/ipv4/ip_fragment.c   |  6 +-----
 3 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/include/net/inet_frag.h b/include/net/inet_frag.h
index 5af6eb14c5db15..94edc0e130d2c4 100644
--- a/include/net/inet_frag.h
+++ b/include/net/inet_frag.h
@@ -141,9 +141,8 @@ void inet_frag_kill(struct inet_frag_queue *q);
 void inet_frag_destroy(struct inet_frag_queue *q);
 struct inet_frag_queue *inet_frag_find(struct fqdir *fqdir, void *key);
 
-/* Free all skbs in the queue; return the sum of their truesizes. */
-unsigned int inet_frag_rbtree_purge(struct rb_root *root,
-				    enum skb_drop_reason reason);
+void inet_frag_queue_flush(struct inet_frag_queue *q,
+			   enum skb_drop_reason reason);
 
 static inline void inet_frag_put(struct inet_frag_queue *q)
 {
diff --git a/net/ipv4/inet_fragment.c b/net/ipv4/inet_fragment.c
index 496308c0238485..1e390d24f11440 100644
--- a/net/ipv4/inet_fragment.c
+++ b/net/ipv4/inet_fragment.c
@@ -264,8 +264,8 @@ static void inet_frag_destroy_rcu(struct rcu_head *head)
 	kmem_cache_free(f->frags_cachep, q);
 }
 
-unsigned int inet_frag_rbtree_purge(struct rb_root *root,
-				    enum skb_drop_reason reason)
+static unsigned int
+inet_frag_rbtree_purge(struct rb_root *root, enum skb_drop_reason reason)
 {
 	struct rb_node *p = rb_first(root);
 	unsigned int sum = 0;
@@ -285,7 +285,16 @@ unsigned int inet_frag_rbtree_purge(struct rb_root *root,
 	}
 	return sum;
 }
-EXPORT_SYMBOL(inet_frag_rbtree_purge);
+
+void inet_frag_queue_flush(struct inet_frag_queue *q,
+			   enum skb_drop_reason reason)
+{
+	unsigned int sum;
+
+	sum = inet_frag_rbtree_purge(&q->rb_fragments, reason);
+	sub_frag_mem_limit(q->fqdir, sum);
+}
+EXPORT_SYMBOL(inet_frag_queue_flush);
 
 void inet_frag_destroy(struct inet_frag_queue *q)
 {
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index 484edc8513e4b7..7214d5bcc647e5 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -253,16 +253,12 @@ static int ip_frag_too_far(struct ipq *qp)
 
 static int ip_frag_reinit(struct ipq *qp)
 {
-	unsigned int sum_truesize = 0;
-
 	if (!mod_timer(&qp->q.timer, jiffies + qp->q.fqdir->timeout)) {
 		refcount_inc(&qp->q.refcnt);
 		return -ETIMEDOUT;
 	}
 
-	sum_truesize = inet_frag_rbtree_purge(&qp->q.rb_fragments,
-					      SKB_DROP_REASON_FRAG_TOO_FAR);
-	sub_frag_mem_limit(qp->q.fqdir, sum_truesize);
+	inet_frag_queue_flush(&qp->q, SKB_DROP_REASON_FRAG_TOO_FAR);
 
 	qp->q.flags = 0;
 	qp->q.len = 0;
-- 
2.53.0



