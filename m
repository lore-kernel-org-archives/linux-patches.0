Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E0781F7580;
	Mon, 23 Jun 2025 22:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716774; cv=none; b=jY55DqdKZ7RQkSw/L3z0rFNOHgrwRHpdsKfU8vaifPMHz4ZAMdt28McFZY/12w829sJJZYp7s8PqapGug2LC2wVDg7+zsV56vAJO1f7IaZ6Tmr0M2IBysVPahM6+VBFnLSbej0qUPxwXGSm/e2ozUZOSo5pMPQIWUjaQQDd5EDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716774; c=relaxed/simple;
	bh=9Cv0Y/c/CqGxO2Gh70CHxF09UO1t64z+oVF7b9ndCCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bvwzrnIkp6894B9RqE6GYG/Ayt7zWEYAVdUCfIMqddyF4csn8Af6tHkvP8fPKbL23bpTUWecd9zW4RQ+42VSQEaWEt9oTG90cjt2yawr0mPrPHqy/AebXFNDuB0pkWPC4LC6kMTsfzhwqyrz3zVvCh+DXhEmMGfbaTrRcFKv+OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UP1FeCkt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UP1FeCkt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA023C4CEF1;
	Mon, 23 Jun 2025 22:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716774;
	bh=9Cv0Y/c/CqGxO2Gh70CHxF09UO1t64z+oVF7b9ndCCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UP1FeCkt4Az8t45pKiPq7awp4BlSzn96mH3umagQHKc4xMemHnE+zISY/dQuJuqje
	 H2gJNIylibV+W3buondWQdETBdB/lKhddtKgDQqp9KQO9W9hor+CCBbMmKK1jDzUsz
	 3PkvcVOVYCaxrG8LVKi6w7NRP2Cm0ounLU3BkXfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlad Dogaru <vdogaru@nvidia.com>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 281/414] net/mlx5: HWS, Harden IP version definer checks
Date: Mon, 23 Jun 2025 15:06:58 +0200
Message-ID: <20250623130649.045547270@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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
 .../mlx5/core/steering/hws/mlx5hws_definer.c  | 44 ++++++++++++++++++-
 1 file changed, 42 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_definer.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_definer.c
index 0d0591ba41fdb..fc9ba534d5d97 100644
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
@@ -575,6 +589,12 @@ hws_definer_conv_outer(struct mlx5hws_definer_conv_data *cd,
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
@@ -664,9 +684,9 @@ static int
 hws_definer_conv_inner(struct mlx5hws_definer_conv_data *cd,
 		       u32 *match_param)
 {
+	bool is_ipv6, smac_set, dmac_set, ip_addr_set, ip_ver_set;
 	struct mlx5hws_definer_fc *fc = cd->fc;
 	struct mlx5hws_definer_fc *curr_fc;
-	bool is_ipv6, smac_set, dmac_set;
 	u32 *s_ipv6, *d_ipv6;
 
 	if (HWS_IS_FLD_SET_SZ(match_param, inner_headers.l4_type, 0x2) ||
@@ -676,6 +696,20 @@ hws_definer_conv_inner(struct mlx5hws_definer_conv_data *cd,
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
@@ -730,6 +764,12 @@ hws_definer_conv_inner(struct mlx5hws_definer_conv_data *cd,
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



