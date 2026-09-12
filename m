Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB67D356744;
	Sat, 12 Sep 2026 11:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211269; cv=none; b=In8zqqluHA6UMyyWZEk/2Z3Sa5xzTzrGd5EX+CMZJBEav/QZj1Exx0ckv7sGRYrX0ZkWm4ziZN01z9HB5I34TyKpNhTZfGeJpL6jGp4pycR81f290ppciYtu2BEfkK5WH+d3MiHJchjPgJGIe22PMrlZrqNSR9vFUfQd+PEwbvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211269; c=relaxed/simple;
	bh=wEXN3voZ6hZac89JYIfZzYormbAIvj2HU21lFOPY9ps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gPcSGXiz4dLUDCCT8KDamyCEHAeSosu75KRMJCfJm5GyRXzCqIbvP2a1x71Op2eSf8eDgI+/2mDUgABpC5lnlNdbv26CgEkNRHpAhxzvg6Xsnf160Qdk1KKqr/AFyvewQ8fOdYGz7FOx7LmF8p/EmdCb2ifbN43YpAZxhabnjqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EKJy9O3+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EKJy9O3+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8591F000FF;
	Sat, 12 Sep 2026 11:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211267;
	bh=684wNgKJ0Mbqevw3L22OKyxZe8wGsNAT176fyi68gGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EKJy9O3+0np47LLrxiMnMaXJc6oOi+96mmSIAKQ2Nmsh+PPpZuIeUf78lmRz9hJPh
	 D4MkVRoWcBbRjGJTTMT4gO5hD13FcafAqHBNYo3BuIP0ryeiPBi9XGog5xluqapq2w
	 2oIdY0e/j2dnIQhtFgKpD88si8uB4NNkIMqF3RDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1154/1518] firewire: core: fix memory leak in error path of build_tree()
Date: Sat, 12 Sep 2026 08:55:23 +0200
Message-ID: <20260912065649.560652425@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

[ Upstream commit 05bfb1327dc5fb61528bab31cd8f0c1e4bddec23 ]

In the error path of build_tree(), node instances can remain in the local
linked list when the function returns.

Whenever an invalid value is detected in the self ID sequence, each
allocated node instance is either an entry in the linked list or an
entry in the ports array of its parent node. Therefore, the allocate
node instances can be safely released by traversing the linked list from
its head.

Release the remaining node instances with for_each_fw_node() before
returning to the caller.

Fixes: 3038e353cfaf ("firewire: Add core firewire stack.")
Reported-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Link: https://lore.kernel.org/all/20260727095955.104972-1-nihaal@cse.iitm.ac.in/
Link: https://lore.kernel.org/r/20260811120928.700577-4-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firewire/core-topology.c  | 30 +++++++++++++++++++++---------
 drivers/firewire/node-tree-test.c |  4 ----
 2 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/drivers/firewire/core-topology.c b/drivers/firewire/core-topology.c
index e951b1089bef7..14eb8e3f84c84 100644
--- a/drivers/firewire/core-topology.c
+++ b/drivers/firewire/core-topology.c
@@ -88,6 +88,17 @@ static inline struct fw_node *fw_node(struct list_head *l)
 	return list_entry(l, struct fw_node, link);
 }
 
+typedef void (*fw_node_callback_t)(struct fw_card *card, struct fw_node *node,
+				   struct fw_node *parent);
+
+static void for_each_fw_node(struct fw_card *card, struct fw_node *root,
+			     fw_node_callback_t callback);
+
+static void free_fw_node(struct fw_card *card, struct fw_node *node, struct fw_node *parent)
+{
+	kfree(node);
+}
+
 /*
  * This function builds the tree representation of the topology given
  * by the self IDs from the latest bus reset.  During the construction
@@ -134,7 +145,7 @@ static struct fw_node *build_tree(struct fw_card *card, const u32 *sid, int self
 			if (PTR_ERR(self_id_sequence) != -ENODATA) {
 				fw_err(card, "inconsistent extended self IDs: %ld\n",
 				       PTR_ERR(self_id_sequence));
-				return NULL;
+				goto error;
 			}
 			break;
 		}
@@ -168,18 +179,18 @@ static struct fw_node *build_tree(struct fw_card *card, const u32 *sid, int self
 		    (enumerator.quadlet_count > 0 && parent_port_count != 1)) {
 			fw_err(card, "parent port inconsistency for node %d: parent_count=%d\n",
 			       phy_id, parent_port_count);
-			return NULL;
+			goto error;
 		}
 
 		if (phy_id != phy_packet_self_id_get_phy_id(self_id_sequence[0])) {
 			fw_err(card, "PHY ID mismatch in self ID: %d != %d\n",
 			       phy_id, phy_packet_self_id_get_phy_id(self_id_sequence[0]));
-			return NULL;
+			goto error;
 		}
 
 		if (child_port_count > stack_depth) {
 			fw_err(card, "topology stack underflow\n");
-			return NULL;
+			goto error;
 		}
 
 		/*
@@ -197,7 +208,7 @@ static struct fw_node *build_tree(struct fw_card *card, const u32 *sid, int self
 		node = fw_node_create(self_id_sequence[0], total_port_count, card->color);
 		if (node == NULL) {
 			fw_err(card, "out of memory while building topology\n");
-			return NULL;
+			goto error;
 		}
 
 		if (phy_id == (card->node_id & 0x3f))
@@ -256,12 +267,13 @@ static struct fw_node *build_tree(struct fw_card *card, const u32 *sid, int self
 	card->beta_repeaters_present = beta_repeaters_present;
 
 	return local_node;
+error:
+	++card->color;
+	list_for_each_entry_safe(node, child, &stack, link)
+		for_each_fw_node(card, node, free_fw_node);
+	return NULL;
 }
 
-typedef void (*fw_node_callback_t)(struct fw_card * card,
-				   struct fw_node * node,
-				   struct fw_node * parent);
-
 static void for_each_fw_node(struct fw_card *card, struct fw_node *root,
 			     fw_node_callback_t callback)
 {
diff --git a/drivers/firewire/node-tree-test.c b/drivers/firewire/node-tree-test.c
index 251c0113639f2..5e6bb58537e94 100644
--- a/drivers/firewire/node-tree-test.c
+++ b/drivers/firewire/node-tree-test.c
@@ -521,7 +521,6 @@ static void node_tree_test_invalid_extended_self_id_sequence(struct kunit *test)
 
 	card->node_id = LOCAL_BUS | 0x03;
 
-	// TODO: Memory leak.
 	card->local_node = build_tree(card, self_id_sequence, ARRAY_SIZE(self_id_sequence), 123);
 	KUNIT_EXPECT_NULL(test, card->local_node);
 }
@@ -541,7 +540,6 @@ static void node_tree_test_invalid_phy_id(struct kunit *test)
 
 	card->node_id = LOCAL_BUS | 0x03;
 
-	// TODO: Memory leak.
 	card->local_node = build_tree(card, self_id_sequence, ARRAY_SIZE(self_id_sequence), 123);
 	KUNIT_EXPECT_NULL(test, card->local_node);
 }
@@ -561,7 +559,6 @@ static void node_tree_test_invalid_child_port_count(struct kunit *test)
 
 	card->node_id = LOCAL_BUS | 0x03;
 
-	// TODO: Memory leak.
 	card->local_node = build_tree(card, self_id_sequence, ARRAY_SIZE(self_id_sequence), 123);
 	KUNIT_EXPECT_NULL(test, card->local_node);
 }
@@ -581,7 +578,6 @@ static void node_tree_test_invalid_parent_port_count(struct kunit *test)
 
 	card->node_id = LOCAL_BUS | 0x03;
 
-	// TODO: Memory leak.
 	card->local_node = build_tree(card, self_id_sequence, ARRAY_SIZE(self_id_sequence), 123);
 	KUNIT_EXPECT_NULL(test, card->local_node);
 }
-- 
2.53.0



