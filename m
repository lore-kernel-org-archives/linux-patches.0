Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC337498
	for <patches@lists.linux.dev>; Fri,  1 Jul 2022 19:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656702775; x=1688238775;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7Ji9e0hAxIJNMDuh9KYE+lqOyY+7TlQzjmXgYGpP8ic=;
  b=b8YNBbiuLJoPYkDcUf1vgEya9yMdfEeGrFWq5/5ikprSI9oC9y3RsAaR
   olbn6/TSXvtmtoATHjVykmV1WLoT7aS7DEhwBDyqOu6uUpVpCzEVzIpvH
   R20jd1VgXh/P5C1Sl6Hxn4VuooXObY6FVq3rptUSR3qMgWBEpgN+sK7Jl
   pNFV86ikp1z4jYwpgMx1Qhz3WL5wo3pULast2f6KlsetmG4bgYD7eSUYu
   kj+BykiQqZrtB2b3UDOPoYxJ1eJjK4sIESh6vRFhYZV/KnKdvFcOxyCak
   wMteA28CiEhiAizKiEy8lpWThmT1DnaJPvLkEplCSlkKwdBtSOFbYXT9m
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10395"; a="344410072"
X-IronPort-AV: E=Sophos;i="5.92,238,1650956400"; 
   d="scan'208";a="344410072"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2022 12:12:44 -0700
X-IronPort-AV: E=Sophos;i="5.92,238,1650956400"; 
   d="scan'208";a="596366381"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2022 12:12:44 -0700
From: Tony Luck <tony.luck@intel.com>
To: yazen.ghannam@amd.com
Cc: tony.luck@intel.com,
	bp@alien8.de,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	x86@kernel.org
Subject: [PATCH] RAS/CEC: Reduce offline page threshold for Intel systems
Date: Fri,  1 Jul 2022 12:12:39 -0700
Message-Id: <20220701191239.619940-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <a871b8bd35604921b842dcd65aed0f6c@intel.com>
References: <a871b8bd35604921b842dcd65aed0f6c@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A large scale study of memory errors on Intel systems in data centers
showed that aggressively taking pages with corrected errors offline is
the best strategy of using corrected errors as a predictor of future
uncorrected errors.

It is unknown whether this would help other vendors. There are some
indicators that it would not.

Set the threshold to "2" on Intel systems.

Do-not-apply-without-agreement-from-AMD
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 drivers/ras/cec.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/ras/cec.c b/drivers/ras/cec.c
index 42f2fc0bc8a9..b1fc193b2036 100644
--- a/drivers/ras/cec.c
+++ b/drivers/ras/cec.c
@@ -556,6 +556,14 @@ static int __init cec_init(void)
 	if (ce_arr.disabled)
 		return -ENODEV;
 
+	/*
+	 * Intel systems may avoid uncorreectable errors
+	 * if pages with corrected errors are aggresively
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

