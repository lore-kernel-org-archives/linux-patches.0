Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5EA87406A;
	Mon, 29 Jan 2024 17:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548573; cv=none; b=BKpGsKYhRUFQeUyYTuVznRYmQsgdJZ0piDK59Vw+4/3A8Z/92O9239l823ydAq0HayfUMI6CyZVdu/ftWFnOkGXeK6UQP39ZjA6l+9RcqvRwmi/1zWbgpuD4dROOtYGqj5E58EIc6BWgHfD7aHUvCqDzrxyhRx8UeUNTDo1OFwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548573; c=relaxed/simple;
	bh=GrlhRRXR+2iOVaW3Q9LrCOkXTqYXp/ZXMQHNp4fwPNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YrRn/dogbXfdFkF5l+i0Ir1LtiEPn9N8zYtZCKuOPXZxolapHTMRAoKCtyjzdSo1cSmOq0QkYD2eg21fBsWmvwgozcSQu1qPOf2DWpaug+fnwXR+8mHMTt4df+DaSDJL7t6I6tzPf0E9BA9dC7RHkD8P0Kv9EflHSmzuau9zuSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F8CNW+sB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F8CNW+sB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FCEEC433F1;
	Mon, 29 Jan 2024 17:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548573;
	bh=GrlhRRXR+2iOVaW3Q9LrCOkXTqYXp/ZXMQHNp4fwPNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F8CNW+sBEk7V7JEEhHrZqPp7eZ+feedmQzo1C5BFwoFl0QZGo07ZETUThc7Pj/ACb
	 LyDHmu2Ejn3QK/4c2Q1X+VdlG5Q5RNOJiFhAQ9VAu8gKXoee87OamRSxyGG9WkAilt
	 x8WABNhOXj+erJCnjXQGLCafLtoEEKQM27WWS7RY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 200/331] net/mlx5e: Allow software parsing when IPsec crypto is enabled
Date: Mon, 29 Jan 2024 09:04:24 -0800
Message-ID: <20240129170020.728459374@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 20f5468a7988dedd94a57ba8acd65ebda6a59723 ]

All ConnectX devices have software parsing capability enabled, but it is
more correct to set allow_swp only if capability exists, which for IPsec
means that crypto offload is supported.

Fixes: 2451da081a34 ("net/mlx5: Unify device IPsec capabilities check")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/params.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index e097f336e1c4..30507b7c2fb1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -1062,8 +1062,8 @@ void mlx5e_build_sq_param(struct mlx5_core_dev *mdev,
 	void *wq = MLX5_ADDR_OF(sqc, sqc, wq);
 	bool allow_swp;
 
-	allow_swp =
-		mlx5_geneve_tx_allowed(mdev) || !!mlx5_ipsec_device_caps(mdev);
+	allow_swp = mlx5_geneve_tx_allowed(mdev) ||
+		    (mlx5_ipsec_device_caps(mdev) & MLX5_IPSEC_CAP_CRYPTO);
 	mlx5e_build_sq_param_common(mdev, param);
 	MLX5_SET(wq, wq, log_wq_sz, params->log_sq_size);
 	MLX5_SET(sqc, sqc, allow_swp, allow_swp);
-- 
2.43.0



