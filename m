Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE0722A4E9;
	Mon,  2 Jun 2025 15:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877527; cv=none; b=LHNVRfbw1gdXaRwWaektSi7fBTBZeLcsoHhNwZWETLt9GCdzoFkd3fuavkyJmEMeGtZa16htylmvXJw+ytICCYzYzoh+ywrM3NKQTeMpjBTcE2FJ7nk0NlOUQMmpxIaAf71kKtol1Go6IEjfxWgcAXl67ZseUw6P1fHnlyKvdYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877527; c=relaxed/simple;
	bh=ZbYZ9mb2EK9jUu3QPK1wn+WOpi+rlF5LwG4txydS+yM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cJ7RRT5VoxEHvt8Ox1fEO5MgCLKa0iwCeBYunjtuoxO4s1zeBggNK1zA7fZfkmc8PDqaM6y8qq93diSoW8iPoAEJBvvP4MNMpP7Twr/ktULsNLutv6BGp34Ssem/uBBlPiDQA+xro1+NSVpW3SoMydJ4HMAhkG1czTOCyPl4dQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sEEnXMj0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sEEnXMj0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DB2EC4CEEB;
	Mon,  2 Jun 2025 15:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877527;
	bh=ZbYZ9mb2EK9jUu3QPK1wn+WOpi+rlF5LwG4txydS+yM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sEEnXMj0aubRnyhzbxpITlhUriMI+BH232RxVOC04IoZkPBPuFVcjtNOmN7mbt0Tj
	 dlFD3ZFvHTpmsVC/wtJA+n8jIBuN2ZBPmbo3Dmfj/5Syc6bjhrFSZ2BB1+izjrWvry
	 XVOKoiFOLvm3T3shGIBORiPkNjEiNZ1Sc2tQeCJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Sunil Goutham <sgoutham@marvell.com>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 276/325] octeontx2-pf: fix page_pool creation fail for rings > 32k
Date: Mon,  2 Jun 2025 15:49:12 +0200
Message-ID: <20250602134330.979462652@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ratheesh Kannoth <rkannoth@marvell.com>

commit 49fa4b0d06705a24a81bb8be6eb175059b77f0a7 upstream.

octeontx2 driver calls page_pool_create() during driver probe()
and fails if queue size > 32k. Page pool infra uses these buffers
as shock absorbers for burst traffic. These pages are pinned down
over time as working sets varies, due to the recycling nature
of page pool, given page pool (currently) don't have a shrinker
mechanism, the pages remain pinned down in ptr_ring.
Instead of clamping page_pool size to 32k at
most, limit it even more to 2k to avoid wasting memory.

This have been tested on octeontx2 CN10KA hardware.
TCP and UDP tests using iperf shows no performance regressions.

Fixes: b2e3406a38f0 ("octeontx2-pf: Add support for page pool")
Suggested-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Reviewed-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
Acked-by: Jesper Dangaard Brouer <hawk@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c |    2 +-
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h   |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -1434,7 +1434,7 @@ int otx2_pool_init(struct otx2_nic *pfvf
 	}
 
 	pp_params.flags = PP_FLAG_PAGE_FRAG | PP_FLAG_DMA_MAP;
-	pp_params.pool_size = numptrs;
+	pp_params.pool_size = min(OTX2_PAGE_POOL_SZ, numptrs);
 	pp_params.nid = NUMA_NO_NODE;
 	pp_params.dev = pfvf->dev;
 	pp_params.dma_dir = DMA_FROM_DEVICE;
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
@@ -23,6 +23,8 @@
 #define	OTX2_ETH_HLEN		(VLAN_ETH_HLEN + VLAN_HLEN)
 #define	OTX2_MIN_MTU		60
 
+#define OTX2_PAGE_POOL_SZ	2048
+
 #define OTX2_MAX_GSO_SEGS	255
 #define OTX2_MAX_FRAGS_IN_SQE	9
 


