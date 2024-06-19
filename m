Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A1782871;
	Wed, 19 Jun 2024 13:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802293; cv=none; b=qHheb6/bCs4zj0YRjSc5v/tpPl9TCfPuzR+XQ5PZAgerW6uVGx6+f0mSfBDP1PYsg0LBTZS3gjjYhUWJyW8xK/lmYhKgoWVtVe2CJznS32eymCVqqBM+J2yn3B4fliKd8lgtB553wO+QErmFy7q3fqZccacZZO/P8TLojVEcTO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802293; c=relaxed/simple;
	bh=PfCzz0J5u8ZOShRFkKu8OmCY/JmmTzqdhA1zHujiS2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RZ0IyAs3W9c69koZcInDwAiFBZVC9wgC2jJ+jstAw5PY9GCXRFLYOXp0oE6Bv7Yh4rxpPXplmphdnWqF38SFITiLcsyxuKbou+M3HojjIzJuaDW7uvqbTM+ZwmFR0V8aCobeO+UwYONYBvlBzfwg+/lqzaSw+ZiegF150gskJJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uwOeaSRx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uwOeaSRx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CFE7C2BBFC;
	Wed, 19 Jun 2024 13:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802293;
	bh=PfCzz0J5u8ZOShRFkKu8OmCY/JmmTzqdhA1zHujiS2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uwOeaSRxHoc6SLsxJfaQCeePQqWWUnXQPmxi7+/wuz18xQt5O1jplMPTUiTnRJEKi
	 1QX5MjoYHYH0e/8i+B5RXjXSATh+LXkG0QMJzce0YRtGxMbIFgivOtlgWSLEftTVpW
	 tKpuNlxUk4RB4pGzpTt3TlCAV+nPYNCqrtwHvhUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagar Cheluvegowda <quic_scheluve@quicinc.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Halaney <ahalaney@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 146/267] net: stmmac: dwmac-qcom-ethqos: Configure host DMA width
Date: Wed, 19 Jun 2024 14:54:57 +0200
Message-ID: <20240619125611.951770686@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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
index 31631e3f89d0a..51ff53120307a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
@@ -93,6 +93,7 @@ struct ethqos_emac_driver_data {
 	bool has_emac_ge_3;
 	const char *link_clk_name;
 	bool has_integrated_pcs;
+	u32 dma_addr_width;
 	struct dwmac4_addrs dwmac4_addrs;
 };
 
@@ -272,6 +273,7 @@ static const struct ethqos_emac_driver_data emac_v4_0_0_data = {
 	.has_emac_ge_3 = true,
 	.link_clk_name = "phyaux",
 	.has_integrated_pcs = true,
+	.dma_addr_width = 36,
 	.dwmac4_addrs = {
 		.dma_chan = 0x00008100,
 		.dma_chan_offset = 0x1000,
@@ -816,6 +818,8 @@ static int qcom_ethqos_probe(struct platform_device *pdev)
 		plat_dat->flags |= STMMAC_FLAG_RX_CLK_RUNS_IN_LPI;
 	if (data->has_integrated_pcs)
 		plat_dat->flags |= STMMAC_FLAG_HAS_INTEGRATED_PCS;
+	if (data->dma_addr_width)
+		plat_dat->host_dma_width = data->dma_addr_width;
 
 	if (ethqos->serdes_phy) {
 		plat_dat->serdes_powerup = qcom_ethqos_serdes_powerup;
-- 
2.43.0



