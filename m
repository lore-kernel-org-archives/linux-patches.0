Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3447B3BF303;
	Thu, 15 Jan 2026 17:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497261; cv=none; b=YzGUCDgGy09gFHaTI1tislQ1qvcXdthcM84AHRB3E8mNE3nI9R5b3cfF7W29FNL3okyT0Cos0N6tyPP1NjXkTrDFdF4URlqIMwJCnXTn+P2hG3tqSUx8bKST5DAJsjIo7FpiMlTkPRsPkjQcWwgm+/f7K3gdbxiQHIm+fb/2Sgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497261; c=relaxed/simple;
	bh=dFEyZSFlmHyQPSe59wW+e196/cdz4XWqeAfXX8OBr5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NPcMafwQZ/b7vLBVy8LnEdCKmzRiD+vq4bSndUNqKVfKGmr8NZr7kgU/mCGkTS+yM3OB3V+4guX/i0ANy0h7eR0Dei9FjQF1v00/hnGOMHqZIBwjrXO9yLAibK2UGdnKtptlQIWD1D9jL+1Ct4puSYCUYLelL63a/5onXOGBaJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ESa0u/qq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ESa0u/qq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B539CC116D0;
	Thu, 15 Jan 2026 17:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497261;
	bh=dFEyZSFlmHyQPSe59wW+e196/cdz4XWqeAfXX8OBr5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ESa0u/qqgXkrVKjt02UaU3lIBposx/Hm2GZhk5GBOxlR0dbd1X7JuM2u85bCVRAfR
	 4+294toSKC7TpesHmTa6B2RADD0ORDBkucKU24ajCeLHUmCGljlQ0C8UgdwekURQZ0
	 PLH/WyPl1BLZLOCIHVe6xe6J4Y5Pe4WADwvCcUYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 002/554] Revert "xfrm: destroy xfrm_state synchronously on net exit path"
Date: Thu, 15 Jan 2026 17:41:08 +0100
Message-ID: <20260115164246.322710391@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 2a198bbec6913ae1c90ec963750003c6213668c7 ]

This reverts commit f75a2804da391571563c4b6b29e7797787332673.

With all states (whether user or kern) removed from the hashtables
during deletion, there's no need for synchronous destruction of
states. xfrm6_tunnel states still need to have been destroyed (which
will be the case when its last user is deleted (not destroyed)) so
that xfrm6_tunnel_free_spi removes it from the per-netns hashtable
before the netns is destroyed.

This has the benefit of skipping one synchronize_rcu per state (in
__xfrm_state_destroy(sync=true)) when we exit a netns.

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xfrm.h      | 12 +++---------
 net/ipv6/xfrm6_tunnel.c |  2 +-
 net/key/af_key.c        |  2 +-
 net/xfrm/xfrm_state.c   | 23 +++++++++--------------
 net/xfrm/xfrm_user.c    |  2 +-
 5 files changed, 15 insertions(+), 26 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 3e1690e0a38de..875f7dc4706ef 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -785,7 +785,7 @@ static inline void xfrm_pols_put(struct xfrm_policy **pols, int npols)
 		xfrm_pol_put(pols[i]);
 }
 
-void __xfrm_state_destroy(struct xfrm_state *, bool);
+void __xfrm_state_destroy(struct xfrm_state *);
 
 static inline void __xfrm_state_put(struct xfrm_state *x)
 {
@@ -795,13 +795,7 @@ static inline void __xfrm_state_put(struct xfrm_state *x)
 static inline void xfrm_state_put(struct xfrm_state *x)
 {
 	if (refcount_dec_and_test(&x->refcnt))
-		__xfrm_state_destroy(x, false);
-}
-
-static inline void xfrm_state_put_sync(struct xfrm_state *x)
-{
-	if (refcount_dec_and_test(&x->refcnt))
-		__xfrm_state_destroy(x, true);
+		__xfrm_state_destroy(x);
 }
 
 static inline void xfrm_state_hold(struct xfrm_state *x)
@@ -1577,7 +1571,7 @@ struct xfrmk_spdinfo {
 
 struct xfrm_state *xfrm_find_acq_byseq(struct net *net, u32 mark, u32 seq);
 int xfrm_state_delete(struct xfrm_state *x);
-int xfrm_state_flush(struct net *net, u8 proto, bool task_valid, bool sync);
+int xfrm_state_flush(struct net *net, u8 proto, bool task_valid);
 int xfrm_dev_state_flush(struct net *net, struct net_device *dev, bool task_valid);
 void xfrm_sad_getinfo(struct net *net, struct xfrmk_sadinfo *si);
 void xfrm_spd_getinfo(struct net *net, struct xfrmk_spdinfo *si);
diff --git a/net/ipv6/xfrm6_tunnel.c b/net/ipv6/xfrm6_tunnel.c
index 34f500a417fa6..3d811248f3129 100644
--- a/net/ipv6/xfrm6_tunnel.c
+++ b/net/ipv6/xfrm6_tunnel.c
@@ -330,7 +330,7 @@ static void __net_exit xfrm6_tunnel_net_exit(struct net *net)
 	struct xfrm6_tunnel_net *xfrm6_tn = xfrm6_tunnel_pernet(net);
 	unsigned int i;
 
-	xfrm_state_flush(net, 0, false, true);
+	xfrm_state_flush(net, IPSEC_PROTO_ANY, false);
 	xfrm_flush_gc();
 
 	for (i = 0; i < XFRM6_TUNNEL_SPI_BYADDR_HSIZE; i++)
diff --git a/net/key/af_key.c b/net/key/af_key.c
index 258fa046f440d..925fe4f89966b 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -1766,7 +1766,7 @@ static int pfkey_flush(struct sock *sk, struct sk_buff *skb, const struct sadb_m
 	if (proto == 0)
 		return -EINVAL;
 
-	err = xfrm_state_flush(net, proto, true, false);
+	err = xfrm_state_flush(net, proto, true);
 	err2 = unicast_flush_resp(sk, hdr);
 	if (err || err2) {
 		if (err == -ESRCH) /* empty table - go quietly */
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 6e410f30feba7..0e2e13c62e6b7 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -497,7 +497,7 @@ void xfrm_state_free(struct xfrm_state *x)
 }
 EXPORT_SYMBOL(xfrm_state_free);
 
-static void ___xfrm_state_destroy(struct xfrm_state *x)
+static void xfrm_state_gc_destroy(struct xfrm_state *x)
 {
 	hrtimer_cancel(&x->mtimer);
 	del_timer_sync(&x->rtimer);
@@ -535,7 +535,7 @@ static void xfrm_state_gc_task(struct work_struct *work)
 	synchronize_rcu();
 
 	hlist_for_each_entry_safe(x, tmp, &gc_list, gclist)
-		___xfrm_state_destroy(x);
+		xfrm_state_gc_destroy(x);
 }
 
 static enum hrtimer_restart xfrm_timer_handler(struct hrtimer *me)
@@ -659,19 +659,14 @@ struct xfrm_state *xfrm_state_alloc(struct net *net)
 }
 EXPORT_SYMBOL(xfrm_state_alloc);
 
-void __xfrm_state_destroy(struct xfrm_state *x, bool sync)
+void __xfrm_state_destroy(struct xfrm_state *x)
 {
 	WARN_ON(x->km.state != XFRM_STATE_DEAD);
 
-	if (sync) {
-		synchronize_rcu();
-		___xfrm_state_destroy(x);
-	} else {
-		spin_lock_bh(&xfrm_state_gc_lock);
-		hlist_add_head(&x->gclist, &xfrm_state_gc_list);
-		spin_unlock_bh(&xfrm_state_gc_lock);
-		schedule_work(&xfrm_state_gc_work);
-	}
+	spin_lock_bh(&xfrm_state_gc_lock);
+	hlist_add_head(&x->gclist, &xfrm_state_gc_list);
+	spin_unlock_bh(&xfrm_state_gc_lock);
+	schedule_work(&xfrm_state_gc_work);
 }
 EXPORT_SYMBOL(__xfrm_state_destroy);
 
@@ -782,7 +777,7 @@ xfrm_dev_state_flush_secctx_check(struct net *net, struct net_device *dev, bool
 }
 #endif
 
-int xfrm_state_flush(struct net *net, u8 proto, bool task_valid, bool sync)
+int xfrm_state_flush(struct net *net, u8 proto, bool task_valid)
 {
 	int i, err = 0, cnt = 0;
 
@@ -2745,7 +2740,7 @@ void xfrm_state_fini(struct net *net)
 	unsigned int sz;
 
 	flush_work(&net->xfrm.state_hash_work);
-	xfrm_state_flush(net, 0, false, true);
+	xfrm_state_flush(net, IPSEC_PROTO_ANY, false);
 	flush_work(&xfrm_state_gc_work);
 
 	WARN_ON(!list_empty(&net->xfrm.state_all));
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 1aa05b608ccf0..d9238e17ab427 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -2210,7 +2210,7 @@ static int xfrm_flush_sa(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct xfrm_usersa_flush *p = nlmsg_data(nlh);
 	int err;
 
-	err = xfrm_state_flush(net, p->proto, true, false);
+	err = xfrm_state_flush(net, p->proto, true);
 	if (err) {
 		if (err == -ESRCH) /* empty table */
 			return 0;
-- 
2.51.0



