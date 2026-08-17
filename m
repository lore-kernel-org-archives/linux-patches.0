Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56FCF4B0481;
	Mon, 17 Aug 2026 14:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977849; cv=none; b=Fnl+NCapUhghR8xLV96FuqPySWh7pIng/ishzZftb9jolqTgKBRiFYVQhMnrJc2n/TIUa6S2LnLItqANmFy6DF7IKt5x7TCiNZBbFrGDSGe+n3Vc6UkE6y1CPnMuBNQyg2fUKEiIlSChjaQUf+f0YhxJAoI16TcZaGmO/OwZhFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977849; c=relaxed/simple;
	bh=EN6VIFz+Hn29+cBzP+DOc0t78IzybKSpMAO6E77hKbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mcErC9uKPX1bcg7zDwU+Jq4Alci7Xra81xE4tbMy0lo3FQi//vxPP5hT63KvzeJWOgrpNkaNjzBky/w8tggHeGCmVfLmKTLSSObTTU9EWaZYGgWifo49MbTmqAShiWhFJpBe6iJn7KphRCZX5JFT6V6lD50cFOauIjt8Kz0Ksxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y9tz3UTz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y9tz3UTz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91CB21F000E9;
	Mon, 17 Aug 2026 14:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977848;
	bh=UsZqeS/49fom/y3TAAiaFfkv7Citoj2bHAlLCCEqz1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y9tz3UTzWSzlw9Q4Li1ooaBzSRsN6CoDjtT5EELPXUbinMGwmYSBwMLWqkH+Zm/Fv
	 fqvqKoTJk3TYtoyY92RBMEkTWOIwgXI/9d8q7hpi2zF8Tfxm4doZbYDj52i6J4q+Wt
	 LkKJV71r+beR5ZUYKeSPHyqjZiZ5ktJZna07QxvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 015/181] net/mlx5e: TC, Check if flow is PEER before acquiring devcom lock
Date: Mon, 17 Aug 2026 15:31:49 +0200
Message-ID: <20260817132535.994046749@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit 6ddfba2ea98db21b001e0e5c472499156224650c ]

In case __mlx5e_add_fdb_flow() fails in lower levels, the flow is
deleted via mlx5e_tc_del_flow(), and mlx5e_tc_del_flow() is acquiring
ESW devcom lock without condition. In addition, in case of peer_flow,
__mlx5e_add_fdb_flow() is called while holding ESW devcom comp lock.
This results in an AA deadlock.

To fix this, introduce a new PEER flag that is set on flows created as
peer flows (the duplicate flows on peer devices), and check it in
mlx5e_tc_del_flow() before acquiring ESW devcom lock.

Lockdep splat:
============================================
WARNING: possible recursive locking detected
============================================
 Possible unsafe locking scenario:
       CPU0
       ----
  lock(&comp->lock_key#2);
  lock(&comp->lock_key#2);
 *** DEADLOCK ***
Call Trace:
 <TASK>
 dump_stack_lvl+0x69/0xa0
 print_deadlock_bug.cold+0xbd/0xca
 __lock_acquire+0x1671/0x2ec0
 lock_acquire+0x10e/0x2e0
 down_read+0x95/0x430
 mlx5_devcom_for_each_peer_begin+0x4e/0xe0 [mlx5_core]
 mlx5e_tc_del_flow+0x11d/0xa70 [mlx5_core]
 mlx5e_flow_put+0x99/0x100 [mlx5_core]
 __mlx5e_add_fdb_flow+0x409/0xf00 [mlx5_core]
 mlx5e_configure_flower+0x2a86/0x4100 [mlx5_core]
 mlx5e_rep_setup_tc_cls_flower+0x12f/0x1b0 [mlx5_core]
 mlx5e_rep_setup_tc_cb+0x153/0x750 [mlx5_core]
 tc_setup_cb_add+0x1dc/0x470
 fl_change+0x2f4d/0x626d [cls_flower]
 tc_new_tfilter+0x79b/0x2310
 rtnetlink_rcv_msg+0x778/0xad0
 do_syscall_64+0x70/0x960
 entry_SYSCALL_64_after_hwframe+0x4b/0x53
 </TASK>

Fixes: 04de7dda7394 ("net/mlx5e: Infrastructure for duplicated offloading of TC flows")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260728044338.2271143-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c      | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
index efb34de4cb7ad..692ac2f21d94e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
@@ -30,6 +30,7 @@ enum {
 	MLX5E_TC_FLOW_FLAG_FAILED                = MLX5E_TC_FLOW_BASE + 9,
 	MLX5E_TC_FLOW_FLAG_SAMPLE                = MLX5E_TC_FLOW_BASE + 10,
 	MLX5E_TC_FLOW_FLAG_USE_ACT_STATS         = MLX5E_TC_FLOW_BASE + 11,
+	MLX5E_TC_FLOW_FLAG_PEER                  = MLX5E_TC_FLOW_BASE + 12,
 };
 
 struct mlx5e_tc_flow_parse_attr {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 8878990254f46..a5ae179310672 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2161,7 +2161,8 @@ static void mlx5e_tc_del_flow(struct mlx5e_priv *priv,
 	if (mlx5e_is_eswitch_flow(flow)) {
 		struct mlx5_devcom_comp_dev *devcom = flow->priv->mdev->priv.eswitch->devcom;
 
-		if (!mlx5_devcom_for_each_peer_begin(devcom)) {
+		if (flow_flag_test(flow, PEER) ||
+		    !mlx5_devcom_for_each_peer_begin(devcom)) {
 			mlx5e_tc_del_fdb_flow(priv, flow);
 			return;
 		}
@@ -4605,6 +4606,7 @@ static int mlx5e_tc_add_fdb_peer_flow(struct flow_cls_offload *f,
 	else
 		in_mdev = priv->mdev;
 
+	flow_flags |= BIT(MLX5E_TC_FLOW_FLAG_PEER);
 	parse_attr = flow->attr->parse_attr;
 	peer_flow = __mlx5e_add_fdb_flow(peer_priv, f, flow_flags,
 					 parse_attr->filter_dev,
-- 
2.53.0



