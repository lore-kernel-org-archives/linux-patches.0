Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6E41A0BFD;
	Tue, 26 Aug 2025 12:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212912; cv=none; b=qtF9aidHkO6+RSE1VwUpEzv97KfrM1hznKr6zYeAZM3tRROlnoAGb2ImM7zTMC6VGo7IXMsaOaWEj5thArnHtYzkH4xVf5q9kIDtGwI6bSjWsTC7ar1i444VXMSDnYYavBZ/8PxqaBPVWUmLWJCoXefVQSGAJWmrtchykZ8AHVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212912; c=relaxed/simple;
	bh=3fQnI8flut0aF+Zy1J8vEdgZTkgEh+RXy6DkkowOrkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tRB9K7SQ9Q0UZamJRcgIQGoXlan0EJIWcC8W6mDJFyX1SDM1y9xxZaCYf/1TGbnLfHCh+x0Vjoy8iq4cjbcJ4k9US6iOAjmXJuqKIll4GYc7HwExIwMU9lNJsf9XmydFkQhTf63zPjzR+S94/Oq6up631m9MQzEtHItzN3hkKGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LOGOUd77; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LOGOUd77"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4CC5C4CEF1;
	Tue, 26 Aug 2025 12:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212912;
	bh=3fQnI8flut0aF+Zy1J8vEdgZTkgEh+RXy6DkkowOrkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LOGOUd77LdSD58nPaz3xARuZfW0oQGPqmY5VwQ4wEFALKXA4u+EsMI7BEmI3XNuXL
	 RVt4oWRPylh6Yq/pCu32i7Du2eJLl7EcRo/pVWsJC5yvGA39GQF+otFdgNeF8MOnXc
	 U0GgYWELNqmGUqtktZfVIio7enh/FZSvAskQ1+uc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Mark Einon <mark.einon@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 149/587] et131x: Add missing check after DMA map
Date: Tue, 26 Aug 2025 13:04:58 +0200
Message-ID: <20250826110956.740809172@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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
index 3d9220f9c9fe..294dbe2c3797 100644
--- a/drivers/net/ethernet/agere/et131x.c
+++ b/drivers/net/ethernet/agere/et131x.c
@@ -2459,6 +2459,10 @@ static int nic_send_packet(struct et131x_adapter *adapter, struct tcb *tcb)
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
@@ -2468,6 +2472,10 @@ static int nic_send_packet(struct et131x_adapter *adapter, struct tcb *tcb)
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
@@ -2478,6 +2486,10 @@ static int nic_send_packet(struct et131x_adapter *adapter, struct tcb *tcb)
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
@@ -2489,6 +2501,9 @@ static int nic_send_packet(struct et131x_adapter *adapter, struct tcb *tcb)
 						    0,
 						    desc[frag].len_vlan,
 						    DMA_TO_DEVICE);
+			if (dma_mapping_error(&adapter->pdev->dev, dma_addr))
+				goto unmap_out;
+
 			desc[frag].addr_lo = lower_32_bits(dma_addr);
 			desc[frag].addr_hi = upper_32_bits(dma_addr);
 			frag++;
@@ -2578,6 +2593,27 @@ static int nic_send_packet(struct et131x_adapter *adapter, struct tcb *tcb)
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



