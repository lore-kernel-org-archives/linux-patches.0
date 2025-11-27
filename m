Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1003E27F18B;
	Thu, 27 Nov 2025 14:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764254949; cv=none; b=EnL2CeSfDLTt+/6tNyH0cWyxQQmlDNF2v2d8Yeev4HexPS9cktlkNeDio0zgu1I/eAHfmW16Hsd6u311fBlP/0hb4ET5OCmq2EqGXHrm/3AdUpaKV9UPNjX9GU/8N1R+BWKA/uQcZQFFUCaGyooq5CN2FQ+ZD0mnchpAEmAA0RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764254949; c=relaxed/simple;
	bh=fmC3U9LGnWn+uMCAT+/NEDdpngdoksLFKXgCTX2usx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XpSsgJ0FNtW4T88VZvVWnw/A++2AZypBRCxLqsMxirArRk6By1kSmi51javE9TajmlSgjAuX51M8wpfubd78iA9zShCHSoss1KeMKdj8d4F0jLDbvhaHn/uECq22294s1HdZfnRn/UjJFTcETH+7IBOsCRWVGYUqiJ1awmwWFg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q3DXYDa2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q3DXYDa2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9231EC116C6;
	Thu, 27 Nov 2025 14:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764254948;
	bh=fmC3U9LGnWn+uMCAT+/NEDdpngdoksLFKXgCTX2usx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q3DXYDa2rh5nhO0X9KsxOzgx73SEP3RsXsHWF/OgFtgwwAGniIxEKCF6PV2/zJV0a
	 wG392qhBJerFurYr6VK81Vig4VRiuBVfW5JMq/rENGVsL0527p90SRqMf5LOiiGCv7
	 MhZzzGwMm3f9gGv7mBM1i788+qUCo5Aps4NqeZp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 41/86] mlxsw: spectrum: Fix memory leak in mlxsw_sp_flower_stats()
Date: Thu, 27 Nov 2025 15:45:57 +0100
Message-ID: <20251127144029.330185627@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144027.800761504@linuxfoundation.org>
References: <20251127144027.800761504@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 407a06507c2358554958e8164dc97176feddcafc ]

The function mlxsw_sp_flower_stats() calls mlxsw_sp_acl_ruleset_get() to
obtain a ruleset reference. If the subsequent call to
mlxsw_sp_acl_rule_lookup() fails to find a rule, the function returns
an error without releasing the ruleset reference, causing a memory leak.

Fix this by using a goto to the existing error handling label, which
calls mlxsw_sp_acl_ruleset_put() to properly release the reference.

Fixes: 7c1b8eb175b69 ("mlxsw: spectrum: Add support for TC flower offload statistics")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20251112052114.1591695-1-zilin@seu.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index 9fd1ca0792584..fba545938fd7d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -816,8 +816,10 @@ int mlxsw_sp_flower_stats(struct mlxsw_sp *mlxsw_sp,
 		return -EINVAL;
 
 	rule = mlxsw_sp_acl_rule_lookup(mlxsw_sp, ruleset, f->cookie);
-	if (!rule)
-		return -EINVAL;
+	if (!rule) {
+		err = -EINVAL;
+		goto err_rule_get_stats;
+	}
 
 	err = mlxsw_sp_acl_rule_get_stats(mlxsw_sp, rule, &packets, &bytes,
 					  &drops, &lastuse, &used_hw_stats);
-- 
2.51.0



