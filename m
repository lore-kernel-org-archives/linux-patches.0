Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44EBA23D0
	for <patches@lists.linux.dev>; Fri, 22 Jul 2022 23:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658532829; x=1690068829;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mLYExMQ8UHt3jObNveidiNRuSpjvL66K2gZRbegeAfs=;
  b=YB1zEJUy3dbpZfB7RTQV1Q/4/7HSO34YWLcEH/TRnfIWQ7k/EAcv/+LX
   LBKiIWaZhH+expo/zqG1WJFWprVVcY33Yv7M5vBTfYmzqcGbgACGj733K
   kqV/J5cEgy8Dhzl7DwTZDRok/tubm7jtmKXEJajaCU2S/qc59oV3/xA/N
   zt5jpMRXVBwIs4JsViWRdh93Auc8/KNSL46fBgZyO8Xvy2u97RKqpFJXN
   bHjI8YU1KtYHo7yMjcZuPseZTpXfAxbZcdgQ2UWplDbiOUXshCLuk1OUr
   3NnF5m97bzuv8YeQGBfj9SmBLWNjee73UVVMpo1A7so1+8HH7E2uexiEq
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10416"; a="288603559"
X-IronPort-AV: E=Sophos;i="5.93,186,1654585200"; 
   d="scan'208";a="288603559"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2022 16:33:47 -0700
X-IronPort-AV: E=Sophos;i="5.93,186,1654585200"; 
   d="scan'208";a="574346061"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2022 16:33:47 -0700
From: Tony Luck <tony.luck@intel.com>
To: linux-edac@vger.kernel.org
Cc: Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Aristeu Rozanski <aris@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 1/4] EDAC/skx_common: Add ChipSelect ADXL component
Date: Fri, 22 Jul 2022 16:33:35 -0700
Message-Id: <20220722233338.341567-2-tony.luck@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220722233338.341567-1-tony.luck@intel.com>
References: <20220722233338.341567-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

Each pseudo channel of HBM has its own retry_rd_err_log registers.
The bit 0 of ChipSelect ADXL component encodes the pseudo channel
number of HBM memory. So add ChipSelect ADXL component to get HBM
pseudo channel number.

Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 drivers/edac/skx_common.h | 4 ++++
 drivers/edac/skx_common.c | 5 +++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/edac/skx_common.h b/drivers/edac/skx_common.h
index 03ac067a80b9..70ec4f41911b 100644
--- a/drivers/edac/skx_common.h
+++ b/drivers/edac/skx_common.h
@@ -108,16 +108,19 @@ enum {
 	INDEX_MEMCTRL,
 	INDEX_CHANNEL,
 	INDEX_DIMM,
+	INDEX_CS,
 	INDEX_NM_FIRST,
 	INDEX_NM_MEMCTRL = INDEX_NM_FIRST,
 	INDEX_NM_CHANNEL,
 	INDEX_NM_DIMM,
+	INDEX_NM_CS,
 	INDEX_MAX
 };
 
 #define BIT_NM_MEMCTRL	BIT_ULL(INDEX_NM_MEMCTRL)
 #define BIT_NM_CHANNEL	BIT_ULL(INDEX_NM_CHANNEL)
 #define BIT_NM_DIMM	BIT_ULL(INDEX_NM_DIMM)
+#define BIT_NM_CS	BIT_ULL(INDEX_NM_CS)
 
 struct decoded_addr {
 	struct skx_dev *dev;
@@ -129,6 +132,7 @@ struct decoded_addr {
 	int	sktways;
 	int	chanways;
 	int	dimm;
+	int	cs;
 	int	rank;
 	int	channel_rank;
 	u64	rank_address;
diff --git a/drivers/edac/skx_common.c b/drivers/edac/skx_common.c
index 19c17c5198c5..ee074fb507d8 100644
--- a/drivers/edac/skx_common.c
+++ b/drivers/edac/skx_common.c
@@ -27,9 +27,11 @@ static const char * const component_names[] = {
 	[INDEX_MEMCTRL]		= "MemoryControllerId",
 	[INDEX_CHANNEL]		= "ChannelId",
 	[INDEX_DIMM]		= "DimmSlotId",
+	[INDEX_CS]		= "ChipSelect",
 	[INDEX_NM_MEMCTRL]	= "NmMemoryControllerId",
 	[INDEX_NM_CHANNEL]	= "NmChannelId",
 	[INDEX_NM_DIMM]		= "NmDimmSlotId",
+	[INDEX_NM_CS]		= "NmChipSelect",
 };
 
 static int component_indices[ARRAY_SIZE(component_names)];
@@ -139,10 +141,13 @@ static bool skx_adxl_decode(struct decoded_addr *res, bool error_in_1st_level_me
 			       (int)adxl_values[component_indices[INDEX_NM_CHANNEL]] : -1;
 		res->dimm    = (adxl_nm_bitmap & BIT_NM_DIMM) ?
 			       (int)adxl_values[component_indices[INDEX_NM_DIMM]] : -1;
+		res->cs      = (adxl_nm_bitmap & BIT_NM_CS) ?
+			       (int)adxl_values[component_indices[INDEX_NM_CS]] : -1;
 	} else {
 		res->imc     = (int)adxl_values[component_indices[INDEX_MEMCTRL]];
 		res->channel = (int)adxl_values[component_indices[INDEX_CHANNEL]];
 		res->dimm    = (int)adxl_values[component_indices[INDEX_DIMM]];
+		res->cs      = (int)adxl_values[component_indices[INDEX_CS]];
 	}
 
 	if (res->imc > NUM_IMC - 1 || res->imc < 0) {
-- 
2.35.3

