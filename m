Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE1931E534;
	Tue, 27 Feb 2024 13:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040944; cv=none; b=V1cengwGQ+b7CdXD2g1jZ69uc0Fe9J8g3bsZwF1AA51YGQT0fKd3syIxShhCRCTVIv5HohM6Lyrnoyq95cj2wZsG0p0OIdNinT7ZjOrtXWc46c1+mzLHGWTv/U9gBQZr4+G552r52WNxcRwROFfxWByK/pZv2lm6bEx0KNKBWNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040944; c=relaxed/simple;
	bh=gGxCDFIRICEyL9QFtB9+NJrDvg1NtidU50iI6mPYom4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hc30p4AcmhlGvR3pV9MjGrzbFXcK1SK4Bxd1t/HTUmq7EbHUYqn5faw6OTRY54jyG68NnTuUeiseDJB1B0+QBi29oXge+9XC1N9IS0Etxfix9k/lpOCM/478lD/Kco+K1qmLH/mHoGPBonlykv9Zrt/bI/ivABTCUuLtThLzrNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OL9v0jPQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OL9v0jPQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 495AEC433F1;
	Tue, 27 Feb 2024 13:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040944;
	bh=gGxCDFIRICEyL9QFtB9+NJrDvg1NtidU50iI6mPYom4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OL9v0jPQ7hRXrj07mGbhGJPmA5iqkC7g2aH++BFXY8VM7xxeLRASWyINolar6dIv6
	 cSWBrNOUX81estWYqZxr2OW7Pj8nHv6B9EuXBkbQiWoikbqwvGxrQG5PaeoB16ZCWF
	 WbPW9Go/nGL0RUkubImgNkhD/+w5MI6Vf7Nt+Pkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 6.7 164/334] cxl/acpi: Fix load failures due to single window creation failure
Date: Tue, 27 Feb 2024 14:20:22 +0100
Message-ID: <20240227131635.793616062@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

commit 5c6224bfabbf7f3e491c51ab50fd2c6f92ba1141 upstream.

The expectation is that cxl_parse_cfwms() continues in the face the of
failure as evidenced by code like:

    cxlrd = cxl_root_decoder_alloc(root_port, ways, cxl_calc_hb);
    if (IS_ERR(cxlrd))
    	return 0;

There are other error paths in that function which mistakenly follow
idiomatic expectations and return an error when they should not. Most of
those mistakes are innocuous checks that hardly ever fail in practice.
However, a recent change succeed in making the implementation more
fragile by applying an idiomatic, but still wrong "fix" [1]. In this
failure case the kernel reports:

    cxl root0: Failed to populate active decoder targets
    cxl_acpi ACPI0017:00: Failed to add decode range: [mem 0x00000000-0x7fffffff flags 0x200]

...which is a real issue with that one window (to be fixed separately),
but ends up failing the entirety of cxl_acpi_probe().

Undo that recent breakage while also removing the confusion about
ignoring errors. Update all exits paths to return an error per typical
expectations and let an outer wrapper function handle dropping the
error.

Fixes: 91019b5bc7c2 ("cxl/acpi: Return 'rc' instead of '0' in cxl_parse_cfmws()") [1]
Cc: <stable@vger.kernel.org>
Cc: Breno Leitao <leitao@debian.org>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cxl/acpi.c |   46 ++++++++++++++++++++++++++++------------------
 1 file changed, 28 insertions(+), 18 deletions(-)

--- a/drivers/cxl/acpi.c
+++ b/drivers/cxl/acpi.c
@@ -194,31 +194,27 @@ struct cxl_cfmws_context {
 	int id;
 };
 
-static int cxl_parse_cfmws(union acpi_subtable_headers *header, void *arg,
-			   const unsigned long end)
+static int __cxl_parse_cfmws(struct acpi_cedt_cfmws *cfmws,
+			     struct cxl_cfmws_context *ctx)
 {
 	int target_map[CXL_DECODER_MAX_INTERLEAVE];
-	struct cxl_cfmws_context *ctx = arg;
 	struct cxl_port *root_port = ctx->root_port;
 	struct resource *cxl_res = ctx->cxl_res;
 	struct cxl_cxims_context cxims_ctx;
 	struct cxl_root_decoder *cxlrd;
 	struct device *dev = ctx->dev;
-	struct acpi_cedt_cfmws *cfmws;
 	cxl_calc_hb_fn cxl_calc_hb;
 	struct cxl_decoder *cxld;
 	unsigned int ways, i, ig;
 	struct resource *res;
 	int rc;
 
-	cfmws = (struct acpi_cedt_cfmws *) header;
-
 	rc = cxl_acpi_cfmws_verify(dev, cfmws);
 	if (rc) {
 		dev_err(dev, "CFMWS range %#llx-%#llx not registered\n",
 			cfmws->base_hpa,
 			cfmws->base_hpa + cfmws->window_size - 1);
-		return 0;
+		return rc;
 	}
 
 	rc = eiw_to_ways(cfmws->interleave_ways, &ways);
@@ -254,7 +250,7 @@ static int cxl_parse_cfmws(union acpi_su
 
 	cxlrd = cxl_root_decoder_alloc(root_port, ways, cxl_calc_hb);
 	if (IS_ERR(cxlrd))
-		return 0;
+		return PTR_ERR(cxlrd);
 
 	cxld = &cxlrd->cxlsd.cxld;
 	cxld->flags = cfmws_to_decoder_flags(cfmws->restrictions);
@@ -298,16 +294,7 @@ err_xormap:
 		put_device(&cxld->dev);
 	else
 		rc = cxl_decoder_autoremove(dev, cxld);
-	if (rc) {
-		dev_err(dev, "Failed to add decode range: %pr", res);
-		return rc;
-	}
-	dev_dbg(dev, "add: %s node: %d range [%#llx - %#llx]\n",
-		dev_name(&cxld->dev),
-		phys_to_target_node(cxld->hpa_range.start),
-		cxld->hpa_range.start, cxld->hpa_range.end);
-
-	return 0;
+	return rc;
 
 err_insert:
 	kfree(res->name);
@@ -316,6 +303,29 @@ err_name:
 	return -ENOMEM;
 }
 
+static int cxl_parse_cfmws(union acpi_subtable_headers *header, void *arg,
+			   const unsigned long end)
+{
+	struct acpi_cedt_cfmws *cfmws = (struct acpi_cedt_cfmws *)header;
+	struct cxl_cfmws_context *ctx = arg;
+	struct device *dev = ctx->dev;
+	int rc;
+
+	rc = __cxl_parse_cfmws(cfmws, ctx);
+	if (rc)
+		dev_err(dev,
+			"Failed to add decode range: [%#llx - %#llx] (%d)\n",
+			cfmws->base_hpa,
+			cfmws->base_hpa + cfmws->window_size - 1, rc);
+	else
+		dev_dbg(dev, "decode range: node: %d range [%#llx - %#llx]\n",
+			phys_to_target_node(cfmws->base_hpa), cfmws->base_hpa,
+			cfmws->base_hpa + cfmws->window_size - 1);
+
+	/* never fail cxl_acpi load for a single window failure */
+	return 0;
+}
+
 __mock struct acpi_device *to_cxl_host_bridge(struct device *host,
 					      struct device *dev)
 {


