Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B066833993;
	Thu, 15 Jan 2026 16:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496176; cv=none; b=rWXeLThl9cOVXrMRvEGr4IrfEhpKZHw0aA3egg+c2x3LSJ2vSrsxjSFbLTNbcvHXSH9wdQc1skZKRpHZDeriB+xwot5LHfd7NP4vYFNHtNzvyNTvCoA8QPTE1f6RJ8C6bK7W4ju/niF4GjbNm35VWoVzEROXox7VIDlbsgGhJwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496176; c=relaxed/simple;
	bh=6WXyfY8jn0/od1MQTEJ6WJdyuyzwyUx4IgYcs1RSynM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ouOuDPRbT8z8agTZ09mJVY72xNWM4j8cA6waOIt7cq2r2WP/u1t9DHe6M4D9V1g79xY5RrNBNastrrkxKYYIGUEGbo2hLGYMn8gxuP5X2jCODhb0d6IUEIpjRg5AeUqHPyOqNfEmkB6JpgIwVXYGnAzBJIwfpD/5u+aeBB8Qy74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sKPhPPmq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sKPhPPmq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFAFEC116D0;
	Thu, 15 Jan 2026 16:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496176;
	bh=6WXyfY8jn0/od1MQTEJ6WJdyuyzwyUx4IgYcs1RSynM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sKPhPPmqE85+0WEfyyNPk0fLNa6C5cnGk0VlUQe8h8ph+kYCkxB8PSeOLCIGvLj1t
	 229w/FQel6BAWnpBKGzqvgZxUP/anNxMi/y84Xq4szk0TUDjfWUAqH6geVDGFSKny+
	 z1Dk5FQ3Mi1gyuzW7Ov+eOpARkmOUenXNq7Ps8pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Lazar <alazar@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 103/181] net/mlx5e: Dont gate FEC histograms on ppcnt_statistical_group
Date: Thu, 15 Jan 2026 17:47:20 +0100
Message-ID: <20260115164206.038162015@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexei Lazar <alazar@nvidia.com>

[ Upstream commit 6c75dc9de40ff91ec2b621b78f6cd9031762067c ]

Currently, the ppcnt_statistical_group capability check
incorrectly gates access to FEC histogram statistics.
This capability applies only to statistical and physical
counter groups, not for histogram data.

Restrict the ppcnt_statistical_group check to the
Physical_Layer_Counters and Physical_Layer_Statistical_Counters
groups.
Histogram statistics access remains gated by the pphcr
capability.

The issue is harmless as of today, as it happens that
ppcnt_statistical_group is set on all existing devices that
have pphcr set.

Fixes: 6b81b8a0b197 ("net/mlx5e: Don't query FEC statistics when FEC is disabled")
Signed-off-by: Alexei Lazar <alazar@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Link: https://patch.msgid.link/20251225132717.358820-3-mbloch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index a2802cfc9b989..a8af84fc97638 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -1608,12 +1608,13 @@ void mlx5e_stats_fec_get(struct mlx5e_priv *priv,
 {
 	int mode = fec_active_mode(priv->mdev);
 
-	if (mode == MLX5E_FEC_NOFEC ||
-	    !MLX5_CAP_PCAM_FEATURE(priv->mdev, ppcnt_statistical_group))
+	if (mode == MLX5E_FEC_NOFEC)
 		return;
 
-	fec_set_corrected_bits_total(priv, fec_stats);
-	fec_set_block_stats(priv, mode, fec_stats);
+	if (MLX5_CAP_PCAM_FEATURE(priv->mdev, ppcnt_statistical_group)) {
+		fec_set_corrected_bits_total(priv, fec_stats);
+		fec_set_block_stats(priv, mode, fec_stats);
+	}
 
 	if (MLX5_CAP_PCAM_REG(priv->mdev, pphcr))
 		fec_set_histograms_stats(priv, mode, hist);
-- 
2.51.0



