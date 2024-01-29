Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19EDC7405B;
	Mon, 29 Jan 2024 17:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548565; cv=none; b=cjR+cSOl6ELvTWTHGQhIdPFxUfGKWpHd9YEwKlVTfkdMVSjN2uT77JxxADu3tEWgvxBcMF1VStkHy4dSDUWGQoh2/6YwvZYwCQwlMaA3jNqWQftY+NOmG8/U2fMiJs/xUA0zJiyw6c9XKmo8ZkrwZCADYRo/r3TSk4c5dMHIjuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548565; c=relaxed/simple;
	bh=u4M1xd0//2F4Pc7MTA7NImOT1i8dZgMeCg0WgZCigEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PFfxbHaG4+R2Vc7tf5FoIERhu7PIVfcsNORgzSvz97EoBSmpJd/P4pPqTegVadFICeBjqcaz4UYzGPpoaXgi6Wv95sMjY2TS5DjMb8RRutMJeF+cnBfifOuWmB/JBAJXigMKSiHh5xAr/gEIY585ZxYz44O+Niitp5jEQLWNeWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NuFdYJi6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NuFdYJi6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D81FBC433C7;
	Mon, 29 Jan 2024 17:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548564;
	bh=u4M1xd0//2F4Pc7MTA7NImOT1i8dZgMeCg0WgZCigEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NuFdYJi6RN0o3pbKFLUZ1+Ppqz4OXQcMWHCJm34BOvjziCS9RU+PAkqeHMch+9bxC
	 77MoccMLkUgaNHkayUM9XsDLY2/7vg0o6kgJcDCiqmQP+2CCvYTKVLO0M6uv/Emexs
	 2g2+2v+sb2XZ+C5zhg9Eam2IZJpSkmQxCajITZks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 213/331] xsk: make xsk_buff_pool responsible for clearing xdp_buff::flags
Date: Mon, 29 Jan 2024 09:04:37 -0800
Message-ID: <20240129170021.112457168@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit f7f6aa8e24383fbb11ac55942e66da9660110f80 ]

XDP multi-buffer support introduced XDP_FLAGS_HAS_FRAGS flag that is
used by drivers to notify data path whether xdp_buff contains fragments
or not. Data path looks up mentioned flag on first buffer that occupies
the linear part of xdp_buff, so drivers only modify it there. This is
sufficient for SKB and XDP_DRV modes as usually xdp_buff is allocated on
stack or it resides within struct representing driver's queue and
fragments are carried via skb_frag_t structs. IOW, we are dealing with
only one xdp_buff.

ZC mode though relies on list of xdp_buff structs that is carried via
xsk_buff_pool::xskb_list, so ZC data path has to make sure that
fragments do *not* have XDP_FLAGS_HAS_FRAGS set. Otherwise,
xsk_buff_free() could misbehave if it would be executed against xdp_buff
that carries a frag with XDP_FLAGS_HAS_FRAGS flag set. Such scenario can
take place when within supplied XDP program bpf_xdp_adjust_tail() is
used with negative offset that would in turn release the tail fragment
from multi-buffer frame.

Calling xsk_buff_free() on tail fragment with XDP_FLAGS_HAS_FRAGS would
result in releasing all the nodes from xskb_list that were produced by
driver before XDP program execution, which is not what is intended -
only tail fragment should be deleted from xskb_list and then it should
be put onto xsk_buff_pool::free_list. Such multi-buffer frame will never
make it up to user space, so from AF_XDP application POV there would be
no traffic running, however due to free_list getting constantly new
nodes, driver will be able to feed HW Rx queue with recycled buffers.
Bottom line is that instead of traffic being redirected to user space,
it would be continuously dropped.

To fix this, let us clear the mentioned flag on xsk_buff_pool side
during xdp_buff initialization, which is what should have been done
right from the start of XSK multi-buffer support.

Fixes: 1bbc04de607b ("ice: xsk: add RX multi-buffer support")
Fixes: 1c9ba9c14658 ("i40e: xsk: add RX multi-buffer support")
Fixes: 24ea50127ecf ("xsk: support mbuf on ZC RX")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Link: https://lore.kernel.org/r/20240124191602.566724-3-maciej.fijalkowski@intel.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 1 -
 drivers/net/ethernet/intel/ice/ice_xsk.c   | 1 -
 include/net/xdp_sock_drv.h                 | 1 +
 net/xdp/xsk_buff_pool.c                    | 1 +
 4 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 7d991e4d9b89..b75e6b6d317c 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -503,7 +503,6 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 		xdp_res = i40e_run_xdp_zc(rx_ring, first, xdp_prog);
 		i40e_handle_xdp_result_zc(rx_ring, first, rx_desc, &rx_packets,
 					  &rx_bytes, xdp_res, &failure);
-		first->flags = 0;
 		next_to_clean = next_to_process;
 		if (failure)
 			break;
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 2a3f0834e139..33f194c870bb 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -897,7 +897,6 @@ int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget)
 
 		if (!first) {
 			first = xdp;
-			xdp_buff_clear_frags_flag(first);
 		} else if (ice_add_xsk_frag(rx_ring, first, xdp, size)) {
 			break;
 		}
diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
index 1f6fc8c7a84c..7290eb721c07 100644
--- a/include/net/xdp_sock_drv.h
+++ b/include/net/xdp_sock_drv.h
@@ -152,6 +152,7 @@ static inline void xsk_buff_set_size(struct xdp_buff *xdp, u32 size)
 	xdp->data = xdp->data_hard_start + XDP_PACKET_HEADROOM;
 	xdp->data_meta = xdp->data;
 	xdp->data_end = xdp->data + size;
+	xdp->flags = 0;
 }
 
 static inline dma_addr_t xsk_buff_raw_get_dma(struct xsk_buff_pool *pool,
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 49cb9f9a09be..b0a611677865 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -541,6 +541,7 @@ struct xdp_buff *xp_alloc(struct xsk_buff_pool *pool)
 
 	xskb->xdp.data = xskb->xdp.data_hard_start + XDP_PACKET_HEADROOM;
 	xskb->xdp.data_meta = xskb->xdp.data;
+	xskb->xdp.flags = 0;
 
 	if (pool->dma_need_sync) {
 		dma_sync_single_range_for_device(pool->dev, xskb->dma, 0,
-- 
2.43.0



