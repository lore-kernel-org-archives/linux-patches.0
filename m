Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9415A33076;
	Fri, 24 Nov 2023 18:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ktYn7yqm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22646C433C8;
	Fri, 24 Nov 2023 18:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852288;
	bh=IYpiaQ38uRI+fjyTaaQXahJx9wGPb9grW1I13Qq9ubY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ktYn7yqmiPv3GlB+/HpwJ4hAqSASONLsc+WL3PFENqaUMNIUfYhLbqLPOi9J2M9Zf
	 Ldd4kTWiobHsng5CqxYWRyl3GIb8YQ8WBGbKtRAoZj+RRnqyeB1WNa365ZCHHYqA2R
	 VTTxuCqy0Y8uhwC9/Lh/BYWNJ0SMT+am2DyBLsQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vishal Verma <vishal.l.verma@intel.com>,
	Gregory Price <gregory.price@memverge.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Fan Ni <fan.ni@samsung.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 295/372] cxl/region: Validate region mode vs decoder mode
Date: Fri, 24 Nov 2023 17:51:22 +0000
Message-ID: <20231124172020.264449593@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
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

From: Dan Williams <dan.j.williams@intel.com>

[ Upstream commit 1b9b7a6fd618239db47a83da39dff9e725a5865a ]

In preparation for a new region mode, do not, for example, allow
'ram' decoders to be assigned to 'pmem' regions and vice versa.

Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
Reviewed-by: Gregory Price <gregory.price@memverge.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Tested-by: Fan Ni <fan.ni@samsung.com>
Link: https://lore.kernel.org/r/167601995111.1924368.7459128614177994602.stgit@dwillia2-xfh.jf.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Stable-dep-of: 0718588c7aaa ("cxl/region: Do not try to cleanup after cxl_region_setup_targets() fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/region.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 9709bbf773b72..99b0501066e57 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -1191,6 +1191,12 @@ static int cxl_region_attach(struct cxl_region *cxlr,
 	struct cxl_dport *dport;
 	int i, rc = -ENXIO;
 
+	if (cxled->mode != cxlr->mode) {
+		dev_dbg(&cxlr->dev, "%s region mode: %d mismatch: %d\n",
+			dev_name(&cxled->cxld.dev), cxlr->mode, cxled->mode);
+		return -EINVAL;
+	}
+
 	if (cxled->mode == CXL_DECODER_DEAD) {
 		dev_dbg(&cxlr->dev, "%s dead\n", dev_name(&cxled->cxld.dev));
 		return -ENODEV;
-- 
2.42.0



