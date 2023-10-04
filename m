Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D97691D6B0
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G0a3UiQW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EAEDC433CA;
	Wed,  4 Oct 2023 18:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444021;
	bh=BG/xKnCfzv5AvKnwbqJmC1pqIsOdgYyTJZllz4hHlpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G0a3UiQWrQOi5ihTQm4RX1Z9UXmCj1VEqgsqyhg3x6jOSyAWl5mb1mj6RY7AafW/s
	 1isaXu2xp/e4BUZ39pDz7c9z2+kGqLhQz+NSOcajDdyT0Xm6mxscSYpNTzo58UO10a
	 PBng3xZX8bviIxqmZjW4G0UzU24ouVGoAyjZkVn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 103/321] cxl/region: Match auto-discovered region decoders by HPA range
Date: Wed,  4 Oct 2023 19:54:08 +0200
Message-ID: <20231004175234.017234356@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alison Schofield <alison.schofield@intel.com>

[ Upstream commit 9e4edf1a2196fa4bea6e8201f166785bd066446a ]

Currently, when the region driver attaches a region to a port, it
selects the ports next available decoder to program.

With the addition of auto-discovered regions, a port decoder has
already been programmed so grabbing the next available decoder can
be a mismatch when there is more than one region using the port.

The failure appears like this with CXL DEBUG enabled:

[] cxl_core:alloc_region_ref:754: cxl region0: endpoint9: HPA order violation region0:[mem 0x14780000000-0x1478fffffff flags 0x200] vs [mem 0x880000000-0x185fffffff flags 0x200]
[] cxl_core:cxl_port_attach_region:972: cxl region0: endpoint9: failed to allocate region reference

When CXL DEBUG is not enabled, there is no failure message. The region
just never materializes. Users can suspect this issue if they know their
firmware has programmed decoders so that more than one region is using
a port. Note that the problem may appear intermittently, ie not on
every reboot.

Add a matching method for auto-discovered regions that finds a decoder
based on an HPA range. The decoder range must exactly match the region
resource parameter.

Fixes: a32320b71f08 ("cxl/region: Add region autodiscovery")
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Link: https://lore.kernel.org/r/20230905211007.256385-1-alison.schofield@intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/region.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index e115ba382e044..b4c6a749406f1 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -717,13 +717,35 @@ static int match_free_decoder(struct device *dev, void *data)
 	return 0;
 }
 
+static int match_auto_decoder(struct device *dev, void *data)
+{
+	struct cxl_region_params *p = data;
+	struct cxl_decoder *cxld;
+	struct range *r;
+
+	if (!is_switch_decoder(dev))
+		return 0;
+
+	cxld = to_cxl_decoder(dev);
+	r = &cxld->hpa_range;
+
+	if (p->res && p->res->start == r->start && p->res->end == r->end)
+		return 1;
+
+	return 0;
+}
+
 static struct cxl_decoder *cxl_region_find_decoder(struct cxl_port *port,
 						   struct cxl_region *cxlr)
 {
 	struct device *dev;
 	int id = 0;
 
-	dev = device_find_child(&port->dev, &id, match_free_decoder);
+	if (test_bit(CXL_REGION_F_AUTO, &cxlr->flags))
+		dev = device_find_child(&port->dev, &cxlr->params,
+					match_auto_decoder);
+	else
+		dev = device_find_child(&port->dev, &id, match_free_decoder);
 	if (!dev)
 		return NULL;
 	/*
-- 
2.40.1



