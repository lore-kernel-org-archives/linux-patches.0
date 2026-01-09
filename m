Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9855235A955;
	Fri,  9 Jan 2026 12:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962493; cv=none; b=MN0edToGO+Dmdnp/2esCHp6zBYDksCJT3DqeEEXXLre868JdUZ+oUXhLJhPMKZu/rJ0XFLIKVirKL+bQsYtifyFCjHuNKjUvb3w7Ys+fLGsqEC/6In31HDQKbjR9LBxSo/D2rMcnDggeWnC4tNQ+P0yv7vpEQoMNQFP3C5RhN5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962493; c=relaxed/simple;
	bh=QtRhzk5yf4QSOK+SlYXlTdtD4LQ0eHbE2AzC6PHYKaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lTxU4ErvStGHKjLJ3nFhO+PRl+N5nuXty7FVb1a/IJJqrDHjK0JLKflA8mgk+4+bITrwwSMtQ0ASVzFTTlyJ/jOLAErvuYSEdaI8gXrAFsyvMCA4u3RUPT5xqclzoSo93hmuHWAaU6SuR5yjKSTQvqLnam8gs/a4jWKVsYxxJVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QeEoAhNe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QeEoAhNe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CE20C4CEF1;
	Fri,  9 Jan 2026 12:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962493;
	bh=QtRhzk5yf4QSOK+SlYXlTdtD4LQ0eHbE2AzC6PHYKaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QeEoAhNeXtT91rctL3HBiNruvsbz0M5e/xfAj6dmgk5kgWtJQGqjEzZ36T9ytCaAT
	 r87Elfn49T39y3LmzcZG8K1qaHXPqgRkTwg49+A17wQpYZd2sKRNakpmdUDwWYur7m
	 isKFD+yZATg/qS5xZDvPPI9K6bPD2ejQ19D6zbCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH 6.1 351/634] tools/testing/nvdimm: Use per-DIMM device handle
Date: Fri,  9 Jan 2026 12:40:29 +0100
Message-ID: <20260109112130.731574213@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alison Schofield <alison.schofield@intel.com>

commit f59b701b4674f7955170b54c4167c5590f4714eb upstream.

KASAN reports a global-out-of-bounds access when running these nfit
tests: clear.sh, pmem-errors.sh, pfn-meta-errors.sh, btt-errors.sh,
daxdev-errors.sh, and inject-error.sh.

[] BUG: KASAN: global-out-of-bounds in nfit_test_ctl+0x769f/0x7840 [nfit_test]
[] Read of size 4 at addr ffffffffc03ea01c by task ndctl/1215
[] The buggy address belongs to the variable:
[] handle+0x1c/0x1df4 [nfit_test]

nfit_test_search_spa() uses handle[nvdimm->id] to retrieve a device
handle and triggers a KASAN error when it reads past the end of the
handle array. It should not be indexing the handle array at all.

The correct device handle is stored in per-DIMM test data. Each DIMM
has a struct nfit_mem that embeds a struct acpi_nfit_memdev that
describes the NFIT device handle. Use that device handle here.

Fixes: 10246dc84dfc ("acpi nfit: nfit_test supports translate SPA")
Cc: stable@vger.kernel.org
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>> ---
Link: https://patch.msgid.link/20251031234227.1303113-1-alison.schofield@intel.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/nvdimm/test/nfit.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -670,6 +670,7 @@ static int nfit_test_search_spa(struct n
 		.addr = spa->spa,
 		.region = NULL,
 	};
+	struct nfit_mem *nfit_mem;
 	u64 dpa;
 
 	ret = device_for_each_child(&bus->dev, &ctx,
@@ -687,8 +688,12 @@ static int nfit_test_search_spa(struct n
 	 */
 	nd_mapping = &nd_region->mapping[nd_region->ndr_mappings - 1];
 	nvdimm = nd_mapping->nvdimm;
+	nfit_mem = nvdimm_provider_data(nvdimm);
+	if (!nfit_mem)
+		return -EINVAL;
 
-	spa->devices[0].nfit_device_handle = handle[nvdimm->id];
+	spa->devices[0].nfit_device_handle =
+		__to_nfit_memdev(nfit_mem)->device_handle;
 	spa->num_nvdimms = 1;
 	spa->devices[0].dpa = dpa;
 


