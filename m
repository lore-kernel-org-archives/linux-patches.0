Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809B01EC00E;
	Wed,  6 Nov 2024 12:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897088; cv=none; b=GSAcfaG8edm5GErj2fp3Tqk95VGhjP5EVXehQwaYs97vnPRwpj4L/MJ2H2H7fZmGEskvJxN0JR0JpSRZUDH7r9KJQfr1p1o3RDpnNv+rHLM9gkXpFzrKCWqSxQBy9bpMRLfBJQ1poJXY3T6LuMGSQlyalEm3NwIWjHKeKAJTnDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897088; c=relaxed/simple;
	bh=+KwZF2j0i3nJGA34Rg8Qh79+wYmr8IoHyPUxLRGTfPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K1ZyO73/ubqDnfOi0+Awd8KM1faQnhcgBB9lwtosmiivj2Fwg6YqadTsiOFQvC3MrXUT1ho5AebNmqLqPFrqhsSOSn+dvNDYwxetExMFZLebU5L4eVRqyD8NRIYaSC8yrSbNt3/l3+jn5bq+5ON0oBy3wdvAyNwAzffi2zd2l7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SgGLp9Fp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SgGLp9Fp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 078E1C4CECD;
	Wed,  6 Nov 2024 12:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897088;
	bh=+KwZF2j0i3nJGA34Rg8Qh79+wYmr8IoHyPUxLRGTfPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SgGLp9FpGgCrbuLA6M0eO6aPyBKCdWF+VmK4My/INU1Dt8xca4TGy00Pd7XZVAqO+
	 Ivhau7uP8lBMsU3cEAvYJ+DtOu9rvnrli8ztTbXMMQfdZuTFvJLN4voRQsEoNv8+m2
	 J8YM5TrYmddtZL7iUdqnLARbT8hse3gddYV/jF88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Amit Cohen <amcohen@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 035/126] mlxsw: spectrum_ipip: Rename Spectrum-2 ip6gre operations
Date: Wed,  6 Nov 2024 13:03:56 +0100
Message-ID: <20241106120307.057226727@linuxfoundation.org>
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

[ Upstream commit ab30e4d4b29ba530c65406e8a146630d0663c570 ]

There are two main differences between Spectrum-1 and newer ASICs in
terms of IP-in-IP support:

1. In Spectrum-1, RIFs representing ip6gre tunnels require two entries
   in the RIF table.

2. In Spectrum-2 and newer ASICs, packets ingress the underlay (during
   encapsulation) and egress the underlay (during decapsulation) via a
   special generic loopback RIF.

The first difference was handled in previous patches by adding the
'double_rif_entry' field to the Spectrum-1 operations structure of
ip6gre RIFs. The second difference is handled during RIF creation, by
only creating a generic loopback RIF in Spectrum-2 and newer ASICs.

Therefore, the ip6gre operations can be shared between Spectrum-1 and
newer ASIC in a similar fashion to how the ipgre operations are shared.

Rename the operations to not be Spectrum-2 specific and move them
earlier in the file so that they could later be used for Spectrum-1.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 12ae97c531fc ("mlxsw: spectrum_ipip: Fix memory leak when changing remote IPv6 address")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlxsw/spectrum_ipip.c   | 94 +++++++++----------
 1 file changed, 47 insertions(+), 47 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
index 7ed4b64fecc7a..fd421fbfc71bd 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
@@ -429,28 +429,8 @@ mlxsw_sp1_ipip_rem_addr_unset_gre6(struct mlxsw_sp *mlxsw_sp,
 	WARN_ON_ONCE(1);
 }
 
-static const struct mlxsw_sp_ipip_ops mlxsw_sp1_ipip_gre6_ops = {
-	.dev_type = ARPHRD_IP6GRE,
-	.ul_proto = MLXSW_SP_L3_PROTO_IPV6,
-	.inc_parsing_depth = true,
-	.double_rif_entry = true,
-	.parms_init = mlxsw_sp1_ipip_netdev_parms_init_gre6,
-	.nexthop_update = mlxsw_sp1_ipip_nexthop_update_gre6,
-	.decap_config = mlxsw_sp1_ipip_decap_config_gre6,
-	.can_offload = mlxsw_sp1_ipip_can_offload_gre6,
-	.ol_loopback_config = mlxsw_sp1_ipip_ol_loopback_config_gre6,
-	.ol_netdev_change = mlxsw_sp1_ipip_ol_netdev_change_gre6,
-	.rem_ip_addr_set = mlxsw_sp1_ipip_rem_addr_set_gre6,
-	.rem_ip_addr_unset = mlxsw_sp1_ipip_rem_addr_unset_gre6,
-};
-
-const struct mlxsw_sp_ipip_ops *mlxsw_sp1_ipip_ops_arr[] = {
-	[MLXSW_SP_IPIP_TYPE_GRE4] = &mlxsw_sp_ipip_gre4_ops,
-	[MLXSW_SP_IPIP_TYPE_GRE6] = &mlxsw_sp1_ipip_gre6_ops,
-};
-
 static struct mlxsw_sp_ipip_parms
-mlxsw_sp2_ipip_netdev_parms_init_gre6(const struct net_device *ol_dev)
+mlxsw_sp_ipip_netdev_parms_init_gre6(const struct net_device *ol_dev)
 {
 	struct __ip6_tnl_parm parms = mlxsw_sp_ipip_netdev_parms6(ol_dev);
 
@@ -465,9 +445,9 @@ mlxsw_sp2_ipip_netdev_parms_init_gre6(const struct net_device *ol_dev)
 }
 
 static int
-mlxsw_sp2_ipip_nexthop_update_gre6(struct mlxsw_sp *mlxsw_sp, u32 adj_index,
-				   struct mlxsw_sp_ipip_entry *ipip_entry,
-				   bool force, char *ratr_pl)
+mlxsw_sp_ipip_nexthop_update_gre6(struct mlxsw_sp *mlxsw_sp, u32 adj_index,
+				  struct mlxsw_sp_ipip_entry *ipip_entry,
+				  bool force, char *ratr_pl)
 {
 	u16 rif_index = mlxsw_sp_ipip_lb_rif_index(ipip_entry->ol_lb);
 	enum mlxsw_reg_ratr_op op;
@@ -483,9 +463,9 @@ mlxsw_sp2_ipip_nexthop_update_gre6(struct mlxsw_sp *mlxsw_sp, u32 adj_index,
 }
 
 static int
-mlxsw_sp2_ipip_decap_config_gre6(struct mlxsw_sp *mlxsw_sp,
-				 struct mlxsw_sp_ipip_entry *ipip_entry,
-				 u32 tunnel_index)
+mlxsw_sp_ipip_decap_config_gre6(struct mlxsw_sp *mlxsw_sp,
+				struct mlxsw_sp_ipip_entry *ipip_entry,
+				u32 tunnel_index)
 {
 	u16 rif_index = mlxsw_sp_ipip_lb_rif_index(ipip_entry->ol_lb);
 	u16 ul_rif_id = mlxsw_sp_ipip_lb_ul_rif_id(ipip_entry->ol_lb);
@@ -520,8 +500,8 @@ mlxsw_sp2_ipip_decap_config_gre6(struct mlxsw_sp *mlxsw_sp,
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(rtdp), rtdp_pl);
 }
 
-static bool mlxsw_sp2_ipip_can_offload_gre6(const struct mlxsw_sp *mlxsw_sp,
-					    const struct net_device *ol_dev)
+static bool mlxsw_sp_ipip_can_offload_gre6(const struct mlxsw_sp *mlxsw_sp,
+					   const struct net_device *ol_dev)
 {
 	struct __ip6_tnl_parm tparm = mlxsw_sp_ipip_netdev_parms6(ol_dev);
 	bool inherit_tos = tparm.flags & IP6_TNL_F_USE_ORIG_TCLASS;
@@ -535,8 +515,8 @@ static bool mlxsw_sp2_ipip_can_offload_gre6(const struct mlxsw_sp *mlxsw_sp,
 }
 
 static struct mlxsw_sp_rif_ipip_lb_config
-mlxsw_sp2_ipip_ol_loopback_config_gre6(struct mlxsw_sp *mlxsw_sp,
-				       const struct net_device *ol_dev)
+mlxsw_sp_ipip_ol_loopback_config_gre6(struct mlxsw_sp *mlxsw_sp,
+				      const struct net_device *ol_dev)
 {
 	struct __ip6_tnl_parm parms = mlxsw_sp_ipip_netdev_parms6(ol_dev);
 	enum mlxsw_reg_ritr_loopback_ipip_type lb_ipipt;
@@ -554,20 +534,20 @@ mlxsw_sp2_ipip_ol_loopback_config_gre6(struct mlxsw_sp *mlxsw_sp,
 }
 
 static int
-mlxsw_sp2_ipip_ol_netdev_change_gre6(struct mlxsw_sp *mlxsw_sp,
-				     struct mlxsw_sp_ipip_entry *ipip_entry,
-				     struct netlink_ext_ack *extack)
+mlxsw_sp_ipip_ol_netdev_change_gre6(struct mlxsw_sp *mlxsw_sp,
+				    struct mlxsw_sp_ipip_entry *ipip_entry,
+				    struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sp_ipip_parms new_parms;
 
-	new_parms = mlxsw_sp2_ipip_netdev_parms_init_gre6(ipip_entry->ol_dev);
+	new_parms = mlxsw_sp_ipip_netdev_parms_init_gre6(ipip_entry->ol_dev);
 	return mlxsw_sp_ipip_ol_netdev_change_gre(mlxsw_sp, ipip_entry,
 						  &new_parms, extack);
 }
 
 static int
-mlxsw_sp2_ipip_rem_addr_set_gre6(struct mlxsw_sp *mlxsw_sp,
-				 struct mlxsw_sp_ipip_entry *ipip_entry)
+mlxsw_sp_ipip_rem_addr_set_gre6(struct mlxsw_sp *mlxsw_sp,
+				struct mlxsw_sp_ipip_entry *ipip_entry)
 {
 	return mlxsw_sp_ipv6_addr_kvdl_index_get(mlxsw_sp,
 						 &ipip_entry->parms.daddr.addr6,
@@ -575,24 +555,44 @@ mlxsw_sp2_ipip_rem_addr_set_gre6(struct mlxsw_sp *mlxsw_sp,
 }
 
 static void
-mlxsw_sp2_ipip_rem_addr_unset_gre6(struct mlxsw_sp *mlxsw_sp,
-				   const struct mlxsw_sp_ipip_entry *ipip_entry)
+mlxsw_sp_ipip_rem_addr_unset_gre6(struct mlxsw_sp *mlxsw_sp,
+				  const struct mlxsw_sp_ipip_entry *ipip_entry)
 {
 	mlxsw_sp_ipv6_addr_put(mlxsw_sp, &ipip_entry->parms.daddr.addr6);
 }
 
+static const struct mlxsw_sp_ipip_ops mlxsw_sp1_ipip_gre6_ops = {
+	.dev_type = ARPHRD_IP6GRE,
+	.ul_proto = MLXSW_SP_L3_PROTO_IPV6,
+	.inc_parsing_depth = true,
+	.double_rif_entry = true,
+	.parms_init = mlxsw_sp1_ipip_netdev_parms_init_gre6,
+	.nexthop_update = mlxsw_sp1_ipip_nexthop_update_gre6,
+	.decap_config = mlxsw_sp1_ipip_decap_config_gre6,
+	.can_offload = mlxsw_sp1_ipip_can_offload_gre6,
+	.ol_loopback_config = mlxsw_sp1_ipip_ol_loopback_config_gre6,
+	.ol_netdev_change = mlxsw_sp1_ipip_ol_netdev_change_gre6,
+	.rem_ip_addr_set = mlxsw_sp1_ipip_rem_addr_set_gre6,
+	.rem_ip_addr_unset = mlxsw_sp1_ipip_rem_addr_unset_gre6,
+};
+
+const struct mlxsw_sp_ipip_ops *mlxsw_sp1_ipip_ops_arr[] = {
+	[MLXSW_SP_IPIP_TYPE_GRE4] = &mlxsw_sp_ipip_gre4_ops,
+	[MLXSW_SP_IPIP_TYPE_GRE6] = &mlxsw_sp1_ipip_gre6_ops,
+};
+
 static const struct mlxsw_sp_ipip_ops mlxsw_sp2_ipip_gre6_ops = {
 	.dev_type = ARPHRD_IP6GRE,
 	.ul_proto = MLXSW_SP_L3_PROTO_IPV6,
 	.inc_parsing_depth = true,
-	.parms_init = mlxsw_sp2_ipip_netdev_parms_init_gre6,
-	.nexthop_update = mlxsw_sp2_ipip_nexthop_update_gre6,
-	.decap_config = mlxsw_sp2_ipip_decap_config_gre6,
-	.can_offload = mlxsw_sp2_ipip_can_offload_gre6,
-	.ol_loopback_config = mlxsw_sp2_ipip_ol_loopback_config_gre6,
-	.ol_netdev_change = mlxsw_sp2_ipip_ol_netdev_change_gre6,
-	.rem_ip_addr_set = mlxsw_sp2_ipip_rem_addr_set_gre6,
-	.rem_ip_addr_unset = mlxsw_sp2_ipip_rem_addr_unset_gre6,
+	.parms_init = mlxsw_sp_ipip_netdev_parms_init_gre6,
+	.nexthop_update = mlxsw_sp_ipip_nexthop_update_gre6,
+	.decap_config = mlxsw_sp_ipip_decap_config_gre6,
+	.can_offload = mlxsw_sp_ipip_can_offload_gre6,
+	.ol_loopback_config = mlxsw_sp_ipip_ol_loopback_config_gre6,
+	.ol_netdev_change = mlxsw_sp_ipip_ol_netdev_change_gre6,
+	.rem_ip_addr_set = mlxsw_sp_ipip_rem_addr_set_gre6,
+	.rem_ip_addr_unset = mlxsw_sp_ipip_rem_addr_unset_gre6,
 };
 
 const struct mlxsw_sp_ipip_ops *mlxsw_sp2_ipip_ops_arr[] = {
-- 
2.43.0



