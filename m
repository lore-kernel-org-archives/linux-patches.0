Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA184A59;
	Wed, 30 Sep 2026 18:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791467; cv=none; b=HN7PlXDDiGocwpGfprt7+1F84hBeROqTLsO/AcOnxZ8wBTVe6jllKf02lVkmAli7LYSpwUQwLNW1kHPbZeYZAE1k3eo8b7nK7IyDdGFxpQ4xPdoEWFjYD86BNH95tFrDWZ+/Cw6JWuJtngUe2NZGkhrWo7XpTO50IchAC3zo7NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791467; c=relaxed/simple;
	bh=FU/sGDG5V7LPClUkNFSywPgA8GOXGKOHhJnrVVkd7FE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hqmP2CsIEJAARAlY318iFdByvMoc7JI6FZqhwda/WRdMVVLGhPus89l+sZ4oChkuJoq/MvdfYlcFUI7QUZWqb+Oa9X7Nf2ruE5hqCsj6MszvESa7dEqUzNifgCRZhVE1g75ivv2NFymZNWHPC9FVLWAf0BVSXtDJY1bogy51JHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DyBmehpX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DyBmehpX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5823A1F000FF;
	Wed, 30 Sep 2026 18:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791465;
	bh=/Zz93LufkyFLAO9z9WB/l3UVOjFOtvoregFJMHCZQdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DyBmehpXkymoGgrRCxpwhZ/JVhd9+/Y11f7rgt/kv8nC+AMA259JHBOvyPtp8qptn
	 ohbWvaq2nCHNUYdsJn3Ki/inLfNcPb7R/N1ivBHHYhf3MvZ0ZJmCne4VYXRvVh0bRN
	 3XFIJWDFrLppAT4uqmJD1OPmNOXckNHQo1itua2Q=
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
Subject: [PATCH 5.15 310/752] net/mlx5e: Fix setting RS FEC after remapping
Date: Wed, 30 Sep 2026 17:23:00 +0200
Message-ID: <20260930152405.004255260@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 89510cac46c22..0ac51c6d1900a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
@@ -542,6 +542,7 @@ int mlx5e_set_fec_mode(struct mlx5_core_dev *dev, u16 fec_policy)
 	u32 in[MLX5_ST_SZ_DW(pplm_reg)] = {};
 	int sz = MLX5_ST_SZ_BYTES(pplm_reg);
 	u16 fec_policy_auto = 0;
+	bool fec_set = false;
 	int err;
 	int i;
 
@@ -554,9 +555,6 @@ int mlx5e_set_fec_mode(struct mlx5_core_dev *dev, u16 fec_policy)
 	if (fec_policy >= (1 << MLX5E_FEC_LLRS_272_257_1) && !fec_50g_per_lane)
 		return -EOPNOTSUPP;
 
-	if (fec_policy && !mlx5e_fec_in_caps(dev, fec_policy))
-		return -EOPNOTSUPP;
-
 	MLX5_SET(pplm_reg, in, local_port, 1);
 	err = mlx5_core_access_reg(dev, in, sz, out, sz, MLX5_REG_PPLM, 0, 0);
 	if (err)
@@ -583,12 +581,17 @@ int mlx5e_set_fec_mode(struct mlx5_core_dev *dev, u16 fec_policy)
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



