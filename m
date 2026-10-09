Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A542D592D;
	Fri,  9 Oct 2026 14:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555775; cv=none; b=GTCwN8AtHd+yIHWZbaaU98lyEuwFsKeuqeetVNdiFWxi85AXnNGaQ4kaAgjQ/zq56/EXa697u7aiWj/E7bGOrs90v4skZALraHxPkpBaTzPC64fz/DmFbQjTplZ2JpMYFgPML+4EIGnFh3m13LJxfVtVnLtEGFPlEyQq/lhdFVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555775; c=relaxed/simple;
	bh=+mdJVPfBN7CFrhimcL0u4+Wu5UPDboFdAr9s2nY/A44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pcpnTdxjq6/SmZjA6iqKQD88a40MwMrgYwBZNwXJmwOZeVXc+oQ8m5khELtK0f8CgXw36LDfvPRf9oBLBHGmo0K2zTdjEsYio1uxyAup5QvvlJvHgo3kMpqZDkXjyNoI56UtwNrTLGRqWgr5yZtxI/t1Zsz2uRvXW7IKXG8mlaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HvaeNTwf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HvaeNTwf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A34351F000FF;
	Fri,  9 Oct 2026 14:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555774;
	bh=wISmy4a+cyZVpA/281SFhPsRSJK4Oz8VRHf0UYmna7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HvaeNTwfi0IZZ2lhL9r3N/gSwa8drPFH/QEpLG8dYa4xfjNxQ0SiDMlyVmRCCuPaX
	 +4KAD34wgt+qy73zrpAuUbOVeMRavMqGMRU2ZlX1lTwSc9CRW3g8MD/Yif3Qf3o+3N
	 +q2w1fbRuw6q9+Hc51LOOUJKkYtNxd1IZPRHYvLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 116/403] net: sparx5: move stats initialization and add deinit function
Date: Fri,  9 Oct 2026 16:07:57 +0200
Message-ID: <20261009140954.792308758@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Machon <daniel.machon@microchip.com>

[ Upstream commit e180067a03cad7043d951b0040f0169a267f0293 ]

The sparx5_stats_init() function starts a worker thread which needs to
be cleaned up. Move the initialization code to probe() and add a
deinit() function for proper teardown.

Also, rename sparx_stats_init() to sparx5_stats_init() to match the
driver naming convention.

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/20260227-sparx5-init-deinit-v2-4-10ba54ccf005@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 0d2c49915bc3 ("net: sparx5: skip ptp deinit if init was skipped")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/microchip/sparx5/sparx5_ethtool.c   |  9 ++++++++-
 .../net/ethernet/microchip/sparx5/sparx5_main.c  | 16 ++++++++++------
 .../net/ethernet/microchip/sparx5/sparx5_main.h  |  3 ++-
 3 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c b/drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c
index 049541eeaae0d..d42c57bead89d 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c
@@ -1244,7 +1244,7 @@ const struct ethtool_ops sparx5_ethtool_ops = {
 	.set_pauseparam         = sparx5_set_pauseparam,
 };
 
-int sparx_stats_init(struct sparx5 *sparx5)
+int sparx5_stats_init(struct sparx5 *sparx5)
 {
 	const struct sparx5_consts *consts = sparx5->data->consts;
 	char queue_name[32];
@@ -1278,3 +1278,10 @@ int sparx_stats_init(struct sparx5 *sparx5)
 
 	return 0;
 }
+
+void sparx5_stats_deinit(struct sparx5 *sparx5)
+{
+	cancel_delayed_work_sync(&sparx5->stats_work);
+	destroy_workqueue(sparx5->stats_queue);
+	mutex_destroy(&sparx5->queue_stats_lock);
+}
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
index 8ac9960a776a2..4ebcc4f127a5b 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
@@ -741,11 +741,6 @@ static int sparx5_start(struct sparx5 *sparx5)
 	if (err)
 		return err;
 
-	/* Init stats */
-	err = sparx_stats_init(sparx5);
-	if (err)
-		return err;
-
 	sparx5_board_init(sparx5);
 
 	/* Start Frame DMA with fallback to register based INJ/XTR */
@@ -984,12 +979,18 @@ static int mchp_sparx5_probe(struct platform_device *pdev)
 		goto cleanup_vcap;
 	}
 
+	err = sparx5_stats_init(sparx5);
+	if (err) {
+		dev_err(sparx5->dev, "Failed to initialize stats\n");
+		goto cleanup_mact;
+	}
+
 	INIT_LIST_HEAD(&sparx5->mall_entries);
 
 	err = sparx5_register_netdevs(sparx5);
 	if (err) {
 		dev_err(sparx5->dev, "Failed to register net devices\n");
-		goto cleanup_mact;
+		goto cleanup_stats;
 	}
 
 	err = sparx5_register_notifier_blocks(sparx5);
@@ -1002,6 +1003,8 @@ static int mchp_sparx5_probe(struct platform_device *pdev)
 
 cleanup_netdevs:
 	sparx5_unregister_netdevs(sparx5);
+cleanup_stats:
+	sparx5_stats_deinit(sparx5);
 cleanup_mact:
 	sparx5_mact_deinit(sparx5);
 cleanup_vcap:
@@ -1033,6 +1036,7 @@ static void mchp_sparx5_remove(struct platform_device *pdev)
 	}
 	sparx5_unregister_notifier_blocks(sparx5);
 	sparx5_unregister_netdevs(sparx5);
+	sparx5_stats_deinit(sparx5);
 	sparx5_mact_deinit(sparx5);
 	sparx5_vcap_deinit(sparx5);
 	sparx5_ptp_deinit(sparx5);
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
index e4c39cca7b266..97d53e229ad69 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
@@ -514,7 +514,8 @@ enum sparx5_cal_bw sparx5_get_port_cal_speed(struct sparx5 *sparx5, u32 portno);
 
 /* sparx5_ethtool.c */
 void sparx5_get_stats64(struct net_device *ndev, struct rtnl_link_stats64 *stats);
-int sparx_stats_init(struct sparx5 *sparx5);
+int sparx5_stats_init(struct sparx5 *sparx5);
+void sparx5_stats_deinit(struct sparx5 *sparx5);
 
 /* sparx5_dcb.c */
 #ifdef CONFIG_SPARX5_DCB
-- 
2.53.0



