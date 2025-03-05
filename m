Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0351A5BB7;
	Wed,  5 Mar 2025 18:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198326; cv=none; b=RoilKKXNZntKF0gRDvoKiNB1inbkLQn6Xv1pZe6NppSRGtlg/1xAK5BfpqhTBxbnVmSx5pP1lnBFkC7MlRz7KuxO4kcVpBdZ559ApBT5OeNGDGuRARQJ31OmedERO4XwozYAnBxUfVzmvxV/2GTWJuxg4mC9plm1gIOvKsJ9N3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198326; c=relaxed/simple;
	bh=kXlZ6Org4ZXEUkziUfI/vVi/ABqpcMV2McWrDezDr4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F9eMx1EeKwj7F8+K+Yg6UjZlp4L2sLx82D2T22jrqIvDQfVZrVr0V+He9rum0SDzZc5YHi2EOQ6exk+0LAlS0UWs6JaIkZILJTY9M4/LVIH7cRpbeQQ+hIbD4qF1c5vEHZAhL1owCw4XOTOFa6PkUAVIzLfcuKXXdJ9sQXEJNhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EjjCsrFD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EjjCsrFD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A911CC4CED1;
	Wed,  5 Mar 2025 18:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198326;
	bh=kXlZ6Org4ZXEUkziUfI/vVi/ABqpcMV2McWrDezDr4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EjjCsrFDDIuEkJRiwDqDj9C0FoZCdsEDXpY5gnQm+Dchaolzd9ucilHciMAO+Telt
	 JKTD+Pm748offHO8oPCK4xFe0Gv2muzucubRhO8pr3m6FmDts8qH6M7N7W2y+rzbPa
	 pxloAYCMuBPGJhmlYSih0/OKR9PVfY4gxC9Nnf1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 113/150] net: enetc: VFs do not support HWTSTAMP_TX_ONESTEP_SYNC
Date: Wed,  5 Mar 2025 18:49:02 +0100
Message-ID: <20250305174508.358101304@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Fang <wei.fang@nxp.com>

commit a562d0c4a893eae3ea51d512c4d90ab858a6b7ec upstream.

Actually ENETC VFs do not support HWTSTAMP_TX_ONESTEP_SYNC because only
ENETC PF can access PMa_SINGLE_STEP registers. And there will be a crash
if VFs are used to test one-step timestamp, the crash log as follows.

[  129.110909] Unable to handle kernel paging request at virtual address 00000000000080c0
[  129.287769] Call trace:
[  129.290219]  enetc_port_mac_wr+0x30/0xec (P)
[  129.294504]  enetc_start_xmit+0xda4/0xe74
[  129.298525]  enetc_xmit+0x70/0xec
[  129.301848]  dev_hard_start_xmit+0x98/0x118

Fixes: 41514737ecaa ("enetc: add get_ts_info interface for ethtool")
Cc: stable@vger.kernel.org
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20250224111251.1061098-5-wei.fang@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.c         |    3 +++
 drivers/net/ethernet/freescale/enetc/enetc_ethtool.c |    7 +++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2945,6 +2945,9 @@ static int enetc_hwtstamp_set(struct net
 		new_offloads |= ENETC_F_TX_TSTAMP;
 		break;
 	case HWTSTAMP_TX_ONESTEP_SYNC:
+		if (!enetc_si_is_pf(priv->si))
+			return -EOPNOTSUPP;
+
 		new_offloads &= ~ENETC_F_TX_TSTAMP_MASK;
 		new_offloads |= ENETC_F_TX_ONESTEP_SYNC_TSTAMP;
 		break;
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -843,6 +843,7 @@ static int enetc_set_coalesce(struct net
 static int enetc_get_ts_info(struct net_device *ndev,
 			     struct kernel_ethtool_ts_info *info)
 {
+	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	int *phc_idx;
 
 	phc_idx = symbol_get(enetc_phc_index);
@@ -863,8 +864,10 @@ static int enetc_get_ts_info(struct net_
 				SOF_TIMESTAMPING_TX_SOFTWARE;
 
 	info->tx_types = (1 << HWTSTAMP_TX_OFF) |
-			 (1 << HWTSTAMP_TX_ON) |
-			 (1 << HWTSTAMP_TX_ONESTEP_SYNC);
+			 (1 << HWTSTAMP_TX_ON);
+
+	if (enetc_si_is_pf(priv->si))
+		info->tx_types |= (1 << HWTSTAMP_TX_ONESTEP_SYNC);
 
 	info->rx_filters = (1 << HWTSTAMP_FILTER_NONE) |
 			   (1 << HWTSTAMP_FILTER_ALL);


