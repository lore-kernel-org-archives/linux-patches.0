Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324D820ED;
	Sat, 12 Sep 2026 08:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203329; cv=none; b=XSHcrR/035J0AJgkIchOOfjodqAaaqldrPZ+FrtB1bRBcspUoKXYnB5ruOdUA54BqYEakcZgJlhgQksEl6CXnmnpQ8m2HVQ7nvnhvs5vIVsyB3/uWINCOOhIGVO+bE63nm6KY2zIpkHH+qi3D0nfe19yvqRyjazhsKaBmtXoSn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203329; c=relaxed/simple;
	bh=iijlQqYZS4KiW3/OY3fCQBTFFEE0X7gfVP1/UGYMnbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sz/T9B1TXuykJh+yS7WOWhA+SUtfCQNlPrdz8OC/B/jtblWEY1qhw41xuzpVPfaFLDGU+UhwJoURf+MPlCDpeu1109zIE6pm4kXDeywidvySrAVGE4bPXLg7hRwEMh0QeOLP0A9LMV6VdnYXAvhD7xZJZvJXLf4Ab6+BAAEVmA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=li7ZkqIV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="li7ZkqIV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC7DC1F000FF;
	Sat, 12 Sep 2026 08:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203328;
	bh=IRo8YXXax8jRu9Oq+1XelXPT4yZUN58QGGJwJ0w6gW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=li7ZkqIVjlxAqGFJ+mSeap8/pM4I8eOUH0cPs1FF/RJ7kgUHZjRX60GVWC5hOjR7X
	 5G8CYmTLGcWGHQfz6FBqpbuvL2VxOEkUJVGkpav8rvXL6eYfjN5zkT3AyJ+NAWTqTE
	 DQTgJxdbhAnjDu7Ang9xnwBy7U3QQdj41k3rsuZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1387/1815] firewire: core: consolidate port counting in build_tree()
Date: Sat, 12 Sep 2026 08:52:17 +0200
Message-ID: <20260912065721.586964737@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

[ Upstream commit 87c48e54f28d410af0c12b5dd339307bb43abeea ]

The self ID sequence describes the state of each port for each PHY.
Currently, build_tree() counts the ports in two separate places.

Consolidate the port counting in one place.

Link: https://lore.kernel.org/r/20260811120928.700577-2-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Stable-dep-of: 05bfb1327dc5 ("firewire: core: fix memory leak in error path of build_tree()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firewire/core-topology.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/firewire/core-topology.c b/drivers/firewire/core-topology.c
index 1d3a4419f5547..4f610205576c3 100644
--- a/drivers/firewire/core-topology.c
+++ b/drivers/firewire/core-topology.c
@@ -119,8 +119,8 @@ static struct fw_node *build_tree(struct fw_card *card, const u32 *sid, int self
 
 	while (enumerator.quadlet_count > 0) {
 		unsigned int child_port_count = 0;
+		unsigned int parent_port_count = 0;
 		unsigned int total_port_count = 0;
-		unsigned int parent_count = 0;
 		unsigned int quadlet_count;
 		const u32 *self_id_sequence;
 		unsigned int port_capacity;
@@ -148,16 +148,19 @@ static struct fw_node *build_tree(struct fw_card *card, const u32 *sid, int self
 			switch (port_status) {
 			case PHY_PACKET_SELF_ID_PORT_STATUS_CHILD:
 				++child_port_count;
-				fallthrough;
+				break;
 			case PHY_PACKET_SELF_ID_PORT_STATUS_PARENT:
+				++parent_port_count;
+				break;
 			case PHY_PACKET_SELF_ID_PORT_STATUS_NCONN:
 				++total_port_count;
-				fallthrough;
+				break;
 			case PHY_PACKET_SELF_ID_PORT_STATUS_NONE:
 			default:
 				break;
 			}
 		}
+		total_port_count += child_port_count + parent_port_count;
 
 		if (phy_id != phy_packet_self_id_get_phy_id(self_id_sequence[0])) {
 			fw_err(card, "PHY ID mismatch in self ID: %d != %d\n",
@@ -203,7 +206,6 @@ static struct fw_node *build_tree(struct fw_card *card, const u32 *sid, int self
 				// we temporarily abuse node->color for remembering the entry in
 				// the node->ports array where the parent node should be.  Later,
 				// when we handle the parent node, we fix up the reference.
-				++parent_count;
 				node->color = port_index;
 				break;
 
@@ -223,10 +225,10 @@ static struct fw_node *build_tree(struct fw_card *card, const u32 *sid, int self
 
 		// Check that the node reports exactly one parent port, except for the root, which
 		// of course should have no parents.
-		if ((enumerator.quadlet_count == 0 && parent_count != 0) ||
-		    (enumerator.quadlet_count > 0 && parent_count != 1)) {
+		if ((enumerator.quadlet_count == 0 && parent_port_count != 0) ||
+		    (enumerator.quadlet_count > 0 && parent_port_count != 1)) {
 			fw_err(card, "parent port inconsistency for node %d: "
-			       "parent_count=%d\n", phy_id, parent_count);
+			       "parent_count=%d\n", phy_id, parent_port_count);
 			return NULL;
 		}
 
@@ -235,7 +237,7 @@ static struct fw_node *build_tree(struct fw_card *card, const u32 *sid, int self
 		list_add_tail(&node->link, &stack);
 		stack_depth += 1 - child_port_count;
 
-		if (node->phy_speed == SCODE_BETA && parent_count + child_port_count > 1)
+		if (node->phy_speed == SCODE_BETA && parent_port_count + child_port_count > 1)
 			beta_repeaters_present = true;
 
 		// If PHYs report different gap counts, set an invalid count which will force a gap
-- 
2.53.0



