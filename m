Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A826A1C774
	for <patches@lists.linux.dev>; Fri, 16 Jun 2023 18:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686940076; x=1718476076;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zxtEr+49Z8SAPXXw+VLSmKO/k0+mLZ8hYyIUwukrFTo=;
  b=EOwbK+81BqUst+mAy4bZ+iffJO5YOnUqoXTnLwH9Vsnn9muZw8h1lNTC
   6d0rqufa7Nz6fGbi6UBuc1BwxY5M1lJF2o9kkJWWKw4ZYYB0TdBozUspB
   gbfWsj3lXT5/aKg7vjU00ETVTV+e70BfJSDbVmf3dWzcmYJEsrJtxtKoO
   pSdMgy9kepQBzucBm9HH9dTDC6vELfpV5H4n3JHJljReWM1hG2Jybgpjj
   piBiAs7MmvXqC18MV9OmeFkRSFqJZPSHD247wJbfO1pQ2pzSTSyrJC7Nh
   v133WxmdBp3TSGisjluShb1UEE+4V32FMEZGSRLvry+HomqQ82OdoBHm4
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10743"; a="361815200"
X-IronPort-AV: E=Sophos;i="6.00,248,1681196400"; 
   d="scan'208";a="361815200"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 11:27:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10743"; a="783018175"
X-IronPort-AV: E=Sophos;i="6.00,248,1681196400"; 
   d="scan'208";a="783018175"
Received: from agluck-desk3.sc.intel.com ([172.25.222.74])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 11:27:51 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Yazen Ghannam <yazen.ghannam@amd.com>,
	Smita.KoralahalliChannabasappa@amd.com,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	linux-edac@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v6 3/4] x86/mce: Handle AMD threshold interrupt storms
Date: Fri, 16 Jun 2023 11:27:43 -0700
Message-Id: <20230616182744.17632-4-tony.luck@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230616182744.17632-1-tony.luck@intel.com>
References: <20230411173841.70491-1-tony.luck@intel.com>
 <20230616182744.17632-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>

Add hook into core storm handling code for AMD threshold interrupts.

Disable the interrupt on the corresponding CPU and bank. Re-enable
back the interrupts if enough consecutive polls of the bank show no
corrected errors.

Turning off the threshold interrupts is the best solution on AMD systems
as other error severities will still be handled even if the threshold
interrupts are disabled.

[Tony: Updated places where storm tracking variables moved into a
structure]

Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/mce/internal.h |  2 ++
 arch/x86/kernel/cpu/mce/amd.c      | 49 ++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/mce/core.c     |  3 ++
 3 files changed, 54 insertions(+)

diff --git a/arch/x86/kernel/cpu/mce/internal.h b/arch/x86/kernel/cpu/mce/internal.h
index eae88a824d97..22899d28138f 100644
--- a/arch/x86/kernel/cpu/mce/internal.h
+++ b/arch/x86/kernel/cpu/mce/internal.h
@@ -232,6 +232,7 @@ extern bool filter_mce(struct mce *m);
 
 #ifdef CONFIG_X86_MCE_AMD
 extern bool amd_filter_mce(struct mce *m);
+void mce_amd_handle_storm(int bank, bool on);
 
 /*
  * If MCA_CONFIG[McaLsbInStatusSupported] is set, extract ErrAddr in bits
@@ -259,6 +260,7 @@ static __always_inline void smca_extract_err_addr(struct mce *m)
 
 #else
 static inline bool amd_filter_mce(struct mce *m) { return false; }
+static inline void mce_amd_handle_storm(int bank, bool on) {}
 static inline void smca_extract_err_addr(struct mce *m) { }
 #endif
 
diff --git a/arch/x86/kernel/cpu/mce/amd.c b/arch/x86/kernel/cpu/mce/amd.c
index 0b971f974096..b19f3eb70187 100644
--- a/arch/x86/kernel/cpu/mce/amd.c
+++ b/arch/x86/kernel/cpu/mce/amd.c
@@ -468,6 +468,47 @@ static void threshold_restart_bank(void *_tr)
 	wrmsr(tr->b->address, lo, hi);
 }
 
+static void _reset_block(struct threshold_block *block)
+{
+	struct thresh_restart tr;
+
+	memset(&tr, 0, sizeof(tr));
+	tr.b = block;
+	threshold_restart_bank(&tr);
+}
+
+static void toggle_interrupt_reset_block(struct threshold_block *block, bool on)
+{
+	if (!block)
+		return;
+
+	block->interrupt_enable = !!on;
+	_reset_block(block);
+}
+
+void mce_amd_handle_storm(int bank, bool on)
+{
+	struct threshold_block *first_block = NULL, *block = NULL, *tmp = NULL;
+	struct threshold_bank **bp = this_cpu_read(threshold_banks);
+	unsigned long flags;
+
+	if (!bp)
+		return;
+
+	local_irq_save(flags);
+
+	first_block = bp[bank]->blocks;
+	if (!first_block)
+		goto end;
+
+	toggle_interrupt_reset_block(first_block, on);
+
+	list_for_each_entry_safe(block, tmp, &first_block->miscj, miscj)
+		toggle_interrupt_reset_block(block, on);
+end:
+	local_irq_restore(flags);
+}
+
 static void mce_threshold_block_init(struct threshold_block *b, int offset)
 {
 	struct thresh_restart tr = {
@@ -868,6 +909,7 @@ static void amd_threshold_interrupt(void)
 	struct threshold_block *first_block = NULL, *block = NULL, *tmp = NULL;
 	struct threshold_bank **bp = this_cpu_read(threshold_banks);
 	unsigned int bank, cpu = smp_processor_id();
+	u64 status;
 
 	/*
 	 * Validate that the threshold bank has been initialized already. The
@@ -881,6 +923,13 @@ static void amd_threshold_interrupt(void)
 		if (!(per_cpu(bank_map, cpu) & BIT_ULL(bank)))
 			continue;
 
+		rdmsrl(mca_msr_reg(bank, MCA_STATUS), status);
+		track_cmci_storm(bank, status);
+
+		/* Return early on an interrupt storm */
+		if (this_cpu_read(storm_desc.bank_storm[bank]))
+			return;
+
 		first_block = bp[bank]->blocks;
 		if (!first_block)
 			continue;
diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index cd9d9ea5bb0a..d4c9dc194d56 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -2055,6 +2055,9 @@ static void mce_zhaoxin_feature_clear(struct cpuinfo_x86 *c)
 void mce_handle_storm(int bank, bool on)
 {
 	switch (boot_cpu_data.x86_vendor) {
+	case X86_VENDOR_AMD:
+		mce_amd_handle_storm(bank, on);
+		break;
 	}
 }
 
-- 
2.40.1

