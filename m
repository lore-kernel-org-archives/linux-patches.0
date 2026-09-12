Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DCCD369990;
	Sat, 12 Sep 2026 08:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203334; cv=none; b=GOnedtn3rvhjcr6d/r3X9JA4mdzHPLo1SEWXj+ZdY+/ymErW2SaGS42+Ny2KXbt/8JLWdpA2X3Gs8aWaxXkCbuZLAi7aQXRhbWxtLl4M3bahuGygPBzLZKAA31fVTe7pwoxDoEDXMbiJOHvW3c9nT9v/Y8UYmc0aoECP6CpraCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203334; c=relaxed/simple;
	bh=A+pRsjOZG8+pFSzmDKet9U1CgGEffqQZFuRC/zriTNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M1d4Ns8DHLvH13hnXfbUoevZYEOYGz5Spx59QYjbeEOKa01dcoS+6Ogk3dVKlWY9cImcYeAb1QUvwV9A+gUJr8EddLrtRjW+w8lC728ddDmID0EznbuODoKoMSiIKfBAQxAIeMlQ/T79DchBcQTo5b039qKulIJJmSc5VKDh5SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=En/TaCzN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="En/TaCzN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1772C1F000FF;
	Sat, 12 Sep 2026 08:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203333;
	bh=IT5t+pBZWbjSH3g9Ka1LVB5y1RPwQN1/0dEbbrndgsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=En/TaCzNFMgbrSI63Bm9oxcTeEcVmbJA7vmvpUmLgPUOyUPfVVbRJhc1NROmeCnmv
	 rexymepcPnb6tN1No3vicbGnOlx1CVJsBm2QtIXny8sSU3jDabSX9il071/Ry+wFcl
	 npuTizVAZeElTxjaZ0mUyPwya/wY3gJ7ycrHFhXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1388/1815] firewire: core: validate parent port count before allocating nodes in build_tree()
Date: Sat, 12 Sep 2026 08:52:18 +0200
Message-ID: <20260912065721.609684870@linuxfoundation.org>
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

[ Upstream commit a563a7cb645a79a3a7e31bed8cbf95980ef5feb1 ]

The node tree requires each child node to have exactly one port connected
to a parent node, while the root node must have no such port. This can be
validated by comparing the parent port count for a PHY with the rest of
the self ID sequence.

Currently, this validation is done after the node has been allocated. Move
it before the allocation so that an invalid self ID sequence can cause
an error without having to clean up the newly allocated node.

Link: https://lore.kernel.org/r/20260811120928.700577-3-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Stable-dep-of: 05bfb1327dc5 ("firewire: core: fix memory leak in error path of build_tree()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firewire/core-topology.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/firewire/core-topology.c b/drivers/firewire/core-topology.c
index 4f610205576c3..e032497b25940 100644
--- a/drivers/firewire/core-topology.c
+++ b/drivers/firewire/core-topology.c
@@ -162,6 +162,15 @@ static struct fw_node *build_tree(struct fw_card *card, const u32 *sid, int self
 		}
 		total_port_count += child_port_count + parent_port_count;
 
+		// Check that the node reports exactly one parent port, except for the root, which
+		// of course should have no parents.
+		if ((enumerator.quadlet_count == 0 && parent_port_count != 0) ||
+		    (enumerator.quadlet_count > 0 && parent_port_count != 1)) {
+			fw_err(card, "parent port inconsistency for node %d: parent_count=%d\n",
+			       phy_id, parent_port_count);
+			return NULL;
+		}
+
 		if (phy_id != phy_packet_self_id_get_phy_id(self_id_sequence[0])) {
 			fw_err(card, "PHY ID mismatch in self ID: %d != %d\n",
 			       phy_id, phy_packet_self_id_get_phy_id(self_id_sequence[0]));
@@ -223,15 +232,6 @@ static struct fw_node *build_tree(struct fw_card *card, const u32 *sid, int self
 			}
 		}
 
-		// Check that the node reports exactly one parent port, except for the root, which
-		// of course should have no parents.
-		if ((enumerator.quadlet_count == 0 && parent_port_count != 0) ||
-		    (enumerator.quadlet_count > 0 && parent_port_count != 1)) {
-			fw_err(card, "parent port inconsistency for node %d: "
-			       "parent_count=%d\n", phy_id, parent_port_count);
-			return NULL;
-		}
-
 		/* Pop the child nodes off the stack and push the new node. */
 		__list_del(h->prev, &stack);
 		list_add_tail(&node->link, &stack);
-- 
2.53.0



