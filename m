Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC2D1DA60C;
	Tue,  8 Oct 2024 12:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391139; cv=none; b=apssuphWhjjHb3TgHoa/KNfjK+8GgzP0OG5AwCcA8NX+MmYlL5AWZuBvgKgDrQ+f/XnJ/kAeiUumCH6I/5WO5nJAr5xV/bZh8FGY0pGBu8bX0Nwso/VgHr1FT5EU9WDHWQwB4RQ8ueaYErzXnFPsQAQqwtuiam7iaewBeOEIVJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391139; c=relaxed/simple;
	bh=NJDXvGAFYKqxoEmqZ1irQu8QEaUbyovuRavVTO5VZlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XLJAgO8IK0M6XOzpq76fHUzyhe+vfkCitn2wZEtmGDmIVxItkn7nQ32qSqA4jUppLP9y7dlxt128NUYL1pt9tjUTE0YZ4j6l61MKpKnPr/wW7KbI+wxXQA1nrYLJ4Tbw3NM7o58CPc2eDn4q6whwxgfHI2KGRoqmmLR8T4JbRZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kZtfUYBR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kZtfUYBR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 120CDC4CEC7;
	Tue,  8 Oct 2024 12:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391139;
	bh=NJDXvGAFYKqxoEmqZ1irQu8QEaUbyovuRavVTO5VZlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kZtfUYBR/0iucqVe4lRUzjn1xwlFP/qNJQkeIIJQYr2n8HLtVJeTFtg3Hsph6adSc
	 Z9v74NXB31529AmgTIFusEXO6JocHV6cct0elBTjMlccTRxxiqGpdEy7MTmSNDWU/t
	 /b2uZ/QFWZ9M+R7f4hpjQu6xXuhfEjDo/B01z4nY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerd Bayer <gbayer@linux.ibm.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Maxim Mikityanskiy <maxtram95@gmail.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 020/558] net/mlx5: Fix error path in multi-packet WQE transmit
Date: Tue,  8 Oct 2024 14:00:50 +0200
Message-ID: <20241008115703.018889197@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



