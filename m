Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6126305E08;
	Tue, 12 Aug 2025 18:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022285; cv=none; b=AcjAQ9W35DQoUOYK4lmtF319+HtD5PaSKs+g7BaWDd4VtBR96gfZsawPeLcm6/FLlBP74CisYjGd3cAyR6OO5pQbQylrll6TKVhYy4a5tL57yy0aI5/egPgG0XX+BY9+oQk1Qhe5u9/jxwndixSImlY+dQhsVzveyZH11N/DUhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022285; c=relaxed/simple;
	bh=qrNBCVYu3XyLwbzHB3rHaSuxbR+K9f6NwnlgeM6DhLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nifBHzWv1GVh72EyW3+F2TbnNTOw8f4L1wJb9Nf2DH84vuDLN24tUe8QHkCpThlj9tH8lnm2poB6NQhtf3CAACDwV26iNmA52yqP/cp09wfYleSJ9fOk7pBqysxtQRGxWJED+cv/jv6PKf+YRjnrqKLkTAulrcL35oICUDTHqsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gXPBn07L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gXPBn07L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56F32C4CEF7;
	Tue, 12 Aug 2025 18:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022285;
	bh=qrNBCVYu3XyLwbzHB3rHaSuxbR+K9f6NwnlgeM6DhLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gXPBn07LKhIHSVo+2hGvjKdtytbUOLnc6/5wl/UJpC0nd3FSZsqFr/p8oj7cgIJw1
	 u/R7XcSmE4JiHHRP6tpX6nFhy/eh7SnKEz35eXXhqaha2Y3hpm2U48aH6QO0zn5Z2K
	 BYnD7NiDUJ68dJBsT/io2K33pfyVPaTQ+URza95A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 111/369] mwl8k: Add missing check after DMA map
Date: Tue, 12 Aug 2025 19:26:48 +0200
Message-ID: <20250812173018.949071160@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



