Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB2426A090;
	Tue,  8 Apr 2025 12:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116062; cv=none; b=Qhi1579QTj6TmxLx2xRxr6DjlyM7EJ57taK10bEMDx0vG+QkybTcLsMyogNR+l6EhYhCwCiJcSx5iVGf4UlraPlR9sn6zhrF+z7ej1sg8LfA40Jl6jmJDX4hPsAzoVprJPWfr0JkZ3oDpYp4lfHj0RvZrs2u2CWuPaLII3JZ+Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116062; c=relaxed/simple;
	bh=1J5cOQBW1KZqHoeZDSZsBSAbrUC3A1JtCbdmvaHg6IY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EMdP2igQf3mI+p3Qb771EzKtszDArDDwDTOaaAAUzcjTUOWX24iN1+Uiqc2X/rk1PDxCr1vN6zafYbQIReefJSrK7IEr1ORn+ns/sVrpMGrdiP01NG8QwjgjKPZQwT/g+EHy2M3SO/QY/6YXJqoz92fC3ZS1b8l+7A/JhLM1S7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PBcmWw4V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PBcmWw4V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21E85C4CEE5;
	Tue,  8 Apr 2025 12:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116061;
	bh=1J5cOQBW1KZqHoeZDSZsBSAbrUC3A1JtCbdmvaHg6IY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PBcmWw4VefWNT6GkbDKj/NQ1vp6uVCn8YTZRnNtH85wSb0kP5fxTOfnNXzTn0qtkv
	 GRY44XukZG8iFYQ9nW4dYPg5unNuwnK1g72X6+IeuK1vRE8VXbctzhxiC/UPGJ8VAO
	 tetuH/7lF+vD9objgXTFgVsHseVvt7jb51GDqsZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Fomichev <stfomichev@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 166/204] ipv6: Start path selection from the first nexthop
Date: Tue,  8 Apr 2025 12:51:36 +0200
Message-ID: <20250408104825.191020161@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5cf6e824c0dff..2cfef1c971093 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -416,11 +416,35 @@ static bool rt6_check_expired(const struct rt6_info *rt)
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
@@ -444,10 +468,18 @@ void fib6_select_path(const struct net *net, struct fib6_result *res,
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



