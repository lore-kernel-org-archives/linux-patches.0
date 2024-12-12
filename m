Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185926F2FE;
	Thu, 12 Dec 2024 15:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017741; cv=none; b=RIHuTcus5SAWdinMyqishOMgTZJBxvR16cAtUTV0eGjjRwIuKQdsijHB/o+0jKIGdN6cWevCgpD282ea6MSWMtj+6bWb/vrAoGoGQh0J+JaGXStObsVHNXqB7IV8pV7/zY6G5WJiAx+sOh5+8dotluV+7TGcNqM3ILydQUriPtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017741; c=relaxed/simple;
	bh=NecZ8Z4sk3TZJTIVipycj77hzLn4fpYufS3zwkGri3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VT93aBp4RJz9utdRiy8DCiS155528wS0aciccH6GKQVW0zrXNl7Be1ioKvI6LTMWVEP/xCoNxpW1GgXGewufRM1viGf9tpj14lraK8TDNE1fOib+eycClVWAt8GS0nTqvfMCBMv1/6GsJj76LtTKrAbxv4AyxDUjTH5ozpCxkOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jliIZMC0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jliIZMC0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75F27C4CECE;
	Thu, 12 Dec 2024 15:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017740;
	bh=NecZ8Z4sk3TZJTIVipycj77hzLn4fpYufS3zwkGri3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jliIZMC0CgE5gWyBVikjXJex/b6QREeyqe2LPI518PLIPCwBzyYAoOhkNuHXg7lVY
	 ovKERrGF0x/jUxtKQxkFBqKkG+qaTabIg+MK0waw+vnSyR7wqotzFM506tx6OJTe1G
	 dG355mgzlCtVh5zkg0ldjnLXHHhYFhIyL2ny5Ni4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 059/356] mlxsw: spectrum_acl_flex_keys: Use correct key block on Spectrum-4
Date: Thu, 12 Dec 2024 15:56:18 +0100
Message-ID: <20241212144246.967728398@linuxfoundation.org>
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

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 217bbf156f93ada86b91617489e7ba8a0904233c ]

The driver is currently using an ACL key block that is not supported by
Spectrum-4. This works because the driver is only using a single field
from this key block which is located in the same offset in the
equivalent Spectrum-4 key block.

The issue was discovered when the firmware started rejecting the use of
the unsupported key block. The change has been reverted to avoid
breaking users that only update their firmware.

Nonetheless, fix the issue by using the correct key block.

Fixes: 07ff135958dd ("mlxsw: Introduce flex key elements for Spectrum-4")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Link: https://patch.msgid.link/35e72c97bdd3bc414fb8e4d747e5fb5d26c29658.1733237440.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlxsw/spectrum_acl_flex_keys.c    | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_keys.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_keys.c
index 6fe185ea6732c..1850a975b3804 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_keys.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_keys.c
@@ -324,6 +324,10 @@ static const struct mlxsw_afk_element_inst mlxsw_sp_afk_element_info_mac_5b[] =
 	MLXSW_AFK_ELEMENT_INST_EXT_U32(SRC_SYS_PORT, 0x04, 0, 9, -1, true), /* RX_ACL_SYSTEM_PORT */
 };
 
+static const struct mlxsw_afk_element_inst mlxsw_sp_afk_element_info_ipv4_1b[] = {
+	MLXSW_AFK_ELEMENT_INST_BUF(SRC_IP_0_31, 0x04, 4),
+};
+
 static const struct mlxsw_afk_element_inst mlxsw_sp_afk_element_info_ipv4_5b[] = {
 	MLXSW_AFK_ELEMENT_INST_U32(VIRT_ROUTER, 0x04, 20, 12),
 };
@@ -341,7 +345,7 @@ static const struct mlxsw_afk_block mlxsw_sp4_afk_blocks[] = {
 	MLXSW_AFK_BLOCK(0x14, mlxsw_sp_afk_element_info_mac_4),
 	MLXSW_AFK_BLOCK_HIGH_ENTROPY(0x1A, mlxsw_sp_afk_element_info_mac_5b),
 	MLXSW_AFK_BLOCK_HIGH_ENTROPY(0x38, mlxsw_sp_afk_element_info_ipv4_0),
-	MLXSW_AFK_BLOCK_HIGH_ENTROPY(0x39, mlxsw_sp_afk_element_info_ipv4_1),
+	MLXSW_AFK_BLOCK_HIGH_ENTROPY(0x3F, mlxsw_sp_afk_element_info_ipv4_1b),
 	MLXSW_AFK_BLOCK(0x3A, mlxsw_sp_afk_element_info_ipv4_2),
 	MLXSW_AFK_BLOCK(0x36, mlxsw_sp_afk_element_info_ipv4_5b),
 	MLXSW_AFK_BLOCK(0x40, mlxsw_sp_afk_element_info_ipv6_0),
-- 
2.43.0



