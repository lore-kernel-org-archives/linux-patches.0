Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E67F4DE728;
	Wed, 30 Sep 2026 15:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782979; cv=none; b=orm7gyUDsrdRkVon2W7AkhnBy6eCCanyCL8CLcfuket99f8gk1U38wB39xU1WlDNWHlTohNYKIWmzroK9F9yqvww9Ty5R8LekyUmQvuTn42g5mxsJ/+KCcNM69VPn/eptLufB8H6qE9XQ56j0UmIibIoxG1tEWsjWvk8l/E1LJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782979; c=relaxed/simple;
	bh=LItCxneHKGdJammziRiXFTswjqjc6p/kj1lGRMu9O4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e4HIWJSmpUfcJibOpuJJpfE3464ffbyBTLc4IZMEFMTN0GuGNf0PFE4YkRKmw2HupAFRiwOf8sFLGj+S6+KyABBdY9DmO7aj+Y9/VTkMCBPHRPjsZEwAHKvwY4N0mbHPf1zn22y1EajfPIGosZUfE6oJl3rWhhLcQ4r2l+dRW/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sw1Tfs/L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sw1Tfs/L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D90F81F00899;
	Wed, 30 Sep 2026 15:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782973;
	bh=4i5WEDsFQR7yNSVbAi8eQlOZEBG7Z1God61sePOkMtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sw1Tfs/L/q382jEZ/MNt4rBH0wkyq1LgunjEus29TBJC1zG0rlmzU8kVzLELyRTiH
	 AByHCrR/LK6qnNfGZTv7rzctlm2fBICgiehQzHScORPlklY7UdJugvWdwbA1qUkyaw
	 Myi1lJIlLaMe+VbX9+UdFPV04UIDnZKTh2I2Modc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 235/595] net: stmmac: reconfigure RX packet parser table in stmmac_hw_setup() after reset
Date: Wed, 30 Sep 2026 17:22:08 +0200
Message-ID: <20260930152352.776948446@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index ac278d81f1614..75d7096ab20b7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2743,6 +2743,14 @@ static int stmmac_hw_setup(struct net_device *dev, bool ptp_register)
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



