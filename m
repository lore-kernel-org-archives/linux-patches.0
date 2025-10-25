Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 867D2302CB8;
	Sat, 25 Oct 2025 16:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409485; cv=none; b=uCCnrAlkPfcFu+vf2WL5eEaAB4/E8p928uDAK09jd3WumHxgJXx3W98oV80J4ifKFdYyQ6QAD5R68XPQAP88t4KgtcIVDOmtR3bTpWGxOHs2JvKvjUdHkK57HdZsv7e/13Xr5Tb1VdqDAkibxZ/bVswvBdkuTIXN2R28Zqq1JcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409485; c=relaxed/simple;
	bh=rk3G3WM6efAJRetQFee0jg61Wboa43cijZ7Gtlo5zdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VKme718/CLB3nhFJTrTO2Y/uz/bgzXatLARdxR6UrpShgeA4xyoAQDr3MD30F09j1eLknJQE84EB8oSPzuGO02A12/Dynn/WWAbuODML3l4It0mN83rrhw6xD85At1xmRPUdpO0qvnsVohgZhrqE8/z5nWhYGZ/mn53QW0Ov8l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=glMG+Yza; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="glMG+Yza"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E71AC4CEFB;
	Sat, 25 Oct 2025 16:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409485;
	bh=rk3G3WM6efAJRetQFee0jg61Wboa43cijZ7Gtlo5zdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=glMG+YzakiprAAzSq7u4r7Csv4gSQmGItYuCpWfk7YZEImR4Sspsj/d7lsBDQRC0r
	 HqmsDrRsYdr8/sDlMJ9Qp0+v6hQrR4G3aXCgIZovxhPwJFUX1+M72Qv8+F99RpmkNA
	 ghR0Rj4H1oSWotA+b5d+xA3K4+tuETqLhiIglqbJ00PQ+Xcq3eCfZbGpWiBZ95TSoX
	 kArBfeTc/eR0ejHZZBtGYxj2gcV/CtwpTzRst2MKf0H8+SvzI0lwn8HSnMldWw0l0n
	 cDJSP+4dEJQq9QrpbRw04f1s/sl6t79Dq9DOuDlQ20KiBsqXO7WzYa3Z6pZcIOlaJW
	 0vC0tb5R7BEfA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Seyediman Seyedarab <ImanDevel@gmail.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	dwmw2@infradead.org,
	iommu@lists.linux.dev
Subject: [PATCH AUTOSEL 6.17-5.15] iommu/vt-d: Replace snprintf with scnprintf in dmar_latency_snapshot()
Date: Sat, 25 Oct 2025 11:59:36 -0400
Message-ID: <20251025160905.3857885-345-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Seyediman Seyedarab <ImanDevel@gmail.com>

[ Upstream commit 75c02a037609f34db17e91be195cedb33b61bae0 ]

snprintf() returns the number of bytes that would have been written, not
the number actually written. Using this for offset tracking can cause
buffer overruns if truncation occurs.

Replace snprintf() with scnprintf() to ensure the offset stays within
bounds.

Since scnprintf() never returns a negative value, and zero is not possible
in this context because 'bytes' starts at 0 and 'size - bytes' is
DEBUG_BUFFER_SIZE in the first call, which is large enough to hold the
string literals used, the return value is always positive. An integer
overflow is also completely out of reach here due to the small and fixed
buffer size. The error check in latency_show_one() is therefore
unnecessary. Remove it and make dmar_latency_snapshot() return void.

Signed-off-by: Seyediman Seyedarab <ImanDevel@gmail.com>
Link: https://lore.kernel.org/r/20250731225048.131364-1-ImanDevel@gmail.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES – This fixes a real memory-corruption bug in the Intel VT-d debugfs
latency snapshot and the change is tight, self-contained, and low risk
for stable.

- `drivers/iommu/intel/perf.c:116-160` now uses `scnprintf` for every
  append into `debug_buf`. Previously `snprintf` advanced the `bytes`
  cursor by the would-have-been length; once the counters grew large
  enough to truncate a write, `bytes` could exceed `size`, and the next
  `snprintf(str + bytes, size - bytes, …)` would wrap the length
  argument and scribble past the 1 KB buffer. That overflow is a latent
  kernel memory corruption reachable from the `dmar_perf_latency`
  debugfs file. With `scnprintf`, the offset can no longer run past the
  remaining space, eliminating the corruption risk.
- `drivers/iommu/intel/debugfs.c:659-666` drops the dead `< 0` error
  handling and simply prints the buffer, matching the new `void` return
  semantics and avoiding bogus “Failed to get latency snapshot”
  messages.
- `drivers/iommu/intel/perf.h:37-70` updates the prototype and the
  `!CONFIG_DMAR_PERF` stub accordingly so all callers build cleanly; no
  other interfaces or architectures are touched.

The bug exists in all trees that have Intel IOMMU debugfs
(`CONFIG_INTEL_IOMMU_DEBUGFS` selects this code) and can be triggered by
routine use once latency counters accumulate large values. The fix is
entirely in debug/perf code, introduces no behavioural changes beyond
removing the overflow, and carries negligible regression risk.
Backporting is recommended.

 drivers/iommu/intel/debugfs.c | 10 ++--------
 drivers/iommu/intel/perf.c    | 10 ++++------
 drivers/iommu/intel/perf.h    |  5 ++---
 3 files changed, 8 insertions(+), 17 deletions(-)

diff --git a/drivers/iommu/intel/debugfs.c b/drivers/iommu/intel/debugfs.c
index 5aa7f46a420b5..38790ff50977c 100644
--- a/drivers/iommu/intel/debugfs.c
+++ b/drivers/iommu/intel/debugfs.c
@@ -661,17 +661,11 @@ DEFINE_SHOW_ATTRIBUTE(ir_translation_struct);
 static void latency_show_one(struct seq_file *m, struct intel_iommu *iommu,
 			     struct dmar_drhd_unit *drhd)
 {
-	int ret;
-
 	seq_printf(m, "IOMMU: %s Register Base Address: %llx\n",
 		   iommu->name, drhd->reg_base_addr);
 
-	ret = dmar_latency_snapshot(iommu, debug_buf, DEBUG_BUFFER_SIZE);
-	if (ret < 0)
-		seq_puts(m, "Failed to get latency snapshot");
-	else
-		seq_puts(m, debug_buf);
-	seq_puts(m, "\n");
+	dmar_latency_snapshot(iommu, debug_buf, DEBUG_BUFFER_SIZE);
+	seq_printf(m, "%s\n", debug_buf);
 }
 
 static int latency_show(struct seq_file *m, void *v)
diff --git a/drivers/iommu/intel/perf.c b/drivers/iommu/intel/perf.c
index adc4de6bbd88e..dceeadc3ee7cd 100644
--- a/drivers/iommu/intel/perf.c
+++ b/drivers/iommu/intel/perf.c
@@ -113,7 +113,7 @@ static char *latency_type_names[] = {
 	"     svm_prq"
 };
 
-int dmar_latency_snapshot(struct intel_iommu *iommu, char *str, size_t size)
+void dmar_latency_snapshot(struct intel_iommu *iommu, char *str, size_t size)
 {
 	struct latency_statistic *lstat = iommu->perf_statistic;
 	unsigned long flags;
@@ -122,7 +122,7 @@ int dmar_latency_snapshot(struct intel_iommu *iommu, char *str, size_t size)
 	memset(str, 0, size);
 
 	for (i = 0; i < COUNTS_NUM; i++)
-		bytes += snprintf(str + bytes, size - bytes,
+		bytes += scnprintf(str + bytes, size - bytes,
 				  "%s", latency_counter_names[i]);
 
 	spin_lock_irqsave(&latency_lock, flags);
@@ -130,7 +130,7 @@ int dmar_latency_snapshot(struct intel_iommu *iommu, char *str, size_t size)
 		if (!dmar_latency_enabled(iommu, i))
 			continue;
 
-		bytes += snprintf(str + bytes, size - bytes,
+		bytes += scnprintf(str + bytes, size - bytes,
 				  "\n%s", latency_type_names[i]);
 
 		for (j = 0; j < COUNTS_NUM; j++) {
@@ -156,11 +156,9 @@ int dmar_latency_snapshot(struct intel_iommu *iommu, char *str, size_t size)
 				break;
 			}
 
-			bytes += snprintf(str + bytes, size - bytes,
+			bytes += scnprintf(str + bytes, size - bytes,
 					  "%12lld", val);
 		}
 	}
 	spin_unlock_irqrestore(&latency_lock, flags);
-
-	return bytes;
 }
diff --git a/drivers/iommu/intel/perf.h b/drivers/iommu/intel/perf.h
index df9a36942d643..1d4baad7e852e 100644
--- a/drivers/iommu/intel/perf.h
+++ b/drivers/iommu/intel/perf.h
@@ -40,7 +40,7 @@ void dmar_latency_disable(struct intel_iommu *iommu, enum latency_type type);
 bool dmar_latency_enabled(struct intel_iommu *iommu, enum latency_type type);
 void dmar_latency_update(struct intel_iommu *iommu, enum latency_type type,
 			 u64 latency);
-int dmar_latency_snapshot(struct intel_iommu *iommu, char *str, size_t size);
+void dmar_latency_snapshot(struct intel_iommu *iommu, char *str, size_t size);
 #else
 static inline int
 dmar_latency_enable(struct intel_iommu *iommu, enum latency_type type)
@@ -64,9 +64,8 @@ dmar_latency_update(struct intel_iommu *iommu, enum latency_type type, u64 laten
 {
 }
 
-static inline int
+static inline void
 dmar_latency_snapshot(struct intel_iommu *iommu, char *str, size_t size)
 {
-	return 0;
 }
 #endif /* CONFIG_DMAR_PERF */
-- 
2.51.0

