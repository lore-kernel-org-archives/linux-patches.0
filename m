Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215224;
	b=kbsyHgmWplCDnrwLOISXY1E6q1KrPGQsK/U8utquIceXZuxxlr4qFsdgtB17T8bwN9vp
	 aAWTrekkp4wRu5XhBm9JDPBS8+4bJUHItw32Yb/FCRZl2jCuEjqGmGPfQbwCvPc8YHvtO
	 fEhSnpmdDxk8SLn1GTSnxmD2pdFpVNKQet1wO/mE34ePWw20W0ffqWl2dBiRT/EXtjj3i
	 rKyRDnmyrOJoMHhrOzLQngxT0dp6+DzOmWfNmlttQAq0pVmAKbCSwwJus0cUYBlBEkamw
	 m9yLEC/8BRK8a8IN7OuJliedTjtyZKjnAPLd+isO66bVTg6c9yqqB59fBGUWeFwicgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215224;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vAa/R8uE46vZ4IERlcYOrl3uy9eFokQyW0Dh/EzEOPY=;
	b=Ltk7cxYcuRah4ACBgcO3mAdwgtjtIXjj57oFe9f8xd6TIaZP2BYqyAnxNAda0GbUOye8
	 AT0AALSJhgN/F7xsw5JtM/P9K0nkGgMfpoITKtSBHivIz0+ztljrPByK6rOZLPyjDvgjl
	 p6V2/qt2fjdM2bYngHv4AbAfltCcSKSdCZ/+cpe/j5qyDbrKYaUJ0l7meB+LJp96zrG+2
	 gCBf5rxXkUNvLc6dW0pVDEIDNtNla+xthhtQUc4yqWGIPiBRRKeGtM/LikXB8MtXURPG7
	 rNUJxjSU4KuEeZHRa5Uif/QZLBf6ka+NHUz5mulMOizIruGNZ1R/53E8Ztwlqaj9H4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ocXh3uCq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D61606A31A;
	Wed, 28 Oct 2026 19:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ocXh3uCq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E59011F01825;
	Wed, 28 Oct 2026 19:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215224;
	bh=vAa/R8uE46vZ4IERlcYOrl3uy9eFokQyW0Dh/EzEOPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ocXh3uCqNmhEAOyDQ/ItHElC/T89q/Mh7sAyjkui71Ezck/4aegAeS4t3YarZ5Ycc
	 Bnat0P0PI0mstnr+kLSx5PpwNsWrcVtX2MSDQ/n2++XQUGZ5ksafOoCTSMm2Pk18dn
	 xHM6dr1ykn5fYPNXCCG/+o48kc8QnR2fLj5q30CA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1092/1887] net/mlx5e: xsk: Fix DMA and xdp_frame leak on XDP_TX xmit failure
Date: Wed, 28 Oct 2026 17:53:08 +0100
Message-ID: <20261028170524.257485116@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index 20507ef2f9569..98e9df752c4bb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -100,8 +100,12 @@ mlx5e_xmit_xdp_buff(struct mlx5e_xdpsq *sq, struct mlx5e_rq *rq,
 		xdpi.frame.dma_addr = dma_addr;
 
 		if (unlikely(!INDIRECT_CALL_2(sq->xmit_xdp_frame, mlx5e_xmit_xdp_frame_mpwqe,
-					      mlx5e_xmit_xdp_frame, sq, &xdptxd, NULL, 0)))
+					      mlx5e_xmit_xdp_frame, sq, &xdptxd, NULL, 0))) {
+			dma_unmap_single(sq->pdev, dma_addr, xdptxd.len,
+					 DMA_TO_DEVICE);
+			xdp_return_frame(xdpf);
 			return false;
+		}
 
 		mlx5e_xdpi_fifo_push(&sq->db.xdpi_fifo, &xdpi);
 		return true;
-- 
2.53.0



