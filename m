Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC404315A;
	Mon, 23 Jun 2025 21:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714892; cv=none; b=Hx4W6iY/DlxA2SP1E3Jb+XNkb9tTQ9VM34drU+gXUVp48dWOL/hEsSZLcdEcGjLD/Imqt/pbA7QJY64fYOAMyOW19EO8lf3Aair2ra4OZomRXgUQIKhsL2fxZcd5/7aoq9RypRZtPyNIn2GB6M5/5G2hIAJ7k2ptfyUD3Ct8rKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714892; c=relaxed/simple;
	bh=d1+FMVcCRUWpZXeJAhqUMlUVSLYJG7IngDJKtV8OGZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l0DDzcSwdWab+FKk+v5GkEHjWzNKj4owRadD2u0BJKVetWOZNTpxni9Nf3ukZ3ViyTSSDzv1Z0/LhiyOsCWyTfDSp9m7wdVp+F8j3aYHa+jzI6yyJEjcPdMTFCBewi6BNQf3/LKqri3sy+tqCpVdXJwMNhpobnYwOlfHs145MQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ppXFju/H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ppXFju/H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E60BAC4CEEA;
	Mon, 23 Jun 2025 21:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714892;
	bh=d1+FMVcCRUWpZXeJAhqUMlUVSLYJG7IngDJKtV8OGZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ppXFju/HQSD7mlWqHHZv13ztomy81/RztpXPSq6DEEgGPDpxCO+SOnQ8yBV7kPRnJ
	 NTEN59TBJyDqjOi3C0xxbb7KbFDZV4gzO3bi3CG6CkEzIQot+3zJwoGsJrgTh3fD3C
	 xL9yruG8Cf+EB7sjHRcxC0RnbwKI+P7koSiA5x5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlad Dogaru <vdogaru@nvidia.com>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 424/592] net/mlx5: HWS, Harden IP version definer checks
Date: Mon, 23 Jun 2025 15:06:22 +0200
Message-ID: <20250623130710.522396276@linuxfoundation.org>
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
 .../mellanox/mlx5/core/steering/hws/definer.c | 44 ++++++++++++++++++-
 1 file changed, 42 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/definer.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/definer.c
index 7dc6d8cd744e1..ecda35597111e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/definer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/definer.c
@@ -509,9 +509,9 @@ static int
 hws_definer_conv_outer(struct mlx5hws_definer_conv_data *cd,
 		       u32 *match_param)
 {
+	bool is_ipv6, smac_set, dmac_set, ip_addr_set, ip_ver_set;
 	struct mlx5hws_definer_fc *fc = cd->fc;
 	struct mlx5hws_definer_fc *curr_fc;
-	bool is_ipv6, smac_set, dmac_set;
 	u32 *s_ipv6, *d_ipv6;
 
 	if (HWS_IS_FLD_SET_SZ(match_param, outer_headers.l4_type, 0x2) ||
@@ -521,6 +521,20 @@ hws_definer_conv_outer(struct mlx5hws_definer_conv_data *cd,
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
@@ -576,6 +590,12 @@ hws_definer_conv_outer(struct mlx5hws_definer_conv_data *cd,
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
@@ -665,9 +685,9 @@ static int
 hws_definer_conv_inner(struct mlx5hws_definer_conv_data *cd,
 		       u32 *match_param)
 {
+	bool is_ipv6, smac_set, dmac_set, ip_addr_set, ip_ver_set;
 	struct mlx5hws_definer_fc *fc = cd->fc;
 	struct mlx5hws_definer_fc *curr_fc;
-	bool is_ipv6, smac_set, dmac_set;
 	u32 *s_ipv6, *d_ipv6;
 
 	if (HWS_IS_FLD_SET_SZ(match_param, inner_headers.l4_type, 0x2) ||
@@ -677,6 +697,20 @@ hws_definer_conv_inner(struct mlx5hws_definer_conv_data *cd,
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
@@ -731,6 +765,12 @@ hws_definer_conv_inner(struct mlx5hws_definer_conv_data *cd,
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



