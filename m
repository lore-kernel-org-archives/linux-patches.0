Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57BD437BE64;
	Sat, 17 Oct 2026 16:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254725; cv=none; b=HjtQ5QJPw9n2TsmgkI83srJVLaON7S7DJ+Q0ZCEeKES5T48hpW1urhmBy3THn0HMr6NllmqgaNW0GZrJrM661hQRFsMd2jDwFZT06xTMiQ1w6RQe8KMKjcJAdeX9KDzjsRfNXoPS8KsyXN6D0m89+OzQd9hMo5hndSnO95aosPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254725; c=relaxed/simple;
	bh=wCE0so2kQ+dr5CATljNjD5u66BnBFD3aH8CNHy81WOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MD8rSC4mWl4u+5tbRajRWJOqy6gilT8CMV92kW21C4NJACIU9xSW3kp2Bq0Hi7dtIs5Fq09vUB8zPlz9eh1uOV0Wa/uFXqLxyXQldRpSXlnplKqAB0LlJXs2coJAoEJhEEwbkpK9S41ddathqNAGClyJ4e8/4Y+Ic4ySt2AwqTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A76w/byX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A76w/byX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6E081F000C4;
	Sat, 17 Oct 2026 16:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254724;
	bh=XIZBEpXM0TmXb+3fsxSp72B84goS/hkdySUD12XYGDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A76w/byX6TbH3BNFPdVwTB93eeqNiN6hObW9V3NSqZE9PIklkBpfBtrq5jCZ87Hvc
	 ZPx3wTSHIFrpffoYWtCOYf7eU3JD4AbpwrU/i7SzWTnJwpfpujkW9iGbO958ZoHAnZ
	 kWOsZWFwbsMkPaFLXvoUUzENE6GVd/CVuSqtyN/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Terry Bowman <terry.bowman@amd.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ben Cheatham <benjamin.cheatham@amd.com>,
	Richard Cheng <icheng@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 541/869] cxl: Fix CXL_HEADERLOG_SIZE to match RAS Capability size
Date: Sat, 17 Oct 2026 17:56:22 +0200
Message-ID: <20261017160050.965499158@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Terry Bowman <terry.bowman@amd.com>

[ Upstream commit c268f949e219f9e179558e836f457f6c5fbec416 ]

The CXL r4.0 8.2.4.17.7 RAS Capability Structure has total length 0x58
bytes (CXL_RAS_CAPABILITY_LENGTH); the Header Log occupies the trailing
64 bytes at offset 0x18.  CXL_HEADERLOG_SIZE was defined as SZ_512,
eight times the actual on-device size.

header_log_copy() reads CXL_HEADERLOG_SIZE_U32 (128) dwords from the
RAS capability iomap, overrunning the 88-byte mapping by 448 bytes.
The cxl_aer_uncorrectable_error trace event memcpy()s CXL_HEADERLOG_SIZE
(512) bytes from its source.  For the CPER caller the source is
struct cxl_ras_capability_regs::header_log[16] (64 bytes) embedded in a
stack-local cxl_cper_prot_err_work_data, so the memcpy reads 448 bytes
of kernel stack into the trace event ring buffer where userspace can
read it via tracefs.

Set CXL_HEADERLOG_SIZE to 64 and derive CXL_HEADERLOG_SIZE_U32 from it,
bringing all iomap readers into agreement on 16 dwords.  Userspace tools
such as rasdaemon have grown a dependency on the buggy 512-byte (128 u32)
header_log layout in the cxl_aer_uncorrectable_error trace event.  Add
CXL_HEADERLOG_TRACE_SIZE_U32 = 128 and use it for the trace event
__array and its memcpy to preserve that ABI.  Both callers now pass a
zero-filled u32[CXL_HEADERLOG_TRACE_SIZE_U32] staging buffer with only
the first CXL_HEADERLOG_SIZE_U32 (16) entries populated from hardware;
the remaining 112 u32s are zero-padded, keeping the 512-byte trace ring
buffer layout intact.

[ dj: Replaced 64 with SZ_64 per RichardC ]

Fixes: 36f257e3b0ba ("acpi/ghes, cxl/pci: Process CXL CPER Protocol Errors")
Fixes: 2905cb5236cb ("cxl/pci: Add (hopeful) error handling support")
Cc: stable@vger.kernel.org
Reported-by: Sashiko
Signed-off-by: Terry Bowman <terry.bowman@amd.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Ben Cheatham <benjamin.cheatham@amd.com>
Reviewed-by: Richard Cheng <icheng@nvidia.com>
Link: https://patch.msgid.link/20260605180610.2249458-1-terry.bowman@amd.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/ras.c   | 10 +++++++---
 drivers/cxl/core/trace.h | 12 ++++++++----
 drivers/cxl/cxl.h        | 14 ++++++++++++--
 3 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/drivers/cxl/core/ras.c b/drivers/cxl/core/ras.c
index 6256b145a517f..b0d9e65bae2fa 100644
--- a/drivers/cxl/core/ras.c
+++ b/drivers/cxl/core/ras.c
@@ -7,6 +7,10 @@
 #include "core.h"
 #include "trace.h"
 
+/* Check that UCE header definition is maintained to keep ABI intact  */
+static_assert(CXL_HEADERLOG_TRACE_SIZE_U32 == 128,
+	      "rasdaemon ABI requires exactly 128 u32s");
+
 void cxl_handle_cor_ras(struct cxl_dev_state *cxlds, void __iomem *ras_base)
 {
 	void __iomem *addr;
@@ -28,12 +32,12 @@ static void header_log_copy(void __iomem *ras_base, u32 *log)
 {
 	void __iomem *addr;
 	u32 *log_addr;
-	int i, log_u32_size = CXL_HEADERLOG_SIZE / sizeof(u32);
+	int i;
 
 	addr = ras_base + CXL_RAS_HEADER_LOG_OFFSET;
 	log_addr = log;
 
-	for (i = 0; i < log_u32_size; i++) {
+	for (i = 0; i < CXL_HEADERLOG_SIZE_U32; i++) {
 		*log_addr = readl(addr);
 		log_addr++;
 		addr += sizeof(u32);
@@ -46,7 +50,7 @@ static void header_log_copy(void __iomem *ras_base, u32 *log)
  */
 bool cxl_handle_ras(struct cxl_dev_state *cxlds, void __iomem *ras_base)
 {
-	u32 hl[CXL_HEADERLOG_SIZE_U32];
+	u32 hl[CXL_HEADERLOG_TRACE_SIZE_U32] = {};
 	void __iomem *addr;
 	u32 status;
 	u32 fe;
diff --git a/drivers/cxl/core/trace.h b/drivers/cxl/core/trace.h
index 8389a94adb1a6..2a7f257193198 100644
--- a/drivers/cxl/core/trace.h
+++ b/drivers/cxl/core/trace.h
@@ -57,7 +57,7 @@ TRACE_EVENT(cxl_aer_uncorrectable_error,
 		__field(u64, serial)
 		__field(u32, status)
 		__field(u32, first_error)
-		__array(u32, header_log, CXL_HEADERLOG_SIZE_U32)
+		__array(u32, header_log, CXL_HEADERLOG_TRACE_SIZE_U32)
 	),
 	TP_fast_assign(
 		__assign_str(memdev);
@@ -66,10 +66,14 @@ TRACE_EVENT(cxl_aer_uncorrectable_error,
 		__entry->status = status;
 		__entry->first_error = fe;
 		/*
-		 * Embed the 512B headerlog data for user app retrieval and
-		 * parsing, but no need to print this in the trace buffer.
+		 * Embed headerlog data for user app retrieval and parsing,
+		 * but no need to print in the trace buffer. Only
+		 * CXL_HEADERLOG_SIZE_U32 (16) dwords are hardware data;
+		 * the remaining entries preserve the 512-byte ABI layout
+		 * rasdaemon depends on and are zero-filled by the caller.
 		 */
-		memcpy(__entry->header_log, hl, CXL_HEADERLOG_SIZE);
+		memcpy(__entry->header_log, hl,
+			CXL_HEADERLOG_TRACE_SIZE_U32 * sizeof(u32));
 	),
 	TP_printk("memdev=%s host=%s serial=%lld: status: '%s' first_error: '%s'",
 		  __get_str(memdev), __get_str(host), __entry->serial,
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 6d726ca28935d..bcd1d140fa0f2 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -147,8 +147,18 @@ static inline int ways_to_eiw(unsigned int ways, u8 *eiw)
 #define CXL_RAS_CAP_CONTROL_FE_MASK GENMASK(5, 0)
 #define CXL_RAS_HEADER_LOG_OFFSET 0x18
 #define CXL_RAS_CAPABILITY_LENGTH 0x58
-#define CXL_HEADERLOG_SIZE SZ_512
-#define CXL_HEADERLOG_SIZE_U32 SZ_512 / sizeof(u32)
+#define CXL_HEADERLOG_SIZE SZ_64
+#define CXL_HEADERLOG_SIZE_U32 (CXL_HEADERLOG_SIZE / sizeof(u32))
+
+/*
+ * The RAS UCE trace event header array was originally sized at SZ_512/sizeof(u32)
+ * = 128 u32s due to a bug. Userspace tools (rasdaemon) have grown a dependency
+ * on that 512-byte layout. Keep the trace array at 128 u32s to preserve the
+ * ABI; only CXL_HEADERLOG_SIZE_U32 (16) dwords are valid hardware data, the
+ * remainder are zero-filled.
+ */
+#define CXL_HEADERLOG_TRACE_SIZE SZ_512
+#define CXL_HEADERLOG_TRACE_SIZE_U32 (CXL_HEADERLOG_TRACE_SIZE / sizeof(u32))
 
 /* CXL 2.0 8.2.8.1 Device Capabilities Array Register */
 #define CXLDEV_CAP_ARRAY_OFFSET 0x0
-- 
2.53.0



