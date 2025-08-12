Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A3F86331;
	Tue, 12 Aug 2025 17:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020576; cv=none; b=PlKJETt65NAB5UtZ2O6y2jjN6bpK6Kr8EOIzHyrX4CAVCdjXSCQnY5N0pAHzC+BBywIjiGVTp4J/npnHnz17jz+3FMhCeDdivjPiPgN9574CNVHo97jS8cy56yWaydz8J7iE4ybDPARvSydiD3Lk7G0Pa5rrWjYvNjpZsn0tAnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020576; c=relaxed/simple;
	bh=sqE9alErCFiyPduyPhwGLWbAHybBc941uQZ+DuqzKsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BCo14tG6ptVB+BTVyRBC4JYvStf+Mplr4lX7m78qPhet5vsiqXNjWHNJd8a151ch9czZ9xHFvnbctp4s91H8oh/Bh7C19R3B6i2qAbb0nhHz66bwvKAjMFqRWwOeoI5sL2uuE0sNHCLIqCxL/aBWK52TWrf1UaHjH0wfFdxSXQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nAK+6mgV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nAK+6mgV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A59C3C4CEF0;
	Tue, 12 Aug 2025 17:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020576;
	bh=sqE9alErCFiyPduyPhwGLWbAHybBc941uQZ+DuqzKsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nAK+6mgVwxl+gNWJ7R5MFlsvvLj0pfGojXhOwo4UzmvrWpO1jDX2qJPaUtgXY9NRG
	 fXJNsYl3/lzCS0gyrTHeXRQExvwui/u/r+h7BsXJDr4EtL7gUQqE9arsnDTvcZOHrm
	 C87Y55D8ux+EFaKtjys6nA6J26CR400n+UoBGlx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 120/253] mwl8k: Add missing check after DMA map
Date: Tue, 12 Aug 2025 19:28:28 +0200
Message-ID: <20250812172953.811787531@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 61697dad4ea6..cc3a9543d255 100644
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



