Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0BA1F7092;
	Wed,  6 Nov 2024 12:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897056; cv=none; b=pMBRHxgmNuWwG41z7cBDbDCBbs5ZMl+uFcTFdpn1Nz/eDL+FpIEDVKh0dpGVrcNZbM95d2/MLGLQnSaLm/fsHHCQ1TTi7E5du6kx+0jhpF/pDCasERp23XY83FF5WO8MaiLnrAG1Vn04nVd5DWd26mDYoBBjwsiCi8d0UJVeHfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897056; c=relaxed/simple;
	bh=ibMiy7frOXhfHpg/K/CI64HkJQdo6bg+gLEgPyQXp6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OoEAP6XPH0GzwOsaXoWX028nfdtSrNAVQSEgr7ekk7TfacJvmbMk1qBjBdLIuHGV/A/pi8I59d49u3X2gBG6Xm3XYz48uI7Df4lTWaAO0sKqx0NUsctVSIaqEUt27E0eew432XROO9R1PX0a0Qm/5qtGE9VGITQJbapJtQ3cHj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AOsZevO7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AOsZevO7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0701C4CED3;
	Wed,  6 Nov 2024 12:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897056;
	bh=ibMiy7frOXhfHpg/K/CI64HkJQdo6bg+gLEgPyQXp6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AOsZevO7H98cKP4zJ+Bhd2oMA7gSQQvXIR7it5qNHR09Ro9V0Cxa6A9JPXKq2iyl7
	 wKAKfUGzGRb6dzokvimOz0pGkpxXQQtag07T9Pvuveb1UP4E7LNWmDiRZu5IOcdbMA
	 w0nIIEb/n51MbJOFRQfhc5em3p/HvLAN/kekdECc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Amit Cohen <amcohen@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 034/126] mlxsw: spectrum_router: Add support for double entry RIFs
Date: Wed,  6 Nov 2024 13:03:55 +0100
Message-ID: <20241106120307.031439718@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 5ca1b208c5d107fd4b9e7801200dea18ab1af8e7 ]

In Spectrum-1, loopback router interfaces (RIFs) used for IP-in-IP
encapsulation with an IPv6 underlay require two RIF entries and the RIF
index must be even.

Prepare for this change by extending the RIF parameters structure with a
'double_entry' field that indicates if the RIF being created requires
two RIF entries or not. Only set it for RIFs representing ip6gre tunnels
in Spectrum-1.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 12ae97c531fc ("mlxsw: spectrum_ipip: Fix memory leak when changing remote IPv6 address")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c   |    1 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h   |    1 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c |    2 ++
 3 files changed, 4 insertions(+)

--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
@@ -433,6 +433,7 @@ static const struct mlxsw_sp_ipip_ops ml
 	.dev_type = ARPHRD_IP6GRE,
 	.ul_proto = MLXSW_SP_L3_PROTO_IPV6,
 	.inc_parsing_depth = true,
+	.double_rif_entry = true,
 	.parms_init = mlxsw_sp1_ipip_netdev_parms_init_gre6,
 	.nexthop_update = mlxsw_sp1_ipip_nexthop_update_gre6,
 	.decap_config = mlxsw_sp1_ipip_decap_config_gre6,
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h
@@ -49,6 +49,7 @@ struct mlxsw_sp_ipip_ops {
 	int dev_type;
 	enum mlxsw_sp_l3proto ul_proto; /* Underlay. */
 	bool inc_parsing_depth;
+	bool double_rif_entry;
 
 	struct mlxsw_sp_ipip_parms
 	(*parms_init)(const struct net_device *ol_dev);
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -77,6 +77,7 @@ struct mlxsw_sp_rif_params {
 	};
 	u16 vid;
 	bool lag;
+	bool double_entry;
 };
 
 struct mlxsw_sp_rif_subport {
@@ -1068,6 +1069,7 @@ mlxsw_sp_ipip_ol_ipip_lb_create(struct m
 	lb_params = (struct mlxsw_sp_rif_params_ipip_lb) {
 		.common.dev = ol_dev,
 		.common.lag = false,
+		.common.double_entry = ipip_ops->double_rif_entry,
 		.lb_config = ipip_ops->ol_loopback_config(mlxsw_sp, ol_dev),
 	};
 


