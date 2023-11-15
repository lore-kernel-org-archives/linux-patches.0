Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F9783A8F2
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DDTqmpMC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EBBBC433C9;
	Wed, 15 Nov 2023 19:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077754;
	bh=t905Peqctn5pxZhJ58Rg1705TRxqdTAkmHsPYy+65iU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DDTqmpMCD+MqBozBOdcl4chf49erhizPfoA9IX4gO6lmI34vXzmAYJxrlCHqEcT+/
	 sY1WfhIq9lU5O9IdbUZ0sgwWkQSI25Onql/plI/sJ1IgEDEOrU8qlgaivZKrBurlyF
	 G8RhgwX2g0lvJbo1qlIGafy2IyWl+V4NjbmtTlfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmytro Adamenko <dmytro.adamenko@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jim Harris <jim.harris@samsung.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 499/603] cxl/region: Use cxl_calc_interleave_pos() for auto-discovery
Date: Wed, 15 Nov 2023 14:17:24 -0500
Message-ID: <20231115191646.775984571@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

[ Upstream commit 0cf36a85c1408f86a967fb1db721de1b89b9e675 ]

For auto-discovered regions the driver must assign each target to
a valid position in the region interleave set based on the decoder
topology.

The current implementation fails to parse valid decode topologies,
as it does not consider the child offset into a parent port. The sort
put all targets of one port ahead of another port when an interleave
was expected, causing the region assembly to fail.

Replace the existing relative sort with cxl_calc_interleave_pos() that
finds the exact position in a region interleave for an endpoint based
on a walk up the ancestral tree from endpoint to root decoder.

cxl_calc_interleave_pos() was introduced in a prior patch, so the work
here is to use it in cxl_region_sort_targets().

Remove the obsoleted helper functions from the prior sort.

Testing passes on pre-production hardware with BIOS defined regions
that natively trigger this autodiscovery path of the region driver.
Testing passes a CXL unit test using the dev_dbg() calculation test
(see cxl_region_attach()) across an expanded set of region configs:
1, 1, 1+1, 1+1+1, 2, 2+2, 2+2+2, 2+2+2+2, 4, 4+4, where each number
represents the count of endpoints per host bridge.

Fixes: a32320b71f08 ("cxl/region: Add region autodiscovery")
Reported-by: Dmytro Adamenko <dmytro.adamenko@intel.com>
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jim Harris <jim.harris@samsung.com>
Link: https://lore.kernel.org/r/3946cc55ddc19678733eddc9de2c317749f43f3b.1698263080.git.alison.schofield@intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/region.c | 127 +++++---------------------------------
 1 file changed, 15 insertions(+), 112 deletions(-)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index ccde7489edbde..644032cd680e4 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -1474,6 +1474,14 @@ static int cxl_region_attach_auto(struct cxl_region *cxlr,
 	return 0;
 }
 
+static int cmp_interleave_pos(const void *a, const void *b)
+{
+	struct cxl_endpoint_decoder *cxled_a = *(typeof(cxled_a) *)a;
+	struct cxl_endpoint_decoder *cxled_b = *(typeof(cxled_b) *)b;
+
+	return cxled_a->pos - cxled_b->pos;
+}
+
 static struct cxl_port *next_port(struct cxl_port *port)
 {
 	if (!port->parent_dport)
@@ -1604,131 +1612,26 @@ static int cxl_calc_interleave_pos(struct cxl_endpoint_decoder *cxled)
 	return pos;
 }
 
-static void find_positions(const struct cxl_switch_decoder *cxlsd,
-			   const struct cxl_port *iter_a,
-			   const struct cxl_port *iter_b, int *a_pos,
-			   int *b_pos)
-{
-	int i;
-
-	for (i = 0, *a_pos = -1, *b_pos = -1; i < cxlsd->nr_targets; i++) {
-		if (cxlsd->target[i] == iter_a->parent_dport)
-			*a_pos = i;
-		else if (cxlsd->target[i] == iter_b->parent_dport)
-			*b_pos = i;
-		if (*a_pos >= 0 && *b_pos >= 0)
-			break;
-	}
-}
-
-static int cmp_decode_pos(const void *a, const void *b)
-{
-	struct cxl_endpoint_decoder *cxled_a = *(typeof(cxled_a) *)a;
-	struct cxl_endpoint_decoder *cxled_b = *(typeof(cxled_b) *)b;
-	struct cxl_memdev *cxlmd_a = cxled_to_memdev(cxled_a);
-	struct cxl_memdev *cxlmd_b = cxled_to_memdev(cxled_b);
-	struct cxl_port *port_a = cxled_to_port(cxled_a);
-	struct cxl_port *port_b = cxled_to_port(cxled_b);
-	struct cxl_port *iter_a, *iter_b, *port = NULL;
-	struct cxl_switch_decoder *cxlsd;
-	struct device *dev;
-	int a_pos, b_pos;
-	unsigned int seq;
-
-	/* Exit early if any prior sorting failed */
-	if (cxled_a->pos < 0 || cxled_b->pos < 0)
-		return 0;
-
-	/*
-	 * Walk up the hierarchy to find a shared port, find the decoder that
-	 * maps the range, compare the relative position of those dport
-	 * mappings.
-	 */
-	for (iter_a = port_a; iter_a; iter_a = next_port(iter_a)) {
-		struct cxl_port *next_a, *next_b;
-
-		next_a = next_port(iter_a);
-		if (!next_a)
-			break;
-
-		for (iter_b = port_b; iter_b; iter_b = next_port(iter_b)) {
-			next_b = next_port(iter_b);
-			if (next_a != next_b)
-				continue;
-			port = next_a;
-			break;
-		}
-
-		if (port)
-			break;
-	}
-
-	if (!port) {
-		dev_err(cxlmd_a->dev.parent,
-			"failed to find shared port with %s\n",
-			dev_name(cxlmd_b->dev.parent));
-		goto err;
-	}
-
-	dev = device_find_child(&port->dev, &cxled_a->cxld.hpa_range,
-				match_switch_decoder_by_range);
-	if (!dev) {
-		struct range *range = &cxled_a->cxld.hpa_range;
-
-		dev_err(port->uport_dev,
-			"failed to find decoder that maps %#llx-%#llx\n",
-			range->start, range->end);
-		goto err;
-	}
-
-	cxlsd = to_cxl_switch_decoder(dev);
-	do {
-		seq = read_seqbegin(&cxlsd->target_lock);
-		find_positions(cxlsd, iter_a, iter_b, &a_pos, &b_pos);
-	} while (read_seqretry(&cxlsd->target_lock, seq));
-
-	put_device(dev);
-
-	if (a_pos < 0 || b_pos < 0) {
-		dev_err(port->uport_dev,
-			"failed to find shared decoder for %s and %s\n",
-			dev_name(cxlmd_a->dev.parent),
-			dev_name(cxlmd_b->dev.parent));
-		goto err;
-	}
-
-	dev_dbg(port->uport_dev, "%s comes %s %s\n",
-		dev_name(cxlmd_a->dev.parent),
-		a_pos - b_pos < 0 ? "before" : "after",
-		dev_name(cxlmd_b->dev.parent));
-
-	return a_pos - b_pos;
-err:
-	cxled_a->pos = -1;
-	return 0;
-}
-
 static int cxl_region_sort_targets(struct cxl_region *cxlr)
 {
 	struct cxl_region_params *p = &cxlr->params;
 	int i, rc = 0;
 
-	sort(p->targets, p->nr_targets, sizeof(p->targets[0]), cmp_decode_pos,
-	     NULL);
-
 	for (i = 0; i < p->nr_targets; i++) {
 		struct cxl_endpoint_decoder *cxled = p->targets[i];
 
+		cxled->pos = cxl_calc_interleave_pos(cxled);
 		/*
-		 * Record that sorting failed, but still continue to restore
-		 * cxled->pos with its ->targets[] position so that follow-on
-		 * code paths can reliably do p->targets[cxled->pos] to
-		 * self-reference their entry.
+		 * Record that sorting failed, but still continue to calc
+		 * cxled->pos so that follow-on code paths can reliably
+		 * do p->targets[cxled->pos] to self-reference their entry.
 		 */
 		if (cxled->pos < 0)
 			rc = -ENXIO;
-		cxled->pos = i;
 	}
+	/* Keep the cxlr target list in interleave position order */
+	sort(p->targets, p->nr_targets, sizeof(p->targets[0]),
+	     cmp_interleave_pos, NULL);
 
 	dev_dbg(&cxlr->dev, "region sort %s\n", rc ? "failed" : "successful");
 	return rc;
-- 
2.42.0



