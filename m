Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503B828C009;
	Tue, 17 Feb 2026 20:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361608; cv=none; b=VR7XSwJtIaMF0G91S5ay5tPI5l3FiM8WvtTeUYbqK7grDdX+vPnn+b1oqYaClzNoT+uSR9ddiLQ7Tndu1i1MRISsxLJS/nxmQ1JS1MNZEMLnyQ21q7xwuIpbo0EMgwhNSdBJed1zyv7XhrmUofN1LPBeGiKSaYq6k+bXVVf9f2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361608; c=relaxed/simple;
	bh=1Zsr/MgdQjskTIvhrkstgCB97/RG9J5mH4PwrvgNcrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EvBtMspam37+3c5/uvf2Nr4eHqMp4jn1kFL7EWTDH2DdYf0aF2nEdKlNLmRajh5kR0nQi9mBW9eeb3TM8AdnMT85SUqCC6uCkbvycfMuiQLv0j8RupIn2I+8RyS+sg07XHVbVwilbTpVB4oKIiT3N4OhDILkCvWmSgBt8tt4i9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VIZzN+bB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VIZzN+bB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8E23C4CEF7;
	Tue, 17 Feb 2026 20:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361608;
	bh=1Zsr/MgdQjskTIvhrkstgCB97/RG9J5mH4PwrvgNcrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VIZzN+bB/cCS2Fgq7mXXlLilCMcJEZpDqdzgaVUjKJbrXKzPnPN4+nh0j1O5euxTx
	 54M6R/s6gpPdhXMjEGXi1CBkdTw5sJbh/mBmhvQXb7PspkwLl/4SOgTOl+DbuQpKcf
	 Ne/cfP4piIyXf2T6Gv15q1uP769FB1L7pIEjCmiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+28cea38c382fd15e751a@syzkaller.appspotmail.com,
	Deepanshu Kartikey <Kartikey406@gmail.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>,
	Sean Anderson <sean.anderson@linux.dev>
Subject: [PATCH 6.12 21/42] tracing/dma: Cap dma_map_sg tracepoint arrays to prevent buffer overflow
Date: Tue, 17 Feb 2026 21:32:12 +0100
Message-ID: <20260217200006.813281092@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200005.998240758@linuxfoundation.org>
References: <20260217200005.998240758@linuxfoundation.org>
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
 include/trace/events/dma.h | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/include/trace/events/dma.h b/include/trace/events/dma.h
index e5187144c91b7..705363b228a40 100644
--- a/include/trace/events/dma.h
+++ b/include/trace/events/dma.h
@@ -278,6 +278,8 @@ TRACE_EVENT(dma_free_sgt,
 				sizeof(u64), sizeof(u64)))
 );
 
+#define DMA_TRACE_MAX_ENTRIES 128
+
 TRACE_EVENT(dma_map_sg,
 	TP_PROTO(struct device *dev, struct scatterlist *sgl, int nents,
 		 int ents, enum dma_data_direction dir, unsigned long attrs),
@@ -285,9 +287,12 @@ TRACE_EVENT(dma_map_sg,
 
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
@@ -295,11 +300,16 @@ TRACE_EVENT(dma_map_sg,
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
@@ -309,9 +319,12 @@ TRACE_EVENT(dma_map_sg,
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



