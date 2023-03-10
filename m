Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03EEF8821
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 15:04:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B09BC4339C;
	Fri, 10 Mar 2023 15:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678460649;
	bh=DxcOGYs9iOzIDsLffqTUmR2vENM+1lTPQGZ/arYXpzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pYbXSpRLXRzwc9Is+0Gt99a9TRslq+mCwifk1EFYyuP+t1orzHbrWjJz2WGHl/jeZ
	 vQf8EDx5oQVx9ChCQOplbpI3jsKFMM/BQ1y7mz39pnsco/bgpTaaMV1/1NDytW8j5T
	 nL2WO5OZTA1RRXwjKEKpgaorSNo/GkPrBZKXdtaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yin Fengwei <fengwei.yin@intel.com>,
	Nathan Chancellor <nathan@kernel.org>,
	David Rientjes <rientjes@google.com>,
	"Huang, Ying" <ying.huang@intel.com>,
	Feng Tang <feng.tang@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Rik van Riel <riel@surriel.com>,
	Xing Zhengjun <zhengjun.xing@linux.intel.com>,
	Yang Shi <shy828301@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.10 405/529] mm/thp: check and bail out if page in deferred queue already
Date: Fri, 10 Mar 2023 14:39:08 +0100
Message-Id: <20230310133823.752936068@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yin Fengwei <fengwei.yin@intel.com>

commit 81e506bec9be1eceaf5a2c654e28ba5176ef48d8 upstream.

Kernel build regression with LLVM was reported here:
https://lore.kernel.org/all/Y1GCYXGtEVZbcv%2F5@dev-arch.thelio-3990X/ with
commit f35b5d7d676e ("mm: align larger anonymous mappings on THP
boundaries").  And the commit f35b5d7d676e was reverted.

It turned out the regression is related with madvise(MADV_DONTNEED)
was used by ld.lld. But with none PMD_SIZE aligned parameter len.
trace-bpfcc captured:
531607  531732  ld.lld          do_madvise.part.0 start: 0x7feca9000000, len: 0x7fb000, behavior: 0x4
531607  531793  ld.lld          do_madvise.part.0 start: 0x7fec86a00000, len: 0x7fb000, behavior: 0x4

If the underneath physical page is THP, the madvise(MADV_DONTNEED) can
trigger split_queue_lock contention raised significantly. perf showed
following data:
    14.85%     0.00%  ld.lld           [kernel.kallsyms]           [k]
       entry_SYSCALL_64_after_hwframe
           11.52%
                entry_SYSCALL_64_after_hwframe
                do_syscall_64
                __x64_sys_madvise
                do_madvise.part.0
                zap_page_range
                unmap_single_vma
                unmap_page_range
                page_remove_rmap
                deferred_split_huge_page
                __lock_text_start
                native_queued_spin_lock_slowpath

If THP can't be removed from rmap as whole THP, partial THP will be
removed from rmap by removing sub-pages from rmap.  Even the THP head page
is added to deferred queue already, the split_queue_lock will be acquired
and check whether the THP head page is in the queue already.  Thus, the
contention of split_queue_lock is raised.

Before acquire split_queue_lock, check and bail out early if the THP
head page is in the queue already. The checking without holding
split_queue_lock could race with deferred_split_scan, but it doesn't
impact the correctness here.

Test result of building kernel with ld.lld:
commit 7b5a0b664ebe (parent commit of f35b5d7d676e):
time -f "\t%E real,\t%U user,\t%S sys" make LD=ld.lld -skj96 allmodconfig all
        6:07.99 real,   26367.77 user,  5063.35 sys

commit f35b5d7d676e:
time -f "\t%E real,\t%U user,\t%S sys" make LD=ld.lld -skj96 allmodconfig all
        7:22.15 real,   26235.03 user,  12504.55 sys

commit f35b5d7d676e with the fixing patch:
time -f "\t%E real,\t%U user,\t%S sys" make LD=ld.lld -skj96 allmodconfig all
        6:08.49 real,   26520.15 user,  5047.91 sys

Link: https://lkml.kernel.org/r/20221223135207.2275317-1-fengwei.yin@intel.com
Signed-off-by: Yin Fengwei <fengwei.yin@intel.com>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Xing Zhengjun <zhengjun.xing@linux.intel.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/huge_memory.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2803,6 +2803,9 @@ void deferred_split_huge_page(struct pag
 	if (PageSwapCache(page))
 		return;
 
+	if (!list_empty(page_deferred_list(page)))
+		return;
+
 	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
 	if (list_empty(page_deferred_list(page))) {
 		count_vm_event(THP_DEFERRED_SPLIT_PAGE);


