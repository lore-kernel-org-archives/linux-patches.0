Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCABB26FA77;
	Tue, 12 Aug 2025 19:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025857; cv=none; b=mLlwo2r1JMUKZvtdSbJq+2YwiFImNtBF4+KMEy5DfM6cWqQ2yPuuoy7BLSMZJqmnNFvaf4IwuGRqgNRIIPAR8lTiTjDQHe5UVYKiWezveH2r8hS5u3lCgkoGbilXnduy7x/kBZjdjaeYWi9IYcduWSjgrw6si0S5n+tuw7VBaM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025857; c=relaxed/simple;
	bh=/r/lGfe3vyWVhHVNVOEEmBDBq33yuZwsfCheAfwDThk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jfq/WQY4oDsVGl/v2ivIWwSB4+IP/tT60huz7kz3x4cRSo7YpEMaKhH2W2/H/A3IiIZfbVZhTaloN0QzkQo3j1DruguTSl86xnI619RBBhORKjTjlhr33bVXQmMFSJO3RDW9L8TTr4BJvgtZZl/IELxye7jTRKesuK4ElIuJXfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OZkTw/BB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OZkTw/BB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67B6EC4CEF0;
	Tue, 12 Aug 2025 19:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025856;
	bh=/r/lGfe3vyWVhHVNVOEEmBDBq33yuZwsfCheAfwDThk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OZkTw/BBr5iaFLToblar/d6wnHgbf60EcuEpHu6rChWJGyQxxNFxvM68qhfNQCa/Q
	 iuvAinjUrgLw59VW4Ezpq2GcuNUSiSjlobvH25qr+MZgpzVubZIy74ZignTovJr4hO
	 4O8OQUsxoCSo/5y+cHXUN6KEnxyq5N6oE6Hp+SXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 165/480] mwl8k: Add missing check after DMA map
Date: Tue, 12 Aug 2025 19:46:13 +0200
Message-ID: <20250812174404.331134852@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit 50459501b9a212dbe7a673727589ee105a8a9954 ]

The DMA map functions can fail and should be tested for errors.
If the mapping fails, unmap and return an error.

Fixes: 788838ebe8a4 ("mwl8k: use pci_unmap_addr{,set}() to keep track of unmap addresses on rx")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Link: https://patch.msgid.link/20250709111339.25360-2-fourier.thomas@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwl8k.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwl8k.c b/drivers/net/wireless/marvell/mwl8k.c
index bab9ef37a1ab..8bcb1d0dd618 100644
--- a/drivers/net/wireless/marvell/mwl8k.c
+++ b/drivers/net/wireless/marvell/mwl8k.c
@@ -1227,6 +1227,10 @@ static int rxq_refill(struct ieee80211_hw *hw, int index, int limit)
 
 		addr = dma_map_single(&priv->pdev->dev, skb->data,
 				      MWL8K_RX_MAXSZ, DMA_FROM_DEVICE);
+		if (dma_mapping_error(&priv->pdev->dev, addr)) {
+			kfree_skb(skb);
+			break;
+		}
 
 		rxq->rxd_count++;
 		rx = rxq->tail++;
-- 
2.39.5



