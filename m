Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D141815AE3
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:45:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55337C433C8;
	Wed,  9 Aug 2023 10:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691577945;
	bh=ivblmI/dG2shNsK7wnarMREE5p73W9rb76OjDb+1kNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K9zfLK6tvNLaBj0mOAGsEo3wP97zeyDX+7HBZiSpsASbwpWHChohZJd3XYqcRqJKg
	 WrIJfBKGncee26WUSkReUokye22j/ntO4XlsBEVX3IFgcRHvZtmfX/ZPRgGrXbO+1i
	 PFkkTYI9t9XNCbwycFzrMKdcW85Vf1wA9hl/WKao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mi <cmi@nvidia.com>,
	Vlad Buslov <vladbu@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 033/165] net/mlx5e: Dont hold encap tbl lock if there is no encap action
Date: Wed,  9 Aug 2023 12:39:24 +0200
Message-ID: <20230809103643.899295366@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.720851262@linuxfoundation.org>
References: <20230809103642.720851262@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chris Mi <cmi@nvidia.com>

[ Upstream commit 93a331939d1d1c6c3422bc09ec43cac658594b34 ]

The cited commit holds encap tbl lock unconditionally when setting
up dests. But it may cause the following deadlock:

 PID: 1063722  TASK: ffffa062ca5d0000  CPU: 13   COMMAND: "handler8"
  #0 [ffffb14de05b7368] __schedule at ffffffffa1d5aa91
  #1 [ffffb14de05b7410] schedule at ffffffffa1d5afdb
  #2 [ffffb14de05b7430] schedule_preempt_disabled at ffffffffa1d5b528
  #3 [ffffb14de05b7440] __mutex_lock at ffffffffa1d5d6cb
  #4 [ffffb14de05b74e8] mutex_lock_nested at ffffffffa1d5ddeb
  #5 [ffffb14de05b74f8] mlx5e_tc_tun_encap_dests_set at ffffffffc12f2096 [mlx5_core]
  #6 [ffffb14de05b7568] post_process_attr at ffffffffc12d9fc5 [mlx5_core]
  #7 [ffffb14de05b75a0] mlx5e_tc_add_fdb_flow at ffffffffc12de877 [mlx5_core]
  #8 [ffffb14de05b75f0] __mlx5e_add_fdb_flow at ffffffffc12e0eef [mlx5_core]
  #9 [ffffb14de05b7660] mlx5e_tc_add_flow at ffffffffc12e12f7 [mlx5_core]
 #10 [ffffb14de05b76b8] mlx5e_configure_flower at ffffffffc12e1686 [mlx5_core]
 #11 [ffffb14de05b7720] mlx5e_rep_indr_offload at ffffffffc12e3817 [mlx5_core]
 #12 [ffffb14de05b7730] mlx5e_rep_indr_setup_tc_cb at ffffffffc12e388a [mlx5_core]
 #13 [ffffb14de05b7740] tc_setup_cb_add at ffffffffa1ab2ba8
 #14 [ffffb14de05b77a0] fl_hw_replace_filter at ffffffffc0bdec2f [cls_flower]
 #15 [ffffb14de05b7868] fl_change at ffffffffc0be6caa [cls_flower]
 #16 [ffffb14de05b7908] tc_new_tfilter at ffffffffa1ab71f0

[1031218.028143]  wait_for_completion+0x24/0x30
[1031218.028589]  mlx5e_update_route_decap_flows+0x9a/0x1e0 [mlx5_core]
[1031218.029256]  mlx5e_tc_fib_event_work+0x1ad/0x300 [mlx5_core]
[1031218.029885]  process_one_work+0x24e/0x510

Actually no need to hold encap tbl lock if there is no encap action.
Fix it by checking if encap action exists or not before holding
encap tbl lock.

Fixes: 37c3b9fa7ccf ("net/mlx5e: Prevent encap offload when neigh update is running")
Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/en/tc_tun_encap.c      |  3 ---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 21 ++++++++++++++++---
 2 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
index f0c3464f037f4..0c88cf47af01b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
@@ -1030,9 +1030,6 @@ int mlx5e_tc_tun_encap_dests_set(struct mlx5e_priv *priv,
 	int out_index;
 	int err = 0;
 
-	if (!mlx5e_is_eswitch_flow(flow))
-		return 0;
-
 	parse_attr = attr->parse_attr;
 	esw_attr = attr->esw_attr;
 	*vf_tun = false;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index ed05ac8ae1de5..e002f013fa015 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1725,6 +1725,19 @@ verify_attr_actions(u32 actions, struct netlink_ext_ack *extack)
 	return 0;
 }
 
+static bool
+has_encap_dests(struct mlx5_flow_attr *attr)
+{
+	struct mlx5_esw_flow_attr *esw_attr = attr->esw_attr;
+	int out_index;
+
+	for (out_index = 0; out_index < MLX5_MAX_FLOW_FWD_VPORTS; out_index++)
+		if (esw_attr->dests[out_index].flags & MLX5_ESW_DEST_ENCAP)
+			return true;
+
+	return false;
+}
+
 static int
 post_process_attr(struct mlx5e_tc_flow *flow,
 		  struct mlx5_flow_attr *attr,
@@ -1737,9 +1750,11 @@ post_process_attr(struct mlx5e_tc_flow *flow,
 	if (err)
 		goto err_out;
 
-	err = mlx5e_tc_tun_encap_dests_set(flow->priv, flow, attr, extack, &vf_tun);
-	if (err)
-		goto err_out;
+	if (mlx5e_is_eswitch_flow(flow) && has_encap_dests(attr)) {
+		err = mlx5e_tc_tun_encap_dests_set(flow->priv, flow, attr, extack, &vf_tun);
+		if (err)
+			goto err_out;
+	}
 
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR) {
 		err = mlx5e_tc_attach_mod_hdr(flow->priv, flow, attr);
-- 
2.40.1



