Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB5BD8F70
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 19:58:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DED5C433C7;
	Sun, 16 Jul 2023 19:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537493;
	bh=MQjsSB9d0Nc9kS592EzeiNVi3lEZFta7mtenDX4Nttk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YBGZNKOEKKRh1jPi9BPNZVMXWiFwD+DL4oqKvxjS+GP++8N+22lM8mRTf65hwqvIW
	 ElVvI75owFsWzrGCqKnB0u46E8vMHuF2NB9wmsv46S4iZ4pCbc6e8pmy67M+Jaec3I
	 GiGwaRH86idDixJNDlSjV/JNdVC/aT0/PANddIz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Gross <jgross@suse.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Michael Kelley <mikelley@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 088/800] x86/mtrr: Support setting MTRR state for software defined MTRRs
Date: Sun, 16 Jul 2023 21:39:01 +0200
Message-ID: <20230716194951.153399306@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Juergen Gross <jgross@suse.com>

[ Upstream commit 29055dc74287467bd7a053d60b4afe753832960d ]

When running virtualized, MTRR access can be reduced (e.g. in Xen PV
guests or when running as a SEV-SNP guest under Hyper-V). Typically, the
hypervisor will not advertize the MTRR feature in CPUID data, resulting
in no MTRR memory type information being available for the kernel.

This has turned out to result in problems (Link tags below):

- Hyper-V SEV-SNP guests using uncached mappings where they shouldn't
- Xen PV dom0 mapping memory as WB which should be UC- instead

Solve those problems by allowing an MTRR static state override,
overwriting the empty state used today. In case such a state has been
set, don't call get_mtrr_state() in mtrr_bp_init().

The set state will only be used by mtrr_type_lookup(), as in all other
cases mtrr_enabled() is being checked, which will return false. Accept
the overwrite call only for selected cases when running as a guest.
Disable X86_FEATURE_MTRR in order to avoid any MTRR modifications by
just refusing them.

  [ bp: Massage. ]

Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Tested-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/all/4fe9541e-4d4c-2b2a-f8c8-2d34a7284930@nerdbynature.de/
Link: https://lore.kernel.org/lkml/BYAPR21MB16883ABC186566BD4D2A1451D7FE9@BYAPR21MB1688.namprd21.prod.outlook.com
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Stable-dep-of: c957f1f3c498 ("x86/hyperv: Set MTRR state when running as SEV-SNP Hyper-V guest")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/mtrr.h        |  8 ++++
 arch/x86/kernel/cpu/mtrr/generic.c | 60 +++++++++++++++++++++++++++++-
 arch/x86/kernel/cpu/mtrr/mtrr.c    | 14 ++++++-
 arch/x86/kernel/setup.c            |  2 +
 4 files changed, 82 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/mtrr.h b/arch/x86/include/asm/mtrr.h
index f0eeaf6e5f5f7..f1cb81330a645 100644
--- a/arch/x86/include/asm/mtrr.h
+++ b/arch/x86/include/asm/mtrr.h
@@ -31,6 +31,8 @@
  */
 # ifdef CONFIG_MTRR
 void mtrr_bp_init(void);
+void mtrr_overwrite_state(struct mtrr_var_range *var, unsigned int num_var,
+			  mtrr_type def_type);
 extern u8 mtrr_type_lookup(u64 addr, u64 end, u8 *uniform);
 extern void mtrr_save_fixed_ranges(void *);
 extern void mtrr_save_state(void);
@@ -48,6 +50,12 @@ void mtrr_disable(void);
 void mtrr_enable(void);
 void mtrr_generic_set_state(void);
 #  else
+static inline void mtrr_overwrite_state(struct mtrr_var_range *var,
+					unsigned int num_var,
+					mtrr_type def_type)
+{
+}
+
 static inline u8 mtrr_type_lookup(u64 addr, u64 end, u8 *uniform)
 {
 	/*
diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index 3922552340b13..fd77c5da4a7a6 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -8,10 +8,12 @@
 #include <linux/init.h>
 #include <linux/io.h>
 #include <linux/mm.h>
-
+#include <linux/cc_platform.h>
 #include <asm/processor-flags.h>
 #include <asm/cacheinfo.h>
 #include <asm/cpufeature.h>
+#include <asm/hypervisor.h>
+#include <asm/mshyperv.h>
 #include <asm/tlbflush.h>
 #include <asm/mtrr.h>
 #include <asm/msr.h>
@@ -250,6 +252,62 @@ static u8 mtrr_type_lookup_variable(u64 start, u64 end, u64 *partial_end,
 	return mtrr_state.def_type;
 }
 
+/**
+ * mtrr_overwrite_state - set static MTRR state
+ *
+ * Used to set MTRR state via different means (e.g. with data obtained from
+ * a hypervisor).
+ * Is allowed only for special cases when running virtualized. Must be called
+ * from the x86_init.hyper.init_platform() hook.  It can be called only once.
+ * The MTRR state can't be changed afterwards.  To ensure that, X86_FEATURE_MTRR
+ * is cleared.
+ */
+void mtrr_overwrite_state(struct mtrr_var_range *var, unsigned int num_var,
+			  mtrr_type def_type)
+{
+	unsigned int i;
+
+	/* Only allowed to be called once before mtrr_bp_init(). */
+	if (WARN_ON_ONCE(mtrr_state_set))
+		return;
+
+	/* Only allowed when running virtualized. */
+	if (!cpu_feature_enabled(X86_FEATURE_HYPERVISOR))
+		return;
+
+	/*
+	 * Only allowed for special virtualization cases:
+	 * - when running as Hyper-V, SEV-SNP guest using vTOM
+	 * - when running as Xen PV guest
+	 * - when running as SEV-SNP or TDX guest to avoid unnecessary
+	 *   VMM communication/Virtualization exceptions (#VC, #VE)
+	 */
+	if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP) &&
+	    !hv_is_isolation_supported() &&
+	    !cpu_feature_enabled(X86_FEATURE_XENPV) &&
+	    !cpu_feature_enabled(X86_FEATURE_TDX_GUEST))
+		return;
+
+	/* Disable MTRR in order to disable MTRR modifications. */
+	setup_clear_cpu_cap(X86_FEATURE_MTRR);
+
+	if (var) {
+		if (num_var > MTRR_MAX_VAR_RANGES) {
+			pr_warn("Trying to overwrite MTRR state with %u variable entries\n",
+				num_var);
+			num_var = MTRR_MAX_VAR_RANGES;
+		}
+		for (i = 0; i < num_var; i++)
+			mtrr_state.var_ranges[i] = var[i];
+		num_var_ranges = num_var;
+	}
+
+	mtrr_state.def_type = def_type;
+	mtrr_state.enabled |= MTRR_STATE_MTRR_ENABLED;
+
+	mtrr_state_set = 1;
+}
+
 /**
  * mtrr_type_lookup - look up memory type in MTRR
  *
diff --git a/arch/x86/kernel/cpu/mtrr/mtrr.c b/arch/x86/kernel/cpu/mtrr/mtrr.c
index 1bdab16f16bdc..8638019f80680 100644
--- a/arch/x86/kernel/cpu/mtrr/mtrr.c
+++ b/arch/x86/kernel/cpu/mtrr/mtrr.c
@@ -625,11 +625,23 @@ int __initdata changed_by_mtrr_cleanup;
  */
 void __init mtrr_bp_init(void)
 {
+	bool generic_mtrrs = cpu_feature_enabled(X86_FEATURE_MTRR);
 	const char *why = "(not available)";
 
 	mtrr_set_mask();
 
-	if (cpu_feature_enabled(X86_FEATURE_MTRR)) {
+	if (!generic_mtrrs && mtrr_state.enabled) {
+		/*
+		 * Software overwrite of MTRR state, only for generic case.
+		 * Note that X86_FEATURE_MTRR has been reset in this case.
+		 */
+		init_table();
+		pr_info("MTRRs set to read-only\n");
+
+		return;
+	}
+
+	if (generic_mtrrs) {
 		mtrr_if = &generic_mtrr_ops;
 	} else {
 		switch (boot_cpu_data.x86_vendor) {
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 16babff771bdf..0cccfeb67c3ad 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1037,6 +1037,8 @@ void __init setup_arch(char **cmdline_p)
 	/*
 	 * VMware detection requires dmi to be available, so this
 	 * needs to be done after dmi_setup(), for the boot CPU.
+	 * For some guest types (Xen PV, SEV-SNP, TDX) it is required to be
+	 * called before cache_bp_init() for setting up MTRR state.
 	 */
 	init_hypervisor_platform();
 
-- 
2.39.2



