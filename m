Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44118408039;
	Tue, 21 Jul 2026 18:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659928; cv=none; b=t/6Jrw8L6S3qmTY3tlZzZt0cfnZudES7hHLtJ3KXllY2ngGMHuMYYiQo6qrTkBXYUfErodupEJhW3oLc+TkaCqNW0L598+6GS1YvLv2Ae6z7CbCDRRMkXeXV2E5A5F9NsA6zufpAJNbkOlqPlrRtVjoDtcyGKBRfEX0dWQs64zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659928; c=relaxed/simple;
	bh=WV4iOqTTwi/aq/G3PUHA6sPnS9rzkK/MiHwFaur8wsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kgpsLKy4L/xP575IUfH6wAhyX4hQJhfKUCvEfEy5BfyBAjvJGVYO1ZNvu/r93HfTWCu8GPMAnD1/FJjRv0uX65a9zxz3/Euu4Etnc5Kn7LIp+8+R9QezHDXW9PqnFAi7UO0NdPRIC7PtO64BR7TsSe6LvVpamRMVIEY2ah27pgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m7HoZaNQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m7HoZaNQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AADF61F000E9;
	Tue, 21 Jul 2026 18:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659927;
	bh=y78a1ptC7+I/EbwiA4Nz0XuyfTTa16PU9KPbZady3IQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m7HoZaNQnqpcs21/RhexJp1D7iiv0UnHEniYjhpRROVR+yTarZBNW94MFKgLcNhFL
	 hJNuvYFkliOu68P3QbciwvOZOUQ/t5i1RtK7Bn0d9MC7r2lbw+YlYoaNjMMwhPcLdr
	 k03Hxd6lrd9UGtSUmCbWzDQ4zl8xNSYVK/IdkIRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Ming <ming.li@zohomail.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0732/2077] cxl/region: Fix out-of-bounds access in cxl_cancel_auto_attach()
Date: Tue, 21 Jul 2026 17:06:45 +0200
Message-ID: <20260721152610.062191258@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Ming <ming.li@zohomail.com>

[ Upstream commit cbda6a2c2bec2a5fb30a2ce85baeab15b5fc7db3 ]

In cxl_cancel_auto_attach(), it assumes cxled->pos is a valid index for
accessing p->targets[]. However, cxled->pos can be set to negative errno
in cxl_region_sort_targets() if cxl_calc_interleave_pos() fails. This
causes the driver to use a negative index to access p->targets[],
resulting in out-of-bounds access.

Fix it by walking p->targets[] instead of using cxled->pos directly.

Fixes: 87805c32e6ad ("cxl/region: Fix use-after-free from auto assembly failure")
Signed-off-by: Li Ming <ming.li@zohomail.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20260606-fix_two_issues_introduced_by_cxl_cancel_auto_attach-v1-1-5d94ca06c4e4@zohomail.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/region.c | 40 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 21 deletions(-)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index e50dc716d4e820..8956b049c4620c 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -2011,8 +2011,9 @@ static int cxl_region_sort_targets(struct cxl_region *cxlr)
 		cxled->pos = cxl_calc_interleave_pos(cxled, &cxlr->hpa_range);
 		/*
 		 * Record that sorting failed, but still continue to calc
-		 * cxled->pos so that follow-on code paths can reliably
-		 * do p->targets[cxled->pos] to self-reference their entry.
+		 * cxled->pos so that cxl_calc_interleave_pos() emits its
+		 * dev_dbg() for every member. which is useful for auto
+		 * discovery debug.
 		 */
 		if (cxled->pos < 0)
 			rc = -ENXIO;
@@ -2202,18 +2203,30 @@ static int cxl_region_attach(struct cxl_region *cxlr,
 	return 0;
 }
 
-static int cxl_region_by_target(struct device *dev, const void *data)
+static int cxl_region_remove_target(struct device *dev, void *data)
 {
-	const struct cxl_endpoint_decoder *cxled = data;
+	struct cxl_endpoint_decoder *cxled = data;
 	struct cxl_region_params *p;
 	struct cxl_region *cxlr;
+	int i;
 
 	if (!is_cxl_region(dev))
 		return 0;
 
 	cxlr = to_cxl_region(dev);
 	p = &cxlr->params;
-	return p->targets[cxled->pos] == cxled;
+	for (i = 0; i < p->interleave_ways; i++) {
+		if (p->targets[i] == cxled) {
+			p->nr_targets--;
+			cxled->state = CXL_DECODER_STATE_AUTO;
+			cxled->pos = -1;
+			p->targets[i] = NULL;
+
+			return 1;
+		}
+	}
+
+	return 0;
 }
 
 /*
@@ -2222,25 +2235,10 @@ static int cxl_region_by_target(struct device *dev, const void *data)
  */
 static void cxl_cancel_auto_attach(struct cxl_endpoint_decoder *cxled)
 {
-	struct cxl_region_params *p;
-	struct cxl_region *cxlr;
-	int pos = cxled->pos;
-
 	if (cxled->state != CXL_DECODER_STATE_AUTO_STAGED)
 		return;
 
-	struct device *dev __free(put_device) =
-		bus_find_device(&cxl_bus_type, NULL, cxled, cxl_region_by_target);
-	if (!dev)
-		return;
-
-	cxlr = to_cxl_region(dev);
-	p = &cxlr->params;
-
-	p->nr_targets--;
-	cxled->state = CXL_DECODER_STATE_AUTO;
-	cxled->pos = -1;
-	p->targets[pos] = NULL;
+	bus_for_each_dev(&cxl_bus_type, NULL, cxled, cxl_region_remove_target);
 }
 
 static struct cxl_region *
-- 
2.53.0



