Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9C859B67F;
	Thu, 17 Sep 2026 15:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659574; cv=none; b=ahpgY6PXiXfGmUca+vS4SSTs6VM3FDDeA/+L9UiPwq8rLKrOmVJtXe3aHGJw6+DlRbv76jnHAM4LrMrfIpO4ac8GTxwatA3o/HWScf7Qa8E0FG4lf79lZxMYbRpx9BLYmYNpgFA2Z97swieGqfDhpFgyCjE1mXehS4732jd9MjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659574; c=relaxed/simple;
	bh=u1hi2qkw0gb24SwNmeRgBLOtaGWSWybFoUOCy787rn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H80wuG1Z/ukOUsbjO+8GOnYfvRZIxVvKeynuauQP6EdOz0VaeWgbl6uaAHWzSsjCLXn/n6n8i+gCVHKpNeTpCjhANhePugP0tWXbS2gA7ERnapJdhkKILAd41ctSNQrovpKo7TT8gAs7lYXp+RqJxUb1qkfCXJ/pKvxjcq0uQHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LrefmtU7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LrefmtU7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A39BE1F000FF;
	Thu, 17 Sep 2026 15:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659565;
	bh=9J1oiLH6+wkiIlm2wuYJJF/GbqxPb/SoXyHMN+3eR7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LrefmtU7egurGvNs/36EGfCNUOiU9Z5KrqkasGBZAawFqPg+XcS1QbwCHFi4v0trm
	 sTqyMYpRmyKxFhvqtpIWZt9fuTnWjtPp8CYX8VkxGl6YGRoRxEOI57XsYzd0caFfs6
	 CbRNJiB1765WEZkpodp8nD7sQN+GgOe6k/SwwsQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carolina Jubran <cjubran@nvidia.com>,
	Alex Lazar <alazar@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 300/733] net/mlx5e: Fix ETS zero BW reporting when one TC holds 100%
Date: Thu, 17 Sep 2026 16:10:08 +0100
Message-ID: <20260917151358.911725211@linuxfoundation.org>
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

From: Carolina Jubran <cjubran@nvidia.com>

[ Upstream commit e7ee89740800a1cf253713e9249c3ee9203ebe91 ]

When ETS TCs with zero bandwidth are configured, the driver programs the
firmware using an alternate representation. On get, it needs
to recognize that representation so those TCs can be translated back and
reported as 0% bandwidth.

The existing detection relied on the programmed bandwidth because it was
enough to identify this representation. However, when a single ETS TC
owns 100% of the bandwidth, its firmware representation becomes the
same as a strict-priority TC, causing zero-bandwidth ETS TCs to be
reported with non-zero bandwidth values.

Use the cached TSA instead to distinguish the ETS and strict-priority
cases.

Fixes: be0f161ef141 ("net/mlx5e: DCBNL, Implement tc with ets type and zero bandwidth")
Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Alex Lazar <alazar@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260902193224.3668743-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
index 00e706e1ede11..741f75b5bfec5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
@@ -148,7 +148,7 @@ static int mlx5e_dcbnl_ieee_getets(struct net_device *netdev,
 		if (err)
 			return err;
 
-		if (ets->tc_tx_bw[i] < MLX5E_MAX_BW_ALLOC &&
+		if (priv->dcbx.tc_tsa[i] == IEEE_8021QAZ_TSA_ETS &&
 		    tc_group[i] == (MLX5E_LOWEST_PRIO_GROUP + 1))
 			is_zero_bw_ets_tc = true;
 
-- 
2.53.0



