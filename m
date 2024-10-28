Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4984818E05D;
	Mon, 28 Oct 2024 06:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098426; cv=none; b=VPezRiLivljHp11jD8gf85p36mC4kPVIrIIhyVZcHn4WcbnI21zBtl+6/Yq6L9pZEtAyy3uYkz2eV5HIx1UKDAZd4tDOMXMfE4hUhjzAQD/W4xHprPozp5hwGv+7dz4z4xH0KK8vsdKViujM7vEWUJnJhziOFAIWmUdPt9TUMi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098426; c=relaxed/simple;
	bh=6KJF4MLEvWJP+Mv/ttjtipYkQPKyCvmpKiwBsUXINSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NgB7rjLJkM4nRN8hS1VuKQ8RFkqCVXoSHSP6mLXb4jEo7+ryV69bBFJAH4jrVmqP430jxg12x580Pb1/pc6Q3rBKoLI0HnqJ9LomD5NudDeMOaGHuepRm1+PjJMx1RpNb3HN4/cxBHb1hBCPcQZygJl1GqY4HTUdFjBPiyQtxBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XW25Ehsf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XW25Ehsf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAE57C4CEC3;
	Mon, 28 Oct 2024 06:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098426;
	bh=6KJF4MLEvWJP+Mv/ttjtipYkQPKyCvmpKiwBsUXINSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XW25Ehsf6BmGlgDnbdEswQo4peEM6qWRLit8kAJd7CnBknhsjtuLM5IEzu55QIIEy
	 odgpVBkCqBR1FA4n/CKnxKPRHyNhCeqmWYhoVLg4ov8WqT5MGvTrE5wGc2A2XzaF4k
	 hbyjywuCJxa1yNXQPn0mZjWuRLILCesEKO//6R6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edmund Raile <edmund.raile@proton.me>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>
Subject: [PATCH 6.11 222/261] firewire: core: fix invalid port index for parent device
Date: Mon, 28 Oct 2024 07:26:04 +0100
Message-ID: <20241028062317.672640429@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

commit f6a6780e0b9bbcf311a727afed06fee533a5e957 upstream.

In a commit 24b7f8e5cd65 ("firewire: core: use helper functions for self
ID sequence"), the enumeration over self ID sequence was refactored with
some helper functions with KUnit tests. These helper functions are
guaranteed to work expectedly by the KUnit tests, however their application
includes a mistake to assign invalid value to the index of port connected
to parent device.

This bug affects the case that any extra node devices which has three or
more ports are connected to 1394 OHCI controller. In the case, the path
to update the tree cache could hits WARN_ON(), and gets general protection
fault due to the access to invalid address computed by the invalid value.

This commit fixes the bug to assign correct port index.

Cc: stable@vger.kernel.org
Reported-by: Edmund Raile <edmund.raile@proton.me>
Closes: https://lore.kernel.org/lkml/8a9902a4ece9329af1e1e42f5fea76861f0bf0e8.camel@proton.me/
Fixes: 24b7f8e5cd65 ("firewire: core: use helper functions for self ID sequence")
Link: https://lore.kernel.org/r/20241025034137.99317-1-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firewire/core-topology.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firewire/core-topology.c b/drivers/firewire/core-topology.c
index 6adadb11962e..892b94cfd626 100644
--- a/drivers/firewire/core-topology.c
+++ b/drivers/firewire/core-topology.c
@@ -204,7 +204,7 @@ static struct fw_node *build_tree(struct fw_card *card, const u32 *sid, int self
 				// the node->ports array where the parent node should be.  Later,
 				// when we handle the parent node, we fix up the reference.
 				++parent_count;
-				node->color = i;
+				node->color = port_index;
 				break;
 
 			case PHY_PACKET_SELF_ID_PORT_STATUS_CHILD:
-- 
2.47.0



