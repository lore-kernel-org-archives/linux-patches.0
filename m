Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E57036606A;
	Sat, 12 Sep 2026 07:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198616; cv=none; b=g1TAlFGReYF0A5xc1vEAMdpav2H6YVXM7O9+ur998PJFQfBm4QgWoTA7u/BTTrxTyrD8GeDT1ArG71QMXhj7Ot3bHDkpZdJJk9N5BGOdfSAsp6RoX1lhhCwkzInWrWi/Cw1ZXW/THUoT3UbmG63LkZAyF3YDrMnE7E1PmO/OIN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198616; c=relaxed/simple;
	bh=W/CYHRLqTHcDAye/SUasTBNsVsNIBSZ93Drv8ZM1b9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i8M2QjOrBz6Pu9FkM4siIMdZOgxmObXYDSpY037PKt7EJBb2FHibGaYCOjL/pyI659Tbs5Lxo5aVWW41xo1rjIHdyrjX0ceS6SACxz+EM5ofL3pXGolNfAIL+1tdASo4vPIyjNFp9Jhx0Qi1qpmfX+USgc6fuyc7litc0xKUFzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u1my/btr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u1my/btr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 895FD1F000FF;
	Sat, 12 Sep 2026 07:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198613;
	bh=etWWreaoIBe5NCe+uvlpYcMXG2KVKqo5TTcB6wFevJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u1my/btrY/pYUyCfjCOysHfcWmB2XC2U/11jFVkgbzvc1LItPermXfpWe1qeUzcbW
	 j1draauwhlDMccIXAeQ0ttcv38Q7gk++ahZaIK3l1Eb7M7w85roESB+wqWI+3y737Z
	 n0jb80VS/U5NisXkVRZrEpkL8rFjawDmsWK0Chg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Jiang <dave.jiang@intel.com>,
	John Groves <john@groves.net>,
	Alison Schofield <alison.schofield@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0418/1815] dax/fsdev: dont leave a dangling dev_dax->pgmap on probe failure
Date: Sat, 12 Sep 2026 08:36:08 +0200
Message-ID: <20260912065658.708734384@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Groves <John@Groves.net>

[ Upstream commit caf906009d12cb21b934f1c4d17cedc6d469429f ]

After the dynamic path set dev_dax->pgmap, any later probe failure left
dev_dax->pgmap dangling: devres frees the devm_kzalloc'd pgmap on probe
failure, and subsequent probe attempts would hit the "dynamic-dax with
pre-populated page map" check and fail permanently.

Factor pgmap acquisition out into fsdev_acquire_pgmap(), and defer the
dev_dax->pgmap assignment until probe can no longer fail. A failed probe
now never publishes the pointer at all, so there is nothing to unwind.
This also matches kill_dev_dax(), which already clears the dynamic pgmap
pointer on unbind: dev_dax->pgmap is now non-NULL only while the pgmap
is actually valid.

Refactor suggested by Dave Jiang.

Fixes: d5406bd458b0a ("dax: add fsdev.c driver for fs-dax on character dax")

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: John Groves <john@groves.net>
Link: https://patch.msgid.link/0100019ecc092ca1-ffc7a5fd-1252-4be5-882c-fd5efdc102a9-000000@email.amazonses.com
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dax/fsdev.c | 77 ++++++++++++++++++++++++++++-----------------
 1 file changed, 49 insertions(+), 28 deletions(-)

diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
index dbd722ed7ab05..0fd5e1293d725 100644
--- a/drivers/dax/fsdev.c
+++ b/drivers/dax/fsdev.c
@@ -219,47 +219,62 @@ static const struct file_operations fsdev_fops = {
 	.release = fsdev_release,
 };
 
-static int fsdev_dax_probe(struct dev_dax *dev_dax)
+/*
+ * Acquire the dev_pagemap for probe: the static (pre-populated) one if
+ * present, or a devm-allocated one for the dynamic case. Note that
+ * dev_dax->pgmap is not set here; fsdev_dax_probe() sets it only once
+ * probe succeeds, so a failed probe never leaves a dangling pointer
+ * to a devres-freed pgmap.
+ */
+static struct dev_pagemap *fsdev_acquire_pgmap(struct dev_dax *dev_dax)
 {
-	struct dax_device *dax_dev = dev_dax->dax_dev;
 	struct device *dev = &dev_dax->dev;
 	struct dev_pagemap *pgmap;
-	struct inode *inode;
-	u64 data_offset = 0;
-	struct cdev *cdev;
-	void *addr;
-	int rc, i;
+	size_t pgmap_size;
 
 	if (static_dev_dax(dev_dax)) {
 		if (dev_dax->nr_range > 1) {
-			dev_warn(dev, "static pgmap / multi-range device conflict\n");
-			return -EINVAL;
+			dev_warn(dev,
+				 "static pgmap / multi-range device conflict\n");
+			return ERR_PTR(-EINVAL);
 		}
 
 		pgmap = dev_dax->pgmap;
 		pgmap->vmemmap_shift = 0;
-	} else {
-		size_t pgmap_size;
+		return pgmap;
+	}
 
-		if (dev_dax->pgmap) {
-			dev_warn(dev, "dynamic-dax with pre-populated page map\n");
-			return -EINVAL;
-		}
+	if (dev_dax->pgmap) {
+		dev_warn(dev, "dynamic-dax with pre-populated page map\n");
+		return ERR_PTR(-EINVAL);
+	}
 
-		pgmap_size = struct_size(pgmap, ranges, dev_dax->nr_range - 1);
-		pgmap = devm_kzalloc(dev, pgmap_size, GFP_KERNEL);
-		if (!pgmap)
-			return -ENOMEM;
+	pgmap_size = struct_size(pgmap, ranges, dev_dax->nr_range - 1);
+	pgmap = devm_kzalloc(dev, pgmap_size, GFP_KERNEL);
+	if (!pgmap)
+		return ERR_PTR(-ENOMEM);
 
-		pgmap->nr_range = dev_dax->nr_range;
-		dev_dax->pgmap = pgmap;
+	pgmap->nr_range = dev_dax->nr_range;
+	for (int i = 0; i < dev_dax->nr_range; i++)
+		pgmap->ranges[i] = dev_dax->ranges[i].range;
 
-		for (i = 0; i < dev_dax->nr_range; i++) {
-			struct range *range = &dev_dax->ranges[i].range;
+	return pgmap;
+}
 
-			pgmap->ranges[i] = *range;
-		}
-	}
+static int fsdev_dax_probe(struct dev_dax *dev_dax)
+{
+	struct dax_device *dax_dev = dev_dax->dax_dev;
+	struct device *dev = &dev_dax->dev;
+	struct dev_pagemap *pgmap;
+	struct inode *inode;
+	u64 data_offset = 0;
+	struct cdev *cdev;
+	void *addr;
+	int rc, i;
+
+	pgmap = fsdev_acquire_pgmap(dev_dax);
+	if (IS_ERR(pgmap))
+		return PTR_ERR(pgmap);
 
 	for (i = 0; i < dev_dax->nr_range; i++) {
 		struct range *range = &dev_dax->ranges[i].range;
@@ -306,7 +321,7 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
 	/* Detect whether the data is at a non-zero offset into the memory */
 	if (pgmap->range.start != dev_dax->ranges[0].range.start) {
 		u64 phys = dev_dax->ranges[0].range.start;
-		u64 pgmap_phys = dev_dax->pgmap[0].range.start;
+		u64 pgmap_phys = pgmap[0].range.start;
 
 		if (!WARN_ON(pgmap_phys > phys))
 			data_offset = phys - pgmap_phys;
@@ -339,7 +354,13 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
 		return rc;
 
 	run_dax(dax_dev);
-	return devm_add_action_or_reset(dev, fsdev_kill, dev_dax);
+	rc = devm_add_action_or_reset(dev, fsdev_kill, dev_dax);
+	if (rc)
+		return rc;
+
+	/* Probe can no longer fail; expose the pgmap via dev_dax */
+	dev_dax->pgmap = pgmap;
+	return 0;
 }
 
 static struct dax_device_driver fsdev_dax_driver = {
-- 
2.53.0



