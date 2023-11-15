Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED39381DC
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JrM3zpm1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3CF3C433CB;
	Wed, 15 Nov 2023 19:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076912;
	bh=uFJ6GuqmcdjuTVWVgdRNaACkxgvVqALSkVH5uWCkPYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JrM3zpm1nQN0mB41m/vBkA034SIVhtuzSR1l7KNsWVGla4tqrpM/QfjDEDbvZOlKn
	 HPOgv5qtiiyr/+V9B6M2e9Zte9NcFy9sg0kAfcUSePjLr5h/gomKsB2RX9+vFo37S3
	 KFYjvX/rxfe3zdBx/mu86R75Iz6GAhaJ2kFBTpso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Jim Harris <jim.harris@samsung.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 461/550] cxl/region: Prepare the decoder match range helper for reuse
Date: Wed, 15 Nov 2023 14:17:25 -0500
Message-ID: <20231115191632.828983598@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

[ Upstream commit 1110581412c7a223439bb3ecdcdd9f4432e08231 ]

match_decoder_by_range() and decoder_match_range() both determine
if an HPA range matches a decoder. The first does it for root
decoders and the second one operates on switch decoders.

Tidy these up with clear naming and make the switch helper more
like the root decoder helper in style and functionality. Make it
take the actual range, rather than an endpoint decoder from which
it extracts the range. Require an exact match on switch decoders,
because unlike a root decoder that maps an entire region, Linux
only supports 1:1 mapping of switch to endpoint decoders. Note that
root-decoders are a super-set of switch-decoders and the range they
cover is a super-set of a region, hence the use of range_contains() for
that case.

Aside from aesthetics and maintainability, this is in preparation
for reuse.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Jim Harris <jim.harris@samsung.com>
Link: https://lore.kernel.org/r/011b1f498e1758bb8df17c5951be00bd8d489e3b.1698263080.git.alison.schofield@intel.com
[djbw: fixup root decoder vs switch decoder range checks]
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Stable-dep-of: 0cf36a85c140 ("cxl/region: Use cxl_calc_interleave_pos() for auto-discovery")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/region.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 8394cd96e1869..123474d6c475a 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -1482,16 +1482,20 @@ static struct cxl_port *next_port(struct cxl_port *port)
 	return port->parent_dport->port;
 }
 
-static int decoder_match_range(struct device *dev, void *data)
+static int match_switch_decoder_by_range(struct device *dev, void *data)
 {
-	struct cxl_endpoint_decoder *cxled = data;
 	struct cxl_switch_decoder *cxlsd;
+	struct range *r1, *r2 = data;
 
 	if (!is_switch_decoder(dev))
 		return 0;
 
 	cxlsd = to_cxl_switch_decoder(dev);
-	return range_contains(&cxlsd->cxld.hpa_range, &cxled->cxld.hpa_range);
+	r1 = &cxlsd->cxld.hpa_range;
+
+	if (is_root_decoder(dev))
+		return range_contains(r1, r2);
+	return (r1->start == r2->start && r1->end == r2->end);
 }
 
 static void find_positions(const struct cxl_switch_decoder *cxlsd,
@@ -1560,7 +1564,8 @@ static int cmp_decode_pos(const void *a, const void *b)
 		goto err;
 	}
 
-	dev = device_find_child(&port->dev, cxled_a, decoder_match_range);
+	dev = device_find_child(&port->dev, &cxled_a->cxld.hpa_range,
+				match_switch_decoder_by_range);
 	if (!dev) {
 		struct range *range = &cxled_a->cxld.hpa_range;
 
@@ -2691,7 +2696,7 @@ static int devm_cxl_add_dax_region(struct cxl_region *cxlr)
 	return rc;
 }
 
-static int match_decoder_by_range(struct device *dev, void *data)
+static int match_root_decoder_by_range(struct device *dev, void *data)
 {
 	struct range *r1, *r2 = data;
 	struct cxl_root_decoder *cxlrd;
@@ -2822,7 +2827,7 @@ int cxl_add_to_region(struct cxl_port *root, struct cxl_endpoint_decoder *cxled)
 	int rc;
 
 	cxlrd_dev = device_find_child(&root->dev, &cxld->hpa_range,
-				      match_decoder_by_range);
+				      match_root_decoder_by_range);
 	if (!cxlrd_dev) {
 		dev_err(cxlmd->dev.parent,
 			"%s:%s no CXL window for range %#llx:%#llx\n",
-- 
2.42.0



