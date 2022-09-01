Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DA96746F
	for <patches@lists.linux.dev>; Thu,  1 Sep 2022 19:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662061402; x=1693597402;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+KjT95G5kF5GHfkSihejwy6zK0A0g4kfEgY4RnNnD+o=;
  b=Me5lk02OYLsOuO+OQFWGYDkUpTSp+wN15rP6pDmkR3fJrYRrZfCtHseN
   +oBkj0BDtpupd1kIMZUwMBgucS6ShKu6FpcEz0hpJBbPdmqwK2bBox1Us
   no9r5CRKVpw+pSR55wjHAsAvlsqWbyRt/bqMDnnSp2G3Zv+jaRtz30YNC
   Oq2l+bV7NKEtSNt0LxzD7vL/WktFRXqxpA2KHwI1LxYwh+toDCTMZgRGS
   SOLYrDxgfB0z2doumFm0F/pynKsWZoO1L+TDEBjtg3ni116si+0PnuSHD
   tMw7Xg/hC8yB/3PDd3H4TsG98UVurOGsJoA103ZO3H2XupZq/+u8by9+T
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10457"; a="296595789"
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="296595789"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 12:43:20 -0700
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="674020249"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 12:43:20 -0700
From: Tony Luck <tony.luck@intel.com>
To: linux-edac@vger.kernel.org
Cc: Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Youquan Song <youquan.song@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Aristeu Rozanski <aris@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 1/3] EDAC/skx_common: Use driver decoder first
Date: Thu,  1 Sep 2022 12:43:08 -0700
Message-Id: <20220901194310.115427-2-tony.luck@intel.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220901194310.115427-1-tony.luck@intel.com>
References: <20220901194310.115427-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

The performance of driver decoder[1] is better than the performance
of firmware decoder[2], especially on frequent correctable errors.

So use the driver decoder first, fall back to firmware decoder if
the driver decoder is unavailable. Also rename the function pointer
skx_decode to driver_decode (better name to contrast with adxl_decode).

[1] Decode errors by extracting error information from registers of
    memory controllers and/or MCA bank registers.

[2] Decode errors by calling ACPI DSM methods.

Co-developed-by: Youquan Song <youquan.song@intel.com>
Signed-off-by: Youquan Song <youquan.song@intel.com>
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 drivers/edac/skx_common.h |  1 +
 drivers/edac/skx_base.c   |  9 +++++++--
 drivers/edac/skx_common.c | 16 +++++++++-------
 3 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/edac/skx_common.h b/drivers/edac/skx_common.h
index 03ac067a80b9..880ecd15ca42 100644
--- a/drivers/edac/skx_common.h
+++ b/drivers/edac/skx_common.h
@@ -136,6 +136,7 @@ struct decoded_addr {
 	int	column;
 	int	bank_address;
 	int	bank_group;
+	bool	decoded_by_adxl;
 };
 
 struct res_config {
diff --git a/drivers/edac/skx_base.c b/drivers/edac/skx_base.c
index 1abc020d49ab..7e2762f62eec 100644
--- a/drivers/edac/skx_base.c
+++ b/drivers/edac/skx_base.c
@@ -714,8 +714,13 @@ static int __init skx_init(void)
 
 	skx_set_decode(skx_decode, skx_show_retry_rd_err_log);
 
-	if (nvdimm_count && skx_adxl_get() == -ENODEV)
-		skx_printk(KERN_NOTICE, "Only decoding DDR4 address!\n");
+	if (nvdimm_count && skx_adxl_get() != -ENODEV) {
+		skx_set_decode(NULL, skx_show_retry_rd_err_log);
+	} else {
+		if (nvdimm_count)
+			skx_printk(KERN_NOTICE, "Only decoding DDR4 address!\n");
+		skx_set_decode(skx_decode, skx_show_retry_rd_err_log);
+	}
 
 	/* Ensure that the OPSTATE is set correctly for POLL or NMI */
 	opstate_init();
diff --git a/drivers/edac/skx_common.c b/drivers/edac/skx_common.c
index 19c17c5198c5..9b10c359849b 100644
--- a/drivers/edac/skx_common.c
+++ b/drivers/edac/skx_common.c
@@ -40,7 +40,7 @@ static char *adxl_msg;
 static unsigned long adxl_nm_bitmap;
 
 static char skx_msg[MSG_SIZE];
-static skx_decode_f skx_decode;
+static skx_decode_f driver_decode;
 static skx_show_retry_log_f skx_show_retry_rd_err_log;
 static u64 skx_tolm, skx_tohm;
 static LIST_HEAD(dev_edac_list);
@@ -173,6 +173,8 @@ static bool skx_adxl_decode(struct decoded_addr *res, bool error_in_1st_level_me
 			break;
 	}
 
+	res->decoded_by_adxl = true;
+
 	return true;
 }
 
@@ -183,7 +185,7 @@ void skx_set_mem_cfg(bool mem_cfg_2lm)
 
 void skx_set_decode(skx_decode_f decode, skx_show_retry_log_f show_retry_log)
 {
-	skx_decode = decode;
+	driver_decode = decode;
 	skx_show_retry_rd_err_log = show_retry_log;
 }
 
@@ -591,7 +593,7 @@ static void skx_mce_output_error(struct mem_ctl_info *mci,
 			break;
 		}
 	}
-	if (adxl_component_count) {
+	if (res->decoded_by_adxl) {
 		len = snprintf(skx_msg, MSG_SIZE, "%s%s err_code:0x%04x:0x%04x %s",
 			 overflow ? " OVERFLOW" : "",
 			 (uncorrected_error && recoverable) ? " recoverable" : "",
@@ -651,11 +653,11 @@ int skx_mce_check_error(struct notifier_block *nb, unsigned long val,
 	memset(&res, 0, sizeof(res));
 	res.addr = mce->addr;
 
-	if (adxl_component_count) {
-		if (!skx_adxl_decode(&res, skx_error_in_1st_level_mem(mce)))
+	/* Try driver decoder first */
+	if (!(driver_decode && driver_decode(&res))) {
+		/* Then try firmware decoder (ACPI DSM methods) */
+		if (!(adxl_component_count && skx_adxl_decode(&res, skx_error_in_1st_level_mem(mce))))
 			return NOTIFY_DONE;
-	} else if (!skx_decode || !skx_decode(&res)) {
-		return NOTIFY_DONE;
 	}
 
 	mci = res.dev->imc[res.imc].mci;
-- 
2.37.1

