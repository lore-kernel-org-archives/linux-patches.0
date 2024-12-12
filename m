Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A17A21578F;
	Thu, 12 Dec 2024 15:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015814; cv=none; b=KkYJWJr+X4K3Je85PbtO7VY3o+gQjlzxAdMFUEEM0gKpWCU3lT4cpOmBOe0lLVxS/uzyLislrcJv98BPZJNWbqYuyRdxtkLeB6ViFPdPQzLMsV8gX/f+dRzXhNz8hlGf1V45ub9cKukb0JmbAa1AJFcUV77cqZSj+yDoZr4Cxhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015814; c=relaxed/simple;
	bh=SULujkEgOR+FBF5hPK19HgI8YS9RsTy/MCWNiVw965k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wo7Jpqyc1y6l4pbOf/1SKyGkQz1IOhoUOOiPCx2M9Oh/UyxfxtcZQqPDlC1Dy379oaep7xE6O/I4BMnee8zNnspvcQBcw/+IHiCStODnLHjUU9eHVJf3z2sEY5N5A9qepnR0B1Jd1Gvw8HZuHD35io1VOiT3SRKFGoeEA3CN+3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cTAcswmO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cTAcswmO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB025C4CECE;
	Thu, 12 Dec 2024 15:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015814;
	bh=SULujkEgOR+FBF5hPK19HgI8YS9RsTy/MCWNiVw965k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cTAcswmOhzUTPMIQsSvjJ8R9+9NP7khH2BpY1qHbTNwLsqogNhomdqDP8Y8NkHAS7
	 zHt8QBl7TtVrCLqoAt5VFyIUc+POo2uCrQVxJu7QMr8v1cF6HQZImm5RDdLnNOaUxK
	 YM4q1E1HxkfKvFGwhzVQCcRaCSydYwBacunKcr5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 052/466] mlxsw: spectrum_acl_flex_keys: Use correct key block on Spectrum-4
Date: Thu, 12 Dec 2024 15:53:41 +0100
Message-ID: <20241212144308.865931257@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



