Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DDE511C98
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:30:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3F04C433C7;
	Mon, 28 Aug 2023 10:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218651;
	bh=/tNGFyZ+8SH7lxhffrv8FXWaKQ/0/zkWwmMPkpzlpjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EuvyKX0MiNXqCOqJQ0reTakeVzuvN8XstcCymlRe/vgQov42wnIKmS0L2uPuZ5E08
	 eyLPhgTRt3Re/S+7BCldO8ZCfkzWOfZZ8FWVij4EkLGkSbIMaAVMeFTMOvxcehRG4R
	 czxouRVaEda2vwvrHvSJy+BJjeWc4LJy3ZDnF+Qg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Cohen <amcohen@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 035/122] mlxsw: Fix the size of VIRT_ROUTER_MSB
Date: Mon, 28 Aug 2023 12:12:30 +0200
Message-ID: <20230828101157.578723441@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101156.480754469@linuxfoundation.org>
References: <20230828101156.480754469@linuxfoundation.org>
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

From: Amit Cohen <amcohen@nvidia.com>

[ Upstream commit 348c976be0a599918b88729def198a843701c9fe ]

The field 'virtual router' was extended to 12 bits in Spectrum-4.
Therefore, the element 'MLXSW_AFK_ELEMENT_VIRT_ROUTER_MSB' needs 3 bits for
Spectrum < 4 and 4 bits for Spectrum >= 4.

The elements are stored in an internal storage scratchpad. Currently, the
MSB is defined there as 3 bits. It means that for Spectrum-4, only 2K VRFs
can be used for multicast routing, as the highest bit is not really used by
the driver. Fix the definition of 'VIRT_ROUTER_MSB' to use 4 bits. Adjust
the definitions of 'virtual router' field in the blocks accordingly - use
'_avoid_size_check' for Spectrum-2 instead of for Spectrum-4. Fix the mask
in parse function to use 4 bits.

Fixes: 6d5d8ebb881c ("mlxsw: Rename virtual router flex key element")
Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/79bed2b70f6b9ed58d4df02e9798a23da648015b.1692268427.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.c     | 4 ++--
 drivers/net/ethernet/mellanox/mlxsw/spectrum2_mr_tcam.c      | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_keys.c | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.c b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.c
index bd1a51a0a5408..f208a237d0b52 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.c
@@ -32,8 +32,8 @@ static const struct mlxsw_afk_element_info mlxsw_afk_element_infos[] = {
 	MLXSW_AFK_ELEMENT_INFO_U32(IP_TTL_, 0x18, 0, 8),
 	MLXSW_AFK_ELEMENT_INFO_U32(IP_ECN, 0x18, 9, 2),
 	MLXSW_AFK_ELEMENT_INFO_U32(IP_DSCP, 0x18, 11, 6),
-	MLXSW_AFK_ELEMENT_INFO_U32(VIRT_ROUTER_MSB, 0x18, 17, 3),
-	MLXSW_AFK_ELEMENT_INFO_U32(VIRT_ROUTER_LSB, 0x18, 20, 8),
+	MLXSW_AFK_ELEMENT_INFO_U32(VIRT_ROUTER_MSB, 0x18, 17, 4),
+	MLXSW_AFK_ELEMENT_INFO_U32(VIRT_ROUTER_LSB, 0x18, 21, 8),
 	MLXSW_AFK_ELEMENT_INFO_BUF(SRC_IP_96_127, 0x20, 4),
 	MLXSW_AFK_ELEMENT_INFO_BUF(SRC_IP_64_95, 0x24, 4),
 	MLXSW_AFK_ELEMENT_INFO_BUF(SRC_IP_32_63, 0x28, 4),
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum2_mr_tcam.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum2_mr_tcam.c
index e4f4cded2b6f9..b1178b7a7f51a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum2_mr_tcam.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum2_mr_tcam.c
@@ -193,7 +193,7 @@ mlxsw_sp2_mr_tcam_rule_parse(struct mlxsw_sp_acl_rule *rule,
 				       key->vrid, GENMASK(7, 0));
 	mlxsw_sp_acl_rulei_keymask_u32(rulei,
 				       MLXSW_AFK_ELEMENT_VIRT_ROUTER_MSB,
-				       key->vrid >> 8, GENMASK(2, 0));
+				       key->vrid >> 8, GENMASK(3, 0));
 	switch (key->proto) {
 	case MLXSW_SP_L3_PROTO_IPV4:
 		return mlxsw_sp2_mr_tcam_rule_parse4(rulei, key);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_keys.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_keys.c
index 00c32320f8915..173808c096bab 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_keys.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_keys.c
@@ -169,7 +169,7 @@ static struct mlxsw_afk_element_inst mlxsw_sp_afk_element_info_ipv4_2[] = {
 
 static struct mlxsw_afk_element_inst mlxsw_sp_afk_element_info_ipv4_4[] = {
 	MLXSW_AFK_ELEMENT_INST_U32(VIRT_ROUTER_LSB, 0x04, 24, 8),
-	MLXSW_AFK_ELEMENT_INST_U32(VIRT_ROUTER_MSB, 0x00, 0, 3),
+	MLXSW_AFK_ELEMENT_INST_EXT_U32(VIRT_ROUTER_MSB, 0x00, 0, 3, 0, true),
 };
 
 static struct mlxsw_afk_element_inst mlxsw_sp_afk_element_info_ipv6_0[] = {
@@ -319,7 +319,7 @@ static struct mlxsw_afk_element_inst mlxsw_sp_afk_element_info_mac_5b[] = {
 
 static struct mlxsw_afk_element_inst mlxsw_sp_afk_element_info_ipv4_4b[] = {
 	MLXSW_AFK_ELEMENT_INST_U32(VIRT_ROUTER_LSB, 0x04, 13, 8),
-	MLXSW_AFK_ELEMENT_INST_EXT_U32(VIRT_ROUTER_MSB, 0x04, 21, 4, 0, true),
+	MLXSW_AFK_ELEMENT_INST_U32(VIRT_ROUTER_MSB, 0x04, 21, 4),
 };
 
 static struct mlxsw_afk_element_inst mlxsw_sp_afk_element_info_ipv6_2b[] = {
-- 
2.40.1



