Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B67225A38;
	Wed, 20 May 2026 17:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299696; cv=none; b=puIXVDGwCYInLkTzHFqr1i2qLy//sf5Q6XCjTNoVFs6OeLHqgkLz7Rs9HfBSAd9i4ano8l/OOEbkwRZ0fL7uaE+CTMMYoTsd5MHJDVS6RR+yczeo9Cv92Xr4Th0w8pqTg/2FORR0k5SB/tc27eJ44MuV656I0KBLX3310b6xV08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299696; c=relaxed/simple;
	bh=V9bo2rk10RjskXJUoVC4nBWMESb5397CUYd28ckbo7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XmZIBhB38NReZt4VOIfPJz2lvpGCx2Xdm/FLxpenM6rKc+Zt3JliLc7Do+eVyFs4hu4ZkMOoR1IM+LzJRmeaiM00kjgC6B5odiCJNQbZ36PNi3gjNSKGMpHyQ3l5oeILd7p84vh2iZx/5AAMjmqYL+FtzH7bFw/qVAMOGsgXUOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CLuoEfH1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CLuoEfH1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6DCA1F000E9;
	Wed, 20 May 2026 17:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299695;
	bh=YA3+Sb7oCC5I0iU7nujUEknix5jVwsDdXmkEAbZIcuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CLuoEfH1GXk2CbIOYQRoj8NEeOuI6wF9WVGXnrmO36PUY4aoeaIxzHOpNBy78EQgF
	 MYnpcWGTDB7eMysn5mBEAMuEMpNLdeXNuZ580LZ98tCdryrKahMQkhcwBZedbV89Cx
	 2PfhPr6jG4nzNpCWId94YyK3goeyyOSRxxWglbTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 869/957] net: airoha: Move entries to queue head in case of DMA mapping failure in airoha_dev_xmit()
Date: Wed, 20 May 2026 18:22:32 +0200
Message-ID: <20260520162153.412432934@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 75df490c9e8457990c8b227650f6491218ce018b ]

In order to respect the original descriptor order and avoid any
potential IOMMU fault or memory corruption, move pending queue entries
to the head of hw queue tx_list if the DMA mapping of current inflight
packet fails in airoha_dev_xmit routine.

Fixes: 3f47e67dff1f7 ("net: airoha: Add the capability to consume out-of-order DMA tx descriptors")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260429-airoha-xmit-unmap-error-path-v2-1-32e43b7c6d25@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_eth.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/airoha/airoha_eth.c b/drivers/net/ethernet/airoha/airoha_eth.c
index 4364f4320428a..b4dfab2702cb9 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -2136,14 +2136,12 @@ static netdev_tx_t airoha_dev_xmit(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 
 error_unmap:
-	while (!list_empty(&tx_list)) {
-		e = list_first_entry(&tx_list, struct airoha_queue_entry,
-				     list);
+	list_for_each_entry(e, &tx_list, list) {
 		dma_unmap_single(dev->dev.parent, e->dma_addr, e->dma_len,
 				 DMA_TO_DEVICE);
 		e->dma_addr = 0;
-		list_move_tail(&e->list, &q->tx_list);
 	}
+	list_splice(&tx_list, &q->tx_list);
 
 	spin_unlock_bh(&q->lock);
 error:
-- 
2.53.0



