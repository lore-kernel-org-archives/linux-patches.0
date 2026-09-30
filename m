Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E38B3DBD51;
	Wed, 30 Sep 2026 19:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795280; cv=none; b=ejft2Nhs9FvVpMpYgbypf29C1YgqGXO09QGBDp4VwumSehgLCCIEFJxfQTOgIPXMqg/nNrNTZf54GgJdDWqkqigCTEF1HuI7hDm+V7bzRFKEzAu6Z6iOdEnTpqWi9ZhbXaHhzFVLORg14Mia6uFHlZtfgiHIgXs1X5Q4skR/zyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795280; c=relaxed/simple;
	bh=U2WPIyj6rZnW8Oe/F/BILFDQce1P5HE3zIHDbKnI3Y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bh4q4yUTJgxDWGE10yOmpYiWWPMs+CVYtPd6zox8tSc+UR2ibOTZdA3b3ZTZt2/csHKPyZxzLpZ0CKikuDKVRXQ2bkDMQw2p0EdFpZkwaHi8OfOPg+z+v7S4U2ZXUQ7MvKEpBkxwgl3uO86tV21z4UlxH/0aMZHbvdcCXhm8gf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2At+MbqH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2At+MbqH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C80571F000FF;
	Wed, 30 Sep 2026 19:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795279;
	bh=50CSanLo0inZeb3IwGL4PvMI8BW+JQ1tFau1a5Nb3UI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2At+MbqHj2HQjZWfU8WB6qkJZaDwdB7GrsIY9IH139H5z6asn4ueOHvBi2FpF2DMP
	 VXJkmlaKSrulgXX9iDHVAOizdXlAkk9ZEHgUx26Fo0JSoSu/alcGgAOsU7f8+Jiwda
	 I3DOcLiegvEiLmcy5/aI436PAgZORjncb/TSWf/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lama Kayal <lkayal@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0505/1193] net/mlx5: E-Switch, prevent mc_list repopulation during vport disable
Date: Wed, 30 Sep 2026 17:19:49 +0200
Message-ID: <20260930152445.384053653@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3593e2770baf7..a096f7c031cd1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -972,13 +972,19 @@ void mlx5_esw_vport_disable(struct mlx5_eswitch *esw, struct mlx5_vport *vport)
 	    (vport->info.ipsec_crypto_enabled || vport->info.ipsec_packet_enabled))
 		esw->enabled_ipsec_vf_count--;
 
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



