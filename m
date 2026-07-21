Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B922417D9;
	Tue, 21 Jul 2026 18:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659915; cv=none; b=SqGyquPjOpLSTUKqN99bdrF+yKVkj1ctINP/WNAmNEA4DgccQmgoJ/WB65xpOJk6lB4xX5teC3rfYtm2sawej7Ce3CM/xKC7JlqaNxtwFStP+e0pZLuZN2DJatwJPuqfzbjD5i+9M3yQQ4cKRK/x6QoRqFMXcLA/YcvCyVRNP6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659915; c=relaxed/simple;
	bh=rkt2vzgYvXHBUIxlXCSRjv2avVG1ZOdmy7cv/76MO1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=klnTPIWrf6GfnTehMFmMiQhtRJ5FLdhF8m87e5l1Mc85Mkgb1resIRVuSwerSfZYv6EFoD84oXB03W0hjBZGj0Lyg+GBMiLJHq1keC1Ch54/hbr0njCbfztiasCxrt17NIm4gcnP605K8R4ehO93PnLQy348qvys3jUMC7bStlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0SlFRiBE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0SlFRiBE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D4E11F00A3F;
	Tue, 21 Jul 2026 18:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659913;
	bh=yW0v6iUnALjLNZ8Xg+flmJM/OLFEWHHZortq4raeFYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0SlFRiBEBCck2U7DXr3H1EzySWN159XuyFGRBoGTQvom/A4z0L77OE3hhqHSeWt8u
	 DwQu9koGJqq19kVnRK+oXIKXyMNkVc1TsGOcfP+VUeXMUJ7N5ZWjce0UX1njxCdqw/
	 rSsXVXSZ0+BGj2LoZ2qyd8z9HPvqK5Wd3tC7RuDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sungwoo Kim <iam@sung-woo.kim>,
	Dan Williams <djbw@kernel.org>,
	Alejandro Lucero <alucerop@amd.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0737/2077] cxl/region: Resolve region deletion races
Date: Tue, 21 Jul 2026 17:06:50 +0200
Message-ID: <20260721152610.179661781@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <djbw@kernel.org>

[ Upstream commit 4dd86ca99ffcc413cbf79063fd9956ef54e0ca91 ]

Sungwoo noticed that the sysfs trigger to delete a region may try to delete
a region multiple times. It also has no exclusion relative to the kernel
releasing the region via CXL root device teardown.

Instead of installing new cxl root devres actions per region, use the
existing root decoder unregistration event to remove all remaining regions.
An xarray of regions replaces a devres list of regions.

This handles 3 separate issues with the old approach:

1/ sysfs users racing to delete the same region: no longer possible now
   that the regions_lock is held over the lookup and deletion.

2/ multiple actions triggering deletion of the same region: solved by
   erasing regions while holding @regions_lock, and only proceeding on
   successful erasure.

3/ userspace racing devres_release_all() to trigger the devres not found
   warning: solved by sysfs unregistration not requiring a release action

Fixes: 779dd20cfb56 ("cxl/region: Add region creation support")
Reported-by: Sungwoo Kim <iam@sung-woo.kim>
Closes: http://lore.kernel.org/20260427032010.916681-2-iam@sung-woo.kim
Signed-off-by: Dan Williams <djbw@kernel.org>
Reviewed-by: Alejandro Lucero <alucerop@amd.com>
Tested-by: ALejandro Lucero <alucerop@amd.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20260519210158.1499795-3-djbw@kernel.org
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/core.h   |  2 ++
 drivers/cxl/core/port.c   |  5 ++++
 drivers/cxl/core/region.c | 60 +++++++++++++++++++++------------------
 drivers/cxl/cxl.h         |  4 +++
 4 files changed, 44 insertions(+), 27 deletions(-)

diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index 82ca3a4767080c..07555ae6385940 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -52,6 +52,7 @@ u64 cxl_dpa_to_hpa(struct cxl_region *cxlr, const struct cxl_memdev *cxlmd,
 		   u64 dpa);
 int devm_cxl_add_dax_region(struct cxl_region *cxlr);
 int devm_cxl_add_pmem_region(struct cxl_region *cxlr);
+void kill_regions(struct cxl_root_decoder *cxlrd);
 
 #else
 static inline u64 cxl_dpa_to_hpa(struct cxl_region *cxlr,
@@ -81,6 +82,7 @@ static inline int cxl_region_init(void)
 static inline void cxl_region_exit(void)
 {
 }
+static inline void kill_regions(struct cxl_root_decoder *cxlrd) { };
 #define CXL_REGION_ATTR(x) NULL
 #define CXL_REGION_TYPE(x) NULL
 #define SET_CXL_REGION_ATTR(x)
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 6e7a70d51cfe4d..1215ee4f40351b 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -458,6 +458,8 @@ static void cxl_root_decoder_release(struct device *dev)
 
 	if (atomic_read(&cxlrd->region_id) >= 0)
 		memregion_free(atomic_read(&cxlrd->region_id));
+	mutex_destroy(&cxlrd->regions_lock);
+	xa_destroy(&cxlrd->regions);
 	__cxl_decoder_release(&cxlrd->cxlsd.cxld);
 	kfree(cxlrd);
 }
@@ -2017,6 +2019,7 @@ struct cxl_root_decoder *cxl_root_decoder_alloc(struct cxl_port *port,
 	}
 
 	mutex_init(&cxlrd->regions_lock);
+	xa_init(&cxlrd->regions);
 
 	cxld = &cxlsd->cxld;
 	cxld->dev.type = &cxl_decoder_root_type;
@@ -2192,6 +2195,8 @@ static void cxld_unregister(void *dev)
 	if (is_endpoint_decoder(dev))
 		cxl_decoder_detach(NULL, to_cxl_endpoint_decoder(dev), -1,
 				   DETACH_INVALIDATE);
+	if (is_root_decoder(dev))
+		kill_regions(to_cxl_root_decoder(dev));
 
 	device_unregister(dev);
 }
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 3abf7703f7f25e..fda9e97a6ddcd2 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -2548,12 +2548,13 @@ static struct cxl_region *to_cxl_region(struct device *dev)
 	return container_of(dev, struct cxl_region, dev);
 }
 
-static void unregister_region(void *_cxlr)
+static void unregister_region(struct cxl_region *cxlr)
 {
-	struct cxl_region *cxlr = _cxlr;
+	struct cxl_root_decoder *cxlrd = to_cxl_root_decoder(cxlr->dev.parent);
 	struct cxl_region_params *p = &cxlr->params;
 	int i;
 
+	xa_erase(&cxlrd->regions, cxlr->id);
 	device_del(&cxlr->dev);
 
 	/*
@@ -2684,6 +2685,19 @@ static int cxl_region_calculate_adistance(struct notifier_block *nb,
 	return NOTIFY_STOP;
 }
 
+/* unwind all remaining regions */
+void kill_regions(struct cxl_root_decoder *cxlrd)
+{
+	unsigned long index;
+	struct cxl_region *cxlr;
+
+	guard(mutex)(&cxlrd->regions_lock);
+	/* no more region creation */
+	cxlrd->dead = true;
+	xa_for_each(&cxlrd->regions, index, cxlr)
+		unregister_region(cxlr);
+}
+
 /**
  * devm_cxl_add_region - Adds a region to a decoder
  * @cxlrd: root decoder
@@ -2722,14 +2736,15 @@ static struct cxl_region *devm_cxl_add_region(struct cxl_root_decoder *cxlrd,
 	if (rc)
 		goto err;
 
-	rc = devm_add_action_or_reset(port->uport_dev, unregister_region, cxlr);
-	if (rc)
+	rc = xa_insert(&cxlrd->regions, cxlr->id, cxlr, GFP_KERNEL);
+	if (rc) {
+		unregister_region(cxlr);
 		return ERR_PTR(rc);
+	}
 
 	dev_dbg(port->uport_dev, "%s: created %s\n",
 		dev_name(&cxlrd->cxlsd.cxld.dev), dev_name(dev));
 	return cxlr;
-
 err:
 	put_device(dev);
 	return ERR_PTR(rc);
@@ -2758,6 +2773,9 @@ static struct cxl_region *__create_region(struct cxl_root_decoder *cxlrd,
 {
 	int rc;
 
+	if (cxlrd->dead)
+		return ERR_PTR(-ENXIO);
+
 	switch (mode) {
 	case CXL_PARTMODE_RAM:
 	case CXL_PARTMODE_PMEM:
@@ -2833,38 +2851,27 @@ static ssize_t region_show(struct device *dev, struct device_attribute *attr,
 }
 DEVICE_ATTR_RO(region);
 
-static struct cxl_region *
-cxl_find_region_by_name(struct cxl_root_decoder *cxlrd, const char *name)
-{
-	struct cxl_decoder *cxld = &cxlrd->cxlsd.cxld;
-	struct device *region_dev;
-
-	region_dev = device_find_child_by_name(&cxld->dev, name);
-	if (!region_dev)
-		return ERR_PTR(-ENODEV);
-
-	return to_cxl_region(region_dev);
-}
-
 static ssize_t delete_region_store(struct device *dev,
 				   struct device_attribute *attr,
 				   const char *buf, size_t len)
 {
 	struct cxl_root_decoder *cxlrd = to_cxl_root_decoder(dev);
-	struct cxl_port *port = to_cxl_port(dev->parent);
 	struct cxl_region *cxlr;
-	int rc;
+	int rc, id;
 
 	ACQUIRE(mutex_intr, regions_lock)(&cxlrd->regions_lock);
 	if ((rc = ACQUIRE_ERR(mutex_intr, &regions_lock)))
 		return rc;
 
-	cxlr = cxl_find_region_by_name(cxlrd, buf);
-	if (IS_ERR(cxlr))
-		return PTR_ERR(cxlr);
+	rc = sscanf(buf, "region%d\n", &id);
+	if (rc != 1)
+		return -EINVAL;
 
-	devm_release_action(port->uport_dev, unregister_region, cxlr);
-	put_device(&cxlr->dev);
+	cxlr = xa_load(&cxlrd->regions, id);
+	if (!cxlr || !sysfs_streq(buf, dev_name(&cxlr->dev)))
+		return -ENODEV;
+
+	unregister_region(cxlr);
 
 	return len;
 }
@@ -3729,7 +3736,6 @@ static struct cxl_region *construct_region(struct cxl_root_decoder *cxlrd,
 {
 	struct cxl_endpoint_decoder *cxled = ctx->cxled;
 	struct cxl_memdev *cxlmd = cxled_to_memdev(cxled);
-	struct cxl_port *port = cxlrd_to_port(cxlrd);
 	struct cxl_dev_state *cxlds = cxlmd->cxlds;
 	int rc, part = READ_ONCE(cxled->part);
 	struct cxl_region *cxlr;
@@ -3750,7 +3756,7 @@ static struct cxl_region *construct_region(struct cxl_root_decoder *cxlrd,
 
 	rc = __construct_region(cxlr, ctx);
 	if (rc) {
-		devm_release_action(port->uport_dev, unregister_region, cxlr);
+		unregister_region(cxlr);
 		return ERR_PTR(rc);
 	}
 
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 3900a0778571d4..f43abd1903ce96 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -360,6 +360,8 @@ struct cxl_rd_ops {
  * @region_id: region id for next region provisioning event
  * @platform_data: platform specific configuration data
  * @regions_lock: sync region discovery, construction, and deletion
+ * @regions: regions to remove at root decoder destruct time
+ * @dead: root decoder dead to region creation
  * @qos_class: QoS performance class cookie
  * @ops: CXL root decoder operations
  * @cxlsd: base cxl switch decoder
@@ -370,6 +372,8 @@ struct cxl_root_decoder {
 	atomic_t region_id;
 	void *platform_data;
 	struct mutex regions_lock;
+	struct xarray regions;
+	bool dead;
 	int qos_class;
 	struct cxl_rd_ops ops;
 	struct cxl_switch_decoder cxlsd;
-- 
2.53.0



