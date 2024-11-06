Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B05A1DF974;
	Wed,  6 Nov 2024 12:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896451; cv=none; b=cHs/Ik4ORO9NLVl2ZLM+bO60s0h7TC9X6F+eHhtxiFx19tvmcPmKIa/Lqt092SjKrHUU6UUwpoIAwLIZ+6nANwkx/R/ArjY58LPr9pmE9vLMB9R037DNGC2H+l7ulTLlOpzi26f5dbfF41dTCEaC0LZztPQqlaDgpbEoS53c06c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896451; c=relaxed/simple;
	bh=IUUj8nvgJkWKuvGTlHJt2Fv/8RsLHHZuSgAInAnFVos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TgoUfM/UaVTIGISpECewfSCc9/7Jgo1LCYdVKWDKQh2zQ63pmYZT0jSlOnLXivOU2kt228QUCiObtL6xt4tu1jgTAn6sMB6irRMGURMQBm0+pdfWWKuVZh8g4EbZ0kaJFwEGbgbkR1/8Nm3XOtY9f6UX2wUoxXC3xfjC6i2Wodc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C9lLw7e5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C9lLw7e5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8205BC4CECD;
	Wed,  6 Nov 2024 12:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896450;
	bh=IUUj8nvgJkWKuvGTlHJt2Fv/8RsLHHZuSgAInAnFVos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C9lLw7e5eG7QBAcmmJvwK+CviLPiUmAXbfKJzc45QWIPYVl4bwqvjtE7y36sQPbgO
	 ti2i7yu3BmZ41HxoeQTELXlXKxE6lJvG1b7H2IwA6x4HiLzOQHUNo0W9Yosa252Yne
	 AztlBrk1yOC0tBdhQUoL0pP0JVL5Kk5o4eUqBlyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiguo Jiang <justinjiang@vivo.com>,
	Barry Song <baohua@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 207/245] mm: shrink skip folio mapped by an exiting process
Date: Wed,  6 Nov 2024 13:04:20 +0100
Message-ID: <20241106120324.345277354@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhiguo Jiang <justinjiang@vivo.com>

[ Upstream commit c495b97624d0c059b0403e26dadb166d69918409 ]

The releasing process of the non-shared anonymous folio mapped solely by
an exiting process may go through two flows: 1) the anonymous folio is
firstly is swaped-out into swapspace and transformed into a swp_entry in
shrink_folio_list; 2) then the swp_entry is released in the process
exiting flow.  This will result in the high cpu load of releasing a
non-shared anonymous folio mapped solely by an exiting process.

When the low system memory and the exiting process exist at the same time,
it will be likely to happen, because the non-shared anonymous folio mapped
solely by an exiting process may be reclaimed by shrink_folio_list.

This patch is that shrink skips the non-shared anonymous folio solely
mapped by an exting process and this folio is only released directly in
the process exiting flow, which will save swap-out time and alleviate the
load of the process exiting.

Barry provided some effectiveness testing in [1].  "I observed that
this patch effectively skipped 6114 folios (either 4KB or 64KB mTHP),
potentially reducing the swap-out by up to 92MB (97,300,480 bytes)
during the process exit.  The working set size is 256MB."

Link: https://lkml.kernel.org/r/20240710083641.546-1-justinjiang@vivo.com
Link: https://lore.kernel.org/linux-mm/20240710033212.36497-1-21cnbao@gmail.com/ [1]
Signed-off-by: Zhiguo Jiang <justinjiang@vivo.com>
Acked-by: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 1d4832becdc2 ("mm: multi-gen LRU: use {ptep,pmdp}_clear_young_notify()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/rmap.c   | 15 +++++++++++++++
 mm/vmscan.c |  7 ++++++-
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 2490e727e2dcb..2630bde38640c 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -75,6 +75,7 @@
 #include <linux/memremap.h>
 #include <linux/userfaultfd_k.h>
 #include <linux/mm_inline.h>
+#include <linux/oom.h>
 
 #include <asm/tlbflush.h>
 
@@ -870,6 +871,20 @@ static bool folio_referenced_one(struct folio *folio,
 			continue;
 		}
 
+		/*
+		 * Skip the non-shared swapbacked folio mapped solely by
+		 * the exiting or OOM-reaped process. This avoids redundant
+		 * swap-out followed by an immediate unmap.
+		 */
+		if ((!atomic_read(&vma->vm_mm->mm_users) ||
+		    check_stable_address_space(vma->vm_mm)) &&
+		    folio_test_anon(folio) && folio_test_swapbacked(folio) &&
+		    !folio_likely_mapped_shared(folio)) {
+			pra->referenced = -1;
+			page_vma_mapped_walk_done(&pvmw);
+			return false;
+		}
+
 		if (pvmw.pte) {
 			if (lru_gen_enabled() &&
 			    pte_young(ptep_get(pvmw.pte))) {
diff --git a/mm/vmscan.c b/mm/vmscan.c
index c6d9f5f4f6002..a2ad17092abdf 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -863,7 +863,12 @@ static enum folio_references folio_check_references(struct folio *folio,
 	if (vm_flags & VM_LOCKED)
 		return FOLIOREF_ACTIVATE;
 
-	/* rmap lock contention: rotate */
+	/*
+	 * There are two cases to consider.
+	 * 1) Rmap lock contention: rotate.
+	 * 2) Skip the non-shared swapbacked folio mapped solely by
+	 *    the exiting or OOM-reaped process.
+	 */
 	if (referenced_ptes == -1)
 		return FOLIOREF_KEEP;
 
-- 
2.43.0



