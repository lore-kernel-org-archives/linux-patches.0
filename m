Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0700F4FA;
	Wed,  4 Jun 2025 00:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748998756; cv=none; b=bruFq1L142UzZkSsnsLK5R6Ry3Lrund6W7GnG1O1280d0JJL/h4UFeFKh7be7JTZZja8XdlmjPT/OVA1gUjYSgaQK2x0ZPt4tbXBQ9NamPQE9nNJJ/AkW1QaSApVrYYyo2RfEC+lWJ8W4bF2qrHUUkyAc1AfghBOH1Xxw0K49Vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748998756; c=relaxed/simple;
	bh=yCMIwBYvHgP3Nekvjm2i40Kwm2SjcqX56kj/K9+4e4c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=snVFKWN2vadjMV9Mk8iGeHuvl4k+268Rxenfq6kFJFTvx2Zt+7rt6JesU08OqcY9XY9tpEoc9yUESj4niA1OZB1aaPa6Bt0AooKIxFlVbJPbd/YLnwSbcARfPY7Ow/croYMV/Di6ANixqh046nwTo3mnHeWDQeD2RoZywF5kkz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aTHL8sxF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aTHL8sxF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D009C4CEED;
	Wed,  4 Jun 2025 00:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748998755;
	bh=yCMIwBYvHgP3Nekvjm2i40Kwm2SjcqX56kj/K9+4e4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aTHL8sxFpTfqP1n2pIRNnVL3azs6N37b8lrrgxWEpscwHoZ0IHZyNzrWYVzdINeyu
	 AdCzKZB0y3T8GNZeL85TAjDfQ8otbXefO/9AQtss3Mjx+E4XC824yEh8KiBKDGKLsb
	 MjvdLo1GNmOKSOxa4kR7mjSy+pUhjaM3/zHV3I/RBhI3BWQunbU0VHKhFZBwWoGwdC
	 v6gCQ87dGa6W4ll4VYOnJd/Z5o2L2dWa0FTCzoLVvsR1Kx+v69py0LFf4BTcxGWoKH
	 /JbEPGFFKfZc2DpjevDzru9H4hP6Tj8khDewvI1nRcbWlUR9VfyYHIB7Ds5zCX8yPn
	 bSwpvDBP9PRKg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Vlad Dogaru <vdogaru@nvidia.com>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	tariqt@nvidia.com
Subject: [PATCH AUTOSEL 6.14 108/108] net/mlx5: HWS, Harden IP version definer checks
Date: Tue,  3 Jun 2025 20:55:31 -0400
Message-Id: <20250604005531.4178547-108-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604005531.4178547-1-sashal@kernel.org>
References: <20250604005531.4178547-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.9
Content-Transfer-Encoding: 8bit

From: Vlad Dogaru <vdogaru@nvidia.com>

[ Upstream commit 6991a975e416154576b0f5f06256aec13e23b0a7 ]

Replicate some sanity checks that firmware does, since hardware steering
does not go through firmware.

When creating a definer, disallow matching on IP addresses without also
matching on IP version. The latter can be satisfied by matching either
on the version field in the IP header, or on the ethertype field.

Also refuse to match IPv4 IHL alongside IPv6.

Signed-off-by: Vlad Dogaru <vdogaru@nvidia.com>
Reviewed-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Link: https://patch.msgid.link/20250422092540.182091-3-mbloch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES** This commit should be backported to stable kernel trees based on
the following analysis: ## Nature of the Change This is a
**hardening/validation fix** that adds critical input validation to
prevent invalid hardware configurations. The code changes add two
essential checks: 1. **IP Address Version Validation**: Ensures that
when matching on IP addresses, either IP version or ethertype is also
specified 2. **Protocol Consistency Check**: Prevents matching IPv6
addresses alongside IPv4-specific fields like IHL (Internet Header
Length) ## Code Analysis The changes are purely additive validation
logic in `hws_definer_conv_outer()` and `hws_definer_conv_inner()`: ```c
// Prevents matching IP addresses without version specification if
(ip_addr_set && !ip_ver_set) { mlx5hws_err(cd->ctx, "Unsupported match
on IP address without version or ethertype\n"); return -EINVAL; } //
Prevents IPv6/IPv4 field conflicts if (is_ipv6 &&
HWS_IS_FLD_SET(match_param, outer_headers.ipv4_ihl)) {
mlx5hws_err(cd->ctx, "Unsupported match on IPv6 address and IPv4
IHL\n"); return -EINVAL; } ``` ## Critical Context As stated in the
commit message, this "replicates sanity checks that firmware does, since
hardware steering does not go through firmware." This is essential
because: - Hardware Steering (HWS) bypasses normal firmware validation
paths - Without these checks, invalid configurations could reach the
hardware - Invalid configurations could cause hardware errors or
undefined behavior ## Similarity to Established Patterns This follows
the same pattern as **Similar Commit #4** (marked YES for backporting),
which added similar validation for IP matching requirements in software
steering with the message "Don't allow match on IP w/o matching on full
ethertype/ip_version." ## Backporting Justification 1. **Low Risk**:
Only adds validation, doesn't change functional behavior 2. **High
Value**: Prevents potential hardware errors and system instability 3.
**Defensive Programming**: Early error detection with clear diagnostic
messages 4. **No Dependencies**: Uses existing error reporting
infrastructure 5. **Protocol Compliance**: Ensures proper IP protocol
field usage This type of input validation and hardware protection logic
is exactly what stable kernel trees need to maintain system reliability
and prevent configuration errors that could cause more serious issues.

 .../mellanox/mlx5/core/steering/hws/definer.c | 44 ++++++++++++++++++-
 1 file changed, 42 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/definer.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/definer.c
index bc2aa0b0fa865..961d1ea73a127 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/definer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/definer.c
@@ -508,9 +508,9 @@ static int
 hws_definer_conv_outer(struct mlx5hws_definer_conv_data *cd,
 		       u32 *match_param)
 {
+	bool is_ipv6, smac_set, dmac_set, ip_addr_set, ip_ver_set;
 	struct mlx5hws_definer_fc *fc = cd->fc;
 	struct mlx5hws_definer_fc *curr_fc;
-	bool is_ipv6, smac_set, dmac_set;
 	u32 *s_ipv6, *d_ipv6;
 
 	if (HWS_IS_FLD_SET_SZ(match_param, outer_headers.l4_type, 0x2) ||
@@ -520,6 +520,20 @@ hws_definer_conv_outer(struct mlx5hws_definer_conv_data *cd,
 		return -EINVAL;
 	}
 
+	ip_addr_set = HWS_IS_FLD_SET_SZ(match_param,
+					outer_headers.src_ipv4_src_ipv6,
+					0x80) ||
+		      HWS_IS_FLD_SET_SZ(match_param,
+					outer_headers.dst_ipv4_dst_ipv6, 0x80);
+	ip_ver_set = HWS_IS_FLD_SET(match_param, outer_headers.ip_version) ||
+		     HWS_IS_FLD_SET(match_param, outer_headers.ethertype);
+
+	if (ip_addr_set && !ip_ver_set) {
+		mlx5hws_err(cd->ctx,
+			    "Unsupported match on IP address without version or ethertype\n");
+		return -EINVAL;
+	}
+
 	/* L2 Check ethertype */
 	HWS_SET_HDR(fc, match_param, ETH_TYPE_O,
 		    outer_headers.ethertype,
@@ -572,6 +586,12 @@ hws_definer_conv_outer(struct mlx5hws_definer_conv_data *cd,
 	is_ipv6 = s_ipv6[0] || s_ipv6[1] || s_ipv6[2] ||
 		  d_ipv6[0] || d_ipv6[1] || d_ipv6[2];
 
+	/* IHL is an IPv4-specific field. */
+	if (is_ipv6 && HWS_IS_FLD_SET(match_param, outer_headers.ipv4_ihl)) {
+		mlx5hws_err(cd->ctx, "Unsupported match on IPv6 address and IPv4 IHL\n");
+		return -EINVAL;
+	}
+
 	if (is_ipv6) {
 		/* Handle IPv6 source address */
 		HWS_SET_HDR(fc, match_param, IPV6_SRC_127_96_O,
@@ -661,9 +681,9 @@ static int
 hws_definer_conv_inner(struct mlx5hws_definer_conv_data *cd,
 		       u32 *match_param)
 {
+	bool is_ipv6, smac_set, dmac_set, ip_addr_set, ip_ver_set;
 	struct mlx5hws_definer_fc *fc = cd->fc;
 	struct mlx5hws_definer_fc *curr_fc;
-	bool is_ipv6, smac_set, dmac_set;
 	u32 *s_ipv6, *d_ipv6;
 
 	if (HWS_IS_FLD_SET_SZ(match_param, inner_headers.l4_type, 0x2) ||
@@ -673,6 +693,20 @@ hws_definer_conv_inner(struct mlx5hws_definer_conv_data *cd,
 		return -EINVAL;
 	}
 
+	ip_addr_set = HWS_IS_FLD_SET_SZ(match_param,
+					inner_headers.src_ipv4_src_ipv6,
+					0x80) ||
+		      HWS_IS_FLD_SET_SZ(match_param,
+					inner_headers.dst_ipv4_dst_ipv6, 0x80);
+	ip_ver_set = HWS_IS_FLD_SET(match_param, inner_headers.ip_version) ||
+		     HWS_IS_FLD_SET(match_param, inner_headers.ethertype);
+
+	if (ip_addr_set && !ip_ver_set) {
+		mlx5hws_err(cd->ctx,
+			    "Unsupported match on IP address without version or ethertype\n");
+		return -EINVAL;
+	}
+
 	/* L2 Check ethertype */
 	HWS_SET_HDR(fc, match_param, ETH_TYPE_I,
 		    inner_headers.ethertype,
@@ -727,6 +761,12 @@ hws_definer_conv_inner(struct mlx5hws_definer_conv_data *cd,
 	is_ipv6 = s_ipv6[0] || s_ipv6[1] || s_ipv6[2] ||
 		  d_ipv6[0] || d_ipv6[1] || d_ipv6[2];
 
+	/* IHL is an IPv4-specific field. */
+	if (is_ipv6 && HWS_IS_FLD_SET(match_param, inner_headers.ipv4_ihl)) {
+		mlx5hws_err(cd->ctx, "Unsupported match on IPv6 address and IPv4 IHL\n");
+		return -EINVAL;
+	}
+
 	if (is_ipv6) {
 		/* Handle IPv6 source address */
 		HWS_SET_HDR(fc, match_param, IPV6_SRC_127_96_I,
-- 
2.39.5

