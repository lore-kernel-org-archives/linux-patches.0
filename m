Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A18A413AA4C;
	Tue, 27 Feb 2024 13:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041366; cv=none; b=iYDaDx9jt99r+KlRmJrZD04SAFElan4vk0OnxcwBxXtOxbgOTHP4/Wu26GEV+GxGpVHKDiuqbOj4lhqrzIEgtYXo+4YQufiFC4FMVKoJE3q12ovCtAMCPVY30apFHEzq02cDnBQtBUkljmPgVxCLJzg297wEuIuz55+mDjkoUSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041366; c=relaxed/simple;
	bh=rULKSNiQbH2p3xNymx5G6oGihxfAH2ifTcg+vv5tXH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Psjm7ZIe0ktgW5OnTDhh1doxGYnEtfY2lfcL6dHvEoayMrIvmPo7vOj8LGesjp2JeWxsMDkVXs5FRVjsieylF6n0G02sYvwpJ/5Qovo53xU58Myg/zYowRlR+Q0bSiSSp80Q6sZ1vwjXOX8zt7NgIus1QRx59WVGmhBARRpXvt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W9MQsIhp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W9MQsIhp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32B1BC433C7;
	Tue, 27 Feb 2024 13:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041366;
	bh=rULKSNiQbH2p3xNymx5G6oGihxfAH2ifTcg+vv5tXH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W9MQsIhpJu8UMlnU3l9b6flVHYHQjZrr15L6MA2960rZzZdqwk8BZEvWeTF38BxbG
	 tipiHI0icerIQ16N4W+yLgpaajra3bFJrnnPOwuU7t4+3ixpagKTRbEF1/jMfxqyNI
	 TvkbjAZwaNo/oug3jN/xihpc1WS7/uWZE1oIjrPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 307/334] netfilter: nft_flow_offload: reset dst in route object after setting up flow
Date: Tue, 27 Feb 2024 14:22:45 +0100
Message-ID: <20240227131640.964094896@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 9e0f0430389be7696396c62f037be4bf72cf93e3 ]

dst is transferred to the flow object, route object does not own it
anymore.  Reset dst in route object, otherwise if flow_offload_add()
fails, error path releases dst twice, leading to a refcount underflow.

Fixes: a3c90f7a2323 ("netfilter: nf_tables: flow offload expression")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_flow_table.h |  2 +-
 net/netfilter/nf_flow_table_core.c    | 16 +++++++++++++---
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 692d5955911c7..4a767b3d20b9d 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -275,7 +275,7 @@ nf_flow_table_offload_del_cb(struct nf_flowtable *flow_table,
 }
 
 void flow_offload_route_init(struct flow_offload *flow,
-			     const struct nf_flow_route *route);
+			     struct nf_flow_route *route);
 
 int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow);
 void flow_offload_refresh(struct nf_flowtable *flow_table,
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 920a5a29ae1dc..7502d6d73a600 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -87,12 +87,22 @@ static u32 flow_offload_dst_cookie(struct flow_offload_tuple *flow_tuple)
 	return 0;
 }
 
+static struct dst_entry *nft_route_dst_fetch(struct nf_flow_route *route,
+					     enum flow_offload_tuple_dir dir)
+{
+	struct dst_entry *dst = route->tuple[dir].dst;
+
+	route->tuple[dir].dst = NULL;
+
+	return dst;
+}
+
 static int flow_offload_fill_route(struct flow_offload *flow,
-				   const struct nf_flow_route *route,
+				   struct nf_flow_route *route,
 				   enum flow_offload_tuple_dir dir)
 {
 	struct flow_offload_tuple *flow_tuple = &flow->tuplehash[dir].tuple;
-	struct dst_entry *dst = route->tuple[dir].dst;
+	struct dst_entry *dst = nft_route_dst_fetch(route, dir);
 	int i, j = 0;
 
 	switch (flow_tuple->l3proto) {
@@ -146,7 +156,7 @@ static void nft_flow_dst_release(struct flow_offload *flow,
 }
 
 void flow_offload_route_init(struct flow_offload *flow,
-			    const struct nf_flow_route *route)
+			     struct nf_flow_route *route)
 {
 	flow_offload_fill_route(flow, route, FLOW_OFFLOAD_DIR_ORIGINAL);
 	flow_offload_fill_route(flow, route, FLOW_OFFLOAD_DIR_REPLY);
-- 
2.43.0



