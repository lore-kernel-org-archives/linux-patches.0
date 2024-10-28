Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159E62C697;
	Mon, 28 Oct 2024 06:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097611; cv=none; b=npo1cyNtt8eucG1hSBBjDn/83yOEhKdkEYTmoov38U2+zBkWLqXiyWnhLt9MZGRd6cDQdK2IZw87DmiIWvQZummF1V8lcM+j2pm/nZCadxknKibBUz662OsB2GuyOTSoLMWMeg1aetaj6w1b7oLHse/ajAOIiaRl6OZqQWZkEDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097611; c=relaxed/simple;
	bh=9Xn7rHLsGP7l4xfPpVMu7qBEok5CaB0iXPvMHgHpz44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RJ0fYj3KURJMV0x1yT8pnbe2nFqCt4Se7rbqWnz8V9LMAXuSlFNWXJerUvnLeK/wvBiL9EulqOc9KW+bF4vUasGvF3tnFGt7VHx+GoMy3kV7B/4ZQSs0s2nBxxkJA9s6NH5x8GwxnMgtk7A8LmS2GSjBrWr5cb3hE+2pBFLCKmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kSSin87C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kSSin87C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8C04C4CEE3;
	Mon, 28 Oct 2024 06:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097611;
	bh=9Xn7rHLsGP7l4xfPpVMu7qBEok5CaB0iXPvMHgHpz44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kSSin87CMPITJxOWVLGAV07XZOLSUK+scOvLEhhZhkkP5noRBZavf1FdfJS48KERZ
	 sDJV+4X8Zi6xtAD/Uc3Z+qGXkgKo/EUOm6vzJR32xR+S07mKm2uQzMm8SiDv7kKEzj
	 uHnmC96Ryn0elku/Px/JwnuuXI1c28ti83QgzTj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Paul Barker <paul.barker.ct@bp.renesas.com>,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 070/208] net: ravb: Only advertise Rx/Tx timestamps if hardware supports it
Date: Mon, 28 Oct 2024 07:24:10 +0100
Message-ID: <20241028062308.376388650@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8f62cc4517918..58fdc4f8dd483 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1673,20 +1673,19 @@ static int ravb_get_ts_info(struct net_device *ndev,
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



