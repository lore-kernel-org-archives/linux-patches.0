Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A50B175A89;
	Wed, 30 Sep 2026 18:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793241; cv=none; b=Q4jVP+a1b21raCoeZVxukS9kEKwC9oEOyJq275SNkj4n3F6GUaJNOBlA+IYDadH4dcfDH1Rze44BxGjCwfbkbz1LKmXntLSQUnMs9Yd7LOjE9eW+jUL01tI7rNV4HbRAkZ/podwkBhc3j4eQe4S3fSeL4ol6zSJnYUUP+mWNpT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793241; c=relaxed/simple;
	bh=P08Z9hvZik3SpdUhemrr3Zrrk4lBOBBbcs4LyCVpyQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZdU2PW+tgw/D+schzUrhX5OfH2RIHZRduGMvpg1qYhWQHC9S1Z9Lr1mzoRo2QwdIY9BPph20NnlSX9AwCezBou5R4MrXvp60bLepxooUQvobwlid6WczKYdX9l1nY2ilBSIkbFTO0jezE1A8hiIANo/+FCHeMhXSC2WzAoXteY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qo3PczcH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qo3PczcH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1DD41F000FF;
	Wed, 30 Sep 2026 18:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793240;
	bh=jv+bW7GBUglXa9zdYIDvQ9A9FtvAznOXyhkxyKzGg34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qo3PczcHE1GolTAl0HW52xtpKzwZmdu4eKlMkUInzdyYxzudPSbunX8fn6H1emKEB
	 miE+lKk5cE7ILdX8CIILlj+rUsH6gd/GcUpOAYUTRRuCMMxkxIEOUbtj34vUUXJu9N
	 oRAg1ZiN/stxWNwSCoZItQ1pET0rlQIHJ4bS3cp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ankit Garg <nktgrg@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Joshua Washington <joshwash@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 186/395] gve: Advertise NETIF_F_GRO_HW instead of NETIF_F_LRO
Date: Wed, 30 Sep 2026 17:27:28 +0200
Message-ID: <20260930152344.685952473@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Ankit Garg <nktgrg@google.com>

[ Upstream commit e637c244b954426b84340cbc551ca0e2a32058ce ]

The device behind DQO format has always coalesced packets per stricter
hardware GRO spec even though it was being advertised as LRO.

Update advertised capability to match device behavior.

Signed-off-by: Ankit Garg <nktgrg@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Harshitha Ramamurthy <hramamurthy@google.com>
Signed-off-by: Joshua Washington <joshwash@google.com>
Link: https://patch.msgid.link/20260303195549.2679070-2-joshwash@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 3b430ea62340 ("gve: fix TX drop when GSO MSS is too small for hw")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve_adminq.c |  6 +++---
 drivers/net/ethernet/google/gve/gve_main.c   | 15 ++++++++-------
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
index 4f33d094a2ef4..7f8212c20ed2d 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.c
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -791,7 +791,7 @@ static void gve_adminq_get_create_rx_queue_cmd(struct gve_priv *priv,
 		cmd->create_rx_queue.rx_buff_ring_size =
 			cpu_to_be16(priv->rx_desc_cnt);
 		cmd->create_rx_queue.enable_rsc =
-			!!(priv->dev->features & NETIF_F_LRO);
+			!!(priv->dev->features & NETIF_F_GRO_HW);
 		if (priv->header_split_enabled)
 			cmd->create_rx_queue.header_buffer_size =
 				cpu_to_be16(priv->header_buf_size);
@@ -1123,9 +1123,9 @@ int gve_adminq_describe_device(struct gve_priv *priv)
 
 	gve_set_default_rss_sizes(priv);
 
-	/* DQO supports LRO. */
+	/* DQO supports HW-GRO. */
 	if (!gve_is_gqi(priv))
-		priv->dev->hw_features |= NETIF_F_LRO;
+		priv->dev->hw_features |= NETIF_F_GRO_HW;
 
 	priv->max_registered_pages =
 				be64_to_cpu(descriptor->max_registered_pages);
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index c94f1615a4127..5fbb02d14dc38 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -1713,9 +1713,9 @@ static int gve_verify_xdp_configuration(struct net_device *dev,
 	struct gve_priv *priv = netdev_priv(dev);
 	u16 max_xdp_mtu;
 
-	if (dev->features & NETIF_F_LRO) {
+	if (dev->features & NETIF_F_GRO_HW) {
 		NL_SET_ERR_MSG_MOD(extack,
-				   "XDP is not supported when LRO is on.");
+				   "XDP is not supported when HW-GRO is on.");
 		return -EOPNOTSUPP;
 	}
 
@@ -2142,12 +2142,13 @@ static int gve_set_features(struct net_device *netdev,
 
 	gve_get_curr_alloc_cfgs(priv, &tx_alloc_cfg, &rx_alloc_cfg);
 
-	if ((netdev->features & NETIF_F_LRO) != (features & NETIF_F_LRO)) {
-		netdev->features ^= NETIF_F_LRO;
-		if (priv->xdp_prog && (netdev->features & NETIF_F_LRO)) {
+	if ((netdev->features & NETIF_F_GRO_HW) !=
+	    (features & NETIF_F_GRO_HW)) {
+		netdev->features ^= NETIF_F_GRO_HW;
+		if (priv->xdp_prog && (netdev->features & NETIF_F_GRO_HW)) {
 			netdev_warn(netdev,
-				    "XDP is not supported when LRO is on.\n");
-			err =  -EOPNOTSUPP;
+				    "HW-GRO is not supported when XDP is on.");
+			err = -EOPNOTSUPP;
 			goto revert_features;
 		}
 		if (netif_running(netdev)) {
-- 
2.53.0



