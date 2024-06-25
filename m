Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C40413C90B;
	Tue, 25 Jun 2024 10:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309692; cv=none; b=Lrn0JEd+qZgDJpS4IH6lw03kCZWWRcnP5cJk7O+GfQaZSZD9krrxnowBmAFJ4Q0dCT14MPnc+VfIKc30Xg7xEwz4lshR99Anm86ja3pKgFJDMBvrYUxH8Q0b1Zrrn9s7xI/zakAn7wZm3KIGFQDUk9JCCOyjjiIcPrEi90WlvH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309692; c=relaxed/simple;
	bh=yuFl7TZnb/i6ZTw9mPpi2fJcHFV1j2XZgAcpc5WI7gQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ftBLzwbu5DDjy4RTYHLivSd8CzE61qalImkXf4pnM72I0wedhLRI7tuedmjR180HfOf9LT8Lrt1VbgaFM+2CfULKtISDN6MxEwuhVMVXw1xUOWg6mJbwM/eKgFgoqXRDh10preKBpp+OUvnsdsdHrqKo4ZUsm6vhLX27OrnP0t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Um0x/7mQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Um0x/7mQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85433C32781;
	Tue, 25 Jun 2024 10:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309691;
	bh=yuFl7TZnb/i6ZTw9mPpi2fJcHFV1j2XZgAcpc5WI7gQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Um0x/7mQQUkU3VcPQQIPZ38H6kVzU3KcthKO/hx3TxrXio7oiwLX+tYqbz2MAMoBb
	 JpaTKBHFDGR7MOplPB/Am/HnYLhS1f1cFVDDhH5coVuaZ8Njj1brg38YFenh+UAX3J
	 BPRXAexKt8ybLluiVBvk3LKaROUIun7aAf/6pY+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaolei Wang <xiaolei.wang@windriver.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 070/131] net: stmmac: No need to calculate speed divider when offload is disabled
Date: Tue, 25 Jun 2024 11:33:45 +0200
Message-ID: <20240625085528.603226310@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
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
index 074ff289eaf25..5eb8c6713e456 100644
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



