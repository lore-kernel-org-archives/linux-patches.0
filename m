Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9463913B79F;
	Tue, 27 Feb 2024 14:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043610; cv=none; b=ada+3FoDsYhnAzRpibR4YRlsH5ySMySQVRU1hpre19hJHbFzG5Foq59q1unORdBQwTVWg1dJi6rm0pNhL2y68GOeFo9974OU/KN2eQAOpPR4P3y4WJN435XZNSvbN0X48Tf3yzSZlRWNUR0GwcTRE0pJuTQqmTotKMzkEqwxwKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043610; c=relaxed/simple;
	bh=fUk9FEerajzSuU5e4XSISI3f2vLIBUxz3U5jQk0UfTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UxuAkrSdDK1YBk9eH7ZoqtRlaD/lPSmpWSeL6VX7VhZ5VygQadALfgQb8O4o8LohB+PXSOrwhnJKF/CUHwrrxPMds2hBI1SOSsflwk8x1OYkzN9r6eBZ4XN6O7lLa8s6Do4cK4mE69z5leCL0aQ8lE7dsVF00NXDojtDlacReU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fYVz6c5C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fYVz6c5C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21DC7C433F1;
	Tue, 27 Feb 2024 14:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043610;
	bh=fUk9FEerajzSuU5e4XSISI3f2vLIBUxz3U5jQk0UfTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fYVz6c5Cuu3QlUhXe9x9ksdRvuZgrIY0ipclJvHtezpEchjaEmxmvXXzKNx6JX5u+
	 b7Nc0eBCri1pKcLXIhCFLDeJ10aDLk78k5h36nJUtdDQS+Q3p4aTAJCi1GHgSwQFXN
	 38EI0uUO4vePmt6uRF7wyH7tjyH6xiFaLlhPXf/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 171/195] netfilter: nft_flow_offload: reset dst in route object after setting up flow
Date: Tue, 27 Feb 2024 14:27:12 +0100
Message-ID: <20240227131616.054331791@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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
index 78e4aba52b22a..2036c7a27075b 100644
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



