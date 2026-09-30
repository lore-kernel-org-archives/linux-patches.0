Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6BB4C4F58;
	Wed, 30 Sep 2026 15:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783426; cv=none; b=OXJ0iIu60m2jeQk8UW4pJw2fqrdZQQtcY1r1juz4zQAoTvjRTlYUYPSX9tX1vr1YHPrzZ73iEjcpTAxqktPoMwhnkNWhT5JD8N50MHb0eWzFd0uosSwRqM9t2Rt5+TolaHBakqazv7XOHhqMNQrogELNSC3HTtc85IxAKaBfEt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783426; c=relaxed/simple;
	bh=pnOLCn4lggZFNeB2BRAY0Ka1UPwbrXgY+WaL0DUXUn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZWxSowCgO34spOukQuBhxFpNimn4XrqaRPkATvd8XPYdnJao4CSJDLY/dygcQr41whQXXCPsPNIDLDpIZ/hWXwUHfxy+pNG+Ga3ff9F4pgdGcFpEf+Ul/gFgXmPBOplJFknar2dQZKRgbap78hVn2zX3IXqB0gtUF06N5T60jL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sLHaVmNn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sLHaVmNn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F22291F000FF;
	Wed, 30 Sep 2026 15:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783421;
	bh=1dei6aotc0RFVVsHjbuPVDoqn4qgMSl14fYc+Ak48rI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sLHaVmNnl8kVu3kUQK5Xg4s6XPiQOIT5h+pSLckJgAMKXS1lHWBpoYtgFcCQ9nbYM
	 a8+9+xQ0O6bxTc4z4gTQPocvLm5sNYhvJpXHHiq4FOVbV15PoeKyyB0OeOoDa+vKPJ
	 +yPhtttjRL9YAPuwkHReCFh0F89g0puZCUkUM7hs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 391/595] netfilter: flowtable: hold reference on ct until flow is released
Date: Wed, 30 Sep 2026 17:24:44 +0200
Message-ID: <20260930152356.083766485@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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
index 8f6b791918ae7..1d4a236b5bc25 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -173,6 +173,14 @@ static void flow_offload_route_release(struct flow_offload *flow)
 	dst_release(flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.dst_cache);
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
@@ -182,8 +190,7 @@ void flow_offload_free(struct flow_offload *flow)
 	default:
 		break;
 	}
-	nf_ct_put(flow->ct);
-	kfree_rcu(flow, rcu_head);
+	call_rcu(&flow->rcu_head, flow_offload_free_rcu);
 }
 EXPORT_SYMBOL_GPL(flow_offload_free);
 
@@ -584,6 +591,7 @@ static int __init nf_flow_table_module_init(void)
 
 static void __exit nf_flow_table_module_exit(void)
 {
+	rcu_barrier();
 	nf_flow_table_offload_exit();
 }
 
-- 
2.53.0



