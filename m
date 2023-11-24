Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9492B2C85B;
	Fri, 24 Nov 2023 18:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZX3cjXvG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 208A5C433C7;
	Fri, 24 Nov 2023 18:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852310;
	bh=Nj0o0d/rydMfnLBCClHwSzaqMySpwSv7vPiBPlMSHBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZX3cjXvGp1x/XI0Lksva7hC1WDhUN5CZHieSmfFj6xqL+KlBLj0rU+mVGARwZcRDL
	 A6ffQA4tcHwXT3tdxUzP7x3N4rNIUmer5py8zWZIemiNOPJI/79qFo9El/eOANPaew
	 tQ5TOzDnNR8Bqg8mp5AmtlCdEGn/v8QdlqUhdeuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vishal Verma <vishal.l.verma@intel.com>,
	Fan Ni <fan.ni@samsung.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 297/372] cxl/region: Move region-position validation to a helper
Date: Fri, 24 Nov 2023 17:51:24 +0000
Message-ID: <20231124172020.328901558@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

[ Upstream commit 9995576cef48dcbb0ba3de068292ed14f72fa0eb ]

In preparation for region autodiscovery, that needs all devices
discovered before their relative position in the region can be
determined, consolidate all position dependent validation in a helper.

Recall that in the on-demand region creation flow the end-user picks the
position of a given endpoint decoder in a region. In the autodiscovery
case the position of an endpoint decoder can only be determined after
all other endpoint decoders that claim to decode the region's address
range have been enumerated and attached. So, in the autodiscovery case
endpoint decoders may be attached before their relative position is
known. Once all decoders arrive, then positions can be determined and
validated with cxl_region_validate_position() the same as user initiated
on-demand creation.

Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
Tested-by: Fan Ni <fan.ni@samsung.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Link: https://lore.kernel.org/r/167601997584.1924368.4615769326126138969.stgit@dwillia2-xfh.jf.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Stable-dep-of: 0718588c7aaa ("cxl/region: Do not try to cleanup after cxl_region_setup_targets() fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/region.c | 119 ++++++++++++++++++++++++--------------
 1 file changed, 76 insertions(+), 43 deletions(-)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index bd1c511bba987..1ee51327e989d 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -1181,35 +1181,13 @@ static int cxl_region_setup_targets(struct cxl_region *cxlr)
 	return 0;
 }
 
-static int cxl_region_attach(struct cxl_region *cxlr,
-			     struct cxl_endpoint_decoder *cxled, int pos)
+static int cxl_region_validate_position(struct cxl_region *cxlr,
+					struct cxl_endpoint_decoder *cxled,
+					int pos)
 {
-	struct cxl_root_decoder *cxlrd = to_cxl_root_decoder(cxlr->dev.parent);
 	struct cxl_memdev *cxlmd = cxled_to_memdev(cxled);
-	struct cxl_port *ep_port, *root_port, *iter;
 	struct cxl_region_params *p = &cxlr->params;
-	struct cxl_dport *dport;
-	int i, rc = -ENXIO;
-
-	if (cxled->mode != cxlr->mode) {
-		dev_dbg(&cxlr->dev, "%s region mode: %d mismatch: %d\n",
-			dev_name(&cxled->cxld.dev), cxlr->mode, cxled->mode);
-		return -EINVAL;
-	}
-
-	if (cxled->mode == CXL_DECODER_DEAD) {
-		dev_dbg(&cxlr->dev, "%s dead\n", dev_name(&cxled->cxld.dev));
-		return -ENODEV;
-	}
-
-	/* all full of members, or interleave config not established? */
-	if (p->state > CXL_CONFIG_INTERLEAVE_ACTIVE) {
-		dev_dbg(&cxlr->dev, "region already active\n");
-		return -EBUSY;
-	} else if (p->state < CXL_CONFIG_INTERLEAVE_ACTIVE) {
-		dev_dbg(&cxlr->dev, "interleave config missing\n");
-		return -ENXIO;
-	}
+	int i;
 
 	if (pos < 0 || pos >= p->interleave_ways) {
 		dev_dbg(&cxlr->dev, "position %d out of range %d\n", pos,
@@ -1248,6 +1226,71 @@ static int cxl_region_attach(struct cxl_region *cxlr,
 		}
 	}
 
+	return 0;
+}
+
+static int cxl_region_attach_position(struct cxl_region *cxlr,
+				      struct cxl_root_decoder *cxlrd,
+				      struct cxl_endpoint_decoder *cxled,
+				      const struct cxl_dport *dport, int pos)
+{
+	struct cxl_memdev *cxlmd = cxled_to_memdev(cxled);
+	struct cxl_port *iter;
+	int rc;
+
+	if (cxlrd->calc_hb(cxlrd, pos) != dport) {
+		dev_dbg(&cxlr->dev, "%s:%s invalid target position for %s\n",
+			dev_name(&cxlmd->dev), dev_name(&cxled->cxld.dev),
+			dev_name(&cxlrd->cxlsd.cxld.dev));
+		return -ENXIO;
+	}
+
+	for (iter = cxled_to_port(cxled); !is_cxl_root(iter);
+	     iter = to_cxl_port(iter->dev.parent)) {
+		rc = cxl_port_attach_region(iter, cxlr, cxled, pos);
+		if (rc)
+			goto err;
+	}
+
+	return 0;
+
+err:
+	for (iter = cxled_to_port(cxled); !is_cxl_root(iter);
+	     iter = to_cxl_port(iter->dev.parent))
+		cxl_port_detach_region(iter, cxlr, cxled);
+	return rc;
+}
+
+static int cxl_region_attach(struct cxl_region *cxlr,
+			     struct cxl_endpoint_decoder *cxled, int pos)
+{
+	struct cxl_root_decoder *cxlrd = to_cxl_root_decoder(cxlr->dev.parent);
+	struct cxl_memdev *cxlmd = cxled_to_memdev(cxled);
+	struct cxl_region_params *p = &cxlr->params;
+	struct cxl_port *ep_port, *root_port;
+	struct cxl_dport *dport;
+	int rc = -ENXIO;
+
+	if (cxled->mode != cxlr->mode) {
+		dev_dbg(&cxlr->dev, "%s region mode: %d mismatch: %d\n",
+			dev_name(&cxled->cxld.dev), cxlr->mode, cxled->mode);
+		return -EINVAL;
+	}
+
+	if (cxled->mode == CXL_DECODER_DEAD) {
+		dev_dbg(&cxlr->dev, "%s dead\n", dev_name(&cxled->cxld.dev));
+		return -ENODEV;
+	}
+
+	/* all full of members, or interleave config not established? */
+	if (p->state > CXL_CONFIG_INTERLEAVE_ACTIVE) {
+		dev_dbg(&cxlr->dev, "region already active\n");
+		return -EBUSY;
+	} else if (p->state < CXL_CONFIG_INTERLEAVE_ACTIVE) {
+		dev_dbg(&cxlr->dev, "interleave config missing\n");
+		return -ENXIO;
+	}
+
 	ep_port = cxled_to_port(cxled);
 	root_port = cxlrd_to_port(cxlrd);
 	dport = cxl_find_dport_by_dev(root_port, ep_port->host_bridge);
@@ -1258,13 +1301,6 @@ static int cxl_region_attach(struct cxl_region *cxlr,
 		return -ENXIO;
 	}
 
-	if (cxlrd->calc_hb(cxlrd, pos) != dport) {
-		dev_dbg(&cxlr->dev, "%s:%s invalid target position for %s\n",
-			dev_name(&cxlmd->dev), dev_name(&cxled->cxld.dev),
-			dev_name(&cxlrd->cxlsd.cxld.dev));
-		return -ENXIO;
-	}
-
 	if (cxled->cxld.target_type != cxlr->type) {
 		dev_dbg(&cxlr->dev, "%s:%s type mismatch: %d vs %d\n",
 			dev_name(&cxlmd->dev), dev_name(&cxled->cxld.dev),
@@ -1288,12 +1324,13 @@ static int cxl_region_attach(struct cxl_region *cxlr,
 		return -EINVAL;
 	}
 
-	for (iter = ep_port; !is_cxl_root(iter);
-	     iter = to_cxl_port(iter->dev.parent)) {
-		rc = cxl_port_attach_region(iter, cxlr, cxled, pos);
-		if (rc)
-			goto err;
-	}
+	rc = cxl_region_validate_position(cxlr, cxled, pos);
+	if (rc)
+		return rc;
+
+	rc = cxl_region_attach_position(cxlr, cxlrd, cxled, dport, pos);
+	if (rc)
+		return rc;
 
 	p->targets[pos] = cxled;
 	cxled->pos = pos;
@@ -1319,10 +1356,6 @@ static int cxl_region_attach(struct cxl_region *cxlr,
 	p->nr_targets--;
 	cxled->pos = -1;
 	p->targets[pos] = NULL;
-err:
-	for (iter = ep_port; !is_cxl_root(iter);
-	     iter = to_cxl_port(iter->dev.parent))
-		cxl_port_detach_region(iter, cxlr, cxled);
 	return rc;
 }
 
-- 
2.42.0



