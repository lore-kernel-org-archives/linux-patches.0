Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73CB31E3DD6;
	Mon, 21 Oct 2024 10:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506905; cv=none; b=skTpXD87hHsgwFcyseGmj27mxH5dt8gppvwABauTRpfFLu7p5zxEbq1hlccotPwb847BeWb4hz9yEedfOBwYz/M74xLufxIwdNLSAmeGEeefjVZEzinlCDMHYAOJXsjiNRydaZAlYWg/wdd6ST3XncTLxpSOkEycdYQ+V1Vhtoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506905; c=relaxed/simple;
	bh=DDod9Oxq0VT2iTrivItE+GhXd/BkOpMLrEYGb+kyN+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VuFcHeTk9V5oI5exlknAXMBdRYcM/D2shUmM10/KTIpqM6gYXYKSDhjZymGDFbDSWeLUHcsKW2cTi6JOeIzaBHB1MXSEdFI5m8xsAaAi03lwXpfkBpaUlgdCe2kSAOqpy8N62YoFpwZU/qK8MDiqYjR9Kl5tvLTHJtafsiqCGCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DjxFwZUh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DjxFwZUh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7DE1C4CEC3;
	Mon, 21 Oct 2024 10:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506905;
	bh=DDod9Oxq0VT2iTrivItE+GhXd/BkOpMLrEYGb+kyN+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DjxFwZUhiRJEQ9V7GKl5BVlLiWuZwvIRGymsiEcPc00AAO/xYBlb0KD95qkWbbcAS
	 vR7N2GBh9In3uJGviBL2klEtrJed6piMYuxM0yO0qbUFh4yOSjr+m+bkEzs9kE9AOB
	 7TfQxL0xVN5dRCe+rIwlFsAsViCWm+Bhp5Cm6GBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 007/124] net: enetc: block concurrent XDP transmissions during ring reconfiguration
Date: Mon, 21 Oct 2024 12:23:31 +0200
Message-ID: <20241021102257.001402115@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
References: <20241021102256.706334758@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Fang <wei.fang@nxp.com>

commit c728a95ccf2a8ba544facfc30a4418d4c68c39f0 upstream.

When testing the XDP_REDIRECT function on the LS1028A platform, we
found a very reproducible issue that the Tx frames can no longer be
sent out even if XDP_REDIRECT is turned off. Specifically, if there
is a lot of traffic on Rx direction, when XDP_REDIRECT is turned on,
the console may display some warnings like "timeout for tx ring #6
clear", and all redirected frames will be dropped, the detailed log
is as follows.

root@ls1028ardb:~# ./xdp-bench redirect eno0 eno2
Redirecting from eno0 (ifindex 3; driver fsl_enetc) to eno2 (ifindex 4; driver fsl_enetc)
[203.849809] fsl_enetc 0000:00:00.2 eno2: timeout for tx ring #5 clear
[204.006051] fsl_enetc 0000:00:00.2 eno2: timeout for tx ring #6 clear
[204.161944] fsl_enetc 0000:00:00.2 eno2: timeout for tx ring #7 clear
eno0->eno2     1420505 rx/s       1420590 err,drop/s      0 xmit/s
  xmit eno0->eno2    0 xmit/s     1420590 drop/s     0 drv_err/s     15.71 bulk-avg
eno0->eno2     1420484 rx/s       1420485 err,drop/s      0 xmit/s
  xmit eno0->eno2    0 xmit/s     1420485 drop/s     0 drv_err/s     15.71 bulk-avg

By analyzing the XDP_REDIRECT implementation of enetc driver, the
driver will reconfigure Tx and Rx BD rings when a bpf program is
installed or uninstalled, but there is no mechanisms to block the
redirected frames when enetc driver reconfigures rings. Similarly,
XDP_TX verdicts on received frames can also lead to frames being
enqueued in the Tx rings. Because XDP ignores the state set by the
netif_tx_wake_queue() API, so introduce the ENETC_TX_DOWN flag to
suppress transmission of XDP frames.

Fixes: c33bfaf91c4c ("net: enetc: set up XDP program under enetc_reconfigure()")
Cc: stable@vger.kernel.org
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20241010092056.298128-3-wei.fang@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.c |   14 ++++++++++++++
 drivers/net/ethernet/freescale/enetc/enetc.h |    1 +
 2 files changed, 15 insertions(+)

--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -902,6 +902,7 @@ static bool enetc_clean_tx_ring(struct e
 
 	if (unlikely(tx_frm_cnt && netif_carrier_ok(ndev) &&
 		     __netif_subqueue_stopped(ndev, tx_ring->index) &&
+		     !test_bit(ENETC_TX_DOWN, &priv->flags) &&
 		     (enetc_bd_unused(tx_ring) >= ENETC_TXBDS_MAX_NEEDED))) {
 		netif_wake_subqueue(ndev, tx_ring->index);
 	}
@@ -1380,6 +1381,9 @@ int enetc_xdp_xmit(struct net_device *nd
 	int xdp_tx_bd_cnt, i, k;
 	int xdp_tx_frm_cnt = 0;
 
+	if (unlikely(test_bit(ENETC_TX_DOWN, &priv->flags)))
+		return -ENETDOWN;
+
 	enetc_lock_mdio();
 
 	tx_ring = priv->xdp_tx_ring[smp_processor_id()];
@@ -1605,6 +1609,12 @@ static int enetc_clean_rx_ring_xdp(struc
 			break;
 		case XDP_TX:
 			tx_ring = priv->xdp_tx_ring[rx_ring->index];
+			if (unlikely(test_bit(ENETC_TX_DOWN, &priv->flags))) {
+				enetc_xdp_drop(rx_ring, orig_i, i);
+				tx_ring->stats.xdp_tx_drops++;
+				break;
+			}
+
 			xdp_tx_bd_cnt = enetc_rx_swbd_to_xdp_tx_swbd(xdp_tx_arr,
 								     rx_ring,
 								     orig_i, i);
@@ -2466,6 +2476,8 @@ void enetc_start(struct net_device *ndev
 	enetc_enable_bdrs(priv);
 
 	netif_tx_start_all_queues(ndev);
+
+	clear_bit(ENETC_TX_DOWN, &priv->flags);
 }
 EXPORT_SYMBOL_GPL(enetc_start);
 
@@ -2523,6 +2535,8 @@ void enetc_stop(struct net_device *ndev)
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	int i;
 
+	set_bit(ENETC_TX_DOWN, &priv->flags);
+
 	netif_tx_stop_all_queues(ndev);
 
 	enetc_disable_bdrs(priv);
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -328,6 +328,7 @@ enum enetc_active_offloads {
 
 enum enetc_flags_bit {
 	ENETC_TX_ONESTEP_TSTAMP_IN_PROGRESS = 0,
+	ENETC_TX_DOWN,
 };
 
 /* interrupt coalescing modes */


