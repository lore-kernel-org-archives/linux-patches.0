Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA49223DFF;
	Tue, 12 Aug 2025 19:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026028; cv=none; b=bO5VEKPARcJx/+FbkQIGTGxF4FLSLBV/5Ko0D6uJaG1o9Pez3zUV3Ox4evTQGyi0tFQXhQGNDHuiPoPnIIZ0y6YwAabbFCrW4ZAYrwp+csx5VH/kM/kShreQrswX+9oOENZbJQs44glT/nwARjICVhStY1hQwfHSU8/h2FUQSMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026028; c=relaxed/simple;
	bh=CkDJiMtnq3EsF1Bi+VzGbUeRD4z5l36V6GeV+mBM4H8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O550026thX8swcBjPvS2thXLT0f0FkiQojH69dSzaqapMvnVlTp02/3jsW2eS9jnbB22gtYn0wyht01Rm4XAlwa+IYunjgCFDJIH8j315mmRVsWpSd6lrTgxZUExYvUEMZPi8uXZ0MHvZY4d94N4dP4O9qrmfykFm8gdKY27yWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KRDnZcFH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KRDnZcFH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C611C4CEF0;
	Tue, 12 Aug 2025 19:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026028;
	bh=CkDJiMtnq3EsF1Bi+VzGbUeRD4z5l36V6GeV+mBM4H8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KRDnZcFHrnwZl/nXolw8BN6qpt84kbBOC08SeZoM3MoXv273Oe9JLaZ1pus3E110u
	 BxLpzG0ZQzxZY4fPTv7YKo1b4DCBSwp5oc1O5TmcgYPs2FkxBXJk0ZfGFYqPgscrUo
	 H1hi/iSVkf01twy4VhFFMUjybcOouDq3tvxNP+BU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 214/480] ipv6: prevent infinite loop in rt6_nlmsg_size()
Date: Tue, 12 Aug 2025 19:47:02 +0200
Message-ID: <20250812174406.287150347@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 54e6fe9dd3b0e7c481c2228782c9494d653546da ]

While testing prior patch, I was able to trigger
an infinite loop in rt6_nlmsg_size() in the following place:

list_for_each_entry_rcu(sibling, &f6i->fib6_siblings,
			fib6_siblings) {
	rt6_nh_nlmsg_size(sibling->fib6_nh, &nexthop_len);
}

This is because fib6_del_route() and fib6_add_rt2node()
uses list_del_rcu(), which can confuse rcu readers,
because they might no longer see the head of the list.

Restart the loop if f6i->fib6_nsiblings is zero.

Fixes: d9ccb18f83ea ("ipv6: Fix soft lockups in fib6_select_path under high next hop churn")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250725140725.3626540-3-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_fib.c |  4 ++--
 net/ipv6/route.c   | 34 ++++++++++++++++++----------------
 2 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index bf727149fdec..d7cf38f91c5b 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -1244,7 +1244,7 @@ static int fib6_add_rt2node(struct fib6_node *fn, struct fib6_info *rt,
 							 &rt->fib6_siblings,
 							 fib6_siblings)
 					sibling->fib6_nsiblings--;
-				rt->fib6_nsiblings = 0;
+				WRITE_ONCE(rt->fib6_nsiblings, 0);
 				list_del_rcu(&rt->fib6_siblings);
 				rt6_multipath_rebalance(next_sibling);
 				return err;
@@ -1962,7 +1962,7 @@ static void fib6_del_route(struct fib6_table *table, struct fib6_node *fn,
 		list_for_each_entry_safe(sibling, next_sibling,
 					 &rt->fib6_siblings, fib6_siblings)
 			sibling->fib6_nsiblings--;
-		rt->fib6_nsiblings = 0;
+		WRITE_ONCE(rt->fib6_nsiblings, 0);
 		list_del_rcu(&rt->fib6_siblings);
 		rt6_multipath_rebalance(next_sibling);
 	}
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 96f1621e2381..ebb4abd5e69e 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5596,32 +5596,34 @@ static int rt6_nh_nlmsg_size(struct fib6_nh *nh, void *arg)
 
 static size_t rt6_nlmsg_size(struct fib6_info *f6i)
 {
+	struct fib6_info *sibling;
+	struct fib6_nh *nh;
 	int nexthop_len;
 
 	if (f6i->nh) {
 		nexthop_len = nla_total_size(4); /* RTA_NH_ID */
 		nexthop_for_each_fib6_nh(f6i->nh, rt6_nh_nlmsg_size,
 					 &nexthop_len);
-	} else {
-		struct fib6_nh *nh = f6i->fib6_nh;
-		struct fib6_info *sibling;
-
-		nexthop_len = 0;
-		if (f6i->fib6_nsiblings) {
-			rt6_nh_nlmsg_size(nh, &nexthop_len);
-
-			rcu_read_lock();
+		goto common;
+	}
 
-			list_for_each_entry_rcu(sibling, &f6i->fib6_siblings,
-						fib6_siblings) {
-				rt6_nh_nlmsg_size(sibling->fib6_nh, &nexthop_len);
-			}
+	rcu_read_lock();
+retry:
+	nh = f6i->fib6_nh;
+	nexthop_len = 0;
+	if (READ_ONCE(f6i->fib6_nsiblings)) {
+		rt6_nh_nlmsg_size(nh, &nexthop_len);
 
-			rcu_read_unlock();
+		list_for_each_entry_rcu(sibling, &f6i->fib6_siblings,
+					fib6_siblings) {
+			rt6_nh_nlmsg_size(sibling->fib6_nh, &nexthop_len);
+			if (!READ_ONCE(f6i->fib6_nsiblings))
+				goto retry;
 		}
-		nexthop_len += lwtunnel_get_encap_size(nh->fib_nh_lws);
 	}
-
+	rcu_read_unlock();
+	nexthop_len += lwtunnel_get_encap_size(nh->fib_nh_lws);
+common:
 	return NLMSG_ALIGN(sizeof(struct rtmsg))
 	       + nla_total_size(16) /* RTA_SRC */
 	       + nla_total_size(16) /* RTA_DST */
-- 
2.39.5



