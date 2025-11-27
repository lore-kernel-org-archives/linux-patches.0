Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06489335BB6;
	Thu, 27 Nov 2025 14:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255304; cv=none; b=qhlQpZ5iIaQQmChFlh/8wkr3obPdCe+8oyI5R4S5qDbZNyhA/45KDK+GfkZYPK6tu6ZCz8MNNLCiZ8md/3D2as61SUizeELC9KY4T4ID+I4Tf8MKrCNU7OTgXqwlf1e7kcenAEFTWSv8wwPYOE196/Uodxz3VW9/dKEiBlRWSUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255304; c=relaxed/simple;
	bh=DHUVtSgufpZNH0z4mW/APF6GyH3APSTWFbvC1Cror44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BGn/DM6eNx8B7l/PlVgQEDm0rKGzXoss1NQgPnhFlYGglzorkvQrMWSrmlCMJnh9l5MP47DvvXIP/NeUgn3A1DuXbdIx9ExHlLWfkzonS81hBT9VGqZcHRBImlWWu91+7U/wXuaeEPeOuVfVIhG2mqdiRu7n31Ist0XZTfiADko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NhS7rGbA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NhS7rGbA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F65C116C6;
	Thu, 27 Nov 2025 14:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255303;
	bh=DHUVtSgufpZNH0z4mW/APF6GyH3APSTWFbvC1Cror44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NhS7rGbAaShFyu+MIJAkRP5iWe2wzAOmDl6xPX6sMOR8EW9zfDWvhgBkkTLopMIwN
	 kMqSLD9kVt8Zvk/8HPjn40uFoZd9RRrUzzSi1Q/RaCAMDfiWmzxctdDdR0h5vpzrJP
	 Q6Otp5YSj3Fsfm6jzAeKnGEbLtPPR4hekTJqO8gE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 061/112] mlxsw: spectrum: Fix memory leak in mlxsw_sp_flower_stats()
Date: Thu, 27 Nov 2025 15:46:03 +0100
Message-ID: <20251127144035.072647725@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f07955b5439f6..a8d4cf8b92998 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -820,8 +820,10 @@ int mlxsw_sp_flower_stats(struct mlxsw_sp *mlxsw_sp,
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



