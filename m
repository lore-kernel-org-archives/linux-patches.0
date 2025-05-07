Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C9023DE;
	Wed,  7 May 2025 19:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644509; cv=none; b=iOcvISGyXK/UDCsWkf0Xy4kF6jLelT+vqoPLIZ6jBt1IfqH7gQZJwPFySzyo5/9BgsRBAA00+wMea4VHrbcSma+CQtXuwfPCkGGZ55OYVa7me4dfWZHzmibDZ7pEQei0m7GBOWIUD9Kqjo0j+k4mYnOzr6nr7Lg3DyI7ySr8dgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644509; c=relaxed/simple;
	bh=qNBvpJbc1HnhEcUBoOwTm81RWPJg+3t1hpTP+71NoL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KpLnBdXRFSUuqmX05lHwY0kananupYzg0LqnvD4SuH/TETedCTXAI7ipUIGQvQcLolGKZGdQRbtWBAX5Rd+RkwIBNa8Uo9eaerUQZIZREz5tjCxgqYHJA+jl7QHkrk3kKMLuMMJnOP8yMC6Ds9c9ccTHrzxSIX7wgH5QNMtnZj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=112fkH0Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="112fkH0Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D144C4CEE2;
	Wed,  7 May 2025 19:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644508;
	bh=qNBvpJbc1HnhEcUBoOwTm81RWPJg+3t1hpTP+71NoL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=112fkH0YGxX/Dk1EPIWNCQ2OiaECzOv8iKz5C0QNEiFGm4uFxiSlhsEK2DzE4Q7pl
	 GsklZJLUS4+d+RL/Om2VKIHpkjGzsFoPD9l5VLyzWl2X0ZETyvNqrRf+3L5rdobIOE
	 g/CttQPcisiIhSZmA5KpcwOBwneFrZBYVbtT7+Tc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlad Dogaru <vdogaru@nvidia.com>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 067/164] net/mlx5e: Use custom tunnel header for vxlan gbp
Date: Wed,  7 May 2025 20:39:12 +0200
Message-ID: <20250507183823.663841991@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Dogaru <vdogaru@nvidia.com>

[ Upstream commit eacc77a73275895eca0e3655dc6c671853500e2e ]

Symbolic (e.g. "vxlan") and custom (e.g. "tunnel_header_0") tunnels
cannot be combined, but the match params interface does not have fields
for matching on vxlan gbp. To match vxlan bgp, the tc_tun layer uses
tunnel_header_0.

Allow matching on both VNI and GBP by matching the VNI with a custom
tunnel header instead of the symbolic field name.

Matching solely on the VNI continues to use the symbolic field name.

Fixes: 74a778b4a63f ("net/mlx5: HWS, added definers handling")
Signed-off-by: Vlad Dogaru <vdogaru@nvidia.com>
Reviewed-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Link: https://patch.msgid.link/20250423083611.324567-2-mbloch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/en/tc_tun_vxlan.c      | 32 +++++++++++++++++--
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
index e4e487c8431b8..b9cf79e271244 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
@@ -165,9 +165,6 @@ static int mlx5e_tc_tun_parse_vxlan(struct mlx5e_priv *priv,
 	struct flow_match_enc_keyid enc_keyid;
 	void *misc_c, *misc_v;
 
-	misc_c = MLX5_ADDR_OF(fte_match_param, spec->match_criteria, misc_parameters);
-	misc_v = MLX5_ADDR_OF(fte_match_param, spec->match_value, misc_parameters);
-
 	if (!flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_KEYID))
 		return 0;
 
@@ -182,6 +179,30 @@ static int mlx5e_tc_tun_parse_vxlan(struct mlx5e_priv *priv,
 		err = mlx5e_tc_tun_parse_vxlan_gbp_option(priv, spec, f);
 		if (err)
 			return err;
+
+		/* We can't mix custom tunnel headers with symbolic ones and we
+		 * don't have a symbolic field name for GBP, so we use custom
+		 * tunnel headers in this case. We need hardware support to
+		 * match on custom tunnel headers, but we already know it's
+		 * supported because the previous call successfully checked for
+		 * that.
+		 */
+		misc_c = MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
+				      misc_parameters_5);
+		misc_v = MLX5_ADDR_OF(fte_match_param, spec->match_value,
+				      misc_parameters_5);
+
+		/* Shift by 8 to account for the reserved bits in the vxlan
+		 * header after the VNI.
+		 */
+		MLX5_SET(fte_match_set_misc5, misc_c, tunnel_header_1,
+			 be32_to_cpu(enc_keyid.mask->keyid) << 8);
+		MLX5_SET(fte_match_set_misc5, misc_v, tunnel_header_1,
+			 be32_to_cpu(enc_keyid.key->keyid) << 8);
+
+		spec->match_criteria_enable |= MLX5_MATCH_MISC_PARAMETERS_5;
+
+		return 0;
 	}
 
 	/* match on VNI is required */
@@ -195,6 +216,11 @@ static int mlx5e_tc_tun_parse_vxlan(struct mlx5e_priv *priv,
 		return -EOPNOTSUPP;
 	}
 
+	misc_c = MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
+			      misc_parameters);
+	misc_v = MLX5_ADDR_OF(fte_match_param, spec->match_value,
+			      misc_parameters);
+
 	MLX5_SET(fte_match_set_misc, misc_c, vxlan_vni,
 		 be32_to_cpu(enc_keyid.mask->keyid));
 	MLX5_SET(fte_match_set_misc, misc_v, vxlan_vni,
-- 
2.39.5



