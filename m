Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8FFF1F93D
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:09:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B1FAC433C7;
	Fri, 21 Jul 2023 16:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689955792;
	bh=BWr+YCz3f+Vvk6Ii4C2E1/6AyVPOSGvAmZJdy0YtrnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VkFElo7t4weUZKhgEwUKD5sPuR1lJT5StCa+CPxd6Hssp7mi5gr49yQXAe3DvGusD
	 GrYxEyInCs5BbK59RW7U0tvOvA7bgeXb9SsDlJkPUFbp319zlSFNU8HihqYONps9Qj
	 U0ueXFRIb62xMH4c1uMK3Xf12jPYZErjbsejGzwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Blakey <paulb@nvidia.com>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 032/292] net/mlx5e: TC, CT: Offload ct clear only once
Date: Fri, 21 Jul 2023 18:02:21 +0200
Message-ID: <20230721160530.183799778@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

[ Upstream commit f7a485115ad4cfc560833942014bf791abf1f827 ]

Non-clear CT action causes a flow rule split, while CT clear action
doesn't and is just a header-rewrite to the current flow rule.
But ct offload is done in post_parse and is per ct action instance,
so ct clear offload is parsed multiple times, while its deleted once.

Fix this by post_parsing the ct action only once per flow attribute
(which is per flow rule) by using a offloaded ct_attr flag.

Fixes: 08fe94ec5f77 ("net/mlx5e: TC, Remove special handling of CT action")
Signed-off-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 14 +++++++++++---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h |  1 +
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index a254e728ac954..fadfa8b50bebe 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -1545,7 +1545,8 @@ mlx5_tc_ct_parse_action(struct mlx5_tc_ct_priv *priv,
 
 	attr->ct_attr.ct_action |= act->ct.action; /* So we can have clear + ct */
 	attr->ct_attr.zone = act->ct.zone;
-	attr->ct_attr.nf_ft = act->ct.flow_table;
+	if (!(act->ct.action & TCA_CT_ACT_CLEAR))
+		attr->ct_attr.nf_ft = act->ct.flow_table;
 	attr->ct_attr.act_miss_cookie = act->miss_cookie;
 
 	return 0;
@@ -1990,6 +1991,9 @@ mlx5_tc_ct_flow_offload(struct mlx5_tc_ct_priv *priv, struct mlx5_flow_attr *att
 	if (!priv)
 		return -EOPNOTSUPP;
 
+	if (attr->ct_attr.offloaded)
+		return 0;
+
 	if (attr->ct_attr.ct_action & TCA_CT_ACT_CLEAR) {
 		err = mlx5_tc_ct_entry_set_registers(priv, &attr->parse_attr->mod_hdr_acts,
 						     0, 0, 0, 0);
@@ -1999,11 +2003,15 @@ mlx5_tc_ct_flow_offload(struct mlx5_tc_ct_priv *priv, struct mlx5_flow_attr *att
 		attr->action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
 	}
 
-	if (!attr->ct_attr.nf_ft) /* means only ct clear action, and not ct_clear,ct() */
+	if (!attr->ct_attr.nf_ft) { /* means only ct clear action, and not ct_clear,ct() */
+		attr->ct_attr.offloaded = true;
 		return 0;
+	}
 
 	mutex_lock(&priv->control_lock);
 	err = __mlx5_tc_ct_flow_offload(priv, attr);
+	if (!err)
+		attr->ct_attr.offloaded = true;
 	mutex_unlock(&priv->control_lock);
 
 	return err;
@@ -2021,7 +2029,7 @@ void
 mlx5_tc_ct_delete_flow(struct mlx5_tc_ct_priv *priv,
 		       struct mlx5_flow_attr *attr)
 {
-	if (!attr->ct_attr.ft) /* no ct action, return */
+	if (!attr->ct_attr.offloaded) /* no ct action, return */
 		return;
 	if (!attr->ct_attr.nf_ft) /* means only ct clear action, and not ct_clear,ct() */
 		return;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
index 8e9316fa46d4b..b66c5f98067f7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
@@ -29,6 +29,7 @@ struct mlx5_ct_attr {
 	u32 ct_labels_id;
 	u32 act_miss_mapping;
 	u64 act_miss_cookie;
+	bool offloaded;
 	struct mlx5_ct_ft *ft;
 };
 
-- 
2.39.2



