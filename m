Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80EE443BDCF;
	Mon, 17 Aug 2026 14:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978435; cv=none; b=W/g6rDMTEe7XmApURPf21BmmcsWIJaRxFaG/lbsT0wpOQB2f01X3cg4+kRLh9CLwTet+oOGu5roaJXK2UA+suGEosLeDSsJqCFS+1FV3xaYriqQfn9wm3BYxNHjI4t3C3gN+6zJii9tVmVdFFO+cw3BMGBnsyyBSwm98+yc+ju4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978435; c=relaxed/simple;
	bh=J51YR/BY2qhIDDTYu4o19WkEtGeFMsvkHBZEyTJfQTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ju7H2INepI+gtuMbcXGkX0vEV50IyUgYtenfTkuhhczI7YbMHP4IjzlhGjIk2RyC5AunGzf7eWcNq039t2aiw0goNWFlvufsf2l1nWcV03zdZzf0g4MJbdqh6dxdb6lcntsjBZRWuBlCbROfgmLFwFHMYP3qyVg40opwCvqLXh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WWPhJRR7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WWPhJRR7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B88D51F000E9;
	Mon, 17 Aug 2026 14:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978433;
	bh=9ypIODaBgmYx02bWpQgh1SYOjVz+a6aD+IqqSH3WROY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WWPhJRR7k3stFDAZOIS7X9x5yrRcxhMwpemRgSU1ce2SsV7bo2nbKUiRqBRfDDh8V
	 L9zlcNfJhwyPNBelb8Fm5mOGYUTUzBJDJavakbe3xKg3YliEMjv6nr+ZaP9WI4/6yR
	 Gq7cNqWv7fDjRK5PrEchffvcDAPhtN3f2IM6HuYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.net>,
	Simon Horman <horms@kernel.org>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 034/156] net: sched: cls_api: add filter counter
Date: Mon, 17 Aug 2026 15:32:48 +0200
Message-ID: <20260817132535.956309000@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Asbjørn Sloth Tønnesen <ast@fiberby.net>

[ Upstream commit 2081fd3445fec6b9813c20e8b910c2abd6de31cb ]

Maintain a count of filters per block.

Counter updates are protected by cb_lock, which is
also used to protect the offload counters.

Signed-off-by: Asbjørn Sloth Tønnesen <ast@fiberby.net>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: a347304b2ca1 ("net/sched: cls_api: Always acquire rtnl_lock when destroying locked classifiers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sch_generic.h |  2 ++
 net/sched/cls_api.c       | 19 +++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 5df841ed0aeaa..a94ff63e3cd5b 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -429,6 +429,7 @@ struct tcf_proto {
 	 */
 	spinlock_t		lock;
 	bool			deleting;
+	bool			counted;
 	refcount_t		refcnt;
 	struct rcu_head		rcu;
 	struct hlist_node	destroy_ht_node;
@@ -477,6 +478,7 @@ struct tcf_block {
 	struct flow_block flow_block;
 	struct list_head owner_list;
 	bool keep_dst;
+	atomic_t filtercnt; /* Number of filters */
 	atomic_t skipswcnt; /* Number of skip_sw filters */
 	atomic_t offloadcnt; /* Number of oddloaded filters */
 	unsigned int nooffloaddevcnt; /* Number of devs unable to do offload */
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 792e7040ebc1f..d25ac60259715 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -410,12 +410,30 @@ static void tcf_proto_get(struct tcf_proto *tp)
 	refcount_inc(&tp->refcnt);
 }
 
+static void tcf_block_filter_cnt_update(struct tcf_block *block, bool *counted, bool add)
+{
+	lockdep_assert_not_held(&block->cb_lock);
+
+	down_write(&block->cb_lock);
+	if (*counted != add) {
+		if (add) {
+			atomic_inc(&block->filtercnt);
+			*counted = true;
+		} else {
+			atomic_dec(&block->filtercnt);
+			*counted = false;
+		}
+	}
+	up_write(&block->cb_lock);
+}
+
 static void tcf_chain_put(struct tcf_chain *chain);
 
 static void tcf_proto_destroy(struct tcf_proto *tp, bool rtnl_held,
 			      bool sig_destroy, struct netlink_ext_ack *extack)
 {
 	tp->ops->destroy(tp, rtnl_held, extack);
+	tcf_block_filter_cnt_update(tp->chain->block, &tp->counted, false);
 	if (sig_destroy)
 		tcf_proto_signal_destroyed(tp->chain, tp);
 	tcf_chain_put(tp->chain);
@@ -2354,6 +2372,7 @@ static int tc_new_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 	err = tp->ops->change(net, skb, tp, cl, t->tcm_handle, tca, &fh,
 			      flags, extack);
 	if (err == 0) {
+		tcf_block_filter_cnt_update(block, &tp->counted, true);
 		tfilter_notify(net, skb, n, tp, block, q, parent, fh,
 			       RTM_NEWTFILTER, false, rtnl_held, extack);
 		tfilter_put(tp, fh);
-- 
2.53.0



