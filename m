Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84D8F429004;
	Wed, 30 Sep 2026 19:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797132; cv=none; b=G4UTzY1+FIIdSWNx8O2KbJKk0t1RKddHa/4O8oVAjdrl7poBpj9IC7HeWBIiLkXAh4tRmJ82wcKmGEKNgkj29ARHkCfK3HoAiurCTc4zeEJ6ZygRkjoPzbmVNoZbTqpe3VGB5KjD2W9bOdyw5rgyrL8z/n7eiEFER9Qon/8+iLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797132; c=relaxed/simple;
	bh=dWGgSWH2pnxVd3hAs8vc0aRCs7ipU81+4H2Eq8GvgrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SHW13SntqJo6aytgpuswxsLHGEZkFdRcCZXaX0o9HK2YUNNlUWtilyxWJF0aokpC4AG+zWzPuYhORgrVkEYob9OGWBfQqxKB/nZ66jaeyrCRWQG2gI+FPsSLFTzWyi/pGU1H8cG5Qo9Vc/OeKUEWC2uHn2D/QWIwBNcbHbvRPvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sTik3qcB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sTik3qcB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A69391F000FF;
	Wed, 30 Sep 2026 19:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790797131;
	bh=PCMPdildP/u4dYj3Z/TcOECiSV1pSyEcCh77upos8+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sTik3qcBhnl1CrgCQsSYKVKK4jEMeR/tSGQilLPE9eWJR/l53RIorh7j+NRxoDil9
	 qw6xL2Rv34prm9lsARCZHnlysVkWootkQ1Lja9/j9eR48/rhlZnUGLjqTlz4NiI2ut
	 URr/76ppjkdZOUo/3WmCbzYozsA7k9N+xI+0wyyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1159/1193] wifi: ath12k: fix kernel crash during resume
Date: Wed, 30 Sep 2026 17:30:43 +0200
Message-ID: <20260930152459.992530149@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baochen Qiang <quic_bqiang@quicinc.com>

[ Upstream commit 303c017821d88ebad887814114d4e5966d320b28 ]

Currently during resume, QMI target memory is not properly handled, resulting
in kernel crash in case DMA remap is not supported:

BUG: Bad page state in process kworker/u16:54  pfn:36e80
page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x36e80
page dumped because: nonzero _refcount
Call Trace:
 bad_page
 free_page_is_bad_report
 __free_pages_ok
 __free_pages
 dma_direct_free
 dma_free_attrs
 ath12k_qmi_free_target_mem_chunk
 ath12k_qmi_msg_mem_request_cb

The reason is:
Once ath12k module is loaded, firmware sends memory request to host. In case
DMA remap not supported, ath12k refuses the first request due to failure in
allocating with large segment size:

ath12k_pci 0000:04:00.0: qmi firmware request memory request
ath12k_pci 0000:04:00.0: qmi mem seg type 1 size 7077888
ath12k_pci 0000:04:00.0: qmi mem seg type 4 size 8454144
ath12k_pci 0000:04:00.0: qmi dma allocation failed (7077888 B type 1), will try later with small size
ath12k_pci 0000:04:00.0: qmi delays mem_request 2
ath12k_pci 0000:04:00.0: qmi firmware request memory request

Later firmware comes back with more but small segments and allocation
succeeds:

ath12k_pci 0000:04:00.0: qmi mem seg type 1 size 524288
ath12k_pci 0000:04:00.0: qmi mem seg type 1 size 524288
ath12k_pci 0000:04:00.0: qmi mem seg type 1 size 524288
ath12k_pci 0000:04:00.0: qmi mem seg type 1 size 524288
ath12k_pci 0000:04:00.0: qmi mem seg type 1 size 524288
ath12k_pci 0000:04:00.0: qmi mem seg type 1 size 524288
ath12k_pci 0000:04:00.0: qmi mem seg type 1 size 524288
ath12k_pci 0000:04:00.0: qmi mem seg type 1 size 262144
ath12k_pci 0000:04:00.0: qmi mem seg type 1 size 524288
ath12k_pci 0000:04:00.0: qmi mem seg type 1 size 524288
ath12k_pci 0000:04:00.0: qmi mem seg type 1 size 524288
ath12k_pci 0000:04:00.0: qmi mem seg type 1 size 524288
ath12k_pci 0000:04:00.0: qmi mem seg type 1 size 524288
ath12k_pci 0000:04:00.0: qmi mem seg type 4 size 524288
ath12k_pci 0000:04:00.0: qmi mem seg type 4 size 524288
ath12k_pci 0000:04:00.0: qmi mem seg type 4 size 524288
ath12k_pci 0000:04:00.0: qmi mem seg type 4 size 524288
ath12k_pci 0000:04:00.0: qmi mem seg type 4 size 524288
ath12k_pci 0000:04:00.0: qmi mem seg type 4 size 524288
ath12k_pci 0000:04:00.0: qmi mem seg type 4 size 524288
ath12k_pci 0000:04:00.0: qmi mem seg type 4 size 524288
ath12k_pci 0000:04:00.0: qmi mem seg type 4 size 524288
ath12k_pci 0000:04:00.0: qmi mem seg type 4 size 524288
ath12k_pci 0000:04:00.0: qmi mem seg type 4 size 524288
ath12k_pci 0000:04:00.0: qmi mem seg type 4 size 524288
ath12k_pci 0000:04:00.0: qmi mem seg type 4 size 524288
ath12k_pci 0000:04:00.0: qmi mem seg type 4 size 524288
ath12k_pci 0000:04:00.0: qmi mem seg type 4 size 524288
ath12k_pci 0000:04:00.0: qmi mem seg type 4 size 524288
ath12k_pci 0000:04:00.0: qmi mem seg type 4 size 65536
ath12k_pci 0000:04:00.0: qmi mem seg type 1 size 524288

Now ath12k is working. If suspend is triggered, firmware will be reloaded
during resume. As same as before, firmware requests two large segments at
first. In ath12k_qmi_msg_mem_request_cb() segment count and size are
assigned:

	ab->qmi.mem_seg_count == 2
	ab->qmi.target_mem[0].size == 7077888
	ab->qmi.target_mem[1].size == 8454144

Then allocation failed like before and ath12k_qmi_free_target_mem_chunk()
is called to free all allocated segments. Note the first segment is skipped
because its v.addr is cleared due to allocation failure:

	chunk->v.addr = dma_alloc_coherent()

Also note that this leaks that segment because it has not been freed.

While freeing the second segment, a size of 8454144 is passed to
dma_free_coherent(). However remember that this segment is allocated at
the first time firmware is loaded, before suspend. So its real size is
524288, much smaller than 8454144. As a result kernel found we are freeing
some memory which is in use and thus crashed.

So one possible fix would be to free those segments during suspend. This
works because with them freed, ath12k_qmi_free_target_mem_chunk() does
nothing: all segment addresses are NULL so dma_free_coherent() is not called.

But note that ath11k has similar logic but never hits this issue. Reviewing
code there shows the luck comes from QMI memory reuse logic. So the decision
is to port it to ath12k. Like in ath11k, the crash is avoided by adding
prev_size to target_mem_chunk structure and caching real segment size in it,
then prev_size instead of current size is passed to dma_free_coherent(),
no unexpected memory is freed now.

Also reuse m3 buffer.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0-03427-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.15378.4
Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3

[ Backport to 6.6.y: carried target-memory reuse and prev_size tracking;
  the target already retains core resources and reuses M3, whose size
  check follows in patch 2. ]

Signed-off-by: Baochen Qiang <quic_bqiang@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://msgid.link/20240419034034.2842-1-quic_bqiang@quicinc.com
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/qmi.c | 20 +++++++++++++++++++-
 drivers/net/wireless/ath/ath12k/qmi.h |  2 ++
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/qmi.c b/drivers/net/wireless/ath/ath12k/qmi.c
index c49f585cc3965..7a9868dbab02d 100644
--- a/drivers/net/wireless/ath/ath12k/qmi.c
+++ b/drivers/net/wireless/ath/ath12k/qmi.c
@@ -2152,8 +2152,9 @@ static void ath12k_qmi_free_target_mem_chunk(struct ath12k_base *ab)
 	for (i = 0; i < ab->qmi.mem_seg_count; i++) {
 		if (!ab->qmi.target_mem[i].v.addr)
 			continue;
+
 		dma_free_coherent(ab->dev,
-				  ab->qmi.target_mem[i].size,
+				  ab->qmi.target_mem[i].prev_size,
 				  ab->qmi.target_mem[i].v.addr,
 				  ab->qmi.target_mem[i].paddr);
 		ab->qmi.target_mem[i].v.addr = NULL;
@@ -2179,6 +2180,19 @@ static int ath12k_qmi_alloc_target_mem_chunk(struct ath12k_base *ab)
 		case M3_DUMP_REGION_TYPE:
 		case PAGEABLE_MEM_REGION_TYPE:
 		case CALDB_MEM_REGION_TYPE:
+			/* Firmware reloads in recovery/resume. Reuse an
+			 * unchanged allocation rather than allocating it again.
+			 */
+			if (chunk->v.addr) {
+				if (chunk->prev_type == chunk->type &&
+				    chunk->prev_size == chunk->size)
+					goto this_chunk_done;
+
+				dma_free_coherent(ab->dev, chunk->prev_size,
+						  chunk->v.addr, chunk->paddr);
+				chunk->v.addr = NULL;
+			}
+
 			chunk->v.addr = dma_alloc_coherent(ab->dev,
 							   chunk->size,
 							   &chunk->paddr,
@@ -2197,6 +2211,10 @@ static int ath12k_qmi_alloc_target_mem_chunk(struct ath12k_base *ab)
 					    chunk->type, chunk->size);
 				return -ENOMEM;
 			}
+
+			chunk->prev_type = chunk->type;
+			chunk->prev_size = chunk->size;
+this_chunk_done:
 			break;
 		default:
 			ath12k_warn(ab, "memory type %u not supported\n",
diff --git a/drivers/net/wireless/ath/ath12k/qmi.h b/drivers/net/wireless/ath/ath12k/qmi.h
index 4c1ba3196a403..a996c6d57aa7b 100644
--- a/drivers/net/wireless/ath/ath12k/qmi.h
+++ b/drivers/net/wireless/ath/ath12k/qmi.h
@@ -97,6 +97,8 @@ struct ath12k_qmi_event_msg {
 struct target_mem_chunk {
 	u32 size;
 	u32 type;
+	u32 prev_size;
+	u32 prev_type;
 	dma_addr_t paddr;
 	union {
 		void __iomem *ioaddr;
-- 
2.53.0



