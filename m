Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC84139FE9;
	Fri, 24 Nov 2023 18:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wK5QeOkd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 686BCC433C7;
	Fri, 24 Nov 2023 18:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849967;
	bh=8MIfYySpr46s8nkSLUVQ0qsBMRnQv5WdlS9KFuOAhYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wK5QeOkdC3JMkkju39U1uY9P3wnwpv7PTJcrKznx6RuZzSFJWCVX1Y9R7mUSSTL3T
	 UBNgr3qphbLkTq8xAp02y7N5eAJCfeVJ10lyhV6AAmIxpYdJgnheCp6VkB4M/xKSVA
	 NECSNovudsj6lBEo76SfyOkapjEZyz5vgEALe92w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Harris <jim.harris@samsung.com>,
	Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 6.6 393/530] cxl/region: Fix x1 root-decoder granularity calculations
Date: Fri, 24 Nov 2023 17:49:19 +0000
Message-ID: <20231124172039.986086534@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

From: Jim Harris <jim.harris@samsung.com>

commit 98a04c7aced2b43b3ac4befe216c4eecc7257d4b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cxl/core/region.c    |    9 ++++++++-
 tools/testing/cxl/test/cxl.c |    2 +-
 2 files changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -1127,7 +1127,14 @@ static int cxl_port_setup_targets(struct
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
--- a/tools/testing/cxl/test/cxl.c
+++ b/tools/testing/cxl/test/cxl.c
@@ -831,7 +831,7 @@ static void mock_init_hdm_decoder(struct
 			cxld->interleave_ways = 2;
 		else
 			cxld->interleave_ways = 1;
-		cxld->interleave_granularity = 256;
+		cxld->interleave_granularity = 4096;
 		cxld->hpa_range = (struct range) {
 			.start = base,
 			.end = base + size - 1,


