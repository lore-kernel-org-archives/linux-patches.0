Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A2638424C;
	Sat, 17 Oct 2026 18:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260519; cv=none; b=I2GMEWCXWBT1dTNo2IXyZag0DqbK1LxwmeOohGJVeGUyM56LDOahF26abhP+upb+0t0PvO/v2G4ZFQZ4YfXVQEZhHpCIAR6U0Cvr/nmKOfOosB9fi1i1sjaRveCYrZlKqkBBDYsvN/TiTv+MIl00vA57jchIF2ueS2xtFocthHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260519; c=relaxed/simple;
	bh=gCaPyzzoEFNS/leZFH+3X5MhdCEjhp18GAoLzaejU+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t+0naiwySEETwNXpvQXLFKsnPTHKyybcjRULV759CX/3ArRcjnQVDO8qX6oUzDKHJ5ltOB2C4staPrkbylnrm8iLQjOMKkRdnMO2pA4YfQal02p8p6ME81g3L5dpmrHwOuBIy/2XJlw7gtLKLzsTGhmo8z+cOdfTOeM6HO7n7gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OfhteGgN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OfhteGgN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E9341F000C4;
	Sat, 17 Oct 2026 18:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260517;
	bh=RPSJfgHOcsnnu0TAP6H/X+R7hB3FWwROCLmoxm5ZnY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OfhteGgNFtQ7BYTS+wD2Vu7eh46DC24ydjMQA2VT2We3MqMbx8gsfOXkSyI0QJXa7
	 1LSKpq9SE2tENc+rtwn67H9ObCgBF6yuz3F8gKRm1/+2zZrg2dlNA09ZqECMHaGIhQ
	 UdHiAK8qpPaZobvlBoj+aYdYIiY1PPJ42ZVlpfPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sungwoo Kim <iam@sung-woo.kim>,
	Dan Williams <djbw@kernel.org>,
	Alejandro Lucero <alucerop@amd.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1570/1674] cxl/region: Resolve region deletion races
Date: Sat, 17 Oct 2026 18:04:02 +0200
Message-ID: <20261017160511.401456530@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
 drivers/cxl/core/port.c   |  5 +++
 drivers/cxl/core/region.c | 65 ++++++++++++++++++++++-----------------
 drivers/cxl/cxl.h         |  4 +++
 4 files changed, 48 insertions(+), 28 deletions(-)

diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index 6444cc827c9ce..3f05fa7c65a75 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -28,6 +28,7 @@ int cxl_region_init(void);
 void cxl_region_exit(void);
 int cxl_get_poison_by_endpoint(struct cxl_port *port);
 struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa);
+void kill_regions(struct cxl_root_decoder *cxlrd);
 
 #else
 static inline
@@ -42,6 +43,7 @@ static inline int cxl_get_poison_by_endpoint(struct cxl_port *port)
 static inline void cxl_decoder_kill_region(struct cxl_endpoint_decoder *cxled)
 {
 }
+static inline void kill_regions(struct cxl_root_decoder *cxlrd) { };
 static inline int cxl_region_init(void)
 {
 	return 0;
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 7746e2691802c..2589354b0ca44 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -433,6 +433,8 @@ static void cxl_root_decoder_release(struct device *dev)
 
 	if (atomic_read(&cxlrd->region_id) >= 0)
 		memregion_free(atomic_read(&cxlrd->region_id));
+	mutex_destroy(&cxlrd->regions_lock);
+	xa_destroy(&cxlrd->regions);
 	__cxl_decoder_release(&cxlrd->cxlsd.cxld);
 	kfree(cxlrd);
 }
@@ -1708,6 +1710,7 @@ struct cxl_root_decoder *cxl_root_decoder_alloc(struct cxl_port *port,
 
 	cxlrd->calc_hb = calc_hb;
 	mutex_init(&cxlrd->regions_lock);
+	xa_init(&cxlrd->regions);
 
 	cxld = &cxlsd->cxld;
 	cxld->dev.type = &cxl_decoder_root_type;
@@ -1894,6 +1897,8 @@ static void cxld_unregister(void *dev)
 		cxled = to_cxl_endpoint_decoder(dev);
 		cxl_decoder_kill_region(cxled);
 	}
+	if (is_root_decoder(dev))
+		kill_regions(to_cxl_root_decoder(dev));
 
 	device_unregister(dev);
 }
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 5fc2a6a50ae94..873ee24a34317 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -2193,13 +2193,14 @@ static struct cxl_region *to_cxl_region(struct device *dev)
 	return container_of(dev, struct cxl_region, dev);
 }
 
-static void unregister_region(void *dev)
+static void unregister_region(struct cxl_region *cxlr)
 {
-	struct cxl_region *cxlr = to_cxl_region(dev);
+	struct cxl_root_decoder *cxlrd = to_cxl_root_decoder(cxlr->dev.parent);
 	struct cxl_region_params *p = &cxlr->params;
 	int i;
 
-	device_del(dev);
+	xa_erase(&cxlrd->regions, cxlr->id);
+	device_del(&cxlr->dev);
 
 	/*
 	 * Now that region sysfs is shutdown, the parameter block is now
@@ -2210,7 +2211,7 @@ static void unregister_region(void *dev)
 		detach_target(cxlr, i);
 
 	cxl_region_iomem_release(cxlr);
-	put_device(dev);
+	put_device(&cxlr->dev);
 }
 
 static struct lock_class_key cxl_region_key;
@@ -2243,6 +2244,19 @@ static struct cxl_region *cxl_region_alloc(struct cxl_root_decoder *cxlrd, int i
 	return cxlr;
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
@@ -2281,9 +2295,11 @@ static struct cxl_region *devm_cxl_add_region(struct cxl_root_decoder *cxlrd,
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
@@ -2316,6 +2332,9 @@ static struct cxl_region *__create_region(struct cxl_root_decoder *cxlrd,
 {
 	int rc;
 
+	if (cxlrd->dead)
+		return ERR_PTR(-ENXIO);
+
 	switch (mode) {
 	case CXL_DECODER_RAM:
 	case CXL_DECODER_PMEM:
@@ -2407,40 +2426,31 @@ static ssize_t region_show(struct device *dev, struct device_attribute *attr,
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
 
 	rc = mutex_lock_interruptible(&cxlrd->regions_lock);
 	if (rc)
 		return rc;
 
-	cxlr = cxl_find_region_by_name(cxlrd, buf);
-	if (IS_ERR(cxlr)) {
+	rc = sscanf(buf, "region%d\n", &id);
+	if (rc != 1) {
 		mutex_unlock(&cxlrd->regions_lock);
-		return PTR_ERR(cxlr);
+		return -EINVAL;
 	}
 
-	devm_release_action(port->uport_dev, unregister_region, cxlr);
-	put_device(&cxlr->dev);
+	cxlr = xa_load(&cxlrd->regions, id);
+	if (!cxlr || !sysfs_streq(buf, dev_name(&cxlr->dev))) {
+		mutex_unlock(&cxlrd->regions_lock);
+		return -ENODEV;
+	}
+
+	unregister_region(cxlr);
 	mutex_unlock(&cxlrd->regions_lock);
 
 	return len;
@@ -2958,7 +2968,6 @@ static struct cxl_region *construct_region(struct cxl_root_decoder *cxlrd,
 					   struct cxl_endpoint_decoder *cxled)
 {
 	struct cxl_memdev *cxlmd = cxled_to_memdev(cxled);
-	struct cxl_port *port = cxlrd_to_port(cxlrd);
 	struct range *hpa = &cxled->cxld.hpa_range;
 	struct cxl_region_params *p;
 	struct cxl_region *cxlr;
@@ -3033,7 +3042,7 @@ static struct cxl_region *construct_region(struct cxl_root_decoder *cxlrd,
 
 err:
 	up_write(&cxl_region_rwsem);
-	devm_release_action(port->uport_dev, unregister_region, cxlr);
+	unregister_region(cxlr);
 	return ERR_PTR(rc);
 }
 
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 9dcc8a4d5128a..7a1b1721860d7 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -442,6 +442,8 @@ typedef struct cxl_dport *(*cxl_calc_hb_fn)(struct cxl_root_decoder *cxlrd,
  * @calc_hb: which host bridge covers the n'th position by granularity
  * @platform_data: platform specific configuration data
  * @regions_lock: sync region discovery, construction, and deletion
+ * @regions: regions to remove at root decoder destruct time
+ * @dead: root decoder dead to region creation
  * @cxlsd: base cxl switch decoder
  */
 struct cxl_root_decoder {
@@ -450,6 +452,8 @@ struct cxl_root_decoder {
 	cxl_calc_hb_fn calc_hb;
 	void *platform_data;
 	struct mutex regions_lock;
+	struct xarray regions;
+	bool dead;
 	struct cxl_switch_decoder cxlsd;
 };
 
-- 
2.53.0



