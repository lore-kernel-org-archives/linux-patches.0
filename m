Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8374A7F
	for <patches@lists.linux.dev>; Tue,  2 Aug 2022 16:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659457208; x=1690993208;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=odLe469vYRFFk0tiQE748w0fTOIT9bUrSyZmNxifBUU=;
  b=QjjBZqtkhsnYQO+iWTrN1xi6MqphoEn72JOQSdUA5kM5vZ++zs1wpY2t
   RMYac5BA9ZJJh/68lDBum8uk2XTXc/l6Dn3rVMyu2IWpqzzsohpHK8KHK
   pfyiMtQu9hwRTTEIH+t4Z3oTMFSfX3iMasuVoQVfERgOHn3c2UkTn0C9X
   Hb/KCPQUQCN36W1oZ1tD0m0rEq4uc9HWooHtDm4/RFJpgqOFPk13f5Tw4
   J0FJhO3kmd2Oz+DD5QCcqrfWmpo8HgvkGZb3v3hf15LBA2Rskm/vpWBrm
   uACAppNwyZb9N48zwzv0o8mGHdh5ohH3e34Mn1pxEXzaF/2t3zreROUgJ
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10427"; a="375756137"
X-IronPort-AV: E=Sophos;i="5.93,211,1654585200"; 
   d="scan'208";a="375756137"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2022 09:18:50 -0700
X-IronPort-AV: E=Sophos;i="5.93,211,1654585200"; 
   d="scan'208";a="602491098"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2022 09:18:49 -0700
Date: Tue, 2 Aug 2022 09:18:47 -0700
From: Tony Luck <tony.luck@intel.com>
To: Yazen Ghannam <yazen.ghannam@amd.com>
Cc: bp@alien8.de, linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	x86@kernel.org
Subject: [PATCH v2] RAS/CEC: Reduce offline page threshold for Intel systems
Message-ID: <YulOZ/Eso0bwUcC4@agluck-desk3.sc.intel.com>
References: <a871b8bd35604921b842dcd65aed0f6c@intel.com>
 <20220701191239.619940-1-tony.luck@intel.com>
 <YukTfuX3QmKV4msI@yaz-fattaah>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YukTfuX3QmKV4msI@yaz-fattaah>

A large scale study of memory errors on Intel systems in data centers
showed that aggressively taking pages with corrected errors offline is
the best strategy of using corrected errors as a predictor of future
uncorrected errors.

Set the threshold to "2" on Intel systems. AMD guidance is that this is
not necessary for their systems.

Reviewed-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---

V2:
	Fix some spelling errors. 
	Add note to commit that AMD systems do not need this.
	Add Yazen's Reviewed-by tag.

 drivers/ras/cec.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/ras/cec.c b/drivers/ras/cec.c
index 42f2fc0bc8a9..321af498ee11 100644
--- a/drivers/ras/cec.c
+++ b/drivers/ras/cec.c
@@ -556,6 +556,14 @@ static int __init cec_init(void)
 	if (ce_arr.disabled)
 		return -ENODEV;
 
+	/*
+	 * Intel systems may avoid uncorrectable errors
+	 * if pages with corrected errors are aggressively
+	 * taken offline.
+	 */
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL)
+		action_threshold = 2;
+
 	ce_arr.array = (void *)get_zeroed_page(GFP_KERNEL);
 	if (!ce_arr.array) {
 		pr_err("Error allocating CE array page!\n");
-- 
2.35.3

