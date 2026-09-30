Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6756B2E2286;
	Wed, 30 Sep 2026 16:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785189; cv=none; b=lnbp6JrPl9djF3fCWZBViifd6V6Lod520HeRXT5TU00S5KrfJBNdFLUim8tqcwOqNX3Y5iTq24EOfh6LcOerJFoAwA7xhwFN4XP+XBGgR3FRyBAgB9c7x/H1cWJhu3FYsoLum6otLkeV03DI2e0qZF5MgprWD9WdUo4fXjGp3bE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785189; c=relaxed/simple;
	bh=qDL47Rx7d439CNGzP8Mx1P5K39wQ16q/Cj1BXeq7VKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ReIXCSiMmJ66VJ6a9De9BKFfwIiBgCbl+Mhm17gCHIlwQNV1Z47wCXtcBNZ5s/0BJAFwMkTmIvfL5VRBpzulfROMP3EzWQk0+ie/eh47XhRhzsRvK+IHfrR5wmiNYxlepVuG1s6y6UX66myOioknSkNCAj684ffY9i3+CcraaJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=apYSVjrW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="apYSVjrW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F3991F00898;
	Wed, 30 Sep 2026 16:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785183;
	bh=eaN1P63geaaz+Og9T12If73XD6Y2BbgwrBG4+fdYWPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=apYSVjrWNKQ78FrIwKLkEC3f5coBDB9Sfyyp/NLtYWToX8EMPQ9Tp6SNGlN9qogOn
	 Sd11jyxlJg0hMggrBODOem1dBVSUYz541A3DOa81vjJXUKftEZREMs/quG1j5/LooH
	 fXIFZNHgOKpbXiPX8Gltx8+pVWjeFfeF5BGlLpLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carolina Jubran <cjubran@nvidia.com>,
	Alex Lazar <alazar@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 419/982] net/mlx5e: Fix ETS zero BW reporting when one TC holds 100%
Date: Wed, 30 Sep 2026 17:19:15 +0200
Message-ID: <20260930152425.801865950@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1a73fa436a136..4b331069fbcfe 100644
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



