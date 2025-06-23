Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7253C1C5D46;
	Mon, 23 Jun 2025 21:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714382; cv=none; b=KVTVbSSE78ELTfOgO8x4SABf0LPtNPhl5dDRs64gvI/UtwGiE/P1ITXY4CANw9dRVrruXereuRTEc4f/gyjZQWUVmdRtpvYe/M5VmRY9HS6khp5F/rgdGFHFwEFVKFB9d9oyHt1yiOXrNXV+w1j8P+cwb2PdSb+VHw5H59piLTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714382; c=relaxed/simple;
	bh=4ZVryBueCgyqIErQP+8hTO29/IA7aO9OHUFyB6WGwmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I2aeSlpjwc8iuU05hxGE7+vcOsWXWuzLLfVC3c8+vIKWx07mqQJbSbmZl9tZ8judC59DjzuQZQgl4oB7DHdU97u2IePOgaSdMyO2+eNvQRdZkzHwU0FrGULFMqp6/y1G44nAMw66ylQjeAeCrVU2/v6p6ZpudnSqpU0ZtSUpUno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yEGev9V6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yEGev9V6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09646C4CEEA;
	Mon, 23 Jun 2025 21:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714382;
	bh=4ZVryBueCgyqIErQP+8hTO29/IA7aO9OHUFyB6WGwmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yEGev9V6GMUNzQHEME6I5m1TQPy0U6Xcifc0E4eKY/TlS4bHVFYqQgoN8+LSVLIGn
	 W50j+r60pTr7fwEsiwUf9QNiDW5en/VbQp3Jc5zLUJAsbkpnbUJJS9/2jBWnQ11jiV
	 Q8P64bZHrxK78zfVnVbK/ehZhSDHtUr+mPnlyapU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlad Dogaru <vdogaru@nvidia.com>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 387/592] net/mlx5: HWS, Fix IP version decision
Date: Mon, 23 Jun 2025 15:05:45 +0200
Message-ID: <20250623130709.646898390@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

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
 .../mellanox/mlx5/core/steering/hws/definer.c | 38 ++++++++-----------
 1 file changed, 16 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/definer.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/definer.c
index 293459458cc5f..7dc6d8cd744e1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/definer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/definer.c
@@ -509,9 +509,9 @@ static int
 hws_definer_conv_outer(struct mlx5hws_definer_conv_data *cd,
 		       u32 *match_param)
 {
-	bool is_s_ipv6, is_d_ipv6, smac_set, dmac_set;
 	struct mlx5hws_definer_fc *fc = cd->fc;
 	struct mlx5hws_definer_fc *curr_fc;
+	bool is_ipv6, smac_set, dmac_set;
 	u32 *s_ipv6, *d_ipv6;
 
 	if (HWS_IS_FLD_SET_SZ(match_param, outer_headers.l4_type, 0x2) ||
@@ -573,10 +573,10 @@ hws_definer_conv_outer(struct mlx5hws_definer_conv_data *cd,
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
@@ -590,13 +590,6 @@ hws_definer_conv_outer(struct mlx5hws_definer_conv_data *cd,
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
@@ -611,6 +604,10 @@ hws_definer_conv_outer(struct mlx5hws_definer_conv_data *cd,
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
@@ -668,9 +665,9 @@ static int
 hws_definer_conv_inner(struct mlx5hws_definer_conv_data *cd,
 		       u32 *match_param)
 {
-	bool is_s_ipv6, is_d_ipv6, smac_set, dmac_set;
 	struct mlx5hws_definer_fc *fc = cd->fc;
 	struct mlx5hws_definer_fc *curr_fc;
+	bool is_ipv6, smac_set, dmac_set;
 	u32 *s_ipv6, *d_ipv6;
 
 	if (HWS_IS_FLD_SET_SZ(match_param, inner_headers.l4_type, 0x2) ||
@@ -731,10 +728,10 @@ hws_definer_conv_inner(struct mlx5hws_definer_conv_data *cd,
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
@@ -748,13 +745,6 @@ hws_definer_conv_inner(struct mlx5hws_definer_conv_data *cd,
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
@@ -769,6 +759,10 @@ hws_definer_conv_inner(struct mlx5hws_definer_conv_data *cd,
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



