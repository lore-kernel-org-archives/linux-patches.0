Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF56E1C0DEA;
	Tue,  2 Jul 2024 17:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940632; cv=none; b=Lz50QcQoYd3A4qyc/D6r1C0YzNR/1bFJ4gpFgOZefXPdHT/Tnc0PLPUekeDLwf4S3jQVM3j0CoQMjlWgVPAjtqTM9CVwPLdW69lZjdcHGQbi5qAUA54aJOmfHSiLGbor0jGSgB4t+FcrNBqv+jmrUd+i/bOVXoqqdoYO54j78lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940632; c=relaxed/simple;
	bh=HA8mZCIT1oCF4gg9Nko89ywZI86WW+IkaPb9fSbkprI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KpX9AiAOCuBaQxT7RUgwpkCz2vmmz6IQMsUhuLM0Srdb+7ziHSLJZYGlsf9Ahl++bdp539PuvLU3J3mmH8NOUrLWu91NSkd3RSc2fH5OptAt6o3d8vdpWlFltHq7Mx9AnhuLvFIZJMBdHzbbfb5nijVeSRn1lPQ+JTKah8P7uv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gZGRYFf/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gZGRYFf/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C48AC116B1;
	Tue,  2 Jul 2024 17:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940632;
	bh=HA8mZCIT1oCF4gg9Nko89ywZI86WW+IkaPb9fSbkprI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gZGRYFf/6mU0cH/GqkC0eCo1dhsMgtmgi58ubX5Y3NEPh1Rv+oxuy2y+6S2Nn5igW
	 D83iNCpPs1A6hXuGQYbG51lMQNqWHCJjADFVQG4Gvap27AnWxdfkT3ACPTA8kA7OHQ
	 P+OflJh5zinQcvmWoJEWhVlWwKwTg5A01G0UzOIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Zhijian <lizhijian@fujitsu.com>,
	Jonathan Cameron <Jonathan.Cameron@Huawei.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 212/222] cxl/region: Convert cxl_pmem_region_alloc to scope-based resource management
Date: Tue,  2 Jul 2024 19:04:10 +0200
Message-ID: <20240702170252.089778206@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

[ Upstream commit d357dd8ad2f154376e5cb930284e7bf4fe21ffaa ]

A recent bugfix to cxl_pmem_region_alloc() to fix an
error-unwind-memleak [1], highlighted a use case for scope-based resource
management.

Delete the goto for releasing @cxl_region_rwsem, and return error codes
directly from error condition paths.

The caller, devm_cxl_add_pmem_region(), is no longer given @cxlr_pmem
directly it must retrieve it from @cxlr->cxlr_pmem. This retrieval from
@cxlr was already in place for @cxlr->cxl_nvb, and converting
cxl_pmem_region_alloc() to return an int makes it less awkward to handle
no_free_ptr().

Cc: Li Zhijian <lizhijian@fujitsu.com>
Reported-by: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
Closes: http://lore.kernel.org/r/20240430174540.000039ce@Huawei.com
Link: http://lore.kernel.org/r/20240428030748.318985-1-lizhijian@fujitsu.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Link: https://lore.kernel.org/r/171451430965.1147997.15782562063090960666.stgit@dwillia2-xfh.jf.intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Stable-dep-of: 84ec985944ef ("cxl/mem: Fix no cxl_nvd during pmem region auto-assembling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/region.c | 43 ++++++++++++++++-----------------------
 1 file changed, 17 insertions(+), 26 deletions(-)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 18b95149640b6..bcb30e04e0963 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -2681,26 +2681,21 @@ int cxl_get_poison_by_endpoint(struct cxl_port *port)
 
 static struct lock_class_key cxl_pmem_region_key;
 
-static struct cxl_pmem_region *cxl_pmem_region_alloc(struct cxl_region *cxlr)
+static int cxl_pmem_region_alloc(struct cxl_region *cxlr)
 {
 	struct cxl_region_params *p = &cxlr->params;
 	struct cxl_nvdimm_bridge *cxl_nvb;
-	struct cxl_pmem_region *cxlr_pmem;
 	struct device *dev;
 	int i;
 
-	down_read(&cxl_region_rwsem);
-	if (p->state != CXL_CONFIG_COMMIT) {
-		cxlr_pmem = ERR_PTR(-ENXIO);
-		goto out;
-	}
+	guard(rwsem_read)(&cxl_region_rwsem);
+	if (p->state != CXL_CONFIG_COMMIT)
+		return -ENXIO;
 
-	cxlr_pmem = kzalloc(struct_size(cxlr_pmem, mapping, p->nr_targets),
-			    GFP_KERNEL);
-	if (!cxlr_pmem) {
-		cxlr_pmem = ERR_PTR(-ENOMEM);
-		goto out;
-	}
+	struct cxl_pmem_region *cxlr_pmem __free(kfree) =
+		kzalloc(struct_size(cxlr_pmem, mapping, p->nr_targets), GFP_KERNEL);
+	if (!cxlr_pmem)
+		return -ENOMEM;
 
 	cxlr_pmem->hpa_range.start = p->res->start;
 	cxlr_pmem->hpa_range.end = p->res->end;
@@ -2718,11 +2713,8 @@ static struct cxl_pmem_region *cxl_pmem_region_alloc(struct cxl_region *cxlr)
 		 */
 		if (i == 0) {
 			cxl_nvb = cxl_find_nvdimm_bridge(cxlmd);
-			if (!cxl_nvb) {
-				kfree(cxlr_pmem);
-				cxlr_pmem = ERR_PTR(-ENODEV);
-				goto out;
-			}
+			if (!cxl_nvb)
+				return -ENODEV;
 			cxlr->cxl_nvb = cxl_nvb;
 		}
 		m->cxlmd = cxlmd;
@@ -2733,18 +2725,16 @@ static struct cxl_pmem_region *cxl_pmem_region_alloc(struct cxl_region *cxlr)
 	}
 
 	dev = &cxlr_pmem->dev;
-	cxlr_pmem->cxlr = cxlr;
-	cxlr->cxlr_pmem = cxlr_pmem;
 	device_initialize(dev);
 	lockdep_set_class(&dev->mutex, &cxl_pmem_region_key);
 	device_set_pm_not_required(dev);
 	dev->parent = &cxlr->dev;
 	dev->bus = &cxl_bus_type;
 	dev->type = &cxl_pmem_region_type;
-out:
-	up_read(&cxl_region_rwsem);
+	cxlr_pmem->cxlr = cxlr;
+	cxlr->cxlr_pmem = no_free_ptr(cxlr_pmem);
 
-	return cxlr_pmem;
+	return 0;
 }
 
 static void cxl_dax_region_release(struct device *dev)
@@ -2861,9 +2851,10 @@ static int devm_cxl_add_pmem_region(struct cxl_region *cxlr)
 	struct device *dev;
 	int rc;
 
-	cxlr_pmem = cxl_pmem_region_alloc(cxlr);
-	if (IS_ERR(cxlr_pmem))
-		return PTR_ERR(cxlr_pmem);
+	rc = cxl_pmem_region_alloc(cxlr);
+	if (rc)
+		return rc;
+	cxlr_pmem = cxlr->cxlr_pmem;
 	cxl_nvb = cxlr->cxl_nvb;
 
 	dev = &cxlr_pmem->dev;
-- 
2.43.0



