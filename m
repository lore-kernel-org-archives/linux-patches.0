Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585941519AA;
	Wed,  5 Feb 2025 14:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764334; cv=none; b=agrTxD+JZb3UwrTgGrZJvxqeuyojTUGgw45LmZHEL0+8jMZt3X4v5dcLgfZOBsDknTNvvygyV5tavp61G3ljRZHQucShzLW9xF/pgWrRCCYsE6f5v7XvwtOq/br98+1ONAodyF+Ab6M4FYIIIMORoXg6rBUdlx77covFAm9R/Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764334; c=relaxed/simple;
	bh=tgxUWKisDc7FBQKbpqaYqCf6IrlKa57fQUIyKQq0tmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qq82NMMYT+eQu4k2/Mqzz3s4EW59C8nD0Zth6W2e/9VHDp77h0gNA88hG3qp6YWCup2fkZny59FbJ29EoFXZFzC2OIGS3HlyWSs55zukeBT6322ZL1/0YBBuvB/Npnn5ZAuzYRrV8Bg3jEFE/TX8jEjTxLRL4l74RQo5lqAkE7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lKWaTNkY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lKWaTNkY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C63A5C4CED1;
	Wed,  5 Feb 2025 14:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764334;
	bh=tgxUWKisDc7FBQKbpqaYqCf6IrlKa57fQUIyKQq0tmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lKWaTNkYKuPOnvZWlISbiw8vBjnCwfv2xNFUmOOJJ4BWlqv6YxAA6/YJBo7tSFH4W
	 0mywS70QB2pczJn7RBMFbMj8aL7Ffs6Htu8xcw6Y+WlVtPe1wSgz/5LonEyJWG4rBU
	 ebumGphGx4CvO3zNLj9pQoKkofApK41jC3kQexBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 114/590] net: airoha: Fix error path in airoha_probe()
Date: Wed,  5 Feb 2025 14:37:49 +0100
Message-ID: <20250205134459.619425854@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 0c7469ee718e1dd929f52bfb142a7f6fb68f0765 ]

Do not run napi_disable() if airoha_hw_init() fails since Tx/Rx napi
has not been started yet. In order to fix the issue, introduce
airoha_qdma_stop_napi routine and remove napi_disable in
airoha_hw_cleanup().

Fixes: 23020f049327 ("net: airoha: Introduce ethernet support for EN7581 SoC")
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20241216-airoha_probe-error-path-fix-v2-1-6b10e04e9a5c@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/airoha_eth.c | 33 ++++++++++++++++------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/airoha_eth.c b/drivers/net/ethernet/mediatek/airoha_eth.c
index 2c26eb1852837..8d9fb2a20469a 100644
--- a/drivers/net/ethernet/mediatek/airoha_eth.c
+++ b/drivers/net/ethernet/mediatek/airoha_eth.c
@@ -2123,17 +2123,14 @@ static void airoha_hw_cleanup(struct airoha_qdma *qdma)
 		if (!qdma->q_rx[i].ndesc)
 			continue;
 
-		napi_disable(&qdma->q_rx[i].napi);
 		netif_napi_del(&qdma->q_rx[i].napi);
 		airoha_qdma_cleanup_rx_queue(&qdma->q_rx[i]);
 		if (qdma->q_rx[i].page_pool)
 			page_pool_destroy(qdma->q_rx[i].page_pool);
 	}
 
-	for (i = 0; i < ARRAY_SIZE(qdma->q_tx_irq); i++) {
-		napi_disable(&qdma->q_tx_irq[i].napi);
+	for (i = 0; i < ARRAY_SIZE(qdma->q_tx_irq); i++)
 		netif_napi_del(&qdma->q_tx_irq[i].napi);
-	}
 
 	for (i = 0; i < ARRAY_SIZE(qdma->q_tx); i++) {
 		if (!qdma->q_tx[i].ndesc)
@@ -2158,6 +2155,21 @@ static void airoha_qdma_start_napi(struct airoha_qdma *qdma)
 	}
 }
 
+static void airoha_qdma_stop_napi(struct airoha_qdma *qdma)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(qdma->q_tx_irq); i++)
+		napi_disable(&qdma->q_tx_irq[i].napi);
+
+	for (i = 0; i < ARRAY_SIZE(qdma->q_rx); i++) {
+		if (!qdma->q_rx[i].ndesc)
+			continue;
+
+		napi_disable(&qdma->q_rx[i].napi);
+	}
+}
+
 static void airoha_update_hw_stats(struct airoha_gdm_port *port)
 {
 	struct airoha_eth *eth = port->qdma->eth;
@@ -2713,7 +2725,7 @@ static int airoha_probe(struct platform_device *pdev)
 
 	err = airoha_hw_init(pdev, eth);
 	if (err)
-		goto error;
+		goto error_hw_cleanup;
 
 	for (i = 0; i < ARRAY_SIZE(eth->qdma); i++)
 		airoha_qdma_start_napi(&eth->qdma[i]);
@@ -2728,13 +2740,16 @@ static int airoha_probe(struct platform_device *pdev)
 		err = airoha_alloc_gdm_port(eth, np);
 		if (err) {
 			of_node_put(np);
-			goto error;
+			goto error_napi_stop;
 		}
 	}
 
 	return 0;
 
-error:
+error_napi_stop:
+	for (i = 0; i < ARRAY_SIZE(eth->qdma); i++)
+		airoha_qdma_stop_napi(&eth->qdma[i]);
+error_hw_cleanup:
 	for (i = 0; i < ARRAY_SIZE(eth->qdma); i++)
 		airoha_hw_cleanup(&eth->qdma[i]);
 
@@ -2755,8 +2770,10 @@ static void airoha_remove(struct platform_device *pdev)
 	struct airoha_eth *eth = platform_get_drvdata(pdev);
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(eth->qdma); i++)
+	for (i = 0; i < ARRAY_SIZE(eth->qdma); i++) {
+		airoha_qdma_stop_napi(&eth->qdma[i]);
 		airoha_hw_cleanup(&eth->qdma[i]);
+	}
 
 	for (i = 0; i < ARRAY_SIZE(eth->ports); i++) {
 		struct airoha_gdm_port *port = eth->ports[i];
-- 
2.39.5



