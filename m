Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49BFC4F0526;
	Wed, 30 Sep 2026 16:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785834; cv=none; b=EZ8LncI1QzpFjLn5hWUwfBZ9spVMdYIlkyYAxEOX9afYOheQ2dfHhcL1p9LzpRO7thiVFNzRH3KVLfwaBeGTezcCQieO2TeEB8U+Cks2ufcNobdJ7VXyEHAy3HjbMaABraX37roRfiZx0cQ2b+Q9jGCMvAxpYnyS4brAFXfp68M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785834; c=relaxed/simple;
	bh=9T0qrot7CxX2sZBzG+yOO0Ob9bSO4w8kFAIMmrJHOUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ee0qP0CDh7jPaBnkF6FCHtuh5sA9+mPQBcQ5nLMUVnipJcZQiQ7VkIOI7gPkThybXWTnEpkRo9j5tdUv1DQ1KVyWFuAh2LTzxUqJ1sK0eCd+7gx5pPHLRePlxdl+8cG9kq17dutOjVJuOUpDFOv1uRhdhrIUJIRa8aW/oAQQAEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CxT19kFp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CxT19kFp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0A281F00893;
	Wed, 30 Sep 2026 16:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785833;
	bh=/0S25gDjiUst+VNaeO3KI9R1vRK2i/cXtUAZYw6QYfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CxT19kFpmtJfRb6oK9/E0/+gVyNa09em5DDOags1iTkz98IR/2vVgZNPNuGhThYvp
	 WnCSLS4Q81pMczh9ej2QpJVVTqmcwJypMfH7jov0LWpsEEVBfywfBWu2MzEVs2k1u1
	 m5uvSfLgtmDVcgQI3x5lqteuh8B5yCtBGaen4DO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 649/982] netfilter: flowtable: hold reference on ct until flow is released
Date: Wed, 30 Sep 2026 17:23:05 +0200
Message-ID: <20260930152430.707355778@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit e75a9fa1d44bcbd66ea02e8781bcca6ea4076e0d ]

nf_ct_put() releases the ct->ext area inmediately, the rcu typesafe
semantics also allow to refer to the wrong conntrack from the flowtable
datapath. Hold reference on ct until flow is released after rcu grace
period.

Add rcu_barrier() on module exit path, to ensure pending flow entries
are release before module goes away.

Fixes: 0ff90b6c2034 ("netfilter: nf_flow_offload: fix use-after-free and a resource leak")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_flow_table_core.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index be74dccfe1410..16076c66fcec7 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -202,6 +202,14 @@ static void flow_offload_route_release(struct flow_offload *flow)
 	nft_flow_dst_release(flow, FLOW_OFFLOAD_DIR_REPLY);
 }
 
+static void flow_offload_free_rcu(struct rcu_head *rcu_head)
+{
+	struct flow_offload *flow = container_of(rcu_head, struct flow_offload, rcu_head);
+
+	nf_ct_put(flow->ct);
+	kfree(flow);
+}
+
 void flow_offload_free(struct flow_offload *flow)
 {
 	switch (flow->type) {
@@ -211,8 +219,7 @@ void flow_offload_free(struct flow_offload *flow)
 	default:
 		break;
 	}
-	nf_ct_put(flow->ct);
-	kfree_rcu(flow, rcu_head);
+	call_rcu(&flow->rcu_head, flow_offload_free_rcu);
 }
 EXPORT_SYMBOL_GPL(flow_offload_free);
 
@@ -677,6 +684,7 @@ static int __init nf_flow_table_module_init(void)
 
 static void __exit nf_flow_table_module_exit(void)
 {
+	rcu_barrier();
 	nf_flow_table_offload_exit();
 	unregister_pernet_subsys(&nf_flow_table_net_ops);
 }
-- 
2.53.0



