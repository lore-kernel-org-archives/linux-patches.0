Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CDAB82871;
	Wed, 19 Jun 2024 13:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802335; cv=none; b=B6uHcTv7riGK4KTc8JBVUSPiqCM4gqKLSXlEOvZTd4JabSN1FvKOvZ3Up1ujdyvMi2SM1cmG3z0zBohESfBgATAxlloCMRhxY2BjbdMaa202WC3Phq96ysWA/CGbNt/PAjkWZKisBOb5MjBw5U/K8QSf9ZEqBDOMXkT4z2ggY1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802335; c=relaxed/simple;
	bh=QjB7q8LHJ4sYu0XdBJu4P1unCTn9cGIUHvyRSuVIxqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yo1ztiKO6WayCtjzOunzuNSiyAydtQydGk0F8uCo76AuwrW9j7/x3KwCGsgT17GHoVh0BXQX3DqkFKonNEiwUMzmN8bOmX1cAwj3L2du5KLIps08klVEnG6IGILqwjfv+5T6dcjQF4SoRavQK9FHZNcw+ETwOfOcTcRpVHDboNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2wa0VRS6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2wa0VRS6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94320C2BBFC;
	Wed, 19 Jun 2024 13:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802335;
	bh=QjB7q8LHJ4sYu0XdBJu4P1unCTn9cGIUHvyRSuVIxqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2wa0VRS67d87OnHXI7xSFmB8BGRXYUGbLZGfqjffScAQWVAX3FmB8CEcVMa4VwxLV
	 /w9TIPiaDBLDdBPCVMX2DIu95i5CSLxskAURPOubwdd0cefijdgbU7/YoSF+OpMuXR
	 OQ1fFCEu1iWjb7etPZwuZLb2q2PvsYHP8Ma3IZJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaolei Wang <xiaolei.wang@windriver.com>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 162/267] net: stmmac: replace priv->speed with the portTransmitRate from the tc-cbs parameters
Date: Wed, 19 Jun 2024 14:55:13 +0200
Message-ID: <20240619125612.561244752@linuxfoundation.org>
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

From: Xiaolei Wang <xiaolei.wang@windriver.com>

[ Upstream commit be27b896529787e23a35ae4befb6337ce73fcca0 ]

The current cbs parameter depends on speed after uplinking,
which is not needed and will report a configuration error
if the port is not initially connected. The UAPI exposed by
tc-cbs requires userspace to recalculate the send slope anyway,
because the formula depends on port_transmit_rate (see man tc-cbs),
which is not an invariant from tc's perspective. Therefore, we
use offload->sendslope and offload->idleslope to derive the
original port_transmit_rate from the CBS formula.

Fixes: 1f705bc61aee ("net: stmmac: Add support for CBS QDISC")
Signed-off-by: Xiaolei Wang <xiaolei.wang@windriver.com>
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Link: https://lore.kernel.org/r/20240608143524.2065736-1-xiaolei.wang@windriver.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/stmmac_tc.c   | 25 ++++++++-----------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index 6ad3e0a119366..2467598f9d92f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -343,10 +343,11 @@ static int tc_setup_cbs(struct stmmac_priv *priv,
 			struct tc_cbs_qopt_offload *qopt)
 {
 	u32 tx_queues_count = priv->plat->tx_queues_to_use;
+	s64 port_transmit_rate_kbps;
 	u32 queue = qopt->queue;
-	u32 ptr, speed_div;
 	u32 mode_to_use;
 	u64 value;
+	u32 ptr;
 	int ret;
 
 	/* Queue 0 is not AVB capable */
@@ -355,30 +356,26 @@ static int tc_setup_cbs(struct stmmac_priv *priv,
 	if (!priv->dma_cap.av)
 		return -EOPNOTSUPP;
 
+	port_transmit_rate_kbps = qopt->idleslope - qopt->sendslope;
+
 	/* Port Transmit Rate and Speed Divider */
-	switch (priv->speed) {
+	switch (div_s64(port_transmit_rate_kbps, 1000)) {
 	case SPEED_10000:
-		ptr = 32;
-		speed_div = 10000000;
-		break;
 	case SPEED_5000:
 		ptr = 32;
-		speed_div = 5000000;
 		break;
 	case SPEED_2500:
-		ptr = 8;
-		speed_div = 2500000;
-		break;
 	case SPEED_1000:
 		ptr = 8;
-		speed_div = 1000000;
 		break;
 	case SPEED_100:
 		ptr = 4;
-		speed_div = 100000;
 		break;
 	default:
-		return -EOPNOTSUPP;
+		netdev_err(priv->dev,
+			   "Invalid portTransmitRate %lld (idleSlope - sendSlope)\n",
+			   port_transmit_rate_kbps);
+		return -EINVAL;
 	}
 
 	mode_to_use = priv->plat->tx_queues_cfg[queue].mode_to_use;
@@ -398,10 +395,10 @@ static int tc_setup_cbs(struct stmmac_priv *priv,
 	}
 
 	/* Final adjustments for HW */
-	value = div_s64(qopt->idleslope * 1024ll * ptr, speed_div);
+	value = div_s64(qopt->idleslope * 1024ll * ptr, port_transmit_rate_kbps);
 	priv->plat->tx_queues_cfg[queue].idle_slope = value & GENMASK(31, 0);
 
-	value = div_s64(-qopt->sendslope * 1024ll * ptr, speed_div);
+	value = div_s64(-qopt->sendslope * 1024ll * ptr, port_transmit_rate_kbps);
 	priv->plat->tx_queues_cfg[queue].send_slope = value & GENMASK(31, 0);
 
 	value = qopt->hicredit * 1024ll * 8;
-- 
2.43.0



