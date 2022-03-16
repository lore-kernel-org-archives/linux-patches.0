Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D273D6B
	for <patches@lists.linux.dev>; Wed, 16 Mar 2022 23:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647471797; x=1679007797;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yEvtPHFFysHl3pMp6x7GJywjDfLrIS+UGRgeUgaP29s=;
  b=ipsK7oqzl8LgIqhOP5DN+anaFKqdTOvm7CfVgDaZcAt4MTy53+J6H1Ns
   u4FatUEM1V1Hg/IxtR5/PCCall5SiQLPuokhf6iXSlr6nDWf3dn360TRQ
   +S2ub9ZX4ppoG0zGeja3HUC1z75Gl+l5TAaIYGwz5ae2TvOQsYHxzM6mx
   A020BD+AagNLHlwH/0FruhAvrhwOyR3bxb8Od1k2qGv3TiQz0Bo5AUPq3
   xAI/Vv58SOw8iaDl81E06m0bAArIVavzKR8xhGu5pSJPnpKK1qStDEDCt
   9RyijXamkxsgg1CgX2j1W4LW2ibb7mtdd+52y8R5M39ExlaFiDOI2ypqz
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10288"; a="238895927"
X-IronPort-AV: E=Sophos;i="5.90,187,1643702400"; 
   d="scan'208";a="238895927"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2022 16:03:16 -0700
X-IronPort-AV: E=Sophos;i="5.90,187,1643702400"; 
   d="scan'208";a="498621384"
Received: from msimpso1-cxt.amr.corp.intel.com (HELO localhost.localdomain) ([10.252.132.128])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2022 16:03:16 -0700
From: Ben Widawsky <ben.widawsky@intel.com>
To: linux-cxl@vger.kernel.org
Cc: patches@lists.linux.dev,
	Ben Widawsky <ben.widawsky@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [RFC PATCH 1/7] cxl/core: Use is_endpoint_decoder
Date: Wed, 16 Mar 2022 16:02:57 -0700
Message-Id: <20220316230303.1813397-2-ben.widawsky@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220316230303.1813397-1-ben.widawsky@intel.com>
References: <20220316230303.1813397-1-ben.widawsky@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Save some characters and directly check decoder type rather than port
type. There's no need to check if the port is an endpoint port since we
already know the decoder, after alloc, has a specified type.

Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
---
 drivers/cxl/core/hdm.c  | 2 +-
 drivers/cxl/core/port.c | 2 +-
 drivers/cxl/cxl.h       | 1 +
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
index a9ae8620701f..808b19215425 100644
--- a/drivers/cxl/core/hdm.c
+++ b/drivers/cxl/core/hdm.c
@@ -190,7 +190,7 @@ static int init_hdm_decoder(struct cxl_port *port, struct cxl_decoder *cxld,
 	else
 		cxld->target_type = CXL_DECODER_ACCELERATOR;
 
-	if (is_cxl_endpoint(to_cxl_port(cxld->dev.parent)))
+	if (is_endpoint_decoder(&cxld->dev))
 		return 0;
 
 	target_list.value =
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 1a0c3d757a29..bda40e91af2b 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -293,7 +293,7 @@ static const struct device_type cxl_decoder_root_type = {
 	.groups = cxl_decoder_root_attribute_groups,
 };
 
-static bool is_endpoint_decoder(struct device *dev)
+bool is_endpoint_decoder(struct device *dev)
 {
 	return dev->type == &cxl_decoder_endpoint_type;
 }
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 4c1963c0c8d2..4a93d409328f 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -357,6 +357,7 @@ struct cxl_dport *cxl_find_dport_by_dev(struct cxl_port *port,
 
 struct cxl_decoder *to_cxl_decoder(struct device *dev);
 bool is_root_decoder(struct device *dev);
+bool is_endpoint_decoder(struct device *dev);
 bool is_cxl_decoder(struct device *dev);
 struct cxl_decoder *cxl_root_decoder_alloc(struct cxl_port *port,
 					   unsigned int nr_targets);
-- 
2.35.1

