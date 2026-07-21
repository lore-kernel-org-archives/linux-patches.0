Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD73C46D0A4;
	Tue, 21 Jul 2026 17:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655465; cv=none; b=e22irmR/3sO1jpRg6Jq+MuoY+b5ns7clbJbzy7u+1G8kRZRSCiKens9Z5R0Jhgm9jXdPB15ztGnajTL9Qv6FXPDQcptob7soIJ+no71dSyIy1bMgSm3sCZtfBlhbmLGEPqsAU8NQ15iRCq/7Jj4atmxvYZkVBZUBe1kAF3RQfOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655465; c=relaxed/simple;
	bh=wOuDYqMoQ72Z2UlMQ7duBhgvXhLieDQBheE+omWQEFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NpnIYMYoDWe7Ab3CDmTXl3oW/1Y8gjlN7yHwQAnqNMmXJL1HhZf9JjkyqnKjVhy256RCYUwkjwt4633whN74+24G2mbcdatg4kGEvD6g1i4fXNgw+033kNwAwS3yraN7lYRJMMAlzC26VbZ4HtSHo9/3ZVUzbvxzhL/Jon8vjIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tMvy328q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tMvy328q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3DC61F000E9;
	Tue, 21 Jul 2026 17:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655462;
	bh=GZyJVwJhQZykdzoLF1xulRsEJE0AbQLEAiH7HeuKiLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tMvy328q7Ji8beM6n/5d8qmld2lI5F0uQkPNVsAJ4p8WoOXfTpwlivv9Xx/X6KZnJ
	 iEsZECxT8GnZkbzNGV3d/JPO+ujH3aM12SgL3wmH7iQ7FKKZMX8gi9qhaKv8f1fro9
	 LRqM1T9xJiTfaEeIRF4P/XFSSsb10e5FQlD+bcfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Borislav Petkov <bp@alien8.de>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Dheeraj Kumar Srivastava <dheerajkumar.srivastava@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0019/1611] iommu/amd: Use maximum PPR log buffer size when SNP is enabled on Family 0x19
Date: Tue, 21 Jul 2026 17:02:15 +0200
Message-ID: <20260721152515.228743536@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasant Hegde <vasant.hegde@amd.com>

[ Upstream commit 1f44aab79bac31f459422dfb213e907bb386509c ]

Due to CVE-2023-20585, the PPR log buffer must use the maximum supported
size (512K) on Genoa (Family 0x19, model >= 0x10) systems when SNP is
enabled, to mitigate a potential security vulnerability. Note that Family
0x19 models below 0x10 (Milan) do not support PPR when SNP is enabled.
Hence the PPR log size increase is only applied for model >= 0x10.
All other systems continue to use the default PPR log buffer size (8K).

Apply the errata fix by making the following changes:

- Introduce global new variable (amd_iommu_pprlog_size) to have PPR log buffer
  size. Adjust variable size for Genoa family.

- Extend 'amd_iommu_apply_erratum_snp()' to also set the PPR log buffer
  size to maximum for Family 0x19 model >= 0x10 when SNP is enabled.

- Rename PPR_* macros to make it more readable.

Link: https://www.amd.com/en/resources/product-security/bulletin/amd-sb-3016.html
Cc: Borislav Petkov <bp@alien8.de>
Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Vasant Hegde <vasant.hegde@amd.com>
Tested-by: Dheeraj Kumar Srivastava <dheerajkumar.srivastava@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/amd_iommu.h       |  1 +
 drivers/iommu/amd/amd_iommu_types.h | 11 ++++++-----
 drivers/iommu/amd/init.c            | 13 ++++++++++++-
 drivers/iommu/amd/ppr.c             |  8 +++++---
 4 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu.h b/drivers/iommu/amd/amd_iommu.h
index 57d7f3faa98c6e..ef397c5a2c4ab2 100644
--- a/drivers/iommu/amd/amd_iommu.h
+++ b/drivers/iommu/amd/amd_iommu.h
@@ -12,6 +12,7 @@
 #include "amd_iommu_types.h"
 
 extern int amd_iommu_evtlog_size;
+extern int amd_iommu_pprlog_size;
 
 irqreturn_t amd_iommu_int_thread(int irq, void *data);
 irqreturn_t amd_iommu_int_thread_evtlog(int irq, void *data);
diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
index bdd6c38ddfec9b..2494b1958117b2 100644
--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -257,11 +257,12 @@
 #define EVTLOG_LEN_MASK_MAX	(0xFULL << EVTLOG_SIZE_SHIFT)
 
 /* Constants for PPR Log handling */
-#define PPR_LOG_ENTRIES		512
-#define PPR_LOG_SIZE_SHIFT	56
-#define PPR_LOG_SIZE_512	(0x9ULL << PPR_LOG_SIZE_SHIFT)
-#define PPR_ENTRY_SIZE		16
-#define PPR_LOG_SIZE		(PPR_ENTRY_SIZE * PPR_LOG_ENTRIES)
+#define PPRLOG_ENTRY_SIZE	0x10
+#define PPRLOG_SIZE_SHIFT	56
+#define PPRLOG_SIZE_DEF		SZ_8K	/* 512 entries */
+#define PPRLOG_LEN_MASK_DEF	(0x9ULL << PPRLOG_SIZE_SHIFT)
+#define PPRLOG_SIZE_MAX		SZ_512K	/* 32K entries */
+#define PPRLOG_LEN_MASK_MAX	(0xFULL << PPRLOG_SIZE_SHIFT)
 
 /* PAGE_SERVICE_REQUEST PPR Log Buffer Entry flags */
 #define PPR_FLAG_EXEC		0x002	/* Execute permission requested */
diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 64964bb5ce0d36..6e5efc340c83e4 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -133,6 +133,7 @@ struct ivhd_entry {
 } __attribute__((packed));
 
 int amd_iommu_evtlog_size = EVTLOG_SIZE_DEF;
+int amd_iommu_pprlog_size = PPRLOG_SIZE_DEF;
 
 /*
  * An AMD IOMMU memory definition structure. It defines things like exclusion
@@ -3411,6 +3412,16 @@ static void amd_iommu_apply_erratum_snp(void)
 	amd_iommu_evtlog_size = EVTLOG_SIZE_MAX;
 	pr_info("Applying erratum: Increase Event log size to 0x%x\n",
 		amd_iommu_evtlog_size);
+
+	/*
+	 * Set PPR log buffer size to max.
+	 * (Family 0x19, model < 0x10 doesn't support PPR when SNP is enabled).
+	 */
+	if (boot_cpu_data.x86_model >= 0x10) {
+		amd_iommu_pprlog_size = PPRLOG_SIZE_MAX;
+		pr_info("Applying erratum: Increase PPR log size to 0x%x\n",
+			amd_iommu_pprlog_size);
+	}
 #endif
 }
 
@@ -4071,7 +4082,7 @@ int amd_iommu_snp_disable(void)
 		if (ret)
 			return ret;
 
-		ret = iommu_make_shared(iommu->ppr_log, PPR_LOG_SIZE);
+		ret = iommu_make_shared(iommu->ppr_log, amd_iommu_pprlog_size);
 		if (ret)
 			return ret;
 
diff --git a/drivers/iommu/amd/ppr.c b/drivers/iommu/amd/ppr.c
index e6767c057d01fa..1f8d2823bea42c 100644
--- a/drivers/iommu/amd/ppr.c
+++ b/drivers/iommu/amd/ppr.c
@@ -20,7 +20,7 @@
 int __init amd_iommu_alloc_ppr_log(struct amd_iommu *iommu)
 {
 	iommu->ppr_log = iommu_alloc_4k_pages(iommu, GFP_KERNEL | __GFP_ZERO,
-					      PPR_LOG_SIZE);
+					      amd_iommu_pprlog_size);
 	return iommu->ppr_log ? 0 : -ENOMEM;
 }
 
@@ -33,7 +33,9 @@ void amd_iommu_enable_ppr_log(struct amd_iommu *iommu)
 
 	iommu_feature_enable(iommu, CONTROL_PPR_EN);
 
-	entry = iommu_virt_to_phys(iommu->ppr_log) | PPR_LOG_SIZE_512;
+	entry = iommu_virt_to_phys(iommu->ppr_log);
+	entry |= (amd_iommu_pprlog_size == PPRLOG_SIZE_DEF) ?
+			PPRLOG_LEN_MASK_DEF : PPRLOG_LEN_MASK_MAX;
 
 	memcpy_toio(iommu->mmio_base + MMIO_PPR_LOG_OFFSET,
 		    &entry, sizeof(entry));
@@ -201,7 +203,7 @@ void amd_iommu_poll_ppr_log(struct amd_iommu *iommu)
 			raw[0] = raw[1] = 0UL;
 
 		/* Update head pointer of hardware ring-buffer */
-		head = (head + PPR_ENTRY_SIZE) % PPR_LOG_SIZE;
+		head = (head + PPRLOG_ENTRY_SIZE) % amd_iommu_pprlog_size;
 		writel(head, iommu->mmio_base + MMIO_PPR_HEAD_OFFSET);
 
 		/* Handle PPR entry */
-- 
2.53.0



