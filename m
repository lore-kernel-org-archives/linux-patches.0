Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08B8263C90;
	Tue,  8 Apr 2025 11:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110925; cv=none; b=ixjNlJlMpmfUAiY/UZfoebT8EYRRg8ZdYxXihvTws4DhSj+4/SDzaWqNFjiBF+d0ExcWajtSlSzHJcobo+Hnnl/xyge6OuQOFTHjzXKtfLBYbT1480jg0KkqnSYZhENMhHRKGBkmAx4uwTqU8mt+7+g8wjAAKtyvGS5pCeetfgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110925; c=relaxed/simple;
	bh=KOCaH50RVXHcppQLXpmqKFVcTsd8u/8s7tHwZEuPCNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BBBjLfY7wsQx2nZeOACG5UkEEFNgSOLzD0vfpjLFW9VV+THg+S9m5k1qOcgV5ohyEPd863dLcFkIHvbdd6LwGjZYSjV69DhCoxxTs/49FuXbj6j6BzpebvywAurtIf1I70Z0Olwb5kVIMa4o00+t6SxmLLARdH6QUZ05CNb91B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m0vpKbGR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m0vpKbGR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F5C6C4CEE5;
	Tue,  8 Apr 2025 11:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110924;
	bh=KOCaH50RVXHcppQLXpmqKFVcTsd8u/8s7tHwZEuPCNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m0vpKbGR9f21Eg90ZNjlxcxR9lCAy9D5b0z3BElre181eCOhG2n/+mgii4E93bJfS
	 EOOIIr2gq0KQyP3sOCm2YaI2xX2C2/6RXiNQVzfpVxLQJx75kwRWMtRIQmfU9hGzhE
	 Ja7Ph/+wYVb3U+cY4Wgrecg8vezFlu6Y5IxYLVaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 244/731] net: dsa: sja1105: reject other RX filters than HWTSTAMP_FILTER_PTP_V2_L2_EVENT
Date: Tue,  8 Apr 2025 12:42:21 +0200
Message-ID: <20250408104919.958307912@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit b6a177b559717b707087114e08537fd47a4d1aca ]

This is all that we can support timestamping, so we shouldn't accept
anything else. Also see sja1105_hwtstamp_get().

To avoid erroring out in an inconsistent state, operate on copies of
priv->hwts_rx_en and priv->hwts_tx_en, and write them back when nothing
else can fail anymore.

Fixes: a602afd200f5 ("net: dsa: sja1105: Expose PTP timestamping ioctls to userspace")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250318115716.2124395-3-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/sja1105/sja1105_ptp.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index a1f4ca6ad888f..08b45fdd1d248 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -61,17 +61,21 @@ enum sja1105_ptp_clk_mode {
 int sja1105_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr)
 {
 	struct sja1105_private *priv = ds->priv;
+	unsigned long hwts_tx_en, hwts_rx_en;
 	struct hwtstamp_config config;
 
 	if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
 		return -EFAULT;
 
+	hwts_tx_en = priv->hwts_tx_en;
+	hwts_rx_en = priv->hwts_rx_en;
+
 	switch (config.tx_type) {
 	case HWTSTAMP_TX_OFF:
-		priv->hwts_tx_en &= ~BIT(port);
+		hwts_tx_en &= ~BIT(port);
 		break;
 	case HWTSTAMP_TX_ON:
-		priv->hwts_tx_en |= BIT(port);
+		hwts_tx_en |= BIT(port);
 		break;
 	default:
 		return -ERANGE;
@@ -79,15 +83,21 @@ int sja1105_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr)
 
 	switch (config.rx_filter) {
 	case HWTSTAMP_FILTER_NONE:
-		priv->hwts_rx_en &= ~BIT(port);
+		hwts_rx_en &= ~BIT(port);
 		break;
-	default:
-		priv->hwts_rx_en |= BIT(port);
+	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
+		hwts_rx_en |= BIT(port);
 		break;
+	default:
+		return -ERANGE;
 	}
 
 	if (copy_to_user(ifr->ifr_data, &config, sizeof(config)))
 		return -EFAULT;
+
+	priv->hwts_tx_en = hwts_tx_en;
+	priv->hwts_rx_en = hwts_rx_en;
+
 	return 0;
 }
 
-- 
2.39.5



