Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41BCC377ABA;
	Sat, 12 Sep 2026 16:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231572; cv=none; b=PMhTUiA052In9QoBQGeHC9Nd09tSxKP488kpMNJpN/JQbB8afAFyseLJTxzMR5+3ZJET9LUSmg4WAzx42YeUPyRFndm5POZSJwcAO69UGML57k1YVqfgw3FgRqsp1EqtNT6Iq8WCLe2VWnTI4R0ODVaqvnR7GnqXWWj2VTCex2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231572; c=relaxed/simple;
	bh=O5EXEDhEYXgYgxEf4iu+jH19KgkyiTSmFK/8GhtufO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OdAIOkzw0SFZ3RajqfaKlFS2YSIKkO+6MOqYX/N8AkRLtS/uvdE/TbEQh3RTRufAe+qhGEFOFM+zukBDcOEyfPquGdJrlDS+5EFX7JQLPYfulqZrNm7jzDa35yvBU9ktknUC1CO0WS9YivIn9RTXpePmngtUguWS7xf4bZQzwmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QpYKPTd4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QpYKPTd4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F6B51F000FF;
	Sat, 12 Sep 2026 16:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231571;
	bh=1JSEPIOv9znnl+1kNpF+1rhemA+V4xzvkdDQDiHYXcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QpYKPTd4Hknl6RAGLsA3ZGkh1fAkooMhQEOY8mU5+y5ltAv6VQjePaA34ibggznYp
	 JufkccC7Q2QnK+uakGks99WEA8eaMqs2F3ybuhjYkQzXLkLxdfhKvBrwl9DhGrUQtB
	 gulMNSbtaHBweCzocqzTOy9FKJkcBXIHlLTWd6yY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1027/1191] null_blk: add configfs variable shared_tags
Date: Sat, 12 Sep 2026 09:02:35 +0200
Message-ID: <20260912065611.253643426@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

[ Upstream commit 14509b748ff58df3f0980b1cd70ade0e4a805e99 ]

Allow setting shared_tags through configfs, which could only be set as a
module parameter. For that purpose, delay tag_set initialization from
null_init() to null_add_dev(). Refer tag_set.ops as the flag to check if
tag_set is initialized or not.

The following parameters can not be set through configfs yet:

    timeout
    requeue
    init_hctx

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Link: https://lore.kernel.org/r/20240130042134.2463659-1-shinichiro.kawasaki@wdc.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: c9d293d6bb05 ("null_blk: register configfs subsystem after creating default devices")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/null_blk/main.c     | 38 ++++++++++++++++---------------
 drivers/block/null_blk/null_blk.h |  1 +
 2 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index 59cef8db63e86..11bda1242283b 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -165,8 +165,8 @@ static bool g_blocking;
 module_param_named(blocking, g_blocking, bool, 0444);
 MODULE_PARM_DESC(blocking, "Register as a blocking blk-mq driver device");
 
-static bool shared_tags;
-module_param(shared_tags, bool, 0444);
+static bool g_shared_tags;
+module_param_named(shared_tags, g_shared_tags, bool, 0444);
 MODULE_PARM_DESC(shared_tags, "Share tag set between devices for blk-mq");
 
 static bool g_shared_tag_bitmap;
@@ -438,6 +438,7 @@ NULLB_DEVICE_ATTR(zone_max_open, uint, NULL);
 NULLB_DEVICE_ATTR(zone_max_active, uint, NULL);
 NULLB_DEVICE_ATTR(virt_boundary, bool, NULL);
 NULLB_DEVICE_ATTR(no_sched, bool, NULL);
+NULLB_DEVICE_ATTR(shared_tags, bool, NULL);
 NULLB_DEVICE_ATTR(shared_tag_bitmap, bool, NULL);
 
 static ssize_t nullb_device_power_show(struct config_item *item, char *page)
@@ -587,6 +588,7 @@ static struct configfs_attribute *nullb_device_attrs[] = {
 	&nullb_device_attr_zone_offline,
 	&nullb_device_attr_virt_boundary,
 	&nullb_device_attr_no_sched,
+	&nullb_device_attr_shared_tags,
 	&nullb_device_attr_shared_tag_bitmap,
 	NULL,
 };
@@ -647,10 +649,11 @@ static ssize_t memb_group_features_show(struct config_item *item, char *page)
 			"badblocks,blocking,blocksize,cache_size,"
 			"completion_nsec,discard,home_node,hw_queue_depth,"
 			"irqmode,max_sectors,mbps,memory_backed,no_sched,"
-			"poll_queues,power,queue_mode,shared_tag_bitmap,size,"
-			"submit_queues,use_per_node_hctx,virt_boundary,zoned,"
-			"zone_capacity,zone_max_active,zone_max_open,"
-			"zone_nr_conv,zone_offline,zone_readonly,zone_size\n");
+			"poll_queues,power,queue_mode,shared_tag_bitmap,"
+			"shared_tags,size,submit_queues,use_per_node_hctx,"
+			"virt_boundary,zoned,zone_capacity,zone_max_active,"
+			"zone_max_open,zone_nr_conv,zone_offline,zone_readonly,"
+			"zone_size\n");
 }
 
 CONFIGFS_ATTR_RO(memb_group_, features);
@@ -725,6 +728,7 @@ static struct nullb_device *null_alloc_dev(void)
 	dev->zone_max_active = g_zone_max_active;
 	dev->virt_boundary = g_virt_boundary;
 	dev->no_sched = g_no_sched;
+	dev->shared_tags = g_shared_tags;
 	dev->shared_tag_bitmap = g_shared_tag_bitmap;
 	return dev;
 }
@@ -2085,7 +2089,14 @@ static int null_add_dev(struct nullb_device *dev)
 		goto out_free_nullb;
 
 	if (dev->queue_mode == NULL_Q_MQ) {
-		if (shared_tags) {
+		if (dev->shared_tags) {
+			if (!tag_set.ops) {
+				rv = null_init_tag_set(NULL, &tag_set);
+				if (rv) {
+					tag_set.ops = NULL;
+					goto out_cleanup_queues;
+				}
+			}
 			nullb->tag_set = &tag_set;
 			rv = 0;
 		} else {
@@ -2270,18 +2281,12 @@ static int __init null_init(void)
 		g_submit_queues = 1;
 	}
 
-	if (g_queue_mode == NULL_Q_MQ && shared_tags) {
-		ret = null_init_tag_set(NULL, &tag_set);
-		if (ret)
-			return ret;
-	}
-
 	config_group_init(&nullb_subsys.su_group);
 	mutex_init(&nullb_subsys.su_mutex);
 
 	ret = configfs_register_subsystem(&nullb_subsys);
 	if (ret)
-		goto err_tagset;
+		return ret;
 
 	null_major = register_blkdev(0, "nullb");
 	if (null_major < 0) {
@@ -2306,9 +2311,6 @@ static int __init null_init(void)
 	unregister_blkdev(null_major, "nullb");
 err_conf:
 	configfs_unregister_subsystem(&nullb_subsys);
-err_tagset:
-	if (g_queue_mode == NULL_Q_MQ && shared_tags)
-		blk_mq_free_tag_set(&tag_set);
 	return ret;
 }
 
@@ -2327,7 +2329,7 @@ static void __exit null_exit(void)
 	}
 	mutex_unlock(&lock);
 
-	if (g_queue_mode == NULL_Q_MQ && shared_tags)
+	if (tag_set.ops)
 		blk_mq_free_tag_set(&tag_set);
 
 	mutex_destroy(&lock);
diff --git a/drivers/block/null_blk/null_blk.h b/drivers/block/null_blk/null_blk.h
index eb5972c50be86..f211deb9bbcaa 100644
--- a/drivers/block/null_blk/null_blk.h
+++ b/drivers/block/null_blk/null_blk.h
@@ -114,6 +114,7 @@ struct nullb_device {
 	bool zoned; /* if device is zoned */
 	bool virt_boundary; /* virtual boundary on/off for the device */
 	bool no_sched; /* no IO scheduler for the device */
+	bool shared_tags; /* share tag set between devices for blk-mq */
 	bool shared_tag_bitmap; /* use hostwide shared tags */
 };
 
-- 
2.53.0



