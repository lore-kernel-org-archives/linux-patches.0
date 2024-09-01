Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D1861C68C;
	Sun,  1 Sep 2024 16:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209904; cv=none; b=GMqfE3d+3ITVgTVP6XE2fCe26ZLgVRt85qSqnEjFnHN8FCG5kN797/oYFV1SHLzf72TacgABkLjB5kfcy800xn72CahDa4AOqXqr+qLm5GyzuE8bwcbhZh8cmXrtHQ0zKN3sPY5w0pPKO8YfIrKz1fIR8fNtgOHfbhJutmMubgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209904; c=relaxed/simple;
	bh=MvkK4OA59InBw6fNIXHenAz0nA79uIqku/A/I6wsjbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a6cXpm9H7W/T+4CngcW+kSHS6uxXg7qBhxtgJR6J2sZj0OO+x80OqMjyKdErpTHKNWLKvIXWHSenampX+5lmzrDxKE4FkyVQ7f6Dxrt4At1zN6C9/p+s+N2PstjoFNy1Pw6XIuafDUGKbbs5qqaMWAmHivvbVxFPa8I68HRQMp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qqwzua5v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qqwzua5v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EE42C4CEC3;
	Sun,  1 Sep 2024 16:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209904;
	bh=MvkK4OA59InBw6fNIXHenAz0nA79uIqku/A/I6wsjbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qqwzua5vFc1KMs6b85cG5Jr84cW51kfjlweCj8EzuhoL8uKoWlnRPwCwP43QVBAT7
	 0Du6M1USaouZFMRKbILV8mB9Sz72u+2NU5XB9EAxKitpNSHLxjvif7iRJp5RuA4Ric
	 DnvzYWR4OIpETeOFn/U8lYN6LNBLZOD3CfCCpbY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 028/215] net/mlx5e: Correctly report errors for ethtool rx flows
Date: Sun,  1 Sep 2024 18:15:40 +0200
Message-ID: <20240901160824.326649039@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cosmin Ratiu <cratiu@nvidia.com>

[ Upstream commit cbc796be1779c4dbc9a482c7233995e2a8b6bfb3 ]

Previously, an ethtool rx flow with no attrs would not be added to the
NIC as it has no rules to configure the hw with, but it would be
reported as successful to the caller (return code 0). This is confusing
for the user as ethtool then reports "Added rule $num", but no rule was
actually added.

This change corrects that by instead reporting these wrong rules as
-EINVAL.

Fixes: b29c61dac3a2 ("net/mlx5e: Ethtool steering flow validation refactoring")
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20240808144107.2095424-5-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
index d32b70c62c949..32212bc41df30 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
@@ -727,7 +727,7 @@ mlx5e_ethtool_flow_replace(struct mlx5e_priv *priv,
 	if (num_tuples <= 0) {
 		netdev_warn(priv->netdev, "%s: flow is not valid %d\n",
 			    __func__, num_tuples);
-		return num_tuples;
+		return num_tuples < 0 ? num_tuples : -EINVAL;
 	}
 
 	eth_ft = get_flow_table(priv, fs, num_tuples);
-- 
2.43.0



