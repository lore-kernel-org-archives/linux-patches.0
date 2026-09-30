Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A614BE423;
	Wed, 30 Sep 2026 18:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791478; cv=none; b=JnCxgVVZ0qcgeq0SZntBw5Um6vyiPZMpQSgNgpAGguVnPg9O+shq6X2S6bsosw/Zgij8b+k9zFxQb0Guf/S+v2+Qd7rwRLTdAepcgrVUpSltmcylcShoTkXCyLTIVEUQrVLt3H7ZZUZNgP8SCKyDsv/ciLRCi1T8J0OdAM8lBuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791478; c=relaxed/simple;
	bh=0wnQas5AF2xbwFzl0Yhoi1rJTJCPuTU0LVfvS3CjKcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FpzgMSWe0XGIPBhr+9pPwzwBVBKCsE63RtFjoXXXi846m/37xrujpmNMRBK3JIGUUTOhd+V6AeSnJDX3K9qMM1CYuz4y2E7PZlBCVoWDjNOlRX4A1UyFV7QiR4CmM9N1UEMM8vzfSVbAZy6MCQ59+7hKN8PFfvIyXaK2PP7PyGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PM6SI3qN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PM6SI3qN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB0391F000FF;
	Wed, 30 Sep 2026 18:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791477;
	bh=+jUDF3FiFRrP+vHNeTNhHes/O/0dqtggFBhgl5zVO34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PM6SI3qNolUJcN33emju1B8K2d8z0TyuujYVpk24wFB/qrCaOGxhktnEhsHAaTH13
	 O0tHDFpilKpdZYLulYF16f7e1tr6p7t/EuiDgRSWGbe+hwuQedJeseIzUtCzLHOHoL
	 tiCPaZmaZDo04C/806h8eL9Gf88r+LirM+twR99k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lama Kayal <lkayal@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 314/752] net/mlx5: E-Switch, prevent mc_list repopulation during vport disable
Date: Wed, 30 Sep 2026 17:23:04 +0200
Message-ID: <20260930152405.092708518@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lama Kayal <lkayal@nvidia.com>

[ Upstream commit c0c6f4ba8a37688f7b4d4044898d88f0450d44c2 ]

In mlx5_esw_vport_disable(), move esw_apply_vport_rx_mode() ahead
of esw_vport_change_handle_locked() so vport->allmulti_rule is
NULL before the change handler observes it.

During FW-fatal recovery the disable runs while dev->state ==
INTERNAL_ERROR. The promisc query inside esw_update_vport_rx_mode()
fails and returns early, leaving vport->allmulti_rule intact, so
esw_update_vport_mc_promisc() runs and adds MLX5_ACTION_ADD entries
to vport->mc_list whose flow rules are then installed in the FDB
by esw_add_mc_addr(). esw_destroy_legacy_table() tears down the
FDB with those refs still held, corrupting the sub-tree and
leaving dangling flow_rule pointers in vport->mc_list.

Two-stage failure on `echo 1 > /sys/bus/pci/devices/<bdf>/reset`:

  refcount_t: underflow; use-after-free.
   tree_put_node+0xef/0x110 [mlx5_core]
   clean_tree+0x44/0xd0 [mlx5_core] (x5)
   mlx5_fs_core_cleanup+0x57/0x1c0 [mlx5_core]
   mlx5_unload+0x65/0xd0 [mlx5_core]
   ... mlx5_health_try_recover

  BUG: unable to handle page fault for address: 0000000003000055
   down_write+0x1c/0x60
   mlx5_del_flow_rules+0x33/0x1f0 [mlx5_core]
   esw_del_mc_addr+0x7b/0x170 [mlx5_core]
   esw_apply_vport_addr_list+0x56/0xf0 [mlx5_core]
   esw_vport_change_handle_locked+0x28b/0x310 [mlx5_core]
   mlx5_esw_vport_enable+0x270/0x4a0 [mlx5_core]
   ... mlx5_load ... mlx5_health_try_recover

esw_apply_vport_rx_mode(false, false) clears vport->allmulti_rule
via its local state machine even when the FW del fails. With the
rule NULL the !IS_ERR_OR_NULL(allmulti_rule) gate in the change
handler closes, no rules are installed during disable, and the
reload starts with a clean mc_list.

Fixes: 922f56e9a795 ("net/mlx5: Fix steering rules cleanup")
Signed-off-by: Lama Kayal <lkayal@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260902193854.3669035-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 7315bf447e061..58259d9767a8f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -912,13 +912,19 @@ void mlx5_esw_vport_disable(struct mlx5_eswitch *esw, u16 vport_num)
 	    MLX5_CAP_GEN(esw->dev, vhca_resource_manager))
 		mlx5_esw_vport_vhca_id_clear(esw, vport_num);
 
+	/* Clear rx-mode before esw_vport_change_handle_locked(): on
+	 * MLX5_VPORT_PROMISC_CHANGE it calls esw_update_vport_mc_promisc()
+	 * when vport->allmulti_rule is set, repopulating mc_list with FDB
+	 * rules that dangle once the FDB is destroyed. NULL allmulti_rule
+	 * here skips that path.
+	 */
+	esw_apply_vport_rx_mode(esw, vport, false, false);
 	/* We don't assume VFs will cleanup after themselves.
 	 * Calling vport change handler while vport is disabled will cleanup
 	 * the vport resources.
 	 */
 	esw_vport_change_handle_locked(vport);
 	vport->enabled_events = 0;
-	esw_apply_vport_rx_mode(esw, vport, false, false);
 	esw_vport_cleanup(esw, vport);
 	esw->enabled_vports--;
 
-- 
2.53.0



