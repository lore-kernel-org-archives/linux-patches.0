Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462C61C07DF;
	Tue, 15 Oct 2024 13:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997823; cv=none; b=tL+dyi5V/vivO684nEQx1G3mOBLrkMY2Lqhg3uAfaZuq+IbxfAfYgOWxQ70mKMRkbtpGRSYq6K5szQvIRjdV0hSASHTyXd57I3AABtlF7MZCqbx1UTLHVxrZ6kKJGrLah8Fl3mXI5i48mj4veaS+C6PtiaFTjQfxbMOHC4myZgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997823; c=relaxed/simple;
	bh=Gw+vDIFrrwxbJwjstRgzzloAwExni1qIPlg7mE8ybOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UwSyaPp4pEZe/OPszAMDs0wy+kvXHAarJAGjGDYIIT80pwe8UPZyJP4UuKSuQ+PllFxN5LRqpIwUNIE+wmEqmJqo7O8YI0hvCId9F9Qjx2tgRsku/hMy3N1pCPoANeYmt80ZXg8yVoagXQxLmoUj7Nq4nw+jdkT0zBiylXKrcMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ga7sw9gn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ga7sw9gn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1405C4CEC6;
	Tue, 15 Oct 2024 13:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997823;
	bh=Gw+vDIFrrwxbJwjstRgzzloAwExni1qIPlg7mE8ybOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ga7sw9gniGAb44xdCtBaGssDGV5YTksJC5LgYovq0u5Em5XJdZmPARHwBFmT6D9l3
	 TzT/t/9Iq37kcbu6W3Y6u7KKrOJmaWAbLeT0VwdQ1IHJROi/2Ec1Iqtr/9qhMZhTp2
	 xd6NJPTYDf6dvHYx6iyBnZv7d63jnlTUlGO23wXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerd Bayer <gbayer@linux.ibm.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Maxim Mikityanskiy <maxtram95@gmail.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 270/518] net/mlx5: Fix error path in multi-packet WQE transmit
Date: Tue, 15 Oct 2024 14:42:54 +0200
Message-ID: <20241015123927.414406155@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gerd Bayer <gbayer@linux.ibm.com>

[ Upstream commit 2bcae12c795f32ddfbf8c80d1b5f1d3286341c32 ]

Remove the erroneous unmap in case no DMA mapping was established

The multi-packet WQE transmit code attempts to obtain a DMA mapping for
the skb. This could fail, e.g. under memory pressure, when the IOMMU
driver just can't allocate more memory for page tables. While the code
tries to handle this in the path below the err_unmap label it erroneously
unmaps one entry from the sq's FIFO list of active mappings. Since the
current map attempt failed this unmap is removing some random DMA mapping
that might still be required. If the PCI function now presents that IOVA,
the IOMMU may assumes a rogue DMA access and e.g. on s390 puts the PCI
function in error state.

The erroneous behavior was seen in a stress-test environment that created
memory pressure.

Fixes: 5af75c747e2a ("net/mlx5e: Enhanced TX MPWQE for SKBs")
Signed-off-by: Gerd Bayer <gbayer@linux.ibm.com>
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Acked-by: Maxim Mikityanskiy <maxtram95@gmail.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 3736680680715..9b1e43ff8ae1e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -601,7 +601,6 @@ mlx5e_sq_xmit_mpwqe(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 	return;
 
 err_unmap:
-	mlx5e_dma_unmap_wqe_err(sq, 1);
 	sq->stats->dropped++;
 	dev_kfree_skb_any(skb);
 }
-- 
2.43.0



