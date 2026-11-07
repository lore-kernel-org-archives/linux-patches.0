Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063333;
	b=cak3MFlQamnEm4Hn3F7SNsbOgU336rBqM7ZeY8sDma5HWgNeSIc2Eyj/jjMR/43Ec+yr
	 JY8VXTueMqiNvGbjcczig8FAUoRCjx+pep1FAfVcjktuIH+SczFlZ4cL6oUZS3GFW/r11
	 b7tdX9+gBvslBIiQ17PpWpcP3qNQji2q9T1c8giRKPxz4kmURZO+YZBOGpcpJYqVOcB6A
	 eF/qD/p8TZ6GDKre2Hm1xKgARYCvAP3NCDkdN27bHeiCOKQrXTBNtLz53tF8xmc4Ip9nR
	 LrcBPGm/uRFOGWjvd8O5tAK60Z7CF9nfqqxDkY980ArqG7hZ0SjdSSFye7BtjyQKS3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063333;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IXnPo9C3JMg4uAO/pq16zNytysod7FVBeXKC07WXajs=;
	b=AmpxwkoTBhZImgCjFNyVckzXoeDuT+bHrYbEdf4UOHSLTTw23mWl3Oc2xhiM+SQYl3RU
	 J50O+FsVyMIArPheMMp0GI5zk0c0PHDG9Rx2Uz6OryofzkKzRZmB/l94jvP9BpjPIzDdE
	 kDJkFvhW6b6u5V3SYul3XxycnFA0SyC4zyO9kqeffaYGkuBFE/GGPe6OpfBsrodSzqSfX
	 G9Vrcvg50OisvMaCYpOICGshIMA6cy3ciCq0xv0Weyik4LeJdAuCpC0P553Yj2IrJNlwu
	 lPEOi4IJQLtFe4KtNW89BMcpplxXCsNZkwKxCf4z/QGqOf/UWL+eMkEdQXzvakt3xTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ipgkh46s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E105606A32C;
	Sat,  7 Nov 2026 14:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ipgkh46s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40A641F0089F;
	Sat,  7 Nov 2026 14:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063333;
	bh=IXnPo9C3JMg4uAO/pq16zNytysod7FVBeXKC07WXajs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ipgkh46sE8GVRHr3j5LBz8TCM6Pm/D5eJ3uATNT/YQgyDPSFCSLB6bjVwP9+/Zrxc
	 z2Mry8HlyhKFoBmR/6BGyh/ozmH4tGdtUSzdYDqJLeBnspUaUNZjJFO+fI28N4/y+Q
	 prLI49zPvbjNHdcGywlw0C9b4V5H2mq6pZnQKU9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	sashiko-bot <sashiko-bot@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Jann Horn <jannh@google.com>,
	Jiexun Wang <wangjiexun@tinylab.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 479/869] mm/madvise: reclaim isolated folios if PTE restart fails
Date: Sat,  7 Nov 2026 08:52:41 -0500
Message-ID: <20261107134909.836946595@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gregory Price <gourry@gourry.net>

[ Upstream commit 5445a6359d717354dd76d509b8e693f13403ec61 ]

MADV_PAGEOUT collects isolated folios on a local list before reclaiming
them after the PTE walk.  The reschedule path drops the PTE lock and then
restarts the mapping with pte_offset_map_lock().

A concurrent operation can remove or replace the PTE table while the lock
is dropped, causing pte_offset_map_lock() to return NULL.  Returning
directly in that case bypasses reclaim_pages(), leaving the collected
folios off the LRU with elevated references.

This results in a permanent memory leak.  nr_isolated_anon increases
reliably and does not decrease when the process dies.

Route the failure through the existing cleanup path so any isolated folios
are reclaimed or put back.

Simplest userland pseudo-code reproducer:

p = mmap(PMD_SIZE, ANONYMOUS);
touch_every_page(p, PMD_SIZE);
parallel {
   while (1) madvise(p, PMD_SIZE, MADV_PAGEOUT);
   while (1) {
       madvise(p, PMD_SIZE, MADV_DONTNEED);
       touch_every_page(p, PMD_SIZE);
   }
}

Reproduced in qemu trivially with some explicit widening of the race window.

Link: https://lore.kernel.org/20260912110832.3203902-1-gourry@gourry.net
Fixes: b2f557a21bc8 ("mm/madvise: add cond_resched() in madvise_cold_or_pageout_pte_range()")
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260821150912.183976-1-gourry@gourry.net
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Assisted-by: LLM
Cc: David Hildenbrand <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Jiexun Wang <wangjiexun@tinylab.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/madvise.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index b8c25fea4fab9..6b62e01f31911 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -460,7 +460,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 restart:
 	start_pte = pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	if (!start_pte)
-		return 0;
+		goto out;
 	flush_tlb_batched_pending(mm);
 	arch_enter_lazy_mmu_mode();
 	for (; addr < end; pte += nr, addr += nr * PAGE_SIZE) {
@@ -564,6 +564,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 			folio_deactivate(folio);
 	}
 
+out:
 	if (start_pte) {
 		arch_leave_lazy_mmu_mode();
 		pte_unmap_unlock(start_pte, ptl);
-- 
2.53.0



