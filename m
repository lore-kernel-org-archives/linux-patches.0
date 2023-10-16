Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E4E1A5A7
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 09:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wpd7O5iX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BDBFC433C9;
	Mon, 16 Oct 2023 09:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697447035;
	bh=L9rtt5Fh1c15dr3cXWNSQJuTqPv4KJRxdRnKZlVAgvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wpd7O5iXUN4kVQ/XbpBihAwIma7XSF+2pq3UJFmcC985d2khCIuFNupoij8qf3M1W
	 74uE+FDlXJ9J4BSucNHbJ7D/3Bi+uxAikZdsc7/UJA0trwiwR72karoHmwTcV0KNSW
	 0t7AwT+TR3DnGcfra103SsHzoP2McvsgeStIs4Cg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sili Luo <rootlab@huawei.com>,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 112/131] mctp: perform route lookups under a RCU read-side lock
Date: Mon, 16 Oct 2023 10:41:35 +0200
Message-ID: <20231016084002.850409519@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084000.050926073@linuxfoundation.org>
References: <20231016084000.050926073@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeremy Kerr <jk@codeconstruct.com.au>

commit 5093bbfc10ab6636b32728e35813cbd79feb063c upstream.

Our current route lookups (mctp_route_lookup and mctp_route_lookup_null)
traverse the net's route list without the RCU read lock held. This means
the route lookup is subject to preemption, resulting in an potential
grace period expiry, and so an eventual kfree() while we still have the
route pointer.

Add the proper read-side critical section locks around the route
lookups, preventing premption and a possible parallel kfree.

The remaining net->mctp.routes accesses are already under a
rcu_read_lock, or protected by the RTNL for updates.

Based on an analysis from Sili Luo <rootlab@huawei.com>, where
introducing a delay in the route lookup could cause a UAF on
simultaneous sendmsg() and route deletion.

Reported-by: Sili Luo <rootlab@huawei.com>
Fixes: 889b7da23abf ("mctp: Add initial routing framework")
Cc: stable@vger.kernel.org
Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/29c4b0e67dc1bf3571df3982de87df90cae9b631.1696837310.git.jk@codeconstruct.com.au
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mctp/route.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -737,6 +737,8 @@ struct mctp_route *mctp_route_lookup(str
 {
 	struct mctp_route *tmp, *rt = NULL;
 
+	rcu_read_lock();
+
 	list_for_each_entry_rcu(tmp, &net->mctp.routes, list) {
 		/* TODO: add metrics */
 		if (mctp_rt_match_eid(tmp, dnet, daddr)) {
@@ -747,21 +749,29 @@ struct mctp_route *mctp_route_lookup(str
 		}
 	}
 
+	rcu_read_unlock();
+
 	return rt;
 }
 
 static struct mctp_route *mctp_route_lookup_null(struct net *net,
 						 struct net_device *dev)
 {
-	struct mctp_route *rt;
+	struct mctp_route *tmp, *rt = NULL;
+
+	rcu_read_lock();
 
-	list_for_each_entry_rcu(rt, &net->mctp.routes, list) {
-		if (rt->dev->dev == dev && rt->type == RTN_LOCAL &&
-		    refcount_inc_not_zero(&rt->refs))
-			return rt;
+	list_for_each_entry_rcu(tmp, &net->mctp.routes, list) {
+		if (tmp->dev->dev == dev && tmp->type == RTN_LOCAL &&
+		    refcount_inc_not_zero(&tmp->refs)) {
+			rt = tmp;
+			break;
+		}
 	}
 
-	return NULL;
+	rcu_read_unlock();
+
+	return rt;
 }
 
 static int mctp_do_fragment_route(struct mctp_route *rt, struct sk_buff *skb,


