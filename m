Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E6FA93F
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:16:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08CB6C433D2;
	Tue, 10 Jan 2023 18:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374561;
	bh=1vPwRMs2yjD0xjGBksJHtpbk0dkBM+7GvvZTraCV8AU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lYpDFdnCvQn+9yvNoIJF9ZnsVpD7hPZWtb3ojEm4+9YkFPzCv1+pa4S/Q9pAU0ZUG
	 TszUUWLTBgwZ+UYDQ49BzS2QXl1dIurBNeQ8v0uFwtTT4FavE6fs1DgjrYToaSnwQq
	 xCiHlgFyaIIRAe+a8MZj/ft4fxQ6OCCuQYFJq3Z4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Gal Pressman <gal@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 056/159] net/mlx5e: IPoIB, Dont allow CQE compression to be turned on by default
Date: Tue, 10 Jan 2023 19:03:24 +0100
Message-Id: <20230110180020.091877265@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dragos Tatulea <dtatulea@nvidia.com>

[ Upstream commit b12d581e83e3ae1080c32ab83f123005bd89a840 ]

mlx5e_build_nic_params will turn CQE compression on if the hardware
capability is enabled and the slow_pci_heuristic condition is detected.
As IPoIB doesn't support CQE compression, make sure to disable the
feature in the IPoIB profile init.

Please note that the feature is not exposed to the user for IPoIB
interfaces, so it can't be subsequently turned on.

Fixes: b797a684b0dd ("net/mlx5e: Enable CQE compression when PCI is slower than link")
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 4e3a75496dd9..84f5352b0ce1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -71,6 +71,10 @@ static void mlx5i_build_nic_params(struct mlx5_core_dev *mdev,
 	params->packet_merge.type = MLX5E_PACKET_MERGE_NONE;
 	params->hard_mtu = MLX5_IB_GRH_BYTES + MLX5_IPOIB_HARD_LEN;
 	params->tunneled_offload_en = false;
+
+	/* CQE compression is not supported for IPoIB */
+	params->rx_cqe_compress_def = false;
+	MLX5E_SET_PFLAG(params, MLX5E_PFLAG_RX_CQE_COMPRESS, params->rx_cqe_compress_def);
 }
 
 /* Called directly after IPoIB netdevice was created to initialize SW structs */
-- 
2.35.1



