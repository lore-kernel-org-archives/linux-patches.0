Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB433192D73;
	Thu,  5 Sep 2024 09:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530274; cv=none; b=ZfyNr01srcMXHZi7Arv4Vs77MUV5KArr1OjprsvStPSzw1cwtvyOnm74pqYaJcZeCHq1OUsmMzfK9LY6tBEWya2ECfme3ZmreresNL1O7R5934rr0Lz3tQqv1dQs9EmC5WUqauB0bZP314JQwTDZgPf9/Bay3IBCZuZFGRjz3w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530274; c=relaxed/simple;
	bh=TIB84f8tlK8VT/5xNTuUDO1Q8mPMZaOjFThN8/BqlFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j2AaPmcr3RR39Shcu+wpn/4ttACCNXUzal2R947yZG5PB8ySOyTQ3NVrgwzkE0o5APEVL4ZAjIH3pwHDlO9f8DVEFCtfmHW6IA6o396ytTkwcpxwTSp3UUm3lj86PeZBQGC7WGUQxUSxAipsGV61qwJSjy6MAYe9cAYmY55NMcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bf8hbEPy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bf8hbEPy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A013C4CEC3;
	Thu,  5 Sep 2024 09:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530274;
	bh=TIB84f8tlK8VT/5xNTuUDO1Q8mPMZaOjFThN8/BqlFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bf8hbEPyY8RciEaGzMfH+cU8BhitDSZO+ZwqtiDNz8ldk0DXQsAHciKpkWAje6B25
	 DOEuaHI7QAL/bjy2rxW4wayfYu6jqAf+i93d3j+6G09CPzelhJepUgg86b1duzqq2O
	 2UMOH7NV9MPTjuTODx+yir7iV5xHtQBhdoBuR7yA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 108/132] net/mlx5e: SHAMPO, Fix incorrect page release
Date: Thu,  5 Sep 2024 11:41:35 +0200
Message-ID: <20240905093726.430496952@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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

[ Upstream commit 70bd03b89f20b9bbe51a7f73c4950565a17a45f7 ]

Under the following conditions:
1) No skb created yet
2) header_size == 0 (no SHAMPO header)
3) header_index + 1 % MLX5E_SHAMPO_WQ_HEADER_PER_PAGE == 0 (this is the
   last page fragment of a SHAMPO header page)

a new skb is formed with a page that is NOT a SHAMPO header page (it
is a regular data page). Further down in the same function
(mlx5e_handle_rx_cqe_mpwrq_shampo()), a SHAMPO header page from
header_index is released. This is wrong and it leads to SHAMPO header
pages being released more than once.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://lore.kernel.org/r/20240603212219.1037656-3-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 79ec6fcc9e25..57b0e26696e3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -2369,7 +2369,8 @@ static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cq
 	if (flush)
 		mlx5e_shampo_flush_skb(rq, cqe, match);
 free_hd_entry:
-	mlx5e_free_rx_shampo_hd_entry(rq, header_index);
+	if (likely(head_size))
+		mlx5e_free_rx_shampo_hd_entry(rq, header_index);
 mpwrq_cqe_out:
 	if (likely(wi->consumed_strides < rq->mpwqe.num_strides))
 		return;
-- 
2.43.0



