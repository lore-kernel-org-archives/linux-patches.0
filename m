Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA06D156F57;
	Tue,  9 Jul 2024 11:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524169; cv=none; b=dc6Z8TrxEQe1wlyvIUYF+F70iFV0RkjQUbrJC0Bop9acCWNGFs3hTSc64cMiZIpsjDnVzX/87eKYHP4GHpdSddxIFbD1qs4BM+Yr+l7STWpJwmq3zQaaYtgmT408l8hjhMELKma+uOragPWFTQAEGk+xOjsDKugoyHNu7bwD+OA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524169; c=relaxed/simple;
	bh=JJAuP4J9iaVc/jwhlrIlWLGeXmhCEP7BqdLjaeCySLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eAH0rTPoa/ysvexRJVIn5rTqo9wO3+NjnOyU37ryHhhJsBPdaR2lgFj6L6XlKcgniGo6W02PVTIhw5KxmVOOVK8dTaYmoHSSCLTyROgIg/w5H3JBw0ajmWYMSf7GT1EklRjYec8REbPcJxQejw7+wpeURmKK5VktC7xcUrkwZd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PKaWp5gg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PKaWp5gg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 345E6C3277B;
	Tue,  9 Jul 2024 11:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524169;
	bh=JJAuP4J9iaVc/jwhlrIlWLGeXmhCEP7BqdLjaeCySLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PKaWp5ggcIOJNzoTvQxGgN6zg5ccSyibd9pSFbZxGI71Jw7rFl0sqwBFnAKVNY9uc
	 IBeEd7UXInW5ApVa7Q0y5/npbfvDwtf2rhMtKkB6uX9Er7EfDLFp32Dj/4nu1A7OXI
	 27RM1y21G8xoiz44R4RAj1EeVP16Xt1+HAyRCrj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 092/197] net/mlx5e: Present succeeded IPsec SA bytes and packet
Date: Tue,  9 Jul 2024 13:09:06 +0200
Message-ID: <20240709110712.525007696@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 2d9dac5559f8cc4318e6b0d3c5b71984f462620b ]

IPsec SA statistics presents successfully decrypted and encrypted
packet and bytes, and not total handled by this SA. So update the
calculation logic to take into account failures.

Fixes: 6fb7f9408779 ("net/mlx5e: Connect mlx5 IPsec statistics with XFRM core")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 36 ++++++++++++-------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index c54fd01ea635a..2a10428d820ae 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -989,6 +989,10 @@ static void mlx5e_xfrm_update_stats(struct xfrm_state *x)
 	struct mlx5e_ipsec_sa_entry *sa_entry = to_ipsec_sa_entry(x);
 	struct mlx5e_ipsec_rule *ipsec_rule = &sa_entry->ipsec_rule;
 	struct net *net = dev_net(x->xso.dev);
+	u64 trailer_packets = 0, trailer_bytes = 0;
+	u64 replay_packets = 0, replay_bytes = 0;
+	u64 auth_packets = 0, auth_bytes = 0;
+	u64 success_packets, success_bytes;
 	u64 packets, bytes, lastuse;
 
 	lockdep_assert(lockdep_is_held(&x->lock) ||
@@ -999,26 +1003,32 @@ static void mlx5e_xfrm_update_stats(struct xfrm_state *x)
 		return;
 
 	if (sa_entry->attrs.dir == XFRM_DEV_OFFLOAD_IN) {
-		mlx5_fc_query_cached(ipsec_rule->auth.fc, &bytes, &packets, &lastuse);
-		x->stats.integrity_failed += packets;
-		XFRM_ADD_STATS(net, LINUX_MIB_XFRMINSTATEPROTOERROR, packets);
-
-		mlx5_fc_query_cached(ipsec_rule->trailer.fc, &bytes, &packets, &lastuse);
-		XFRM_ADD_STATS(net, LINUX_MIB_XFRMINHDRERROR, packets);
+		mlx5_fc_query_cached(ipsec_rule->auth.fc, &auth_bytes,
+				     &auth_packets, &lastuse);
+		x->stats.integrity_failed += auth_packets;
+		XFRM_ADD_STATS(net, LINUX_MIB_XFRMINSTATEPROTOERROR, auth_packets);
+
+		mlx5_fc_query_cached(ipsec_rule->trailer.fc, &trailer_bytes,
+				     &trailer_packets, &lastuse);
+		XFRM_ADD_STATS(net, LINUX_MIB_XFRMINHDRERROR, trailer_packets);
 	}
 
 	if (x->xso.type != XFRM_DEV_OFFLOAD_PACKET)
 		return;
 
-	mlx5_fc_query_cached(ipsec_rule->fc, &bytes, &packets, &lastuse);
-	x->curlft.packets += packets;
-	x->curlft.bytes += bytes;
-
 	if (sa_entry->attrs.dir == XFRM_DEV_OFFLOAD_IN) {
-		mlx5_fc_query_cached(ipsec_rule->replay.fc, &bytes, &packets, &lastuse);
-		x->stats.replay += packets;
-		XFRM_ADD_STATS(net, LINUX_MIB_XFRMINSTATESEQERROR, packets);
+		mlx5_fc_query_cached(ipsec_rule->replay.fc, &replay_bytes,
+				     &replay_packets, &lastuse);
+		x->stats.replay += replay_packets;
+		XFRM_ADD_STATS(net, LINUX_MIB_XFRMINSTATESEQERROR, replay_packets);
 	}
+
+	mlx5_fc_query_cached(ipsec_rule->fc, &bytes, &packets, &lastuse);
+	success_packets = packets - auth_packets - trailer_packets - replay_packets;
+	x->curlft.packets += success_packets;
+
+	success_bytes = bytes - auth_bytes - trailer_bytes - replay_bytes;
+	x->curlft.bytes += success_bytes;
 }
 
 static int mlx5e_xfrm_validate_policy(struct mlx5_core_dev *mdev,
-- 
2.43.0



