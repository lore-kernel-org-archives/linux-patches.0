Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A731C0DE5;
	Tue,  2 Jul 2024 17:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940675; cv=none; b=bBlMAODqZoKLOAGrc0XH0w9uldmssyqzZumNgtXo9fSoBt3cWDj2mFeSXauCpY/huItLv0RUBV2uhnOVOVOT1X6XM5wEwfme1H4eI4pNBIGULOdWw3q8o0LLlpmiXwbvkLU/nic2mIXMh+zrMg1s45uBlcklSIs6f6qKlA1tKJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940675; c=relaxed/simple;
	bh=gI8yubw2gFX7GQeTQmq0yobOPONWJKNQUuHqk94NA2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oy5hSo5THO6RgH5QGB6c837H8sGcmka4bnDAaRgtN3jA/zcqlKtbmAKDz/6/Hj0JL7PWl9Wv5M6ibnG2CBmUIDeSVKodZjbq0VxIlLBZRfE6qZqtRJQpwaAeB2dhCif5/G0SGstOSMz9eHEPUOOawG6ArKttEoG7IakUB+nrmjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oorwa12q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oorwa12q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0307C116B1;
	Tue,  2 Jul 2024 17:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940675;
	bh=gI8yubw2gFX7GQeTQmq0yobOPONWJKNQUuHqk94NA2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oorwa12qv1aEWvqHA249RTcVNdf8q54k6fDZ3ghR64x+QaURxpyfAGBnJ6CJSc8+P
	 jdK/y49sWKOFK6DwYJBX2RlBxl5Cht+IGbXLzHiWusUR29guwmxRr3vxgtf43KVZ/J
	 d6EsRkBElTMxKn/rbL4gi1OfClTC2MWj9vRs/YgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 219/222] cxl/region: Avoid null pointer dereference in region lookup
Date: Tue,  2 Jul 2024 19:04:17 +0200
Message-ID: <20240702170252.358863678@linuxfoundation.org>
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
index 52061edf4bd97..a083893c0afe0 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -2688,22 +2688,33 @@ static int __cxl_dpa_to_region(struct device *dev, void *arg)
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



