Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F303B71A7;
	Sat, 17 Oct 2026 18:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260549; cv=none; b=TDtAVqEOs5Lx0ipdsJISirP5RaT63TuOLNXfUSj8WimL8H9v6ldyqyUJm29ZnXScp3B1YyLb7m5mzZy+0ltK3nTG6jnvEjIUwQEFyFbzv4OaWXkpOPDNFHaq8NbmMnK0WO8/qG7bZvaNZB/g7/afbVw0YpOFz/v6LvHPZ3nexj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260549; c=relaxed/simple;
	bh=AQytIGa3YzsOg4r9H4UB81LK13CZWEeE1ejEMGgNbEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KGyA0qPM+VB1HtrhSvjHcCQw6aPsKapN23Ovrbkt34060P4fZ12CI728DzqRQBjjvYebXreZHry9fyZWrbiyR20tr4D6zUY6rAfiFCckHKji6MxZk4LlPC1BnqvGpzcEsCkK9NDKeYf5wmmA/1yqqs94FttPNN2T29HC/XKc6FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N8ur3Duw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N8ur3Duw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49B381F000C4;
	Sat, 17 Oct 2026 18:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260547;
	bh=nPUhIEPlivJtbwOoOZ9kLj3j+xUoTtE/NgZH/Kfexus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N8ur3DuwdbmeQoCq3DcZREX9btcxtE+2+JlFqrN8myTPHmEgkVlWTxZUMHg46EVFT
	 jt/nbLlUJqTeeQFA1yHnH731bxRwJbljdFuTnOjVQrYhbplJbRZ0fG3rAEBY2N7L4M
	 UY4HRvRikB8O3Lc4VqxGIMS+bnRzyE4dVmHebwqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1579/1674] firewire: core: fix memory leak in error path of build_tree()
Date: Sat, 17 Oct 2026 18:04:11 +0200
Message-ID: <20261017160511.623677722@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
 drivers/firewire/core-topology.c | 30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/firewire/core-topology.c b/drivers/firewire/core-topology.c
index f40c815343812..99a2fc88ccd2e 100644
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
@@ -273,7 +284,7 @@ static struct fw_node *build_tree(struct fw_card *card,
 		    (next_sid < end && parent_count != 1)) {
 			fw_err(card, "parent port inconsistency for node %d: "
 			       "parent_count=%d\n", phy_id, parent_count);
-			return NULL;
+			goto error;
 		}
 
 		/* Pop the child nodes off the stack and push the new node. */
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



