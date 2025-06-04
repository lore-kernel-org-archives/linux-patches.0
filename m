Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 065881E871;
	Wed,  4 Jun 2025 01:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748998932; cv=none; b=Rnhi9emP5X0y+ediCiOPbveDjxXdc/VfXSyU/o4Cu89m/sgiIH4IlaZmtjmP3JRGktxXo8KY+EehE1DFRQSXYwCwNuNw4rcwNWKTKYXOGDOepXIxfBnFsUAHHUCS3KLZ7Cj/F+nDQBtxWw3ydlzot3UeBxr6VSvT+Yj58JI1l3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748998932; c=relaxed/simple;
	bh=UOAXries/JoIyZqaHN3Z59+NpgpEtT2/dBTdWsnQ0jk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XdLg7FBOAbrncqNtc+BD8CSaw5izGVggQpgQCKHCOlm0TT8oWlgpEeXGZpG1uWrINWMQFb8nzJzMyyCi4Dwk9GLLi0kjLussIUREqiAMNdSpPXMjx7ov8BhT++p9sL7QCxNaDrSlm6FSS5t0uSEZG8kkQ0lf9AdNKrch6nfR0bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hsufjVMY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hsufjVMY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21945C4CEEF;
	Wed,  4 Jun 2025 01:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748998931;
	bh=UOAXries/JoIyZqaHN3Z59+NpgpEtT2/dBTdWsnQ0jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hsufjVMYrhHzTrBqCBcMIvcwg0d4Ko3zpl7WbOmpXut1eE+JlmzTK6gJK3Trz1eqt
	 EaQI/ZCQsCn/++0bPSQP1rWLZKyETTTL5/+Py7vdTpVM+skKbYh3tLmWKga/YKO+IY
	 /XNPbOpHzavcGdlxKEtRX3Vm8KqY+ArjnpgQDjhtzyiiMMq71PnwoYxFfDBOLFEGR+
	 U2kL/HBl+M97AHnkEU8qCOY9ng9pRylFcTNsG60RL7ZEat7bAd7teyh6eBCQQXuBJ/
	 XnGGMmMQx4yeb1w2kDFNSivzLUkJYFUR3vWhlEYozp3xdPU1qDFZCY37Ez2ceI1cRA
	 WwtO2hfKjxDHw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Vlad Dogaru <vdogaru@nvidia.com>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	saeedm@nvidia.com,
	tariqt@nvidia.com,
	hamdani@nvidia.com,
	pabeni@redhat.com
Subject: [PATCH AUTOSEL 6.12 93/93] net/mlx5: HWS, Harden IP version definer checks
Date: Tue,  3 Jun 2025 20:59:19 -0400
Message-Id: <20250604005919.4191884-93-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604005919.4191884-1-sashal@kernel.org>
References: <20250604005919.4191884-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.31
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

 .../mlx5/core/steering/hws/mlx5hws_definer.c  | 44 ++++++++++++++++++-
 1 file changed, 42 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_definer.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_definer.c
index 5cabde7098b68..678e2539cf312 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_definer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_definer.c
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

