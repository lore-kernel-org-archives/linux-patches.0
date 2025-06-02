Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71ED022AE65;
	Mon,  2 Jun 2025 14:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873788; cv=none; b=Zd+Ht4IQW2ThQ40V4500N356NAAs16gPpTYg5JryhS4SWKhG6nitqqr1zLT/csMzdI62EtJhESDg3Hel7v70U60CxnJvltBHvFOMfLcsMNc8auC34/OwqokKf5E8HfcyXE0ISpW9JbjkBP9grkkdaaeoH7MSG7iALW7LTsRGEd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873788; c=relaxed/simple;
	bh=F3cL4W+ukXSIlmqB9V5rF3USqiCemeOw9JTs2f8paAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rrF+Vng2giNIIie0IuE5y/nqD6tf3+z5CIOfjZgUKukS0i81CphRqFSoa6vSszjMcGp6WEapbnHQ34krIIUb1Jp/ryQufn9UEJZ3rXQ4Mb45arYSFMLDu2JY+DsQVvR4r3QiuHlQLZhbZaYW0hYhzaI5Em4d2RNgLa05dC5TmwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZIrtv1+O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZIrtv1+O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 022E5C4CEF0;
	Mon,  2 Jun 2025 14:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873788;
	bh=F3cL4W+ukXSIlmqB9V5rF3USqiCemeOw9JTs2f8paAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZIrtv1+O5zbu0bBtFTKnLWCq4D+5J+j11noj7tUOB6oClQumfUa5FcGOmX/YAwpHX
	 NFUSMV8MShtUuJQY7QD5/mB5aofgSlWY5kDsDqE5cej2SJwbu49A+PYWsp34HMmKpF
	 1+kRR4ethSEtNBhYt/4fLHq6W91wl89yzgM910GM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Tu <witu@nvidia.com>,
	Daniel Jurgens <danielj@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 253/444] net/mlx5e: set the tx_queue_len for pfifo_fast
Date: Mon,  2 Jun 2025 15:45:17 +0200
Message-ID: <20250602134351.191677804@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: William Tu <witu@nvidia.com>

[ Upstream commit a38cc5706fb9f7dc4ee3a443f61de13ce1e410ed ]

By default, the mq netdev creates a pfifo_fast qdisc. On a
system with 16 core, the pfifo_fast with 3 bands consumes
16 * 3 * 8 (size of pointer) * 1024 (default tx queue len)
= 393KB. The patch sets the tx qlen to representor default
value, 128 (1<<MLX5E_REP_PARAMS_DEF_LOG_SQ_SIZE), which
consumes 16 * 3 * 8 * 128 = 49KB, saving 344KB for each
representor at ECPF.

Signed-off-by: William Tu <witu@nvidia.com>
Reviewed-by: Daniel Jurgens <danielj@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Link: https://patch.msgid.link/20250209101716.112774-9-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 751d3ffcd2f6c..39d8e63e8856d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -829,6 +829,8 @@ static void mlx5e_build_rep_netdev(struct net_device *netdev,
 	netdev->ethtool_ops = &mlx5e_rep_ethtool_ops;
 
 	netdev->watchdog_timeo    = 15 * HZ;
+	if (mlx5_core_is_ecpf(mdev))
+		netdev->tx_queue_len = 1 << MLX5E_REP_PARAMS_DEF_LOG_SQ_SIZE;
 
 #if IS_ENABLED(CONFIG_MLX5_CLS_ACT)
 	netdev->hw_features    |= NETIF_F_HW_TC;
-- 
2.39.5



