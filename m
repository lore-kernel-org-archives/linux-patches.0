Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65C642065;
	Wed,  4 Jun 2025 00:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748998683; cv=none; b=F8hKg1b9Eqe7dyZwylG0SzU2bArMyEBeHRKMlMUhE2qAC5IYV85afyPV4f/u/JifbMqeG6eH8Vtiz9jJzWy3C65N+fXJckmyMK3qsMnDyroUy1LZ5I9WpLfx9MFhGk2sNNH7yc57LdmX7qpHkjSeMUWr+WG75Zxj6iMTNpUGE/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748998683; c=relaxed/simple;
	bh=GB/aP0q0r7SbOGwK2a1BFkG75fJVmBfPWZGOC2O0e5c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hIUC7AswkvyiW8JKBdp/zRkUwe3kvrOoyJS/0LrLDhqrFOzZWNJL9bo+l6yNYP2o7aiRCPtzueU3WC6fi9VChm+JNlQ8+4Wi7CCkZvIiTGur6soFMcrpCme9gQJlBg2/qqeoU4RBJd1ZcIfMfVhKhL7G2f52iZwNJwC5JzLbbjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XdNH/hUm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XdNH/hUm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEA16C4CEED;
	Wed,  4 Jun 2025 00:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748998683;
	bh=GB/aP0q0r7SbOGwK2a1BFkG75fJVmBfPWZGOC2O0e5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XdNH/hUm6jN/FNlUiGCenwC0aDjS1Pmd6dpOUpC3xkzqmB8NDevjeIjXVvf78Wy1w
	 K+KGEREv9rPVPjyrsPQqvPok8ARFWeyoVMilQnlh3/9g2n3K5cJPSo3hDUsMM6oTzt
	 +veLnwPnX/SEQNJxVfaVVTze6M0k5ENNFyhclemJ4+sSLiMmAe5dSTrRw1qhpnlpq7
	 P751o6D/xlVX5pjbJaJtCzQJG2Pz6E7+m+lLAoNCto7UAoATc3J/A7Go8Y2E4x7cw+
	 vEtLOtd6AfbMbUVqaE1urlvHQXU9XGDkyvhA4y2Xwfts3q3pmrL3CEjttY5ca9WSnC
	 EVf+p3Uz2StYg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Vlad Dogaru <vdogaru@nvidia.com>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	tariqt@nvidia.com
Subject: [PATCH AUTOSEL 6.14 072/108] net/mlx5: HWS, Fix IP version decision
Date: Tue,  3 Jun 2025 20:54:55 -0400
Message-Id: <20250604005531.4178547-72-sashal@kernel.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vlad Dogaru <vdogaru@nvidia.com>

[ Upstream commit 5f2f8d8b6800e4fc760c2eccec9b2bd2cacf80cf ]

Unify the check for IP version when creating a definer. A given matcher
is deemed to match on IPv6 if any of the higher order (>31) bits of
source or destination address mask are set.

A single packet cannot mix IP versions between source and destination
addresses, so it makes no sense that they would be decided on
independently.

Signed-off-by: Vlad Dogaru <vdogaru@nvidia.com>
Reviewed-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Link: https://patch.msgid.link/20250422092540.182091-2-mbloch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES** This commit should be backported to stable kernel trees. Here's
my detailed analysis: ## Bug Analysis This commit fixes a real logical
bug in the mlx5 HWS (Hardware Steering) definer subsystem. The issue is
in how IP version is determined when creating flow matchers. **The
Problem:** The old code made independent decisions about IPv6 vs IPv4
for source and destination addresses: ```c is_s_ipv6 = s_ipv6[0] ||
s_ipv6[1] || s_ipv6[2]; is_d_ipv6 = d_ipv6[0] || d_ipv6[1] || d_ipv6[2];
``` This could lead to inconsistent handling where source and
destination addresses might be treated as different IP versions, which
is logically impossible for a single packet. **The Fix:** The new code
correctly unifies the decision: ```c is_ipv6 = s_ipv6[0] || s_ipv6[1] ||
s_ipv6[2] || d_ipv6[0] || d_ipv6[1] || d_ipv6[2]; ``` ## Impact
Assessment **User Impact:** This bug could cause serious networking
issues: 1. **Incorrect packet classification** - packets might not match
intended flow rules 2. **Hardware steering failures** - wrong definer
configuration could cause packets to fall back to software path 3.
**Performance degradation** - incorrect hardware offload behavior 4.
**Connection failures** - in environments with IPv6 traffic **Risk
Assessment:** This is a low-risk fix: - **Scope**: Limited to two
functions (`hws_definer_conv_outer` and `hws_definer_conv_inner`) -
**Logic**: Simple variable consolidation with more correct networking
logic - **Size**: Small, contained change affecting only the IP version
decision logic ## Comparison to Similar Commits Unlike the provided
similar commits that were marked "Backport Status: NO" (which were
primarily new features like "added definers handling", "log unsupported
mask", etc.), this commit: - **Fixes core functionality** rather than
adding new features - **Addresses a logical incorrectness** that can
impact real users - **Has minimal regression risk** while fixing a clear
bug ## Conclusion This commit meets all criteria for stable backporting:
✅ Fixes a user-impacting bug ✅ Small, contained change ✅ Minimal
regression risk ✅ Affects core networking functionality ✅ Clear benefit-
to-risk ratio The fix aligns the code with fundamental networking
principles (a packet cannot have mixed IP versions) and resolves
potential hardware steering issues that could impact production
environments using mlx5 networking hardware.

 .../mellanox/mlx5/core/steering/hws/definer.c | 38 ++++++++-----------
 1 file changed, 16 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/definer.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/definer.c
index 10ece7df1cfaf..bc2aa0b0fa865 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/definer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/definer.c
@@ -508,9 +508,9 @@ static int
 hws_definer_conv_outer(struct mlx5hws_definer_conv_data *cd,
 		       u32 *match_param)
 {
-	bool is_s_ipv6, is_d_ipv6, smac_set, dmac_set;
 	struct mlx5hws_definer_fc *fc = cd->fc;
 	struct mlx5hws_definer_fc *curr_fc;
+	bool is_ipv6, smac_set, dmac_set;
 	u32 *s_ipv6, *d_ipv6;
 
 	if (HWS_IS_FLD_SET_SZ(match_param, outer_headers.l4_type, 0x2) ||
@@ -569,10 +569,10 @@ hws_definer_conv_outer(struct mlx5hws_definer_conv_data *cd,
 			      outer_headers.dst_ipv4_dst_ipv6.ipv6_layout);
 
 	/* Assume IPv6 is used if ipv6 bits are set */
-	is_s_ipv6 = s_ipv6[0] || s_ipv6[1] || s_ipv6[2];
-	is_d_ipv6 = d_ipv6[0] || d_ipv6[1] || d_ipv6[2];
+	is_ipv6 = s_ipv6[0] || s_ipv6[1] || s_ipv6[2] ||
+		  d_ipv6[0] || d_ipv6[1] || d_ipv6[2];
 
-	if (is_s_ipv6) {
+	if (is_ipv6) {
 		/* Handle IPv6 source address */
 		HWS_SET_HDR(fc, match_param, IPV6_SRC_127_96_O,
 			    outer_headers.src_ipv4_src_ipv6.ipv6_simple_layout.ipv6_127_96,
@@ -586,13 +586,6 @@ hws_definer_conv_outer(struct mlx5hws_definer_conv_data *cd,
 		HWS_SET_HDR(fc, match_param, IPV6_SRC_31_0_O,
 			    outer_headers.src_ipv4_src_ipv6.ipv6_simple_layout.ipv6_31_0,
 			    ipv6_src_outer.ipv6_address_31_0);
-	} else {
-		/* Handle IPv4 source address */
-		HWS_SET_HDR(fc, match_param, IPV4_SRC_O,
-			    outer_headers.src_ipv4_src_ipv6.ipv6_simple_layout.ipv6_31_0,
-			    ipv4_src_dest_outer.source_address);
-	}
-	if (is_d_ipv6) {
 		/* Handle IPv6 destination address */
 		HWS_SET_HDR(fc, match_param, IPV6_DST_127_96_O,
 			    outer_headers.dst_ipv4_dst_ipv6.ipv6_simple_layout.ipv6_127_96,
@@ -607,6 +600,10 @@ hws_definer_conv_outer(struct mlx5hws_definer_conv_data *cd,
 			    outer_headers.dst_ipv4_dst_ipv6.ipv6_simple_layout.ipv6_31_0,
 			    ipv6_dst_outer.ipv6_address_31_0);
 	} else {
+		/* Handle IPv4 source address */
+		HWS_SET_HDR(fc, match_param, IPV4_SRC_O,
+			    outer_headers.src_ipv4_src_ipv6.ipv6_simple_layout.ipv6_31_0,
+			    ipv4_src_dest_outer.source_address);
 		/* Handle IPv4 destination address */
 		HWS_SET_HDR(fc, match_param, IPV4_DST_O,
 			    outer_headers.dst_ipv4_dst_ipv6.ipv6_simple_layout.ipv6_31_0,
@@ -664,9 +661,9 @@ static int
 hws_definer_conv_inner(struct mlx5hws_definer_conv_data *cd,
 		       u32 *match_param)
 {
-	bool is_s_ipv6, is_d_ipv6, smac_set, dmac_set;
 	struct mlx5hws_definer_fc *fc = cd->fc;
 	struct mlx5hws_definer_fc *curr_fc;
+	bool is_ipv6, smac_set, dmac_set;
 	u32 *s_ipv6, *d_ipv6;
 
 	if (HWS_IS_FLD_SET_SZ(match_param, inner_headers.l4_type, 0x2) ||
@@ -727,10 +724,10 @@ hws_definer_conv_inner(struct mlx5hws_definer_conv_data *cd,
 			      inner_headers.dst_ipv4_dst_ipv6.ipv6_layout);
 
 	/* Assume IPv6 is used if ipv6 bits are set */
-	is_s_ipv6 = s_ipv6[0] || s_ipv6[1] || s_ipv6[2];
-	is_d_ipv6 = d_ipv6[0] || d_ipv6[1] || d_ipv6[2];
+	is_ipv6 = s_ipv6[0] || s_ipv6[1] || s_ipv6[2] ||
+		  d_ipv6[0] || d_ipv6[1] || d_ipv6[2];
 
-	if (is_s_ipv6) {
+	if (is_ipv6) {
 		/* Handle IPv6 source address */
 		HWS_SET_HDR(fc, match_param, IPV6_SRC_127_96_I,
 			    inner_headers.src_ipv4_src_ipv6.ipv6_simple_layout.ipv6_127_96,
@@ -744,13 +741,6 @@ hws_definer_conv_inner(struct mlx5hws_definer_conv_data *cd,
 		HWS_SET_HDR(fc, match_param, IPV6_SRC_31_0_I,
 			    inner_headers.src_ipv4_src_ipv6.ipv6_simple_layout.ipv6_31_0,
 			    ipv6_src_inner.ipv6_address_31_0);
-	} else {
-		/* Handle IPv4 source address */
-		HWS_SET_HDR(fc, match_param, IPV4_SRC_I,
-			    inner_headers.src_ipv4_src_ipv6.ipv6_simple_layout.ipv6_31_0,
-			    ipv4_src_dest_inner.source_address);
-	}
-	if (is_d_ipv6) {
 		/* Handle IPv6 destination address */
 		HWS_SET_HDR(fc, match_param, IPV6_DST_127_96_I,
 			    inner_headers.dst_ipv4_dst_ipv6.ipv6_simple_layout.ipv6_127_96,
@@ -765,6 +755,10 @@ hws_definer_conv_inner(struct mlx5hws_definer_conv_data *cd,
 			    inner_headers.dst_ipv4_dst_ipv6.ipv6_simple_layout.ipv6_31_0,
 			    ipv6_dst_inner.ipv6_address_31_0);
 	} else {
+		/* Handle IPv4 source address */
+		HWS_SET_HDR(fc, match_param, IPV4_SRC_I,
+			    inner_headers.src_ipv4_src_ipv6.ipv6_simple_layout.ipv6_31_0,
+			    ipv4_src_dest_inner.source_address);
 		/* Handle IPv4 destination address */
 		HWS_SET_HDR(fc, match_param, IPV4_DST_I,
 			    inner_headers.dst_ipv4_dst_ipv6.ipv6_simple_layout.ipv6_31_0,
-- 
2.39.5

