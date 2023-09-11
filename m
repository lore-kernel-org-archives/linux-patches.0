Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8977C11710
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 13:59:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09BB6C433C7;
	Mon, 11 Sep 2023 13:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694440774;
	bh=kCkbDlRngWNj8JPZKobM0KEkjh+BgGtewM7VcALfYAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oPnaC5Rk5TBnftiIKvx3jbgJ6aJaJUUmRKaKQZsjeyv0rO2m8zNKoQfo01urdNPet
	 AhSqDVcz6Qs7VUPCcyRjoK/Q/l5Tz784tzxUgY4Pt1DqSB/3DdS76j4m1yxdrwIKrT
	 tNQesswozZ0a3RyFOo/iwdZ2PlQJ91uTZ8j9+6Ns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Sunil Goutham <sgoutham@marvell.com>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 181/739] octeontx2-pf: fix page_pool creation fail for rings > 32k
Date: Mon, 11 Sep 2023 15:39:40 +0200
Message-ID: <20230911134656.251646874@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ratheesh Kannoth <rkannoth@marvell.com>

[ Upstream commit 49fa4b0d06705a24a81bb8be6eb175059b77f0a7 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c | 2 +-
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h   | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 77c8f650f7ac1..3e1c70c746227 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -1432,7 +1432,7 @@ int otx2_pool_init(struct otx2_nic *pfvf, u16 pool_id,
 	}
 
 	pp_params.flags = PP_FLAG_PAGE_FRAG | PP_FLAG_DMA_MAP;
-	pp_params.pool_size = numptrs;
+	pp_params.pool_size = min(OTX2_PAGE_POOL_SZ, numptrs);
 	pp_params.nid = NUMA_NO_NODE;
 	pp_params.dev = pfvf->dev;
 	pp_params.dma_dir = DMA_FROM_DEVICE;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
index b5d689eeff80b..9e3bfbe5c4809 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
@@ -23,6 +23,8 @@
 #define	OTX2_ETH_HLEN		(VLAN_ETH_HLEN + VLAN_HLEN)
 #define	OTX2_MIN_MTU		60
 
+#define OTX2_PAGE_POOL_SZ	2048
+
 #define OTX2_MAX_GSO_SEGS	255
 #define OTX2_MAX_FRAGS_IN_SQE	9
 
-- 
2.40.1



