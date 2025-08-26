Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3717024DD11;
	Tue, 26 Aug 2025 13:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215763; cv=none; b=dVRSYPbvm1E7NbJM+AsCiMKMps/R2HHt2nmeYQ6lCvAs+gzMbeCdjNPSYqj93LdZPgCbnoEeVwl/6qHaNY/rMKj1x24vaOwGH3GI15asMJezT+uS7lAevZUi6FrIvDVS5Nzfif2v8romPN9BL2pMh5lyc8hcdL+3PdZgYgklIV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215763; c=relaxed/simple;
	bh=cg+zPy7KZj78hAV1DGCOLLa1Wf+A63kjtGPrm+Ctq/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qWWz8UO/8nZNZ+GXcjPLsctORSKAej24tHRLQHsX1OpwF63coZzX8vCq97x6aCLsv8lUofyx+CPe6BSWXGZ5ag3iiUYgrPZGnmWsgl9/MxofbaILYE4IIZi5QETHI/JlkSynunWQBR3vhwRwYr9ff1w5oOwdVU78qBoyyNQ4D9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LUokh3rX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LUokh3rX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E16AC4CEF1;
	Tue, 26 Aug 2025 13:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215762;
	bh=cg+zPy7KZj78hAV1DGCOLLa1Wf+A63kjtGPrm+Ctq/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LUokh3rXqxlBiNAeqM4iYt2Nfo2jx/u5O3k+6SedNaKSJiqrLPPOkzzuuhdHqs3B0
	 XoZXf9B5v5NPe8UjMH5nv4rtuRE2e3YIhpGS0+3GEIet3arfFFaT44bnzqqQg2RVnp
	 f/r5MKlEX0U+smf/bfa0tNsssAiPg5FCprFGWsQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 155/644] mwl8k: Add missing check after DMA map
Date: Tue, 26 Aug 2025 13:04:06 +0200
Message-ID: <20250826110950.321781127@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ad9678186c58..6cef5a0d6a6e 100644
--- a/drivers/net/wireless/marvell/mwl8k.c
+++ b/drivers/net/wireless/marvell/mwl8k.c
@@ -1222,6 +1222,10 @@ static int rxq_refill(struct ieee80211_hw *hw, int index, int limit)
 
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



