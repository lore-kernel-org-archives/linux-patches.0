Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE1A7192B7B;
	Tue, 10 Sep 2024 10:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964399; cv=none; b=lEe+ZqcUnl59iOKNTk13kTRkKyPIejYL9pgd+mpGMuo47CHDByrcfGPzjqH32mYm+0St1Juui9CodBojKhr90h9nSvcMzkucqklU7AQB8ai2+p9wL6nW6Kvo8SOWCScpT+sy1EATBEPJEjieu/31U31UZr6X7Qa6Suj+eo/Dlj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964399; c=relaxed/simple;
	bh=nJG/HJiXyrElPFehPKZZlS+VrglqQt7LDX/wtaUTeJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TrXT81LWj64hzxJ/1JhGoh4uWoDdsGm5WECNp9ysq0dQaVkWL1x3qJmTRXc1AdIhDDUYEnmbG94fPqwcYXUmxhBBenKPsLFAkojZ2jFtwmIRVtLu9JhpCuiA7KNcW1g2SIRbbljIdj4vsFTVwLQ3Gat+IQSCUQZxVRml510x/fY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WeSJbHng; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WeSJbHng"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C43AC4CEC3;
	Tue, 10 Sep 2024 10:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964399;
	bh=nJG/HJiXyrElPFehPKZZlS+VrglqQt7LDX/wtaUTeJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WeSJbHngS00uWa8r02Y1ekgT7FyZVS52HJ4sp6fqDEt/AQdecUh5EFNYSHvVKtMK+
	 78fyGkcsu239jclnf6kOLao4mSuw7qXpBlxqAFF/Ds2semmsIRWT2HUZzAc1G4HnwN
	 MQkDDKpAQuM/hSWlfoDmZJDDVfwnPBRrkwmhw160=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 169/269] cxl/region: Verify target positions using the ordered target list
Date: Tue, 10 Sep 2024 11:32:36 +0200
Message-ID: <20240910092614.174883304@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

[ Upstream commit 82a3e3a235633aa0575fac9507d648dd80f3437f ]

When a root decoder is configured the interleave target list is read
from the BIOS populated CFMWS structure. Per the CXL spec 3.1 Table
9-22 the target list is in interleave order. The CXL driver populates
its decoder target list in the same order and stores it in 'struct
cxl_switch_decoder' field "@target: active ordered target list in
current decoder configuration"

Given the promise of an ordered list, the driver can stop duplicating
the work of BIOS and simply check target positions against the ordered
list during region configuration.

The simplified check against the ordered list is presented here.
A follow-on patch will remove the unused code.

For Modulo arithmetic this is not a fix, only a simplification.
For XOR arithmetic this is a fix for HB IW of 3,6,12.

Fixes: f9db85bfec0d ("cxl/acpi: Support CXL XOR Interleave Math (CXIMS)")
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Link: https://patch.msgid.link/35d08d3aba08fee0f9b86ab1cef0c25116ca8a55.1719980933.git.alison.schofield@intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/region.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index bc5a43897d57..5060d9802795 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -1528,10 +1528,13 @@ static int cxl_region_attach_position(struct cxl_region *cxlr,
 				      const struct cxl_dport *dport, int pos)
 {
 	struct cxl_memdev *cxlmd = cxled_to_memdev(cxled);
+	struct cxl_switch_decoder *cxlsd = &cxlrd->cxlsd;
+	struct cxl_decoder *cxld = &cxlsd->cxld;
+	int iw = cxld->interleave_ways;
 	struct cxl_port *iter;
 	int rc;
 
-	if (cxlrd->calc_hb(cxlrd, pos) != dport) {
+	if (dport != cxlrd->cxlsd.target[pos % iw]) {
 		dev_dbg(&cxlr->dev, "%s:%s invalid target position for %s\n",
 			dev_name(&cxlmd->dev), dev_name(&cxled->cxld.dev),
 			dev_name(&cxlrd->cxlsd.cxld.dev));
-- 
2.43.0



