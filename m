Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 520F63922F
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:58:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C63ABC4339E;
	Wed,  7 Jun 2023 20:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686171482;
	bh=pwW/HxR4ngBKfLurQoSwrY0D1jxwjTlKEpdfKev7gc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lqAU60Ihf4XQ4mZhInP8PlQz8drMUh90rrFbqNej1hpXejdeD3BbH4Q/nbM2zN4Ll
	 ZgdmpTgNG6HF0l5nJfN6p41kPeIpNQNAHfB4drAVq60KDc8bZNH/Pi7DPr/mgY3DeZ
	 7j51qICX1GYpq0OIrZO5riM5DEAtseyI/qxoMbgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moshe Shemesh <moshe@nvidia.com>,
	Shay Drory <shayd@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 034/159] net/mlx5: Read embedded cpu after init bit cleared
Date: Wed,  7 Jun 2023 22:15:37 +0200
Message-ID: <20230607200904.784790892@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200903.652580797@linuxfoundation.org>
References: <20230607200903.652580797@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Moshe Shemesh <moshe@nvidia.com>

[ Upstream commit bbfa4b58997e3d38ba629c9f6fc0bd1c163aaf43 ]

During driver load it reads embedded_cpu bit from initialization
segment, but the initialization segment is readable only after
initialization bit is cleared.

Move the call to mlx5_read_embedded_cpu() right after initialization bit
cleared.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Fixes: 591905ba9679 ("net/mlx5: Introduce Mellanox SmartNIC and modify page management logic")
Reviewed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index d75facc5c5031..13eceb6016344 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -781,7 +781,6 @@ static int mlx5_pci_init(struct mlx5_core_dev *dev, struct pci_dev *pdev,
 	}
 
 	mlx5_pci_vsc_init(dev);
-	dev->caps.embedded_cpu = mlx5_read_embedded_cpu(dev);
 	return 0;
 
 err_clr_master:
@@ -1003,6 +1002,7 @@ static int mlx5_function_setup(struct mlx5_core_dev *dev, bool boot)
 		goto err_cmd_cleanup;
 	}
 
+	dev->caps.embedded_cpu = mlx5_read_embedded_cpu(dev);
 	mlx5_cmd_set_state(dev, MLX5_CMDIF_STATE_UP);
 
 	err = mlx5_core_enable_hca(dev, 0);
-- 
2.39.2



