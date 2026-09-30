Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB00C51B19E;
	Wed, 30 Sep 2026 17:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789307; cv=none; b=JrZx7Q/2dJv3EZucabE8RBwhiLwsn2pZ2akoD9cr3793mHPaSVEkRsGe9G6Whccfk1A7SDHlsQzsFJzzpi63ienW6jCt7QalLF27Xr8gtS4ALX2+L4Ot1kQiPdJCwQWV25Ttp6NpmnTLkc1/mASoLnLeAhsqJeVPzcvV0IJd0DI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789307; c=relaxed/simple;
	bh=S0C5fh5TNRB2tREo93CUtipFTNuVDVqIZb3UOmfyxlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DTBNDir5wuArbgWyHd8NA6CokOGQlc89+kGbbEKeKH7n8RJpxwqDhLvq3b8/MX4BGerS+2mDHXZZRDiLm1XvbfQln5WhE9W9hdvfxcPVK+tkzYWzE+x6TDnFkhfgBTvUYOxFwU3MbZd0MKJxEMT/qGqY9UmESWcKtqS7WAKyx8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xdZlcaZZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xdZlcaZZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDD331F00899;
	Wed, 30 Sep 2026 17:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789303;
	bh=H92HKQSrp9yRLKT6o4J41qDj9UYph2lPua6EgijJ7Bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xdZlcaZZDPIV7GXVytzNLzxqCtKIgU/B/5sJdNQqNkmBaagFhFVfgleWP2XF380bw
	 3NNVUnKfr+CwX+L2jzoTbh5D71kxufXSpHhut2/qvG4BrPNZTZQPVquTD+OeoKoLUz
	 G5k2X8YTqhsjgNyNXWZ4deTHlrUQlmc2L7Lo1T5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 429/877] net: bcmgenet: mask DMA_TIMEOUT_MASK when reading DMA_RING0_TIMEOUT
Date: Wed, 30 Sep 2026 17:22:20 +0200
Message-ID: <20260930152423.946057616@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a326ee63c1b7c..14e891db97ea8 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -819,7 +819,8 @@ static int bcmgenet_get_coalesce(struct net_device *dev,
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



