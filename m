Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D529379C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:37:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42A80C433EF;
	Thu, 12 Jan 2023 14:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673534231;
	bh=+KFzYhx3y9QXewYsYB1HV2JuA6jhcYSfVKTMQv2OxUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xaVka+zzL9w4dUIXjetOO4Y5B0LvYHSaagSnWDpQbqRXvYFTg1sUWIFCX7eZbB6NY
	 DMmGzl9MsoVlVNEMHoW05hUGScL+RAu+OV8y2bqvqsQUxqUQmyeDpnYSrkM64+9nf7
	 xLhVvwnquR1L9qMF1l+xErvRzONgQt5J3Z41D8JY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adham Faris <afaris@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 740/783] net/mlx5e: Fix hw mtu initializing at XDP SQ allocation
Date: Thu, 12 Jan 2023 14:57:36 +0100
Message-Id: <20230112135558.662940612@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Adham Faris <afaris@nvidia.com>

[ Upstream commit 1e267ab88dc44c48f556218f7b7f14c76f7aa066 ]

Current xdp xmit functions logic (mlx5e_xmit_xdp_frame_mpwqe or
mlx5e_xmit_xdp_frame), validates xdp packet length by comparing it to
hw mtu (configured at xdp sq allocation) before xmiting it. This check
does not account for ethernet fcs length (calculated and filled by the
nic). Hence, when we try sending packets with length > (hw-mtu -
ethernet-fcs-size), the device port drops it and tx_errors_phy is
incremented. Desired behavior is to catch these packets and drop them
by the driver.

Fix this behavior in XDP SQ allocation function (mlx5e_alloc_xdpsq) by
subtracting ethernet FCS header size (4 Bytes) from current hw mtu
value, since ethernet FCS is calculated and written to ethernet frames
by the nic.

Fixes: d8bec2b29a82 ("net/mlx5e: Support bpf_xdp_adjust_head()")
Signed-off-by: Adham Faris <afaris@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index cfc3bfcb04a2..5673a4113253 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -992,7 +992,7 @@ static int mlx5e_alloc_xdpsq(struct mlx5e_channel *c,
 	sq->channel   = c;
 	sq->uar_map   = mdev->mlx5e_res.bfreg.map;
 	sq->min_inline_mode = params->tx_min_inline_mode;
-	sq->hw_mtu    = MLX5E_SW2HW_MTU(params, params->sw_mtu);
+	sq->hw_mtu    = MLX5E_SW2HW_MTU(params, params->sw_mtu) - ETH_FCS_LEN;
 	sq->xsk_pool  = xsk_pool;
 
 	sq->stats = sq->xsk_pool ?
-- 
2.35.1



