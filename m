Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B102868B0;
	Thu, 15 Jan 2026 17:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499289; cv=none; b=TrqRIr74og0hQfmYQQ/o7tVsPc0EkTAMoGuWJd+QaqOFsDWSgVvCbTEot/hyXova4NZMMwbNop3KuJmGHX8wqFNB46UwCLBydsawltPcafbFQEb1qbFnLkx+z7rCJk6mX4AcAPbz5/G6SzJDAHCqRtn/864Ijkld7WH5RMcNo0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499289; c=relaxed/simple;
	bh=WzYTyOZ63cci53GBJLW71c43pZ4aHrDpAPPFBr4JGqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RZ7fdbgcB4wuMU986S6B+tGs/ZpPjBoBzSNw0EXbi0uJ8MWktpKnkcSmo5YuYFHz+J4L2l0Fxfntr9zMfo65n7vGN++aQL4m0NhSXNJSHpbdiuaqmVpltOuEit2BbJmMMx0ooCyswSlt6YhG4KIJmz7c4R7LvEJc/8E5ubJuYaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oQc9cZ9w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oQc9cZ9w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35766C19423;
	Thu, 15 Jan 2026 17:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499288;
	bh=WzYTyOZ63cci53GBJLW71c43pZ4aHrDpAPPFBr4JGqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oQc9cZ9wQH8wEIKqgTwGWIxQhpLCfnnTNCw2WJ3bdg9hSyio5m4VS82/3MALKuqTY
	 rVH3ZJaEQ5Sj3nrg2XzbKQwVKHfq1WzUgte0Rb7JxN/pOpo5uISgzLrVV/qW1LArU8
	 MEtzq6vRpe8c0DZOPar7wh236IIjjgFp0aArW2LA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 175/451] netfilter: nf_conncount: fix leaked ct in error paths
Date: Thu, 15 Jan 2026 17:46:16 +0100
Message-ID: <20260115164237.237030277@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 2e2a720766886190a6d35c116794693aabd332b6 ]

There are some situations where ct might be leaked as error paths are
skipping the refcounted check and return immediately. In order to solve
it make sure that the check is always called.

Fixes: be102eb6a0e7 ("netfilter: nf_conncount: rework API to use sk_buff directly")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conncount.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 97b631a81484d..c00b8e522c5a7 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -172,14 +172,14 @@ static int __nf_conncount_add(struct net *net,
 	struct nf_conn *found_ct;
 	unsigned int collect = 0;
 	bool refcounted = false;
+	int err = 0;
 
 	if (!get_ct_or_tuple_from_skb(net, skb, l3num, &ct, &tuple, &zone, &refcounted))
 		return -ENOENT;
 
 	if (ct && nf_ct_is_confirmed(ct)) {
-		if (refcounted)
-			nf_ct_put(ct);
-		return -EEXIST;
+		err = -EEXIST;
+		goto out_put;
 	}
 
 	if ((u32)jiffies == list->last_gc)
@@ -231,12 +231,16 @@ static int __nf_conncount_add(struct net *net,
 	}
 
 add_new_node:
-	if (WARN_ON_ONCE(list->count > INT_MAX))
-		return -EOVERFLOW;
+	if (WARN_ON_ONCE(list->count > INT_MAX)) {
+		err = -EOVERFLOW;
+		goto out_put;
+	}
 
 	conn = kmem_cache_alloc(conncount_conn_cachep, GFP_ATOMIC);
-	if (conn == NULL)
-		return -ENOMEM;
+	if (conn == NULL) {
+		err = -ENOMEM;
+		goto out_put;
+	}
 
 	conn->tuple = tuple;
 	conn->zone = *zone;
@@ -249,7 +253,7 @@ static int __nf_conncount_add(struct net *net,
 out_put:
 	if (refcounted)
 		nf_ct_put(ct);
-	return 0;
+	return err;
 }
 
 int nf_conncount_add_skb(struct net *net,
@@ -446,11 +450,10 @@ insert_tree(struct net *net,
 
 		rb_link_node_rcu(&rbconn->node, parent, rbnode);
 		rb_insert_color(&rbconn->node, root);
-
-		if (refcounted)
-			nf_ct_put(ct);
 	}
 out_unlock:
+	if (refcounted)
+		nf_ct_put(ct);
 	spin_unlock_bh(&nf_conncount_locks[hash]);
 	return count;
 }
-- 
2.51.0



