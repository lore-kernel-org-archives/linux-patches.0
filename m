Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4EE158D96;
	Mon, 29 Jan 2024 17:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548156; cv=none; b=okRdWXrh1nmbGX6dWZJLyGySSgGBXoiVMOCG4CVBylELyLh5XwXxJOY7WPdHXfW21YCpQyub1dKfoo/MTIhfYFF2xEqYV9OoaZKLkKzVN8LjykxnSvxeXuQ4/BY3eZiXgxZl8jcYqO2p/Reuyc/cZlCwJSX5h03FZEUscEiKK8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548156; c=relaxed/simple;
	bh=8XD2uR/aFaWTM+nLvsqlHY8EpEyNV/7B6Rt6BmHNg6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IVvRu57DTi/d04ljicFpMdb2NmmQxLirCJS3ON0I49treSjkQLHjUsOiqNSo/eexN3nAFReQUIxf4AWTOG058YlARlxymlh38IcSxS3sGTzblXpi7mOwWUUraiXPt06IcFKhk/7kdyTrpECAUZ7d7DLN4p71w7BJUQjBA3UNGqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bdJwk6TG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bdJwk6TG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E79E5C43394;
	Mon, 29 Jan 2024 17:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548156;
	bh=8XD2uR/aFaWTM+nLvsqlHY8EpEyNV/7B6Rt6BmHNg6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bdJwk6TGwc62xLeKG0/tyZzi1zZ+1xbQjq523sm6zN6zV/8g5Lmsf/BQneLrGUcl6
	 4wrh5ytN9rcItYam3KxYYRIGdSnO2sc+m5l8y8oxU61XFl7OlK5LGPreBLFRvHoGCW
	 4PRT6hFlNWy3pT+yKurXHjYvaDUAckYCJQBI58bU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 194/346] net/mlx5e: Allow software parsing when IPsec crypto is enabled
Date: Mon, 29 Jan 2024 09:03:45 -0800
Message-ID: <20240129170022.106289571@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



