Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA5E1DE4CC;
	Tue,  8 Oct 2024 13:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392965; cv=none; b=Ho9rZsBUFzSh+ciKo+5OYep/bQ7XYoQDGD32LjGQhJMmoE7ZxtA5N1LpLn6TCMA3V43WVVS0a08ehw73ecU47AAJGOb/I3gFP7qKYwKgR3i7iX8np3xus7drVKV1q+dzcCZYZFSR4fG1XDwPFKd/FrI0NRhbkAj8LS2yRr1MGHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392965; c=relaxed/simple;
	bh=WZ9ZInv4don8Jf7dtUAcMVE2CSbTRpnYusfhe7NYjaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ip2Ti0tqgrQKQk59ijIDBZ3odcOITSA1NjjPVR7W1UjM3wftO4fyk6QW51TieEmQiPoTEtmJTg3vTABJu5mGSfJ9dTdoUY/kbVTZyv0aLADhZPtL5kkpbzU3Rcb1vxjRRLvU8zrOK7XOOgW9XxnJywmubXJnEDbsg4rWr/Bv/KY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E1V9jvjC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E1V9jvjC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D536BC4CEC7;
	Tue,  8 Oct 2024 13:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392965;
	bh=WZ9ZInv4don8Jf7dtUAcMVE2CSbTRpnYusfhe7NYjaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E1V9jvjCoDO/cQPA6paRE1NiS3NS96zK1w4BF6NP1gfojaZcozOWmbh8iEcxOX6lc
	 hKkDlPPL8nNJqgcsaV0bqpANTghFkEEBh54WTCZSn70WgvHK0FuzmHcwcD4gjdlglz
	 DLx5b3JZftRtMOFfnq7dhdBsTJkqfoLhGiqA78KY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerd Bayer <gbayer@linux.ibm.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Maxim Mikityanskiy <maxtram95@gmail.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 013/386] net/mlx5: Fix error path in multi-packet WQE transmit
Date: Tue,  8 Oct 2024 14:04:18 +0200
Message-ID: <20241008115629.843486997@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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
index 3001a52e1ac2e..85d6334308e31 100644
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



