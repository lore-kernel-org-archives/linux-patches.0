Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED91B36A359;
	Mon, 11 May 2026 22:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778538012; cv=none; b=oX1/6SALo5bzZqlauontUVkjw6KYKK/5FVe8O0Kg/XhIMzPGxj1o+OZ2h2OQJoFGaLRbjZUGCcprVMFJjfk/g7uGvx0QogSO7boo6TYatJOFAEoc6DVDnFFjgzrY5eESVH+Lgm8wPEQbiiT1TorANdM3QLJ2HOCwYrQ8XTUd2+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778538012; c=relaxed/simple;
	bh=L86pyKWsxPvaB5adhMiA/7xl+or1ihECJG1ePo8bnEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=stGf0Qyxf+jL+Vn8iTfNK6sGEnT0WvkhN71VKkGguacwZnDWIjCPRAVWszFa+QLG296nZd72tedGBIuKRrXdyur0lTKImaQmLD3PoGTsrsXDAZR1gFOGV4ILtLHtdMKo/K6q7ta0p6PI2A/jl1ujkhujMEo9+amAxjuJjD3hG6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IUNMOvc8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IUNMOvc8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A89FC2BCF5;
	Mon, 11 May 2026 22:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778538011;
	bh=L86pyKWsxPvaB5adhMiA/7xl+or1ihECJG1ePo8bnEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IUNMOvc8Pr+8A/6dbYKE+htjl5pXukzN5GME9yT+rjM9bDNq34vS9Qp4sF4to65OM
	 u431r67Yt519P9FL87WV+W9ZXSdcGrm1EpwonP6rgsadNceXHsVLApqx0hHUoJyrsx
	 iuYq3m4T5OxAcKyEfXjGEiyb9OcEJ4TjVMgjfi5I5zwZ93TrYPa7eKYh4pE7gmrXMF
	 xKunXBoe/tjbkBhJKBYSEM9L/mrA21JtjHndraCj3IEWb53/SVJJw9OskbLK1IXdUN
	 8Mw3WH4IYBP2vd/0KZFGor0SLvwvWAqpCy+G/qZm6KtWMaJ0MlrYTeUOHZTVemce7d
	 7tCBCsgd+WnQQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Vasant Hegde <vasant.hegde@amd.com>,
	Borislav Petkov <bp@alien8.de>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Dheeraj Kumar Srivastava <dheerajkumar.srivastava@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	joro@8bytes.org,
	will@kernel.org,
	iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] iommu/amd: Use maximum Event log buffer size when SNP is enabled on Family 0x19
Date: Mon, 11 May 2026 18:19:26 -0400
Message-ID: <20260511221931.2370053-27-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511221931.2370053-1-sashal@kernel.org>
References: <20260511221931.2370053-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vasant Hegde <vasant.hegde@amd.com>

[ Upstream commit 58c0ac6125d89bf6ec65a521eaeb52a0e8e20a9f ]

Due to CVE-2023-20585, the Event log buffer must use the maximum supported
size (512K) on Milan/Genoa (Family 0x19) systems when SNP is enabled,
to mitigate a potential security vulnerability. All other systems continue to
use the default Event log buffer size (8K).

Apply the errata fix by making the following changes:

* Introduce new global variable (amd_iommu_evtlog_size) to have event log
  buffer size. Adjust variable size for family 0x19.

* Since 'iommu_snp_enable()' must be called after the core IOMMU subsystem
  is initialized, it cannot be moved to the early init stage. The SNP errata
  must also be applied after the 'iommu_snp_enable()' check. Therefore,
  'alloc_event_buffer()' and 'iommu_enable_event_buffer()' are now called
  in the IOMMU_ENABLED state, after the errata is applied.

* Adjust alloc_event_buffer() and iommu_enable_event_buffer() to handle
  all IOMMU instances.

* Also rename EVT_* macros to make it more readable.

Link: https://www.amd.com/en/resources/product-security/bulletin/amd-sb-3016.html
Cc: Borislav Petkov <bp@alien8.de>
Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Vasant Hegde <vasant.hegde@amd.com>
Tested-by: Dheeraj Kumar Srivastava <dheerajkumar.srivastava@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Conclusion
This commit should be backported to stable trees that carry AMD IOMMU
SNP host support. It is a security mitigation for `CVE-2023-20585`,
scoped to AMD Family `0x19` systems with SNP enabled, and it keeps all
other systems on the existing 8K event log size.

The patch is not feature enablement in the stable sense; it is a
hardware erratum/security workaround. The main concern is backport
mechanics: it applies cleanly to `stable/linux-7.0.y`, but failed a
direct apply check on `6.12.y`, `6.18.y`, and `6.19.y`, so those need
backport adjustment. For Genoa, the companion PPR-log patch should also
be considered for the full series mitigation.

## Phase Walkthrough
Phase 1 Record:
- Subject subsystem/action: `iommu/amd`, action is “Use maximum”, intent
  is to use a 512K AMD IOMMU event log buffer for SNP on Family `0x19`.
- Tags: `Link` to AMD-SB-3016, `Cc` to AMD/IOMMU maintainers, `Signed-
  off-by` Vasant Hegde, `Tested-by` Dheeraj Kumar Srivastava, `Signed-
  off-by` Joerg Roedel. No `Fixes:` tag.
- Body: describes `CVE-2023-20585`, requiring max supported event log
  buffer size on Milan/Genoa with SNP enabled; all other systems remain
  at 8K.
- Hidden bug fix: yes. This is phrased partly as buffer
  sizing/refactoring, but the purpose is a CVE security mitigation.

Phase 2 Record:
- Files changed: `drivers/iommu/amd/amd_iommu.h`, `amd_iommu_types.h`,
  `init.c`, `iommu.c`; fetched commit stat is 86 insertions, 38
  deletions.
- Functions modified/added: `alloc_event_buffer`,
  `iommu_enable_event_buffer`, `remap_event_buffer`,
  `early_enable_iommu`, `early_enable_iommus`, `amd_iommu_resume`, new
  `amd_iommu_apply_erratum_snp`, `state_next`, `amd_iommu_snp_disable`,
  `iommu_poll_events`.
- Code flow: event buffer allocation/enable moves from early per-IOMMU
  setup to after `iommu_snp_enable()`, allowing the erratum decision to
  set 512K before allocation/programming. Polling and SNP shutdown now
  use the variable size.
- Bug category: hardware security erratum/workaround.
- Fix quality: contained to AMD IOMMU event-log handling. Regression
  risk is medium-low because init ordering changes, but it is subsystem-
  contained, tested, and keeps non-SNP/non-Family-0x19 behavior at 8K.

Phase 3 Record:
- Blame/history: fixed 8K event buffer logic is long-standing; SNP
  integration relevant to the erratum is present from the v6.9 era and
  later. `6.12.y`, `6.18.y`, `6.19.y`, and `7.0.y` contain the
  integrated SNP enable commit checked locally; `5.15.y`, `6.1.y`, and
  `6.6.y` do not.
- `Fixes:` tag: none, so no direct original-bug commit to follow.
- Related file history: companion commit `1f44aab79bac3` does the same
  for the PPR log. Patch 2 depends conceptually/codewise on patch 1;
  patch 1 stands on its own for the event log.
- Author context: Vasant Hegde has multiple recent AMD IOMMU fixes in
  the fetched IOMMU fixes branch; Joerg Roedel committed the patch.
- Dependencies: no semantic dependency on the NUMA log-buffer allocation
  commit, but older stable branches have context differences requiring
  backport edits.

Phase 4 Record:
- `b4 dig -c 58c0ac6125d89`: found the original lore submission at `http
  s://patch.msgid.link/20260420084204.12263-2-vasant.hegde@amd.com`.
- `b4 dig -a`: only v1 found.
- `b4 dig -w`: original recipients included `iommu@lists.linux.dev`,
  Joerg Roedel, Will Deacon, Robin Murphy, Suravee Suthikulpanit, and
  Borislav Petkov.
- Lore thread: Dheeraj Kumar Srivastava replied `Tested-by`; Joerg
  Roedel replied “Applied to fixes”.
- AMD bulletin: AMD-SB-3016 confirms potential SNP guest integrity loss
  from an IOMMU host buffer out-of-bounds condition and says OS updates
  are required along with firmware.

Phase 5 Record:
- Callers: event interrupt path uses `amd_iommu_int_thread_evtlog()` ->
  `amd_iommu_handle_irq()` -> `iommu_poll_events()`. Interrupt setup is
  via AMD IOMMU MSI/INTCAPXT setup in `init.c`.
- Callees: allocation uses `iommu_alloc_4k_pages()`, which handles SNP
  4K page setup; enable writes `MMIO_EVT_BUF_OFFSET`, head/tail
  registers, and `CONTROL_EVT_LOG_EN`.
- Reachability: reachable on AMD IOMMU systems through hardware event
  interrupts and SNP init/shutdown paths, not through a direct userspace
  syscall.
- Similar pattern: companion PPR log patch in the same series mirrors
  the variable-size/max-buffer handling.

Phase 6 Record:
- Stable code existence: `6.12.y`, `6.18.y`, `6.19.y`, and `7.0.y` have
  the relevant AMD IOMMU SNP/event-log code. `5.15.y`, `6.1.y`, and
  `6.6.y` lack the integrated SNP enable commit I checked; `6.6.y` has
  an exported old SNP enable function but no in-tree caller was found.
- Backport difficulty: clean on `7.0.y`; direct apply failed on
  `6.12.y`, `6.18.y`, and `6.19.y`, so those need manual backporting.
- Related stable discussion: no stable-list-specific discussion for this
  CVE/patch was found by `lei`.

Phase 7 Record:
- Subsystem: AMD IOMMU driver under `drivers/iommu/amd`.
- Criticality: important platform/virtualization security code,
  affecting AMD EPYC SNP hosts rather than all systems.
- Activity: actively maintained; recent AMD IOMMU fixes and the
  maintainer-applied fixes branch confirm ongoing subsystem work.

Phase 8 Record:
- Affected users: AMD Family `0x19` Milan/Genoa systems with SNP
  enabled.
- Trigger/security conditions: AMD bulletin describes a privileged
  attacker with a compromised hypervisor triggering an out-of-bounds
  condition without RMP checks.
- Failure severity: security integrity impact for confidential SNP
  guests; AMD rates it Medium, but stable rules treat CVE/security
  mitigations as strong candidates.
- Benefit/risk: high benefit for affected SNP hosts; medium-low
  regression risk due to contained but non-trivial init-order and
  buffer-size changes.

Phase 9 Record:
- Evidence for: CVE/security mitigation, AMD bulletin requires OS
  update, tested-by, maintainer applied to fixes, scoped to AMD IOMMU,
  default behavior preserved for unaffected systems.
- Evidence against/concerns: patch is larger than a trivial one-liner,
  moves event buffer allocation/enable timing, and needs backport
  adjustments for several stable branches. Genoa full mitigation also
  needs the PPR companion patch.
- Stable rules: fixes a real security issue; important; no new userspace
  API; contained to one driver; tested; applies cleanly to `7.0.y` and
  can be backported with adjustments elsewhere.
- Exception category: hardware erratum/security workaround.

## Verification
- [Phase 1] Parsed fetched commit `58c0ac6125d89`: confirmed subject,
  tags, `Tested-by`, no `Fixes:`, and AMD-SB-3016 link.
- [Phase 2] Inspected diff/stat from fetched commit: 4 AMD IOMMU files,
  86 insertions, 38 deletions.
- [Phase 3] Ran `git blame` on event allocation, enable, SNP init, and
  polling paths; confirmed relevant code history.
- [Phase 3] Checked stable branch ancestry: `6.12.y+` contain integrated
  SNP enable; `5.15.y`, `6.1.y`, `6.6.y` do not.
- [Phase 4] Ran `b4 dig -c 58c0ac6125d89`, `-a`, and `-w`; found one v1
  submission, maintainers/recipients, and lore URL.
- [Phase 4] Fetched lore thread; confirmed `Tested-by` reply and
  maintainer “Applied to fixes”.
- [Phase 4] Fetched AMD bulletin; confirmed CVE impact and OS update
  requirement.
- [Phase 5] Traced event interrupt call path with source search/read:
  `amd_iommu_int_thread_evtlog()` to `iommu_poll_events()`.
- [Phase 6] Ran apply checks: clean on `stable/linux-7.0.y`; failed
  direct apply on `6.12.y`, `6.18.y`, and `6.19.y`.
- UNVERIFIED: I did not build-test the backport or test on AMD Family
  `0x19` SNP hardware.

**YES**

 drivers/iommu/amd/amd_iommu.h       |   2 +
 drivers/iommu/amd/amd_iommu_types.h |  10 ++-
 drivers/iommu/amd/init.c            | 110 +++++++++++++++++++---------
 drivers/iommu/amd/iommu.c           |   2 +-
 4 files changed, 86 insertions(+), 38 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu.h b/drivers/iommu/amd/amd_iommu.h
index 1342e764a5486..f1c486dcf0f38 100644
--- a/drivers/iommu/amd/amd_iommu.h
+++ b/drivers/iommu/amd/amd_iommu.h
@@ -11,6 +11,8 @@
 
 #include "amd_iommu_types.h"
 
+extern int amd_iommu_evtlog_size;
+
 irqreturn_t amd_iommu_int_thread(int irq, void *data);
 irqreturn_t amd_iommu_int_thread_evtlog(int irq, void *data);
 irqreturn_t amd_iommu_int_thread_pprlog(int irq, void *data);
diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
index c685d3771436a..c3430c09bc5c9 100644
--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -15,6 +15,7 @@
 #include <linux/mutex.h>
 #include <linux/msi.h>
 #include <linux/list.h>
+#include <linux/sizes.h>
 #include <linux/spinlock.h>
 #include <linux/pci.h>
 #include <linux/iommufd.h>
@@ -141,7 +142,6 @@
 #define MMIO_STATUS_GALOG_INT_MASK		BIT(10)
 
 /* event logging constants */
-#define EVENT_ENTRY_SIZE	0x10
 #define EVENT_TYPE_SHIFT	28
 #define EVENT_TYPE_MASK		0xf
 #define EVENT_TYPE_ILL_DEV	0x1
@@ -259,8 +259,12 @@
 #define MMIO_CMD_BUFFER_TAIL(x) FIELD_GET(MMIO_CMD_TAIL_MASK, (x))
 
 /* constants for event buffer handling */
-#define EVT_BUFFER_SIZE		8192 /* 512 entries */
-#define EVT_LEN_MASK		(0x9ULL << 56)
+#define EVTLOG_ENTRY_SIZE	0x10
+#define EVTLOG_SIZE_SHIFT	56
+#define EVTLOG_SIZE_DEF		SZ_8K /* 512 entries */
+#define EVTLOG_LEN_MASK_DEF	(0x9ULL << EVTLOG_SIZE_SHIFT)
+#define EVTLOG_SIZE_MAX		SZ_512K /* 32K entries */
+#define EVTLOG_LEN_MASK_MAX	(0xFULL << EVTLOG_SIZE_SHIFT)
 
 /* Constants for PPR Log handling */
 #define PPR_LOG_ENTRIES		512
diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index f3fd7f39efb48..74effb847f488 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -132,6 +132,8 @@ struct ivhd_entry {
 	u8 uid;
 } __attribute__((packed));
 
+int amd_iommu_evtlog_size = EVTLOG_SIZE_DEF;
+
 /*
  * An AMD IOMMU memory definition structure. It defines things like exclusion
  * ranges for devices and regions that should be unity mapped.
@@ -864,35 +866,47 @@ void *__init iommu_alloc_4k_pages(struct amd_iommu *iommu, gfp_t gfp,
 }
 
 /* allocates the memory where the IOMMU will log its events to */
-static int __init alloc_event_buffer(struct amd_iommu *iommu)
+static int __init alloc_event_buffer(void)
 {
-	iommu->evt_buf = iommu_alloc_4k_pages(iommu, GFP_KERNEL,
-					      EVT_BUFFER_SIZE);
+	struct amd_iommu *iommu;
 
-	return iommu->evt_buf ? 0 : -ENOMEM;
+	for_each_iommu(iommu) {
+		iommu->evt_buf = iommu_alloc_4k_pages(iommu, GFP_KERNEL,
+						      amd_iommu_evtlog_size);
+		if (!iommu->evt_buf)
+			return -ENOMEM;
+	}
+
+	return 0;
 }
 
-static void iommu_enable_event_buffer(struct amd_iommu *iommu)
+static void iommu_enable_event_buffer(void)
 {
+	struct amd_iommu *iommu;
 	u64 entry;
 
-	BUG_ON(iommu->evt_buf == NULL);
+	for_each_iommu(iommu) {
+		BUG_ON(iommu->evt_buf == NULL);
 
-	if (!is_kdump_kernel()) {
-		/*
-		 * Event buffer is re-used for kdump kernel and setting
-		 * of MMIO register is not required.
-		 */
-		entry = iommu_virt_to_phys(iommu->evt_buf) | EVT_LEN_MASK;
-		memcpy_toio(iommu->mmio_base + MMIO_EVT_BUF_OFFSET,
-			    &entry, sizeof(entry));
-	}
+		if (!is_kdump_kernel()) {
+			/*
+			 * Event buffer is re-used for kdump kernel and setting
+			 * of MMIO register is not required.
+			 */
+			entry = iommu_virt_to_phys(iommu->evt_buf);
+			entry |= (amd_iommu_evtlog_size == EVTLOG_SIZE_DEF) ?
+				EVTLOG_LEN_MASK_DEF : EVTLOG_LEN_MASK_MAX;
+
+			memcpy_toio(iommu->mmio_base + MMIO_EVT_BUF_OFFSET,
+				    &entry, sizeof(entry));
+		}
 
-	/* set head and tail to zero manually */
-	writel(0x00, iommu->mmio_base + MMIO_EVT_HEAD_OFFSET);
-	writel(0x00, iommu->mmio_base + MMIO_EVT_TAIL_OFFSET);
+		/* set head and tail to zero manually */
+		writel(0x00, iommu->mmio_base + MMIO_EVT_HEAD_OFFSET);
+		writel(0x00, iommu->mmio_base + MMIO_EVT_TAIL_OFFSET);
 
-	iommu_feature_enable(iommu, CONTROL_EVT_LOG_EN);
+		iommu_feature_enable(iommu, CONTROL_EVT_LOG_EN);
+	}
 }
 
 /*
@@ -981,15 +995,20 @@ static int __init alloc_cwwb_sem(struct amd_iommu *iommu)
 	return 0;
 }
 
-static int __init remap_event_buffer(struct amd_iommu *iommu)
+static int __init remap_event_buffer(void)
 {
+	struct amd_iommu *iommu;
 	u64 paddr;
 
 	pr_info_once("Re-using event buffer from the previous kernel\n");
-	paddr = readq(iommu->mmio_base + MMIO_EVT_BUF_OFFSET) & PM_ADDR_MASK;
-	iommu->evt_buf = iommu_memremap(paddr, EVT_BUFFER_SIZE);
+	for_each_iommu(iommu) {
+		paddr = readq(iommu->mmio_base + MMIO_EVT_BUF_OFFSET) & PM_ADDR_MASK;
+		iommu->evt_buf = iommu_memremap(paddr, amd_iommu_evtlog_size);
+		if (!iommu->evt_buf)
+			return -ENOMEM;
+	}
 
-	return iommu->evt_buf ? 0 : -ENOMEM;
+	return 0;
 }
 
 static int __init remap_command_buffer(struct amd_iommu *iommu)
@@ -1041,10 +1060,6 @@ static int __init alloc_iommu_buffers(struct amd_iommu *iommu)
 		ret = remap_command_buffer(iommu);
 		if (ret)
 			return ret;
-
-		ret = remap_event_buffer(iommu);
-		if (ret)
-			return ret;
 	} else {
 		ret = alloc_cwwb_sem(iommu);
 		if (ret)
@@ -1053,10 +1068,6 @@ static int __init alloc_iommu_buffers(struct amd_iommu *iommu)
 		ret = alloc_command_buffer(iommu);
 		if (ret)
 			return ret;
-
-		ret = alloc_event_buffer(iommu);
-		if (ret)
-			return ret;
 	}
 
 	return 0;
@@ -2890,7 +2901,6 @@ static void early_enable_iommu(struct amd_iommu *iommu)
 	iommu_init_flags(iommu);
 	iommu_set_device_table(iommu);
 	iommu_enable_command_buffer(iommu);
-	iommu_enable_event_buffer(iommu);
 	iommu_set_exclusion_range(iommu);
 	iommu_enable_gt(iommu);
 	iommu_enable_ga(iommu);
@@ -2954,7 +2964,6 @@ static void early_enable_iommus(void)
 			iommu_disable_event_buffer(iommu);
 			iommu_disable_irtcachedis(iommu);
 			iommu_enable_command_buffer(iommu);
-			iommu_enable_event_buffer(iommu);
 			iommu_enable_ga(iommu);
 			iommu_enable_xt(iommu);
 			iommu_enable_irtcachedis(iommu);
@@ -3067,6 +3076,7 @@ static void amd_iommu_resume(void *data)
 	for_each_iommu(iommu)
 		early_enable_iommu(iommu);
 
+	iommu_enable_event_buffer();
 	amd_iommu_enable_interrupts();
 }
 
@@ -3396,6 +3406,23 @@ static __init void iommu_snp_enable(void)
 #endif
 }
 
+static void amd_iommu_apply_erratum_snp(void)
+{
+#ifdef CONFIG_KVM_AMD_SEV
+	if (!amd_iommu_snp_en)
+		return;
+
+	/* Errata fix for Family 0x19 */
+	if (boot_cpu_data.x86 != 0x19)
+		return;
+
+	/* Set event log buffer size to max */
+	amd_iommu_evtlog_size = EVTLOG_SIZE_MAX;
+	pr_info("Applying erratum: Increase Event log size to 0x%x\n",
+		amd_iommu_evtlog_size);
+#endif
+}
+
 /****************************************************************************
  *
  * AMD IOMMU Initialization State Machine
@@ -3432,6 +3459,21 @@ static int __init state_next(void)
 	case IOMMU_ENABLED:
 		register_syscore(&amd_iommu_syscore);
 		iommu_snp_enable();
+
+		amd_iommu_apply_erratum_snp();
+
+		/* Allocate/enable event log buffer */
+		if (is_kdump_kernel())
+			ret = remap_event_buffer();
+		else
+			ret = alloc_event_buffer();
+
+		if (ret) {
+			init_state = IOMMU_INIT_ERROR;
+			break;
+		}
+		iommu_enable_event_buffer();
+
 		ret = amd_iommu_init_pci();
 		init_state = ret ? IOMMU_INIT_ERROR : IOMMU_PCI_INIT;
 		break;
@@ -4034,7 +4076,7 @@ int amd_iommu_snp_disable(void)
 		return 0;
 
 	for_each_iommu(iommu) {
-		ret = iommu_make_shared(iommu->evt_buf, EVT_BUFFER_SIZE);
+		ret = iommu_make_shared(iommu->evt_buf, amd_iommu_evtlog_size);
 		if (ret)
 			return ret;
 
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 760d5f4623b55..02b5eaae6843d 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1009,7 +1009,7 @@ static void iommu_poll_events(struct amd_iommu *iommu)
 		iommu_print_event(iommu, iommu->evt_buf + head);
 
 		/* Update head pointer of hardware ring-buffer */
-		head = (head + EVENT_ENTRY_SIZE) % EVT_BUFFER_SIZE;
+		head = (head + EVTLOG_ENTRY_SIZE) % amd_iommu_evtlog_size;
 		writel(head, iommu->mmio_base + MMIO_EVT_HEAD_OFFSET);
 	}
 
-- 
2.53.0

