Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73191425CE1;
	Tue, 31 Mar 2026 16:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975091; cv=none; b=g7BwgmW3obCvdt1T9FHH4B8p20SrFDd4/Kxk3PqYe+y0PY+eOcKiRKZVvFqkBBb2/+tYURIoqLZhGjptD/Se7N5HSDdK9e9Vuh4/6yawubaCiyPmu87VsdTotWLfk/Fn2NMaq6X7MfUw3gl/y9ELC5pfm0KzNfy0uLz/JMMt06w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975091; c=relaxed/simple;
	bh=bWFgxN1BS+V01Pw8Ikb+gx3wtsz0wSdj28tWAIJKXvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QnrGRqAtlITfEHUc9WDm7V+j7/Nelp1Orv5NO6lkRP0D13KT7Xo2xgyO5YuZl0yXsDir0eXTXjCx84pXFGfD+JFhkGbBixob5TMTk09Di0I3tnDRursjqbR5JSzv/8zL+EaL97t4okKAj/fWzrwJJVVPP3Eax92HtOaM2AU6SD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uZJs18zc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uZJs18zc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AD13C19423;
	Tue, 31 Mar 2026 16:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975091;
	bh=bWFgxN1BS+V01Pw8Ikb+gx3wtsz0wSdj28tWAIJKXvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uZJs18zc7/d1joEAT7/N2/kbbYWkAGMvbNEBACUyv7hfCjdwMpBUteOVqmSpi7mFv
	 rrzl8np19BCtfx5PAno9uMKuP1sF9l7NVicYRroipb0Mn/+JO8Y7tzRZ3EONfQB91P
	 qJjHMMjFY88unUSEaF8V66c6kHI7+75zZAxvhApQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 128/342] net: ti: icssg-prueth: fix use-after-free of CPPI descriptor in RX path
Date: Tue, 31 Mar 2026 18:19:21 +0200
Message-ID: <20260331161803.715983468@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/net/ethernet/ti/icssg/icssg_common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/icssg/icssg_common.c b/drivers/net/ethernet/ti/icssg/icssg_common.c
index a9b5f86bc71bc..11d5b23a61bad 100644
--- a/drivers/net/ethernet/ti/icssg/icssg_common.c
+++ b/drivers/net/ethernet/ti/icssg/icssg_common.c
@@ -962,7 +962,6 @@ static int emac_rx_packet_zc(struct prueth_emac *emac, u32 flow_id,
 		pkt_len -= 4;
 		cppi5_desc_get_tags_ids(&desc_rx->hdr, &port_id, NULL);
 		psdata = cppi5_hdesc_get_psdata(desc_rx);
-		k3_cppi_desc_pool_free(rx_chn->desc_pool, desc_rx);
 		count++;
 		xsk_buff_set_size(xdp, pkt_len);
 		xsk_buff_dma_sync_for_cpu(xdp);
@@ -988,6 +987,7 @@ static int emac_rx_packet_zc(struct prueth_emac *emac, u32 flow_id,
 			emac_dispatch_skb_zc(emac, xdp, psdata);
 			xsk_buff_free(xdp);
 		}
+		k3_cppi_desc_pool_free(rx_chn->desc_pool, desc_rx);
 	}
 
 	if (xdp_status & ICSSG_XDP_REDIR)
@@ -1057,7 +1057,6 @@ static int emac_rx_packet(struct prueth_emac *emac, u32 flow_id, u32 *xdp_state)
 	/* firmware adds 4 CRC bytes, strip them */
 	pkt_len -= 4;
 	cppi5_desc_get_tags_ids(&desc_rx->hdr, &port_id, NULL);
-	k3_cppi_desc_pool_free(rx_chn->desc_pool, desc_rx);
 
 	/* if allocation fails we drop the packet but push the
 	 * descriptor back to the ring with old page to prevent a stall
@@ -1115,6 +1114,7 @@ static int emac_rx_packet(struct prueth_emac *emac, u32 flow_id, u32 *xdp_state)
 	ndev->stats.rx_packets++;
 
 requeue:
+	k3_cppi_desc_pool_free(rx_chn->desc_pool, desc_rx);
 	/* queue another RX DMA */
 	ret = prueth_dma_rx_push_mapped(emac, &emac->rx_chns, new_page,
 					PRUETH_MAX_PKT_SIZE);
-- 
2.51.0



