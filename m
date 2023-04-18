Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F620257D
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:50:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C94E6C4339B;
	Tue, 18 Apr 2023 12:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681822238;
	bh=k/HB4zxvp8gyenny9Zjs2yixtVMg9eZfyBxRQrGyrk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vdT5rgZ0dXBmIJ+CTpnpxjrySeIX16IfBiummWMKGFhFof/sjzAm6W/vGhaLcuHyZ
	 qI1VB6/ei3aJADBMVq/A8+i+LH6slBBi/NqYiyNUC5gKFswZE7NyzLSnssP8LxVxLM
	 +Ou9esMY7hs7w8hemFsfTyAJdfTB3kqfMzZEcEDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maher Sanalla <msanalla@nvidia.com>,
	Aya Levin <ayal@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 035/139] IB/mlx5: Add support for 400G_8X lane speed
Date: Tue, 18 Apr 2023 14:21:40 +0200
Message-Id: <20230418120314.974703458@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maher Sanalla <msanalla@nvidia.com>

[ Upstream commit 88c9483faf15ada14eca82714114656893063458 ]

Currently, when driver queries PTYS to report which link speed is being
used on its RoCE ports, it does not check the case of having 400Gbps
transmitted over 8 lanes. Thus it fails to report the said speed and
instead it defaults to report 10G over 4 lanes.

Add a check for the said speed when querying PTYS and report it back
correctly when needed.

Fixes: 08e8676f1607 ("IB/mlx5: Add support for 50Gbps per lane link modes")
Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
Reviewed-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Link: https://lore.kernel.org/r/ec9040548d119d22557d6a4b4070d6f421701fd4.1678973994.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index c669ef6e47e73..eaa35e1df2a85 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -442,6 +442,10 @@ static int translate_eth_ext_proto_oper(u32 eth_proto_oper, u16 *active_speed,
 		*active_width = IB_WIDTH_2X;
 		*active_speed = IB_SPEED_NDR;
 		break;
+	case MLX5E_PROT_MASK(MLX5E_400GAUI_8):
+		*active_width = IB_WIDTH_8X;
+		*active_speed = IB_SPEED_HDR;
+		break;
 	case MLX5E_PROT_MASK(MLX5E_400GAUI_4_400GBASE_CR4_KR4):
 		*active_width = IB_WIDTH_4X;
 		*active_speed = IB_SPEED_NDR;
-- 
2.39.2



