Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C8C111B0
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m7yzrvs1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF4B4C433C7;
	Mon, 23 Oct 2023 11:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059369;
	bh=okdxfI3kEEIJ6J+OzEc9tLfONuc6jEpUgdaCVYzDJ/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m7yzrvs1teceCBr5aFibXoYGLhl0GS2eAUbOpWtuNti9miXge7grwE1/wsjaslbra
	 uopDPoqemeq/+2z+kU84CtlvceDRFD/u9lhqC9pl03tYTXytV6ncbEkDQkF2kNl5Bg
	 Qv/YNNarzv7Inkp0mHBFFQxRuSppwTT9wvzM5hok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianbo Liu <jianbol@nvidia.com>,
	Ariel Levkovich <lariel@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 155/241] net/mlx5e: Dont offload internal port if filter device is out device
Date: Mon, 23 Oct 2023 12:55:41 +0200
Message-ID: <20231023104837.650911621@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianbo Liu <jianbol@nvidia.com>

[ Upstream commit 06b4eac9c4beda520b8a4dbbb8e33dba9d1c8fba ]

In the cited commit, if the routing device is ovs internal port, the
out device is set to uplink, and packets go out after encapsulation.

If filter device is uplink, it can trigger the following syndrome:
mlx5_core 0000:08:00.0: mlx5_cmd_out_err:803:(pid 3966): SET_FLOW_TABLE_ENTRY(0x936) op_mod(0x0) failed, status bad parameter(0x3), syndrome (0xcdb051), err(-22)

Fix this issue by not offloading internal port if filter device is out
device. In this case, packets are not forwarded to the root table to
be processed, the termination table is used instead to forward them
from uplink to uplink.

Fixes: 100ad4e2d758 ("net/mlx5e: Offload internal port as encap route device")
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Ariel Levkovich <lariel@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
index 1730f6a716eea..b10e40e1a9c14 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
@@ -24,7 +24,8 @@ static int mlx5e_set_int_port_tunnel(struct mlx5e_priv *priv,
 
 	route_dev = dev_get_by_index(dev_net(e->out_dev), e->route_dev_ifindex);
 
-	if (!route_dev || !netif_is_ovs_master(route_dev))
+	if (!route_dev || !netif_is_ovs_master(route_dev) ||
+	    attr->parse_attr->filter_dev == e->out_dev)
 		goto out;
 
 	err = mlx5e_set_fwd_to_int_port_actions(priv, attr, e->route_dev_ifindex,
-- 
2.40.1



