Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB7B248F71;
	Mon, 12 May 2025 18:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073540; cv=none; b=Bm+WYKjaTKWHKvbPZB2Fwi8CxJiY0s8dM/69cLymXCoWCB+7wXR/sYXE2VsEhTVJtW/u/zBMHWFBwYg2y5rAgyn+4rllDLL6PJPBp1R7nJct2wlYsiO4MNrX5oe6OGRShTHCdd8Cs0AgPfWQywmq0f+JmojM+fytT6WMGPf7otE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073540; c=relaxed/simple;
	bh=Xcu/HnCZjOOLERCqV9ktC8/Sblzz0nlt8iSgX3hBJ1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NbSHugbE/j8C1g0BSMwkF86qKkHPQQOluXH8ddw54B272HGYidGO0WbWVZTeTvyicjd30e+r0rwBXO+iLCXG4eFDsQk+3Kte5cZnMnw4o9Ioyg9j+sdd6epUn/6Pj+26GI1iX/Rgak2gyPMox+aa8p63x2N4YUkgQ8tH76UD44k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BlSExPwJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BlSExPwJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B3D9C4CEE7;
	Mon, 12 May 2025 18:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073540;
	bh=Xcu/HnCZjOOLERCqV9ktC8/Sblzz0nlt8iSgX3hBJ1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BlSExPwJKQnp0Ch10UWPMmRxtUhzJ7FdXcWArJT3mK8u0RWM+FMOSOtG6HOX7+KvD
	 roRrrvDEYX5CfdAObU5A8B4hsImB1I6o0jZHzi5tcNuti8vHXMECcZ8lwa/QjIY5UU
	 NkJ17t5mCKqwKBAzwHwrHzGTZsNnVomerY/DXiVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Alexandre Chartre <alexandre.chartre@oracle.com>
Subject: [PATCH 6.6 108/113] x86/its: Enable Indirect Target Selection mitigation
Date: Mon, 12 May 2025 19:46:37 +0200
Message-ID: <20250512172032.072803117@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
References: <20250512172027.691520737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit f4818881c47fd91fcb6d62373c57c7844e3de1c0 upstream.

Indirect Target Selection (ITS) is a bug in some pre-ADL Intel CPUs with
eIBRS. It affects prediction of indirect branch and RETs in the
lower half of cacheline. Due to ITS such branches may get wrongly predicted
to a target of (direct or indirect) branch that is located in the upper
half of the cacheline.

Scope of impact
===============

Guest/host isolation
--------------------
When eIBRS is used for guest/host isolation, the indirect branches in the
VMM may still be predicted with targets corresponding to branches in the
guest.

Intra-mode
----------
cBPF or other native gadgets can be used for intra-mode training and
disclosure using ITS.

User/kernel isolation
---------------------
When eIBRS is enabled user/kernel isolation is not impacted.

Indirect Branch Prediction Barrier (IBPB)
-----------------------------------------
After an IBPB, indirect branches may be predicted with targets
corresponding to direct branches which were executed prior to IBPB. This is
mitigated by a microcode update.

Add cmdline parameter indirect_target_selection=off|on|force to control the
mitigation to relocate the affected branches to an ITS-safe thunk i.e.
located in the upper half of cacheline. Also add the sysfs reporting.

When retpoline mitigation is deployed, ITS safe-thunks are not needed,
because retpoline sequence is already ITS-safe. Similarly, when call depth
tracking (CDT) mitigation is deployed (retbleed=stuff), ITS safe return
thunk is not used, as CDT prevents RSB-underflow.

To not overcomplicate things, ITS mitigation is not supported with
spectre-v2 lfence;jmp mitigation. Moreover, it is less practical to deploy
lfence;jmp mitigation on ITS affected parts anyways.

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Reviewed-by: Alexandre Chartre <alexandre.chartre@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/ABI/testing/sysfs-devices-system-cpu |    1 
 Documentation/admin-guide/kernel-parameters.txt    |   13 +
 arch/x86/include/asm/nospec-branch.h               |    6 
 arch/x86/kernel/cpu/bugs.c                         |  141 ++++++++++++++++++++-
 drivers/base/cpu.c                                 |    3 
 include/linux/cpu.h                                |    2 
 6 files changed, 156 insertions(+), 10 deletions(-)

--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -514,6 +514,7 @@ Description:	information about CPUs hete
 
 What:		/sys/devices/system/cpu/vulnerabilities
 		/sys/devices/system/cpu/vulnerabilities/gather_data_sampling
+		/sys/devices/system/cpu/vulnerabilities/indirect_target_selection
 		/sys/devices/system/cpu/vulnerabilities/itlb_multihit
 		/sys/devices/system/cpu/vulnerabilities/l1tf
 		/sys/devices/system/cpu/vulnerabilities/mds
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2060,6 +2060,18 @@
 			different crypto accelerators. This option can be used
 			to achieve best performance for particular HW.
 
+	indirect_target_selection= [X86,Intel] Mitigation control for Indirect
+			Target Selection(ITS) bug in Intel CPUs. Updated
+			microcode is also required for a fix in IBPB.
+
+			on:     Enable mitigation (default).
+			off:    Disable mitigation.
+			force:	Force the ITS bug and deploy default
+				mitigation.
+
+			For details see:
+			Documentation/admin-guide/hw-vuln/indirect-target-selection.rst
+
 	init=		[KNL]
 			Format: <full_path>
 			Run specified binary instead of /sbin/init as init
@@ -3331,6 +3343,7 @@
 				expose users to several CPU vulnerabilities.
 				Equivalent to: if nokaslr then kpti=0 [ARM64]
 					       gather_data_sampling=off [X86]
+					       indirect_target_selection=off [X86]
 					       kvm.nx_huge_pages=off [X86]
 					       l1tf=off [X86]
 					       mds=off [X86]
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -421,11 +421,6 @@ extern void (*x86_return_thunk)(void);
 #ifdef CONFIG_CALL_DEPTH_TRACKING
 extern void __x86_return_skl(void);
 
-static inline void x86_set_skl_return_thunk(void)
-{
-	x86_return_thunk = &__x86_return_skl;
-}
-
 #define CALL_DEPTH_ACCOUNT					\
 	ALTERNATIVE("",						\
 		    __stringify(INCREMENT_CALL_DEPTH),		\
@@ -438,7 +433,6 @@ DECLARE_PER_CPU(u64, __x86_stuffs_count)
 DECLARE_PER_CPU(u64, __x86_ctxsw_count);
 #endif
 #else
-static inline void x86_set_skl_return_thunk(void) {}
 
 #define CALL_DEPTH_ACCOUNT ""
 
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -49,6 +49,7 @@ static void __init srbds_select_mitigati
 static void __init l1d_flush_select_mitigation(void);
 static void __init srso_select_mitigation(void);
 static void __init gds_select_mitigation(void);
+static void __init its_select_mitigation(void);
 
 /* The base value of the SPEC_CTRL MSR without task-specific bits set */
 u64 x86_spec_ctrl_base;
@@ -67,6 +68,14 @@ static DEFINE_MUTEX(spec_ctrl_mutex);
 
 void (*x86_return_thunk)(void) __ro_after_init = __x86_return_thunk;
 
+static void __init set_return_thunk(void *thunk)
+{
+	if (x86_return_thunk != __x86_return_thunk)
+		pr_warn("x86/bugs: return thunk changed\n");
+
+	x86_return_thunk = thunk;
+}
+
 /* Update SPEC_CTRL MSR and its cached copy unconditionally */
 static void update_spec_ctrl(u64 val)
 {
@@ -175,6 +184,7 @@ void __init cpu_select_mitigations(void)
 	 */
 	srso_select_mitigation();
 	gds_select_mitigation();
+	its_select_mitigation();
 }
 
 /*
@@ -1102,7 +1112,7 @@ do_cmd_auto:
 		setup_force_cpu_cap(X86_FEATURE_RETHUNK);
 		setup_force_cpu_cap(X86_FEATURE_UNRET);
 
-		x86_return_thunk = retbleed_return_thunk;
+		set_return_thunk(retbleed_return_thunk);
 
 		if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD &&
 		    boot_cpu_data.x86_vendor != X86_VENDOR_HYGON)
@@ -1136,7 +1146,9 @@ do_cmd_auto:
 	case RETBLEED_MITIGATION_STUFF:
 		setup_force_cpu_cap(X86_FEATURE_RETHUNK);
 		setup_force_cpu_cap(X86_FEATURE_CALL_DEPTH);
-		x86_set_skl_return_thunk();
+#ifdef CONFIG_CALL_DEPTH_TRACKING
+		set_return_thunk(&__x86_return_skl);
+#endif
 		break;
 
 	default:
@@ -1171,6 +1183,114 @@ do_cmd_auto:
 }
 
 #undef pr_fmt
+#define pr_fmt(fmt)     "ITS: " fmt
+
+enum its_mitigation_cmd {
+	ITS_CMD_OFF,
+	ITS_CMD_ON,
+};
+
+enum its_mitigation {
+	ITS_MITIGATION_OFF,
+	ITS_MITIGATION_ALIGNED_THUNKS,
+	ITS_MITIGATION_RETPOLINE_STUFF,
+};
+
+static const char * const its_strings[] = {
+	[ITS_MITIGATION_OFF]			= "Vulnerable",
+	[ITS_MITIGATION_ALIGNED_THUNKS]		= "Mitigation: Aligned branch/return thunks",
+	[ITS_MITIGATION_RETPOLINE_STUFF]	= "Mitigation: Retpolines, Stuffing RSB",
+};
+
+static enum its_mitigation its_mitigation __ro_after_init = ITS_MITIGATION_ALIGNED_THUNKS;
+
+static enum its_mitigation_cmd its_cmd __ro_after_init =
+	IS_ENABLED(CONFIG_MITIGATION_ITS) ? ITS_CMD_ON : ITS_CMD_OFF;
+
+static int __init its_parse_cmdline(char *str)
+{
+	if (!str)
+		return -EINVAL;
+
+	if (!IS_ENABLED(CONFIG_MITIGATION_ITS)) {
+		pr_err("Mitigation disabled at compile time, ignoring option (%s)", str);
+		return 0;
+	}
+
+	if (!strcmp(str, "off")) {
+		its_cmd = ITS_CMD_OFF;
+	} else if (!strcmp(str, "on")) {
+		its_cmd = ITS_CMD_ON;
+	} else if (!strcmp(str, "force")) {
+		its_cmd = ITS_CMD_ON;
+		setup_force_cpu_bug(X86_BUG_ITS);
+	} else {
+		pr_err("Ignoring unknown indirect_target_selection option (%s).", str);
+	}
+
+	return 0;
+}
+early_param("indirect_target_selection", its_parse_cmdline);
+
+static void __init its_select_mitigation(void)
+{
+	enum its_mitigation_cmd cmd = its_cmd;
+
+	if (!boot_cpu_has_bug(X86_BUG_ITS) || cpu_mitigations_off()) {
+		its_mitigation = ITS_MITIGATION_OFF;
+		return;
+	}
+
+	/* Retpoline+CDT mitigates ITS, bail out */
+	if (boot_cpu_has(X86_FEATURE_RETPOLINE) &&
+	    boot_cpu_has(X86_FEATURE_CALL_DEPTH)) {
+		its_mitigation = ITS_MITIGATION_RETPOLINE_STUFF;
+		goto out;
+	}
+
+	/* Exit early to avoid irrelevant warnings */
+	if (cmd == ITS_CMD_OFF) {
+		its_mitigation = ITS_MITIGATION_OFF;
+		goto out;
+	}
+	if (spectre_v2_enabled == SPECTRE_V2_NONE) {
+		pr_err("WARNING: Spectre-v2 mitigation is off, disabling ITS\n");
+		its_mitigation = ITS_MITIGATION_OFF;
+		goto out;
+	}
+	if (!IS_ENABLED(CONFIG_RETPOLINE) || !IS_ENABLED(CONFIG_RETHUNK)) {
+		pr_err("WARNING: ITS mitigation depends on retpoline and rethunk support\n");
+		its_mitigation = ITS_MITIGATION_OFF;
+		goto out;
+	}
+	if (IS_ENABLED(CONFIG_DEBUG_FORCE_FUNCTION_ALIGN_64B)) {
+		pr_err("WARNING: ITS mitigation is not compatible with CONFIG_DEBUG_FORCE_FUNCTION_ALIGN_64B\n");
+		its_mitigation = ITS_MITIGATION_OFF;
+		goto out;
+	}
+	if (boot_cpu_has(X86_FEATURE_RETPOLINE_LFENCE)) {
+		pr_err("WARNING: ITS mitigation is not compatible with lfence mitigation\n");
+		its_mitigation = ITS_MITIGATION_OFF;
+		goto out;
+	}
+
+	switch (cmd) {
+	case ITS_CMD_OFF:
+		its_mitigation = ITS_MITIGATION_OFF;
+		break;
+	case ITS_CMD_ON:
+		its_mitigation = ITS_MITIGATION_ALIGNED_THUNKS;
+		if (!boot_cpu_has(X86_FEATURE_RETPOLINE))
+			setup_force_cpu_cap(X86_FEATURE_INDIRECT_THUNK_ITS);
+		setup_force_cpu_cap(X86_FEATURE_RETHUNK);
+		set_return_thunk(its_return_thunk);
+		break;
+	}
+out:
+	pr_info("%s\n", its_strings[its_mitigation]);
+}
+
+#undef pr_fmt
 #define pr_fmt(fmt)     "Spectre V2 : " fmt
 
 static enum spectre_v2_user_mitigation spectre_v2_user_stibp __ro_after_init =
@@ -2607,10 +2727,10 @@ static void __init srso_select_mitigatio
 
 			if (boot_cpu_data.x86 == 0x19) {
 				setup_force_cpu_cap(X86_FEATURE_SRSO_ALIAS);
-				x86_return_thunk = srso_alias_return_thunk;
+				set_return_thunk(srso_alias_return_thunk);
 			} else {
 				setup_force_cpu_cap(X86_FEATURE_SRSO);
-				x86_return_thunk = srso_return_thunk;
+				set_return_thunk(srso_return_thunk);
 			}
 			if (has_microcode)
 				srso_mitigation = SRSO_MITIGATION_SAFE_RET;
@@ -2794,6 +2914,11 @@ static ssize_t rfds_show_state(char *buf
 	return sysfs_emit(buf, "%s\n", rfds_strings[rfds_mitigation]);
 }
 
+static ssize_t its_show_state(char *buf)
+{
+	return sysfs_emit(buf, "%s\n", its_strings[its_mitigation]);
+}
+
 static char *stibp_state(void)
 {
 	if (spectre_v2_in_eibrs_mode(spectre_v2_enabled) &&
@@ -2976,6 +3101,9 @@ static ssize_t cpu_show_common(struct de
 	case X86_BUG_RFDS:
 		return rfds_show_state(buf);
 
+	case X86_BUG_ITS:
+		return its_show_state(buf);
+
 	default:
 		break;
 	}
@@ -3055,4 +3183,9 @@ ssize_t cpu_show_reg_file_data_sampling(
 {
 	return cpu_show_common(dev, attr, buf, X86_BUG_RFDS);
 }
+
+ssize_t cpu_show_indirect_target_selection(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	return cpu_show_common(dev, attr, buf, X86_BUG_ITS);
+}
 #endif
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -566,6 +566,7 @@ CPU_SHOW_VULN_FALLBACK(retbleed);
 CPU_SHOW_VULN_FALLBACK(spec_rstack_overflow);
 CPU_SHOW_VULN_FALLBACK(gds);
 CPU_SHOW_VULN_FALLBACK(reg_file_data_sampling);
+CPU_SHOW_VULN_FALLBACK(indirect_target_selection);
 
 static DEVICE_ATTR(meltdown, 0444, cpu_show_meltdown, NULL);
 static DEVICE_ATTR(spectre_v1, 0444, cpu_show_spectre_v1, NULL);
@@ -581,6 +582,7 @@ static DEVICE_ATTR(retbleed, 0444, cpu_s
 static DEVICE_ATTR(spec_rstack_overflow, 0444, cpu_show_spec_rstack_overflow, NULL);
 static DEVICE_ATTR(gather_data_sampling, 0444, cpu_show_gds, NULL);
 static DEVICE_ATTR(reg_file_data_sampling, 0444, cpu_show_reg_file_data_sampling, NULL);
+static DEVICE_ATTR(indirect_target_selection, 0444, cpu_show_indirect_target_selection, NULL);
 
 static struct attribute *cpu_root_vulnerabilities_attrs[] = {
 	&dev_attr_meltdown.attr,
@@ -597,6 +599,7 @@ static struct attribute *cpu_root_vulner
 	&dev_attr_spec_rstack_overflow.attr,
 	&dev_attr_gather_data_sampling.attr,
 	&dev_attr_reg_file_data_sampling.attr,
+	&dev_attr_indirect_target_selection.attr,
 	NULL
 };
 
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -77,6 +77,8 @@ extern ssize_t cpu_show_gds(struct devic
 			    struct device_attribute *attr, char *buf);
 extern ssize_t cpu_show_reg_file_data_sampling(struct device *dev,
 					       struct device_attribute *attr, char *buf);
+extern ssize_t cpu_show_indirect_target_selection(struct device *dev,
+						  struct device_attribute *attr, char *buf);
 
 extern __printf(4, 5)
 struct device *cpu_device_create(struct device *parent, void *drvdata,


