Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064657;
	b=WvHwP2Gnp0e07LkahfTzDRbLhdbIh3icxqKHx6uPYlrRlU+SSo5TrmmUC0eQwReq56EZ
	 KmZkZMdqd4Rp+NvabT1uFTqY2la7APLtpSz9BfwKGmEsHpvMuDzJCQVtpvNZAjJnoKBFP
	 3kAAklKkLdSvRFkKQpBRRFfzCmpDth026sHgBNfl216N55u3fbwy9qJAkHu0VCyiFdADP
	 tUKs9SO8aZzCL2zRsvNZHw5+oADHRJd5ZRQaGtGIG7xH1O2nNozEnry66kcGoFZJwZJv5
	 muDRyPWA7rpyPKaYqio8QywWrytBRjLczXcSOH+vHKL1E0HoLdPNFg2Ch9dXNemLoqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064657;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=POjDYRgzs3qvOSAVytPzJrkdlY5mhmrC0ppB2B+hCxs=;
	b=XPs7St85o7PzylIDhqB/afNTggL6TSPp2c8mHQ65Qwgt4gi4EcR6CDWihRWbkEA70+0V
	 7gxGvIKxUHnxA6p6LaGI1SN7fsKFiQyIl2GtQY22auSdHrCYepf0JiDPhoDduEEsfGOML
	 Yq/DeGtHFIEsQ1ExffbuWhFHKwlhhFZ4RJnZWE2gIY3wKt1RvJFetxQFAJ6r9CJQ7kxsf
	 F9ns9TrN3IAfAHRlr0AqrWEdek2t2hXnEtsKbpTK3npLJlbxYmwFrUy/irF+PpCTr8cL2
	 jOakq1msOZYH61zJgRmd+5bmQz9f9wcxvgoA1sTS2g2+iPpuNGo6Yun55KzLn4CAMgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LfkAeh5n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06271606CE40;
	Sat,  7 Nov 2026 15:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LfkAeh5n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9395D1F0089F;
	Sat,  7 Nov 2026 15:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064656;
	bh=POjDYRgzs3qvOSAVytPzJrkdlY5mhmrC0ppB2B+hCxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LfkAeh5n1I1ObpYlZsn56jESj9u3MqNWsA3d5Of37Clz+PfWOiv/amJlbYWgojdgi
	 r7M1n9KobudVKuXUXuGWAePAEelcrao351KNCZMd5jC7wnufWoFVIVVcTK4+P7NoI0
	 zrU+uSODNdlUAeAymLuDGAfth73y9JxONH9Luwvs=
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
Subject: [PATCH 7.3 0657/1257] mm/madvise: reclaim isolated folios if PTE restart fails
Date: Sat,  7 Nov 2026 08:49:13 -0500
Message-ID: <20261107134957.406138640@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 95287c495e462..47e40d240c7e6 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -461,7 +461,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 restart:
 	start_pte = pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	if (!start_pte)
-		return 0;
+		goto out;
 	flush_tlb_batched_pending(mm);
 	lazy_mmu_mode_enable();
 	for (; addr < end; pte += nr, addr += nr * PAGE_SIZE) {
@@ -565,6 +565,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 			folio_deactivate(folio);
 	}
 
+out:
 	if (start_pte) {
 		lazy_mmu_mode_disable();
 		pte_unmap_unlock(start_pte, ptl);
-- 
2.53.0



