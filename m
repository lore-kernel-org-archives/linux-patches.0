Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F3D5012A9;
	Tue, 13 Oct 2026 12:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893253; cv=none; b=eUvFs4PTgDsDz3zqM2B9TvsRkWMA2gwA+KuIDButlIkvdy0rYuuD9wXEommusGfph3e3NafKkKVjKTUGKfmy28LgZx2Sk+sHP7XU/dfWLejqD+dwTKRykuuxRALKTyr/Fb2G1Ij6GHDju+bzAWQbd8KwVKk6Mj4J/hYAWiKJPME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893253; c=relaxed/simple;
	bh=WdeDRLPcP3SAktM2AcDta3WhH0DFtusn6qyZKq/ibvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A4QDqYewLRqYLYmlvVdE1DzsvhV86F/kRGC4Qxdg2Cn+2zc5XHsrHO60uXZxX533IujRoI2dnnvZtetwm+zDHHzuwPtwI9CwSZnWxpEyXTcsuur91UevNEkqnNFNThSGWdz7yAdFWC9AoFa5QoiTWiXV9qbkQDduewIM6kSv5j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qz8D9D6x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qz8D9D6x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 169A41F000FF;
	Tue, 13 Oct 2026 12:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893252;
	bh=0FhjQpJ0GVh49+rQnNRfX9Icm+rvVNhxKhjsM/KCcbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qz8D9D6xQ3nZIxlMZKgurjCJcO3H3SUoKrGiXABqPFxchFMzYQrjYhOQsWTsRxzBt
	 FNy/o9ARzjH/HiEBhjEBvzhXYHU7nuySzp3gIzy1mZ1Q0tb5EW8QcmTBgW3shB6vnA
	 z3wVZDObCivFl8wFWXsZEzrAJJZiXHm9VhB0zK6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 165/621] net: ti: icssg-prueth: fix use-after-free of CPPI descriptor in RX path
Date: Tue, 13 Oct 2026 13:32:40 +0200
Message-ID: <20261013112924.779344269@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: David Carlier <devnexen@gmail.com>

[ Upstream commit eb8c426c9803beb171f89d15fea17505eb517714 ]

cppi5_hdesc_get_psdata() returns a pointer into the CPPI descriptor.
In both emac_rx_packet() and emac_rx_packet_zc(), the descriptor is
freed via k3_cppi_desc_pool_free() before the psdata pointer is used
by emac_rx_timestamp(), which dereferences psdata[0] and psdata[1].
This constitutes a use-after-free on every received packet that goes
through the timestamp path.

Defer the descriptor free until after all accesses through the psdata
pointer are complete. For emac_rx_packet(), move the free into the
requeue label so both early-exit and success paths free the descriptor
after all accesses are done. For emac_rx_packet_zc(), move the free to
the end of the loop body after emac_dispatch_skb_zc() (which calls
emac_rx_timestamp()) has returned.

Fixes: 46eeb90f03e0 ("net: ti: icssg-prueth: Use page_pool API for RX buffer allocation")
Signed-off-by: David Carlier <devnexen@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260320174439.41080-1-devnexen@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/icssg/icssg_common.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/icssg/icssg_common.c b/drivers/net/ethernet/ti/icssg/icssg_common.c
index 5c7e1247556d0..c005ff7c72a06 100644
--- a/drivers/net/ethernet/ti/icssg/icssg_common.c
+++ b/drivers/net/ethernet/ti/icssg/icssg_common.c
@@ -747,8 +747,6 @@ static int emac_rx_packet(struct prueth_emac *emac, u32 flow_id, u32 *xdp_state)
 	pkt_len -= 4;
 	cppi5_desc_get_tags_ids(&desc_rx->hdr, &port_id, NULL);
 
-	k3_cppi_desc_pool_free(rx_chn->desc_pool, desc_rx);
-
 	/* if allocation fails we drop the packet but push the
 	 * descriptor back to the ring with old page to prevent a stall
 	 */
@@ -800,6 +798,7 @@ static int emac_rx_packet(struct prueth_emac *emac, u32 flow_id, u32 *xdp_state)
 	ndev->stats.rx_packets++;
 
 requeue:
+	k3_cppi_desc_pool_free(rx_chn->desc_pool, desc_rx);
 	/* queue another RX DMA */
 	ret = prueth_dma_rx_push_mapped(emac, &emac->rx_chns, new_page,
 					PRUETH_MAX_PKT_SIZE);
-- 
2.53.0



