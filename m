Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C873B1991AA;
	Wed, 20 Nov 2024 12:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107596; cv=none; b=czqpLM/5izrRr40HI6Vi8WMgkdEHwdaSdZIvxUdnZhQ+UDhURk3GS3UpeYyWfszJkD3lz3+8X3WGtYLrO71BryUKvhVKbPcf1XRJjQ3w6sLOnaudSmnVPHrVoTy0PShy4wH+c2VGo7x7f5m3oyIrUgfllsj/pMnOK46uMrNVY/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107596; c=relaxed/simple;
	bh=f8KfLiyhpQWqLy3cOPvEOkX2TjwGsTN+z4yigUW4VOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s6nFbtZ0JQCp/nTMj6BKttblxDQQSTG99H0o/bMyM50vanryn/oWUlndQ8hFetMCg0tMcbwztqb3r9fYl/5SFbqlurclM1Y+VhEU6pm5Iywg6zdQmk8Cyz5ZEUi44wnt68+MWm0Kx7LQ2HR/jNBN0XPcdPjwjJW50a/G4FlM4E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qFGveQ5d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qFGveQ5d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0187C4CECD;
	Wed, 20 Nov 2024 12:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107596;
	bh=f8KfLiyhpQWqLy3cOPvEOkX2TjwGsTN+z4yigUW4VOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qFGveQ5dK81Y4YXu4P+E/iny1Xfjrd5LIoTcFgGZ6gGZzVAykMqDV6eTHLrIrI9Vr
	 9vwTYNoXf0kXGbfOOAa5PRCJE/baPezJKlrc4we7H62ph9d8w5fPo42sCbTxffzmgy
	 1wU1XGCzjRVykk/V0DtyNUwpZtFh4tlNoQzymfvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 08/82] net/mlx5e: kTLS, Fix incorrect page refcounting
Date: Wed, 20 Nov 2024 13:56:18 +0100
Message-ID: <20241120125629.806031462@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.623666563@linuxfoundation.org>
References: <20241120125629.623666563@linuxfoundation.org>
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
 .../net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c    | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index d61be26a4df1a..3db31cc107192 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -660,7 +660,7 @@ tx_sync_info_get(struct mlx5e_ktls_offload_context_tx *priv_tx,
 	while (remaining > 0) {
 		skb_frag_t *frag = &record->frags[i];
 
-		get_page(skb_frag_page(frag));
+		page_ref_inc(skb_frag_page(frag));
 		remaining -= skb_frag_size(frag);
 		info->frags[i++] = *frag;
 	}
@@ -763,7 +763,7 @@ void mlx5e_ktls_tx_handle_resync_dump_comp(struct mlx5e_txqsq *sq,
 	stats = sq->stats;
 
 	mlx5e_tx_dma_unmap(sq->pdev, dma);
-	put_page(wi->resync_dump_frag_page);
+	page_ref_dec(wi->resync_dump_frag_page);
 	stats->tls_dump_packets++;
 	stats->tls_dump_bytes += wi->num_bytes;
 }
@@ -816,12 +816,12 @@ mlx5e_ktls_tx_handle_ooo(struct mlx5e_ktls_offload_context_tx *priv_tx,
 
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
-- 
2.43.0



