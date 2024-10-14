Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA7523A1B6;
	Mon, 14 Oct 2024 15:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918213; cv=none; b=tD9f4IJjw67Zw2ipP5c+qHFjJ9aUlPWZtS/X/eNyfwnTsvTjG2yLcpq9nKXz7hSMzAqKPHBdkIXepRarbMIpwi4VFyHIki/Twc/dY6AQcwa+3oLkDUsOVZLHxicIMqb2NssWarNTU3TVjfUqFmztofPLd4mZQku2uMQDYT14jUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918213; c=relaxed/simple;
	bh=cTSzKAbJRmoFsrceInAvKSVjWyHFdIaCIfRpKmG0LVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UWrnU5uS/7uye+gvB8KWQv4JUOl0Z1K3Q2BbftOKyREAwzTUirV+WuGeYbJIVUHytm/nHADn3nU7EIfdwe8TKzraX9Id4oOsWC1hfPZlrJ9CVM2D2Bnou3k8MifFrVpbvXwZw7PsOh0J3l5LnOwLewqSpYjX+zQHVhFbXXeHWgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qvr0M7tk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qvr0M7tk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72A5FC4CEC3;
	Mon, 14 Oct 2024 15:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918212;
	bh=cTSzKAbJRmoFsrceInAvKSVjWyHFdIaCIfRpKmG0LVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qvr0M7tkRtdC/STXBLzD0KIEZPcKCWWe2+TImvMDSOT3/n79HhOzNa8RV3R5l6In/
	 T5kzNr9qR+ClHEs8SJhs4FLb5tOmUGLK+OK/O7RPcxRcYtCjcd0bUiFSRjyG6PdHbC
	 RbFQHg0yBSsqH0FYW2Qz7JytMM3GbrJk3CkOk8HM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 255/798] cxl/pci: Break out range register decoding from cxl_hdm_decode_init()
Date: Mon, 14 Oct 2024 16:13:29 +0200
Message-ID: <20241014141227.953294704@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 1acba6e9206c655f8eb6736c7cafbf022492f36d ]

There are 2 scenarios that requires additional handling. 1. A device that
has active ranges in DVSEC range registers (RR) but no HDM decoder register
block. 2. A device that has both RR active and HDM, but the HDM decoders
are not programmed. The goal is to create emulated decoder software structs
based on the RR.

Move the CXL DVSEC range register decoding code block from
cxl_hdm_decode_init() to its own function. Refactor code in preparation for
the HDM decoder emulation.  There is no functionality change to the code.
Name the new function to cxl_dvsec_rr_decode().

The only change is to set range->start and range->end to CXL_RESOURCE_NONE
and skipping the reading of base registers if the range size is 0, which
equates to range not active.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/167640366839.935665.11816388524993234329.stgit@dwillia2-xfh.jf.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Stable-dep-of: 55e268694e8b ("cxl/pci: Fix to record only non-zero ranges")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/pci.c | 64 ++++++++++++++++++++++++++----------------
 1 file changed, 40 insertions(+), 24 deletions(-)

diff --git a/drivers/cxl/core/pci.c b/drivers/cxl/core/pci.c
index 5584af15300a8..194c8024216df 100644
--- a/drivers/cxl/core/pci.c
+++ b/drivers/cxl/core/pci.c
@@ -211,11 +211,10 @@ int cxl_await_media_ready(struct cxl_dev_state *cxlds)
 }
 EXPORT_SYMBOL_NS_GPL(cxl_await_media_ready, CXL);
 
-static int wait_for_valid(struct cxl_dev_state *cxlds)
+static int wait_for_valid(struct pci_dev *pdev, int d)
 {
-	struct pci_dev *pdev = to_pci_dev(cxlds->dev);
-	int d = cxlds->cxl_dvsec, rc;
 	u32 val;
+	int rc;
 
 	/*
 	 * Memory_Info_Valid: When set, indicates that the CXL Range 1 Size high
@@ -404,20 +403,11 @@ static bool __cxl_hdm_decode_init(struct cxl_dev_state *cxlds,
 	return true;
 }
 
-/**
- * cxl_hdm_decode_init() - Setup HDM decoding for the endpoint
- * @cxlds: Device state
- * @cxlhdm: Mapped HDM decoder Capability
- *
- * Try to enable the endpoint's HDM Decoder Capability
- */
-int cxl_hdm_decode_init(struct cxl_dev_state *cxlds, struct cxl_hdm *cxlhdm)
+static int cxl_dvsec_rr_decode(struct device *dev, int d,
+			       struct cxl_endpoint_dvsec_info *info)
 {
-	struct pci_dev *pdev = to_pci_dev(cxlds->dev);
-	struct cxl_endpoint_dvsec_info info = { 0 };
+	struct pci_dev *pdev = to_pci_dev(dev);
 	int hdm_count, rc, i, ranges = 0;
-	struct device *dev = &pdev->dev;
-	int d = cxlds->cxl_dvsec;
 	u16 cap, ctrl;
 
 	if (!d) {
@@ -448,7 +438,7 @@ int cxl_hdm_decode_init(struct cxl_dev_state *cxlds, struct cxl_hdm *cxlhdm)
 	if (!hdm_count || hdm_count > 2)
 		return -EINVAL;
 
-	rc = wait_for_valid(cxlds);
+	rc = wait_for_valid(pdev, d);
 	if (rc) {
 		dev_dbg(dev, "Failure awaiting MEM_INFO_VALID (%d)\n", rc);
 		return rc;
@@ -459,9 +449,9 @@ int cxl_hdm_decode_init(struct cxl_dev_state *cxlds, struct cxl_hdm *cxlhdm)
 	 * disabled, and they will remain moot after the HDM Decoder
 	 * capability is enabled.
 	 */
-	info.mem_enabled = FIELD_GET(CXL_DVSEC_MEM_ENABLE, ctrl);
-	if (!info.mem_enabled)
-		goto hdm_init;
+	info->mem_enabled = FIELD_GET(CXL_DVSEC_MEM_ENABLE, ctrl);
+	if (!info->mem_enabled)
+		return 0;
 
 	for (i = 0; i < hdm_count; i++) {
 		u64 base, size;
@@ -480,6 +470,13 @@ int cxl_hdm_decode_init(struct cxl_dev_state *cxlds, struct cxl_hdm *cxlhdm)
 			return rc;
 
 		size |= temp & CXL_DVSEC_MEM_SIZE_LOW_MASK;
+		if (!size) {
+			info->dvsec_range[i] = (struct range) {
+				.start = 0,
+				.end = CXL_RESOURCE_NONE,
+			};
+			continue;
+		}
 
 		rc = pci_read_config_dword(
 			pdev, d + CXL_DVSEC_RANGE_BASE_HIGH(i), &temp);
@@ -495,22 +492,41 @@ int cxl_hdm_decode_init(struct cxl_dev_state *cxlds, struct cxl_hdm *cxlhdm)
 
 		base |= temp & CXL_DVSEC_MEM_BASE_LOW_MASK;
 
-		info.dvsec_range[i] = (struct range) {
+		info->dvsec_range[i] = (struct range) {
 			.start = base,
 			.end = base + size - 1
 		};
 
-		if (size)
-			ranges++;
+		ranges++;
 	}
 
-	info.ranges = ranges;
+	info->ranges = ranges;
+
+	return 0;
+}
+
+/**
+ * cxl_hdm_decode_init() - Setup HDM decoding for the endpoint
+ * @cxlds: Device state
+ * @cxlhdm: Mapped HDM decoder Capability
+ *
+ * Try to enable the endpoint's HDM Decoder Capability
+ */
+int cxl_hdm_decode_init(struct cxl_dev_state *cxlds, struct cxl_hdm *cxlhdm)
+{
+	struct cxl_endpoint_dvsec_info info = { 0 };
+	struct device *dev = cxlds->dev;
+	int d = cxlds->cxl_dvsec;
+	int rc;
+
+	rc = cxl_dvsec_rr_decode(dev, d, &info);
+	if (rc < 0)
+		return rc;
 
 	/*
 	 * If DVSEC ranges are being used instead of HDM decoder registers there
 	 * is no use in trying to manage those.
 	 */
-hdm_init:
 	if (!__cxl_hdm_decode_init(cxlds, cxlhdm, &info)) {
 		dev_err(dev,
 			"Legacy range registers configuration prevents HDM operation.\n");
-- 
2.43.0



