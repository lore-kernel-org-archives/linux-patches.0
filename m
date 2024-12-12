Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA36222D67;
	Thu, 12 Dec 2024 17:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024964; cv=none; b=qBR/+klH4E9OBcs1agyBGyswbD/j1XcNIaVT6gxcdlwkJ9xKG4cey+eVvdDjPJsBTz2WmzOwGOmnJeH0UE/V5Lwj9NfO2QDv673RexbKGjOYiodcDq/2ppf2jM7KtSSUkvzdQMHISqLkQp7ulEpEQqTvNLiJ0FXrnfay82eFVtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024964; c=relaxed/simple;
	bh=nHK+rx5yTAvWB8HSiFE8AU2qSbhCq0f32HZ7ZdSqnXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J32xOAQJ/AWOam7thKftNpAwDN6ETDF7v4tK9oynSpwyJMdJmjpIVECXUJKGEvYT6/TCZeTiOy4XsEC+GqhICrVDgJYZNhifykH5dYskFGU4e6j5iqew7cl/vzaX0Jdm7uWoEtC3JGefHiozfpNngAV9J+blWV5x9eL4reX0euc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UHiQcdsX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UHiQcdsX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87E9AC4CECE;
	Thu, 12 Dec 2024 17:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024963;
	bh=nHK+rx5yTAvWB8HSiFE8AU2qSbhCq0f32HZ7ZdSqnXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UHiQcdsXKL9rlSWm/hXy5z0FsWdbtJUoLvMdjSHerolMXOQAOo55MroErDQgwIchj
	 e1Ot5fahXquCEiNbw59sbLCxcq4IWqQQ1VuUPKXbrSSqX14HxzxogSwagW2GpE+/u4
	 PvHLy3931ESfCppwfxo4BnHz8DVHlt+jjjvyGY9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 003/321] net/mlx5e: kTLS, Fix incorrect page refcounting
Date: Thu, 12 Dec 2024 15:58:41 +0100
Message-ID: <20241212144229.447918115@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dragos Tatulea <dtatulea@nvidia.com>

[ Upstream commit dd6e972cc5890d91d6749bb48e3912721c4e4b25 ]

The kTLS tx handling code is using a mix of get_page() and
page_ref_inc() APIs to increment the page reference. But on the release
path (mlx5e_ktls_tx_handle_resync_dump_comp()), only put_page() is used.

This is an issue when using pages from large folios: the get_page()
references are stored on the folio page while the page_ref_inc()
references are stored directly in the given page. On release the folio
page will be dereferenced too many times.

This was found while doing kTLS testing with sendfile() + ZC when the
served file was read from NFS on a kernel with NFS large folios support
(commit 49b29a573da8 ("nfs: add support for large folios")).

Fixes: 84d1bb2b139e ("net/mlx5e: kTLS, Limit DUMP wqe size")
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20241107183527.676877-5-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -233,7 +233,7 @@ tx_sync_info_get(struct mlx5e_ktls_offlo
 	while (remaining > 0) {
 		skb_frag_t *frag = &record->frags[i];
 
-		get_page(skb_frag_page(frag));
+		page_ref_inc(skb_frag_page(frag));
 		remaining -= skb_frag_size(frag);
 		info->frags[i++] = *frag;
 	}
@@ -321,7 +321,7 @@ void mlx5e_ktls_tx_handle_resync_dump_co
 	stats = sq->stats;
 
 	mlx5e_tx_dma_unmap(sq->pdev, dma);
-	put_page(wi->resync_dump_frag_page);
+	page_ref_dec(wi->resync_dump_frag_page);
 	stats->tls_dump_packets++;
 	stats->tls_dump_bytes += wi->num_bytes;
 }
@@ -412,12 +412,12 @@ mlx5e_ktls_tx_handle_ooo(struct mlx5e_kt
 
 err_out:
 	for (; i < info.nr_frags; i++)
-		/* The put_page() here undoes the page ref obtained in tx_sync_info_get().
+		/* The page_ref_dec() here undoes the page ref obtained in tx_sync_info_get().
 		 * Page refs obtained for the DUMP WQEs above (by page_ref_add) will be
 		 * released only upon their completions (or in mlx5e_free_txqsq_descs,
 		 * if channel closes).
 		 */
-		put_page(skb_frag_page(&info.frags[i]));
+		page_ref_dec(skb_frag_page(&info.frags[i]));
 
 	return MLX5E_KTLS_SYNC_FAIL;
 }


