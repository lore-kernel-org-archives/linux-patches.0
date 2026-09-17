Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EAA3547041;
	Thu, 17 Sep 2026 18:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670463; cv=none; b=X1sWPbaSOpFttH6g+RKHtIKpvacwc2r6iZnU9zKhrmq/R3lPU1D2epKLg+fTa/NngRUWOZY2v03/UdAb5lYmi9Y/T+AqRPasDzkUE67AIAyegx4fxaddYOxSqGgykinxA2xswWs/t7Zs1K8LAtvVPfjvQ6PjgHiebvI4cKyA02c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670463; c=relaxed/simple;
	bh=/F6E9qcClxRRymw5WlnNxZnU9qEITvNEnd41XzrZ944=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cD8Q/ykLb+f7k5cw1Xp+Oq7jUQP59U0RQovF7wHcu+k/evOkqWqKeNLPIol0YLQTOYsiBtmwt8uKFehjdndy+a+VCqXcewAHHQikp7Bud28AtsB5jkdxVXqj0bn1y1xll+tPdWCwUskp84ytBJXtOumh0mVkDgNDqWmQfah1/OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DpEGdYwa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DpEGdYwa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 403641F000FF;
	Thu, 17 Sep 2026 18:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670462;
	bh=VQTIzwPOykng++P+CFnZNzTl89wwFGWVx74dA/wGvgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DpEGdYwaFdueTR+GIRbLDV3287JTYrUOpw4CsxxmtJIF6hPRLBWl4yLfYJL3rhTwA
	 +uv1PAkhAFyD6mQJL41m4ldjXAWgC2MZK5irzabP9bIlnov60zOfrKFPCUXI8OCOt7
	 z1dsbJTLY4GHsrsn4LxyxMJcC2KegygKB6gpkJVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <joe@dama.to>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0668/1102] net: ethtool: require drivers to opt into the per-RSS ctx RXFH
Date: Thu, 17 Sep 2026 16:10:11 +0100
Message-ID: <20260917151556.983529440@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit fac4b41741b5cd0826cf0fa5b14e177f70a6b509 ]

RX Flow Hashing supports using different configuration for different
RSS contexts. Only two drivers seem to support it. Make sure we
uniformly error out for drivers which don't.

Reviewed-by: Joe Damato <joe@dama.to>
Link: https://patch.msgid.link/20250611145949.2674086-4-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: f1986bf87b07 ("eth: nfp: bound the ntuple rule dump by the caller's buffer size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 1 +
 drivers/net/ethernet/sfc/ethtool.c                   | 1 +
 include/linux/ethtool.h                              | 3 +++
 net/ethtool/ioctl.c                                  | 8 ++++++++
 4 files changed, 13 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 026f2867b8490..e7b8909dfd119 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -2606,6 +2606,7 @@ static void mlx5e_get_ts_stats(struct net_device *netdev,
 
 const struct ethtool_ops mlx5e_ethtool_ops = {
 	.cap_rss_ctx_supported	= true,
+	.rxfh_per_ctx_fields	= true,
 	.rxfh_per_ctx_key	= true,
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
 				     ETHTOOL_COALESCE_MAX_FRAMES |
diff --git a/drivers/net/ethernet/sfc/ethtool.c b/drivers/net/ethernet/sfc/ethtool.c
index 83d715544f7fb..afbedca63b29e 100644
--- a/drivers/net/ethernet/sfc/ethtool.c
+++ b/drivers/net/ethernet/sfc/ethtool.c
@@ -262,6 +262,7 @@ const struct ethtool_ops efx_ethtool_ops = {
 	.set_rxnfc		= efx_ethtool_set_rxnfc,
 	.get_rxfh_indir_size	= efx_ethtool_get_rxfh_indir_size,
 	.get_rxfh_key_size	= efx_ethtool_get_rxfh_key_size,
+	.rxfh_per_ctx_fields	= true,
 	.rxfh_per_ctx_key	= true,
 	.cap_rss_rxnfc_adds	= true,
 	.rxfh_priv_size		= sizeof(struct efx_rss_context_priv),
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index b3a003dc2043e..913286e16a3e0 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -753,6 +753,8 @@ struct kernel_ethtool_ts_info {
  * @cap_rss_ctx_supported: indicates if the driver supports RSS
  *	contexts via legacy API, drivers implementing @create_rxfh_context
  *	do not have to set this bit.
+ * @rxfh_per_ctx_fields: device supports selecting different header fields
+ *	for Rx hash calculation and RSS for each additional context.
  * @rxfh_per_ctx_key: device supports setting different RSS key for each
  *	additional context. Netlink API should report hfunc, key, and input_xfrm
  *	for every context, not just context 0.
@@ -980,6 +982,7 @@ struct ethtool_ops {
 	u32     supported_input_xfrm:8;
 	u32     cap_link_lanes_supported:1;
 	u32     cap_rss_ctx_supported:1;
+	u32	rxfh_per_ctx_fields:1;
 	u32	rxfh_per_ctx_key:1;
 	u32	cap_rss_rxnfc_adds:1;
 	u32	rxfh_indir_space;
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index e53af2fc5a23a..f5f2db4b53ca6 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1074,6 +1074,10 @@ ethtool_set_rxfh_fields(struct net_device *dev, u32 cmd, void __user *useraddr)
 	if (rc)
 		return rc;
 
+	if (info.flow_type & FLOW_RSS && info.rss_context &&
+	    !ops->rxfh_per_ctx_fields)
+		return -EINVAL;
+
 	if (ops->get_rxfh) {
 		struct ethtool_rxfh_param rxfh = {};
 
@@ -1104,6 +1108,10 @@ ethtool_get_rxfh_fields(struct net_device *dev, u32 cmd, void __user *useraddr)
 	if (ret)
 		return ret;
 
+	if (info.flow_type & FLOW_RSS && info.rss_context &&
+	    !ops->rxfh_per_ctx_fields)
+		return -EINVAL;
+
 	ret = ops->get_rxnfc(dev, &info, NULL);
 	if (ret < 0)
 		return ret;
-- 
2.53.0



