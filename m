Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE62D15B0E8;
	Mon, 29 Jan 2024 17:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548190; cv=none; b=g8n04zBT0uA74eHIRFAtvLfmnTQcQd89zgzd72cQa/tkEH9NPq8ulb+k6fV0/IeHMUXbBQtFhfGhiuifNpuA4urZABJCfTTQMQ+uarb73OmopBjx2K3sfinQYT/I3JOzKM0kFyotvCea2aSCsZy0ow5xoYV50qrEoejo/08RPEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548190; c=relaxed/simple;
	bh=N7eWBBIe2SC0ACrCVC+kUwHQzlJDjem/gKeqr45ldYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YAe5ClZtxnoO7WKCUFuTdarokfqYpsQT6vtesG/qswmKUE2/VZnAH7xUyIozeOS8Yx42ndr4sqktpZVXbnYHK/axkquChBAIDLy5zaJsJAhTIiVQu72Lf/+gvwaNu7pMEmKq6/RSzKUWwpnA9zy/a1nhGPnErRWdZ5RCefpKo6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HrtDTVAq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HrtDTVAq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9647DC433C7;
	Mon, 29 Jan 2024 17:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548190;
	bh=N7eWBBIe2SC0ACrCVC+kUwHQzlJDjem/gKeqr45ldYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HrtDTVAqWptPLXWg/OKgPTOXUnrtAFVGRhYYQ1cXIEmQkT0ZC18KXf6Wh2lAejZpD
	 mySGloKVMg/qCdGrwBRyd060BiY+VmYw0gd9PUJENTZUmTz9pQ5jCHemaTp7uAU7pu
	 /x36xqtHQ2MDXe9EKJy4yCcwHly4eHD9ttW0tZGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 207/346] xsk: make xsk_buff_pool responsible for clearing xdp_buff::flags
Date: Mon, 29 Jan 2024 09:03:58 -0800
Message-ID: <20240129170022.477105117@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index e99fa854d17f..fede0bb3e047 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -499,7 +499,6 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 		xdp_res = i40e_run_xdp_zc(rx_ring, first, xdp_prog);
 		i40e_handle_xdp_result_zc(rx_ring, first, rx_desc, &rx_packets,
 					  &rx_bytes, xdp_res, &failure);
-		first->flags = 0;
 		next_to_clean = next_to_process;
 		if (failure)
 			break;
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 99954508184f..951f84bfdf2b 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -891,7 +891,6 @@ int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget)
 
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



