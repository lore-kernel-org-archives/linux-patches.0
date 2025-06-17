Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD95C2F2379;
	Tue, 17 Jun 2025 15:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175439; cv=none; b=MgoU7HLwcPqqBNVzdIp84XZOlTsJx1D5JiNpmzAvE5ICGCUdenL4OocW8/jELiQdgzvp/OXlp2Rt4uUuiCrXeTqAW2mykzXJjVkcVNQYxCDLybet8TiDbsAJ5GOKE1Y2BGaQz9SFdoTNAOSSpMmRzZE+/+ZBqEr5Z6KUHrYLmOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175439; c=relaxed/simple;
	bh=0S6QYNyCJrWYRcDnXFDqiOWFkSFnv/LftaX60DIzMVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PEau8yedkUVJDf7asZDblImchXmWDFUDTKb8poEeEVcYfXulZi/hYRzmVLqj/ccfDMCJ5r8llYceqjeFXNN/+wv8LyyrrUJi4i5w/l4Opa9C1rxkefPWI4tJiOe6dPLogQssSLTvJWVDhxgiJbsd4/ctaIyZhL872PtmJhqHeRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zSVsyc9N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zSVsyc9N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE502C4CEE3;
	Tue, 17 Jun 2025 15:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175438;
	bh=0S6QYNyCJrWYRcDnXFDqiOWFkSFnv/LftaX60DIzMVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zSVsyc9Nuv++yei8xS3hEb4FtAtP5taPdnWfarMe5zvnI+WYNll6yGIqORb1ljW4j
	 X2aUVIXxHAfOX2y9+eUHb+I6nhsvjkJVXF73NnOJVeDu1/bwrdqzACeUBe7Mv58doF
	 O37YrkjTSqn3PiSROMV084/yqjSxgsGQagoxnhlg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 126/512] xfrm: Use xdo.dev instead of xdo.real_dev
Date: Tue, 17 Jun 2025 17:21:32 +0200
Message-ID: <20250617152424.696299116@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cosmin Ratiu <cratiu@nvidia.com>

[ Upstream commit 25ac138f58e7d5c8bffa31e8891418d2819180c4 ]

The policy offload struct was reused from the state offload and
real_dev was copied from dev, but it was never set to anything else.
Simplify the code by always using xdo.dev for policies.

Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c | 2 +-
 net/xfrm/xfrm_device.c                                   | 2 --
 net/xfrm/xfrm_state.c                                    | 2 --
 3 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 94edfd7713b5d..39dcbf863421a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -1135,7 +1135,7 @@ mlx5e_ipsec_build_accel_pol_attrs(struct mlx5e_ipsec_pol_entry *pol_entry,
 static int mlx5e_xfrm_add_policy(struct xfrm_policy *x,
 				 struct netlink_ext_ack *extack)
 {
-	struct net_device *netdev = x->xdo.real_dev;
+	struct net_device *netdev = x->xdo.dev;
 	struct mlx5e_ipsec_pol_entry *pol_entry;
 	struct mlx5e_priv *priv;
 	int err;
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index b33c4591e09a4..32ad8f3fc81e8 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -373,7 +373,6 @@ int xfrm_dev_policy_add(struct net *net, struct xfrm_policy *xp,
 
 	xdo->dev = dev;
 	netdev_tracker_alloc(dev, &xdo->dev_tracker, GFP_ATOMIC);
-	xdo->real_dev = dev;
 	xdo->type = XFRM_DEV_OFFLOAD_PACKET;
 	switch (dir) {
 	case XFRM_POLICY_IN:
@@ -395,7 +394,6 @@ int xfrm_dev_policy_add(struct net *net, struct xfrm_policy *xp,
 	err = dev->xfrmdev_ops->xdo_dev_policy_add(xp, extack);
 	if (err) {
 		xdo->dev = NULL;
-		xdo->real_dev = NULL;
 		xdo->type = XFRM_DEV_OFFLOAD_UNSPECIFIED;
 		xdo->dir = 0;
 		netdev_put(dev, &xdo->dev_tracker);
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index abd725386cb60..7a298058fc16c 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1487,7 +1487,6 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
 			xso->type = XFRM_DEV_OFFLOAD_PACKET;
 			xso->dir = xdo->dir;
 			xso->dev = xdo->dev;
-			xso->real_dev = xdo->real_dev;
 			xso->flags = XFRM_DEV_OFFLOAD_FLAG_ACQ;
 			netdev_hold(xso->dev, &xso->dev_tracker, GFP_ATOMIC);
 			error = xso->dev->xfrmdev_ops->xdo_dev_state_add(x, NULL);
@@ -1495,7 +1494,6 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
 				xso->dir = 0;
 				netdev_put(xso->dev, &xso->dev_tracker);
 				xso->dev = NULL;
-				xso->real_dev = NULL;
 				xso->type = XFRM_DEV_OFFLOAD_UNSPECIFIED;
 				x->km.state = XFRM_STATE_DEAD;
 				to_put = x;
-- 
2.39.5



