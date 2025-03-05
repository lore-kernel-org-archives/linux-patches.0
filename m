Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1541C6FF9;
	Wed,  5 Mar 2025 18:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197771; cv=none; b=KeF0xCpXKP0VtLzVDREyWnwzS+713iC5UyhFIqBiE8fx6XOp7ik3PLxqMeNb4/xSuRXeesJPQsBq6FVm0Q9pc3PYPRF2HJVykxY8jabJVr5Ix4+Ja9964sHhQPY2C7jOlOhPOYilR6cx84dLWBmckh7HNJZBfpy9gaCpFIpOIsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197771; c=relaxed/simple;
	bh=XpDUp+fPowDhNOJ3hH7G6hYwKEbSdrGoQIZ9A47aa2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nhGGv6A0haiCC7A5q+7WJ8t5qVi0ZUtcypQiEzcDbnevjYJRlP1CP/u5AuujiTFZ8SP0FCs05eJELNBVTjvYJq0fYsCrPYpjkqoNJPd37OiDQbUaMds1Rn9sKpZEDOCdz/wrwMLoFf1R5mtbA6W6kZfqHCwAVgLHVienPYKy2QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cGqSv9Za; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cGqSv9Za"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F54C4CED1;
	Wed,  5 Mar 2025 18:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197771;
	bh=XpDUp+fPowDhNOJ3hH7G6hYwKEbSdrGoQIZ9A47aa2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cGqSv9ZaellH8X7WLBRtg78SDvGcOZkaz3X1wBoeOnpwg92uJLxBZys610/PVGaV5
	 x3t1ws/PaBZ6/yb269mTHGeqqngttYoJYfelgwJ1BuqY4vonOihvR1XnX6FVxn6dTd
	 j6m0NO/KMeaywnbxiNbBME4/PFm65LAtMBaPFxM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Praveen Kaligineedi <pkaligineedi@google.com>,
	Jeroen de Borst <jeroendb@google.com>,
	Joshua Washington <joshwash@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 094/142] gve: set xdp redirect target only when it is available
Date: Wed,  5 Mar 2025 18:48:33 +0100
Message-ID: <20250305174504.108721946@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174500.327985489@linuxfoundation.org>
References: <20250305174500.327985489@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Washington <joshwash@google.com>

commit 415cadd505464d9a11ff5e0f6e0329c127849da5 upstream.

Before this patch the NETDEV_XDP_ACT_NDO_XMIT XDP feature flag is set by
default as part of driver initialization, and is never cleared. However,
this flag differs from others in that it is used as an indicator for
whether the driver is ready to perform the ndo_xdp_xmit operation as
part of an XDP_REDIRECT. Kernel helpers
xdp_features_(set|clear)_redirect_target exist to convey this meaning.

This patch ensures that the netdev is only reported as a redirect target
when XDP queues exist to forward traffic.

Fixes: 39a7f4aa3e4a ("gve: Add XDP REDIRECT support for GQI-QPL format")
Cc: stable@vger.kernel.org
Reviewed-by: Praveen Kaligineedi <pkaligineedi@google.com>
Reviewed-by: Jeroen de Borst <jeroendb@google.com>
Signed-off-by: Joshua Washington <joshwash@google.com>
Link: https://patch.msgid.link/20250214224417.1237818-1-joshwash@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Joshua Washington <joshwash@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/google/gve/gve.h      |   10 ++++++++++
 drivers/net/ethernet/google/gve/gve_main.c |    6 +++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -1030,6 +1030,16 @@ static inline u32 gve_xdp_tx_start_queue
 	return gve_xdp_tx_queue_id(priv, 0);
 }
 
+static inline bool gve_supports_xdp_xmit(struct gve_priv *priv)
+{
+	switch (priv->queue_format) {
+	case GVE_GQI_QPL_FORMAT:
+		return true;
+	default:
+		return false;
+	}
+}
+
 /* buffers */
 int gve_alloc_page(struct gve_priv *priv, struct device *dev,
 		   struct page **page, dma_addr_t *dma,
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -1753,6 +1753,8 @@ static void gve_turndown(struct gve_priv
 	/* Stop tx queues */
 	netif_tx_disable(priv->dev);
 
+	xdp_features_clear_redirect_target(priv->dev);
+
 	gve_clear_napi_enabled(priv);
 	gve_clear_report_stats(priv);
 
@@ -1793,6 +1795,9 @@ static void gve_turnup(struct gve_priv *
 		}
 	}
 
+	if (priv->num_xdp_queues && gve_supports_xdp_xmit(priv))
+		xdp_features_set_redirect_target(priv->dev, false);
+
 	gve_set_napi_enabled(priv);
 }
 
@@ -2014,7 +2019,6 @@ static void gve_set_netdev_xdp_features(
 	if (priv->queue_format == GVE_GQI_QPL_FORMAT) {
 		xdp_features = NETDEV_XDP_ACT_BASIC;
 		xdp_features |= NETDEV_XDP_ACT_REDIRECT;
-		xdp_features |= NETDEV_XDP_ACT_NDO_XMIT;
 		xdp_features |= NETDEV_XDP_ACT_XSK_ZEROCOPY;
 	} else {
 		xdp_features = 0;


