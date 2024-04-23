Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6623A143C49;
	Tue, 23 Apr 2024 21:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908722; cv=none; b=BAPD0+L6RIR8V9+1YOfehLy61nl5JIQHwHFEhMvCFuKuM2KalpMmbyi2zAV8G+lzk7GUlYBCWehCeBg7/Qqx4UoL3EWGheYr/0hqk9L0RqvJnqeRPg7YWUKpvEZtsiOb/AdoFtKHCBT+ZGCSBebAHV6Y1eAFM8/Rsoxt2FPJYsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908722; c=relaxed/simple;
	bh=q8AzzETJ75LJq/aQZNV4MF8V+jha1tQqpLqM/kmnxAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qCZvL1xHHyxxZ8FbCkkycWZVsQtL8gOS3axQ4RAyGF697a0Nn20TU75onGAYT9WvlhG/ad218iN9k4EFrdYz7fj/iMRMbvuj15mtswZylM1/jr4ABDYXC2Z67dx1BseclkC5ktcZsR9NwRFGEjaOjqZG/JRwCOqITrAEkkcBdTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RCihTU6G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RCihTU6G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B6B8C32782;
	Tue, 23 Apr 2024 21:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908722;
	bh=q8AzzETJ75LJq/aQZNV4MF8V+jha1tQqpLqM/kmnxAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RCihTU6GlYpcPAl3TM6dYihoa6gzq1c4vfEzolTXx+gALegwRmj2VZGrsCXgHWpgR
	 RAxPCRPBOQJn19jnjfNirOHlkQnYhITpqHUIX59oYazxl13oGUBHZuZrGuifjzsOm3
	 LYfAqGUkF8+oILctK4zUN24xljzkwUCRlU+HqAcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Schuyler Patton <spatton@ti.com>,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Roger Quadros <rogerq@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 047/141] net: ethernet: ti: am65-cpsw-nuss: cleanup DMA Channels before using them
Date: Tue, 23 Apr 2024 14:38:35 -0700
Message-ID: <20240423213854.785404499@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 76fabeae512db..33df06a2de13a 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2549,6 +2549,8 @@ static void am65_cpsw_unregister_devlink(struct am65_cpsw_common *common)
 
 static int am65_cpsw_nuss_register_ndevs(struct am65_cpsw_common *common)
 {
+	struct am65_cpsw_rx_chn *rx_chan = &common->rx_chns;
+	struct am65_cpsw_tx_chn *tx_chan = common->tx_chns;
 	struct device *dev = common->dev;
 	struct devlink_port *dl_port;
 	struct am65_cpsw_port *port;
@@ -2567,6 +2569,22 @@ static int am65_cpsw_nuss_register_ndevs(struct am65_cpsw_common *common)
 		return ret;
 	}
 
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



