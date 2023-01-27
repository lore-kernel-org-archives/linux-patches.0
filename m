Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0260615A8
	for <patches@lists.linux.dev>; Fri, 27 Jan 2023 01:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674784241; x=1706320241;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=qyfxmzLE5JfhsIee4y1DuROPldIjNhc8I6zB/cwwAS0=;
  b=WrkoMTf/vlBXEis98T6KTMNDvU6lo2KLvIzRMTyFYboL69YCRU1PKGAh
   93rFAtQ6eujVZHkS+Ih+ogvYcbxSVjCsE2WnYk8pL69jaL5xkN1Z/xG6P
   XPaaxGaizrABzrspwQyazd6IWlCW60MuSiFnmtiCvnC5ChL1HsRqplIhc
   zHVLPwjkwa86kanUsFcYO8unUfz4akyDD2B/Swg5tjMdwB+TnA9z+I4aa
   I9zKFLU7UWIJs5MVw5Gj/1okjtI2OF7/y64BtzNWHBFi7tovBEMtKnGTs
   hmxdzLfGEwykAxf1ln1CBm0LNd+4CMUBPaXwju7LlOqYzQpGvBO4tHIGf
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10602"; a="391553842"
X-IronPort-AV: E=Sophos;i="5.97,249,1669104000"; 
   d="scan'208";a="391553842"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2023 17:50:40 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10602"; a="908503263"
X-IronPort-AV: E=Sophos;i="5.97,249,1669104000"; 
   d="scan'208";a="908503263"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2023 17:50:39 -0800
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>,
	x86@kernel.org,
	linux-edac@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Zhiquan Li <zhiquan1.li@intel.com>,
	Youquan Song <youquan.song@intel.com>,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH] x86/mce: Set PG_hwpoison page flag to avoid the capture kernel panic
Date: Thu, 26 Jan 2023 17:50:30 -0800
Message-Id: <20230127015030.30074-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.39.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhiquan Li <zhiquan1.li@intel.com>

Kdump can exclude the HWPosion page to avoid touch the error page
again, the prerequisite is the PG_hwpoison page flag is set.
However, for some MCE fatal error cases, there are no opportunity
to queue a task for calling memory_failure(), as a result,
the capture kernel touches the error page again and panics.

Add function mce_set_page_hwpoison_now() which mark a page as
HWPoison before kernel panic() for MCE error, so that the dump
program can check and skip the error page and prevent the capture
kernel panic.

[Tony: Changed TestSetPageHWPoison() to SetPageHWPoison()]

Co-developedd-by: Youquan Song <youquan.song@intel.com>
Signed-off-by: Youquan Song <youquan.song@intel.com>
Signed-off-by: Zhiquan Li <zhiquan1.li@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/mce/core.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 2c8ec5c71712..0630999c6311 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -162,6 +162,24 @@ void mce_unregister_decode_chain(struct notifier_block *nb)
 }
 EXPORT_SYMBOL_GPL(mce_unregister_decode_chain);
 
+/*
+ * Kdump can exclude the HWPosion page to avoid touch the error page again,
+ * the prerequisite is the PG_hwpoison page flag is set. However, for some
+ * MCE fatal error cases, there are no opportunity to queue a task
+ * for calling memory_failure(), as a result, the capture kernel panic.
+ * This function mark the page as HWPoison before kernel panic() for MCE.
+ */
+static void mce_set_page_hwpoison_now(unsigned long pfn)
+{
+	struct page *p;
+
+	/* TODO: need to handle other sort of page, like SGX, PMEM and
+	 * HugeTLB pages*/
+	p = pfn_to_online_page(pfn);
+	if (p)
+		SetPageHWPoison(p);
+}
+
 static void __print_mce(struct mce *m)
 {
 	pr_emerg(HW_ERR "CPU %d: Machine Check%s: %Lx Bank %d: %016Lx\n",
@@ -292,6 +310,8 @@ static noinstr void mce_panic(const char *msg, struct mce *final, char *exp)
 	if (!fake_panic) {
 		if (panic_timeout == 0)
 			panic_timeout = mca_cfg.panic_timeout;
+		if (final && (final->status & MCI_STATUS_ADDRV))
+			 mce_set_page_hwpoison_now(final->addr >> PAGE_SHIFT);
 		panic(msg);
 	} else
 		pr_emerg(HW_ERR "Fake kernel panic: %s\n", msg);
-- 
2.39.1

