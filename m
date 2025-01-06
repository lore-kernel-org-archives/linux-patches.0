Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2B516D9B8;
	Mon,  6 Jan 2025 15:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178063; cv=none; b=dnl/Y8Qiylk5B9AjsGzunXIqSfSLz4SF7uLR14Hc8Y92aSE4KzccbIJy1HH5isLzo1XvJN7CZNp29Bjb6Np2llAKCjv1v2K6WJlIE7/M2T+tZHyjAEwwX1dcBxxeVwoTIB1S8tBw9QMIJPCZVypDy1SEcfMTJVux9TadrhBwBXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178063; c=relaxed/simple;
	bh=+wDlo9R50pJegD2MbagxfKRnn/h0Mn+rMj0rF+rhqVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b10YeSLvxuijvsJBQ6jLRXAIS2XZSeTpLi4XkbuuQugO6SUdPPRRdEgepn4s3blHaT54dOWhTtJ0v6fL5MJ2ky6P6JlHwPbbGq7I3ArAOVLSzIbxpxkEBRG6+qd81eGiOFXJdRIBkDBATs2+5J4S3muwEDnvPZfI92p4pCuCHyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ZHTHrbU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ZHTHrbU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D3F0C4CED2;
	Mon,  6 Jan 2025 15:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178063;
	bh=+wDlo9R50pJegD2MbagxfKRnn/h0Mn+rMj0rF+rhqVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1ZHTHrbUimFZnZE8L/edvVZd0EusJe21ghdzXqnb0D1gt6C2B4hTuOMecKTVjgxoI
	 HygQ904FAHI9QxLzdpH11HRVVWZqIxIcMTOD83DyBCEtMUoo6qciqcFtNTvmOnEjY8
	 UhpoKo5X9yfh5V1JYLODnmyv2VE45yzb2t/3rG00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Washington <joshwash@google.com>,
	Praveen Kaligineedi <pkaligineedi@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 148/156] gve: trigger RX NAPI instead of TX NAPI in gve_xsk_wakeup
Date: Mon,  6 Jan 2025 16:17:14 +0100
Message-ID: <20250106151147.303047066@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
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

From: Joshua Washington <joshwash@google.com>

commit fb3a9a1165cea104b5ab3753e88218e4497b01c1 upstream.

Commit ba0925c34e0f ("gve: process XSK TX descriptors as part of RX NAPI")
moved XSK TX processing to be part of the RX NAPI. However, that commit
did not include triggering the RX NAPI in gve_xsk_wakeup. This is
necessary because the TX NAPI only processes TX completions, meaning
that a TX wakeup would not actually trigger XSK descriptor processing.
Also, the branch on XDP_WAKEUP_TX was supposed to have been removed, as
the NAPI should be scheduled whether the wakeup is for RX or TX.

Fixes: ba0925c34e0f ("gve: process XSK TX descriptors as part of RX NAPI")
Cc: stable@vger.kernel.org
Signed-off-by: Joshua Washington <joshwash@google.com>
Signed-off-by: Praveen Kaligineedi <pkaligineedi@google.com>
Link: https://patch.msgid.link/20241221032807.302244-1-pkaligineedi@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/google/gve/gve_main.c |   21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -1714,7 +1714,7 @@ done:
 static int gve_xsk_wakeup(struct net_device *dev, u32 queue_id, u32 flags)
 {
 	struct gve_priv *priv = netdev_priv(dev);
-	int tx_queue_id = gve_xdp_tx_queue_id(priv, queue_id);
+	struct napi_struct *napi;
 
 	if (!gve_get_napi_enabled(priv))
 		return -ENETDOWN;
@@ -1722,19 +1722,12 @@ static int gve_xsk_wakeup(struct net_dev
 	if (queue_id >= priv->rx_cfg.num_queues || !priv->xdp_prog)
 		return -EINVAL;
 
-	if (flags & XDP_WAKEUP_TX) {
-		struct gve_tx_ring *tx = &priv->tx[tx_queue_id];
-		struct napi_struct *napi =
-			&priv->ntfy_blocks[tx->ntfy_id].napi;
-
-		if (!napi_if_scheduled_mark_missed(napi)) {
-			/* Call local_bh_enable to trigger SoftIRQ processing */
-			local_bh_disable();
-			napi_schedule(napi);
-			local_bh_enable();
-		}
-
-		tx->xdp_xsk_wakeup++;
+	napi = &priv->ntfy_blocks[gve_rx_idx_to_ntfy(priv, queue_id)].napi;
+	if (!napi_if_scheduled_mark_missed(napi)) {
+		/* Call local_bh_enable to trigger SoftIRQ processing */
+		local_bh_disable();
+		napi_schedule(napi);
+		local_bh_enable();
 	}
 
 	return 0;


