Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9867E1494DB;
	Thu,  5 Sep 2024 10:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530622; cv=none; b=jfNFL5gKaE1R/MBQ0y2g91FvEzqaTenpOY5H98HjycsdAZoxdAjtTepSW0YiP3sDgLZgbkjS1Z+3GetsVuu5SMXfxhE0lrMb1OLp41qootwOXWA0o677y1usOjXVM7C99cUSGHIOQfuZi6mfr5t6sKg2R5rB+M9SgdiwgB9FDsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530622; c=relaxed/simple;
	bh=sA8KWkedAoCAcmS9Tf+uhiMjaJzm7d2K/Dm4EIVRYJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f0mPDW8FvZiq7Q6mI2lk6/7unoF5UBoX8PaKRiWPoyAlcP6ocV4al+lpciAX3037LjVOC1nN4Ftoxk+iOUFezZR9G9y6Ym4hVi5aBrFQf4jL60+oO65jFro5BcGzcUqZCNkGyVWIcLHwQynGEqfOF4Ohsr0NKQICj+PBYeOCyhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fe/I8f7o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fe/I8f7o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3831C4CEC3;
	Thu,  5 Sep 2024 10:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530622;
	bh=sA8KWkedAoCAcmS9Tf+uhiMjaJzm7d2K/Dm4EIVRYJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fe/I8f7o8Mkqc6oRakTVIOvXJHdb6gLMGGBhrhYyYzzCfqjYwDYSn1FCf1eB19AcZ
	 Lvd4JMQ4mU+Z3NEg0SjU9FrYpHsGL6c1eTUU58QCwMwlW49m+LoikTfspcORxFOjD9
	 M2G8G1NIe2JmAJiNrlPI1fb/xye07iqWyuyrJ834=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 081/101] net/mlx5e: SHAMPO, Fix incorrect page release
Date: Thu,  5 Sep 2024 11:41:53 +0200
Message-ID: <20240905093719.298378117@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
References: <20240905093716.075835938@linuxfoundation.org>
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
index 97d1cfec4ec0..ccddfa49e96c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -2141,7 +2141,8 @@ static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cq
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



