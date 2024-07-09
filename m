Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D1614EC4D;
	Tue,  9 Jul 2024 11:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524219; cv=none; b=CO8bxQw1A8Wf+H4y7KYWtYBFa/VshEYYc5AW/WURJffBfibKCWVAijk5WUuV3A0t8V9oDt1sKiW61c11HMiZZOUHPnkv3hnhgiqL6inQs2PUpVMBpaGYPvMUm1cVrtuU3PIwwvO39K0fP37McsHhSYM4x0h/g7RC3hEILuI+/bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524219; c=relaxed/simple;
	bh=fngHy74i6TQKnCDlQCF7hC+lh/AL5Tq79JIxxnBRFj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SXEeWpjtcXMniObLUAw+JBkbrUztXCEbCbCuuLDi3QH1X5pf3XwG9pkoEuxKkCyisuQT9pnnI2nb/Kjr25mbwdO00dqlOXpunlqAU4GFS0Kk2M3ZjupY5NG/aNtfC4g0tvO4F3RCoBvOpBE1Hpx4IQRPQDam6X+bRAGlSBoqyG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2knySe8D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2knySe8D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B243C3277B;
	Tue,  9 Jul 2024 11:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524219;
	bh=fngHy74i6TQKnCDlQCF7hC+lh/AL5Tq79JIxxnBRFj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2knySe8DA/jTIsIGmxS2nGAGNmQ+6SkadMHqmKt5TrZUYZpfNMgPlLt1L4wPG0NzF
	 EodOAIaJfbxVw0E96iS/IMkSJba+JiZqNPWjCzvXcZagEad/YuL+AxYcWka72PzzgS
	 W0DNe/kLWGViRAOdC6oMjvWkZTYdvc7BH2qjUJk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Furong Xu <0x1207@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 111/197] net: stmmac: enable HW-accelerated VLAN stripping for gmac4 only
Date: Tue,  9 Jul 2024 13:09:25 +0200
Message-ID: <20240709110713.251653240@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

From: Furong Xu <0x1207@gmail.com>

[ Upstream commit 8eb301bd7b0f45d36e663ecbe59b7c80b9863950 ]

Commit 750011e239a5 ("net: stmmac: Add support for HW-accelerated VLAN
stripping") enables MAC level VLAN tag stripping for all MAC cores, but
leaves set_hw_vlan_mode() and rx_hw_vlan() un-implemented for both gmac
and xgmac.

On gmac and xgmac, ethtool reports rx-vlan-offload is on, both MAC and
driver do nothing about VLAN packets actually, although VLAN works well.

Driver level stripping should be used on gmac and xgmac for now.

Fixes: 750011e239a5 ("net: stmmac: Add support for HW-accelerated VLAN stripping")
Signed-off-by: Furong Xu <0x1207@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 7c6fb14b55550..39e8340446c71 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7662,9 +7662,10 @@ int stmmac_dvr_probe(struct device *device,
 #ifdef STMMAC_VLAN_TAG_USED
 	/* Both mac100 and gmac support receive VLAN tag detection */
 	ndev->features |= NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_HW_VLAN_STAG_RX;
-	ndev->hw_features |= NETIF_F_HW_VLAN_CTAG_RX;
-	priv->hw->hw_vlan_en = true;
-
+	if (priv->plat->has_gmac4) {
+		ndev->hw_features |= NETIF_F_HW_VLAN_CTAG_RX;
+		priv->hw->hw_vlan_en = true;
+	}
 	if (priv->dma_cap.vlhash) {
 		ndev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
 		ndev->features |= NETIF_F_HW_VLAN_STAG_FILTER;
-- 
2.43.0



