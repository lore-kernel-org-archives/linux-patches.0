Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E1151008;
	Tue, 23 Jan 2024 00:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970138; cv=none; b=dPy+4sPdIuG2C5UuL4QdBUC2UXi/w7M2ouWTKkMOlLZXUJSJvEhNwaHHr3gYag5WbQ2LTRlBPDyXiUw74dtmpp2rmusMqGifyuGphscxxc5J5SixO9lVj9YU9uta+39cae7OlsV4u7RKu9VNdOG+EpP/09l7DgA9KQXEpEkTqFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970138; c=relaxed/simple;
	bh=ExfK1FQ2wB/uzX1vbHOFj1zFy5t4jII+GINI3DEoKOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fm7ScgEVJbBiungRSSx90CrpuIWQdPkDXUZpgp6+ICin1uTE2CuJ4HqRr7h7M2QCOU0lwOtO+Dwf9Dc44wDQ5EjN+wl03OJd1FBii25FPtpLb7nNQAHzGaA0UzNFqaSQouUDJKtiFHJuEoEfglhJ191mH/TUgu9kudGIemeiCfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LXIL1w7y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LXIL1w7y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68CE3C433C7;
	Tue, 23 Jan 2024 00:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970137;
	bh=ExfK1FQ2wB/uzX1vbHOFj1zFy5t4jII+GINI3DEoKOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LXIL1w7yX6ZDmks/ym0+Q8TY3JxkEFdnRale8bV7+62/RLq9utpur1z4jf0Cipemv
	 ceeFTzAgs1vRSCFbvzgzamF5C3VscnqPxuC2FI2F76SzzBfrGofkSJbq4uy8AT82eb
	 XxMjSXIojsvlo/jDDCOGFZex2fyutFPX+Npet9AU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sneh Shah <quic_snehshah@quicinc.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>,
	Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH 6.7 597/641] net: stmmac: Fix ethool link settings ops for integrated PCS
Date: Mon, 22 Jan 2024 15:58:21 -0800
Message-ID: <20240122235836.886484889@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sneh Shah <quic_snehshah@quicinc.com>

[ Upstream commit 08300adac3b8dab9e2fd3be0155c7d3093c755f4 ]

Currently get/set_link_ksettings ethtool ops are dependent on PCS.
When PCS is integrated, it will not have separate link config.
Bypass configuring and checking PCS for integrated PCS.

Fixes: aa571b6275fb ("net: stmmac: add new switch to struct plat_stmmacenet_data")
Tested-by: Andrew Halaney <ahalaney@redhat.com> # sa8775p-ride
Signed-off-by: Sneh Shah <quic_snehshah@quicinc.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index 112a36a698f1..bfd146ad6937 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -311,8 +311,9 @@ static int stmmac_ethtool_get_link_ksettings(struct net_device *dev,
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 
-	if (priv->hw->pcs & STMMAC_PCS_RGMII ||
-	    priv->hw->pcs & STMMAC_PCS_SGMII) {
+	if (!(priv->plat->flags & STMMAC_FLAG_HAS_INTEGRATED_PCS) &&
+	    (priv->hw->pcs & STMMAC_PCS_RGMII ||
+	     priv->hw->pcs & STMMAC_PCS_SGMII)) {
 		struct rgmii_adv adv;
 		u32 supported, advertising, lp_advertising;
 
@@ -397,8 +398,9 @@ stmmac_ethtool_set_link_ksettings(struct net_device *dev,
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 
-	if (priv->hw->pcs & STMMAC_PCS_RGMII ||
-	    priv->hw->pcs & STMMAC_PCS_SGMII) {
+	if (!(priv->plat->flags & STMMAC_FLAG_HAS_INTEGRATED_PCS) &&
+	    (priv->hw->pcs & STMMAC_PCS_RGMII ||
+	     priv->hw->pcs & STMMAC_PCS_SGMII)) {
 		/* Only support ANE */
 		if (cmd->base.autoneg != AUTONEG_ENABLE)
 			return -EINVAL;
-- 
2.43.0



