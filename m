Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620294F85B0;
	Thu, 17 Sep 2026 17:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665769; cv=none; b=SD9HftUv90Z6LSWMufjlnix0zSD+Dlj+XWqXZGn9bo+TMyL9q4VSoIML0SlEbzOREXUJ+NsBQd67pUZMcI9WOk4/cv3poCa6yjtfdWIRm9NomezcBGyAvwd6bPMf1MUys+EcstN73pOeH4iuUSTG2z0zuE3B64A33TU96abAeIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665769; c=relaxed/simple;
	bh=Z6BLWKIl0Xv15+PNEkf/TJmXXOKTs/F2RiAmdD07/IM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gzv256wK+WL0jublO15T2Aujet4M8WwxGVmp9WcpgQFONPOezuqspMuTI9mbv05u5/ZZIPYgQPt1PvyrDsJjDeh7zMWTHXXk7xifTVAyOC8zBjzWmYWP3j/HTo5NNM4LFKq+1JQSi51DGzsmn9III44St2Q9w6up+ueaDelIq4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dxo7iqTX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dxo7iqTX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1E831F000FF;
	Thu, 17 Sep 2026 17:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665768;
	bh=AVs4zLnqhq9XnW2imzLOkCTSnYQabpVXylDwd7ZQi6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dxo7iqTXnc0y+wivqMnAbMzcapQ+H5ePFddC21TnGnTX5svZdkMYjOH+ErCkEV4IU
	 bv4wD4DIpsHxPYMkEiCdmC1tMU+QksVjLvfBqz7CZnYrjWJzJqZ/e4WjuZXLmo+l93
	 FlC20l09vYP67PzPxFWB8SrbqwXvVheDNJAwKWfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shahar Shitrit <shshitrit@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Yael Chemla <ychemla@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0812/1250] net/mlx5e: Fix setting RS FEC after remapping
Date: Thu, 17 Sep 2026 16:10:07 +0100
Message-ID: <20260917151613.929219201@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Shahar Shitrit <shshitrit@nvidia.com>

[ Upstream commit b9d755c5a37519fb1354034db1dfeb30e1ba6856 ]

When a user sets a FEC mode via ethtool, the driver maps the ethtool
FEC type to the lowest mlx5 bit of that type. For RS FEC, this is
MLX5E_FEC_RS_528_514 (bit 2). The driver then checks whether this
bit is supported by at least one link mode by inspecting the
fec_override_cap fields via mlx5e_fec_in_caps(), and returns
-EOPNOTSUPP if not.

This check is incorrect. RS FEC has three supported hardware variants:
RS_528_514 (bit 2), RS_544_514_INTERLEAVED_QUAD (bit 4), and
RS_544_514 (bit 7). mlx5e_remap_fec_conf_mode() already remaps bit 2
to the appropriate RS variant per link mode when writing the admin
fields, but the early capability check is done against the raw
unmapped bit. As a result, a device that supports RS_544_514 or
RS_544_514_INTERLEAVED_QUAD but not RS_528_514 will incorrectly reject
the user's RS FEC request.

Remove the early support check from mlx5e_set_fec_mode() and fold
it into the existing write loop, checking caps against the remapped
policy per link mode. Return -EOPNOTSUPP before the final register
write if no link mode accepted the policy.

Fixes: 2608a2f831c4 ("net/mlx5e: Fix return status when setting unsupported FEC mode")
Signed-off-by: Shahar Shitrit <shshitrit@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Yael Chemla <ychemla@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260902164634.3657606-3-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/port.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port.c b/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
index 6049ccf475bc4..a4c096a4fed25 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
@@ -557,6 +557,7 @@ int mlx5e_set_fec_mode(struct mlx5_core_dev *dev, u16 fec_policy)
 	u32 in[MLX5_ST_SZ_DW(pplm_reg)] = {};
 	int sz = MLX5_ST_SZ_BYTES(pplm_reg);
 	u16 fec_policy_auto = 0;
+	bool fec_set = false;
 	int err;
 	int i;
 
@@ -569,9 +570,6 @@ int mlx5e_set_fec_mode(struct mlx5_core_dev *dev, u16 fec_policy)
 	if (fec_policy >= (1 << MLX5E_FEC_LLRS_272_257_1) && !fec_50g_per_lane)
 		return -EOPNOTSUPP;
 
-	if (fec_policy && !mlx5e_fec_in_caps(dev, fec_policy))
-		return -EOPNOTSUPP;
-
 	MLX5_SET(pplm_reg, in, local_port, 1);
 	err = mlx5_core_access_reg(dev, in, sz, out, sz, MLX5_REG_PPLM, 0, 0);
 	if (err)
@@ -591,12 +589,17 @@ int mlx5e_set_fec_mode(struct mlx5_core_dev *dev, u16 fec_policy)
 		mlx5e_get_fec_cap_field(out, &fec_caps, i);
 
 		/* policy supported for link speed */
-		if (fec_caps & conf_fec)
+		if (fec_caps & conf_fec) {
 			mlx5e_fec_admin_field(out, &conf_fec, 1, i);
-		else
-			/* set FEC to auto*/
+			fec_set = true;
+		} else {
+			/* set FEC to auto */
 			mlx5e_fec_admin_field(out, &fec_policy_auto, 1, i);
+		}
 	}
 
+	if (fec_policy && !fec_set)
+		return -EOPNOTSUPP;
+
 	return mlx5_core_access_reg(dev, out, sz, out, sz, MLX5_REG_PPLM, 0, 1);
 }
-- 
2.53.0



