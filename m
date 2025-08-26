Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E3BF1F790F;
	Tue, 26 Aug 2025 14:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217761; cv=none; b=WpPtbS4NFpEaylZpsw/L1xREM4DbbnWUVokZHBnEiYSs08xFCCm9JFM+BmERrsbe3zor1b639dUpciNsjrY51F9BKkTqdEeJtN8Of8XSBW7Y9B83ojXOAsuZKnlJm9suQtJd3ct7TeSb1WVS203fvh2OV1KudzS+n0GBGdkXo78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217761; c=relaxed/simple;
	bh=sku0xpQ2kLYHVQEzTnYNXfqFJxA/d9EIakUs/sInojc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YFchzf43H9+pm6xIiXVDJsUschRj1oNgTV+oEaNQy76hFgoaQEO9g5Qy8j1jV36RYnKTUGQkxYr8X7cklB5G/TLg8oepUSNVmbs960RSTOMy0axeUhggLpb1oCkDg97zxT/7+t06HpmY1B7Vu9A1CbBa8f+sJ64L258aQotHGoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U09Y5LOh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U09Y5LOh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E098C4CEF1;
	Tue, 26 Aug 2025 14:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217761;
	bh=sku0xpQ2kLYHVQEzTnYNXfqFJxA/d9EIakUs/sInojc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U09Y5LOhk7v9pR6dblfG+MW7vurcViCqzkpueumMgIPv4gF3pE+MMxP5XyoJ9CxpZ
	 RHCqPiU3saczS7CvQTBd92XegPAlCxfPCUv3K26Rp+Ahq1LMocmonutmlLSgtpJO4q
	 xpJOXH4IpnbwkSV6JfrGb+eoQuXkUBJBYzJtcEBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Mark Einon <mark.einon@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 263/523] et131x: Add missing check after DMA map
Date: Tue, 26 Aug 2025 13:07:53 +0200
Message-ID: <20250826110930.913414703@linuxfoundation.org>
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

[ Upstream commit d61f6cb6f6ef3c70d2ccc0d9c85c508cb8017da9 ]

The DMA map functions can fail and should be tested for errors.
If the mapping fails, unmap and return an error.

Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Acked-by: Mark Einon <mark.einon@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250716094733.28734-2-fourier.thomas@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/agere/et131x.c | 36 +++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/net/ethernet/agere/et131x.c b/drivers/net/ethernet/agere/et131x.c
index 41f8821f792d..fa04e37de089 100644
--- a/drivers/net/ethernet/agere/et131x.c
+++ b/drivers/net/ethernet/agere/et131x.c
@@ -2460,6 +2460,10 @@ static int nic_send_packet(struct et131x_adapter *adapter, struct tcb *tcb)
 							  skb->data,
 							  skb_headlen(skb),
 							  DMA_TO_DEVICE);
+				if (dma_mapping_error(&adapter->pdev->dev,
+						      dma_addr))
+					return -ENOMEM;
+
 				desc[frag].addr_lo = lower_32_bits(dma_addr);
 				desc[frag].addr_hi = upper_32_bits(dma_addr);
 				frag++;
@@ -2469,6 +2473,10 @@ static int nic_send_packet(struct et131x_adapter *adapter, struct tcb *tcb)
 							  skb->data,
 							  skb_headlen(skb) / 2,
 							  DMA_TO_DEVICE);
+				if (dma_mapping_error(&adapter->pdev->dev,
+						      dma_addr))
+					return -ENOMEM;
+
 				desc[frag].addr_lo = lower_32_bits(dma_addr);
 				desc[frag].addr_hi = upper_32_bits(dma_addr);
 				frag++;
@@ -2479,6 +2487,10 @@ static int nic_send_packet(struct et131x_adapter *adapter, struct tcb *tcb)
 							  skb_headlen(skb) / 2,
 							  skb_headlen(skb) / 2,
 							  DMA_TO_DEVICE);
+				if (dma_mapping_error(&adapter->pdev->dev,
+						      dma_addr))
+					goto unmap_first_out;
+
 				desc[frag].addr_lo = lower_32_bits(dma_addr);
 				desc[frag].addr_hi = upper_32_bits(dma_addr);
 				frag++;
@@ -2490,6 +2502,9 @@ static int nic_send_packet(struct et131x_adapter *adapter, struct tcb *tcb)
 						    0,
 						    desc[frag].len_vlan,
 						    DMA_TO_DEVICE);
+			if (dma_mapping_error(&adapter->pdev->dev, dma_addr))
+				goto unmap_out;
+
 			desc[frag].addr_lo = lower_32_bits(dma_addr);
 			desc[frag].addr_hi = upper_32_bits(dma_addr);
 			frag++;
@@ -2579,6 +2594,27 @@ static int nic_send_packet(struct et131x_adapter *adapter, struct tcb *tcb)
 		       &adapter->regs->global.watchdog_timer);
 	}
 	return 0;
+
+unmap_out:
+	// Unmap the body of the packet with map_page
+	while (--i) {
+		frag--;
+		dma_addr = desc[frag].addr_lo;
+		dma_addr |= (u64)desc[frag].addr_hi << 32;
+		dma_unmap_page(&adapter->pdev->dev, dma_addr,
+			       desc[frag].len_vlan, DMA_TO_DEVICE);
+	}
+
+unmap_first_out:
+	// Unmap the header with map_single
+	while (frag--) {
+		dma_addr = desc[frag].addr_lo;
+		dma_addr |= (u64)desc[frag].addr_hi << 32;
+		dma_unmap_single(&adapter->pdev->dev, dma_addr,
+				 desc[frag].len_vlan, DMA_TO_DEVICE);
+	}
+
+	return -ENOMEM;
 }
 
 static int send_packet(struct sk_buff *skb, struct et131x_adapter *adapter)
-- 
2.39.5



