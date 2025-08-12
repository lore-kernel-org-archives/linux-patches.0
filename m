Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429DE2D5C76;
	Tue, 12 Aug 2025 17:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021224; cv=none; b=SuDY+CxT5o3aqozdpsx7pY8I1fSokmnded2OQLAmq1maD5bEt/2O/vTCO58rSKa4Q4VwNrZxvcJNLnX2AXJu6TH8pyCQVQVfvBJ3s8TsQzC4NU7lMmLSP5CivQGeOtWWaas+dLDbCe8hgFtD0TipNHEILoseFGf2a5bDR6hAO28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021224; c=relaxed/simple;
	bh=CjVcq/7BLyr8V7SYoLNyWah10t0e3F0yJi7wUdvF12k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jqiJzlPjUAfef39wg713UzcuR6R37UuULdPdDA7NtJlI7sBwbTI9aBHZ9h9b+Uxr+1XJNjYQdjkAIvXrmPaqTibAS/AKJmZbqXyQXuF66L4RifKzHbK0kK5JUA9Ef9zRKpZNR1c6TmOMW9VmIcqGa+axtFpnN40ua+w+2wVe2PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fKykvr98; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fKykvr98"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4218AC4CEF0;
	Tue, 12 Aug 2025 17:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021223;
	bh=CjVcq/7BLyr8V7SYoLNyWah10t0e3F0yJi7wUdvF12k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fKykvr98FXWzfRQp5KHktHWUwfyqR5UPWCViJ7v7bhCnj/xEXsYNi6VjcLJ22GynQ
	 vdnDwo9vT9j5qeSTj0uhS2h3/56IWwW8EqGZpcLAUrSUc3NWmhX0Fh/rlxHvuIN/Hq
	 cQrPZQ0o59luMZNI8iKv6NsxFDF54WhpXk9lTGLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 080/262] mwl8k: Add missing check after DMA map
Date: Tue, 12 Aug 2025 19:27:48 +0200
Message-ID: <20250812172956.450587636@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c0ecd769ada7..1a48914e6f82 100644
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



