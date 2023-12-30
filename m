Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4A78F42;
	Sat, 30 Dec 2023 12:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xNmfH3il"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23E52C433C7;
	Sat, 30 Dec 2023 12:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937715;
	bh=yprDKe91uyBWNn7T1+GBNU52WfWc1bR4EgxDoPAZEgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xNmfH3iltAkqN0atC5HJxwdT+10H9YSQqtMlopZjB5HI/B0JkcosIBMVozQAzZKSp
	 u6CaAOCNf+xM4pyGT+8ocsmVbfNbouN4G9DwrNrpzN7zj+hzGcEelVih+11KTV35GL
	 7ZwmoP6XeKP7oGfEOCasPzNmxVBr/+brq5PL1TbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianbo Liu <jianbol@nvidia.com>,
	Roi Dayan <roid@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 035/156] net/mlx5e: Fix overrun reported by coverity
Date: Sat, 30 Dec 2023 11:58:09 +0000
Message-ID: <20231230115813.527421802@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
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

From: Jianbo Liu <jianbol@nvidia.com>

[ Upstream commit da75fa542873e5f7d7f615566c0b00042d8a0437 ]

Coverity Scan reports the following issue. But it's impossible that
mlx5_get_dev_index returns 7 for PF, even if the index is calculated
from PCI FUNC ID. So add the checking to make coverity slience.

CID 610894 (#2 of 2): Out-of-bounds write (OVERRUN)
Overrunning array esw->fdb_table.offloads.peer_miss_rules of 4 8-byte
elements at element index 7 (byte offset 63) using index
mlx5_get_dev_index(peer_dev) (which evaluates to 7).

Fixes: 9bee385a6e39 ("net/mlx5: E-switch, refactor FDB miss rule add/remove")
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c   | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index bb8bcb448ae90..9bd5609cf6597 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1177,9 +1177,9 @@ static int esw_add_fdb_peer_miss_rules(struct mlx5_eswitch *esw,
 	struct mlx5_flow_handle *flow;
 	struct mlx5_flow_spec *spec;
 	struct mlx5_vport *vport;
+	int err, pfindex;
 	unsigned long i;
 	void *misc;
-	int err;
 
 	if (!MLX5_VPORT_MANAGER(esw->dev) && !mlx5_core_is_ecpf_esw_manager(esw->dev))
 		return 0;
@@ -1255,7 +1255,15 @@ static int esw_add_fdb_peer_miss_rules(struct mlx5_eswitch *esw,
 			flows[vport->index] = flow;
 		}
 	}
-	esw->fdb_table.offloads.peer_miss_rules[mlx5_get_dev_index(peer_dev)] = flows;
+
+	pfindex = mlx5_get_dev_index(peer_dev);
+	if (pfindex >= MLX5_MAX_PORTS) {
+		esw_warn(esw->dev, "Peer dev index(%d) is over the max num defined(%d)\n",
+			 pfindex, MLX5_MAX_PORTS);
+		err = -EINVAL;
+		goto add_ec_vf_flow_err;
+	}
+	esw->fdb_table.offloads.peer_miss_rules[pfindex] = flows;
 
 	kvfree(spec);
 	return 0;
-- 
2.43.0



