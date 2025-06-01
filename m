Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE25298256;
	Sun,  1 Jun 2025 23:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748820804; cv=none; b=ld3V/w4S4hn4AjkelI+3503hauETx3IrYsTfjO5S8gkafWQZfL/Ql0cMY5p9wVQSO4/hHTQZzgplpSLfun2SdXGH8qyqEkPfq8losbuMSQZvI5RTDw3i73wWRtPCzGImK86Su3n1gFJ7TW1KcGci5NNuAf2+HDdvu101QsLsmTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748820804; c=relaxed/simple;
	bh=1ROuwQC2Hyt7v3h4anzkD3O+wnXBM6CNhQofGqEExqg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Nyh9IwkzNFhdV/wZzDZEElM5jLEIcgaC8i1Kxj0XrOwbAHLnJrzTCYMfXHF2dPZsIeBptIxtwqcPXLugf99fxJKBmTHkjll2YniBgq4tE3TcLe0zomeFBd6PyyqnihffRx9qulAZa25qyzZBtL6sxzXSpoJtCKbKcbiCgN1LFPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b+ozN/GL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b+ozN/GL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D818AC4CEE7;
	Sun,  1 Jun 2025 23:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748820804;
	bh=1ROuwQC2Hyt7v3h4anzkD3O+wnXBM6CNhQofGqEExqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b+ozN/GLUdGPcqvlIhaTgWZZKqhdV4jcimlwBNGgoAM+ECLeOXxLAdmZTRKVu7tIa
	 URvPllshjj5FrZUasRDCS9Z1rR41V8sJBx6SWxZWtH6NlrMoCaOQAxh6C+f1WAnngU
	 6MuxSm6q6N5XPeXKc8UaEc9hKvV5SDQBW0YhW8y8lqJivWaFWLQh1YMOe++vOMqzgy
	 vVnrXVjzvQdT6UAeBZsnCXix6+xo+ER41Akp1dJkbxUMwF6UDS98O4lGydQ7saR4ew
	 t2sILlN0P5Bucmu1mVsnxGpg6ajzbS5G7nPpdqeMavWLvmvimlDTJRli62BeEtC0Oo
	 y6ywixRN2OWIw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Brian Norris <briannorris@chromium.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 6.14 085/102] genirq: Retain disable depth for managed interrupts across CPU hotplug
Date: Sun,  1 Jun 2025 19:29:17 -0400
Message-Id: <20250601232937.3510379-85-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250601232937.3510379-1-sashal@kernel.org>
References: <20250601232937.3510379-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Brian Norris <briannorris@chromium.org>

[ Upstream commit 788019eb559fd0b365f501467ceafce540e377cc ]

Affinity-managed interrupts can be shut down and restarted during CPU
hotunplug/plug. Thereby the interrupt may be left in an unexpected state.
Specifically:

 1. Interrupt is affine to CPU N
 2. disable_irq() -> depth is 1
 3. CPU N goes offline
 4. irq_shutdown() -> depth is set to 1 (again)
 5. CPU N goes online
 6. irq_startup() -> depth is set to 0 (BUG! driver expects that the interrupt
    		     	      	        still disabled)
 7. enable_irq() -> depth underflow / unbalanced enable_irq() warning

This is only a problem for managed interrupts and CPU hotplug, all other
cases like request()/free()/request() truly needs to reset a possibly stale
disable depth value.

Provide a startup function, which takes the disable depth into account, and
invoked it for the managed interrupts in the CPU hotplug path.

This requires to change irq_shutdown() to do a depth increment instead of
setting it to 1, which allows to retain the disable depth, but is harmless
for the other code paths using irq_startup(), which will still reset the
disable depth unconditionally to keep the original correct behaviour.

A kunit tests will be added separately to cover some of these aspects.

[ tglx: Massaged changelog ]

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/all/20250514201353.3481400-2-briannorris@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

Based on my analysis of the commit and the current kernel code, here is
my assessment: **YES** This commit should be backported to stable kernel
trees. Here's my extensive analysis: ## Bug Analysis The commit fixes a
critical bug in the interrupt subsystem's CPU hotplug handling that
affects affinity-managed interrupts. The bug manifests as follows: 1.
**Problem Scenario**: When a managed interrupt is disabled (depth=1),
then its CPU goes offline causing `irq_shutdown()`, and later the CPU
comes back online triggering `irq_startup()`, the disable depth
accounting becomes corrupted. 2. **Current Broken Behavior** (from
existing kernel code): - `irq_shutdown()` sets `desc->depth = 1`
unconditionally (line seen in grep output) - `irq_startup()` sets
`desc->depth = 0` unconditionally - This overwrites any previous disable
state, violating the disable/enable balance 3. **User-Visible Impact**:
The bug causes: - Unbalanced `enable_irq()` warnings - Interrupts being
unexpectedly enabled during CPU hotplug - Potential system instability
or incorrect device behavior ## Code Changes Analysis The fix makes
surgical changes to preserve disable depth: ### 1. **irq_shutdown()
Change** (kernel/irq/chip.c): ```c - desc->depth = 1; + /bin /bin.usr-
is-merged /boot /dev /etc /home /init /lib /lib.usr-is-merged /lib64
/lost+found /media /mnt /opt /proc /root /run /sbin /sbin.usr-is-merged
/snap /srv /sys /tmp /usr /var +
amd_display_timing_generator_analysis.md
amd_doorbell_analysis_framework.md
amd_gpu_documentation_backport_analysis.md amd_si_chip_analysis.md
amdgpu_csb_analysis.md amdgpu_mqd_prop_backport_analysis.md
analogix_dp_backport_analysis.md cgroup_rstat_analysis.sh
cgroup_rstat_analysis_guide.md cpuset_comment_fix_backport_analysis.md
csiphy_x1e80100_backport_analysis.md
dcn315_smu_indirect_register_access_analysis.md
drm_dp_helper_dpcd_refactoring_backport_analysis.md
drm_format_helper_generic_8bit_conversion_backport_analysis.md
es8375_codec_driver_backport_analysis.md expected_findings_summary.md
hdmi_read_request_analysis.md kernel_analysis_commands.sh
kselftest_harness_teardown_metadata_backport_analysis.md linux-kernel
mediatek_vcodec_h264_backport_analysis.md
pidfd_open_kselftest_harness_compatibility_analysis.md
qualcomm_camss_bus_type_backport_analysis.md
selftests_harness_libatomic_backport_analysis.md
sphinx_version_compatibility_backport_analysis.md
spi_sh_msiof_grpmask_backport_analysis.md
spi_sh_msiof_sitmdr2_sirmdr2_bitfield_conversion_backport_analysis.md
sta2x11_removal_analysis.md test_unused_param.c test_unused_param.o
ti_bridge_encoder_crtc_refactoring_backport_analysis.md
xe_driver_flr_vf_restriction_analysis.md
xe_firmware_per_gt_backport_analysis.md
xe_sriov_logging_backport_analysis.md Increment disable depth, so that a
managed shutdown on + amd_display_timing_generator_analysis.md
amd_doorbell_analysis_framework.md
amd_gpu_documentation_backport_analysis.md amd_si_chip_analysis.md
amdgpu_csb_analysis.md amdgpu_mqd_prop_backport_analysis.md
analogix_dp_backport_analysis.md cgroup_rstat_analysis.sh
cgroup_rstat_analysis_guide.md cpuset_comment_fix_backport_analysis.md
csiphy_x1e80100_backport_analysis.md
dcn315_smu_indirect_register_access_analysis.md
drm_dp_helper_dpcd_refactoring_backport_analysis.md
drm_format_helper_generic_8bit_conversion_backport_analysis.md
es8375_codec_driver_backport_analysis.md expected_findings_summary.md
hdmi_read_request_analysis.md kernel_analysis_commands.sh
kselftest_harness_teardown_metadata_backport_analysis.md linux-kernel
mediatek_vcodec_h264_backport_analysis.md
pidfd_open_kselftest_harness_compatibility_analysis.md
qualcomm_camss_bus_type_backport_analysis.md
selftests_harness_libatomic_backport_analysis.md
sphinx_version_compatibility_backport_analysis.md
spi_sh_msiof_grpmask_backport_analysis.md
spi_sh_msiof_sitmdr2_sirmdr2_bitfield_conversion_backport_analysis.md
sta2x11_removal_analysis.md test_unused_param.c test_unused_param.o
ti_bridge_encoder_crtc_refactoring_backport_analysis.md
xe_driver_flr_vf_restriction_analysis.md
xe_firmware_per_gt_backport_analysis.md
xe_sriov_logging_backport_analysis.md CPU hotunplug preserves the actual
disabled state when the + amd_display_timing_generator_analysis.md
amd_doorbell_analysis_framework.md
amd_gpu_documentation_backport_analysis.md amd_si_chip_analysis.md
amdgpu_csb_analysis.md amdgpu_mqd_prop_backport_analysis.md
analogix_dp_backport_analysis.md cgroup_rstat_analysis.sh
cgroup_rstat_analysis_guide.md cpuset_comment_fix_backport_analysis.md
csiphy_x1e80100_backport_analysis.md
dcn315_smu_indirect_register_access_analysis.md
drm_dp_helper_dpcd_refactoring_backport_analysis.md
drm_format_helper_generic_8bit_conversion_backport_analysis.md
es8375_codec_driver_backport_analysis.md expected_findings_summary.md
hdmi_read_request_analysis.md kernel_analysis_commands.sh
kselftest_harness_teardown_metadata_backport_analysis.md linux-kernel
mediatek_vcodec_h264_backport_analysis.md
pidfd_open_kselftest_harness_compatibility_analysis.md
qualcomm_camss_bus_type_backport_analysis.md
selftests_harness_libatomic_backport_analysis.md
sphinx_version_compatibility_backport_analysis.md
spi_sh_msiof_grpmask_backport_analysis.md
spi_sh_msiof_sitmdr2_sirmdr2_bitfield_conversion_backport_analysis.md
sta2x11_removal_analysis.md test_unused_param.c test_unused_param.o
ti_bridge_encoder_crtc_refactoring_backport_analysis.md
xe_driver_flr_vf_restriction_analysis.md
xe_firmware_per_gt_backport_analysis.md
xe_sriov_logging_backport_analysis.md CPU comes back online. See
irq_startup_managed(). + linux-kernel/ + desc->depth++; ``` This
preserves the original disable state instead of overwriting it. ### 2.
**New irq_startup_managed() Function**: ```c +void
irq_startup_managed(struct irq_desc *desc) +{ + /bin /bin.usr-is-merged
/boot /dev /etc /home /init /lib /lib.usr-is-merged /lib64 /lost+found
/media /mnt /opt /proc /root /run /sbin /sbin.usr-is-merged /snap /srv
/sys /tmp /usr /var + amd_display_timing_generator_analysis.md
amd_doorbell_analysis_framework.md
amd_gpu_documentation_backport_analysis.md amd_si_chip_analysis.md
amdgpu_csb_analysis.md amdgpu_mqd_prop_backport_analysis.md
analogix_dp_backport_analysis.md cgroup_rstat_analysis.sh
cgroup_rstat_analysis_guide.md cpuset_comment_fix_backport_analysis.md
csiphy_x1e80100_backport_analysis.md
dcn315_smu_indirect_register_access_analysis.md
drm_dp_helper_dpcd_refactoring_backport_analysis.md
drm_format_helper_generic_8bit_conversion_backport_analysis.md
es8375_codec_driver_backport_analysis.md expected_findings_summary.md
hdmi_read_request_analysis.md kernel_analysis_commands.sh
kselftest_harness_teardown_metadata_backport_analysis.md linux-kernel
mediatek_vcodec_h264_backport_analysis.md
pidfd_open_kselftest_harness_compatibility_analysis.md
qualcomm_camss_bus_type_backport_analysis.md
selftests_harness_libatomic_backport_analysis.md
sphinx_version_compatibility_backport_analysis.md
spi_sh_msiof_grpmask_backport_analysis.md
spi_sh_msiof_sitmdr2_sirmdr2_bitfield_conversion_backport_analysis.md
sta2x11_removal_analysis.md test_unused_param.c test_unused_param.o
ti_bridge_encoder_crtc_refactoring_backport_analysis.md
xe_driver_flr_vf_restriction_analysis.md
xe_firmware_per_gt_backport_analysis.md
xe_sriov_logging_backport_analysis.md Only start it up when the disable
depth is 1, so that a disable, +
amd_display_timing_generator_analysis.md
amd_doorbell_analysis_framework.md
amd_gpu_documentation_backport_analysis.md amd_si_chip_analysis.md
amdgpu_csb_analysis.md amdgpu_mqd_prop_backport_analysis.md
analogix_dp_backport_analysis.md cgroup_rstat_analysis.sh
cgroup_rstat_analysis_guide.md cpuset_comment_fix_backport_analysis.md
csiphy_x1e80100_backport_analysis.md
dcn315_smu_indirect_register_access_analysis.md
drm_dp_helper_dpcd_refactoring_backport_analysis.md
drm_format_helper_generic_8bit_conversion_backport_analysis.md
es8375_codec_driver_backport_analysis.md expected_findings_summary.md
hdmi_read_request_analysis.md kernel_analysis_commands.sh
kselftest_harness_teardown_metadata_backport_analysis.md linux-kernel
mediatek_vcodec_h264_backport_analysis.md
pidfd_open_kselftest_harness_compatibility_analysis.md
qualcomm_camss_bus_type_backport_analysis.md
selftests_harness_libatomic_backport_analysis.md
sphinx_version_compatibility_backport_analysis.md
spi_sh_msiof_grpmask_backport_analysis.md
spi_sh_msiof_sitmdr2_sirmdr2_bitfield_conversion_backport_analysis.md
sta2x11_removal_analysis.md test_unused_param.c test_unused_param.o
ti_bridge_encoder_crtc_refactoring_backport_analysis.md
xe_driver_flr_vf_restriction_analysis.md
xe_firmware_per_gt_backport_analysis.md
xe_sriov_logging_backport_analysis.md hotunplug, hotplug sequence does
not end up enabling it during + amd_display_timing_generator_analysis.md
amd_doorbell_analysis_framework.md
amd_gpu_documentation_backport_analysis.md amd_si_chip_analysis.md
amdgpu_csb_analysis.md amdgpu_mqd_prop_backport_analysis.md
analogix_dp_backport_analysis.md cgroup_rstat_analysis.sh
cgroup_rstat_analysis_guide.md cpuset_comment_fix_backport_analysis.md
csiphy_x1e80100_backport_analysis.md
dcn315_smu_indirect_register_access_analysis.md
drm_dp_helper_dpcd_refactoring_backport_analysis.md
drm_format_helper_generic_8bit_conversion_backport_analysis.md
es8375_codec_driver_backport_analysis.md expected_findings_summary.md
hdmi_read_request_analysis.md kernel_analysis_commands.sh
kselftest_harness_teardown_metadata_backport_analysis.md linux-kernel
mediatek_vcodec_h264_backport_analysis.md
pidfd_open_kselftest_harness_compatibility_analysis.md
qualcomm_camss_bus_type_backport_analysis.md
selftests_harness_libatomic_backport_analysis.md
sphinx_version_compatibility_backport_analysis.md
spi_sh_msiof_grpmask_backport_analysis.md
spi_sh_msiof_sitmdr2_sirmdr2_bitfield_conversion_backport_analysis.md
sta2x11_removal_analysis.md test_unused_param.c test_unused_param.o
ti_bridge_encoder_crtc_refactoring_backport_analysis.md
xe_driver_flr_vf_restriction_analysis.md
xe_firmware_per_gt_backport_analysis.md
xe_sriov_logging_backport_analysis.md hotplug unconditionally. + linux-
kernel/ + desc->depth--; + if (!desc->depth) + irq_startup(desc,
IRQ_RESEND, IRQ_START_COND); +} ``` This provides proper depth-aware
startup specifically for managed interrupts. ### 3. **IRQ_STARTUP_ABORT
Case Update**: ```c case IRQ_STARTUP_ABORT: + desc->depth = 1;
irqd_set_managed_shutdown(d); return 0; ``` Ensures consistent depth
handling in abort cases. ### 4. **CPU Hotplug Integration**
(kernel/irq/cpuhotplug.c): ```c - irq_startup(desc, IRQ_RESEND,
IRQ_START_COND); + irq_startup_managed(desc); ``` Uses the new depth-
aware function for managed interrupt restoration. ## Backport
Suitability Assessment **Meets All Stable Criteria:** 1. **Fixes
Important Bug**: ✅ Corrects interrupt enable/disable balance corruption
2. **Small & Contained**: ✅ Minimal changes confined to IRQ subsystem 3.
**Low Regression Risk**: ✅ Only affects managed interrupts during CPU
hotplug 4. **No New Features**: ✅ Pure bug fix, no architectural changes
5. **Critical Subsystem**: ✅ IRQ handling is fundamental to system
stability **Similar Pattern Match**: This closely resembles Similar
Commit #3 and #5 (both marked YES) which also fix managed interrupt CPU
hotplug issues with surgical changes to preserve state across hotplug
events. **Real-World Impact**: The bug can cause: - Server/datacenter
systems using CPU hotplug for power management to experience interrupt
handling issues - Multi-queue device drivers to malfunction after CPU
hotplug cycles - Unbalanced IRQ state leading to system instability The
fix is well-contained, addresses a clear functional bug with user-
visible symptoms, and follows established patterns for stable backports
in the IRQ subsystem.

 kernel/irq/chip.c       | 22 +++++++++++++++++++++-
 kernel/irq/cpuhotplug.c |  2 +-
 kernel/irq/internals.h  |  1 +
 3 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index c901436ebd9f4..7abe050b7c656 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -223,6 +223,19 @@ __irq_startup_managed(struct irq_desc *desc, const struct cpumask *aff,
 		return IRQ_STARTUP_ABORT;
 	return IRQ_STARTUP_MANAGED;
 }
+
+void irq_startup_managed(struct irq_desc *desc)
+{
+	/*
+	 * Only start it up when the disable depth is 1, so that a disable,
+	 * hotunplug, hotplug sequence does not end up enabling it during
+	 * hotplug unconditionally.
+	 */
+	desc->depth--;
+	if (!desc->depth)
+		irq_startup(desc, IRQ_RESEND, IRQ_START_COND);
+}
+
 #else
 static __always_inline int
 __irq_startup_managed(struct irq_desc *desc, const struct cpumask *aff,
@@ -275,6 +288,7 @@ int irq_startup(struct irq_desc *desc, bool resend, bool force)
 			ret = __irq_startup(desc);
 			break;
 		case IRQ_STARTUP_ABORT:
+			desc->depth = 1;
 			irqd_set_managed_shutdown(d);
 			return 0;
 		}
@@ -307,7 +321,13 @@ void irq_shutdown(struct irq_desc *desc)
 {
 	if (irqd_is_started(&desc->irq_data)) {
 		clear_irq_resend(desc);
-		desc->depth = 1;
+		/*
+		 * Increment disable depth, so that a managed shutdown on
+		 * CPU hotunplug preserves the actual disabled state when the
+		 * CPU comes back online. See irq_startup_managed().
+		 */
+		desc->depth++;
+
 		if (desc->irq_data.chip->irq_shutdown) {
 			desc->irq_data.chip->irq_shutdown(&desc->irq_data);
 			irq_state_set_disabled(desc);
diff --git a/kernel/irq/cpuhotplug.c b/kernel/irq/cpuhotplug.c
index 15a7654eff684..3ed5b15927355 100644
--- a/kernel/irq/cpuhotplug.c
+++ b/kernel/irq/cpuhotplug.c
@@ -219,7 +219,7 @@ static void irq_restore_affinity_of_irq(struct irq_desc *desc, unsigned int cpu)
 		return;
 
 	if (irqd_is_managed_and_shutdown(data))
-		irq_startup(desc, IRQ_RESEND, IRQ_START_COND);
+		irq_startup_managed(desc);
 
 	/*
 	 * If the interrupt can only be directed to a single target
diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index a979523640d0a..9661527e81571 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -87,6 +87,7 @@ extern void __enable_irq(struct irq_desc *desc);
 extern int irq_activate(struct irq_desc *desc);
 extern int irq_activate_and_startup(struct irq_desc *desc, bool resend);
 extern int irq_startup(struct irq_desc *desc, bool resend, bool force);
+extern void irq_startup_managed(struct irq_desc *desc);
 
 extern void irq_shutdown(struct irq_desc *desc);
 extern void irq_shutdown_and_deactivate(struct irq_desc *desc);
-- 
2.39.5

