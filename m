Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B7D1A2632;
	Tue, 17 Jun 2025 16:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177379; cv=none; b=jFmEDxEWxmeIeDRI5df295XZnQvVg1y48xLK+4C50AxqhRM556u4FDo+WpK7RwSxNYGvxM1wbq170Jd/ixda79rdXtzgB6E9wC7Epi8pN3pKm9VTbQqgzLzpGV91C6a/drYTQ5o/OTXz9iCaBEp8lZJAoeiaR0xfPvALpxSA6u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177379; c=relaxed/simple;
	bh=w4xx/HJ0JDXO69E8o3tqEvWhgt6iYb0YLEfQuwhDkwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kqWJVyz6pXqsA0fxGvScCtbZfFQ1//wx3AabmEE6djDYQY5SFJNRftEuyFsZ49AEYKe8RPDnwAUWNxPCEPKGojWHEYijgiHp4eOdCYlyHLPesw+sXJGkaAVZGiq836snZ0UvbqQO4AU2Fd91BncC4IJcvIZ7DGbb/yrK99beX9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XCFSarRH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XCFSarRH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15692C4CEE3;
	Tue, 17 Jun 2025 16:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177379;
	bh=w4xx/HJ0JDXO69E8o3tqEvWhgt6iYb0YLEfQuwhDkwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XCFSarRHNwDZ5PTnD+l99aLBbfyUtCqCZBZfrzQRKj4FMVqgX8mG9Zh1eNKCxiQjU
	 ScETmO0SVhGlNJgap/y1JJ5UHcCO6u2xOencvGdG3oSaFTK95b//vQJqzlQfW2jdJg
	 Hu0aj89BLYz+t+5kxxWqnJnDyOZhleGSpjL+kx0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Leo Yan <leo.yan@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 335/512] coresight: prevent deactivate active config while enabling the config
Date: Tue, 17 Jun 2025 17:25:01 +0200
Message-ID: <20250617152433.188175263@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Yeoreum Yun <yeoreum.yun@arm.com>

[ Upstream commit 408c97c4a5e0b634dcd15bf8b8808b382e888164 ]

While enable active config via cscfg_csdev_enable_active_config(),
active config could be deactivated via configfs' sysfs interface.
This could make UAF issue in below scenario:

CPU0                                          CPU1
(sysfs enable)                                load module
                                              cscfg_load_config_sets()
                                              activate config. // sysfs
                                              (sys_active_cnt == 1)
...
cscfg_csdev_enable_active_config()
lock(csdev->cscfg_csdev_lock)
// here load config activate by CPU1
unlock(csdev->cscfg_csdev_lock)

                                              deactivate config // sysfs
                                              (sys_activec_cnt == 0)
                                              cscfg_unload_config_sets()
                                              unload module

// access to config_desc which freed
// while unloading module.
cscfg_csdev_enable_config

To address this, use cscfg_config_desc's active_cnt as a reference count
 which will be holded when
    - activate the config.
    - enable the activated config.
and put the module reference when config_active_cnt == 0.

Fixes: f8cce2ff3c04 ("coresight: syscfg: Add API to activate and enable configurations")
Suggested-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20250514161951.3427590-4-yeoreum.yun@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../hwtracing/coresight/coresight-config.h    |  2 +-
 .../hwtracing/coresight/coresight-syscfg.c    | 49 +++++++++++++------
 2 files changed, 35 insertions(+), 16 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-config.h b/drivers/hwtracing/coresight/coresight-config.h
index 6ba0139757418..84cdde6f0e4db 100644
--- a/drivers/hwtracing/coresight/coresight-config.h
+++ b/drivers/hwtracing/coresight/coresight-config.h
@@ -228,7 +228,7 @@ struct cscfg_feature_csdev {
  * @feats_csdev:references to the device features to enable.
  */
 struct cscfg_config_csdev {
-	const struct cscfg_config_desc *config_desc;
+	struct cscfg_config_desc *config_desc;
 	struct coresight_device *csdev;
 	bool enabled;
 	struct list_head node;
diff --git a/drivers/hwtracing/coresight/coresight-syscfg.c b/drivers/hwtracing/coresight/coresight-syscfg.c
index 11138a9762b01..30a561d874819 100644
--- a/drivers/hwtracing/coresight/coresight-syscfg.c
+++ b/drivers/hwtracing/coresight/coresight-syscfg.c
@@ -867,6 +867,25 @@ void cscfg_csdev_reset_feats(struct coresight_device *csdev)
 }
 EXPORT_SYMBOL_GPL(cscfg_csdev_reset_feats);
 
+static bool cscfg_config_desc_get(struct cscfg_config_desc *config_desc)
+{
+	if (!atomic_fetch_inc(&config_desc->active_cnt)) {
+		/* must ensure that config cannot be unloaded in use */
+		if (unlikely(cscfg_owner_get(config_desc->load_owner))) {
+			atomic_dec(&config_desc->active_cnt);
+			return false;
+		}
+	}
+
+	return true;
+}
+
+static void cscfg_config_desc_put(struct cscfg_config_desc *config_desc)
+{
+	if (!atomic_dec_return(&config_desc->active_cnt))
+		cscfg_owner_put(config_desc->load_owner);
+}
+
 /*
  * This activate configuration for either perf or sysfs. Perf can have multiple
  * active configs, selected per event, sysfs is limited to one.
@@ -890,22 +909,17 @@ static int _cscfg_activate_config(unsigned long cfg_hash)
 			if (config_desc->available == false)
 				return -EBUSY;
 
-			/* must ensure that config cannot be unloaded in use */
-			err = cscfg_owner_get(config_desc->load_owner);
-			if (err)
+			if (!cscfg_config_desc_get(config_desc)) {
+				err = -EINVAL;
 				break;
+			}
+
 			/*
 			 * increment the global active count - control changes to
 			 * active configurations
 			 */
 			atomic_inc(&cscfg_mgr->sys_active_cnt);
 
-			/*
-			 * mark the descriptor as active so enable config on a
-			 * device instance will use it
-			 */
-			atomic_inc(&config_desc->active_cnt);
-
 			err = 0;
 			dev_dbg(cscfg_device(), "Activate config %s.\n", config_desc->name);
 			break;
@@ -920,9 +934,8 @@ static void _cscfg_deactivate_config(unsigned long cfg_hash)
 
 	list_for_each_entry(config_desc, &cscfg_mgr->config_desc_list, item) {
 		if ((unsigned long)config_desc->event_ea->var == cfg_hash) {
-			atomic_dec(&config_desc->active_cnt);
 			atomic_dec(&cscfg_mgr->sys_active_cnt);
-			cscfg_owner_put(config_desc->load_owner);
+			cscfg_config_desc_put(config_desc);
 			dev_dbg(cscfg_device(), "Deactivate config %s.\n", config_desc->name);
 			break;
 		}
@@ -1047,7 +1060,7 @@ int cscfg_csdev_enable_active_config(struct coresight_device *csdev,
 				     unsigned long cfg_hash, int preset)
 {
 	struct cscfg_config_csdev *config_csdev_active = NULL, *config_csdev_item;
-	const struct cscfg_config_desc *config_desc;
+	struct cscfg_config_desc *config_desc;
 	unsigned long flags;
 	int err = 0;
 
@@ -1062,8 +1075,8 @@ int cscfg_csdev_enable_active_config(struct coresight_device *csdev,
 	spin_lock_irqsave(&csdev->cscfg_csdev_lock, flags);
 	list_for_each_entry(config_csdev_item, &csdev->config_csdev_list, node) {
 		config_desc = config_csdev_item->config_desc;
-		if ((atomic_read(&config_desc->active_cnt)) &&
-		    ((unsigned long)config_desc->event_ea->var == cfg_hash)) {
+		if (((unsigned long)config_desc->event_ea->var == cfg_hash) &&
+				cscfg_config_desc_get(config_desc)) {
 			config_csdev_active = config_csdev_item;
 			csdev->active_cscfg_ctxt = (void *)config_csdev_active;
 			break;
@@ -1097,7 +1110,11 @@ int cscfg_csdev_enable_active_config(struct coresight_device *csdev,
 				err = -EBUSY;
 			spin_unlock_irqrestore(&csdev->cscfg_csdev_lock, flags);
 		}
+
+		if (err)
+			cscfg_config_desc_put(config_desc);
 	}
+
 	return err;
 }
 EXPORT_SYMBOL_GPL(cscfg_csdev_enable_active_config);
@@ -1136,8 +1153,10 @@ void cscfg_csdev_disable_active_config(struct coresight_device *csdev)
 	spin_unlock_irqrestore(&csdev->cscfg_csdev_lock, flags);
 
 	/* true if there was an enabled active config */
-	if (config_csdev)
+	if (config_csdev) {
 		cscfg_csdev_disable_config(config_csdev);
+		cscfg_config_desc_put(config_csdev->config_desc);
+	}
 }
 EXPORT_SYMBOL_GPL(cscfg_csdev_disable_active_config);
 
-- 
2.39.5



