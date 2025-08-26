Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28FF828314A;
	Tue, 26 Aug 2025 14:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217351; cv=none; b=rlYKOMK+8pPZYEhjzr+zHYr+M+tQ0zipjKG81/6IE6LSBJrTnQbDhLHgmbNF1GmtiGBEgnEf8UnwRDz3DGJTWYYmcaqi2Y+yy9HXAg/Kw0SsqJoMqVrbSLWUaGRZZNXUmejjCK1ZDY8BFzDT96Nkx+L+PPrg+Mak/15M5rwdBwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217351; c=relaxed/simple;
	bh=GOp7LLBn1qOmXLU4Ett6weoCZnjkWf1Xleva05YXOHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iQY8MCNEOMdd2Mp7fjIB7RFkRYuMt3bcAZh0XOIw5YSoU3rt24HAAnREE0uBP1UmcdbCvXgws8PBMvJ9A0tiITCk3VXcNDOxkxrgUQI9Y/96Goj1ORfkEHvbJevEble92CtZIE52rlCVw4427trFjERkHpmcExuN9y3ibH9jM0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FwM4dvLO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FwM4dvLO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B074AC113CF;
	Tue, 26 Aug 2025 14:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217351;
	bh=GOp7LLBn1qOmXLU4Ett6weoCZnjkWf1Xleva05YXOHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FwM4dvLOItsRIAMvPpL2+p3cW3m3nz9vP0g1UUzuVt80cWyruDHlzN3IO6UAUTNl+
	 yEL36hO29vQZ/bMzO2VVBS+AGdWpJjjVWFtrN6uSSB6r5gsRZIO/OO9ihmYrOUhRUQ
	 MBPKmoHN7Vbi2Y6z+6Jm1VwH+8mUD07XqwX2J3Ts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 111/523] mwl8k: Add missing check after DMA map
Date: Tue, 26 Aug 2025 13:05:21 +0200
Message-ID: <20250826110927.264993100@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index dd72e9f8b407..194087e6a764 100644
--- a/drivers/net/wireless/marvell/mwl8k.c
+++ b/drivers/net/wireless/marvell/mwl8k.c
@@ -1220,6 +1220,10 @@ static int rxq_refill(struct ieee80211_hw *hw, int index, int limit)
 
 		addr = pci_map_single(priv->pdev, skb->data,
 				      MWL8K_RX_MAXSZ, DMA_FROM_DEVICE);
+		if (dma_mapping_error(&priv->pdev->dev, addr)) {
+			kfree_skb(skb);
+			break;
+		}
 
 		rxq->rxd_count++;
 		rx = rxq->tail++;
-- 
2.39.5



