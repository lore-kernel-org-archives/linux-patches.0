Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 984571C68C;
	Sun,  1 Sep 2024 16:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209389; cv=none; b=NCWrUJERnDnAwa37P7I8siarFS6uWYFT+f9Wk1A7+ygClYbW5Ej9iemOX9kSWkARLJSOpAwLyTWML6PA/ueD6gnRFH5MwjpZgDMnZIkfcE78Rpm7/LJhI23XuEMz6zQYDnDb5gVU1TFffNpSzbC2Gt4LW9vigeKg+aAYW0b9JYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209389; c=relaxed/simple;
	bh=Q9RelQjZrPM9YMK6SKdx+f3hvobWO3Gj1OWN8lSG91A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HWdcttPSmmrKHwkgJ12U0RQ8lDuS5gBuo0w+Lmvs+L/h43+WswKtJoukXYSoodec5zDq6e9mZU7gd4HxeegGbGrbimCAhrunqN4mW6fEKTcaDZba7V7JUTNU3RY6QQxDE3STsFZ+ycj0z1P3PRqxhp4q9a5edLh2E3n/lPUOZqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zK+Ug8+N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zK+Ug8+N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AA44C4CEC4;
	Sun,  1 Sep 2024 16:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209389;
	bh=Q9RelQjZrPM9YMK6SKdx+f3hvobWO3Gj1OWN8lSG91A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zK+Ug8+NMf2oTNXZTAl9DCe1A9kvckPP2TFUtKKoDI9VpqGhbrFk3ujVoGh+BT9E4
	 s6VsfDKH94aYKKwG9Bqy4J/Ak3BpcrYE4Xv9YDJXc6NDSJGIhVnJIfjffFxBqKcpiU
	 gatyetK8yLeK/t1IB42ffFnIQ+97dMIgy7cpmImg=
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
Subject: [PATCH 5.10 020/151] net/mlx5e: Correctly report errors for ethtool rx flows
Date: Sun,  1 Sep 2024 18:16:20 +0200
Message-ID: <20240901160814.861003130@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b416a8ee2eed2..26631bca5ab85 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
@@ -679,7 +679,7 @@ mlx5e_ethtool_flow_replace(struct mlx5e_priv *priv,
 	if (num_tuples <= 0) {
 		netdev_warn(priv->netdev, "%s: flow is not valid %d\n",
 			    __func__, num_tuples);
-		return num_tuples;
+		return num_tuples < 0 ? num_tuples : -EINVAL;
 	}
 
 	eth_ft = get_flow_table(priv, fs, num_tuples);
-- 
2.43.0



