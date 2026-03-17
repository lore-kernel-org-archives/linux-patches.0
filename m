Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322553D6698;
	Tue, 17 Mar 2026 16:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765606; cv=none; b=udOlbyzBYLn1ggYKfyeizmE8T0Kgxccp3NRblVDGkKTweUFNSG36ERQbVT4N3aaIM5NtfGs8cLbGw28oVnOR84ix+ReO+r6nsSTiyboFgpgPIiPESDzaxUBU6uqaR9noy6RuWMTWB2iqYj8cObqokblzYug6ouQDtEkjnty2kZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765606; c=relaxed/simple;
	bh=KBiXAXVUIxDKjhROgBSFFn8/knyTrHXghgdkLjlzxUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h5EdMsMND8u4CBph1GXMSK5QPx7gOzuk86oYibju4y+J9xyTtR+JZszDIkz+n64O7FqlspUwqbg5wtdcaZ0hm/d4qdkzEK+QvQ5WmOB1JpBYQWqReju9uJr9iOCbf0aX/o9YQWeBC+Z9tinhIp9tfAhx+NOoaOaSigDArrczeQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t8+ooj3Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t8+ooj3Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35EAEC4CEF7;
	Tue, 17 Mar 2026 16:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765606;
	bh=KBiXAXVUIxDKjhROgBSFFn8/knyTrHXghgdkLjlzxUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t8+ooj3Z38oTrtKk3/HarQypLLwLbWJweij+U53sprB0TtPU5vhpo9AGr92xmeA6F
	 cJuAd6o0Y6pDM4FRjZiiHrjk10aRnC7JMDF/bfgHS3Z4Dh1Op2qK73dDbhFnHE4hSg
	 +UVVcl013H6Jl9TvUljANC8++MmnmkeGxdkt/y0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Amery Hung <ameryhung@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 048/378] net/mlx5e: RX, Fix XDP multi-buf frag counting for legacy RQ
Date: Tue, 17 Mar 2026 17:30:05 +0100
Message-ID: <20260317163008.755123070@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

From: Dragos Tatulea <dtatulea@nvidia.com>

[ Upstream commit a6413e6f6c9d9bb9833324cb3753582f7bc0f2fa ]

XDP multi-buf programs can modify the layout of the XDP buffer when the
program calls bpf_xdp_pull_data() or bpf_xdp_adjust_tail(). The
referenced commit in the fixes tag corrected the assumption in the mlx5
driver that the XDP buffer layout doesn't change during a program
execution. However, this fix introduced another issue: the dropped
fragments still need to be counted on the driver side to avoid page
fragment reference counting issues.

Such issue can be observed with the
test_xdp_native_adjst_tail_shrnk_data selftest when using a payload of
3600 and shrinking by 256 bytes (an upcoming selftest patch): the last
fragment gets released by the XDP code but doesn't get tracked by the
driver. This results in a negative pp_ref_count during page release and
the following splat:

  WARNING: include/net/page_pool/helpers.h:297 at mlx5e_page_release_fragmented.isra.0+0x4a/0x50 [mlx5_core], CPU#12: ip/3137
  Modules linked in: [...]
  CPU: 12 UID: 0 PID: 3137 Comm: ip Not tainted 6.19.0-rc3+ #12 NONE
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
  RIP: 0010:mlx5e_page_release_fragmented.isra.0+0x4a/0x50 [mlx5_core]
  [...]
  Call Trace:
   <TASK>
   mlx5e_dealloc_rx_wqe+0xcb/0x1a0 [mlx5_core]
   mlx5e_free_rx_descs+0x7f/0x110 [mlx5_core]
   mlx5e_close_rq+0x50/0x60 [mlx5_core]
   mlx5e_close_queues+0x36/0x2c0 [mlx5_core]
   mlx5e_close_channel+0x1c/0x50 [mlx5_core]
   mlx5e_close_channels+0x45/0x80 [mlx5_core]
   mlx5e_safe_switch_params+0x1a5/0x230 [mlx5_core]
   mlx5e_change_mtu+0xf3/0x2f0 [mlx5_core]
   netif_set_mtu_ext+0xf1/0x230
   do_setlink.isra.0+0x219/0x1180
   rtnl_newlink+0x79f/0xb60
   rtnetlink_rcv_msg+0x213/0x3a0
   netlink_rcv_skb+0x48/0xf0
   netlink_unicast+0x24a/0x350
   netlink_sendmsg+0x1ee/0x410
   __sock_sendmsg+0x38/0x60
   ____sys_sendmsg+0x232/0x280
   ___sys_sendmsg+0x78/0xb0
   __sys_sendmsg+0x5f/0xb0
   [...]
   do_syscall_64+0x57/0xc50

This patch fixes the issue by doing page frag counting on all the
original XDP buffer fragments for all relevant XDP actions (XDP_TX ,
XDP_REDIRECT and XDP_PASS). This is basically reverting to the original
counting before the commit in the fixes tag.

As frag_page is still pointing to the original tail, the nr_frags
parameter to xdp_update_skb_frags_info() needs to be calculated
in a different way to reflect the new nr_frags.

Fixes: afd5ba577c10 ("net/mlx5e: RX, Fix generating skb from non-linear xdp_buff for legacy RQ")
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Amery Hung <ameryhung@gmail.com>
Link: https://patch.msgid.link/20260305142634.1813208-6-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index ea6741a822675..3000286bf29c8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1759,6 +1759,7 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi
 	struct skb_shared_info *sinfo;
 	u32 frag_consumed_bytes;
 	struct bpf_prog *prog;
+	u8 nr_frags_free = 0;
 	struct sk_buff *skb;
 	dma_addr_t addr;
 	u32 truesize;
@@ -1801,15 +1802,13 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi
 
 	prog = rcu_dereference(rq->xdp_prog);
 	if (prog) {
-		u8 nr_frags_free, old_nr_frags = sinfo->nr_frags;
+		u8 old_nr_frags = sinfo->nr_frags;
 
 		if (mlx5e_xdp_handle(rq, prog, mxbuf)) {
 			if (__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT,
 						 rq->flags)) {
 				struct mlx5e_wqe_frag_info *pwi;
 
-				wi -= old_nr_frags - sinfo->nr_frags;
-
 				for (pwi = head_wi; pwi < wi; pwi++)
 					pwi->frag_page->frags++;
 			}
@@ -1817,10 +1816,8 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi
 		}
 
 		nr_frags_free = old_nr_frags - sinfo->nr_frags;
-		if (unlikely(nr_frags_free)) {
-			wi -= nr_frags_free;
+		if (unlikely(nr_frags_free))
 			truesize -= nr_frags_free * frag_info->frag_stride;
-		}
 	}
 
 	skb = mlx5e_build_linear_skb(
@@ -1836,7 +1833,7 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi
 
 	if (xdp_buff_has_frags(&mxbuf->xdp)) {
 		/* sinfo->nr_frags is reset by build_skb, calculate again. */
-		xdp_update_skb_frags_info(skb, wi - head_wi - 1,
+		xdp_update_skb_frags_info(skb, wi - head_wi - nr_frags_free - 1,
 					  sinfo->xdp_frags_size, truesize,
 					  xdp_buff_get_skb_flags(&mxbuf->xdp));
 
-- 
2.51.0



