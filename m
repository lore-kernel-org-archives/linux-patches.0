Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 198E24973A7;
	Thu, 17 Sep 2026 15:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659561; cv=none; b=qZivYk1xcUkBo1VAn9ZrSD4EirDPOxemXiKzrpWhgb8Vk3SJBtseobTOyp849il93aj4zxERjNwaAmDar4+rqyN9K3sScr2SBytQkte0i9pRcmBPbpyY3QiX8nQE77jPKUiAIVPi37pXAxn5EVjLe+6YpFl703olXfP57eKk+o4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659561; c=relaxed/simple;
	bh=wNyEQF++BFC5EbOWXymFLKjhT34EKyNj21DogP/Laz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FdDf13xoKnio6Fp5CDhlsO87DfO67OclR19T8fuHhzKe9b2/EAFvp5a7g8Kal/ck6G+giyyAitoIL4UUh30eoSUPzgjD1bTj9nei4fwQN/juEVbW9iHBZN5yAzz5jwnY9gWxqo3kisRvle8hKa4ycR2YSNNUGcy359OvACgLxzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hkSi30ys; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hkSi30ys"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00EAB1F000FF;
	Thu, 17 Sep 2026 15:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659552;
	bh=ZM2h1YRY3XPzhzhoq+rMQkjt18aV3QHL3a+MCFTjEns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hkSi30ysG7vmnxg9MXlg0vf4fo/kkuvN7tZ0YiLnc4pvKdkSvZUtyawmFLZQ9AdfX
	 hF0/3eskxOVUhGag98NmpF6Flr69qRD/Y9NzAX5h+Syh9vhNk7LuZXt5XPv/HfP+E/
	 9ECzgTTF3iWlg2LKwljMJ2MbjCYE1JGojYs6FAAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shahar Shitrit <shshitrit@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Yael Chemla <ychemla@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 296/733] net/mlx5e: Fix missing FEC mode mapping for RS_544_514_INTERLEAVED_QUAD
Date: Thu, 17 Sep 2026 16:10:04 +0100
Message-ID: <20260917151358.798505294@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shahar Shitrit <shshitrit@nvidia.com>

[ Upstream commit 802eedcc0b25bb3e1b492f0600ab74325274d53b ]

MLX5E_FEC_RS_544_514_INTERLEAVED_QUAD is missing from
pplm_fec_2_ethtool_linkmodes[], leaving index 4 zero-initialized.
As a result, when this FEC mode is active, find_first_bit() returns
index 4, causing __set_bit() to set bit 0
(ETHTOOL_LINK_MODE_10baseT_Half_BIT) instead of
ETHTOOL_LINK_MODE_FEC_RS_BIT. Consequently, ethtool reports:

  Advertised FEC modes: Not reported

Add the missing mapping to ETHTOOL_LINK_MODE_FEC_RS_BIT.

Fixes: 4e343c11efbb ("net/mlx5e: Support FEC settings for 200G per lane link modes")
Signed-off-by: Shahar Shitrit <shshitrit@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Yael Chemla <ychemla@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260902164634.3657606-2-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 112926d07634d..f285ad88b6d5a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1013,6 +1013,7 @@ static const u32 pplm_fec_2_ethtool_linkmodes[] = {
 	[MLX5E_FEC_NOFEC] = ETHTOOL_LINK_MODE_FEC_NONE_BIT,
 	[MLX5E_FEC_FIRECODE] = ETHTOOL_LINK_MODE_FEC_BASER_BIT,
 	[MLX5E_FEC_RS_528_514] = ETHTOOL_LINK_MODE_FEC_RS_BIT,
+	[MLX5E_FEC_RS_544_514_INTERLEAVED_QUAD] = ETHTOOL_LINK_MODE_FEC_RS_BIT,
 	[MLX5E_FEC_RS_544_514] = ETHTOOL_LINK_MODE_FEC_RS_BIT,
 	[MLX5E_FEC_LLRS_272_257_1] = ETHTOOL_LINK_MODE_FEC_LLRS_BIT,
 };
-- 
2.53.0



