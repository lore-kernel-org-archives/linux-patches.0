Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F4654B7A44;
	Thu, 17 Sep 2026 18:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670374; cv=none; b=H8P5nRd0YeimXeMobor6EVbpDh2MJT30wyyOBhjOPd3eVoJdNA3dF1bkiV4nsFMsCTH23g1W2DzwGQHmSxqvD2zD8LVMhWCVSWhIxvRpv31UBHLcce2m8KxEGLOsTyfW9u1+7JjjednBg2FJi17sf4vQNzNBBrS4TXYXjkRJzt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670374; c=relaxed/simple;
	bh=3HEkHjqQbdKoZhBvwiSWnCIACM1Ezz7dmwaEjr5dyPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X8ZJ+vAN6UIq1wRGZuXmhvHWv0OEVDq/1lJT1cjNqpCWiLEDvUZkH/k6UGri2sc5fZMvSHinJi+UHfPHwZMIVR1/QtQvLVvuKq0WkzlEHAJHIHx7DXO7PA6IG6OO8Yz7CyayH2kbWefaOXwO4WxPlUtfuRtDl4Fw5MviVqsneGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QBthYwlm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QBthYwlm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BA571F000FF;
	Thu, 17 Sep 2026 18:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670373;
	bh=c3uRPPohJkTvbEXOrexCsxKrhMznHWQG1CaBQ2Pe5EQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QBthYwlm45z1RjbYwY7SmhkTomQxFCh3k0rqsUCvq9BCi0Vrc0brcEPSCBjjrlk1r
	 tRoQNuLsXxsQDGW5o+bGbKz+ufM1I1XO5YUp3P6o92FZo2dRyQQ/lyqbbuL09+Vqgi
	 8QZbPmpWF1iuQj1Pe542D5hmxCn3QB0iFMzeJiPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0636/1102] net: stmmac: reconfigure RX packet parser table in stmmac_hw_setup() after reset
Date: Thu, 17 Sep 2026 16:09:39 +0100
Message-ID: <20260917151556.090594145@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

[ Upstream commit 6b8fed2675fb75d23e6cf2b7e49c94926e884b34 ]

The core software reset issued in stmmac_init_dma_engine() during
ndo_open() callback clears the MTL RX packet parser registers, but
stmmac_rxp_config() is only invoked from the cls_u32 add/delete paths.
After an ifdown/ifup cycle the hardware therefore runs with the default
all-pass table while priv->tc_entries still reports the filters as
installed. Re-apply the RX packet parser table from priv->tc_entries in
stmmac_hw_setup(), right after the software reset, so the filters are
restored when the interface is brought up again.

Fixes: 4dbbe8dde848 ("net: stmmac: Add support for U32 TC filter using Flexible RX Parser")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Link: https://patch.msgid.link/20260831-stmmac_tc_cls32_reconfigure-v1-1-21cb459e64ae@oss.qualcomm.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 3074e322a2cc2..4dcd29e814083 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3423,6 +3423,14 @@ static int stmmac_hw_setup(struct net_device *dev, bool ptp_register)
 	/* Initialize MTL*/
 	stmmac_mtl_configuration(priv);
 
+	/* Apply the RX packet parser table */
+	if (priv->tc_entries) {
+		ret = stmmac_rxp_config(priv, priv->hw->pcsr, priv->tc_entries,
+					priv->tc_entries_max);
+		if (ret)
+			return ret;
+	}
+
 	/* Initialize Safety Features */
 	stmmac_safety_feat_configuration(priv);
 
-- 
2.53.0



