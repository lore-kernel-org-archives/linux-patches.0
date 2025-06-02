Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49E622A80F;
	Mon,  2 Jun 2025 14:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874831; cv=none; b=OsHsoggUoojLa8hiIe3fjQW0AJ/gBmvci1zDMiv+OlYN1OyG6VVIIlmP8TTxcOHxHzl3NVPkrlOzgHI7rJgYCGMtnvNNsOf97BKAxo5WW4Ah/Kn4zdVIab1WTiLkwJgWf12guevK97J/lN2PNssR06fi9xJODyt3xzZlq8Nzd4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874831; c=relaxed/simple;
	bh=WePdrfWOR/qalEZlePtkgZ4aVYD8Dt9aKOWQu9l+odU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nzukXJeRkHwQn3aRnEeMG2glyi9cd9A6devjSw/DvmW++xis6AUOtSN/v1qsAB2i1683fn+O7Tcj3maVfOYpsJjbJdjNg8/5KPapsvGNs8of60vsMUoJMuUBuqTt+QlC20BA+I3bSu52dKHifO9Ep/wbT3rdfjWaO+su+04nzM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ID05kyYZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ID05kyYZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 541CFC4CEEB;
	Mon,  2 Jun 2025 14:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874830;
	bh=WePdrfWOR/qalEZlePtkgZ4aVYD8Dt9aKOWQu9l+odU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ID05kyYZlxkK3fz04qflCyufQNsM0baZHLeWwF7VDTZcxerNqf9/cGq4AjIk0yiDl
	 wwqo8p7X+19q5VwQSePuD7Wf57YRRYpskm1f+83g+Zy9OnwUC1lo1iAVL44DdLfZ/P
	 G6d5B/IzZec56Wc3Vuzxcaw4I20moJ/Er+6+o5QM=
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
Subject: [PATCH 5.4 150/204] net/mlx5e: set the tx_queue_len for pfifo_fast
Date: Mon,  2 Jun 2025 15:48:03 +0200
Message-ID: <20250602134301.544590005@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index a40fecfdb10ca..26a9d38d1e2a7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1470,6 +1470,8 @@ static void mlx5e_build_rep_netdev(struct net_device *netdev)
 	}
 
 	netdev->watchdog_timeo    = 15 * HZ;
+	if (mlx5_core_is_ecpf(mdev))
+		netdev->tx_queue_len = 1 << MLX5E_REP_PARAMS_DEF_LOG_SQ_SIZE;
 
 	netdev->features       |= NETIF_F_NETNS_LOCAL;
 
-- 
2.39.5



