Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F26D1FF5EC;
	Wed,  7 May 2025 18:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643947; cv=none; b=EbuhOvvCejCS3+AQVnzORTqJs42rB0H6R9BBVzqHaLlCccBxJa+FxJP5vp7OwKqcxCW2ZfzMNEGLzBlezJgO1MVeLumtUsU8q3sQKe6zXEsQ4Ov6LenJ/B6+VheN9o405iMDG2ZWFgqMJVwB9O8E/+ZvHv4D3pleNHwzrn/atJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643947; c=relaxed/simple;
	bh=7CGlNSeE1S8cJILkb1r3+1raKdzO6eZMmHbHZnGIJ3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B82+55IXkh/N0aZsPq0IOlii7dzmywQD+Iao+g0K044G5ddqJrwTMXy9lrrhyuEtGVezsKoe3SlyJcpJtJIX2JfufMRaN5bAXnfOHJNN+MFXbuw/EtCgqRWhFbApfBL5dUpbR4IMIn++/AM22001+5A2WUzqGfzmM0yDajl/3vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qKzxhw8F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qKzxhw8F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 882A3C4CEE2;
	Wed,  7 May 2025 18:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643946;
	bh=7CGlNSeE1S8cJILkb1r3+1raKdzO6eZMmHbHZnGIJ3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qKzxhw8FIjlqE28Xm8PsK363yThFdmGN7gIQaqXvPJbGMrS9nc73KZihpwfzqjpHT
	 FEl+1OUFCA5VwbValo9Ie0oIRGbLyxrs1G4jbSWALMNiT8fjqhmXKkPieOKY+neCfc
	 6cIbEx8ABiqtHfqx/t21fT9gUl5W03kXk+GqSqTk=
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
Subject: [PATCH 6.14 069/183] net/mlx5e: Use custom tunnel header for vxlan gbp
Date: Wed,  7 May 2025 20:38:34 +0200
Message-ID: <20250507183827.484461838@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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



