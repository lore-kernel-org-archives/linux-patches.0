Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4420721578B;
	Thu, 12 Dec 2024 15:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017672; cv=none; b=El8APwlfEPAISL4pfwTQlLQmoMZVx4MkTWgfRE/SqqT1O+agTB1V25eyt6n2swAYpFuM/XyF+fzEDGztNjP9lEa3NfvVh4/3MhVP4BRfSnJ8euItjnsh6YRLGR+FYTqzXhekfvX1UC4fK5eU3tDTw6PxGpWKmRsP4thHdioS27g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017672; c=relaxed/simple;
	bh=HRSPRAqiHwoWeecGuYvTcvTcpq60yzEcRZ3VCQayDfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ephk1qLWfOW1fVlN1IS1ixrhQqJ4aV+ZKZP9agnETy0H86dO3+UE+AmdYy3zQPHxkT7NxuMQ4OA2/KvIZ8gDUOlC3O65j7ggmrWOuQY4PL5VyK0X/Oq8KfoMH4e6SDpRGmIuL5vJuVzXd6nyp4+XsmMq3FG8ZX2RDitLL3C1uvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c6b2U52D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c6b2U52D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3668C4CECE;
	Thu, 12 Dec 2024 15:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017672;
	bh=HRSPRAqiHwoWeecGuYvTcvTcpq60yzEcRZ3VCQayDfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c6b2U52DAODvKLg4I5pkXnopfW9dKi6Bo9tDFJut044Mgn8vxfxIAIxOofKhJXDqd
	 rSWrI3ijb5yU3O6DPJ6tFMlK89DAPXI1ogP88RqB6UaPsYze72oOxMbiB3kdunEhWg
	 /cigx+aAi4bqzIBWDPhZOML69J65eQTcHWpZODio=
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
Subject: [PATCH 6.6 061/356] net/mlx5e: Remove workaround to avoid syndrome for internal port
Date: Thu, 12 Dec 2024 15:56:20 +0100
Message-ID: <20241212144247.043848575@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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
index f1d1e1542e81b..c11092da2e7d8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
@@ -5,6 +5,7 @@
 #include <net/nexthop.h>
 #include <net/ip_tunnels.h>
 #include "tc_tun_encap.h"
+#include "fs_core.h"
 #include "en_tc.h"
 #include "tc_tun.h"
 #include "rep/tc.h"
@@ -24,10 +25,18 @@ static int mlx5e_set_int_port_tunnel(struct mlx5e_priv *priv,
 
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



