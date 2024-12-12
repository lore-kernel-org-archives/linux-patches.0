Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE98217670;
	Thu, 12 Dec 2024 15:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017595; cv=none; b=qn1qvDGq/APEfPInQKwa0w8gKM8OeOSzfNDBPfvZBplqUhu4wZuECJMbhfBIyLik6I6K98EvpqsZDt/IDvqu75H/Hb1WedsPA9BT8AFcQ1uk1LWLVoujx3oAGTG5v97KuazEHqQai15qvLeP/DwgOzFX0MRu0SGJSvVniAf6OS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017595; c=relaxed/simple;
	bh=iTdQcIqSWf8hnHv6wIPxzbyNwyDkIVC+waZ1EVg79Ts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DIAonORJDi2fP3sIMVJZSiDQZO6OeN9BGXQzg8qRoRTxu444xYdnAmRhhOqoKwp1W6+2i0iMvG2XREbhkpBDXAyfUcA6Qv72j7nLobnuK+TGVmm1gHSY06lEjmosDZf49zkSe5ue/mJd7tQLdJz9Zzm89vHKwPJ5sF3+wOL+yYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HQZajLoY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HQZajLoY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD60C4CECE;
	Thu, 12 Dec 2024 15:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017595;
	bh=iTdQcIqSWf8hnHv6wIPxzbyNwyDkIVC+waZ1EVg79Ts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HQZajLoYCyWKoMe3R/wAEuxduht9I7a/TN5lNAUwauzjAuB832bqJXmwtJv15iiEh
	 RWlcOdBE5I3J0Z95MZobtNjAhfxoc5IsTwbwAf/aWNLh3ykZjjHy6KPPEQOdsbrUj8
	 vqu3+EfvaHpW5pkFMSbl1XXXwsjb9/4IU7ygGMhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Cohen <amcohen@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 056/356] mlxsw: Edit IPv6 key blocks to use one less block for multicast forwarding
Date: Thu, 12 Dec 2024 15:56:15 +0100
Message-ID: <20241212144246.843728794@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amit Cohen <amcohen@nvidia.com>

[ Upstream commit 92953e7aab013719aa8974805614c0bc11361026 ]

Two ACL regions that are configured by the driver during initialization are
the ones used for IPv4 and IPv6 multicast forwarding. Entries residing
in these two regions match on the {SIP, DIP, VRID} key elements.

Currently for IPv6 region, 9 key blocks are used:
* 4 for SIP - 'ipv4_1', 'ipv6_{3,4,5}'
* 4 for DIP - 'ipv4_0', 'ipv6_{0,1,2/2b}'
* 1 for VRID - 'ipv4_4b'

This can be improved by reducing the amount key blocks needed for
the IPv6 region to 8. It is possible to use key blocks that mix subsets of
the VRID element with subsets of the DIP element.
The following key blocks can be used:
* 4 for SIP - 'ipv4_1', 'ipv6_{3,4,5}'
* 1 for subset of DIP - 'ipv4_0'
* 3 for the rest of DIP and subsets of VRID - 'ipv6_{0,1,2/2b}'

To make this happen, add VRID sub-elements as part of existing keys -
'ipv6_{0,1,2/2b}'. Note that one of the sub-elements is called
VRID_ROUTER_MSB and does not contain bit numbers like the rest, as for
Spectrum < 4 this element represents bits 8-10 and for Spectrum-4 it
represents bits 8-11.

Breaking VRID into 3 sub-elements makes the driver use one less block in
IPv6 region for multicast forwarding. The sub-elements can be filled in
blocks that are used for destination IP.

The algorithm in the driver that chooses which key blocks will be used is
lazy and not the optimal one. It searches the block that contains the most
elements that are required, chooses it, removes the elements that appear
in the chosen block and starts again searching the block that contains the
most elements.

When key block 'ipv4_4' is defined, the algorithm might choose it, as it
contains 2 sub-elements of VRID, then 8 blocks must be chosen for SIP and
DIP and we get 9 blocks to match on {SIP, DIP, VRID}. That is why we had to
remove key block 'ipv4_4' in a previous patch and use key block that
contains one field for VRID.

This improvement was tested and indeed 8 blocks are used instead of 9.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 217bbf156f93 ("mlxsw: spectrum_acl_flex_keys: Use correct key block on Spectrum-4")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlxsw/core_acl_flex_keys.c  |  3 +++
 .../ethernet/mellanox/mlxsw/core_acl_flex_keys.h  |  3 +++
 .../ethernet/mellanox/mlxsw/spectrum2_mr_tcam.c   | 15 ++++++++++++---
 .../mellanox/mlxsw/spectrum_acl_flex_keys.c       |  4 ++++
 4 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.c b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.c
index 5fa3800940c89..654dafc9b54d3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.c
@@ -44,6 +44,9 @@ static const struct mlxsw_afk_element_info mlxsw_afk_element_infos[] = {
 	MLXSW_AFK_ELEMENT_INFO_BUF(DST_IP_0_31, 0x3C, 4),
 	MLXSW_AFK_ELEMENT_INFO_U32(FDB_MISS, 0x40, 0, 1),
 	MLXSW_AFK_ELEMENT_INFO_U32(L4_PORT_RANGE, 0x40, 1, 16),
+	MLXSW_AFK_ELEMENT_INFO_U32(VIRT_ROUTER_0_3, 0x40, 17, 4),
+	MLXSW_AFK_ELEMENT_INFO_U32(VIRT_ROUTER_4_7, 0x40, 21, 4),
+	MLXSW_AFK_ELEMENT_INFO_U32(VIRT_ROUTER_MSB, 0x40, 25, 4),
 };
 
 struct mlxsw_afk {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.h b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.h
index 75e9bbc361701..1c76aa3ffab72 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.h
@@ -36,6 +36,9 @@ enum mlxsw_afk_element {
 	MLXSW_AFK_ELEMENT_VIRT_ROUTER,
 	MLXSW_AFK_ELEMENT_FDB_MISS,
 	MLXSW_AFK_ELEMENT_L4_PORT_RANGE,
+	MLXSW_AFK_ELEMENT_VIRT_ROUTER_0_3,
+	MLXSW_AFK_ELEMENT_VIRT_ROUTER_4_7,
+	MLXSW_AFK_ELEMENT_VIRT_ROUTER_MSB,
 	MLXSW_AFK_ELEMENT_MAX,
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum2_mr_tcam.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum2_mr_tcam.c
index 2efcc9372d4e6..99eeafdc8d1e4 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum2_mr_tcam.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum2_mr_tcam.c
@@ -88,7 +88,9 @@ static void mlxsw_sp2_mr_tcam_ipv4_fini(struct mlxsw_sp2_mr_tcam *mr_tcam)
 }
 
 static const enum mlxsw_afk_element mlxsw_sp2_mr_tcam_usage_ipv6[] = {
-		MLXSW_AFK_ELEMENT_VIRT_ROUTER,
+		MLXSW_AFK_ELEMENT_VIRT_ROUTER_0_3,
+		MLXSW_AFK_ELEMENT_VIRT_ROUTER_4_7,
+		MLXSW_AFK_ELEMENT_VIRT_ROUTER_MSB,
 		MLXSW_AFK_ELEMENT_SRC_IP_96_127,
 		MLXSW_AFK_ELEMENT_SRC_IP_64_95,
 		MLXSW_AFK_ELEMENT_SRC_IP_32_63,
@@ -140,6 +142,8 @@ static void
 mlxsw_sp2_mr_tcam_rule_parse4(struct mlxsw_sp_acl_rule_info *rulei,
 			      struct mlxsw_sp_mr_route_key *key)
 {
+	mlxsw_sp_acl_rulei_keymask_u32(rulei, MLXSW_AFK_ELEMENT_VIRT_ROUTER,
+				       key->vrid, GENMASK(11, 0));
 	mlxsw_sp_acl_rulei_keymask_buf(rulei, MLXSW_AFK_ELEMENT_SRC_IP_0_31,
 				       (char *) &key->source.addr4,
 				       (char *) &key->source_mask.addr4, 4);
@@ -152,6 +156,13 @@ static void
 mlxsw_sp2_mr_tcam_rule_parse6(struct mlxsw_sp_acl_rule_info *rulei,
 			      struct mlxsw_sp_mr_route_key *key)
 {
+	mlxsw_sp_acl_rulei_keymask_u32(rulei, MLXSW_AFK_ELEMENT_VIRT_ROUTER_0_3,
+				       key->vrid, GENMASK(3, 0));
+	mlxsw_sp_acl_rulei_keymask_u32(rulei, MLXSW_AFK_ELEMENT_VIRT_ROUTER_4_7,
+				       key->vrid >> 4, GENMASK(3, 0));
+	mlxsw_sp_acl_rulei_keymask_u32(rulei,
+				       MLXSW_AFK_ELEMENT_VIRT_ROUTER_MSB,
+				       key->vrid >> 8, GENMASK(3, 0));
 	mlxsw_sp_acl_rulei_keymask_buf(rulei, MLXSW_AFK_ELEMENT_SRC_IP_96_127,
 				       &key->source.addr6.s6_addr[0x0],
 				       &key->source_mask.addr6.s6_addr[0x0], 4);
@@ -187,8 +198,6 @@ mlxsw_sp2_mr_tcam_rule_parse(struct mlxsw_sp_acl_rule *rule,
 
 	rulei = mlxsw_sp_acl_rule_rulei(rule);
 	rulei->priority = priority;
-	mlxsw_sp_acl_rulei_keymask_u32(rulei, MLXSW_AFK_ELEMENT_VIRT_ROUTER,
-				       key->vrid, GENMASK(11, 0));
 	switch (key->proto) {
 	case MLXSW_SP_L3_PROTO_IPV4:
 		return mlxsw_sp2_mr_tcam_rule_parse4(rulei, key);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_keys.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_keys.c
index 7d66c4f2deeaa..4b3564f5fd652 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_keys.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_keys.c
@@ -176,14 +176,17 @@ static struct mlxsw_afk_element_inst mlxsw_sp_afk_element_info_ipv4_5[] = {
 };
 
 static struct mlxsw_afk_element_inst mlxsw_sp_afk_element_info_ipv6_0[] = {
+	MLXSW_AFK_ELEMENT_INST_U32(VIRT_ROUTER_0_3, 0x00, 0, 4),
 	MLXSW_AFK_ELEMENT_INST_BUF(DST_IP_32_63, 0x04, 4),
 };
 
 static struct mlxsw_afk_element_inst mlxsw_sp_afk_element_info_ipv6_1[] = {
+	MLXSW_AFK_ELEMENT_INST_U32(VIRT_ROUTER_4_7, 0x00, 0, 4),
 	MLXSW_AFK_ELEMENT_INST_BUF(DST_IP_64_95, 0x04, 4),
 };
 
 static struct mlxsw_afk_element_inst mlxsw_sp_afk_element_info_ipv6_2[] = {
+	MLXSW_AFK_ELEMENT_INST_EXT_U32(VIRT_ROUTER_MSB, 0x00, 0, 3, 0, true),
 	MLXSW_AFK_ELEMENT_INST_BUF(DST_IP_96_127, 0x04, 4),
 };
 
@@ -326,6 +329,7 @@ static struct mlxsw_afk_element_inst mlxsw_sp_afk_element_info_ipv4_5b[] = {
 };
 
 static struct mlxsw_afk_element_inst mlxsw_sp_afk_element_info_ipv6_2b[] = {
+	MLXSW_AFK_ELEMENT_INST_U32(VIRT_ROUTER_MSB, 0x00, 0, 4),
 	MLXSW_AFK_ELEMENT_INST_BUF(DST_IP_96_127, 0x04, 4),
 };
 
-- 
2.43.0



