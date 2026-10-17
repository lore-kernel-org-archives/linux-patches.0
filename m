Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CAAE3C0630;
	Sat, 17 Oct 2026 17:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258980; cv=none; b=PGA94oHBQ/XCwKF9oTyNZlaDe7EnMeFEZI7RAwVub2zMJ2cbZsJZdxYu26IugRpIjTlHf43kLcCVFd+tJNCFjungK2RL9d6bCc2jucU/Nv3P2YRu5d0hNcNHxV7lyUCmRFfJA/WRuatqHBZbWDW1oBgSUWN06em5twWivOke/i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258980; c=relaxed/simple;
	bh=F6wstA/Oc7n/rosHligzpbZFq4rTVRG93BI5LbZvzNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MX1At22bOMFahgPUQvcCXmvbCxQjnvnqRTY3RCOaMQ8Ni7UniiGJJLxAEyJm4rVGsqOLDCtOPQCOnDtdAwbBQDL/Vmyz0VT4AnG1Y+J4VWF4ISWkh051SHKOtTA5swd8ChcHOy6JOmsacBbb7kkjjWmgz2TwGpAsePTbQWcsmPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZQSwf1oh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZQSwf1oh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 895ED1F000C4;
	Sat, 17 Oct 2026 17:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258979;
	bh=wE9S76Wa6IBCHtG1SsY2OUGgsNLHytGxqMl9Fe/N3P4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZQSwf1ohDxSEmJV6J63to4w+z8oAuiArhPcsLdSsC5hoBQFV6ZOFzEC7XEhObuu+x
	 wpPaqagqLtm8f0UZoxDGyqYJhpvKppoo4vdujtso+dI2V/3WkjI7r8nvgzQJERmKva
	 6qSk10LLv+68+l6WIKs9nGF9PChD2vGlV2ZqjoOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1021/1674] net/mlx5e: xsk: Fix DMA and xdp_frame leak on XDP_TX xmit failure
Date: Sat, 17 Oct 2026 17:54:53 +0200
Message-ID: <20261017160457.341399961@linuxfoundation.org>
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

[ Upstream commit b69004f5a6ad32da84d8aa5b23b9c0caafe6252e ]

In the XSK branch of mlx5e_xmit_xdp_buff(), when sq->xmit_xdp_frame()
returns false (e.g. XDPSQ is full), the function returns without
unmapping the DMA address or freeing the xdp_frame allocated by
xdp_convert_zc_to_xdp_frame(). The xdpi_fifo push only happens on
success, so the completion path cannot recover these entries.

With CONFIG_DMA_API_DEBUG=y, the leak surfaces on driver unbind:

  DMA-API: pci 0000:08:00.0: device driver has pending DMA
  allocations while released from device [count=1116]
  One of leaked entries details: [device address=0x000000010ffd7028]
  [size=1534 bytes] [mapped with DMA_TO_DEVICE] [mapped as phy]
  WARNING: kernel/dma/debug.c:881 at dma_debug_device_change+0x127/0x180
  ...
  DMA-API: Mapped at:
   debug_dma_map_phys+0x4b/0xd0
   dma_map_phys+0xfd/0x2d0
   mlx5e_xdp_handle+0x5ae/0xac0 [mlx5_core]
   mlx5e_xsk_skb_from_cqe_mpwrq_linear+0xc4/0x170 [mlx5_core]
   mlx5e_handle_rx_cqe_mpwrq+0xc1/0x290 [mlx5_core]

Add the missing unmap + xdp_return_frame, matching the cleanup already
done in mlx5e_xdp_xmit(). has_frags is rejected earlier in this branch,
so no per-frag unmap is needed.

Fixes: 84a0a2310d6d ("net/mlx5e: XDP_TX from UMEM support")
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260604135446.456119-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index 13c7ed1bb37e9..17ef61700a01c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -102,9 +102,15 @@ mlx5e_xmit_xdp_buff(struct mlx5e_xdpsq *sq, struct mlx5e_rq *rq,
 
 		xdptxd->dma_addr = dma_addr;
 
-		if (unlikely(!INDIRECT_CALL_2(sq->xmit_xdp_frame, mlx5e_xmit_xdp_frame_mpwqe,
-					      mlx5e_xmit_xdp_frame, sq, xdptxd, 0)))
+		if (unlikely(!INDIRECT_CALL_2(sq->xmit_xdp_frame,
+					      mlx5e_xmit_xdp_frame_mpwqe,
+					      mlx5e_xmit_xdp_frame,
+					      sq, xdptxd, 0))) {
+			dma_unmap_single(sq->pdev, dma_addr, xdptxd->len,
+					 DMA_TO_DEVICE);
+			xdp_return_frame(xdpf);
 			return false;
+		}
 
 		/* xmit_mode == MLX5E_XDP_XMIT_MODE_FRAME */
 		mlx5e_xdpi_fifo_push(&sq->db.xdpi_fifo,
-- 
2.53.0



