Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E1F918C03D;
	Mon, 28 Oct 2024 06:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097243; cv=none; b=Fz3FZ2sTVYPb2lbnNeW26LDZEmhtWIqmN+dvOjRtBVCHjRj8Cxyzpyhec5guLl+SHP+aYvcQfFapzFvOPzvDbNf7893UfpJtBktcZWFkzkkq0tuazDuvXyq7/aoKVlv118Gb5RjaBG5SECsI1Y5pnqqaMKb/FY78k5BtzjokSkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097243; c=relaxed/simple;
	bh=OgrRwVJduXMH0kPanKrVzVr/QDjxPqubsyZXJfYlWEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BjYzCm/mWkyJ8nifz7dHA78HMzOaJrF3DCtuvnghD1smdRe7FzQrwVl1odqSaJVbxnl+P+ITh71hZ/30FCKpzLbVbc4zrgsw+gr9wS4VqoEI3AHYYd9ZzUIgPwj+6X2IHCysKHt6dwfs0SJ3VTOZXgQ1Udj2OnhIuc9FM/CwgKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MgnCQjGf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MgnCQjGf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E4E8C4CEC7;
	Mon, 28 Oct 2024 06:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097242;
	bh=OgrRwVJduXMH0kPanKrVzVr/QDjxPqubsyZXJfYlWEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MgnCQjGfw1iNeqdu0z7DzLS2CdSU6Q4Bw6/b4eHH8w0o127thuc5yMDMBMJA8r7L2
	 W5ZLrAzrd0TUVtOcoGYBaAM3PzmV6jgMVCyhwBYQKnVJijL3qvKdm70TqeNA4mJuC3
	 MgpAS2HNtKIcJtQ899fB+mWYfsUnIpOvXvEOrr4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Paul Barker <paul.barker.ct@bp.renesas.com>,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 045/137] net: ravb: Only advertise Rx/Tx timestamps if hardware supports it
Date: Mon, 28 Oct 2024 07:24:42 +0100
Message-ID: <20241028062259.986112302@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 96467b8d48b00..705010ea1d568 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1689,20 +1689,19 @@ static int ravb_get_ts_info(struct net_device *ndev,
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



