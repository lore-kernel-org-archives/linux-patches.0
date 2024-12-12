Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C06FA212F9E;
	Thu, 12 Dec 2024 15:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017598; cv=none; b=Hu1OVPHcE3YRBC/EJTJfCA1Ft6sdM6+VeslLeiE/1qlrjCsYyvqGZT0B9e3s6GuVkig+BY3xAa5xJC/VU1SjEvX4WSb/3tNTGLHY1YaZMEuDGEiMY3+4e5NuzMV7ygLuchYonXqgK9P4QiYJdWStOpU8Vc/bM6lJPyj+DoRpihM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017598; c=relaxed/simple;
	bh=efHjuzkxLyk+a6++07Z7WgBMLwtd2XnhNIi8vas7mX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=De3t4hD9jMFA8SbsEWoF7/32BixgxYHzwyTABsnsLHbJQPnz4G/OGva4LomFRhXt9mevGUo9vOY5FR3dJa1Z9rEuLi6sb/+w08UL6QtP0lexK012xyWjv3LEqO8KSS5gVqGQfY8gwm+zEAO8m4r6+27rx+IjN0BK0mvF8GS7v84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=17tXQUiV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="17tXQUiV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48DAEC4CECE;
	Thu, 12 Dec 2024 15:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017598;
	bh=efHjuzkxLyk+a6++07Z7WgBMLwtd2XnhNIi8vas7mX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=17tXQUiVaZ80qW+BnrG5j/u/nbLvhVDryJyRFYgvwvufnnSpb4XBhntuHT853GW6H
	 BPDfUv43e78E32GNQzALgg/jOyO8+dyKLjODq80IGFF3A4qmVp70GkgKDBKeuHnGBQ
	 3hV7gVudynHddEs7e33JdYnviatf8s23hRsMlQjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Cohen <amcohen@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 057/356] mlxsw: Mark high entropy key blocks
Date: Thu, 12 Dec 2024 15:56:16 +0100
Message-ID: <20241212144246.883236644@linuxfoundation.org>
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

[ Upstream commit cad6431b867507779c41b00baaf18382467ef0a0 ]

For 12 key blocks in the A-TCAM, rules are split into two records, which
constitute two lookups. The two records are linked using a
"large entry key ID".

Due to a Spectrum-4 hardware issue, KVD entries that correspond to key
blocks 0 to 5 of 12 key blocks A-TCAM entries will be placed in the same
KVD pipe if they only differ in their "large entry key ID", as it is
ignored. This results in a reduced scale. To reduce the probability of this
issue, we can place key blocks with high entropy in blocks 0 to 5. The idea
is to place blocks that are changed often in blocks 0 to 5, for
example, key blocks that match on IPv4 addresses or the LSBs of IPv6
addresses. Such placement will reduce the probability of these blocks to be
same.

Mark several blocks with 'high_entropy' flag, so later we will take into
account this flag and place them in blocks 0 to 5.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 217bbf156f93 ("mlxsw: spectrum_acl_flex_keys: Use correct key block on Spectrum-4")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlxsw/core_acl_flex_keys.h |  9 +++++++++
 .../ethernet/mellanox/mlxsw/spectrum_acl_flex_keys.c | 12 ++++++------
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.h b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.h
index 1c76aa3ffab72..98a05598178b3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.h
@@ -119,6 +119,7 @@ struct mlxsw_afk_block {
 	u16 encoding; /* block ID */
 	struct mlxsw_afk_element_inst *instances;
 	unsigned int instances_count;
+	bool high_entropy;
 };
 
 #define MLXSW_AFK_BLOCK(_encoding, _instances)					\
@@ -128,6 +129,14 @@ struct mlxsw_afk_block {
 		.instances_count = ARRAY_SIZE(_instances),			\
 	}
 
+#define MLXSW_AFK_BLOCK_HIGH_ENTROPY(_encoding, _instances)			\
+	{									\
+		.encoding = _encoding,						\
+		.instances = _instances,					\
+		.instances_count = ARRAY_SIZE(_instances),			\
+		.high_entropy = true,						\
+	}
+
 struct mlxsw_afk_element_usage {
 	DECLARE_BITMAP(usage, MLXSW_AFK_ELEMENT_MAX);
 };
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_keys.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_keys.c
index 4b3564f5fd652..eaad786056027 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_keys.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_keys.c
@@ -334,14 +334,14 @@ static struct mlxsw_afk_element_inst mlxsw_sp_afk_element_info_ipv6_2b[] = {
 };
 
 static const struct mlxsw_afk_block mlxsw_sp4_afk_blocks[] = {
-	MLXSW_AFK_BLOCK(0x10, mlxsw_sp_afk_element_info_mac_0),
-	MLXSW_AFK_BLOCK(0x11, mlxsw_sp_afk_element_info_mac_1),
+	MLXSW_AFK_BLOCK_HIGH_ENTROPY(0x10, mlxsw_sp_afk_element_info_mac_0),
+	MLXSW_AFK_BLOCK_HIGH_ENTROPY(0x11, mlxsw_sp_afk_element_info_mac_1),
 	MLXSW_AFK_BLOCK(0x12, mlxsw_sp_afk_element_info_mac_2),
 	MLXSW_AFK_BLOCK(0x13, mlxsw_sp_afk_element_info_mac_3),
 	MLXSW_AFK_BLOCK(0x14, mlxsw_sp_afk_element_info_mac_4),
-	MLXSW_AFK_BLOCK(0x1A, mlxsw_sp_afk_element_info_mac_5b),
-	MLXSW_AFK_BLOCK(0x38, mlxsw_sp_afk_element_info_ipv4_0),
-	MLXSW_AFK_BLOCK(0x39, mlxsw_sp_afk_element_info_ipv4_1),
+	MLXSW_AFK_BLOCK_HIGH_ENTROPY(0x1A, mlxsw_sp_afk_element_info_mac_5b),
+	MLXSW_AFK_BLOCK_HIGH_ENTROPY(0x38, mlxsw_sp_afk_element_info_ipv4_0),
+	MLXSW_AFK_BLOCK_HIGH_ENTROPY(0x39, mlxsw_sp_afk_element_info_ipv4_1),
 	MLXSW_AFK_BLOCK(0x3A, mlxsw_sp_afk_element_info_ipv4_2),
 	MLXSW_AFK_BLOCK(0x36, mlxsw_sp_afk_element_info_ipv4_5b),
 	MLXSW_AFK_BLOCK(0x40, mlxsw_sp_afk_element_info_ipv6_0),
@@ -350,7 +350,7 @@ static const struct mlxsw_afk_block mlxsw_sp4_afk_blocks[] = {
 	MLXSW_AFK_BLOCK(0x43, mlxsw_sp_afk_element_info_ipv6_3),
 	MLXSW_AFK_BLOCK(0x44, mlxsw_sp_afk_element_info_ipv6_4),
 	MLXSW_AFK_BLOCK(0x45, mlxsw_sp_afk_element_info_ipv6_5),
-	MLXSW_AFK_BLOCK(0x90, mlxsw_sp_afk_element_info_l4_0),
+	MLXSW_AFK_BLOCK_HIGH_ENTROPY(0x90, mlxsw_sp_afk_element_info_l4_0),
 	MLXSW_AFK_BLOCK(0x92, mlxsw_sp_afk_element_info_l4_2),
 };
 
-- 
2.43.0



