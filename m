Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8952DCC02;
	Tue,  8 Jul 2025 17:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751994160; cv=none; b=i42MURls7tn262SIfh+KGm2396m4MNFGY/suuVgEOuwFHzNfL+bkT35sVbWGOFv4b1nVP8bF/S5NtZXv0rkMV7oLT9E4nSeBjgVLSCquzoAswp1o+Wxt+qT0oGr4hQWn8ItCtJc850YWj8dvg2MuNk5RCm1eddl1T5bWWyQdKVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751994160; c=relaxed/simple;
	bh=2+XrFEaNo3AM8fLKVlPxAmrvS4eiSaaH6AgDDDXbMqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WsuMbqsnwsw2ghrH0yZJ7tJvurSq/JXiStaVTj5brLOSICrUfMEsJ5NRGU11snttrwF7hRtZNuuowsonajZ9rnm8K1cvrBV3Ph0+85E0wcHFbAD/K4yVhDtsnOmnLDyjSxM9XBmOuVKdwWxWSlnnFG8WOhieAwW8gqD1sxo75Hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IDXEjIbm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IDXEjIbm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B89FC4CEED;
	Tue,  8 Jul 2025 17:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751994159;
	bh=2+XrFEaNo3AM8fLKVlPxAmrvS4eiSaaH6AgDDDXbMqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IDXEjIbm82Xop/n0r7Dryqhs/RaW3067/80FjWwoR+sV7hgbudzW23b6QFixL3yn2
	 qsxn5c8r0PkvUFE136ChYAvJ95zFx2dw5zjaZneG+oVhoy4/5FwLuDxyFRYdVS+38w
	 4EeNTleyFd8h2nJpn6fV070kO9uA25Xbq2f59l/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fushuai Wang <wangfushuai@baidu.com>,
	Simon Horman <horms@kernel.org>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 146/160] dpaa2-eth: fix xdp_rxq_info leak
Date: Tue,  8 Jul 2025 18:23:03 +0200
Message-ID: <20250708162235.386236587@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

From: Fushuai Wang <wangfushuai@baidu.com>

[ Upstream commit 2def09ead4ad5907988b655d1e1454003aaf8297 ]

The driver registered xdp_rxq_info structures via xdp_rxq_info_reg()
but failed to properly unregister them in error paths and during
removal.

Fixes: d678be1dc1ec ("dpaa2-eth: add XDP_REDIRECT support")
Signed-off-by: Fushuai Wang <wangfushuai@baidu.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Link: https://patch.msgid.link/20250626133003.80136-1-wangfushuai@baidu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 26 +++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index acbb26cb2177e..07d8c9e41328e 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -3512,6 +3512,7 @@ static int dpaa2_eth_setup_rx_flow(struct dpaa2_eth_priv *priv,
 					 MEM_TYPE_PAGE_ORDER0, NULL);
 	if (err) {
 		dev_err(dev, "xdp_rxq_info_reg_mem_model failed\n");
+		xdp_rxq_info_unreg(&fq->channel->xdp_rxq);
 		return err;
 	}
 
@@ -4004,17 +4005,25 @@ static int dpaa2_eth_bind_dpni(struct dpaa2_eth_priv *priv)
 			return -EINVAL;
 		}
 		if (err)
-			return err;
+			goto out;
 	}
 
 	err = dpni_get_qdid(priv->mc_io, 0, priv->mc_token,
 			    DPNI_QUEUE_TX, &priv->tx_qdid);
 	if (err) {
 		dev_err(dev, "dpni_get_qdid() failed\n");
-		return err;
+		goto out;
 	}
 
 	return 0;
+
+out:
+	while (i--) {
+		if (priv->fq[i].type == DPAA2_RX_FQ &&
+		    xdp_rxq_info_is_reg(&priv->fq[i].channel->xdp_rxq))
+			xdp_rxq_info_unreg(&priv->fq[i].channel->xdp_rxq);
+	}
+	return err;
 }
 
 /* Allocate rings for storing incoming frame descriptors */
@@ -4371,6 +4380,17 @@ static void dpaa2_eth_del_ch_napi(struct dpaa2_eth_priv *priv)
 	}
 }
 
+static void dpaa2_eth_free_rx_xdp_rxq(struct dpaa2_eth_priv *priv)
+{
+	int i;
+
+	for (i = 0; i < priv->num_fqs; i++) {
+		if (priv->fq[i].type == DPAA2_RX_FQ &&
+		    xdp_rxq_info_is_reg(&priv->fq[i].channel->xdp_rxq))
+			xdp_rxq_info_unreg(&priv->fq[i].channel->xdp_rxq);
+	}
+}
+
 static int dpaa2_eth_probe(struct fsl_mc_device *dpni_dev)
 {
 	struct device *dev;
@@ -4559,6 +4579,7 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dpni_dev)
 	free_percpu(priv->percpu_stats);
 err_alloc_percpu_stats:
 	dpaa2_eth_del_ch_napi(priv);
+	dpaa2_eth_free_rx_xdp_rxq(priv);
 err_bind:
 	dpaa2_eth_free_dpbp(priv);
 err_dpbp_setup:
@@ -4610,6 +4631,7 @@ static int dpaa2_eth_remove(struct fsl_mc_device *ls_dev)
 	free_percpu(priv->percpu_extras);
 
 	dpaa2_eth_del_ch_napi(priv);
+	dpaa2_eth_free_rx_xdp_rxq(priv);
 	dpaa2_eth_free_dpbp(priv);
 	dpaa2_eth_free_dpio(priv);
 	dpaa2_eth_free_dpni(priv);
-- 
2.39.5



