Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CC302DD5EF;
	Tue,  8 Jul 2025 16:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993513; cv=none; b=CZa0doXYmcDNtxaYY2nkAUHMqlYNo6YbUt3eDnDYcP0mZ9HjHqs++epnjemCBg/a7s+lGx5qC9mU4UVFp3Rwm8tANXTgdeo1UndA6Hqc+OHVvZTWFYA7FZhREHQxtLE1Ye4Gz1wsWd4wIplcd95FPDL9ieGl90lRT5V56wXy9LU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993513; c=relaxed/simple;
	bh=/2gG1QHchDu1ZsvQoNBMseQYUaHPRH3t1GwzorgSBfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TnfQfmqbuK7/nEdI9W7Hv6p7W832H+i76hR3x5uDR+Caz64gTNjD7brAoqMb0h11IvZuiFn9v3k5XLV1RoDb2li1aCcMJRuh7XzOVbaZadnjr88iahhq9NguWhAV6tpJtZPILBWgP67f8i5Ihd3wt+kcYtbfbXjmBBxyFxHP2RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OVc8emLt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OVc8emLt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97FBEC4CEF5;
	Tue,  8 Jul 2025 16:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993513;
	bh=/2gG1QHchDu1ZsvQoNBMseQYUaHPRH3t1GwzorgSBfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OVc8emLtYjia92dEE8I7KyKnlJG9E+5CgWoWlFVdasZAyR+N/omsmQWDkIHnuYu+i
	 xz8/LxzDTWeOZHhBIfSkcjIqJbbZFWTVhfJCa2KWQilAVzFBg3z8dBWUJsQPHjj0Bi
	 nFx6QY+UKBDbO/dhvQmToUCixWY40zuIUTcVW4C4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fushuai Wang <wangfushuai@baidu.com>,
	Simon Horman <horms@kernel.org>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 072/178] dpaa2-eth: fix xdp_rxq_info leak
Date: Tue,  8 Jul 2025 18:21:49 +0200
Message-ID: <20250708162238.555710965@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 29886a8ba73f3..efd0048acd3b2 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -3928,6 +3928,7 @@ static int dpaa2_eth_setup_rx_flow(struct dpaa2_eth_priv *priv,
 					 MEM_TYPE_PAGE_ORDER0, NULL);
 	if (err) {
 		dev_err(dev, "xdp_rxq_info_reg_mem_model failed\n");
+		xdp_rxq_info_unreg(&fq->channel->xdp_rxq);
 		return err;
 	}
 
@@ -4421,17 +4422,25 @@ static int dpaa2_eth_bind_dpni(struct dpaa2_eth_priv *priv)
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
@@ -4814,6 +4823,17 @@ static void dpaa2_eth_del_ch_napi(struct dpaa2_eth_priv *priv)
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
@@ -5017,6 +5037,7 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dpni_dev)
 	free_percpu(priv->percpu_stats);
 err_alloc_percpu_stats:
 	dpaa2_eth_del_ch_napi(priv);
+	dpaa2_eth_free_rx_xdp_rxq(priv);
 err_bind:
 	dpaa2_eth_free_dpbps(priv);
 err_dpbp_setup:
@@ -5069,6 +5090,7 @@ static void dpaa2_eth_remove(struct fsl_mc_device *ls_dev)
 	free_percpu(priv->percpu_extras);
 
 	dpaa2_eth_del_ch_napi(priv);
+	dpaa2_eth_free_rx_xdp_rxq(priv);
 	dpaa2_eth_free_dpbps(priv);
 	dpaa2_eth_free_dpio(priv);
 	dpaa2_eth_free_dpni(priv);
-- 
2.39.5



