Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E19E3314C3
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301244; cv=none; b=IwjWu9JSdyUhmyKvVenmsDSy3OsI2/cKGnRxVLZf64LBPjuiqSxtMpBEtbVqqk4iOkKFCK2GIJsUyJ0Dh620gx4e0sQUaH+MGJ38/qTQ18q17Oz+h1Y0DuhglZ86DDmWiSdS0Z2oocylKAZoFwZReudbNfUmjt2z1QHhCZPTj8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301244; c=relaxed/simple;
	bh=alBuDf9HSqqVcmj1GyzmROzhC8BN9Vo36994aPyprhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=agpZEoiGKmfiXznIF+h76rhAEoHAtyaJ6howEkpe2Z8G6yzBsiBnb9PkkAgVbsEbbV4mqYvjyBq19LgceqLSeNaAklSfzKcgiU7WUpM4CUcisCt0hhBG/HYZe/V+F/V3LZCgHJK5mY3+bA+54PDATm8YaTje/oe1+0BhfnlzI4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fs9Hr7rx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fs9Hr7rx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64F87C19423;
	Sat, 28 Feb 2026 17:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301244;
	bh=alBuDf9HSqqVcmj1GyzmROzhC8BN9Vo36994aPyprhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fs9Hr7rxEyKByLqBnAFPn73o+O4p8mfW5LNpLFCqP/U25y1qn5wEvsigH9g6uBCCb
	 qdb5bfN07gAAXnkNFoZfPrSWAF92GE4whVJHfTVkPSqzjjX2ZYe6fZNfxbA6ERZL0Y
	 fhdJ8gcnGX3rOXtZCAzXr1btZOnoyYJD9nY70eDWrdLzpTC57JnDi+TZRO4zqsA/Pv
	 U4C4/Ynj5c9+8WxFIrBuRzCqO0O7TLKkPRfTHZPvlqay1EnsFtwrWDCARe6zZxHoe3
	 RdegourQWxZ5PWMVg5a5mwJQp6t8Da/6gv6jXJnRGqgoo4pEt8hWhx4znwwI3lnhHf
	 6n6Gxy7UkS6IQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Eric Dumazet <edumazet@google.com>,
	Krishna Kumar <krikku@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 425/752] net: do not pass flow_id to set_rps_cpu()
Date: Sat, 28 Feb 2026 12:42:16 -0500
Message-ID: <20260228174750.1542406-425-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 8a8a9fac9efa6423fd74938b940cb7d731780718 ]

Blamed commit made the assumption that the RPS table for each receive
queue would have the same size, and that it would not change.

Compute flow_id in set_rps_cpu(), do not assume we can use the value
computed by get_rps_cpu(). Otherwise we risk out-of-bound access
and/or crashes.

Fixes: 48aa30443e52 ("net: Cache hash and flow_id to avoid recalculation")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Krishna Kumar <krikku@gmail.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260220222605.3468081-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index ff70c902a4196..2dc1cf7f8d892 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4932,8 +4932,7 @@ static bool rps_flow_is_active(struct rps_dev_flow *rflow,
 
 static struct rps_dev_flow *
 set_rps_cpu(struct net_device *dev, struct sk_buff *skb,
-	    struct rps_dev_flow *rflow, u16 next_cpu, u32 hash,
-	    u32 flow_id)
+	    struct rps_dev_flow *rflow, u16 next_cpu, u32 hash)
 {
 	if (next_cpu < nr_cpu_ids) {
 		u32 head;
@@ -4944,6 +4943,7 @@ set_rps_cpu(struct net_device *dev, struct sk_buff *skb,
 		struct rps_dev_flow *tmp_rflow;
 		unsigned int tmp_cpu;
 		u16 rxq_index;
+		u32 flow_id;
 		int rc;
 
 		/* Should we steer this flow to a different hardware queue? */
@@ -4959,6 +4959,7 @@ set_rps_cpu(struct net_device *dev, struct sk_buff *skb,
 		if (!flow_table)
 			goto out;
 
+		flow_id = rfs_slot(hash, flow_table);
 		tmp_rflow = &flow_table->flows[flow_id];
 		tmp_cpu = READ_ONCE(tmp_rflow->cpu);
 
@@ -5006,7 +5007,6 @@ static int get_rps_cpu(struct net_device *dev, struct sk_buff *skb,
 	struct rps_dev_flow_table *flow_table;
 	struct rps_map *map;
 	int cpu = -1;
-	u32 flow_id;
 	u32 tcpu;
 	u32 hash;
 
@@ -5053,8 +5053,7 @@ static int get_rps_cpu(struct net_device *dev, struct sk_buff *skb,
 		/* OK, now we know there is a match,
 		 * we can look at the local (per receive queue) flow table
 		 */
-		flow_id = rfs_slot(hash, flow_table);
-		rflow = &flow_table->flows[flow_id];
+		rflow = &flow_table->flows[rfs_slot(hash, flow_table)];
 		tcpu = rflow->cpu;
 
 		/*
@@ -5073,8 +5072,7 @@ static int get_rps_cpu(struct net_device *dev, struct sk_buff *skb,
 		     ((int)(READ_ONCE(per_cpu(softnet_data, tcpu).input_queue_head) -
 		      rflow->last_qtail)) >= 0)) {
 			tcpu = next_cpu;
-			rflow = set_rps_cpu(dev, skb, rflow, next_cpu, hash,
-					    flow_id);
+			rflow = set_rps_cpu(dev, skb, rflow, next_cpu, hash);
 		}
 
 		if (tcpu < nr_cpu_ids && cpu_online(tcpu)) {
-- 
2.51.0

