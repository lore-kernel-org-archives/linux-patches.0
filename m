Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CBD0186E5A;
	Wed,  3 Jul 2024 11:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005796; cv=none; b=BwisX9iXScmN5cg6SUKVR6qUt0igGOOuupMD9T32uDLkDE2GirVk74iB27yjfxaLZCQZV+L8GRdDgPQ48UKsHbcO7TJ0kJEkjaQWOkUGpBFFFj5mSrQZ7nRBNj3MmZTmgG36iYRl89jItxq0C5tT5EMf+qHJScVtANXt8agd1gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005796; c=relaxed/simple;
	bh=gxRj6Zwb1XP08DoomoK6boMCTgxGLt5AiAejFTMJsHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cZtlS0SMxMFwpx7MVTAGSSy5cUZEm2yXw3ZfIFGSEaNyi4cTIFDDW8Tj92gXUG7f1BskB6lMQH5PfJ7aVVNgzX3wSo8c4KIoGtVPKp7PyGT5scmkF+QOixoxdIRmmqAL1kAp/iuYjY3klJbiV/d6SuMMI8qeB5uoFX5/UCW4IiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=doStivhd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="doStivhd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F75C2BD10;
	Wed,  3 Jul 2024 11:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005796;
	bh=gxRj6Zwb1XP08DoomoK6boMCTgxGLt5AiAejFTMJsHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=doStivhdoN8C0WJS/TrAzt3s/P3WQ+aCaGYShs4UJcwV6uhsc1XStcse5pbShgLdp
	 RYoY220y7p4NV5n7PwvnsPWoZZtQ3eVK9dX5HhwigG7G/7phg0u3KW1DJT9ATxdePt
	 ZAYvhB0nOd2Cc0YEJSiWXNSimRphmqNhT/u/lcK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaolei Wang <xiaolei.wang@windriver.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 199/356] net: stmmac: No need to calculate speed divider when offload is disabled
Date: Wed,  3 Jul 2024 12:38:55 +0200
Message-ID: <20240703102920.633080227@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a9b5f5ad1bac4..b1a5a02bef08e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -356,24 +356,28 @@ static int tc_setup_cbs(struct stmmac_priv *priv,
 
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



