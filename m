Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E28C79C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:31:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA3F3C433D2;
	Thu, 12 Jan 2023 14:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533914;
	bh=AvXULct0/JkCv208GZNXEeBmUO18IY6RwhNjgt/+M38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pKXkGdemFvDY1fSbFPWEcyajSRdbicwN8qnHsSZvwESNtF4RtqBvUHrXwdYJrfAIp
	 BtrzGtudCQOoUfIgbgPMnJVyeJaKap5IDIb1qPiP/omO3TT1nwUu7BEH1Nn/OZu+9b
	 6jDk/oDsw+ZNi6CnQJlx58AzFq46H31kFs9Vksww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dima Chumak <dchumak@nvidia.com>,
	Vlad Buslov <vladbu@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Subject: [PATCH 5.10 603/783] net/mlx5e: Fix nullptr in mlx5e_tc_add_fdb_flow()
Date: Thu, 12 Jan 2023 14:55:19 +0100
Message-Id: <20230112135552.228133387@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dima Chumak <dchumak@nvidia.com>

commit fe7738eb3ca3631a75844e790f6cb576c0fe7b00 upstream.

The result of __dev_get_by_index() is not checked for NULL, which then
passed to mlx5e_attach_encap() and gets dereferenced.

Also, in case of a successful lookup, the net_device reference count is
not incremented, which may result in net_device pointer becoming invalid
at any time during mlx5e_attach_encap() execution.

Fix by using dev_get_by_index(), which does proper reference counting on
the net_device pointer. Also, handle nullptr return value when mirred
device is not found.

It's safe to call dev_put() on the mirred net_device pointer, right
after mlx5e_attach_encap() call, because it's not being saved/copied
down the call chain.

Fixes: 3c37745ec614 ("net/mlx5e: Properly deal with encap flows add/del under neigh update")
Addresses-Coverity: ("Dereference null return value")
Signed-off-by: Dima Chumak <dchumak@nvidia.com>
Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1344,9 +1344,9 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv
 		      struct netlink_ext_ack *extack)
 {
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
-	struct net_device *out_dev, *encap_dev = NULL;
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
 	struct mlx5_flow_attr *attr = flow->attr;
+	struct net_device *encap_dev = NULL;
 	struct mlx5_esw_flow_attr *esw_attr;
 	struct mlx5_fc *counter = NULL;
 	struct mlx5e_rep_priv *rpriv;
@@ -1391,16 +1391,22 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv
 	esw_attr = attr->esw_attr;
 
 	for (out_index = 0; out_index < MLX5_MAX_FLOW_FWD_VPORTS; out_index++) {
+		struct net_device *out_dev;
 		int mirred_ifindex;
 
 		if (!(esw_attr->dests[out_index].flags & MLX5_ESW_DEST_ENCAP))
 			continue;
 
 		mirred_ifindex = parse_attr->mirred_ifindex[out_index];
-		out_dev = __dev_get_by_index(dev_net(priv->netdev),
-					     mirred_ifindex);
+		out_dev = dev_get_by_index(dev_net(priv->netdev), mirred_ifindex);
+		if (!out_dev) {
+			NL_SET_ERR_MSG_MOD(extack, "Requested mirred device not found");
+			err = -ENODEV;
+			return err;
+		}
 		err = mlx5e_attach_encap(priv, flow, out_dev, out_index,
 					 extack, &encap_dev, &encap_valid);
+		dev_put(out_dev);
 		if (err)
 			return err;
 


