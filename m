Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6588B356A12;
	Tue, 21 Jul 2026 19:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661323; cv=none; b=isGWPX1aMvGSZ8qwk96Ygf0Ydf9LeL5tbcjfYpggjE0rDMwQTk6nktCa5WHG3qMS0CXBv2/MRXMoKKgf9sT19Obo/3kJpW4GRYZ5XVDSpf/vg3FD0WfUD4TP6M6Ndt1Mrm1BzDHQC9vxypkFcEhjjC4dP8cvtA0wspVnMr5JXZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661323; c=relaxed/simple;
	bh=BA2kON/wZ22oq041h+hf345Srz+rxWqpwZv4tPQoNpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IOB2TUeEFIzbrPXbHWxVnAC1ql/xJkiqJIyxJqBiQLpulOg0+nSVgZT9kjikkR+MIUKWG7FELUNQdpiSE19SD+u30xda/JvFttZeYkNqobkSGtCvpLUBJG0tUxLn/MAcjnewkwGc5D2uogwUgO3QZP2w3vMpBcAVa73uKrhSxd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kLLXgkCV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kLLXgkCV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D35C01F000E9;
	Tue, 21 Jul 2026 19:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661322;
	bh=/QEsS85ouI//0jw6RzkRm/IabH9LYSI0Z5l7PFEkw08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kLLXgkCVL2ENohny9LA0Sbv6TrIg9lDXoAaBeMwwwi/I3uMWcKaLDGkNo+01o9VMK
	 Lo9wVL5/UziolyhQ+bYeYYY42L+VR/qOASYeuUXJEdyQWrK/EACz98hc350DH7x9wA
	 Vb42eyz85RYJbHbTvj02QjhUvzPKKlfb7GLqdK9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Borislav Petkov <bp@alien8.de>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Dheeraj Kumar Srivastava <dheerajkumar.srivastava@amd.com>,
	Liam Merwick <liam.merwick@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0023/1276] iommu/amd: Use maximum Event log buffer size when SNP is enabled on Family 0x19
Date: Tue, 21 Jul 2026 17:07:46 +0200
Message-ID: <20260721152446.600823937@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasant Hegde <vasant.hegde@amd.com>

commit 58c0ac6125d89bf6ec65a521eaeb52a0e8e20a9f upstream.

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
(cherry picked from commit 58c0ac6125d89bf6ec65a521eaeb52a0e8e20a9f)
Conflicts:
	drivers/iommu/amd/init.c
[ Conflicts in alloc_event_buffer() and iommu_enable_event_buffer()
  due to lack of upstream AMD IOMMU kdump buffer reuse code.
  Similarly, do not add a kdump check when allocating an
  event log buffer in state_next(). ]
Signed-off-by: Liam Merwick <liam.merwick@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/amd_iommu.h       |  2 +
 drivers/iommu/amd/amd_iommu_types.h | 10 ++--
 drivers/iommu/amd/init.c            | 77 +++++++++++++++++++++--------
 drivers/iommu/amd/iommu.c           |  2 +-
 4 files changed, 67 insertions(+), 24 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu.h b/drivers/iommu/amd/amd_iommu.h
index 27eedfb47d8b69..36cd610104e3f8 100644
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
index 7f13b314abbcef..d622fa0091a5a3 100644
--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -15,6 +15,7 @@
 #include <linux/mutex.h>
 #include <linux/msi.h>
 #include <linux/list.h>
+#include <linux/sizes.h>
 #include <linux/spinlock.h>
 #include <linux/pci.h>
 #include <linux/irqreturn.h>
@@ -132,7 +133,6 @@
 #define MMIO_STATUS_GALOG_INT_MASK		BIT(10)
 
 /* event logging constants */
-#define EVENT_ENTRY_SIZE	0x10
 #define EVENT_TYPE_SHIFT	28
 #define EVENT_TYPE_MASK		0xf
 #define EVENT_TYPE_ILL_DEV	0x1
@@ -240,8 +240,12 @@
 #define MMIO_CMD_SIZE_512 (0x9ULL << MMIO_CMD_SIZE_SHIFT)
 
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
index 78e9ceda2338f3..570471e1058655 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -133,6 +133,8 @@ struct ivhd_entry {
 	u8 uid;
 } __attribute__((packed));
 
+int amd_iommu_evtlog_size = EVTLOG_SIZE_DEF;
+
 /*
  * An AMD IOMMU memory definition structure. It defines things like exclusion
  * ranges for devices and regions that should be unity mapped.
@@ -855,30 +857,41 @@ void *__init iommu_alloc_4k_pages(struct amd_iommu *iommu, gfp_t gfp,
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
 
-	entry = iommu_virt_to_phys(iommu->evt_buf) | EVT_LEN_MASK;
+		entry = iommu_virt_to_phys(iommu->evt_buf);
+		entry |= (amd_iommu_evtlog_size == EVTLOG_SIZE_DEF) ?
+			EVTLOG_LEN_MASK_DEF : EVTLOG_LEN_MASK_MAX;
 
-	memcpy_toio(iommu->mmio_base + MMIO_EVT_BUF_OFFSET,
-		    &entry, sizeof(entry));
+		memcpy_toio(iommu->mmio_base + MMIO_EVT_BUF_OFFSET,
+			    &entry, sizeof(entry));
 
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
@@ -891,7 +904,7 @@ static void iommu_disable_event_buffer(struct amd_iommu *iommu)
 
 static void __init free_event_buffer(struct amd_iommu *iommu)
 {
-	iommu_free_pages(iommu->evt_buf, get_order(EVT_BUFFER_SIZE));
+	iommu_free_pages(iommu->evt_buf, get_order(amd_iommu_evtlog_size));
 }
 
 static void free_ga_log(struct amd_iommu *iommu)
@@ -1828,9 +1841,6 @@ static int __init init_iommu_one_late(struct amd_iommu *iommu)
 	if (alloc_command_buffer(iommu))
 		return -ENOMEM;
 
-	if (alloc_event_buffer(iommu))
-		return -ENOMEM;
-
 	iommu->int_enabled = false;
 
 	init_translation_status(iommu);
@@ -2754,7 +2764,6 @@ static void early_enable_iommu(struct amd_iommu *iommu)
 	iommu_init_flags(iommu);
 	iommu_set_device_table(iommu);
 	iommu_enable_command_buffer(iommu);
-	iommu_enable_event_buffer(iommu);
 	iommu_set_exclusion_range(iommu);
 	iommu_enable_gt(iommu);
 	iommu_enable_ga(iommu);
@@ -2812,7 +2821,6 @@ static void early_enable_iommus(void)
 			iommu_disable_event_buffer(iommu);
 			iommu_disable_irtcachedis(iommu);
 			iommu_enable_command_buffer(iommu);
-			iommu_enable_event_buffer(iommu);
 			iommu_enable_ga(iommu);
 			iommu_enable_xt(iommu);
 			iommu_enable_irtcachedis(iommu);
@@ -2928,6 +2936,7 @@ static void amd_iommu_resume(void)
 	/* re-load the hardware */
 	enable_iommus();
 
+	iommu_enable_event_buffer();
 	amd_iommu_enable_interrupts();
 }
 
@@ -3242,6 +3251,23 @@ static void iommu_snp_enable(void)
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
@@ -3278,6 +3304,17 @@ static int __init state_next(void)
 	case IOMMU_ENABLED:
 		register_syscore_ops(&amd_iommu_syscore_ops);
 		iommu_snp_enable();
+
+		amd_iommu_apply_erratum_snp();
+
+		/* Allocate/enable event log buffer */
+		ret = alloc_event_buffer();
+		if (ret) {
+			init_state = IOMMU_INIT_ERROR;
+			break;
+		}
+		iommu_enable_event_buffer();
+
 		ret = amd_iommu_init_pci();
 		init_state = ret ? IOMMU_INIT_ERROR : IOMMU_PCI_INIT;
 		break;
@@ -3865,7 +3902,7 @@ int amd_iommu_snp_disable(void)
 		return 0;
 
 	for_each_iommu(iommu) {
-		ret = iommu_make_shared(iommu->evt_buf, EVT_BUFFER_SIZE);
+		ret = iommu_make_shared(iommu->evt_buf, amd_iommu_evtlog_size);
 		if (ret)
 			return ret;
 
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 5ea0d9eb0ccc54..b4052fa9cc76bc 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1003,7 +1003,7 @@ static void iommu_poll_events(struct amd_iommu *iommu)
 		iommu_print_event(iommu, iommu->evt_buf + head);
 
 		/* Update head pointer of hardware ring-buffer */
-		head = (head + EVENT_ENTRY_SIZE) % EVT_BUFFER_SIZE;
+		head = (head + EVTLOG_ENTRY_SIZE) % amd_iommu_evtlog_size;
 		writel(head, iommu->mmio_base + MMIO_EVT_HEAD_OFFSET);
 	}
 
-- 
2.53.0



