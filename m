Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216560;
	b=yY5jgp42T8pPQ2dnbhe7EXgm0dkpqJ9GCzMAsW+ELBvwmislp2QSLgpBQ7QapuEm5usC
	 fITlyBPDI/IR79HgQDkB77m0h8VIm4oMv4XMBk9G11LdLJ3ULP93L3TtTmxwJ2s4DMMvk
	 bz4xw6n8/i5E77585aITFiZ/9JpfzBvJ/V7hsUz/769DIIRO9J9t5dEyhh8aBkqxPw3Gk
	 mCySAf3xBOomAranKozrPyHn8paLY0MHRiy0kytho/yETDYMju+6owfcH68N+6E8U+aFl
	 RPjv4DXoJNOgIVCaO2wZyijbJjEjF12FdsFdY7hyZOKOgiWmx5FezQAdqH3bFB1rVNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216560;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C6Ukv/MD8I1Ki65001kAHzzAs3YdiVYyeJWXwZTyVR0=;
	b=K0uqbr3W2w8wEwQM5x160a8yQWn1UlHSxtckOVuLU+HZ+JpS2PkE4GK+FhT9t+Ufxjkj
	 QAyB4vgtmOQATmRFg3qKROdCtQ3KVkO1d1KXzFdkRJwE0mXptSjEz2JWLhARsH7sX9M2m
	 vouEP3UrzTBwu8pJMSZy8v57gAcUC76iF8bsWkZL/y2hN5ccx0jrgtPFYDWFSd4SMdsgC
	 3kD4tJ3b94JzjNPXGrPtZ/PooA/JIFD1MMwtB+nkHxUx2bJ10dyyDaaq627r8QEJkDTuA
	 qV+PgzsA1e+aO8vvfzAQ8Op8ynhEDvzImcmtxYyaUm2g3X15OqfFlZzVeIsTIOY+9GA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qM4VILZu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74368606A31D;
	Wed, 28 Oct 2026 19:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qM4VILZu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C55D21F01825;
	Wed, 28 Oct 2026 19:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216560;
	bh=C6Ukv/MD8I1Ki65001kAHzzAs3YdiVYyeJWXwZTyVR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qM4VILZuu4kSe4M+Oz9FQkEmlpVBHlfrLUcpWm1hN/SPWM3Bl7LN7KKz7JhgdGeLW
	 MTxHl/o69jCKgAknhVsirYySTZF30mzAxFEpYQJQP7bj9zwYpbjB8TCkPIYsfed+X7
	 rQGMGtsa26XQaDkrIrvzfv4UInKBaCRMD5HXH9UQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1555/1887] firewire: core: fix memory leak in error path of build_tree()
Date: Wed, 28 Oct 2026 18:00:51 +0100
Message-ID: <20261028170534.852151636@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/firewire/core-topology.c | 40 +++++++++++++++++++++-----------
 1 file changed, 26 insertions(+), 14 deletions(-)

diff --git a/drivers/firewire/core-topology.c b/drivers/firewire/core-topology.c
index f40c815343812..ddcc3fb6cfbd4 100644
--- a/drivers/firewire/core-topology.c
+++ b/drivers/firewire/core-topology.c
@@ -161,6 +161,17 @@ static inline struct fw_node *fw_node(struct list_head *l)
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
+	fw_node_put(node);
+}
+
 /*
  * This function builds the tree representation of the topology given
  * by the self IDs from the latest bus reset.  During the construction
@@ -193,19 +204,19 @@ static struct fw_node *build_tree(struct fw_card *card,
 
 		if (next_sid == NULL) {
 			fw_err(card, "inconsistent extended self IDs\n");
-			return NULL;
+			goto error;
 		}
 
 		q = *sid;
 		if (phy_id != SELF_ID_PHY_ID(q)) {
 			fw_err(card, "PHY ID mismatch in self ID: %d != %d\n",
 			       phy_id, SELF_ID_PHY_ID(q));
-			return NULL;
+			goto error;
 		}
 
 		if (child_port_count > stack_depth) {
 			fw_err(card, "topology stack underflow\n");
-			return NULL;
+			goto error;
 		}
 
 		/*
@@ -223,7 +234,7 @@ static struct fw_node *build_tree(struct fw_card *card,
 		node = fw_node_create(q, port_count, card->color);
 		if (node == NULL) {
 			fw_err(card, "out of memory while building topology\n");
-			return NULL;
+			goto error;
 		}
 
 		if (phy_id == (card->node_id & 0x3f))
@@ -264,6 +275,11 @@ static struct fw_node *build_tree(struct fw_card *card,
 			}
 		}
 
+		/* Pop the child nodes off the stack and push the new node. */
+		__list_del(h->prev, &stack);
+		list_add_tail(&node->link, &stack);
+		stack_depth += 1 - child_port_count;
+
 		/*
 		 * Check that the node reports exactly one parent
 		 * port, except for the root, which of course should
@@ -273,14 +289,9 @@ static struct fw_node *build_tree(struct fw_card *card,
 		    (next_sid < end && parent_count != 1)) {
 			fw_err(card, "parent port inconsistency for node %d: "
 			       "parent_count=%d\n", phy_id, parent_count);
-			return NULL;
+			goto error;
 		}
 
-		/* Pop the child nodes off the stack and push the new node. */
-		__list_del(h->prev, &stack);
-		list_add_tail(&node->link, &stack);
-		stack_depth += 1 - child_port_count;
-
 		if (node->phy_speed == SCODE_BETA &&
 		    parent_count + child_port_count > 1)
 			beta_repeaters_present = true;
@@ -304,12 +315,13 @@ static struct fw_node *build_tree(struct fw_card *card,
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
-- 
2.53.0



