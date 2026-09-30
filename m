Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1C851AEC1;
	Wed, 30 Sep 2026 17:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788491; cv=none; b=PKBex+QI167yG19DOee4irAyABdEwkZ2IJgu6xoo47AQZQXpMp6LeP/RWxvGtTZraLLNfU5yHSH3dsCovrFDPO4h6IzBIFWIP8jOH81rv8ilTnrKdswiHdflmH+IgSa46V6zHWoB6eSANOPGd0Ax8LoYbd9X5d2xSIS0VLvz1us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788491; c=relaxed/simple;
	bh=YGZonm0rsOS0Uk4g/ewipk8VYvOv7Ig4WhxOAMUbie4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pxlKXnZdpZW9YnQP/qnhl72ccAXYVIPc/C9sr6trG8bsNxNJ9NY4HlOYsy7R03/OacT9nYliA+dUHkiVuY4AlzI1rhM7+0aRtA+FNwLPehnEudEMPIU4MouKY9PICTPnsDVwzPcIMwKsMtzVaGAxGzUVwJK9dFCVipsv4Nj9GxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KjKcUfYI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KjKcUfYI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E3581F000FF;
	Wed, 30 Sep 2026 17:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788490;
	bh=Vseb3DpIf2Jbc+QEcuNMrn3Bj4z7hbjEBRdvyqOifV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KjKcUfYIIm+mkUEMCVUrVYF7xswKaZ5FvmNMv3K7RdywNcHLXgwYOcK0pmCUlNbGc
	 x0H5jx9OtUdd3r13RsfKmc8nofK7ulNkvkQse0GBGGoiCUG47Ow+ipL1gwyzBT49nm
	 RJEexMWOMTzUXtb9YKNUQXtbMTwzWN7oylURYMeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Gal Pressman <gal@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 142/877] net: stmmac: do not overwrite phc_index when no PTP clock is registered
Date: Wed, 30 Sep 2026 17:17:33 +0200
Message-ID: <20260930152417.792119165@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

[ Upstream commit f0ef4b1eaed000a304726a43091588e8426ba08a ]

stmmac_get_ts_info() reports phc_index as 0 when hardware timestamping
is supported but no PTP clock has been registered yet (e.g. while the
interface is down). Zero is a valid PHC index and would make userspace
resolve the wrong clock; the absence of a clock should be reported as
-1.

The ethtool core already initializes phc_index to -1 before invoking
the get_ts_info callback (ethtool_init_tsinfo()), so just drop the
erroneous assignment.

Fixes: 9364fa7fcf12 ("net: stmmac: Remove setting of RX software timestamp")
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Link: https://patch.msgid.link/20260914-stmmac-fix-phc_index-v2-1-bf3d90373fe4@oss.qualcomm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index 2a37592a62810..ca8712a573ea0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -1206,8 +1206,6 @@ static int stmmac_get_ts_info(struct net_device *dev,
 
 		if (priv->ptp_clock)
 			info->phc_index = ptp_clock_index(priv->ptp_clock);
-		else
-			info->phc_index = 0;
 
 		info->tx_types = (1 << HWTSTAMP_TX_OFF) | (1 << HWTSTAMP_TX_ON);
 
-- 
2.53.0



