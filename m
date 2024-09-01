Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7B0C537FF;
	Sun,  1 Sep 2024 16:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208712; cv=none; b=OpXVaJDBXsckAzkM8z7jNVKGJqnI99xD2Ovh8K+JbTFz9yE23CrpmkwvXaN9rHxeOnyNFfnDJ8mZ4ildoLHR59k7fv3TJiayCO83WZAgUKKDcrN6rWq5PG+xjYiMA5xZScDKEJnaQ6gpMdlmllQDMu5lJMmpMviJIPQuiOIX/OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208712; c=relaxed/simple;
	bh=lG6ss0CzmteKPFkHD7emFMPv7cEsT5tGWdZ4QUhBOq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y6J959v31ojG4l+2ZxTQ3KFEHGTeQrFx2xXoXV8vFwTRXP/ZQwm3uWCC4KxdDEqFKaoOAiuja3u5PAWHJiRpjpph1OXH9KacAh7NSc6RxGQSeQmEa4w7FIc4NsoW3rjRCSQgZPdpLhhjN7wvb7LCo1hjWCjTUCb8Voy3SLsIZGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QI96op4a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QI96op4a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4745FC4CEC3;
	Sun,  1 Sep 2024 16:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208712;
	bh=lG6ss0CzmteKPFkHD7emFMPv7cEsT5tGWdZ4QUhBOq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QI96op4aLjVsP7oDCrE8XQEUX6KuCaJm9o/rGlWGHFOs++7frdrHXxorDNkHHtjdK
	 VKkB+il5kMJGvwI8UwGNAxtFaKPmm1HfluQPi86GfyRn7PN9plTTIc/mTkEMhSqyUv
	 DCtZ688Nhm0SZp+qQhG6WYb1gBkpjAtO4e0pYtPI=
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
Subject: [PATCH 5.4 017/134] net/mlx5e: Correctly report errors for ethtool rx flows
Date: Sun,  1 Sep 2024 18:16:03 +0200
Message-ID: <20240901160810.760013902@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index acd946f2ddbe7..be49a2a53f29d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
@@ -676,7 +676,7 @@ mlx5e_ethtool_flow_replace(struct mlx5e_priv *priv,
 	if (num_tuples <= 0) {
 		netdev_warn(priv->netdev, "%s: flow is not valid %d\n",
 			    __func__, num_tuples);
-		return num_tuples;
+		return num_tuples < 0 ? num_tuples : -EINVAL;
 	}
 
 	eth_ft = get_flow_table(priv, fs, num_tuples);
-- 
2.43.0



