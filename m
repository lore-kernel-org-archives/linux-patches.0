Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858012E84A;
	Fri, 24 Nov 2023 18:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zBvBFt3E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C0BC433C8;
	Fri, 24 Nov 2023 18:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852372;
	bh=fYi3gR3V6oRMXkuNqrKmqmlyiPcRnAM3VTFCOERamsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zBvBFt3EkvrtUVmab3pugmyVMojjq3J3aqA9sfcBBZOqpMHo4IVwWg4R9LgyWjudV
	 k4zXip6ouKtHJR/eBIcZKwSqD0ZXcSvtzRHjVU2VRgb6lgqBURlLBDN6JIPwDrGKAS
	 4b8ehLYT0w6HNVmivjLCRBgXDoTBM7+iW1KHslko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Harris <jim.harris@samsung.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 304/372] cxl/region: Fix x1 root-decoder granularity calculations
Date: Fri, 24 Nov 2023 17:51:31 +0000
Message-ID: <20231124172020.562146518@linuxfoundation.org>
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

From: Jim Harris <jim.harris@samsung.com>

[ Upstream commit 98a04c7aced2b43b3ac4befe216c4eecc7257d4b ]

Root decoder granularity must match value from CFWMS, which may not
be the region's granularity for non-interleaved root decoders.

So when calculating granularities for host bridge decoders, use the
region's granularity instead of the root decoder's granularity to ensure
the correct granularities are set for the host bridge decoders and any
downstream switch decoders.

Test configuration is 1 host bridge * 2 switches * 2 endpoints per switch.

Region created with 2048 granularity using following command line:

cxl create-region -m -d decoder0.0 -w 4 mem0 mem2 mem1 mem3 \
		  -g 2048 -s 2048M

Use "cxl list -PDE | grep granularity" to get a view of the granularity
set at each level of the topology.

Before this patch:
        "interleave_granularity":2048,
        "interleave_granularity":2048,
    "interleave_granularity":512,
        "interleave_granularity":2048,
        "interleave_granularity":2048,
    "interleave_granularity":512,
"interleave_granularity":256,

After:
        "interleave_granularity":2048,
        "interleave_granularity":2048,
    "interleave_granularity":4096,
        "interleave_granularity":2048,
        "interleave_granularity":2048,
    "interleave_granularity":4096,
"interleave_granularity":2048,

Fixes: 27b3f8d13830 ("cxl/region: Program target lists")
Cc: <stable@vger.kernel.org>
Signed-off-by: Jim Harris <jim.harris@samsung.com>
Link: https://lore.kernel.org/r/169824893473.1403938.16110924262989774582.stgit@bgt-140510-bm03.eng.stellus.in
[djbw: fixup the prebuilt cxl_test region]
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/region.c    | 9 ++++++++-
 tools/testing/cxl/test/cxl.c | 2 +-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 13b1b18612d3f..ebc1b028555ca 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -1012,7 +1012,14 @@ static int cxl_port_setup_targets(struct cxl_port *port,
 	}
 
 	if (is_cxl_root(parent_port)) {
-		parent_ig = cxlrd->cxlsd.cxld.interleave_granularity;
+		/*
+		 * Root decoder IG is always set to value in CFMWS which
+		 * may be different than this region's IG.  We can use the
+		 * region's IG here since interleave_granularity_store()
+		 * does not allow interleaved host-bridges with
+		 * root IG != region IG.
+		 */
+		parent_ig = p->interleave_granularity;
 		parent_iw = cxlrd->cxlsd.cxld.interleave_ways;
 		/*
 		 * For purposes of address bit routing, use power-of-2 math for
diff --git a/tools/testing/cxl/test/cxl.c b/tools/testing/cxl/test/cxl.c
index c43bb6774f4db..339b31a3319bf 100644
--- a/tools/testing/cxl/test/cxl.c
+++ b/tools/testing/cxl/test/cxl.c
@@ -678,7 +678,7 @@ static void mock_init_hdm_decoder(struct cxl_decoder *cxld)
 			cxld->interleave_ways = 2;
 		else
 			cxld->interleave_ways = 1;
-		cxld->interleave_granularity = 256;
+		cxld->interleave_granularity = 4096;
 		cxld->hpa_range = (struct range) {
 			.start = base,
 			.end = base + size - 1,
-- 
2.42.0



