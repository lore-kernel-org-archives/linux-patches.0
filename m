Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086B74D17B6;
	Thu, 17 Sep 2026 18:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670519; cv=none; b=DOWvYOXhKCO/y18DZQbxj3QTIZZG44SaPi0oGNlX6T8tLcu90sokdVSWH+j6x8rU4UypocPVBXb11YtdQJNro8hxtgtMs7j1PgaRgEGewvSUmcG9WugedPUksuaUSHxypPs81JH5cXntr0/wwK3bjpXaot10QQfoEcO/1yQlSRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670519; c=relaxed/simple;
	bh=kYquDGbZufFTdtvomYcWCahY6haIGTgQtJ+b4QEqZCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d98Yn5O0W2jagrL4P0JGXfpKVD1xkb0Y5aDscpbvrw706s6mHpKODtKkrdjkjiIg6ZfDXQZSigzvoSmH6YvDz3XZwAxSPWp7ambO3X+yzDgGpXm7xiMdx2iHATkAyakaSnSi4OmCutNbBG6/O2oqlpFZJfjrnRst91H7mvdlSho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A7PnV32m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A7PnV32m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 618D81F000FF;
	Thu, 17 Sep 2026 18:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670517;
	bh=CqkfN+wVN34ajex9/wRhT2cMUJ/uUyfiPRwHp4FHwhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A7PnV32mW7zpdsunBu5AT27TqKo3JKBsPQF3ycu21PcDoQgMmNTzJ8QdMXmBGMITo
	 6+RF+VkpzmoZvV6j2mU5UeOIeeIbRLdUahgXhmX/M5D8TNgoL7pEveaeQNCWYZrLON
	 WysDZDc4X6J3e3NkFNvWVquYvAr6bByraKK3Zwzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carolina Jubran <cjubran@nvidia.com>,
	Alex Lazar <alazar@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0688/1102] net/mlx5e: Fix ETS zero BW reporting when one TC holds 100%
Date: Thu, 17 Sep 2026 16:10:31 +0100
Message-ID: <20260917151557.541187312@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index 98ca8f486d52c..9fe8ea3e71cf8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
@@ -133,7 +133,7 @@ static int mlx5e_dcbnl_ieee_getets(struct net_device *netdev,
 		if (err)
 			return err;
 
-		if (ets->tc_tx_bw[i] < MLX5E_MAX_BW_ALLOC &&
+		if (priv->dcbx.tc_tsa[i] == IEEE_8021QAZ_TSA_ETS &&
 		    tc_group[i] == (MLX5E_LOWEST_PRIO_GROUP + 1))
 			is_zero_bw_ets_tc = true;
 
-- 
2.53.0



