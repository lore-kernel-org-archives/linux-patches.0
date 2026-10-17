Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13FD03A5E70;
	Sat, 17 Oct 2026 17:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258610; cv=none; b=aZgmB2y9ETTK/+0L4ZOn06ZQx0A4lsvijk3A4ZW5zt/jtxPLM6jIkpxTmHDIN2EcZn1JPfjaJV1VvV2viwjSRL9C2wyKqUSLSLE8Na0rXDUvxqzrOaBFzaFqbNXYmdyDRqhIIUNvQETGR0F3iO5Ez6y4dYWJXJfY2CezhJwLex0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258610; c=relaxed/simple;
	bh=zRQXv5caQFK7sLTxRXEdRKt+Yxsm5afDhNMOXpxEarM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lYPsuLNi0vV3s8TjDMUjnzgV5dbY1AqqBy/FlAgrXYRmjBHP953AkzehqEnosieN5GGJKr+axKl9KeioV15N9KNbMl6lUDanQn4kTMPz+/03fBUAecbmzKxoys5mnrmOt84POVsHx8/zpXztW2ANwx31lU/fZQZyF8Ra9/1wTAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UttSGiHF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UttSGiHF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07C631F000C4;
	Sat, 17 Oct 2026 17:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258608;
	bh=Cy5cCpPCSTIIZyPx0pQ3/Cnq/REA9KvGOu2dqbCAxxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UttSGiHFtO9WA2Xdmf2le0NR8dpnfrNl/tIpK4ls9I4yjS6Pqs3JrMlQgtM0BG1nN
	 4PymJA8YGnrVMTz3kteH04cFwq1UBizUGOAqMyU1qsJ+h+1BUK27ZWmsQ98j7s/H5p
	 1rvpbkO1VHTeQAxxkV7ap4NdWY+QkO5USk2ue8Fc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Amery Hung <ameryhung@gmail.com>,
	Nimrod Oren <noren@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0942/1674] net/mlx5e: RX, Fix XDP multi-buf frag counting for striding RQ
Date: Sat, 17 Oct 2026 17:53:34 +0200
Message-ID: <20261017160455.314046430@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dragos Tatulea <dtatulea@nvidia.com>

[ Upstream commit db25c42c2e1f9c0d136420fff5e5700f7e771a6f ]

XDP multi-buf programs can modify the layout of the XDP buffer when the
program calls bpf_xdp_pull_data() or bpf_xdp_adjust_tail(). The
referenced commit in the fixes tag corrected the assumption in the mlx5
driver that the XDP buffer layout doesn't change during a program
execution. However, this fix introduced another issue: the dropped
fragments still need to be counted on the driver side to avoid page
fragment reference counting issues.

The issue was discovered by the drivers/net/xdp.py selftest,
more specifically the test_xdp_native_tx_mb:
- The mlx5 driver allocates a page_pool page and initializes it with
  a frag counter of 64 (pp_ref_count=64) and the internal frag counter
  to 0.
- The test sends one packet with no payload.
- On RX (mlx5e_skb_from_cqe_mpwrq_nonlinear()), mlx5 configures the XDP
  buffer with the packet data starting in the first fragment which is the
  page mentioned above.
- The XDP program runs and calls bpf_xdp_pull_data() which moves the
  header into the linear part of the XDP buffer. As the packet doesn't
  contain more data, the program drops the tail fragment since it no
  longer contains any payload (pp_ref_count=63).
- mlx5 device skips counting this fragment. Internal frag counter
  remains 0.
- mlx5 releases all 64 fragments of the page but page pp_ref_count is
  63 => negative reference counting error.

Resulting splat during the test:

  WARNING: CPU: 0 PID: 188225 at ./include/net/page_pool/helpers.h:297 mlx5e_page_release_fragmented.isra.0+0xbd/0xe0 [mlx5_core]
  Modules linked in: [...]
  CPU: 0 UID: 0 PID: 188225 Comm: ip Not tainted 6.18.0-rc7_for_upstream_min_debug_2025_12_08_11_44 #1 NONE
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
  RIP: 0010:mlx5e_page_release_fragmented.isra.0+0xbd/0xe0 [mlx5_core]
  [...]
  Call Trace:
   <TASK>
   mlx5e_free_rx_mpwqe+0x20a/0x250 [mlx5_core]
   mlx5e_dealloc_rx_mpwqe+0x37/0xb0 [mlx5_core]
   mlx5e_free_rx_descs+0x11a/0x170 [mlx5_core]
   mlx5e_close_rq+0x78/0xa0 [mlx5_core]
   mlx5e_close_queues+0x46/0x2a0 [mlx5_core]
   mlx5e_close_channel+0x24/0x90 [mlx5_core]
   mlx5e_close_channels+0x5d/0xf0 [mlx5_core]
   mlx5e_safe_switch_params+0x2ec/0x380 [mlx5_core]
   mlx5e_change_mtu+0x11d/0x490 [mlx5_core]
   mlx5e_change_nic_mtu+0x19/0x30 [mlx5_core]
   netif_set_mtu_ext+0xfc/0x240
   do_setlink.isra.0+0x226/0x1100
   rtnl_newlink+0x7a9/0xba0
   rtnetlink_rcv_msg+0x220/0x3c0
   netlink_rcv_skb+0x4b/0xf0
   netlink_unicast+0x255/0x380
   netlink_sendmsg+0x1f3/0x420
   __sock_sendmsg+0x38/0x60
   ____sys_sendmsg+0x1e8/0x240
   ___sys_sendmsg+0x7c/0xb0
   [...]
   __sys_sendmsg+0x5f/0xb0
   do_syscall_64+0x55/0xc70

The problem applies for XDP_PASS as well which is handled in a different
code path in the driver.

This patch fixes the issue by doing page frag counting on all the
original XDP buffer fragments for all relevant XDP actions (XDP_TX ,
XDP_REDIRECT and XDP_PASS). This is basically reverting to the original
counting before the commit in the fixes tag.

As frag_page is still pointing to the original tail, the nr_frags
parameter to xdp_update_skb_frags_info() needs to be calculated
in a different way to reflect the new nr_frags.

Fixes: 87bcef158ac1 ("net/mlx5e: RX, Fix generating skb from non-linear xdp_buff for striding RQ")
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Cc: Amery Hung <ameryhung@gmail.com>
Reviewed-by: Nimrod Oren <noren@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260305142634.1813208-5-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index f4ae2b53a9b9a..11a75a9917f9c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -2097,14 +2097,13 @@ mlx5e_skb_from_cqe_mpwrq_nonlinear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *w
 
 	if (prog) {
 		u8 nr_frags_free, old_nr_frags = sinfo->nr_frags;
+		u8 new_nr_frags;
 		u32 len;
 
 		if (mlx5e_xdp_handle(rq, prog, mxbuf)) {
 			if (__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags)) {
 				struct mlx5e_frag_page *pfp;
 
-				frag_page -= old_nr_frags - sinfo->nr_frags;
-
 				for (pfp = head_page; pfp < frag_page; pfp++)
 					pfp->frags++;
 
@@ -2114,13 +2113,12 @@ mlx5e_skb_from_cqe_mpwrq_nonlinear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *w
 			return NULL; /* page/packet was consumed by XDP */
 		}
 
-		nr_frags_free = old_nr_frags - sinfo->nr_frags;
-		if (unlikely(nr_frags_free)) {
-			frag_page -= nr_frags_free;
+		new_nr_frags = sinfo->nr_frags;
+		nr_frags_free = old_nr_frags - new_nr_frags;
+		if (unlikely(nr_frags_free))
 			truesize -= (nr_frags_free - 1) * PAGE_SIZE +
 				ALIGN(pg_consumed_bytes,
 				      BIT(rq->mpwqe.log_stride_sz));
-		}
 
 		len = mxbuf->xdp.data_end - mxbuf->xdp.data;
 
@@ -2141,7 +2139,7 @@ mlx5e_skb_from_cqe_mpwrq_nonlinear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *w
 			struct mlx5e_frag_page *pagep;
 
 			/* sinfo->nr_frags is reset by build_skb, calculate again. */
-			xdp_update_skb_shared_info(skb, frag_page - head_page,
+			xdp_update_skb_shared_info(skb, new_nr_frags,
 						   sinfo->xdp_frags_size, truesize,
 						   xdp_buff_is_frag_pfmemalloc(
 							&mxbuf->xdp));
-- 
2.53.0



