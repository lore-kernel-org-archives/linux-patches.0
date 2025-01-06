Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9902D156C5E;
	Mon,  6 Jan 2025 15:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178057; cv=none; b=JNRg6htqfZBNdgd1Str1EjIDHG5Us25+gKQ/tz0zJYJbJqC/xtPomSomymtaKje7dSFlnmuiLo/x6dGQPOOVlCa0xTxdbBK4yJr54afIuJRstSa5WRglAg/uclJNVlc0/bTdfotV9/aQDu3AWuxKLvMnPa9vBls8BLBVQTGIJLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178057; c=relaxed/simple;
	bh=tWfOdCm46Ku3flze02GJx8ZWvB6lwLrcKOlMs0GXe7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kzkSbuwSSazbJUYPq2bdYoBZdsKAa9s7SeuJC9TRgaFTZnb+5A3iylPXH/M9ntCQaWdN+SKB+0b0zPCaBDqS2a8OQCn31CQWJelXC36MXegWCP5PEv3H5KWwttb0T0uNGPd0CT4cnDbH1/pVDY0BLNrJ2ixxQOpjhFm6Z0rKTmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gDRA7I3P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gDRA7I3P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21DA0C4CED2;
	Mon,  6 Jan 2025 15:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178057;
	bh=tWfOdCm46Ku3flze02GJx8ZWvB6lwLrcKOlMs0GXe7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gDRA7I3PkGyhQYo71Cx5btkibz+iF0JgoC4jbQeHcGIcVwRUHx7VeGjWZcMUOZgRN
	 hjAQDxVyqa3zudM7FHp/L4Nrw0HcxRU4ru4uDOMJa9b6c3WhuapAXGgCdwiFZBPI7V
	 GDdbiZY7NpJOkf63QacKGtyj7ojhY0KXM+NUS7fA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Washington <joshwash@google.com>,
	Praveen Kaligineedi <pkaligineedi@google.com>,
	Shailend Chand <shailend@google.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.12 146/156] gve: fix XDP allocation path in edge cases
Date: Mon,  6 Jan 2025 16:17:12 +0100
Message-ID: <20250106151147.227373805@linuxfoundation.org>
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

commit de63ac44a527b2c5067551dbd70d939fe151325a upstream.

This patch fixes a number of consistency issues in the queue allocation
path related to XDP.

As it stands, the number of allocated XDP queues changes in three
different scenarios.
1) Adding an XDP program while the interface is up via
   gve_add_xdp_queues
2) Removing an XDP program while the interface is up via
   gve_remove_xdp_queues
3) After queues have been allocated and the old queue memory has been
   removed in gve_queues_start.

However, the requirement for the interface to be up for
gve_(add|remove)_xdp_queues to be called, in conjunction with the fact
that the number of queues stored in priv isn't updated until _after_ XDP
queues have been allocated in the normal queue allocation path means
that if an XDP program is added while the interface is down, XDP queues
won't be added until the _second_ if_up, not the first.

Given the expectation that the number of XDP queues is equal to the
number of RX queues, scenario (3) has another problematic implication.
When changing the number of queues while an XDP program is loaded, the
number of XDP queues must be updated as well, as there is logic in the
driver (gve_xdp_tx_queue_id()) which relies on every RX queue having a
corresponding XDP TX queue. However, the number of XDP queues stored in
priv would not be updated until _after_ a close/open leading to a
mismatch in the number of XDP queues reported vs the number of XDP
queues which actually exist after the queue count update completes.

This patch remedies these issues by doing the following:
1) The allocation config getter function is set up to retrieve the
   _expected_ number of XDP queues to allocate instead of relying
   on the value stored in `priv` which is only updated once the queues
   have been allocated.
2) When adjusting queues, XDP queues are adjusted to match the number of
   RX queues when XDP is enabled. This only works in the case when
   queues are live, so part (1) of the fix must still be available in
   the case that queues are adjusted when there is an XDP program and
   the interface is down.

Fixes: 5f08cd3d6423 ("gve: Alloc before freeing when adjusting queues")
Cc: stable@vger.kernel.org
Signed-off-by: Joshua Washington <joshwash@google.com>
Signed-off-by: Praveen Kaligineedi <pkaligineedi@google.com>
Reviewed-by: Praveen Kaligineedi <pkaligineedi@google.com>
Reviewed-by: Shailend Chand <shailend@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/google/gve/gve_main.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -930,11 +930,13 @@ static void gve_init_sync_stats(struct g
 static void gve_tx_get_curr_alloc_cfg(struct gve_priv *priv,
 				      struct gve_tx_alloc_rings_cfg *cfg)
 {
+	int num_xdp_queues = priv->xdp_prog ? priv->rx_cfg.num_queues : 0;
+
 	cfg->qcfg = &priv->tx_cfg;
 	cfg->raw_addressing = !gve_is_qpl(priv);
 	cfg->ring_size = priv->tx_desc_cnt;
 	cfg->start_idx = 0;
-	cfg->num_rings = gve_num_tx_queues(priv);
+	cfg->num_rings = priv->tx_cfg.num_queues + num_xdp_queues;
 	cfg->tx = priv->tx;
 }
 
@@ -1843,6 +1845,7 @@ int gve_adjust_queues(struct gve_priv *p
 {
 	struct gve_tx_alloc_rings_cfg tx_alloc_cfg = {0};
 	struct gve_rx_alloc_rings_cfg rx_alloc_cfg = {0};
+	int num_xdp_queues;
 	int err;
 
 	gve_get_curr_alloc_cfgs(priv, &tx_alloc_cfg, &rx_alloc_cfg);
@@ -1853,6 +1856,10 @@ int gve_adjust_queues(struct gve_priv *p
 	rx_alloc_cfg.qcfg = &new_rx_config;
 	tx_alloc_cfg.num_rings = new_tx_config.num_queues;
 
+	/* Add dedicated XDP TX queues if enabled. */
+	num_xdp_queues = priv->xdp_prog ? new_rx_config.num_queues : 0;
+	tx_alloc_cfg.num_rings += num_xdp_queues;
+
 	if (netif_running(priv->dev)) {
 		err = gve_adjust_config(priv, &tx_alloc_cfg, &rx_alloc_cfg);
 		return err;


