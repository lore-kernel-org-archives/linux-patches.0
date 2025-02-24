Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7CC518BC26;
	Mon, 24 Feb 2025 14:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408778; cv=none; b=PQd0FydHh2zoab7UKr4Z+pDyrlwdz7VRl1MVbZ4evgpOJmG50jZuSwmtORM1dilVRbUOVXUU9ONlbGKv8AcxmsH3kpqu8e5w/iduTpfxh0nwyK+Gy29CYhEgffCe9GmeYMBq3eC8xSQHTvTmJp3ONVb0fjGVkhrvTFqTKSR5fAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408778; c=relaxed/simple;
	bh=zRpA3/IqZiMC608y+violUdrBGAa5pJdO8X30feEtZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ci66hi7eDycIQySlk8MgvqdHPelVXzlYbPc4ZMcTclOtkyqIvMYRjAIM8EvkzuUpavmBpQJ1YoSfSsyPROc4lKM3qVgZ3F3EGkr7lU67zxxLzFRAutb5EZljD/Pedo58WOKfj2CuUqFgyuaynnqzPdIyPLU1T6erII9Vp1O/BpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N7Iirykx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N7Iirykx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48DD4C4CED6;
	Mon, 24 Feb 2025 14:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408778;
	bh=zRpA3/IqZiMC608y+violUdrBGAa5pJdO8X30feEtZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N7IirykxyEqxVaXhiQlR/J+ReDf6oc+dCFFhO7h/COr0j0LrNv6/DPYJnr47BjGRd
	 gBm8WlF8dEpC3AqAaoSbK8q0cfBbVvpGzQRkaVj4MudYPKFCztkVj2HUtH3YI8QsV5
	 Zrgf/xjsKpb3CyXEEjz2RBeDox6GYGrY8GBLB5FE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Praveen Kaligineedi <pkaligineedi@google.com>,
	Jeroen de Borst <jeroendb@google.com>,
	Joshua Washington <joshwash@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 128/154] gve: set xdp redirect target only when it is available
Date: Mon, 24 Feb 2025 15:35:27 +0100
Message-ID: <20250224142612.062355327@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/google/gve/gve.h      |   10 ++++++++++
 drivers/net/ethernet/google/gve/gve_main.c |    6 +++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -1110,6 +1110,16 @@ static inline u32 gve_xdp_tx_start_queue
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
 /* gqi napi handler defined in gve_main.c */
 int gve_napi_poll(struct napi_struct *napi, int budget);
 
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -1895,6 +1895,8 @@ static void gve_turndown(struct gve_priv
 	/* Stop tx queues */
 	netif_tx_disable(priv->dev);
 
+	xdp_features_clear_redirect_target(priv->dev);
+
 	gve_clear_napi_enabled(priv);
 	gve_clear_report_stats(priv);
 
@@ -1955,6 +1957,9 @@ static void gve_turnup(struct gve_priv *
 		napi_schedule(&block->napi);
 	}
 
+	if (priv->num_xdp_queues && gve_supports_xdp_xmit(priv))
+		xdp_features_set_redirect_target(priv->dev, false);
+
 	gve_set_napi_enabled(priv);
 }
 
@@ -2229,7 +2234,6 @@ static void gve_set_netdev_xdp_features(
 	if (priv->queue_format == GVE_GQI_QPL_FORMAT) {
 		xdp_features = NETDEV_XDP_ACT_BASIC;
 		xdp_features |= NETDEV_XDP_ACT_REDIRECT;
-		xdp_features |= NETDEV_XDP_ACT_NDO_XMIT;
 		xdp_features |= NETDEV_XDP_ACT_XSK_ZEROCOPY;
 	} else {
 		xdp_features = 0;


