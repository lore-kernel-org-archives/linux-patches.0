Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B7381AB1;
	Wed,  7 Aug 2024 15:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043151; cv=none; b=d5e2Rrvmj6Y4mNXwNUrLDR7ENy88oe15LCb7hvD64cCaH1mhGRvGW6mXScCN/rT8Xo3L6EGQD1GOh45iTD7gXsUufDIc4Pj9bxK8xsTDyjIDiuasBWoiLh2LJbeEI1DRjTCeGa4Qns/gIxoY2XodqbpyrCtXvT8L+y53BKQswoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043151; c=relaxed/simple;
	bh=Z0vOEVCmiVGsCWLiJWfs53H3ybiQeHZjNnVoD+GQh3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pYg5AkMcqxB623E0eHFYttjIZ/lnR61j0jir/iSY11wLs4AboK0w2b4ZAnctchbFn2HL6Cp7coch0Igf9NbqsPyeW5RftyswMAZKY9KLp2iSU2KctuCLwSg3dmj/lxYtFT5yay5Q48kvtSk7ipZDPvVxyjHXcpcWYrCmw9Pa61c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hyXbi9y7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hyXbi9y7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27E87C32781;
	Wed,  7 Aug 2024 15:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043151;
	bh=Z0vOEVCmiVGsCWLiJWfs53H3ybiQeHZjNnVoD+GQh3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hyXbi9y7doGPor4Y0edDMMoCPk3ewzIe/u74yl1UbmzooS9HE/evzsmNx1XTyRlU7
	 sAvqz5OLz1lsCImMf771JJFwWQtky8UroeYaDcSKT24/zpUO2//NlMTjKe8oueK/vT
	 PUoSCSTUVeDWmdYSVBkD+E9xJZhVduAIfQ8n7j7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 063/123] net/mlx5e: Require mlx5 tc classifier action support for IPsec prio capability
Date: Wed,  7 Aug 2024 16:59:42 +0200
Message-ID: <20240807150022.835765625@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rahul Rameshbabu <rrameshbabu@nvidia.com>

[ Upstream commit 06827e27fdcd197557be72b2229dbd362303794f ]

Require mlx5 classifier action support when creating IPSec chains in
offload path. MLX5_IPSEC_CAP_PRIO should only be set if CONFIG_MLX5_CLS_ACT
is enabled. If CONFIG_MLX5_CLS_ACT=n and MLX5_IPSEC_CAP_PRIO is set,
configuring IPsec offload will fail due to the mlxx5 ipsec chain rules
failing to be created due to lack of classifier action support.

Fixes: fa5aa2f89073 ("net/mlx5e: Use chains for IPsec policy priority offload")
Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Link: https://patch.msgid.link/20240730061638.1831002-7-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c   | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index 6e00afe4671b7..797db853de363 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -51,9 +51,10 @@ u32 mlx5_ipsec_device_caps(struct mlx5_core_dev *mdev)
 		    MLX5_CAP_FLOWTABLE_NIC_RX(mdev, decap))
 			caps |= MLX5_IPSEC_CAP_PACKET_OFFLOAD;
 
-		if ((MLX5_CAP_FLOWTABLE_NIC_TX(mdev, ignore_flow_level) &&
-		     MLX5_CAP_FLOWTABLE_NIC_RX(mdev, ignore_flow_level)) ||
-		    MLX5_CAP_ESW_FLOWTABLE_FDB(mdev, ignore_flow_level))
+		if (IS_ENABLED(CONFIG_MLX5_CLS_ACT) &&
+		    ((MLX5_CAP_FLOWTABLE_NIC_TX(mdev, ignore_flow_level) &&
+		      MLX5_CAP_FLOWTABLE_NIC_RX(mdev, ignore_flow_level)) ||
+		     MLX5_CAP_ESW_FLOWTABLE_FDB(mdev, ignore_flow_level)))
 			caps |= MLX5_IPSEC_CAP_PRIO;
 
 		if (MLX5_CAP_FLOWTABLE_NIC_TX(mdev,
-- 
2.43.0



