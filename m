Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91256503BC8;
	Wed, 30 Sep 2026 16:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787349; cv=none; b=gEEU0AwN3Vn4NAIDFZAJq9D7mDOG7erF72SAs4DrtymZylxiFujKJaZBDSJ6zfa41tvJ02LOc6i4+Flx7l27qoEr0ln5pJsfwsqSqGf7tW6STZZoD63Y0hV1TtLSMpSiYI5/XkCBJ9Y94dmgh7ijMfbIdt5R/35iggLlEqZ3Bmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787349; c=relaxed/simple;
	bh=7wgrew/KFmK77wPnkjt59+CRtNzLWGzo134Ija068zM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mquANoJkM6sCMWcyVOUN0Ih0p19K3NAyqunPxZJBTi1700X9zqleIZwpedihx6/oLvvOuiZWdIHOJaXvcEyKN/iB3/9VT2g3HV0xsTMVxx1ZwjVp0ZnqMrBz+xjnHQmfqpfB9SdqI+y2k3dP/kz338xziqWvhvotF/WnvbrhHss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zY+VlCmg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zY+VlCmg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E06381F000FF;
	Wed, 30 Sep 2026 16:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787348;
	bh=WEk+SHI6ewslAjt1/TewkEu1gDREarorrttM9iIhDNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zY+VlCmgtVY2tAtnzRuAtXdwPYBckyzyth8YtEg55PrIFK6G3BpB2zNM9W2oUNmcQ
	 Zdp9EzF6qqczCbZh+PArCT9X5mV86V1vCAKKAOX51TN42JnLf6DfBBrjTdNffk/ofX
	 97VqsmLKsfRBBgltSD97WlkvxyTqSUb314ATpvLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 197/457] net: bcmgenet: mask DMA_TIMEOUT_MASK when reading DMA_RING0_TIMEOUT
Date: Wed, 30 Sep 2026 17:25:02 +0200
Message-ID: <20260930152350.306808770@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fainelli <florian.fainelli@broadcom.com>

[ Upstream commit d64e277b955be4506931802837499b62c8f3968a ]

bcmgenet_get_coalesce() reads DMA_RING0_TIMEOUT to calculate
rx_coalesce_usecs without masking out bits outside DMA_TIMEOUT_MASK
(16 bits). If upper bits are non-zero or contain status/flags, the
computed value of rx_coalesce_usecs returned to userspace via ethtool
becomes corrupted.

Mask the register read with DMA_TIMEOUT_MASK before computing the
timeout in microseconds.

Fixes: 4a29645bfe6c ("net: bcmgenet: Implement RX coalescing control knobs")
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20260921220021.281418-6-florian.fainelli@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 011376a1678a1..21668e41b6964 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -852,7 +852,8 @@ static int bcmgenet_get_coalesce(struct net_device *dev,
 	ec->rx_max_coalesced_frames =
 		bcmgenet_rdma_ring_readl(priv, 0, DMA_MBUF_DONE_THRESH);
 	ec->rx_coalesce_usecs =
-		bcmgenet_rdma_readl(priv, DMA_RING0_TIMEOUT) * 8192 / 1000;
+		(bcmgenet_rdma_readl(priv, DMA_RING0_TIMEOUT) &
+		 DMA_TIMEOUT_MASK) * 8192 / 1000;
 
 	for (i = 0; i <= priv->hw_params->rx_queues; i++) {
 		ring = &priv->rx_rings[i];
-- 
2.53.0



