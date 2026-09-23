Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B501B3750D5;
	Wed, 23 Sep 2026 14:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172951; cv=none; b=XQv+R7iftMeGCR8ViSWZyj9frz6rp67KimQ5zYXm4MuLsJBBnsNPze1bSOJS77Ou0z4BUgBIJwGonlR+rPqmdsh9Py6aQZpYLp3C1+8vhyuj4RWYZMOzYAYcTP2qvsWAjHo0itoVFsyuoL7O/Z6KK2KiGwpB89KR458kK4PodBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172951; c=relaxed/simple;
	bh=hwDiFMsN2HHt0TMR/9q1lGULgsQgdUZ/z6la8XhM4lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lziyhcHCE+gjo4VgVxg54EFFqyHDZj/ZADxkVDKm3+q35bmEOBr2kz5RqwYRWy+ezaiBI9CrdtEOKsSjMwM8iVN4ZjmBq4uimOuNFHpPyCnRFVqXT2cMGz3q7eUOuIh/s97OD64NO3xTDkaA/8FidMYIb21tQmZVYidE8C5tpq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a8HwIJIE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a8HwIJIE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEDBA1F000FF;
	Wed, 23 Sep 2026 14:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172950;
	bh=+2bsZ/iH1KPnHVmw/0d+VnmGKrxiAg+wWMWZbdwmnT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a8HwIJIEatTA8OxKbR8o9v7MxQPkXgc8VXuamCzjzuJ9pWwh1t63jVmEagkgijqy+
	 ln6S+5OtnXkeTYAAhJ+wOrzMvFewRe1e32CajgDx4YFji/eMhpmqHfwDBbdWpVZbWY
	 z9jPlOwTG/yyCzapQ3xx9U+FtkjMALbYaA0NDh1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 108/438] netfilter: flowtable: hold reference on ct until flow is released
Date: Wed, 23 Sep 2026 16:02:09 +0200
Message-ID: <20260923140647.580607112@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 8b1165f2b5a49..254063fca0780 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -258,6 +258,14 @@ static void flow_offload_route_release(struct flow_offload *flow)
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
@@ -267,8 +275,7 @@ void flow_offload_free(struct flow_offload *flow)
 	default:
 		break;
 	}
-	nf_ct_put(flow->ct);
-	kfree_rcu(flow, rcu_head);
+	call_rcu(&flow->rcu_head, flow_offload_free_rcu);
 }
 EXPORT_SYMBOL_GPL(flow_offload_free);
 
@@ -852,6 +859,7 @@ static int __init nf_flow_table_module_init(void)
 
 static void __exit nf_flow_table_module_exit(void)
 {
+	rcu_barrier();
 	nf_flow_table_offload_exit();
 	unregister_pernet_subsys(&nf_flow_table_net_ops);
 	kmem_cache_destroy(flow_offload_cachep);
-- 
2.53.0



