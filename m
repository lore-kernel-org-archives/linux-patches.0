Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1E53D9530;
	Wed, 30 Sep 2026 19:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796053; cv=none; b=AoDHLGXZxt/khWA7/YIjzLcf9LsKOztgjdpuZhfUJLLSPSOTYg7mQmOQGB1gX2l/KQztiGG4VSZhLz2IJPs0TMPP1kUv+5cyzRdBu8GdCVA0V9qqh0d1a5jt3SBa4OLpgmQYmmdrGjRAOoOaf8tKKgCLw9/S1mrAkqHQdEmkwcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796053; c=relaxed/simple;
	bh=uidf9rKd1h5tJsT2K6ZfaoO7d5EiwO+eGEqX3S0XRbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BqTZT1Q8E6IulV5q8PdiNE/Nni57HHeZxIx9DUWoyMUeuFIWrpo5Jnfd5UWZ+9FeUoZhNVYhPU/7nZpAYEsEkvMwjI/0PYctyxSyJ9D/o/d85T9cPS1bLE4druGoPDU24890fSHXHSuleTUgLFtL+LidrIQP2FWV/Rvl/oNIHsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oHa+vTQo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oHa+vTQo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B621F000FF;
	Wed, 30 Sep 2026 19:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796051;
	bh=E0W74ET9jndSyKj1V7nedWoi4YVvz8DslX1dy40QGyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oHa+vTQoRrA1LuvskpPkQgPCSrUiYAeR3hSnTcP5mFwgiRoGinsE9+PytgJ5mbkT3
	 CtY7pTcoDXL4w9lFQsWPLoeeABnu6etR9DVoIjqVrBqeNn/EByFiN6T47ZK5XNiUGw
	 ei1UUCQ3Mu8+BFQYRO1wcDDDjdALIYchvfDiyF5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0777/1193] netfilter: flowtable: hold reference on ct until flow is released
Date: Wed, 30 Sep 2026 17:24:21 +0200
Message-ID: <20260930152451.516165182@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index acfbaf9db58bc..e3afc1f4f1689 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -205,6 +205,14 @@ static void flow_offload_route_release(struct flow_offload *flow)
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
@@ -214,8 +222,7 @@ void flow_offload_free(struct flow_offload *flow)
 	default:
 		break;
 	}
-	nf_ct_put(flow->ct);
-	kfree_rcu(flow, rcu_head);
+	call_rcu(&flow->rcu_head, flow_offload_free_rcu);
 }
 EXPORT_SYMBOL_GPL(flow_offload_free);
 
@@ -680,6 +687,7 @@ static int __init nf_flow_table_module_init(void)
 
 static void __exit nf_flow_table_module_exit(void)
 {
+	rcu_barrier();
 	nf_flow_table_offload_exit();
 	unregister_pernet_subsys(&nf_flow_table_net_ops);
 }
-- 
2.53.0



