Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADD3A3019CB;
	Mon,  9 Feb 2026 12:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770640052; cv=none; b=XyQMn6yqOwVus0/muqsBSwoxoJ5eulbWVtOXr+A9EkMUY3szN50QyLVw5KLHvRsQH5Z+vf+7FULATo25bAGf+NAcjGjhyo4227AzxcMl9tb9HxJY4uowhF+8hgr1vAQYmLMfLNRtNEpc2ygAV3Mn/j7IfTFz79iGhIYcVHF2q2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770640052; c=relaxed/simple;
	bh=c8y5npcOeFLfMTDfcC3Bza36cf7Jj0zWNxOT1sTRPa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mSshQY1vfVwU+dweRSPjT2LUDL1FpAmIJUy5NnwWECwE0rK5YkKoUuWxaakKOzQhOXbGvp7icJ1ZPKrcyWxfer3WfYDziSi0YErLbTMen+oc8ZjAWPCctm4elZWP/nBocgoqknS/kgVS+jVs2g9up9Qo5Fjt37+QcrdukDfEf9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lNFJlEj4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lNFJlEj4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 353A0C116C6;
	Mon,  9 Feb 2026 12:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770640052;
	bh=c8y5npcOeFLfMTDfcC3Bza36cf7Jj0zWNxOT1sTRPa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lNFJlEj4sJEuu/IY6v/jmvqyXkqPJ8cL48j6Jak/pCEjE6NBG1PvzeKX+VZqANjVF
	 qDys7O4cpf5Di0mP9ntSdXpH2bUOgfpAgznKAJITAiCnFzxDvGJ/2UCt2UqNLBvkaC
	 R1wRH9as53W44ff3avd0mOCFBUwZV2VP/8o137VuZ2zQVUfZDta8suo2GWqMlHTwpE
	 VOVKETmaCoyU6Y1qWQTHfgdjoytOLAPOpbP1ZA/MyIFmZlYWP7ufGnEF5oIuvWnQpj
	 kPK5gUuQwGYQl9zkXhJcC3Be5enGnfcvRECg/VO8eCcXIoMH3mRIeOXAf7ES3CQRPu
	 O64jhFs6u0h/g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+28cea38c382fd15e751a@syzkaller.appspotmail.com,
	Deepanshu Kartikey <Kartikey406@gmail.com>,
	Sean Anderson <sean.anderson@linux.dev>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>,
	jgg@ziepe.ca,
	leon@kernel.org,
	ptesarik@suse.com
Subject: [PATCH AUTOSEL 6.18-6.12] tracing/dma: Cap dma_map_sg tracepoint arrays to prevent buffer overflow
Date: Mon,  9 Feb 2026 07:26:48 -0500
Message-ID: <20260209122714.1037915-9-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260209122714.1037915-1-sashal@kernel.org>
References: <20260209122714.1037915-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Deepanshu Kartikey <kartikey406@gmail.com>

[ Upstream commit daafcc0ef0b358d9d622b6e3b7c43767aa3814ee ]

The dma_map_sg tracepoint can trigger a perf buffer overflow when
tracing large scatter-gather lists. With devices like virtio-gpu
creating large DRM buffers, nents can exceed 1000 entries, resulting
in:

  phys_addrs: 1000 * 8 bytes = 8,000 bytes
  dma_addrs:  1000 * 8 bytes = 8,000 bytes
  lengths:    1000 * 4 bytes = 4,000 bytes
  Total: ~20,000 bytes

This exceeds PERF_MAX_TRACE_SIZE (8192 bytes), causing:

  WARNING: CPU: 0 PID: 5497 at kernel/trace/trace_event_perf.c:405
  perf buffer not large enough, wanted 24620, have 8192

Cap all three dynamic arrays at 128 entries using min() in the array
size calculation. This ensures arrays are only as large as needed
(up to the cap), avoiding unnecessary memory allocation for small
operations while preventing overflow for large ones.

The tracepoint now records the full nents/ents counts and a truncated
flag so users can see when data has been capped.

Changes in v2:
- Use min(nents, DMA_TRACE_MAX_ENTRIES) for dynamic array sizing
  instead of fixed DMA_TRACE_MAX_ENTRIES allocation (feedback from
  Steven Rostedt)
- This allocates only what's needed up to the cap, avoiding waste
  for small operations

Reported-by: syzbot+28cea38c382fd15e751a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=28cea38c382fd15e751a
Tested-by: syzbot+28cea38c382fd15e751a@syzkaller.appspotmail.com
Signed-off-by: Deepanshu Kartikey <Kartikey406@gmail.com>
Reviwed-by: Sean Anderson <sean.anderson@linux.dev>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/20260130155215.69737-1-kartikey406@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This confirms the bug. At line 405, `WARN_ONCE` fires when `size >
PERF_MAX_TRACE_SIZE` (8192 bytes), and the function returns NULL,
causing the tracepoint to fail. The original `dma_map_sg` tracepoint
uses unbounded dynamic arrays (`__dynamic_array(u64, phys_addrs,
nents)`) which with large scatter-gather lists (nents > ~340 for a
single array of u64, or combined arrays > 8192 bytes total) will exceed
this limit.

### 3. CLASSIFICATION

**This is a clear bug fix.** It fixes:
1. A **buffer overflow** (trace data exceeding `PERF_MAX_TRACE_SIZE`)
2. A **kernel WARNING** triggered at runtime
3. A **functional failure** — the tracepoint becomes non-functional when
   the warning fires (returns NULL)

The bug is **syzbot-reported and reproducible**, with a concrete trigger
(virtio-gpu creating large DRM buffers).

### 4. SCOPE AND RISK ASSESSMENT

**Scope:**
- Single file changed: `include/trace/events/dma.h`
- Only the `dma_map_sg` TRACE_EVENT definition is modified
- Changes are contained within the tracepoint macro infrastructure

**Changes made:**
1. Define `DMA_TRACE_MAX_ENTRIES` (128) — a reasonable cap
2. Cap `__dynamic_array` sizes with `min(nents, DMA_TRACE_MAX_ENTRIES)`
3. Cap the `for_each_sg` iteration to traced_nents/traced_ents
4. Add `full_nents`, `full_ents`, and `truncated` fields for
   observability
5. Update `TP_printk` to show actual vs capped counts and a
   `[TRUNCATED]` marker

**Risk:**
- LOW risk. The change only affects the tracing subsystem, not the DMA
  mapping itself.
- The DMA operations proceed identically — only the trace output
  changes.
- Worst case: trace data is truncated (by design), but users are clearly
  informed via the `[TRUNCATED]` flag.
- The new fields (`full_nents`, `full_ents`, `truncated`) do change the
  tracepoint ABI slightly, but tracepoint ABIs are explicitly not stable
  (they can change between kernel versions).

### 5. USER IMPACT

- **Who is affected**: Anyone tracing DMA operations with perf on
  systems that create large scatter-gather lists (virtio-gpu, any GPU
  driver with large DRM buffers, potentially NVMe or other high-
  throughput I/O drivers).
- **Severity without fix**: Kernel WARNING on every affected tracepoint
  hit, plus the trace data is lost entirely (perf_trace_buf_alloc
  returns NULL). The WARNING can also trigger panic-on-warn
  configurations.
- **With the fix**: Trace data is properly capped and recorded, no
  WARNING.

### 6. STABILITY INDICATORS

- Reported by syzbot with a reproducer
- Tested by syzbot (confirmed fix)
- Reviewed by Sean Anderson
- Accepted by DMA subsystem maintainer Marek Szyprowski
- Iterated based on Steven Rostedt (tracing maintainer) feedback
- V2 of the patch — showing refinement

### 7. DEPENDENCY CHECK

- The `dma_map_sg` tracepoint was introduced in v6.12 (commit
  038eb433dc147). This fix only applies to 6.12+ stable trees.
- The patch modifies only the existing tracepoint definition and is
  self-contained.
- No dependencies on other patches.

### 8. CONCERNS

- **Note about `dma_alloc_sgt` and `dma_free_sgt` and other similar
  tracepoints**: These also have unbounded `__dynamic_array` based on
  `sgt->orig_nents` but are NOT fixed in this commit. This could mean
  those are less commonly hit or a separate fix is needed. However, this
  doesn't diminish the value of fixing the `dma_map_sg` case.
- **ABI change to tracepoint format**: The tracepoint output format
  changes (new fields added, format modified). While tracepoint ABIs are
  not considered stable, any perf scripts parsing the exact format of
  `dma_map_sg` would need updating. This is minor since tracepoint
  formats are expected to change.
- The patch should apply cleanly to 6.12.y since the file hasn't had
  many changes in this area since v6.12.

### SUMMARY

This is a well-crafted, syzbot-reported, tested-and-reviewed fix for a
real buffer overflow in the DMA tracing subsystem. The bug causes kernel
WARNINGs and complete failure of DMA scatter-gather tracing with large
buffers. The fix is small, contained to a single file, affects only the
tracing path (not actual DMA operations), and is low-risk. It has strong
trust indicators: syzbot-tested, maintainer-reviewed, and iterated based
on subsystem maintainer feedback. The only limitation is that it applies
only to stable trees 6.12+ where the tracepoint exists.

**YES**

 include/trace/events/dma.h | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/include/trace/events/dma.h b/include/trace/events/dma.h
index b3fef140ae155..33e99e792f1aa 100644
--- a/include/trace/events/dma.h
+++ b/include/trace/events/dma.h
@@ -275,6 +275,8 @@ TRACE_EVENT(dma_free_sgt,
 				sizeof(u64), sizeof(u64)))
 );
 
+#define DMA_TRACE_MAX_ENTRIES 128
+
 TRACE_EVENT(dma_map_sg,
 	TP_PROTO(struct device *dev, struct scatterlist *sgl, int nents,
 		 int ents, enum dma_data_direction dir, unsigned long attrs),
@@ -282,9 +284,12 @@ TRACE_EVENT(dma_map_sg,
 
 	TP_STRUCT__entry(
 		__string(device, dev_name(dev))
-		__dynamic_array(u64, phys_addrs, nents)
-		__dynamic_array(u64, dma_addrs, ents)
-		__dynamic_array(unsigned int, lengths, ents)
+		__field(int, full_nents)
+		__field(int, full_ents)
+		__field(bool, truncated)
+		__dynamic_array(u64, phys_addrs,  min(nents, DMA_TRACE_MAX_ENTRIES))
+		__dynamic_array(u64, dma_addrs, min(ents, DMA_TRACE_MAX_ENTRIES))
+		__dynamic_array(unsigned int, lengths, min(ents, DMA_TRACE_MAX_ENTRIES))
 		__field(enum dma_data_direction, dir)
 		__field(unsigned long, attrs)
 	),
@@ -292,11 +297,16 @@ TRACE_EVENT(dma_map_sg,
 	TP_fast_assign(
 		struct scatterlist *sg;
 		int i;
+		int traced_nents = min_t(int, nents, DMA_TRACE_MAX_ENTRIES);
+		int traced_ents = min_t(int, ents, DMA_TRACE_MAX_ENTRIES);
 
 		__assign_str(device);
-		for_each_sg(sgl, sg, nents, i)
+		__entry->full_nents = nents;
+		__entry->full_ents = ents;
+		__entry->truncated = (nents > DMA_TRACE_MAX_ENTRIES) || (ents > DMA_TRACE_MAX_ENTRIES);
+		for_each_sg(sgl, sg, traced_nents, i)
 			((u64 *)__get_dynamic_array(phys_addrs))[i] = sg_phys(sg);
-		for_each_sg(sgl, sg, ents, i) {
+		for_each_sg(sgl, sg, traced_ents, i) {
 			((u64 *)__get_dynamic_array(dma_addrs))[i] =
 				sg_dma_address(sg);
 			((unsigned int *)__get_dynamic_array(lengths))[i] =
@@ -306,9 +316,12 @@ TRACE_EVENT(dma_map_sg,
 		__entry->attrs = attrs;
 	),
 
-	TP_printk("%s dir=%s dma_addrs=%s sizes=%s phys_addrs=%s attrs=%s",
+	TP_printk("%s dir=%s nents=%d/%d ents=%d/%d%s dma_addrs=%s sizes=%s phys_addrs=%s attrs=%s",
 		__get_str(device),
 		decode_dma_data_direction(__entry->dir),
+		min_t(int, __entry->full_nents, DMA_TRACE_MAX_ENTRIES), __entry->full_nents,
+		min_t(int, __entry->full_ents, DMA_TRACE_MAX_ENTRIES), __entry->full_ents,
+		__entry->truncated ? " [TRUNCATED]" : "",
 		__print_array(__get_dynamic_array(dma_addrs),
 			      __get_dynamic_array_len(dma_addrs) /
 				sizeof(u64), sizeof(u64)),
-- 
2.51.0

