Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60B5143889;
	Tue, 23 Apr 2024 21:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908595; cv=none; b=NPVhKeyrIYXn9zyaaQQ5+q9Gd1Mt0puZsWyRDxpdnPW/I+Df5P4dt7GXXSzhlkEIB2rfRMy+M1olr+C7v8p0bviSCNsn74WU3UFajGWGPjMV46En2vFbjrLPi9cq0EsxGh0rna7VzDAAg0qZHdTuK42ypezrbzIzrJn+AgGhpxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908595; c=relaxed/simple;
	bh=d/G8t6GJ5zYpeFwgZFbo1cFG4Qv31Yadbiz0IOKvh4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RhQ5EM7MUEblet3TlehvTXDXkcdaTzdwjx/7vwI+FA6N/5umVlT+lfl8HipgO4ddmBv+zots8XkjbTErks+vVh5H3fXVHGkJSHrj2lSS20Y1xLKAdB8Wf3eWz0KlLAAzklvaVurg3f5QFax0BzeNdANq4fl67J5ae98tBcOddp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rEbmhZt5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rEbmhZt5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C422C116B1;
	Tue, 23 Apr 2024 21:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908595;
	bh=d/G8t6GJ5zYpeFwgZFbo1cFG4Qv31Yadbiz0IOKvh4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rEbmhZt5qrpq/akM67687fk135qODU/SpjUy0qK1La+oc0xOi6Rg6SctTSTNpOowU
	 taFxamABSNBoM63xJ0qe8Q9hw66lWdAeEncDWuPMkhhaTSuACA3n144O36xfHlgJBh
	 ByzS3J+J49o/VLdyNDC35bCn3OmEdac4dZmsxIiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Schuyler Patton <spatton@ti.com>,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Roger Quadros <rogerq@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 058/158] net: ethernet: ti: am65-cpsw-nuss: cleanup DMA Channels before using them
Date: Tue, 23 Apr 2024 14:38:15 -0700
Message-ID: <20240423213857.661224106@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Siddharth Vadapalli <s-vadapalli@ti.com>

[ Upstream commit c24cd679b075b0e953ea167b0aa2b2d59e4eba7f ]

The TX and RX DMA Channels used by the driver to exchange data with CPSW
are not guaranteed to be in a clean state during driver initialization.
The Bootloader could have used the same DMA Channels without cleaning them
up in the event of failure. Thus, reset and disable the DMA Channels to
ensure that they are in a clean state before using them.

Fixes: 93a76530316a ("net: ethernet: ti: introduce am65x/j721e gigabit eth subsystem driver")
Reported-by: Schuyler Patton <spatton@ti.com>
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Reviewed-by: Roger Quadros <rogerq@kernel.org>
Link: https://lore.kernel.org/r/20240417095425.2253876-1-s-vadapalli@ti.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index c62b0f99f2bc4..d556e705ec000 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2716,6 +2716,8 @@ static void am65_cpsw_unregister_devlink(struct am65_cpsw_common *common)
 
 static int am65_cpsw_nuss_register_ndevs(struct am65_cpsw_common *common)
 {
+	struct am65_cpsw_rx_chn *rx_chan = &common->rx_chns;
+	struct am65_cpsw_tx_chn *tx_chan = common->tx_chns;
 	struct device *dev = common->dev;
 	struct am65_cpsw_port *port;
 	int ret = 0, i;
@@ -2728,6 +2730,22 @@ static int am65_cpsw_nuss_register_ndevs(struct am65_cpsw_common *common)
 	if (ret)
 		return ret;
 
+	/* The DMA Channels are not guaranteed to be in a clean state.
+	 * Reset and disable them to ensure that they are back to the
+	 * clean state and ready to be used.
+	 */
+	for (i = 0; i < common->tx_ch_num; i++) {
+		k3_udma_glue_reset_tx_chn(tx_chan[i].tx_chn, &tx_chan[i],
+					  am65_cpsw_nuss_tx_cleanup);
+		k3_udma_glue_disable_tx_chn(tx_chan[i].tx_chn);
+	}
+
+	for (i = 0; i < AM65_CPSW_MAX_RX_FLOWS; i++)
+		k3_udma_glue_reset_rx_chn(rx_chan->rx_chn, i, rx_chan,
+					  am65_cpsw_nuss_rx_cleanup, !!i);
+
+	k3_udma_glue_disable_rx_chn(rx_chan->rx_chn);
+
 	ret = am65_cpsw_nuss_register_devlink(common);
 	if (ret)
 		return ret;
-- 
2.43.0



