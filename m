Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2772356744;
	Sat, 12 Sep 2026 11:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211259; cv=none; b=eEPzhBGbvziB3VcL+Ae4CIAXAWKwPDdK04hgxzZT3aYYQvVhjaslKrAWyzjqvxtwegEbBEWSllNKSGxmSWxy7hNDqTV5ZSQ0d/tHqFmhr7yxPNjMzqykViDhjfDraow/vfNZdRVkq4clVlPBQxDh8KuKnRe/BWr8kpDZPIAqWZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211259; c=relaxed/simple;
	bh=Bz4Q8FOZNzjKQ0i4WqnRhGlPrZYS2YJ705Fch4tTdDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bz5JUMQ5I0WVonMIz3ASeRdC2fxdMRcW1p/3PMwx4J+IfxQjUPmpoh9Jkk02eesEwfv21ZFZz9obdtkCt88111uG6I7oVCAKFTbTx/qQnKD1G5jLAHhdK5aK7K8mlgLERjnhM5r/HOMqFq9aqDUOEDRgCiPwqQh+x88HWhs/xTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VhuehWez; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VhuehWez"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A68F91F000FF;
	Sat, 12 Sep 2026 11:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211257;
	bh=gShCANCoMigpCzgZR6n/RyFPw9D67NOfQ54eWVdSUFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VhuehWezS9FSEfhrWGatpbE3RvCFQT6zygCOanmxCZlFFDHDgO9QU0KrCVdsdeX26
	 islOP7iBaHz088STCIqro6HEasXJv6ZGHS0RgTGp9mitm+w5Dc60oPQsMEZ1m5NiPp
	 7H0bsvMepFnjc8AdVU6rNBe6ihEfZyr7oZCLLl/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1152/1518] firewire: core: consolidate port counting in build_tree()
Date: Sat, 12 Sep 2026 08:55:21 +0200
Message-ID: <20260912065649.515763317@linuxfoundation.org>
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
index 45c71327c3c3d..065882b4cf5af 100644
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



