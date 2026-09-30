Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B404E0B66;
	Wed, 30 Sep 2026 16:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786263; cv=none; b=EQwU3dKDvbpUCuC08m/oOHvdSGe1uLGI655jKwobrd7GqiA/s1KAhahIeo2Znn9jhOuLL7OPRtUcOPJWO9u/MdIofX6JzJrHkFxwHXKhEVN0T6fQMYHAHqXget98u+jzJefMmv8Pu3uxFeGlxGbChOTZjjvcOmNc4iLchuI32Bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786263; c=relaxed/simple;
	bh=ImUd1597ZSLXpUN7srvcjw5nBAbqJ5s4ZPhZ3JcQklY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dnc1i7FqLOf8JFji9UntYf4DIb4BWWQwa6eKFubFG0788lryPqxv3y/OXwWTlpgd+OaIPbWoukDXdnP/N3hTzgUEQ/BEfiGck0pbxLHGkxA8KXPeOWUMrbrdQX9R8bib8gJmf6Vkun1gcJ45clkNGafdHjD6WFa6sjg5QQC3P8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pf/veQAy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pf/veQAy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1820F1F000FF;
	Wed, 30 Sep 2026 16:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786262;
	bh=3aDfcVIARdC3iB6bOt5k8U88YyzCRzKSaRuDIOKkALo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pf/veQAyWQqizvyVxBWVgZIKrP+q5V8dCXg/x0EREDQI4jqHewS/6gn4iuwfdz+Pf
	 DU2iNc9fqSSAvZSkaWIw4AoZtfCjgD2/yhphC0medwFoM0W9WbfWWr4URcO5ZgE7jy
	 bSX1nKBlt9321uXcQRUBqnFwIeG/Y7nvJ+bfcsdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianbo Liu <jianbol@nvidia.com>,
	Vlad Buslov <vladbu@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 801/982] net/mlx5e: TC, Fix internal port memory leak
Date: Wed, 30 Sep 2026 17:25:37 +0200
Message-ID: <20260930152433.961363613@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
User-Agent: quilt/0.69
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

[ Upstream commit ac5da544a3c2047cbfd715acd9cec8380d7fe5c6 ]

The flow rule can be splited, and the extra post_act rules are added
to post_act table. It's possible to trigger memleak when the rule
forwards packets from internal port and over tunnel, in the case that,
for example, CT 'new' state offload is allowed. As int_port object is
assigned to the flow attribute of post_act rule, and its refcnt is
incremented by mlx5e_tc_int_port_get(), but mlx5e_tc_int_port_put() is
not called, the refcnt is never decremented, then int_port is never
freed.

The kmemleak reports the following error:
unreferenced object 0xffff888128204b80 (size 64):
  comm "handler20", pid 50121, jiffies 4296973009 (age 642.932s)
  hex dump (first 32 bytes):
    01 00 00 00 19 00 00 00 03 f0 00 00 04 00 00 00  ................
    98 77 67 41 81 88 ff ff 98 77 67 41 81 88 ff ff  .wgA.....wgA....
  backtrace:
    [<00000000e992680d>] kmalloc_trace+0x27/0x120
    [<000000009e945a98>] mlx5e_tc_int_port_get+0x3f3/0xe20 [mlx5_core]
    [<0000000035a537f0>] mlx5e_tc_add_fdb_flow+0x473/0xcf0 [mlx5_core]
    [<0000000070c2cec6>] __mlx5e_add_fdb_flow+0x7cf/0xe90 [mlx5_core]
    [<000000005cc84048>] mlx5e_configure_flower+0xd40/0x4c40 [mlx5_core]
    [<000000004f8a2031>] mlx5e_rep_indr_offload.isra.0+0x10e/0x1c0 [mlx5_core]
    [<000000007df797dc>] mlx5e_rep_indr_setup_tc_cb+0x90/0x130 [mlx5_core]
    [<0000000016c15cc3>] tc_setup_cb_add+0x1cf/0x410
    [<00000000a63305b4>] fl_hw_replace_filter+0x38f/0x670 [cls_flower]
    [<000000008bc9e77c>] fl_change+0x1fd5/0x4430 [cls_flower]
    [<00000000e7f766e4>] tc_new_tfilter+0x867/0x2010
    [<00000000e101c0ef>] rtnetlink_rcv_msg+0x6fc/0x9f0
    [<00000000e1111d44>] netlink_rcv_skb+0x12c/0x360
    [<0000000082dd6c8b>] netlink_unicast+0x438/0x710
    [<00000000fc568f70>] netlink_sendmsg+0x794/0xc50
    [<0000000016e92590>] sock_sendmsg+0xc5/0x190

So fix this by moving int_port cleanup code to the flow attribute
free helper, which is used by all the attribute free cases.

Fixes: 8300f225268b ("net/mlx5e: Create new flow attr for multi table actions")
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

[ Backport to 6.1.y: this tree already releases the primary flow-attribute
  references in mlx5e_tc_del_fdb_flow() and lacks
  mlx5_free_flow_attr_actions(); release only cloned post-action attribute
  references from the corresponding free_flow_post_acts() cleanup. ]
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 05888942ef276..d2f226a09a0c7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3692,6 +3692,7 @@ free_flow_post_acts(struct mlx5e_tc_flow *flow)
 {
 	struct mlx5_core_dev *counter_dev = get_flow_counter_dev(flow);
 	struct mlx5e_post_act *post_act = get_post_action(flow->priv);
+	struct mlx5_esw_flow_attr *esw_attr;
 	struct mlx5_flow_attr *attr, *tmp;
 	bool vf_tun;
 
@@ -3713,6 +3714,16 @@ free_flow_post_acts(struct mlx5e_tc_flow *flow)
 				mlx5_modify_header_dealloc(flow->priv->mdev, attr->modify_hdr);
 		}
 
+		if (mlx5e_is_eswitch_flow(flow)) {
+			esw_attr = attr->esw_attr;
+			if (esw_attr->int_port)
+				mlx5e_tc_int_port_put(mlx5e_get_int_port_priv(flow->priv),
+						      esw_attr->int_port);
+			if (esw_attr->dest_int_port)
+				mlx5e_tc_int_port_put(mlx5e_get_int_port_priv(flow->priv),
+						      esw_attr->dest_int_port);
+		}
+
 		list_del(&attr->list);
 		kvfree(attr->parse_attr);
 		kfree(attr);
-- 
2.53.0



