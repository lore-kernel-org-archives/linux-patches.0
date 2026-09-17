Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED854F391A;
	Thu, 17 Sep 2026 17:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664451; cv=none; b=IzBsi/QxMeaRhDzjn6c1WiVZRD0DhHd6zj8qzGHbx1zvz7VPdv56LgQvj0C65JhN2dn71e4boG30UC+J7Gytk9ssdhM5S3/gS6IF9kXXtpJQ98V7MAjlpk+nCNuadt9gFDEKaaX6J4LNJWieR+nQgQX8GCisYissOasFUr0attA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664451; c=relaxed/simple;
	bh=LG5cuf60H0uAPSgRLMbT45PUUWe8oELmkToaZUkllrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D62RfPPDIdbvyE7NEIM7ywedBAXiSud8r7VpFQyN5y1QoPpXTvHqMhL+Zu1X9bnRknpfLEjinZYSxhT5wjNmqICdpBH04gGtApBnV8JeksPgVpi38Kdd3X8iyVjZsxQJdxu++WZlvXwEfenkJE19ZuV9IgEHkbgmd2vv7d9rqNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gIUmGEQM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gIUmGEQM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE231F00893;
	Thu, 17 Sep 2026 17:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664449;
	bh=RM7K8k9HZT8niOQN+7kXX/mnD5e19syF6STq9Iic6GA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gIUmGEQMu9HLl8R3nmLEYSjz42BNrhXvojRDEQo2idvhSR0j8mol3W/uKtUnGnXf6
	 Bnfx05AytT+Xr1q68xRq2q92fo46esbaRd+tJv/jyXnActYZWr5y/teIQIIRLdbIyZ
	 PL6zxv9ah61+KQpNkWZDdAZC7CU6uS8lNXjJrNrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	David Carlier <devnexen@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0376/1250] net: lan966x: restore RX state on reload failure
Date: Thu, 17 Sep 2026 16:02:51 +0100
Message-ID: <20260917151602.243193553@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit aa97f11a76e545ed73cc455bcdd1ece4b480b507 ]

lan966x_fdma_reload() backs up rx->page_pool and rx->fdma before
reallocating the RX resources for the new MTU. If the allocation fails,
the restore path puts these fields back before restarting RX.

However, the reload path also updates rx->page_order and rx->max_mtu
before calling lan966x_fdma_rx_alloc(). These fields are not restored on
failure, so RX can be restarted with the old pages, old FDMA state and
old page pool, but with the page geometry from the failed new MTU.

This can make the XDP path advertise a frame size derived from the new
page_order while the actual RX pages still come from the old allocation.
For example, after a failed reload to a jumbo MTU, xdp_init_buff() may be
called with a frame size larger than the restored RX pages.

lan966x_fdma_rx_alloc_page_pool() also registers the newly allocated page
pool with each port's XDP RXQ before fdma_alloc_coherent() is called. If
fdma_alloc_coherent() fails, the new page pool is destroyed, but the
rollback path does not restore the per-port XDP RXQ mem model
registration either.

Save and restore rx->page_order and rx->max_mtu, and restore the old page
pool registration for each port's XDP RXQ before RX is started again.
This keeps the restored RX state consistent after a failed reload.

Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: David Carlier <devnexen@gmail.com>
Link: https://patch.msgid.link/20260607145747.1494514-1-lgs201920130244@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/microchip/lan966x/lan966x_fdma.c | 20 +++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
index 646f3d65274e3..b13c60438b978 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
@@ -816,6 +816,7 @@ static int lan966x_fdma_reload(struct lan966x *lan966x, int new_mtu)
 	struct page *(*old_pages)[FDMA_RX_DCB_MAX_DBS];
 	struct page_pool *page_pool;
 	struct fdma fdma_rx_old;
+	int page_order, max_mtu;
 	int err, i, j;
 
 	old_pages = kmemdup(lan966x->rx.page, sizeof(lan966x->rx.page),
@@ -826,6 +827,8 @@ static int lan966x_fdma_reload(struct lan966x *lan966x, int new_mtu)
 	/* Store these for later to free them */
 	memcpy(&fdma_rx_old, &lan966x->rx.fdma, sizeof(struct fdma));
 	page_pool = lan966x->rx.page_pool;
+	page_order = lan966x->rx.page_order;
+	max_mtu = lan966x->rx.max_mtu;
 
 	napi_synchronize(&lan966x->napi);
 	napi_disable(&lan966x->napi);
@@ -855,7 +858,24 @@ static int lan966x_fdma_reload(struct lan966x *lan966x, int new_mtu)
 	return 0;
 restore:
 	lan966x->rx.page_pool = page_pool;
+	lan966x->rx.page_order = page_order;
+	lan966x->rx.max_mtu = max_mtu;
 	memcpy(&lan966x->rx.fdma, &fdma_rx_old, sizeof(struct fdma));
+	/*
+	 * lan966x_fdma_rx_alloc_page_pool() registered the new pool with
+	 * each port's XDP RXQ before the allocation failed. The new pool is
+	 * destroyed by lan966x_fdma_rx_alloc(), so restore the old pool's
+	 * registration before restarting RX.
+	 */
+	for (i = 0; i < lan966x->num_phys_ports; i++) {
+		if (!lan966x->ports[i])
+			continue;
+
+		xdp_rxq_info_unreg_mem_model(&lan966x->ports[i]->xdp_rxq);
+		xdp_rxq_info_reg_mem_model(&lan966x->ports[i]->xdp_rxq,
+					   MEM_TYPE_PAGE_POOL, page_pool);
+	}
+
 	lan966x_fdma_rx_start(&lan966x->rx);
 
 	lan966x_fdma_wakeup_netdev(lan966x);
-- 
2.53.0



