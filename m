Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594AB1A072D;
	Tue, 27 Aug 2024 14:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769957; cv=none; b=NSbHOff8N/l3UU2M62HrsnWGJGwHF70NHJYz2wbXCTXzUzdU89Q/Bi8eFF4WeHZsksvRlh/bPD7DdsWy4dD72td9ggb4oz9TOoVcd3oX+hlY2GyFUfvJvvwzPqhSp613JKBPE9v2BbUR7d4bv8EZhy7Y5Cf8NMCv9MPQa4go2No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769957; c=relaxed/simple;
	bh=8FcCmdyEr9Uwdq855loEsKWZzKeI6NYvuUU80pFktBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CyigqH99+VVg0TIFQUTu7XRM0KD/pJXH8bxmiYA2xQyAeo6/+D4rEi1nh2e0iIvTzczBRLIjTvJnH78PxhbG1o660W9MUgUlQ+xAbe1wJM7CiBzjkIhlc0SJ8xZLdM2e92AkPoKJAe6/OacGN5NtVJlbLBXVfDxUC7x/1ICfmrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XKOhFU9Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XKOhFU9Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC00FC61063;
	Tue, 27 Aug 2024 14:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769957;
	bh=8FcCmdyEr9Uwdq855loEsKWZzKeI6NYvuUU80pFktBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XKOhFU9ZUU5/wSHbgfmuxruYmhomjgB/MHWkHCXPVfh7MI7aD/q21f0GqksqKZgcO
	 BJDEYoE6xSbHQ5PCW+7Eh+y0cxu5mzPPZRH/kmReZCz3w44u6FVsyby6JTotsHs+y4
	 F7XUl1fjJMcqHPSX+twx4tStnmPc3BouBdLq6snk=
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
Subject: [PATCH 6.6 053/341] net/mlx5e: Correctly report errors for ethtool rx flows
Date: Tue, 27 Aug 2024 16:34:44 +0200
Message-ID: <20240827143845.436945025@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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
index 3eccdadc03578..773624bb2c5d5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
@@ -734,7 +734,7 @@ mlx5e_ethtool_flow_replace(struct mlx5e_priv *priv,
 	if (num_tuples <= 0) {
 		netdev_warn(priv->netdev, "%s: flow is not valid %d\n",
 			    __func__, num_tuples);
-		return num_tuples;
+		return num_tuples < 0 ? num_tuples : -EINVAL;
 	}
 
 	eth_ft = get_flow_table(priv, fs, num_tuples);
-- 
2.43.0



