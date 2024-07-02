Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD901BF330;
	Tue,  2 Jul 2024 17:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940672; cv=none; b=YAoBwP3qnuELPee3fZVsCEKmtYT9m498JcUSQPA0m+PhDTWruBgq+GHEZL/UPiMvfjYP4w25hi89JNbCPzUU8QoFF+1Ha7uuw10h74XahGTQ2UCWhA0z+BH8w+v0dp8U+oDT731Shxw49RHQKZDZCKQsDmyvdmVcfE64soG1dwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940672; c=relaxed/simple;
	bh=y52D/E0EnRNovkGK5J47xVcWMolxnKtyBmP4duKG3vA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YZJp6ZP66E6Rbr79TRHTEUfw+uhXoHLDDDEQFsE9uXcY6hVCg60Z2IeDPAEkTkGQTcUwA38hoUr3Tv8z4OgNbOlGfChoxKLEb+rdDftjPQQNhrOsvAWvxNVxEzbOWcPD2DnL0XICgFZdt1AX0Z+CNgcV7rzxAae18TiAxMc3BeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jbb1PAMs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jbb1PAMs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 853D6C116B1;
	Tue,  2 Jul 2024 17:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940672;
	bh=y52D/E0EnRNovkGK5J47xVcWMolxnKtyBmP4duKG3vA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jbb1PAMsYAip45PlhIK5b1/0FqA5FXXy4N09fXXeh4945VhF1/G2UwCCBCYb4C3oc
	 jz1krI7ud2NoBiivw0uvevk0krdoHQlIhSFd5WipO3pZEWfOrBtxmHLMm7OZYVBITs
	 gJGeCYFd4JPe/fHxp04Fx2T0NQJQOpQ/LeI33xP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 218/222] cxl/region: Move cxl_dpa_to_region() work to the region driver
Date: Tue,  2 Jul 2024 19:04:16 +0200
Message-ID: <20240702170252.320896347@linuxfoundation.org>
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

From: Alison Schofield <alison.schofield@intel.com>

[ Upstream commit b98d042698a32518c93e47730e9ad86b387a9c21 ]

This helper belongs in the region driver as it is only useful
with CONFIG_CXL_REGION. Add a stub in core.h for when the region
driver is not built.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Link: https://lore.kernel.org/r/05e30f788d62b3dd398aff2d2ea50a6aaa7c3313.1714496730.git.alison.schofield@intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Stable-dep-of: 285f2a088414 ("cxl/region: Avoid null pointer dereference in region lookup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/core.h   |  7 +++++++
 drivers/cxl/core/memdev.c | 44 ---------------------------------------
 drivers/cxl/core/region.c | 44 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 51 insertions(+), 44 deletions(-)

diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index bc5a95665aa0a..87008505f8a9e 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -27,7 +27,14 @@ void cxl_decoder_kill_region(struct cxl_endpoint_decoder *cxled);
 int cxl_region_init(void);
 void cxl_region_exit(void);
 int cxl_get_poison_by_endpoint(struct cxl_port *port);
+struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa);
+
 #else
+static inline
+struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa)
+{
+	return NULL;
+}
 static inline int cxl_get_poison_by_endpoint(struct cxl_port *port)
 {
 	return 0;
diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
index d4e259f3a7e91..0277726afd049 100644
--- a/drivers/cxl/core/memdev.c
+++ b/drivers/cxl/core/memdev.c
@@ -251,50 +251,6 @@ int cxl_trigger_poison_list(struct cxl_memdev *cxlmd)
 }
 EXPORT_SYMBOL_NS_GPL(cxl_trigger_poison_list, CXL);
 
-struct cxl_dpa_to_region_context {
-	struct cxl_region *cxlr;
-	u64 dpa;
-};
-
-static int __cxl_dpa_to_region(struct device *dev, void *arg)
-{
-	struct cxl_dpa_to_region_context *ctx = arg;
-	struct cxl_endpoint_decoder *cxled;
-	u64 dpa = ctx->dpa;
-
-	if (!is_endpoint_decoder(dev))
-		return 0;
-
-	cxled = to_cxl_endpoint_decoder(dev);
-	if (!cxled->dpa_res || !resource_size(cxled->dpa_res))
-		return 0;
-
-	if (dpa > cxled->dpa_res->end || dpa < cxled->dpa_res->start)
-		return 0;
-
-	dev_dbg(dev, "dpa:0x%llx mapped in region:%s\n", dpa,
-		dev_name(&cxled->cxld.region->dev));
-
-	ctx->cxlr = cxled->cxld.region;
-
-	return 1;
-}
-
-static struct cxl_region *cxl_dpa_to_region(struct cxl_memdev *cxlmd, u64 dpa)
-{
-	struct cxl_dpa_to_region_context ctx;
-	struct cxl_port *port;
-
-	ctx = (struct cxl_dpa_to_region_context) {
-		.dpa = dpa,
-	};
-	port = cxlmd->endpoint;
-	if (port && is_cxl_endpoint(port) && cxl_num_decoders_committed(port))
-		device_for_each_child(&port->dev, &ctx, __cxl_dpa_to_region);
-
-	return ctx.cxlr;
-}
-
 static int cxl_validate_poison_dpa(struct cxl_memdev *cxlmd, u64 dpa)
 {
 	struct cxl_dev_state *cxlds = cxlmd->cxlds;
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 857afc8b72ff1..52061edf4bd97 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -2679,6 +2679,50 @@ int cxl_get_poison_by_endpoint(struct cxl_port *port)
 	return rc;
 }
 
+struct cxl_dpa_to_region_context {
+	struct cxl_region *cxlr;
+	u64 dpa;
+};
+
+static int __cxl_dpa_to_region(struct device *dev, void *arg)
+{
+	struct cxl_dpa_to_region_context *ctx = arg;
+	struct cxl_endpoint_decoder *cxled;
+	u64 dpa = ctx->dpa;
+
+	if (!is_endpoint_decoder(dev))
+		return 0;
+
+	cxled = to_cxl_endpoint_decoder(dev);
+	if (!cxled->dpa_res || !resource_size(cxled->dpa_res))
+		return 0;
+
+	if (dpa > cxled->dpa_res->end || dpa < cxled->dpa_res->start)
+		return 0;
+
+	dev_dbg(dev, "dpa:0x%llx mapped in region:%s\n", dpa,
+		dev_name(&cxled->cxld.region->dev));
+
+	ctx->cxlr = cxled->cxld.region;
+
+	return 1;
+}
+
+struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa)
+{
+	struct cxl_dpa_to_region_context ctx;
+	struct cxl_port *port;
+
+	ctx = (struct cxl_dpa_to_region_context) {
+		.dpa = dpa,
+	};
+	port = cxlmd->endpoint;
+	if (port && is_cxl_endpoint(port) && cxl_num_decoders_committed(port))
+		device_for_each_child(&port->dev, &ctx, __cxl_dpa_to_region);
+
+	return ctx.cxlr;
+}
+
 static struct lock_class_key cxl_pmem_region_key;
 
 static int cxl_pmem_region_alloc(struct cxl_region *cxlr)
-- 
2.43.0



