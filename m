Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB7E2C17A0;
	Wed, 25 Feb 2026 06:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002597; cv=none; b=EYCb9jiqh1PoWcc/oIGnxK39vz5bHshzAqTZemxLdwYp8VjKr2XzfDMDVCxmnqIr4PXjK/l5MC6liOiPnhvQz2VmwUrRp3cNcy8084TvbTDW3/wyKDeahjZnUolCPewkc9cUno2JLvcPOsfKi7Nv8qCHaGSTAXWHYXpuGeYleoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002597; c=relaxed/simple;
	bh=EfRLc7vfAl/5IT5mVxqK3Bv0qmt61n2Ao5W7vvNNF1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nH9z6OtCf3olICmUbPxStWAt8ASM8Glwd7ke9k5fFR7PcW09xO8YqsiGdhvx4cIj39PtNLotSDt4zWM+MTIqU6N6vY38iIIHMi9dONrSFmTmKF2K3e+9aTll8yLWbJ/h4Cq/ERN1zntxqVREd+hl9/qPr4J6pQHRJcp6Lw7H7to=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vY+6LeN+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vY+6LeN+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49C33C116D0;
	Wed, 25 Feb 2026 06:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002597;
	bh=EfRLc7vfAl/5IT5mVxqK3Bv0qmt61n2Ao5W7vvNNF1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vY+6LeN+yzVjsIWvYFWaxYKsNhRyjJI0jrMvGWxgvmYVT2Nzk2/TGSpqlsLiTSk7O
	 SK0TljrDEd7Q/BfyNsb/VenPgkMQRG/8Myp1BxQA57jlqIjd76IVuVi1pX+ZH17o3I
	 VTlQenTSuSMQfq1EUwTBpMe4x6AovbMn+R1AlP6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Shiju Jose <shiju.jose@huawei.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ben Cheatham <benjamin.cheatham@amd.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Alejandro Lucero <alucerop@amd.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 343/641] cxl/mem: Fix devm_cxl_memdev_edac_release() confusion
Date: Tue, 24 Feb 2026 17:21:09 -0800
Message-ID: <20260225012356.973167919@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Dan Williams <dan.j.williams@intel.com>

[ Upstream commit 10016118b6fade907143a32a7aeaa777063dc79c ]

A device release method is only for undoing allocations on the path to
preparing the device for device_add(). In contrast, devm allocations are
post device_add(), are acquired during / after ->probe() and are released
synchronous with ->remove().

So, a "devm" helper in a "release" method is a clear anti-pattern.

Move this devm release action where it belongs, an action created at edac
object creation time. Otherwise, this leaks resources until
cxl_memdev_release() time which may be long after these xarray and error
record caches have gone idle.

Note, this also fixes up the type of @cxlmd->err_rec_array which needlessly
dropped type-safety.

Fixes: 0b5ccb0de1e2 ("cxl/edac: Support for finding memory operation attributes from the current boot")
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Shiju Jose <shiju.jose@huawei.com>
Cc: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Ben Cheatham <benjamin.cheatham@amd.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Tested-by: Shiju Jose <shiju.jose@huawei.com>
Reviewed-by: Shiju Jose <shiju.jose@huawei.com>
Tested-by: Alejandro Lucero <alucerop@amd.com>
Link: https://patch.msgid.link/20251216005616.3090129-2-dan.j.williams@intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/edac.c   | 64 ++++++++++++++++++++++-----------------
 drivers/cxl/core/memdev.c |  1 -
 drivers/cxl/cxlmem.h      |  5 +--
 3 files changed, 38 insertions(+), 32 deletions(-)

diff --git a/drivers/cxl/core/edac.c b/drivers/cxl/core/edac.c
index 79994ca9bc9f3..81160260e26b7 100644
--- a/drivers/cxl/core/edac.c
+++ b/drivers/cxl/core/edac.c
@@ -1988,6 +1988,40 @@ static int cxl_memdev_soft_ppr_init(struct cxl_memdev *cxlmd,
 	return 0;
 }
 
+static void err_rec_free(void *_cxlmd)
+{
+	struct cxl_memdev *cxlmd = _cxlmd;
+	struct cxl_mem_err_rec *array_rec = cxlmd->err_rec_array;
+	struct cxl_event_gen_media *rec_gen_media;
+	struct cxl_event_dram *rec_dram;
+	unsigned long index;
+
+	cxlmd->err_rec_array = NULL;
+	xa_for_each(&array_rec->rec_dram, index, rec_dram)
+		kfree(rec_dram);
+	xa_destroy(&array_rec->rec_dram);
+
+	xa_for_each(&array_rec->rec_gen_media, index, rec_gen_media)
+		kfree(rec_gen_media);
+	xa_destroy(&array_rec->rec_gen_media);
+	kfree(array_rec);
+}
+
+static int devm_cxl_memdev_setup_err_rec(struct cxl_memdev *cxlmd)
+{
+	struct cxl_mem_err_rec *array_rec =
+		kzalloc(sizeof(*array_rec), GFP_KERNEL);
+
+	if (!array_rec)
+		return -ENOMEM;
+
+	xa_init(&array_rec->rec_gen_media);
+	xa_init(&array_rec->rec_dram);
+	cxlmd->err_rec_array = array_rec;
+
+	return devm_add_action_or_reset(&cxlmd->dev, err_rec_free, cxlmd);
+}
+
 int devm_cxl_memdev_edac_register(struct cxl_memdev *cxlmd)
 {
 	struct edac_dev_feature ras_features[CXL_NR_EDAC_DEV_FEATURES];
@@ -2038,15 +2072,9 @@ int devm_cxl_memdev_edac_register(struct cxl_memdev *cxlmd)
 		}
 
 		if (repair_inst) {
-			struct cxl_mem_err_rec *array_rec =
-				devm_kzalloc(&cxlmd->dev, sizeof(*array_rec),
-					     GFP_KERNEL);
-			if (!array_rec)
-				return -ENOMEM;
-
-			xa_init(&array_rec->rec_gen_media);
-			xa_init(&array_rec->rec_dram);
-			cxlmd->err_rec_array = array_rec;
+			rc = devm_cxl_memdev_setup_err_rec(cxlmd);
+			if (rc)
+				return rc;
 		}
 	}
 
@@ -2088,22 +2116,4 @@ int devm_cxl_region_edac_register(struct cxl_region *cxlr)
 }
 EXPORT_SYMBOL_NS_GPL(devm_cxl_region_edac_register, "CXL");
 
-void devm_cxl_memdev_edac_release(struct cxl_memdev *cxlmd)
-{
-	struct cxl_mem_err_rec *array_rec = cxlmd->err_rec_array;
-	struct cxl_event_gen_media *rec_gen_media;
-	struct cxl_event_dram *rec_dram;
-	unsigned long index;
-
-	if (!IS_ENABLED(CONFIG_CXL_EDAC_MEM_REPAIR) || !array_rec)
-		return;
-
-	xa_for_each(&array_rec->rec_dram, index, rec_dram)
-		kfree(rec_dram);
-	xa_destroy(&array_rec->rec_dram);
 
-	xa_for_each(&array_rec->rec_gen_media, index, rec_gen_media)
-		kfree(rec_gen_media);
-	xa_destroy(&array_rec->rec_gen_media);
-}
-EXPORT_SYMBOL_NS_GPL(devm_cxl_memdev_edac_release, "CXL");
diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
index e370d733e4400..4dff7f44d908e 100644
--- a/drivers/cxl/core/memdev.c
+++ b/drivers/cxl/core/memdev.c
@@ -27,7 +27,6 @@ static void cxl_memdev_release(struct device *dev)
 	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
 
 	ida_free(&cxl_memdev_ida, cxlmd->id);
-	devm_cxl_memdev_edac_release(cxlmd);
 	kfree(cxlmd);
 }
 
diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index 434031a0c1f74..c12ab4fc95123 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -63,7 +63,7 @@ struct cxl_memdev {
 	int depth;
 	u8 scrub_cycle;
 	int scrub_region_id;
-	void *err_rec_array;
+	struct cxl_mem_err_rec *err_rec_array;
 };
 
 static inline struct cxl_memdev *to_cxl_memdev(struct device *dev)
@@ -877,7 +877,6 @@ int devm_cxl_memdev_edac_register(struct cxl_memdev *cxlmd);
 int devm_cxl_region_edac_register(struct cxl_region *cxlr);
 int cxl_store_rec_gen_media(struct cxl_memdev *cxlmd, union cxl_event *evt);
 int cxl_store_rec_dram(struct cxl_memdev *cxlmd, union cxl_event *evt);
-void devm_cxl_memdev_edac_release(struct cxl_memdev *cxlmd);
 #else
 static inline int devm_cxl_memdev_edac_register(struct cxl_memdev *cxlmd)
 { return 0; }
@@ -889,8 +888,6 @@ static inline int cxl_store_rec_gen_media(struct cxl_memdev *cxlmd,
 static inline int cxl_store_rec_dram(struct cxl_memdev *cxlmd,
 				     union cxl_event *evt)
 { return 0; }
-static inline void devm_cxl_memdev_edac_release(struct cxl_memdev *cxlmd)
-{ return; }
 #endif
 
 #ifdef CONFIG_CXL_SUSPEND
-- 
2.51.0



