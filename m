Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D524FC8D1;
	Wed, 23 Sep 2026 14:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174381; cv=none; b=aP9oDgFDxcaKHvMEv7s7jwNLpG1NJaWx/8puQ7y2kBe09ohFJPmcgyXR1sUjIrN0DOGdrc4ohJQpeIsuN05fLHHKAaZcs03yL4a00TXblompe390eDp2NWiVP73hDtco64wFMvBbHE6mZK/SgH6QPGnl4N9uxSfGBxsxO+aMV5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174381; c=relaxed/simple;
	bh=i+dzB46ubGZNGBI9Qujk411zwt7EtYDMfWiUVFqKAM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bUmN/ZEUvRIU18TCeCCZpFEYd8n81yLcc/wmU7rG8lftPh8eMvAomsi//5eEGlt8OTwG7Il4LRGxSY65zAayYOPi22ICbBAQt0zwt7i+f1esNEzLf6euDj8Pdjv85jpOzZl4/Bpcoa4ef7VBi0inenVaYQe57RIYsY/igVnV4T4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q+GJCFz+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q+GJCFz+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5689C1F000FF;
	Wed, 23 Sep 2026 14:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174379;
	bh=5BeVfzKxvB69swQlkui1/sTK82kcDY1eK41SlSItEHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q+GJCFz+em/YaQeIVc1CZ6inrwYrIBgKzU20a0F2XV5yiUe7NWsWjDOdlPDiEdSVp
	 LxFpjRCwykSL/f44ygMdFKYaiqTOC+iqavfI0FD1kuk2w+NZrQem8s8PICLYTDRRIt
	 p9Xe6UccG5i7MQ5a81R7MYhDak6FqWZGzA9fPu1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 095/398] netfilter: flowtable: hold reference on ct until flow is released
Date: Wed, 23 Sep 2026 16:02:49 +0200
Message-ID: <20260923140645.898506693@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 7a93e22d049db..2fc2e08aecfb1 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -250,6 +250,14 @@ static void flow_offload_route_release(struct flow_offload *flow)
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
@@ -259,8 +267,7 @@ void flow_offload_free(struct flow_offload *flow)
 	default:
 		break;
 	}
-	nf_ct_put(flow->ct);
-	kfree_rcu(flow, rcu_head);
+	call_rcu(&flow->rcu_head, flow_offload_free_rcu);
 }
 EXPORT_SYMBOL_GPL(flow_offload_free);
 
@@ -839,6 +846,7 @@ static int __init nf_flow_table_module_init(void)
 
 static void __exit nf_flow_table_module_exit(void)
 {
+	rcu_barrier();
 	nf_flow_table_offload_exit();
 	unregister_pernet_subsys(&nf_flow_table_net_ops);
 }
-- 
2.53.0



