Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0091C2E611E;
	Tue, 15 Jul 2025 13:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586508; cv=none; b=hOUq0E8l4QzUeRAWDSY+3e/vnlrW1naG5s18aLnnUrBYSR4mp0ei4hcloVpmXq9C0k/JqVTMO0hVQ78zQBaOph8K0VDyuR7WegBxCpXB//FqTXW5niqRkKYAh+g0NtMEOQ0Jbw7OWX+UCAx4mNlLmF6he6eOWOGiimjThJXp28k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586508; c=relaxed/simple;
	bh=BPC3oOJk7OgsQeXQJOrEjNoJ/EN6KUR1lO+vWf3qfJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RcygVKOTqchzl83O7evuqstzBO8WceSM4t+7P90JdnwXJsbmcCsx4b6RX5b3hXYYwpGwIJUEh4CSQnaBhyCeMprzeeS1/9jAXgPDSnMLyLvVwSoyP9cCyLE9XceQVPeqCPPS8jgoCaLeG/COj5l+ylOWsMS9H5kwBRphZREcFx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TzpjVLhA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TzpjVLhA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34981C4CEE3;
	Tue, 15 Jul 2025 13:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586507;
	bh=BPC3oOJk7OgsQeXQJOrEjNoJ/EN6KUR1lO+vWf3qfJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TzpjVLhAnOqXIJzfTzzrgOLY7uVWHeIXRkeT85PBDDMi+hA1+PieRtG0Ds/iIPYdT
	 dNJ5iMewvBouEGO0+wgduFfLL/FRXe3N5Lw10b1+xXBMKL0iVoM6ag1XgsVr5BU8ci
	 amSrURh+v/1sNu7UmlPTA5NGROIbtqieAt1q+9b4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fushuai Wang <wangfushuai@baidu.com>,
	Simon Horman <horms@kernel.org>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 091/148] dpaa2-eth: fix xdp_rxq_info leak
Date: Tue, 15 Jul 2025 15:13:33 +0200
Message-ID: <20250715130803.958621246@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 5f5766b1f3b70..8649578b54c1e 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -2725,6 +2725,7 @@ static int setup_rx_flow(struct dpaa2_eth_priv *priv,
 					 MEM_TYPE_PAGE_ORDER0, NULL);
 	if (err) {
 		dev_err(dev, "xdp_rxq_info_reg_mem_model failed\n");
+		xdp_rxq_info_unreg(&fq->channel->xdp_rxq);
 		return err;
 	}
 
@@ -3153,17 +3154,25 @@ static int bind_dpni(struct dpaa2_eth_priv *priv)
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
@@ -3445,6 +3454,17 @@ static void del_ch_napi(struct dpaa2_eth_priv *priv)
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
@@ -3574,6 +3594,7 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dpni_dev)
 	free_percpu(priv->percpu_stats);
 err_alloc_percpu_stats:
 	del_ch_napi(priv);
+	dpaa2_eth_free_rx_xdp_rxq(priv);
 err_bind:
 	free_dpbp(priv);
 err_dpbp_setup:
@@ -3614,6 +3635,7 @@ static int dpaa2_eth_remove(struct fsl_mc_device *ls_dev)
 	free_percpu(priv->percpu_extras);
 
 	del_ch_napi(priv);
+	dpaa2_eth_free_rx_xdp_rxq(priv);
 	free_dpbp(priv);
 	free_dpio(priv);
 	free_dpni(priv);
-- 
2.39.5



