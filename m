Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C031D9A43;
	Tue,  8 Oct 2024 12:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389663; cv=none; b=GLhFfLiXZHZGNiuZQckMCLxE7Tfa8+jrWF+cdiLaqeIXy4nE7tw+Glpsw3c+0NO2HLWExw61aMHnuUb+aQ5VsU5mtCLnYiGEjtuupt154Z5IWPZhXaLIi9TBN+S/ePpDN+BdrWda12V83PPJ4TQm6kekhZDy08fIvgqMzCFnX0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389663; c=relaxed/simple;
	bh=g5WXhstBSI/EeFsBa50AXqmqBEtSAJVeQA8OBJFk1j8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MPfbnvGuOUZXvmebUOYwihYc0gex5gtrytk3GhH+Kwyfm/LZisDl+i6AUZJVLSrLrshnOD1u6jywzuhNJs5cG8E1mFrKOC++kGapjR7ULGK0Z3yoOwzI7wFBT/FVJEJRdhrZb9mDSCdfZmVh1M3s5rgmmO5MCuGS2xi5oYwNccQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SpFJ8Czf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SpFJ8Czf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07BAEC4CEC7;
	Tue,  8 Oct 2024 12:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389663;
	bh=g5WXhstBSI/EeFsBa50AXqmqBEtSAJVeQA8OBJFk1j8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SpFJ8CzfdkvbuAh/5RkQfTR+ATYE+ksIMsqNfX372QqIv4GICuFDfgklPgd0ppPeF
	 /aCVhwyC6vJlyE6+093UTUOhF4HTkL21UGEWgbtBA6a3ZCrCtwTY/VZLFlUnXTEEhi
	 npxB62s3sH7n4FV62q/mfBDNH8STZZiPIanpmxOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerd Bayer <gbayer@linux.ibm.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Maxim Mikityanskiy <maxtram95@gmail.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 018/482] net/mlx5: Fix error path in multi-packet WQE transmit
Date: Tue,  8 Oct 2024 14:01:21 +0200
Message-ID: <20241008115649.015991966@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index b09e9abd39f37..f8c7912abe0e3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -642,7 +642,6 @@ mlx5e_sq_xmit_mpwqe(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 	return;
 
 err_unmap:
-	mlx5e_dma_unmap_wqe_err(sq, 1);
 	sq->stats->dropped++;
 	dev_kfree_skb_any(skb);
 	mlx5e_tx_flush(sq);
-- 
2.43.0



