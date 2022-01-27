Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE1522CA8
	for <patches@lists.linux.dev>; Thu, 27 Jan 2022 21:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643318975; x=1674854975;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hnTws23roenYnf9FuTxI5kIVmD5micpi0QGZFv8KyLc=;
  b=EXBUmInugCvIDY7QQ1O3vc8xReyCAPOcEt6ptjt5cjnNBUv+lv6SXLds
   tUp7PWoyEZY9g3/ZAsdQJspKckTRcIG1KcRxs8/P+VQYuSEF7NbnOGsfv
   nj+sn8iv2N0CwqZarq58SY7N7k/jhVbhF4xU+maFUkYvh8u/vJXo7rpSb
   peF3lf37Lkwv6iaoTE8BfbTaeG3kmS7WUf5ogFDufm0b+ExYXFBJF/EJx
   Zc7G+7IotEyBkXmLZut5qKRzycMwLGwpPD2+C4DZZdDAK2DaCd/V1H4wY
   0uyV3031NersRkVVIFZ2+eB3ie2OrDajI1v7TPdHoNbatK9nKWC4PJobD
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="246746135"
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="246746135"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 13:29:33 -0800
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="521402193"
Received: from vrao2-mobl1.gar.corp.intel.com (HELO localhost.localdomain) ([10.252.129.6])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 13:29:32 -0800
From: Ben Widawsky <ben.widawsky@intel.com>
To: linux-cxl@vger.kernel.org
Cc: patches@lists.linux.dev,
	Ben Widawsky <ben.widawsky@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@Huawei.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH 3/4] cxl/core: Extract IW/IG decoding
Date: Thu, 27 Jan 2022 13:29:10 -0800
Message-Id: <20220127212911.127741-4-ben.widawsky@intel.com>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20220127212911.127741-1-ben.widawsky@intel.com>
References: <20220127212911.127741-1-ben.widawsky@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Interleave granularity and ways have specification defined encodings.
Extracting this functionality into the common header file allows other
consumers to make use of it.

Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>

---

I'm in favor of making these helps part of UABI. Having userspace and
kernel disagree (because of differing spec versions for example) would
be difficult to manage.

Thoughts?
---
 drivers/cxl/core/hdm.c | 11 ++---------
 drivers/cxl/cxl.h      | 17 +++++++++++++++++
 2 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
index 4955ba16c9c8..a28369f264da 100644
--- a/drivers/cxl/core/hdm.c
+++ b/drivers/cxl/core/hdm.c
@@ -133,21 +133,14 @@ static int to_interleave_granularity(u32 ctrl)
 {
 	int val = FIELD_GET(CXL_HDM_DECODER0_CTRL_IG_MASK, ctrl);
 
-	return 256 << val;
+	return cxl_to_interleave_granularity(val);
 }
 
 static int to_interleave_ways(u32 ctrl)
 {
 	int val = FIELD_GET(CXL_HDM_DECODER0_CTRL_IW_MASK, ctrl);
 
-	switch (val) {
-	case 0 ... 4:
-		return 1 << val;
-	case 8 ... 10:
-		return 3 << (val - 8);
-	default:
-		return 0;
-	}
+	return cxl_to_interleave_ways(val);
 }
 
 static int init_hdm_decoder(struct cxl_port *port, struct cxl_decoder *cxld,
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 962629c5775f..13fb06849199 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -64,6 +64,23 @@ static inline int cxl_hdm_decoder_count(u32 cap_hdr)
 	return val ? val * 2 : 1;
 }
 
+static inline int cxl_to_interleave_granularity(u16 ig)
+{
+	return 256 << ig;
+}
+
+static inline int cxl_to_interleave_ways(u8 eniw)
+{
+	switch (eniw) {
+	case 0 ... 4:
+		return 1 << eniw;
+	case 8 ... 10:
+		return 3 << (eniw - 8);
+	default:
+		return 0;
+	}
+}
+
 /* CXL 2.0 8.2.8.1 Device Capabilities Array Register */
 #define CXLDEV_CAP_ARRAY_OFFSET 0x0
 #define   CXLDEV_CAP_ARRAY_CAP_ID 0
-- 
2.35.0

