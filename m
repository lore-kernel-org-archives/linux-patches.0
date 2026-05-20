Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F243940242E;
	Wed, 20 May 2026 18:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302908; cv=none; b=pNwq7hgBg9TCitkVUDTVhLPwfVmkK1FaZTqfVkAkPaEOLHvOHRoUjHeT2eXydnUDFbxrfvInd7+rkhgiBIhchlf2HlmjbBPeMko2eY3iZHhaJ0uhQPDkfrB7lqn6N9wzcivTrF4QYi9W9xWEUv/6518mPLu5CZ5RiM/GNO08xu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302908; c=relaxed/simple;
	bh=AFh+sKIlYb4n4OPYS5xjNwOnD9v9GlALIAgG1nLPnJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jLgoU47eT+GyF+TAR/0MkmNFv7g8HWzKCrmh10CK/jFRFWzt12fcOelrKejacmuXCQTVMxJ1Per0eRO3tCqn3wvHYpllp0tD+PP7mjJKDXT8o1fa0Xap9DGnt1hB1lzSbYLp6/SE5zpYXkp7g5aAswuOY5mYyyV3IiRcwO0iuNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PUt7diFb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PUt7diFb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E87561F000E9;
	Wed, 20 May 2026 18:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302906;
	bh=kikeiQsGhG39IJf+2QHitzPeSezdq8cvkNZhZC+j0cI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PUt7diFb4twN+lpRHtjDozBSoNyRXRyOHApFLyRwoUDWwF+vWmBqAIQo6ctEUkC4e
	 X9xd8AaoUWfGkd7LhMr65mySvXjKwiW7AiZuhGQa1YpUSUG7bY3KGLBjhNENqysaGa
	 rGYR8Ttuj7n+vjK2g+6CyceBHTA4UFwiXUe0Zoqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 446/508] net: bcmgenet: fix leaking free_bds
Date: Wed, 20 May 2026 18:24:29 +0200
Message-ID: <20260520162108.262101640@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

From: Justin Chen <justin.chen@broadcom.com>

[ Upstream commit 3f3168300efb839028328d720ab3962f91d6a0d0 ]

While reclaiming the tx queue we fast forward the write pointer to
drop any data in flight. These dropped frames are not added back
to the pool of free bds. We also need to tell the netdev that we
are dropping said data.

Fixes: f1bacae8b655 ("net: bcmgenet: support reclaiming unsent Tx packets")
Signed-off-by: Justin Chen <justin.chen@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Tested-by: Nicolai Buchwitz <nb@tipi-net.de>
Link: https://patch.msgid.link/20260406175756.134567-3-justin.chen@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index d9bd011e0d7c8..d1f5ae56fa417 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1942,6 +1942,7 @@ static unsigned int bcmgenet_tx_reclaim(struct net_device *dev,
 		drop = (ring->prod_index - ring->c_index) & DMA_C_INDEX_MASK;
 		released += drop;
 		ring->prod_index = ring->c_index & DMA_C_INDEX_MASK;
+		ring->free_bds += drop;
 		while (drop--) {
 			cb_ptr = bcmgenet_put_txcb(priv, ring);
 			skb = cb_ptr->skb;
@@ -1953,6 +1954,7 @@ static unsigned int bcmgenet_tx_reclaim(struct net_device *dev,
 		}
 		if (skb)
 			dev_consume_skb_any(skb);
+		netdev_tx_reset_queue(netdev_get_tx_queue(dev, ring->index));
 		bcmgenet_tdma_ring_writel(priv, ring->index,
 					  ring->prod_index, TDMA_PROD_INDEX);
 		wr_ptr = ring->write_ptr * WORDS_PER_BD(priv);
-- 
2.53.0



