Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E844238D;
	Mon, 18 Dec 2023 14:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e4M6k4Bq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8069EC433C8;
	Mon, 18 Dec 2023 14:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908119;
	bh=ygLvFjM+KntVZKR/w5qzUGqhixh63c6R0QClg8vaQA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e4M6k4BqrxJo99Mf7wfs4yL9sklQSmFhFG+92zzlPE9AwY7KGAYFTTYLkdNqkSkUU
	 +sM3lLS0b3TRAwt7Nd1QRu9UlUWS/m+PjfI/A0D3QJ7dAU+VDHAzfm8RCy8IVzHGBU
	 xJYvHdPvSWkSSwKRbTWkdZMqpQ7h1oZ7oAH81rEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Halaney <ahalaney@redhat.com>,
	Sneh Shah <quic_snehshah@quicinc.com>,
	Bjorn Andersson <quic_bjorande@quicinc.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 053/166] net: stmmac: dwmac-qcom-ethqos: Fix drops in 10M SGMII RX
Date: Mon, 18 Dec 2023 14:50:19 +0100
Message-ID: <20231218135107.399297708@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
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

From: Sneh Shah <quic_snehshah@quicinc.com>

[ Upstream commit 981d947bcd382c3950a593690e0e13d194d65b1c ]

In 10M SGMII mode all the packets are being dropped due to wrong Rx clock.
SGMII 10MBPS mode needs RX clock divider programmed to avoid drops in Rx.
Update configure SGMII function with Rx clk divider programming.

Fixes: 463120c31c58 ("net: stmmac: dwmac-qcom-ethqos: add support for SGMII")
Tested-by: Andrew Halaney <ahalaney@redhat.com>
Signed-off-by: Sneh Shah <quic_snehshah@quicinc.com>
Reviewed-by: Bjorn Andersson <quic_bjorande@quicinc.com>
Link: https://lore.kernel.org/r/20231212092208.22393-1-quic_snehshah@quicinc.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c    | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
index d3bf42d0fceb6..31631e3f89d0a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
@@ -34,6 +34,7 @@
 #define RGMII_CONFIG_LOOPBACK_EN		BIT(2)
 #define RGMII_CONFIG_PROG_SWAP			BIT(1)
 #define RGMII_CONFIG_DDR_MODE			BIT(0)
+#define RGMII_CONFIG_SGMII_CLK_DVDR		GENMASK(18, 10)
 
 /* SDCC_HC_REG_DLL_CONFIG fields */
 #define SDCC_DLL_CONFIG_DLL_RST			BIT(30)
@@ -78,6 +79,8 @@
 #define ETHQOS_MAC_CTRL_SPEED_MODE		BIT(14)
 #define ETHQOS_MAC_CTRL_PORT_SEL		BIT(15)
 
+#define SGMII_10M_RX_CLK_DVDR			0x31
+
 struct ethqos_emac_por {
 	unsigned int offset;
 	unsigned int value;
@@ -598,6 +601,9 @@ static int ethqos_configure_rgmii(struct qcom_ethqos *ethqos)
 	return 0;
 }
 
+/* On interface toggle MAC registers gets reset.
+ * Configure MAC block for SGMII on ethernet phy link up
+ */
 static int ethqos_configure_sgmii(struct qcom_ethqos *ethqos)
 {
 	int val;
@@ -617,6 +623,10 @@ static int ethqos_configure_sgmii(struct qcom_ethqos *ethqos)
 	case SPEED_10:
 		val |= ETHQOS_MAC_CTRL_PORT_SEL;
 		val &= ~ETHQOS_MAC_CTRL_SPEED_MODE;
+		rgmii_updatel(ethqos, RGMII_CONFIG_SGMII_CLK_DVDR,
+			      FIELD_PREP(RGMII_CONFIG_SGMII_CLK_DVDR,
+					 SGMII_10M_RX_CLK_DVDR),
+			      RGMII_IO_MACRO_CONFIG);
 		break;
 	}
 
-- 
2.43.0



