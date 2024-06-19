Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AEC582495;
	Wed, 19 Jun 2024 13:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803093; cv=none; b=cR+kj5YPnk1aF87iPhD/32nOH3vIQ6KImoFO8WkgMOncqN2XvP9tjfq1drbw2G10W1DmfRBFgltjJ7Ln255eNdDDE71XnrNNNESsSuBQ6OOTvEk11JDzO7X66yAZm6uvMsgbo+9X43cbASZWAh4lG4lF820ZxTAfgpWIMwc06mU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803093; c=relaxed/simple;
	bh=vApH9GKTC2i7KNYyQgx9IhMdTFT/SBpbHznO+LvWRxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ne102VaVACsgFYzNBos9hMf+2PMOhna6jKmGskQXl3B1k+ycr+z4+Inb38/dnmeWlVIsBAdka46ZnSg+b020V4dBFt2Aq0DtUHKHH4A6CMT1LcWu6zcw2OeyItbhqkXtuHz21AizNTLBF4OStVuZEZJqI6BywyRDRKuuQMhC3vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nMzGyD3j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nMzGyD3j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2BFAC2BBFC;
	Wed, 19 Jun 2024 13:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803093;
	bh=vApH9GKTC2i7KNYyQgx9IhMdTFT/SBpbHznO+LvWRxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nMzGyD3jb7EtmDCaBhRBN71s0F005XcoTG+Mzdf4Otb/8QbbC3pmGRvB6e18rLrJI
	 9ZqB1IP2ZXjqM/f0kM3ban/QiwQ1UT+U9shPoiCjT7A4e3OX5l362oqPbYnuBe8zoJ
	 pnqWd0/DT9F7+wWsQTdFjqSX9L76Em1DDil45jpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagar Cheluvegowda <quic_scheluve@quicinc.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Halaney <ahalaney@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 151/281] net: stmmac: dwmac-qcom-ethqos: Configure host DMA width
Date: Wed, 19 Jun 2024 14:55:10 +0200
Message-ID: <20240619125615.651147521@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sagar Cheluvegowda <quic_scheluve@quicinc.com>

[ Upstream commit 0579f27249047006a818e463ee66a6c314d04cea ]

Commit 070246e4674b ("net: stmmac: Fix for mismatched host/device DMA
address width") added support in the stmmac driver for platform drivers
to indicate the host DMA width, but left it up to authors of the
specific platforms to indicate if their width differed from the addr64
register read from the MAC itself.

Qualcomm's EMAC4 integration supports only up to 36 bit width (as
opposed to the addr64 register indicating 40 bit width). Let's indicate
that in the platform driver to avoid a scenario where the driver will
allocate descriptors of size that is supported by the CPU which in our
case is 36 bit, but as the addr64 register is still capable of 40 bits
the device will use two descriptors as one address.

Fixes: 8c4d92e82d50 ("net: stmmac: dwmac-qcom-ethqos: add support for emac4 on sa8775p platforms")
Signed-off-by: Sagar Cheluvegowda <quic_scheluve@quicinc.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Andrew Halaney <ahalaney@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
index e254b21fdb598..65d7370b47d57 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
@@ -93,6 +93,7 @@ struct ethqos_emac_driver_data {
 	bool has_emac_ge_3;
 	const char *link_clk_name;
 	bool has_integrated_pcs;
+	u32 dma_addr_width;
 	struct dwmac4_addrs dwmac4_addrs;
 };
 
@@ -276,6 +277,7 @@ static const struct ethqos_emac_driver_data emac_v4_0_0_data = {
 	.has_emac_ge_3 = true,
 	.link_clk_name = "phyaux",
 	.has_integrated_pcs = true,
+	.dma_addr_width = 36,
 	.dwmac4_addrs = {
 		.dma_chan = 0x00008100,
 		.dma_chan_offset = 0x1000,
@@ -845,6 +847,8 @@ static int qcom_ethqos_probe(struct platform_device *pdev)
 		plat_dat->flags |= STMMAC_FLAG_RX_CLK_RUNS_IN_LPI;
 	if (data->has_integrated_pcs)
 		plat_dat->flags |= STMMAC_FLAG_HAS_INTEGRATED_PCS;
+	if (data->dma_addr_width)
+		plat_dat->host_dma_width = data->dma_addr_width;
 
 	if (ethqos->serdes_phy) {
 		plat_dat->serdes_powerup = qcom_ethqos_serdes_powerup;
-- 
2.43.0



