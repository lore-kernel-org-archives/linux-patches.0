Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6C92F5E;
	Tue, 12 Aug 2025 18:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023933; cv=none; b=VAi8Zee23xdo4p/Y3jzSHPkErHq0qvQSj8y1HEgYAbqXJzzjVMbkRcjD/7BIMYixVDH/sSd5Hu7m5YN8zB3OyZtq0B6lCq0Qq7XX+hVWBId1PBxVKGdMBVrh/DYEk4Dcfc9cZjghEo0vGqnabugecytg9M4lYBV8mBfXY37SKfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023933; c=relaxed/simple;
	bh=YE3yw4EIoyTcdC+E0xmwRky0vW6SU0BUyC89B5DVFq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D5P25TblPBe8WXmyQfVQZ7HQXIwBrEjaNSt7L6aovdVheAYfexA02BtrKS/mWqYbXlaCA8NL6zPggs+PiP/33EUBzBOxkHjnZjRs2POlsjW2rWBLJQtZNyhPaDddWEPSSmm5E+MUWIudG7x+Ha8IpYvq3AHTxlCBKuQ9mEzkioc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hauMIR+2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hauMIR+2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6413C4CEF0;
	Tue, 12 Aug 2025 18:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023933;
	bh=YE3yw4EIoyTcdC+E0xmwRky0vW6SU0BUyC89B5DVFq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hauMIR+25zccLzbTGFMBz5KFqJpx1J+ayK6+AwVmXdP6tlpVUJT0sGnAh06tnjrXb
	 VG7JFz4i2Qg0mIEM0mnK8RILT7MC/tvsWU8zNSOvnhCWCNCT9yvd3KfhcYE3uxhYom
	 Uvpuwy7FX6vQp1+GoMG4EfVzB7NnBOIEAS0RyDXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 224/627] mwl8k: Add missing check after DMA map
Date: Tue, 12 Aug 2025 19:28:39 +0200
Message-ID: <20250812173427.808516077@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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



