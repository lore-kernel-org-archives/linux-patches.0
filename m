Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9448E1D079F;
	Wed,  2 Oct 2024 13:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876562; cv=none; b=hwOVkwKeJzySxnpxU9iYu1bDQeYWvbHCqWAhb6l6BykbyJnOLiviJKvw6Qe589bO+AwkUTBZQFkFBx4KTxHK+7IIpc0jI3/4pzFTcVUG7uJ9ajDsfR0z6Pq+BMraBIX2NgP5rJbnUC0mIvIEyay59E0jQw8Cn1gWFq9hQOP6bpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876562; c=relaxed/simple;
	bh=G8Jvhzn39B5EPwGTX7kMUcyelUfeoLYSacg7BRL7m1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ix0jWHGcPoHG2IN4duzf0sxK8pOqKUC3+VqQCrP43DjRfORXLnitLYk9uyhHFAyOCgZQwoLliKj1PE3S5wg2QZszW67rpfwY5Lh+qjgcoaeVpC3w9Dg5QC2quCtoFWD9pjiS7RdJYe+5pUqV27BuJhbHHR0f9jjPdSUvdzvhIV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KXJWBrkN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KXJWBrkN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10457C4CECD;
	Wed,  2 Oct 2024 13:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876562;
	bh=G8Jvhzn39B5EPwGTX7kMUcyelUfeoLYSacg7BRL7m1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KXJWBrkNl6FuPHTPeMjRPwbp6iyeE6evsnhJiml5ZeGjCkaMASkMOQ/qiktLQx4+u
	 35g8hONvj/j9kexw1w4wj9FCQ/losCFnvsiIXRz8WC5VhyHGSfVdTO4lExCNsefQcr
	 y0MXa+I8nMrkyK2syIIJrP+eq5YPxJNEKOG5bidY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Paul Barker <paul.barker.ct@bp.renesas.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 485/695] net: ravb: Fix maximum TX frame size for GbEth devices
Date: Wed,  2 Oct 2024 14:58:03 +0200
Message-ID: <20241002125841.829412998@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

From: Paul Barker <paul.barker.ct@bp.renesas.com>

[ Upstream commit 1d63864299cafa7c8cbde56491c9932afdbff7ea ]

The datasheets for all SoCs using the GbEth IP specify a maximum
transmission frame size of 1.5 kByte. I've confirmed through internal
discussions that support for 1522 byte frames has been validated, which
allows us to support the default MTU of 1500 bytes after reserving space
for the Ethernet header, frame checksums and an optional VLAN tag.

Fixes: 2e95e08ac009 ("ravb: Add rx_max_buf_size to struct ravb_hw_info")
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Signed-off-by: Paul Barker <paul.barker.ct@bp.renesas.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/ravb.h      | 1 +
 drivers/net/ethernet/renesas/ravb_main.c | 6 +++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 9893c91af1050..a7de5cf6b3174 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -1052,6 +1052,7 @@ struct ravb_hw_info {
 	netdev_features_t net_features;
 	int stats_len;
 	u32 tccr_mask;
+	u32 tx_max_frame_size;
 	u32 rx_max_frame_size;
 	u32 rx_buffer_size;
 	u32 rx_desc_size;
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index c02fb296bf7d7..471a68b0146ed 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2674,6 +2674,7 @@ static const struct ravb_hw_info ravb_gen2_hw_info = {
 	.net_features = NETIF_F_RXCSUM,
 	.stats_len = ARRAY_SIZE(ravb_gstrings_stats),
 	.tccr_mask = TCCR_TSRQ0 | TCCR_TSRQ1 | TCCR_TSRQ2 | TCCR_TSRQ3,
+	.tx_max_frame_size = SZ_2K,
 	.rx_max_frame_size = SZ_2K,
 	.rx_buffer_size = SZ_2K +
 			  SKB_DATA_ALIGN(sizeof(struct skb_shared_info)),
@@ -2696,6 +2697,7 @@ static const struct ravb_hw_info ravb_gen3_hw_info = {
 	.net_features = NETIF_F_RXCSUM,
 	.stats_len = ARRAY_SIZE(ravb_gstrings_stats),
 	.tccr_mask = TCCR_TSRQ0 | TCCR_TSRQ1 | TCCR_TSRQ2 | TCCR_TSRQ3,
+	.tx_max_frame_size = SZ_2K,
 	.rx_max_frame_size = SZ_2K,
 	.rx_buffer_size = SZ_2K +
 			  SKB_DATA_ALIGN(sizeof(struct skb_shared_info)),
@@ -2721,6 +2723,7 @@ static const struct ravb_hw_info ravb_gen4_hw_info = {
 	.net_features = NETIF_F_RXCSUM,
 	.stats_len = ARRAY_SIZE(ravb_gstrings_stats),
 	.tccr_mask = TCCR_TSRQ0 | TCCR_TSRQ1 | TCCR_TSRQ2 | TCCR_TSRQ3,
+	.tx_max_frame_size = SZ_2K,
 	.rx_max_frame_size = SZ_2K,
 	.rx_buffer_size = SZ_2K +
 			  SKB_DATA_ALIGN(sizeof(struct skb_shared_info)),
@@ -2770,6 +2773,7 @@ static const struct ravb_hw_info gbeth_hw_info = {
 	.net_features = NETIF_F_RXCSUM | NETIF_F_HW_CSUM,
 	.stats_len = ARRAY_SIZE(ravb_gstrings_stats_gbeth),
 	.tccr_mask = TCCR_TSRQ0,
+	.tx_max_frame_size = 1522,
 	.rx_max_frame_size = SZ_8K,
 	.rx_buffer_size = SZ_2K,
 	.rx_desc_size = sizeof(struct ravb_rx_desc),
@@ -2981,7 +2985,7 @@ static int ravb_probe(struct platform_device *pdev)
 	priv->avb_link_active_low =
 		of_property_read_bool(np, "renesas,ether-link-active-low");
 
-	ndev->max_mtu = info->rx_max_frame_size -
+	ndev->max_mtu = info->tx_max_frame_size -
 		(ETH_HLEN + VLAN_HLEN + ETH_FCS_LEN);
 	ndev->min_mtu = ETH_MIN_MTU;
 
-- 
2.43.0



