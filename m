Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 655CA2C9E
	for <patches@lists.linux.dev>; Fri,  7 Jan 2022 00:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641515897; x=1673051897;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=s3YJ4k9WX1H2z3+76n68boGXnNFzvP0oVlTvKxnedTA=;
  b=VtNmug8LGjVodbsAFGKwexBiRxdgP8hT4AOc25vk4uPGHN19cRkqAIY1
   ub280vHWPrbAHsNFO+3hW/8+uve9jqv7JcSJsfPy3VicLDpriBpMf7Hnn
   QUzMzN5BgaqnxERJ9IHQM/ake7sjpqpXkqjAyPg3pGztCk1l88ZZK4PRH
   VCv+lUik/PoZItMO8DLyx/A0Lf5lJG/qMqnlrPefrXJIG1izc+SI0g6jY
   /Nuf4NteXoZB3vCnmncrTwnDEAWAqS0GXYB1YQwiTfX0LgUaSSkpvxwuI
   15DWH0idVNhOibO/JtFSuXEB0TbfA+CDHTxcjGTBGM65Tob2ZRAW66kq3
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="223466654"
X-IronPort-AV: E=Sophos;i="5.88,268,1635231600"; 
   d="scan'208";a="223466654"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 16:38:14 -0800
X-IronPort-AV: E=Sophos;i="5.88,268,1635231600"; 
   d="scan'208";a="471123252"
Received: from elenawei-mobl2.amr.corp.intel.com (HELO localhost.localdomain) ([10.252.138.104])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 16:38:14 -0800
From: Ben Widawsky <ben.widawsky@intel.com>
To: linux-cxl@vger.kernel.org,
	linux-nvdimm@lists.01.org,
	linux-pci@vger.kernel.org
Cc: patches@lists.linux.dev,
	Bjorn Helgaas <helgaas@kernel.org>,
	Ben Widawsky <ben.widawsky@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@Huawei.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH 13/13] cxl: Program decoders for regions
Date: Thu,  6 Jan 2022 16:37:56 -0800
Message-Id: <20220107003756.806582-14-ben.widawsky@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220107003756.806582-1-ben.widawsky@intel.com>
References: <20220107003756.806582-1-ben.widawsky@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Do the HDM decoder programming for all endpoints and host bridges in a
region. Switches are currently unimplemented.

Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
---
 drivers/cxl/core/hdm.c | 198 +++++++++++++++++++++++++++++++++++++++++
 drivers/cxl/cxl.h      |   3 +
 drivers/cxl/region.c   |  39 +++++++-
 3 files changed, 237 insertions(+), 3 deletions(-)

diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
index 44e48cea8cd4..c7293cbd8547 100644
--- a/drivers/cxl/core/hdm.c
+++ b/drivers/cxl/core/hdm.c
@@ -242,3 +242,201 @@ int devm_cxl_enumerate_switch_decoders(struct cxl_port *port)
 	return 0;
 }
 EXPORT_SYMBOL_NS_GPL(devm_cxl_enumerate_switch_decoders, CXL);
+
+#define COMMIT_TIMEOUT_MS 10
+static int wait_for_commit(struct cxl_decoder *cxld)
+{
+	struct cxl_port *port = to_cxl_port(cxld->dev.parent);
+	const unsigned long start = jiffies;
+	struct cxl_port_state *cxlps;
+	void __iomem *hdm_decoder;
+	unsigned long end = start;
+	u32 ctrl;
+
+	cxlps = dev_get_drvdata(&port->dev);
+	hdm_decoder = cxlps->regs.hdm_decoder;
+
+	do {
+		end = jiffies;
+		ctrl = readl(hdm_decoder +
+			     CXL_HDM_DECODER0_CTRL_OFFSET(cxld->id));
+		if (FIELD_GET(CXL_HDM_DECODER0_CTRL_COMMITTED, ctrl))
+			break;
+
+		if (time_after(end, start + COMMIT_TIMEOUT_MS)) {
+			dev_err(&cxld->dev, "HDM decoder commit timeout %x\n", ctrl);
+			return -ETIMEDOUT;
+		}
+		if ((ctrl & CXL_HDM_DECODER0_CTRL_COMMIT_ERROR) != 0) {
+			dev_err(&cxld->dev, "HDM decoder commit error %x\n", ctrl);
+			return -ENXIO;
+		}
+	} while (FIELD_GET(CXL_HDM_DECODER0_CTRL_COMMITTED, ctrl));
+
+	return 0;
+}
+
+/**
+ * cxl_commit_decoder() - Program a configured cxl_decoder
+ * @cxld: The preconfigured cxl decoder.
+ *
+ * A cxl decoder that is to be committed should have been earmarked as enabled.
+ * This mechanism acts as a soft reservation on the decoder.
+ *
+ * Returns 0 if commit was successful, negative error code otherwise.
+ */
+int cxl_commit_decoder(struct cxl_decoder *cxld)
+{
+	u32 ctrl, tl_lo, tl_hi, base_lo, base_hi, size_lo, size_hi;
+	struct cxl_port *port = to_cxl_port(cxld->dev.parent);
+	struct cxl_port_state *cxlps;
+	void __iomem *hdm_decoder;
+	int rc;
+
+	/*
+	 * Decoder flags are entirely software controlled and therefore this
+	 * case is purely a driver bug.
+	 */
+	if (dev_WARN_ONCE(&port->dev, (cxld->flags & CXL_DECODER_F_ENABLE) != 0,
+			  "Invalid %s enable state\n", dev_name(&cxld->dev)))
+		return -ENXIO;
+
+	cxlps = dev_get_drvdata(&port->dev);
+	hdm_decoder = cxlps->regs.hdm_decoder;
+	ctrl = readl(hdm_decoder + CXL_HDM_DECODER0_CTRL_OFFSET(cxld->id));
+
+	/*
+	 * A decoder that's currently active cannot be changed without the
+	 * system being quiesced. While the driver should prevent against this,
+	 * for a variety of reasons the hardware might not be in sync with the
+	 * hardware and so, do not splat on error.
+	 */
+	size_hi = readl(hdm_decoder +
+			CXL_HDM_DECODER0_SIZE_HIGH_OFFSET(cxld->id));
+	size_lo =
+		readl(hdm_decoder + CXL_HDM_DECODER0_SIZE_LOW_OFFSET(cxld->id));
+	if (FIELD_GET(CXL_HDM_DECODER0_CTRL_COMMITTED, ctrl) &&
+	    (size_lo + size_hi)) {
+		dev_err(&port->dev, "Tried to change an active decoder (%s)\n",
+			dev_name(&cxld->dev));
+		return -EBUSY;
+	}
+
+	u32p_replace_bits(&ctrl, 8 - ilog2(cxld->interleave_granularity),
+			  CXL_HDM_DECODER0_CTRL_IG_MASK);
+	u32p_replace_bits(&ctrl, ilog2(cxld->interleave_ways),
+			  CXL_HDM_DECODER0_CTRL_IW_MASK);
+	u32p_replace_bits(&ctrl, 1, CXL_HDM_DECODER0_CTRL_COMMIT);
+
+	/* TODO: set based on type */
+	u32p_replace_bits(&ctrl, 1, CXL_HDM_DECODER0_CTRL_TYPE);
+
+	base_lo = FIELD_PREP(GENMASK(31, 28),
+			     (u32)(cxld->decoder_range.start & 0xffffffff));
+	base_hi = FIELD_PREP(~0, (u32)(cxld->decoder_range.start >> 32));
+
+	size_lo = (u32)(range_len(&cxld->decoder_range)) & GENMASK(31, 28);
+	size_hi = (u32)((range_len(&cxld->decoder_range) >> 32));
+
+	if (cxld->nr_targets > 0) {
+		tl_lo |= FIELD_PREP(GENMASK(7, 0), cxld->target[0]->port_id);
+		if (cxld->interleave_ways > 1)
+			tl_lo |= FIELD_PREP(GENMASK(15, 8),
+					    cxld->target[1]->port_id);
+		if (cxld->interleave_ways > 2)
+			tl_lo |= FIELD_PREP(GENMASK(23, 16),
+					    cxld->target[2]->port_id);
+		if (cxld->interleave_ways > 3)
+			tl_lo |= FIELD_PREP(GENMASK(31, 24),
+					    cxld->target[3]->port_id);
+		if (cxld->interleave_ways > 4)
+			tl_hi |= FIELD_PREP(GENMASK(7, 0),
+					    cxld->target[4]->port_id);
+		if (cxld->interleave_ways > 5)
+			tl_hi |= FIELD_PREP(GENMASK(15, 8),
+					    cxld->target[5]->port_id);
+		if (cxld->interleave_ways > 6)
+			tl_hi |= FIELD_PREP(GENMASK(23, 16),
+					    cxld->target[6]->port_id);
+		if (cxld->interleave_ways > 7)
+			tl_hi |= FIELD_PREP(GENMASK(31, 24),
+					    cxld->target[7]->port_id);
+
+		writel(tl_hi, hdm_decoder + CXL_HDM_DECODER0_TL_HIGH(cxld->id));
+		writel(tl_lo, hdm_decoder + CXL_HDM_DECODER0_TL_LOW(cxld->id));
+	}
+
+	writel(size_hi,
+	       hdm_decoder + CXL_HDM_DECODER0_SIZE_HIGH_OFFSET(cxld->id));
+	writel(size_lo,
+	       hdm_decoder + CXL_HDM_DECODER0_SIZE_LOW_OFFSET(cxld->id));
+	writel(base_hi,
+	       hdm_decoder + CXL_HDM_DECODER0_BASE_HIGH_OFFSET(cxld->id));
+	writel(base_lo,
+	       hdm_decoder + CXL_HDM_DECODER0_BASE_LOW_OFFSET(cxld->id));
+	writel(ctrl, hdm_decoder + CXL_HDM_DECODER0_CTRL_OFFSET(cxld->id));
+
+	rc = wait_for_commit(cxld);
+	if (rc)
+		return rc;
+
+	cxld->flags |= CXL_DECODER_F_ENABLE;
+
+#define DPORT_TL_STR "%d %d %d %d %d %d %d %d"
+#define DPORT(i)                                                               \
+	(cxld->nr_targets && cxld->interleave_ways > (i)) ?                    \
+		      cxld->target[(i)]->port_id :                                   \
+		      -1
+#define DPORT_TL                                                               \
+	DPORT(0), DPORT(1), DPORT(2), DPORT(3), DPORT(4), DPORT(5), DPORT(6),  \
+		DPORT(7)
+
+	dev_dbg(&port->dev,
+		"%s\n\tBase %pa\n\tSize %llu\n\tIG %u\n\tIW %u\n\tTargetList: " DPORT_TL_STR,
+		dev_name(&cxld->dev), &cxld->decoder_range.start,
+		range_len(&cxld->decoder_range), cxld->interleave_granularity,
+		cxld->interleave_ways, DPORT_TL);
+#undef DPORT_TL
+#undef DPORT
+#undef DPORT_TL_STR
+	return 0;
+}
+EXPORT_SYMBOL_GPL(cxl_commit_decoder);
+
+/**
+ * cxl_disable_decoder() - Disables a decoder
+ * @cxld: The active cxl decoder.
+ *
+ * CXL decoders (as of 2.0 spec) have no way to deactivate them other than to
+ * set the size of the HDM to 0. This function will clear all registers, and if
+ * the decoder is active, commit the 0'd out registers.
+ */
+void cxl_disable_decoder(struct cxl_decoder *cxld)
+{
+	struct cxl_port *port = to_cxl_port(cxld->dev.parent);
+	struct cxl_port_state *cxlps;
+	void __iomem *hdm_decoder;
+	u32 ctrl;
+
+	cxlps = dev_get_drvdata(&port->dev);
+	hdm_decoder = cxlps->regs.hdm_decoder;
+	ctrl = readl(hdm_decoder + CXL_HDM_DECODER0_CTRL_OFFSET(cxld->id));
+
+	if (dev_WARN_ONCE(&port->dev, (cxld->flags & CXL_DECODER_F_ENABLE) == 0,
+			  "Invalid decoder enable state\n"))
+		return;
+
+	/* There's no way to "uncommit" a committed decoder, only 0 size it */
+	writel(0, hdm_decoder + CXL_HDM_DECODER0_TL_HIGH(cxld->id));
+	writel(0, hdm_decoder + CXL_HDM_DECODER0_TL_LOW(cxld->id));
+	writel(0, hdm_decoder + CXL_HDM_DECODER0_SIZE_HIGH_OFFSET(cxld->id));
+	writel(0, hdm_decoder + CXL_HDM_DECODER0_SIZE_LOW_OFFSET(cxld->id));
+	writel(0, hdm_decoder + CXL_HDM_DECODER0_BASE_HIGH_OFFSET(cxld->id));
+	writel(0, hdm_decoder + CXL_HDM_DECODER0_BASE_LOW_OFFSET(cxld->id));
+
+	/* If the device isn't actually active, just zero out all the fields */
+	if (FIELD_GET(CXL_HDM_DECODER0_CTRL_COMMITTED, ctrl))
+		writel(CXL_HDM_DECODER0_CTRL_COMMIT,
+		       hdm_decoder + CXL_HDM_DECODER0_CTRL_OFFSET(cxld->id));
+}
+EXPORT_SYMBOL_GPL(cxl_disable_decoder);
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 79bca9a8246c..587b75f7fa53 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -54,6 +54,7 @@
 #define   CXL_HDM_DECODER0_CTRL_IW_MASK GENMASK(7, 4)
 #define   CXL_HDM_DECODER0_CTRL_COMMIT BIT(9)
 #define   CXL_HDM_DECODER0_CTRL_COMMITTED BIT(10)
+#define   CXL_HDM_DECODER0_CTRL_COMMIT_ERROR BIT(11)
 #define   CXL_HDM_DECODER0_CTRL_TYPE BIT(12)
 #define CXL_HDM_DECODER0_TL_LOW(i) (0x20 * (i) + 0x24)
 #define CXL_HDM_DECODER0_TL_HIGH(i) (0x20 * (i) + 0x28)
@@ -364,6 +365,8 @@ int devm_cxl_add_dport(struct cxl_port *port, struct device *dport, int port_id,
 struct cxl_dport *cxl_find_dport_by_dev(struct cxl_port *port,
 					const struct device *dev);
 struct cxl_port *ep_find_cxl_port(struct cxl_memdev *cxlmd, unsigned int depth);
+int cxl_commit_decoder(struct cxl_decoder *cxld);
+void cxl_disable_decoder(struct cxl_decoder *cxld);
 
 struct cxl_decoder *to_cxl_decoder(struct device *dev);
 bool is_cxl_decoder(struct device *dev);
diff --git a/drivers/cxl/region.c b/drivers/cxl/region.c
index 3120b65b0bc5..fd82d37ba573 100644
--- a/drivers/cxl/region.c
+++ b/drivers/cxl/region.c
@@ -580,10 +580,30 @@ static void cleanup_staged_decoders(struct cxl_region *region)
 	}
 }
 
-static int bind_region(const struct cxl_region *region)
+static int bind_region(struct cxl_region *region)
 {
-	/* TODO: */
-	return 0;
+	struct cxl_decoder *cxld, *d;
+	int rc;
+
+	list_for_each_entry_safe(cxld, d, &region->staged_list, region_link) {
+		rc = cxl_commit_decoder(cxld);
+		if (!rc)
+			list_move_tail(&cxld->region_link, &region->commit_list);
+		else
+			break;
+	}
+
+	list_for_each_entry_safe(cxld, d, &region->commit_list, region_link) {
+		if (rc)
+			cxl_disable_decoder(cxld);
+		list_del(&cxld->region_link);
+	}
+
+	if (rc)
+		cleanup_staged_decoders((struct cxl_region *)region);
+
+	BUG_ON(!list_empty(&region->staged_list));
+	return rc;
 }
 
 static int cxl_region_probe(struct device *dev)
@@ -650,9 +670,22 @@ static int cxl_region_probe(struct device *dev)
 	return ret;
 }
 
+static void cxl_region_remove(struct device *dev)
+{
+	struct cxl_region *region = to_cxl_region(dev);
+	struct cxl_decoder *cxld, *d;
+
+	list_for_each_entry_safe(cxld, d, &region->commit_list, region_link) {
+		cxl_disable_decoder(cxld);
+		list_del(&cxld->region_link);
+		cxl_put_decoder(cxld);
+	}
+}
+
 static struct cxl_driver cxl_region_driver = {
 	.name = "cxl_region",
 	.probe = cxl_region_probe,
+	.remove = cxl_region_remove,
 	.id = CXL_DEVICE_REGION,
 };
 module_cxl_driver(cxl_region_driver);
-- 
2.34.1

