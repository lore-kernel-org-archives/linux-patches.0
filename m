Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9DE21A9B39;
	Wed, 23 Apr 2025 14:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419971; cv=none; b=NuCfxGdFgE/5lHiYhoejeFaA9P/i3HYd/3fQPTXTF+8abp4AY8xJiD2K4wCPEjXiWH2gvkbtNWappICU/qCZgR5WnfhUfFb2FdnPg3in6nqPEgd7wpL/GW7vR+orAuH84/nL4meUJPVkIx5uAhjzp8ilT3WcnWn3Pe3+OTW0vak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419971; c=relaxed/simple;
	bh=xsaTwqTGjE1aBl/t0O9OJLNvBTFjTo/TnAeoa0lnQVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N2rjk7+MOayn/qdGnYI9DeQO/9qPzcIgixE581NOud7aD9dtZTXGOGyGbJGh2Lg03ZLagLAnocoW5BUpmgmigBaIagsAETCdg73xsspVvHC5SiAfxPFQRBKyJ+ZmLv0QqJ5K7MCgqWDI6dNuy52uBfPuyV9EVfX5N3BzoEhSuf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l8PX+F4A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l8PX+F4A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E03E2C4CEE2;
	Wed, 23 Apr 2025 14:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419971;
	bh=xsaTwqTGjE1aBl/t0O9OJLNvBTFjTo/TnAeoa0lnQVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l8PX+F4AZy4N8K98rEoxiExCDVzQOIadCidTe9xKV4en9b0aB4qNPQI/XaBCFWVc4
	 7r+Xr9JKjThBG/urhrYJSPS0KjLTRWWoQna5cdda2cUV5shqJYRkx34N9oe8c48FCW
	 LUXXDGoViZpIQK/OWvpCa72GMxgnnErF19jDa9Io=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jijie Shao <shaojijie@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 048/241] net: hibmcge: fix incorrect multicast filtering issue
Date: Wed, 23 Apr 2025 16:41:52 +0200
Message-ID: <20250423142622.469227419@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jijie Shao <shaojijie@huawei.com>

[ Upstream commit 9afaaa54e3eb9b64fc07c06741897800e98ac253 ]

The driver does not support multicast filtering,
the mask must be set to 0xFFFFFFFF. Otherwise,
incorrect filtering occurs.

This patch fixes this problem.

Fixes: 37b367d60d0f ("net: hibmcge: Add unicast frame filter supported in this module")
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250410021327.590362-3-shaojijie@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hibmcge/hbg_hw.c  | 4 ++++
 drivers/net/ethernet/hisilicon/hibmcge/hbg_reg.h | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hibmcge/hbg_hw.c b/drivers/net/ethernet/hisilicon/hibmcge/hbg_hw.c
index 169e6a0bac496..56089849753dc 100644
--- a/drivers/net/ethernet/hisilicon/hibmcge/hbg_hw.c
+++ b/drivers/net/ethernet/hisilicon/hibmcge/hbg_hw.c
@@ -224,6 +224,10 @@ void hbg_hw_set_mac_filter_enable(struct hbg_priv *priv, u32 enable)
 {
 	hbg_reg_write_field(priv, HBG_REG_REC_FILT_CTRL_ADDR,
 			    HBG_REG_REC_FILT_CTRL_UC_MATCH_EN_B, enable);
+
+	/* only uc filter is supported, so set all bits of mc mask reg to 1 */
+	hbg_reg_write64(priv, HBG_REG_STATION_ADDR_LOW_MSK_0, U64_MAX);
+	hbg_reg_write64(priv, HBG_REG_STATION_ADDR_LOW_MSK_1, U64_MAX);
 }
 
 void hbg_hw_set_pause_enable(struct hbg_priv *priv, u32 tx_en, u32 rx_en)
diff --git a/drivers/net/ethernet/hisilicon/hibmcge/hbg_reg.h b/drivers/net/ethernet/hisilicon/hibmcge/hbg_reg.h
index e7bc5435d51ba..c254f4036329f 100644
--- a/drivers/net/ethernet/hisilicon/hibmcge/hbg_reg.h
+++ b/drivers/net/ethernet/hisilicon/hibmcge/hbg_reg.h
@@ -82,6 +82,8 @@
 #define HBG_REG_STATION_ADDR_HIGH_4_ADDR	(HBG_REG_SGMII_BASE + 0x0224)
 #define HBG_REG_STATION_ADDR_LOW_5_ADDR		(HBG_REG_SGMII_BASE + 0x0228)
 #define HBG_REG_STATION_ADDR_HIGH_5_ADDR	(HBG_REG_SGMII_BASE + 0x022C)
+#define HBG_REG_STATION_ADDR_LOW_MSK_0		(HBG_REG_SGMII_BASE + 0x0230)
+#define HBG_REG_STATION_ADDR_LOW_MSK_1		(HBG_REG_SGMII_BASE + 0x0238)
 
 /* PCU */
 #define HBG_REG_TX_FIFO_THRSLD_ADDR		(HBG_REG_SGMII_BASE + 0x0420)
-- 
2.39.5



