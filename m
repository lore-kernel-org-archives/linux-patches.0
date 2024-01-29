Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6634B15703F;
	Mon, 29 Jan 2024 17:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548328; cv=none; b=r9tv7/yBiW8nt8CyWprtc85meHlwjUC4JT9gBlUXeWCluTJt4AlJPlj96YS43l6IBxrOB+DtAivrKAtepC3sCuvPgSW3ChD9i1WSHkiTrJuTbLt+Vw/zlKLJHV95Vep5QXes93wFb6suPS++mCSWmeq5zFSiiox6xl9E3S9X72k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548328; c=relaxed/simple;
	bh=PBPkinmIZNgRpdJ6Nz9HaxiREPrQd/SKrZEMB/6Eeww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ry6BM8RCd/s3GuaM7Wt6g1FzYmkZoEPaKTFd5yFZZDtBcOjGWjOCtn4mvQTSIJ0DG2n0uNgoXhNM/Vp6CB5yS/s0aZaY8mSgyqnjyUn0R4mMKHSQ+bWSlzeAmGh3T9qxF8dr7OmBrGmzw9EAqYCbWMFghyIDfjbTzI0dcJ3Jwzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ha54yZ3e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ha54yZ3e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D9FAC433C7;
	Mon, 29 Jan 2024 17:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548328;
	bh=PBPkinmIZNgRpdJ6Nz9HaxiREPrQd/SKrZEMB/6Eeww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ha54yZ3edkh8yOeriHrhUf4UiKCM0yryXBz73NRAijFq8ADegv/FAV9qLu1GUkvfo
	 YCbWWe2aR0q1OmdPOZitlpJZErT5H9TTpk5vp11bB6bhgaJYTiu5Oz5NEyT6ehNAgy
	 SwmBJHuRlOSrWbpWoTub7G4HtPYzjQWutbSkUWgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 098/185] net/mlx5e: Allow software parsing when IPsec crypto is enabled
Date: Mon, 29 Jan 2024 09:04:58 -0800
Message-ID: <20240129170001.745906693@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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
index 29dd3a04c154..d3de1b7a80bf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -990,8 +990,8 @@ void mlx5e_build_sq_param(struct mlx5_core_dev *mdev,
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



