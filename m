Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 291D77F
	for <patches@lists.linux.dev>; Thu, 14 Sep 2023 02:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694659629; x=1726195629;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=7AqD5A5iW3EXE8bXRwZVy9z6UDY0KU2vLZ++lAl1CMw=;
  b=mV6qqIXVBhkLEOpFLE23DKz3nPm2m3Dy+RXaoLPolM0osnVe2vlXm/iA
   SKeSUJQzwQ8aaBTHaiUcv+/vz8gomAgpn79u2MKop9M574diY6h3b3lGp
   DPprHwr/w5fNAv+jWGHw2hvZhGlmtFVAyBiCf4N/6W19IkJDf1FO5Jlrc
   AK03NnPvnlTz62ZLD27SPb7DbfabvO2FLKvHT1A77tdl/UOihr4RWPDBB
   KJRN2NA1u07Vkx1vBB2WYZpi43QhII9Z+kJwbXkJUW002+EC/hC7HHyFb
   abmFzPVzzmVtccXuXudxqsuS0DEJQh3BTCQHUyaVCnDwadI+8Oj/iyfs9
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="378760917"
X-IronPort-AV: E=Sophos;i="6.02,144,1688454000"; 
   d="scan'208";a="378760917"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 19:47:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="868067061"
X-IronPort-AV: E=Sophos;i="6.02,144,1688454000"; 
   d="scan'208";a="868067061"
Received: from zhiquan-linux-dev.bj.intel.com ([10.238.156.102])
  by orsmga004.jf.intel.com with ESMTP; 13 Sep 2023 19:47:04 -0700
From: Zhiquan Li <zhiquan1.li@intel.com>
To: x86@kernel.org,
	linux-edac@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	bp@alien8.de,
	tony.luck@intel.com,
	naoya.horiguchi@nec.com
Cc: zhiquan1.li@intel.com,
	Youquan Song <youquan.song@intel.com>
Subject: [PATCH RESEND v2] x86/mce: Set PG_hwpoison page flag to avoid the capture kernel panic
Date: Thu, 14 Sep 2023 11:05:39 +0800
Message-Id: <20230914030539.1622477-1-zhiquan1.li@intel.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Kdump can exclude the HWPosion page to avoid touch the error page
again, the prerequisite is the PG_hwpoison page flag is set.
However, for some MCE fatal error cases, there is no opportunity
to queue a task for calling memory_failure(), as a result,
the capture kernel touches the error page again and panics.

Add function mce_set_page_hwpoison_now() which marks a page as
HWPoison before kernel panic() for MCE error, so that the dump
program can check and skip the error page and prevent the capture
kernel panic.

[Tony: Changed TestSetPageHWPoison() to SetPageHWPoison()]

Co-developed-by: Youquan Song <youquan.song@intel.com>
Signed-off-by: Youquan Song <youquan.song@intel.com>
Signed-off-by: Zhiquan Li <zhiquan1.li@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>

---
V2 RESEND notes:
- No changes on this, just rebasing as v6.6-rc1 is out.
- Added the tag from Naoya.
  Link: https://lore.kernel.org/all/20230719211625.298785-1-tony.luck@intel.com/#t

Changes since V1:
- Revised the commit message as per Naoya's suggestion.
- Replaced "TODO" comment in code with comments based on mailing list
  discussion on the lack of value in covering other page types.
  Link: https://lore.kernel.org/all/20230127015030.30074-1-tony.luck@intel.com/
---
 arch/x86/kernel/cpu/mce/core.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 6f35f724cc14..2725698268f3 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -156,6 +156,22 @@ void mce_unregister_decode_chain(struct notifier_block *nb)
 }
 EXPORT_SYMBOL_GPL(mce_unregister_decode_chain);
 
+/*
+ * Kdump can exclude the HWPosion page to avoid touch the error page again,
+ * the prerequisite is the PG_hwpoison page flag is set. However, for some
+ * MCE fatal error cases, there are no opportunity to queue a task
+ * for calling memory_failure(), as a result, the capture kernel panics.
+ * This function marks the page as HWPoison before kernel panic() for MCE.
+ */
+static void mce_set_page_hwpoison_now(unsigned long pfn)
+{
+	struct page *p;
+
+	p = pfn_to_online_page(pfn);
+	if (p)
+		SetPageHWPoison(p);
+}
+
 static void __print_mce(struct mce *m)
 {
 	pr_emerg(HW_ERR "CPU %d: Machine Check%s: %Lx Bank %d: %016Lx\n",
@@ -286,6 +302,8 @@ static noinstr void mce_panic(const char *msg, struct mce *final, char *exp)
 	if (!fake_panic) {
 		if (panic_timeout == 0)
 			panic_timeout = mca_cfg.panic_timeout;
+		if (final && (final->status & MCI_STATUS_ADDRV))
+			mce_set_page_hwpoison_now(final->addr >> PAGE_SHIFT);
 		panic(msg);
 	} else
 		pr_emerg(HW_ERR "Fake kernel panic: %s\n", msg);
-- 
2.25.1

