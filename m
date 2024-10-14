Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B9A1A76A5;
	Mon, 14 Oct 2024 15:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918667; cv=none; b=sTAKnYTpSGKQ48ty5QByUJrYxmlMPHn6uWTFCDan+39Gf7QTJWjmoQswxpfS0l5nU/N442QMdKvBkRuiRfG6n8BDo/WhgYeQLSVHyQ6xY8oSCUruRrx8XY2tohShOCeJi5KpSip4ISCRkqtJJiP+Rm/SrNTiqYa+oqX098v2N0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918667; c=relaxed/simple;
	bh=crHkjEYyl/cDS1vz+bE6HYouMhHWV6oTZzai1YkByuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RQgrLxgYcwPEKZZcZ7702FioRy+471rwJy03HpxZCSHvzkjNO0nCipw1Z56EHcOMsPMEOOZ08Q2cLcdGcC3+Jo4wzor2ti2s2jIer/hWu3pHotjYrI7kxLan/mX0ZDX1ToURyBzHis9EFUGs7zRwQ6KUgO9VGS/LwDPQ/hrQguE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uUMkNwl0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uUMkNwl0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E972C4CEC3;
	Mon, 14 Oct 2024 15:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918666;
	bh=crHkjEYyl/cDS1vz+bE6HYouMhHWV6oTZzai1YkByuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uUMkNwl0uFOsEAMygxR10/1WQQX9syupAAFzmt0ag5Q5qAGymZLdrzledloqcUjEP
	 cHFItj0TZXifyeP1FjK9raXW0Ipyf1BWmtxzivtOCzHKTWShN8kMebmt3KkLbG2Znx
	 evHbgDUD9TTa9rtErvNvQ07SiozGaLFkAfNOjbgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerd Bayer <gbayer@linux.ibm.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Maxim Mikityanskiy <maxtram95@gmail.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 387/798] net/mlx5: Fix error path in multi-packet WQE transmit
Date: Mon, 14 Oct 2024 16:15:41 +0200
Message-ID: <20241014141233.152068545@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e6e792a38a640..7aea25c09f72b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -633,7 +633,6 @@ mlx5e_sq_xmit_mpwqe(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 	return;
 
 err_unmap:
-	mlx5e_dma_unmap_wqe_err(sq, 1);
 	sq->stats->dropped++;
 	dev_kfree_skb_any(skb);
 	mlx5e_tx_flush(sq);
-- 
2.43.0



