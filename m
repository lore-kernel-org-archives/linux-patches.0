Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A9D48837;
	Mon, 28 Oct 2024 06:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098113; cv=none; b=c1XpO3tLkjusQsIN9eBhtzZIzYEc/9cYPkLwLcupd3D+9VXYKA0p1UmMXxkEU5BBi8SYALlRVju+ahwlflnDW3Bd3bcTQXiLmW+5+UzKtJ2Gb3LchlfGDKS9NT1BBP6Koyqgu3VdlyXPgMc9kz/33EPlmh2fOISFlat7DhKIy4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098113; c=relaxed/simple;
	bh=NOTCRZUKBM5Z9uqP35LnREhMt6AGNl4ZoV5Fo7YqLyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CTwx8QD99l25+nIbaQbso0lzBT4BTA94Pv+e7IUxIh/yXbT7OPho/CnIK71xjNhq2L0TRmJw4VWhPksjXC2e0GeJpx2JnkLa6jmZqJdtj8j/qZmrdAz3gJaM90d7NLE8CGst+eiZg2dMOtMVgSsH6i/boNFr2Jb1VFZlNBEYaKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=piyUNpix; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="piyUNpix"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6DC9C4CEC3;
	Mon, 28 Oct 2024 06:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098112;
	bh=NOTCRZUKBM5Z9uqP35LnREhMt6AGNl4ZoV5Fo7YqLyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=piyUNpixoKKYaDVyQ7A8emv80h9mB560e9yG0Snl+QLQSdkzbV5McD9Ysj6U4myhr
	 NE+F6IN3NTee7Pweu7v4I3CVMVTPTWt7G/nXsaGCRQJqQI4CbPDNUQAN63dnvXrgVc
	 eNaiD2Q8WS/y8SVF8D4z0psfTqvfMmkvP9usxENo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Paul Barker <paul.barker.ct@bp.renesas.com>,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 082/261] net: ravb: Only advertise Rx/Tx timestamps if hardware supports it
Date: Mon, 28 Oct 2024 07:23:44 +0100
Message-ID: <20241028062314.085203120@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

[ Upstream commit 126e799602f45e9ce1ded03ee9eadda68bf470e0 ]

Recent work moving the reporting of Rx software timestamps to the core
[1] highlighted an issue where hardware time stamping was advertised
for the platforms where it is not supported.

Fix this by covering advertising support for hardware timestamps only if
the hardware supports it. Due to the Tx implementation in RAVB software
Tx timestamping is also only considered if the hardware supports
hardware timestamps. This should be addressed in future, but this fix
only reflects what the driver currently implements.

1. Commit 277901ee3a26 ("ravb: Remove setting of RX software timestamp")

Fixes: 7e09a052dc4e ("ravb: Exclude gPTP feature support for RZ/G2L")
Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Paul Barker <paul.barker.ct@bp.renesas.com>
Tested-by: Paul Barker <paul.barker.ct@bp.renesas.com>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Link: https://patch.msgid.link/20241014124343.3875285-1-niklas.soderlund+renesas@ragnatech.se
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/ravb_main.c | 25 ++++++++++++------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index d2a6518532f37..907af4651c553 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1750,20 +1750,19 @@ static int ravb_get_ts_info(struct net_device *ndev,
 	struct ravb_private *priv = netdev_priv(ndev);
 	const struct ravb_hw_info *hw_info = priv->info;
 
-	info->so_timestamping =
-		SOF_TIMESTAMPING_TX_SOFTWARE |
-		SOF_TIMESTAMPING_TX_HARDWARE |
-		SOF_TIMESTAMPING_RX_HARDWARE |
-		SOF_TIMESTAMPING_RAW_HARDWARE;
-	info->tx_types = (1 << HWTSTAMP_TX_OFF) | (1 << HWTSTAMP_TX_ON);
-	info->rx_filters =
-		(1 << HWTSTAMP_FILTER_NONE) |
-		(1 << HWTSTAMP_FILTER_PTP_V2_L2_EVENT) |
-		(1 << HWTSTAMP_FILTER_ALL);
-	if (hw_info->gptp || hw_info->ccc_gac)
+	if (hw_info->gptp || hw_info->ccc_gac) {
+		info->so_timestamping =
+			SOF_TIMESTAMPING_TX_SOFTWARE |
+			SOF_TIMESTAMPING_TX_HARDWARE |
+			SOF_TIMESTAMPING_RX_HARDWARE |
+			SOF_TIMESTAMPING_RAW_HARDWARE;
+		info->tx_types = (1 << HWTSTAMP_TX_OFF) | (1 << HWTSTAMP_TX_ON);
+		info->rx_filters =
+			(1 << HWTSTAMP_FILTER_NONE) |
+			(1 << HWTSTAMP_FILTER_PTP_V2_L2_EVENT) |
+			(1 << HWTSTAMP_FILTER_ALL);
 		info->phc_index = ptp_clock_index(priv->ptp.clock);
-	else
-		info->phc_index = 0;
+	}
 
 	return 0;
 }
-- 
2.43.0



