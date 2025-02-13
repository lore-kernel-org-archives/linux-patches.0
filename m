Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A051DC745;
	Thu, 13 Feb 2025 14:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458769; cv=none; b=gv75t3OsF32t9a1HlOcCjfENRorfAniZ+6OqNaVd23wnhdMjJNkLjuNGbhiSTcqO1Ox0NO0N6zWYJgs8MzVlMFQ09g9RF9iYyfsIYIuLCI0kuA/7XnyrgNqyxIfGxa4pcNzJn3dh+2hUmLhZJtn/9Cpp/5arrTY8u4FF5eIEj7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458769; c=relaxed/simple;
	bh=FRbsv8ABApmWnnJtmqhKV6fHTMOac+B0iwxhlbdHcmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=STFo5AAuDNPLGgOdmA7e0CANs0dBaOqopxGGRhLYbyJz1k3aq6I7sKVpwnUhLRx/arVghePkxZptPprvaHHVRky5T4wsuD4E7kpepOTmYlfffJ08woAl4Ueaq+k9PMrwYmLprQsOFuZAqJRqTZpYsVWeyWZYY+FilqR7UiYQdKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JmcsxBof; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JmcsxBof"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69530C4CEE5;
	Thu, 13 Feb 2025 14:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458768;
	bh=FRbsv8ABApmWnnJtmqhKV6fHTMOac+B0iwxhlbdHcmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JmcsxBofiBjYpwQabmIRlPBhT4jlogxUiHf/dUmzuPLG7bHwuaIXVbfM5tjnt40Mu
	 +oYK0+Xy/M9PryB5GCFIBssGoLipZ1z9/fVcM+a0tCKHbB+5U96s4WAqkcwVXw+l27
	 gS5KmXYKKbDgZX4TFsrVTEFeVvvkqX2xgow6TpQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Erez Shitrit <erezsh@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 065/443] net/mlx5: HWS, num_of_rules counter on matcher should be atomic
Date: Thu, 13 Feb 2025 15:23:50 +0100
Message-ID: <20250213142443.128754476@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

[ Upstream commit 61fb92701b8ac9174857c417cfa988adc24e32c2 ]

Rule counter in matcher's struct is used in two places:

1. As heuristics to decide when the number of rules have crossed a
certain percentage threshold and the matcher should be resized.
We don't mind here if the number will be off by 1-2 due to concurrency.

2. When destroying matcher, the counter value is checked and the
user is warned if it is not 0. Here we lock all the queues, so the
counter will be correct.

We don't need to always have *exact* number, but we do need this
number to not be corrupted, which is what is happening when the
counter isn't atomic, due to update by different threads.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Erez Shitrit <erezsh@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20250102181415.1477316-10-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/steering/hws/bwc.c       | 17 +++++++++++------
 .../mellanox/mlx5/core/steering/hws/bwc.h       |  2 +-
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/bwc.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/bwc.c
index baacf662c0ab8..ae2849cf4dd49 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/bwc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/bwc.c
@@ -152,6 +152,8 @@ mlx5hws_bwc_matcher_create(struct mlx5hws_table *table,
 	if (!bwc_matcher)
 		return NULL;
 
+	atomic_set(&bwc_matcher->num_of_rules, 0);
+
 	/* Check if the required match params can be all matched
 	 * in single STE, otherwise complex matcher is needed.
 	 */
@@ -199,10 +201,12 @@ int mlx5hws_bwc_matcher_destroy_simple(struct mlx5hws_bwc_matcher *bwc_matcher)
 
 int mlx5hws_bwc_matcher_destroy(struct mlx5hws_bwc_matcher *bwc_matcher)
 {
-	if (bwc_matcher->num_of_rules)
+	u32 num_of_rules = atomic_read(&bwc_matcher->num_of_rules);
+
+	if (num_of_rules)
 		mlx5hws_err(bwc_matcher->matcher->tbl->ctx,
 			    "BWC matcher destroy: matcher still has %d rules\n",
-			    bwc_matcher->num_of_rules);
+			    num_of_rules);
 
 	mlx5hws_bwc_matcher_destroy_simple(bwc_matcher);
 
@@ -309,7 +313,7 @@ static void hws_bwc_rule_list_add(struct mlx5hws_bwc_rule *bwc_rule, u16 idx)
 {
 	struct mlx5hws_bwc_matcher *bwc_matcher = bwc_rule->bwc_matcher;
 
-	bwc_matcher->num_of_rules++;
+	atomic_inc(&bwc_matcher->num_of_rules);
 	bwc_rule->bwc_queue_idx = idx;
 	list_add(&bwc_rule->list_node, &bwc_matcher->rules[idx]);
 }
@@ -318,7 +322,7 @@ static void hws_bwc_rule_list_remove(struct mlx5hws_bwc_rule *bwc_rule)
 {
 	struct mlx5hws_bwc_matcher *bwc_matcher = bwc_rule->bwc_matcher;
 
-	bwc_matcher->num_of_rules--;
+	atomic_dec(&bwc_matcher->num_of_rules);
 	list_del_init(&bwc_rule->list_node);
 }
 
@@ -704,7 +708,8 @@ hws_bwc_matcher_rehash_size(struct mlx5hws_bwc_matcher *bwc_matcher)
 	 * Need to check again if we really need rehash.
 	 * If the reason for rehash was size, but not any more - skip rehash.
 	 */
-	if (!hws_bwc_matcher_rehash_size_needed(bwc_matcher, bwc_matcher->num_of_rules))
+	if (!hws_bwc_matcher_rehash_size_needed(bwc_matcher,
+						atomic_read(&bwc_matcher->num_of_rules)))
 		return 0;
 
 	/* Now we're done all the checking - do the rehash:
@@ -797,7 +802,7 @@ int mlx5hws_bwc_rule_create_simple(struct mlx5hws_bwc_rule *bwc_rule,
 	}
 
 	/* check if number of rules require rehash */
-	num_of_rules = bwc_matcher->num_of_rules;
+	num_of_rules = atomic_read(&bwc_matcher->num_of_rules);
 
 	if (unlikely(hws_bwc_matcher_rehash_size_needed(bwc_matcher, num_of_rules))) {
 		mutex_unlock(queue_lock);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/bwc.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/bwc.h
index 0b745968e21e1..655fa7a22d84f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/bwc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/bwc.h
@@ -19,7 +19,7 @@ struct mlx5hws_bwc_matcher {
 	u8 num_of_at;
 	u16 priority;
 	u8 size_log;
-	u32 num_of_rules; /* atomically accessed */
+	atomic_t num_of_rules;
 	struct list_head *rules;
 };
 
-- 
2.39.5



