Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB95B3E49EB;
	Wed, 30 Sep 2026 19:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796313; cv=none; b=EK60DF0yaL1596MKhvDreaczNIbZlvywpVPrreHd/kdNDFsz8gJnj6Cw+MDq2bPlDyCiLIDfy3h16GWcMcYAtWTPTu04YqpCfxOrcHWHQnIFPC25Utyu8dMOgaNhb1U92mfK7ghljEQL9oQIn1cUEapVenpBJizz+ISeuldsu78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796313; c=relaxed/simple;
	bh=OX2X2CyYQHFPn0rnY11RQFrwyygiNR7j9Dw3qdN8NTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fspb9xrJsskhoma64M6wzL1G9OTna07bSSd96rSrzyADhhI+yLsFziz3jWPyLSB5q51lLJQMr8ojg9G1n29Nr9gCVFlxKo7N0j3w75W0hMcL3NFCBMDqq7bk5rvC7SYZlMcKU5H8cgLe8fBV1DVq9avQ8wnb14zWDcD9pJFXASY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CEdOElMp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CEdOElMp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 020BC1F000FF;
	Wed, 30 Sep 2026 19:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796312;
	bh=urxaCOB0gi6ed6JKb3mvdWxScyPtmvUZ/yysZ5CwQP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CEdOElMpS6GWBXbvkNFKI6/u+N5Xvbr5F3j7qgVB9WkQw7CjiC7zCiRP5DMz7gGRF
	 rzYoTNisOBXoOQuw+yBixAElPsFcN146PP00YTq0nfxlhhaJRO5LJ9apW2LrbLfld5
	 y91yuRGLcW8PexRUEomVbCaJvTuup1vtw+wOYeho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shakeel Butt <shakeel.butt@linux.dev>,
	syzbot+cd2073ee6d958a8d0fcd@syzkaller.appspotmail.com,
	Hugh Dickins <hughd@google.com>,
	Jann Horn <jannh@google.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 0870/1193] mm/mlock: use the IRQ-safe accessor for NR_MLOCK in __munlock_folio()
Date: Wed, 30 Sep 2026 17:25:54 +0200
Message-ID: <20260930152453.567889096@linuxfoundation.org>
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

From: Shakeel Butt <shakeel.butt@linux.dev>

commit e14a3454806468b086fe2e4ca2e1bff95b528531 upstream.

NR_MLOCK is updated from interrupt context.  __free_pages_prepare() clears
a stray PG_mlocked and adjusts NR_MLOCK, and a folio can reach it with the
flag still set from a bio completion handler:

  __free_pages_ok+0x6af/0x7a0
  <IRQ>
  __bio_release_pages+0xde/0x260
  __iomap_dio_bio_end_io+0x16e/0x1a0
  blk_update_request+0x14b/0x3d0
  blk_mq_end_request+0x18/0x30
  blk_done_softirq+0x49/0x60

The folio gets there like this.  A MAP_SHARED file mapping is mlocked, so
its page cache folios carry PG_mlocked, and an O_DIRECT write sourced from
that mapping GUP-pins those same folios.  munlock() then runs
mlock_vma_pages_range(), which clears VM_LOCKED before walking the page
tables to munlock each folio.  A concurrent hole punch reaches the folio
through the rmap (i_mmap_rwsem, not mmap_lock) and can land inside that
window: __folio_remove_rmap() -> munlock_vma_folio() sees VM_LOCKED
already clear, so it neither queues the folio on the mlock batch nor takes
a reference, and the pte it clears makes the pending mlock_pte_range()
walk skip the folio at its !pte_present() check.  filemap_remove_folio()
then drops the page cache reference, leaving the bio's pin as the last
one, released from the completion handler above.

So __zone_stat_mod_folio() here needs interrupts disabled, not merely
preemption, and __munlock_folio() has a path where they are not: when the
folio has already been taken off the LRU by somebody else the function
jumps straight to the counter update without taking the lruvec lock.  The
read-modify-write of the per-CPU NR_MLOCK diff can then be interrupted by
the softirq above, and one of the two decrements is lost, leaving Mlocked
in /proc/meminfo permanently overstated.

Use zone_stat_mod_folio().  mod_zone_state()'s this_cpu_try_cmpxchg() is
atomic against a same-CPU interrupt and retries, and on the path where the
lruvec lock is held its cost is negligible next to the lock itself.

The UNEVICTABLE_PG* events are deliberately left on the __ accessors: they
occupy different vm_event_states slots from the UNEVICTABLE_PGCLEARED that
__free_pages_prepare() bumps, and nothing updates those two from interrupt
context.

Link: https://lore.kernel.org/20260901180109.3797944-1-shakeel.butt@linux.dev
Fixes: 2fbb0c10d1e8 ("mm/munlock: mlock_page() munlock_page() batch by pagevec")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reported-by: syzbot+cd2073ee6d958a8d0fcd@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-mm/6a931c5a.08e933ee.dbf97.0093.GAE@google.com/
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mlock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -141,7 +141,7 @@ static struct lruvec *__munlock_folio(st
 
 munlock:
 	if (folio_test_clear_mlocked(folio)) {
-		__zone_stat_mod_folio(folio, NR_MLOCK, -nr_pages);
+		zone_stat_mod_folio(folio, NR_MLOCK, -nr_pages);
 		if (isolated || !folio_test_unevictable(folio))
 			__count_vm_events(UNEVICTABLE_PGMUNLOCKED, nr_pages);
 		else


