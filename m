Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC6DE14A0AA;
	Tue, 25 Jun 2024 09:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309092; cv=none; b=hePXkzw1IoZgEtjSLn2hEYc4vPIASuhVWjVaRm0KKp/B9fh/1W1fGO+cdtjJe88i/OaDnV12pdnd2P3nemFGh1ANfJlPu4uv5TArdkvZz/kdV336vjPC+E1us23xkiapGBxi7w+PT61vNmob/9kSR2Wds3vOUnbrZ21Hc4Ku4mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309092; c=relaxed/simple;
	bh=g8kePjaKlsKOj+DEW+QNP8ii+Jxt+57tffpoMn1gWvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pjwmnLLuu/tIUYDslQRap/jHb4JRpm35SWJOILZovaKd+1PEaluBK4S/RYdwlZPooxAIeYsT266FvV/ACm9j4YWZGSpoMzEy4CZOg3LsVj5KdjXBKYkXqImgWTOspLgIJYEgRjPCK1Y02PRKG/ypytc0rv4YaGLneaCqlhrRGWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lqx1DgOv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lqx1DgOv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0F1BC32786;
	Tue, 25 Jun 2024 09:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309092;
	bh=g8kePjaKlsKOj+DEW+QNP8ii+Jxt+57tffpoMn1gWvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lqx1DgOvdHAUc+wfFU8ESRsBZQvMPTzuSh30SuhRqvy/PnkY1ujk0x2SttvTGGvuA
	 wNaqDGgOaQPJUgb5CH1plVxxOlP5GBep5D3gACcFWifbENRer86j2LUJPE6AgB8z6R
	 BU0OjkybFTio7szXMoXRRKS2j4kMNIr8IuPj2XPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaolei Wang <xiaolei.wang@windriver.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 093/192] net: stmmac: No need to calculate speed divider when offload is disabled
Date: Tue, 25 Jun 2024 11:32:45 +0200
Message-ID: <20240625085540.748145677@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

[ Upstream commit b8c43360f6e424131fa81d3ba8792ad8ff25a09e ]

commit be27b8965297 ("net: stmmac: replace priv->speed with
the portTransmitRate from the tc-cbs parameters") introduced
a problem. When deleting, it prompts "Invalid portTransmitRate
0 (idleSlope - sendSlope)" and exits. Add judgment on cbs.enable.
Only when offload is enabled, speed divider needs to be calculated.

Fixes: be27b8965297 ("net: stmmac: replace priv->speed with the portTransmitRate from the tc-cbs parameters")
Signed-off-by: Xiaolei Wang <xiaolei.wang@windriver.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240617013922.1035854-1-xiaolei.wang@windriver.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/stmmac_tc.c   | 40 ++++++++++---------
 1 file changed, 22 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index 2467598f9d92f..77245f856dd0e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -358,24 +358,28 @@ static int tc_setup_cbs(struct stmmac_priv *priv,
 
 	port_transmit_rate_kbps = qopt->idleslope - qopt->sendslope;
 
-	/* Port Transmit Rate and Speed Divider */
-	switch (div_s64(port_transmit_rate_kbps, 1000)) {
-	case SPEED_10000:
-	case SPEED_5000:
-		ptr = 32;
-		break;
-	case SPEED_2500:
-	case SPEED_1000:
-		ptr = 8;
-		break;
-	case SPEED_100:
-		ptr = 4;
-		break;
-	default:
-		netdev_err(priv->dev,
-			   "Invalid portTransmitRate %lld (idleSlope - sendSlope)\n",
-			   port_transmit_rate_kbps);
-		return -EINVAL;
+	if (qopt->enable) {
+		/* Port Transmit Rate and Speed Divider */
+		switch (div_s64(port_transmit_rate_kbps, 1000)) {
+		case SPEED_10000:
+		case SPEED_5000:
+			ptr = 32;
+			break;
+		case SPEED_2500:
+		case SPEED_1000:
+			ptr = 8;
+			break;
+		case SPEED_100:
+			ptr = 4;
+			break;
+		default:
+			netdev_err(priv->dev,
+				   "Invalid portTransmitRate %lld (idleSlope - sendSlope)\n",
+				   port_transmit_rate_kbps);
+			return -EINVAL;
+		}
+	} else {
+		ptr = 0;
 	}
 
 	mode_to_use = priv->plat->tx_queues_cfg[queue].mode_to_use;
-- 
2.43.0



