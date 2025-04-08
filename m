Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A58DE27C163;
	Tue,  8 Apr 2025 12:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116989; cv=none; b=r3rDqPinBuZ1CBTF0eH4pfpgKWt8Zk5oc+B/SLAPU0gIfcpEX5vopk312dIqe+LVqX/3Vt0/lGi34VyPEGozPqPtb+dlDrI4VM+V7+Y7XbIMuklp20QWUiRN/+u4P6sRkqEa2iTWrrF+p/AAo/aeOki836vMteoXmW1+GDJzunA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116989; c=relaxed/simple;
	bh=d1u7E6BDk0v7gKFv2r+IahjM5ePFekXoupHNaFfzCYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mke5YlqLoNA8K2YNNl7dKVPvBmYi5aaBqgBjLrxUPG9otaLgHfnrVDgKZNGa18axj2JIa2S3mYqVPCKmYJvQ9DERVUzDNsQFizi6ZKUDL/3WKE2tnq12B2HAeN9AofwtCSFbQkfRobNrJNQhXYurAwxP0PHm40lYdS912hU+aHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rkyCF8Vn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rkyCF8Vn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8866FC4CEE5;
	Tue,  8 Apr 2025 12:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116988;
	bh=d1u7E6BDk0v7gKFv2r+IahjM5ePFekXoupHNaFfzCYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rkyCF8Vnb3d+zGkLHvgEL30Kkzx7ieJeCypZ8Q2Ik7KKARR1tkWG9NEPiHeVPljC2
	 KfHQJF+i/O/yWGZChFIG7UsGSS6TDrcWgOhflCc8zYqnEzWNk5agAKXa2EhbFlrP/h
	 5FP/NEbsOF+5RQpMFfh7p6WhonrTqcqvlsoiw+Yc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Fomichev <stfomichev@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 341/423] ipv6: Start path selection from the first nexthop
Date: Tue,  8 Apr 2025 12:51:07 +0200
Message-ID: <20250408104853.780426762@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 4d0ab3a6885e3e9040310a8d8f54503366083626 ]

Cited commit transitioned IPv6 path selection to use hash-threshold
instead of modulo-N. With hash-threshold, each nexthop is assigned a
region boundary in the multipath hash function's output space and a
nexthop is chosen if the calculated hash is smaller than the nexthop's
region boundary.

Hash-threshold does not work correctly if path selection does not start
with the first nexthop. For example, if fib6_select_path() is always
passed the last nexthop in the group, then it will always be chosen
because its region boundary covers the entire hash function's output
space.

Fix this by starting the selection process from the first nexthop and do
not consider nexthops for which rt6_score_route() provided a negative
score.

Fixes: 3d709f69a3e7 ("ipv6: Use hash-threshold instead of modulo-N")
Reported-by: Stanislav Fomichev <stfomichev@gmail.com>
Closes: https://lore.kernel.org/netdev/Z9RIyKZDNoka53EO@mini-arch/
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20250402114224.293392-2-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c | 38 +++++++++++++++++++++++++++++++++++---
 1 file changed, 35 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index b393c37d24245..54ce948835a09 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -412,11 +412,35 @@ static bool rt6_check_expired(const struct rt6_info *rt)
 	return false;
 }
 
+static struct fib6_info *
+rt6_multipath_first_sibling_rcu(const struct fib6_info *rt)
+{
+	struct fib6_info *iter;
+	struct fib6_node *fn;
+
+	fn = rcu_dereference(rt->fib6_node);
+	if (!fn)
+		goto out;
+	iter = rcu_dereference(fn->leaf);
+	if (!iter)
+		goto out;
+
+	while (iter) {
+		if (iter->fib6_metric == rt->fib6_metric &&
+		    rt6_qualify_for_ecmp(iter))
+			return iter;
+		iter = rcu_dereference(iter->fib6_next);
+	}
+
+out:
+	return NULL;
+}
+
 void fib6_select_path(const struct net *net, struct fib6_result *res,
 		      struct flowi6 *fl6, int oif, bool have_oif_match,
 		      const struct sk_buff *skb, int strict)
 {
-	struct fib6_info *match = res->f6i;
+	struct fib6_info *first, *match = res->f6i;
 	struct fib6_info *sibling;
 
 	if (!match->nh && (!match->fib6_nsiblings || have_oif_match))
@@ -440,10 +464,18 @@ void fib6_select_path(const struct net *net, struct fib6_result *res,
 		return;
 	}
 
-	if (fl6->mp_hash <= atomic_read(&match->fib6_nh->fib_nh_upper_bound))
+	first = rt6_multipath_first_sibling_rcu(match);
+	if (!first)
 		goto out;
 
-	list_for_each_entry_rcu(sibling, &match->fib6_siblings,
+	if (fl6->mp_hash <= atomic_read(&first->fib6_nh->fib_nh_upper_bound) &&
+	    rt6_score_route(first->fib6_nh, first->fib6_flags, oif,
+			    strict) >= 0) {
+		match = first;
+		goto out;
+	}
+
+	list_for_each_entry_rcu(sibling, &first->fib6_siblings,
 				fib6_siblings) {
 		const struct fib6_nh *nh = sibling->fib6_nh;
 		int nh_upper_bound;
-- 
2.39.5



