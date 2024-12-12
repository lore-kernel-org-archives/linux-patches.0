Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08DF123D41A;
	Thu, 12 Dec 2024 16:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020737; cv=none; b=as01wOxw/wkDuFj305dggjuZ1qOTtMuk3Dnf4YT6Orae2OAO1UbhW7X4pv2vH4boYDJI+lpIUQRBkxcxYEdjQZHe46R7lexPb7w+rWikJhzD62G4elhh2BFoVhjeMqV1JbkYpF7mTiGTBhrpL99vCVKUWz3eHPqou7E7nvQKyOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020737; c=relaxed/simple;
	bh=NTK+L0x+I9OCyi80mXYsNqKY4qokrPT+JRMzR4bkfUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=axz7Z9w87ygGWSkqbIx+jJElXge477dFN59Y1BHR/b4uvCIzKMbPBWNxueEy+Qqa1x2M/ycVLghpF0QbOvSsyK+Io4B4N+ueg3KVhyqvF9Ov749fhZ+jO4aUZjyhqncq7PKtGnqFxlX6CoFd7YjhudHa6p7nrF2sCMgTepCrKes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yh+qECbB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yh+qECbB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69602C4CECE;
	Thu, 12 Dec 2024 16:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020736;
	bh=NTK+L0x+I9OCyi80mXYsNqKY4qokrPT+JRMzR4bkfUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yh+qECbB9DKCm/DMJnxxP472ABJG5TVT1+UembO8phhTnB/0klFxaaQEBQwFBfd1J
	 ZLEDwEJA93HBIiRE52TIsro5tf9Fr/ZbFuNz1bCg+HOUbQqI+LqWNn1wg7LnLyocHC
	 1MwFniB1TcDbS6vd8dryXxQapPLgur5VOm1Gu9uc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianbo Liu <jianbol@nvidia.com>,
	Frode Nordahl <frode.nordahl@canonical.com>,
	Chris Mi <cmi@nvidia.com>,
	Ariel Levkovich <lariel@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 546/772] net/mlx5e: Remove workaround to avoid syndrome for internal port
Date: Thu, 12 Dec 2024 15:58:11 +0100
Message-ID: <20241212144412.528824712@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianbo Liu <jianbol@nvidia.com>

[ Upstream commit 5085f861b414e4a51ce28a891dfa32a10a54b64e ]

Previously a workaround was added to avoid syndrome 0xcdb051. It is
triggered when offload a rule with tunnel encapsulation, and
forwarding to another table, but not matching on the internal port in
firmware steering mode. The original workaround skips internal tunnel
port logic, which is not correct as not all cases are considered. As
an example, if vlan is configured on the uplink port, traffic can't
pass because vlan header is not added with this workaround. Besides,
there is no such issue for software steering. So, this patch removes
that, and returns error directly if trying to offload such rule for
firmware steering.

Fixes: 06b4eac9c4be ("net/mlx5e: Don't offload internal port if filter device is out device")
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Tested-by: Frode Nordahl <frode.nordahl@canonical.com>
Reviewed-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Ariel Levkovich <lariel@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20241203204920.232744-7-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.c   | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
index 907ad6ffe7275..407556334495d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
@@ -4,6 +4,7 @@
 #include <net/fib_notifier.h>
 #include <net/nexthop.h>
 #include "tc_tun_encap.h"
+#include "fs_core.h"
 #include "en_tc.h"
 #include "tc_tun.h"
 #include "rep/tc.h"
@@ -23,10 +24,18 @@ static int mlx5e_set_int_port_tunnel(struct mlx5e_priv *priv,
 
 	route_dev = dev_get_by_index(dev_net(e->out_dev), e->route_dev_ifindex);
 
-	if (!route_dev || !netif_is_ovs_master(route_dev) ||
-	    attr->parse_attr->filter_dev == e->out_dev)
+	if (!route_dev || !netif_is_ovs_master(route_dev))
 		goto out;
 
+	if (priv->mdev->priv.steering->mode == MLX5_FLOW_STEERING_MODE_DMFS &&
+	    mlx5e_eswitch_uplink_rep(attr->parse_attr->filter_dev) &&
+	    (attr->esw_attr->dests[out_index].flags & MLX5_ESW_DEST_ENCAP)) {
+		mlx5_core_warn(priv->mdev,
+			       "Matching on external port with encap + fwd to table actions is not allowed for firmware steering\n");
+		err = -EINVAL;
+		goto out;
+	}
+
 	err = mlx5e_set_fwd_to_int_port_actions(priv, attr, e->route_dev_ifindex,
 						MLX5E_TC_INT_PORT_EGRESS,
 						&attr->action, out_index);
-- 
2.43.0



