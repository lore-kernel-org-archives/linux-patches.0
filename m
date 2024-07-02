Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CEF01BE258;
	Tue,  2 Jul 2024 17:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941216; cv=none; b=pRQpVCssMMb2PlR9SsnpNNVRULyc+2Y44W0CaHNEOAC8eKYm+ebEDtFrGZoHDv5P/F7FksN6nwvoSLKkGgYhz3c91Up9D8dCfy8vBR+0tltj3OwxBDZPwxoPxbbhmGRNZKBOt4sfMDfy9Vpdao7gR1be2iDp4BaQRSCUU+9ufNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941216; c=relaxed/simple;
	bh=CBxrAPtD8LCf6FKA0iRG9R1ebhL6NrzNMFXnHmkrxro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rvy1Du8RcX3NUiIQxe5aUJ+Kab3WXQ1fWRoH64JHkJA4BXakXeX8wgeiPxqNdAGZgGBOMZqb7J25EoXWQWvc5Z6sNZFL6yZLx/UYe4sJGy9rj2nVIvyTJlQy3qUQO2eNsv2qp8mYsp41fESiTnLvjqVj/l5CzVScMFUqI8KHjGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T6RqWgDq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T6RqWgDq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E28D5C4AF07;
	Tue,  2 Jul 2024 17:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941216;
	bh=CBxrAPtD8LCf6FKA0iRG9R1ebhL6NrzNMFXnHmkrxro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T6RqWgDqK4iDywCB8gqGJpAc5YYRluJPRnWBn8HdWa9OqFJ5xVNBtyt/woEhvKHfz
	 nKwnlMoRfhoAORIkYb0H2c4YSULEdmaoOBtpLvJB7DLYOfFqQnoo0gh/ercqFiYgrl
	 cTHTNqlhAMl4krJOf1dSMTizLaEyyYjes2WEZKW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 162/163] cxl/region: Avoid null pointer dereference in region lookup
Date: Tue,  2 Jul 2024 19:04:36 +0200
Message-ID: <20240702170239.191759115@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alison Schofield <alison.schofield@intel.com>

[ Upstream commit 285f2a08841432fc3e498b1cd00cce5216cdf189 ]

cxl_dpa_to_region() looks up a region based on a memdev and DPA.
It wrongly assumes an endpoint found mapping the DPA is also of
a fully assembled region. When not true it leads to a null pointer
dereference looking up the region name.

This appears during testing of region lookup after a failure to
assemble a BIOS defined region or if the lookup raced with the
assembly of the BIOS defined region.

Failure to clean up BIOS defined regions that fail assembly is an
issue in itself and a fix to that problem will alleviate some of
the impact. It will not alleviate the race condition so let's harden
this path.

The behavior change is that the kernel oops due to a null pointer
dereference is replaced with a dev_dbg() message noting that an
endpoint was mapped.

Additional comments are added so that future users of this function
can more clearly understand what it provides.

Fixes: 0a105ab28a4d ("cxl/memdev: Warn of poison inject or clear to a mapped region")
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Link: https://patch.msgid.link/20240604003609.202682-1-alison.schofield@intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/region.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index d2ce309434654..0d59af19ecee7 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -2518,22 +2518,33 @@ static int __cxl_dpa_to_region(struct device *dev, void *arg)
 {
 	struct cxl_dpa_to_region_context *ctx = arg;
 	struct cxl_endpoint_decoder *cxled;
+	struct cxl_region *cxlr;
 	u64 dpa = ctx->dpa;
 
 	if (!is_endpoint_decoder(dev))
 		return 0;
 
 	cxled = to_cxl_endpoint_decoder(dev);
-	if (!cxled->dpa_res || !resource_size(cxled->dpa_res))
+	if (!cxled || !cxled->dpa_res || !resource_size(cxled->dpa_res))
 		return 0;
 
 	if (dpa > cxled->dpa_res->end || dpa < cxled->dpa_res->start)
 		return 0;
 
-	dev_dbg(dev, "dpa:0x%llx mapped in region:%s\n", dpa,
-		dev_name(&cxled->cxld.region->dev));
+	/*
+	 * Stop the region search (return 1) when an endpoint mapping is
+	 * found. The region may not be fully constructed so offering
+	 * the cxlr in the context structure is not guaranteed.
+	 */
+	cxlr = cxled->cxld.region;
+	if (cxlr)
+		dev_dbg(dev, "dpa:0x%llx mapped in region:%s\n", dpa,
+			dev_name(&cxlr->dev));
+	else
+		dev_dbg(dev, "dpa:0x%llx mapped in endpoint:%s\n", dpa,
+			dev_name(dev));
 
-	ctx->cxlr = cxled->cxld.region;
+	ctx->cxlr = cxlr;
 
 	return 1;
 }
-- 
2.43.0



