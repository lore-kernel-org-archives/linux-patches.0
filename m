Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE8026ED40;
	Wed, 28 Jan 2026 16:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769616152; cv=none; b=O8v6PwF4Q0Q5oqJHq3Ur1x1qprKhN71nP0PY7OPvc+9I2/KfW3Ns9EEoTVXHtdmKnUJtxIeShGk5T0OJjzA1IsFosmvCIVpSIe2c97kF1/HW0tJA/WNuBRBJMvVlLpz5RpQjB8CTqMJLsbES0kcq/key+DERGzuhhNsIqqIlW8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769616152; c=relaxed/simple;
	bh=DVJS4Vk27DLKjPYKaLt/pOcJ5X74VY4TxB3rXXhqofI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NnwQYa3LBhO8ea4EE3KnbeocXtf4fJLvELp7FBSJyTcWIcDHDNCNc16lCZSynZPa4vGQrg2VkqqO0RNBRP1QpL+0osWY3qD32XdLQqRWQzc7qjALNnlEn6qVy+tZHDLfyD45OIjVGZq55Pv+0pGN9QyP+o9m6lEEKtbee34Z9s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OatCfXwn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OatCfXwn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1910BC4CEF1;
	Wed, 28 Jan 2026 16:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769616152;
	bh=DVJS4Vk27DLKjPYKaLt/pOcJ5X74VY4TxB3rXXhqofI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OatCfXwn1QGDztmrN3rATypQ8LenoUcCvr+9L0ymPbEWxvLVvkHi4i+18q5yXAi9Y
	 rbcc6FCZhNR7BnEVtjTRKxbXc0jhLhk0gVqehoHOMQIKn1/3oA72bmsMlIy4P/h3fK
	 0gCrVtFsk3VBOJEIiCxcZP++HhmaRKIsxhtN6L5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Clemens Gruber <mail@clemensgruber.at>,
	Wei Fang <wei.fang@nxp.com>,
	Paolo Abeni <pabeni@redhat.com>,
	stable@kernel.org
Subject: [PATCH 6.18 204/227] net: fec: account for VLAN header in frame length calculations
Date: Wed, 28 Jan 2026 16:24:09 +0100
Message-ID: <20260128145351.779834565@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clemens Gruber <mail@clemensgruber.at>

commit ca1bb3fedf26a08ed31974131bc0064d4fe33649 upstream.

The MAX_FL (maximum frame length) and related calculations used ETH_HLEN,
which does not account for the 4-byte VLAN tag in tagged frames. This
caused the hardware to reject valid VLAN frames as oversized, resulting
in RX errors and dropped packets.

Use VLAN_ETH_HLEN instead of ETH_HLEN in the MAX_FL register setup,
cut-through mode threshold, buffer allocation, and max_mtu calculation.

Cc: stable@kernel.org # v6.18+
Fixes: 62b5bb7be7bc ("net: fec: update MAX_FL based on the current MTU")
Fixes: d466c16026e9 ("net: fec: enable the Jumbo frame support for i.MX8QM")
Fixes: 59e9bf037d75 ("net: fec: add change_mtu to support dynamic buffer allocation")
Fixes: ec2a1681ed4f ("net: fec: use a member variable for maximum buffer size")
Signed-off-by: Clemens Gruber <mail@clemensgruber.at>
Reviewed-by: Wei Fang <wei.fang@nxp.com>
Link: https://patch.msgid.link/20260121083751.66997-1-mail@clemensgruber.at
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/fec_main.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1151,7 +1151,7 @@ fec_restart(struct net_device *ndev)
 	u32 rcntl = FEC_RCR_MII;
 
 	if (OPT_ARCH_HAS_MAX_FL)
-		rcntl |= (fep->netdev->mtu + ETH_HLEN + ETH_FCS_LEN) << 16;
+		rcntl |= (fep->netdev->mtu + VLAN_ETH_HLEN + ETH_FCS_LEN) << 16;
 
 	if (fep->bufdesc_ex)
 		fec_ptp_save_state(fep);
@@ -1286,12 +1286,13 @@ fec_restart(struct net_device *ndev)
 
 		/* When Jumbo Frame is enabled, the FIFO may not be large enough
 		 * to hold an entire frame. In such cases, if the MTU exceeds
-		 * (PKT_MAXBUF_SIZE - ETH_HLEN - ETH_FCS_LEN), configure the interface
-		 * to operate in cut-through mode, triggered by the FIFO threshold.
+		 * (PKT_MAXBUF_SIZE - VLAN_ETH_HLEN - ETH_FCS_LEN), configure
+		 * the interface to operate in cut-through mode, triggered by
+		 * the FIFO threshold.
 		 * Otherwise, enable the ENET store-and-forward mode.
 		 */
 		if ((fep->quirks & FEC_QUIRK_JUMBO_FRAME) &&
-		    (ndev->mtu > (PKT_MAXBUF_SIZE - ETH_HLEN - ETH_FCS_LEN)))
+		    (ndev->mtu > (PKT_MAXBUF_SIZE - VLAN_ETH_HLEN - ETH_FCS_LEN)))
 			writel(0xF, fep->hwp + FEC_X_WMRK);
 		else
 			writel(FEC_TXWMRK_STRFWD, fep->hwp + FEC_X_WMRK);
@@ -4052,7 +4053,7 @@ static int fec_change_mtu(struct net_dev
 	if (netif_running(ndev))
 		return -EBUSY;
 
-	order = get_order(new_mtu + ETH_HLEN + ETH_FCS_LEN
+	order = get_order(new_mtu + VLAN_ETH_HLEN + ETH_FCS_LEN
 			  + FEC_DRV_RESERVE_SPACE);
 	fep->rx_frame_size = (PAGE_SIZE << order) - FEC_DRV_RESERVE_SPACE;
 	fep->pagepool_order = order;
@@ -4609,7 +4610,7 @@ fec_probe(struct platform_device *pdev)
 	else
 		fep->max_buf_size = PKT_MAXBUF_SIZE;
 
-	ndev->max_mtu = fep->max_buf_size - ETH_HLEN - ETH_FCS_LEN;
+	ndev->max_mtu = fep->max_buf_size - VLAN_ETH_HLEN - ETH_FCS_LEN;
 
 	ret = register_netdev(ndev);
 	if (ret)


