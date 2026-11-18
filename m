Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022672;
	b=Ol+1GaQ2hmpB2x8+KJ2KWv+Q7KGnsKvbZ6Zk3PWNC1iFKdZQlarea9mo4e7vm1oUbydZ
	 DvOOVn7RLQFkbDPTvWBkS2sdT6LWcdWeoHd/GFxOSoQVfc/HU1zye2U/CGEyliGL6+a1Q
	 e3hcxZyEbzKlQFdf/1DMrWcPYiCp28KRhXesO2R3jXFUN6J7C4/XqCp7mGzSzKQOBR8zS
	 gU352iFkDT2VPFLQc+AzcbSG1WYB0ySHky1eHhruoxw0XJcx7uQkmytJMd2cgYPCXynWJ
	 gV3JJHRB+JH7lwJGKkdVBAazIp7DOLRfjT6PFQ7SkgD9255LOvWR0TGskO4V7tCP4qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022672;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aecaVdw7f0cEAn9PYDoaXkRkQ5EvcE4wucXkUSCmSig=;
	b=jQvK0zv1AzFAnOG6b9nTrzCYNm8dOT8D1OBTw+4lht+CpwdqTAgPThhls4q1aLatwjKs
	 KVZOgFXk+cPufdBKdSVAa1tyT7gNxB8aWsGX6k/lo4ihKVq5ZZ2AH5289GIj4zSv8Ssy7
	 bp65A9uLck58avoV1P/3MUBMt6bfJOLKjlqSapv1EFk3Vry5pTWiisje4nM7JRnzXJ7C9
	 gxmrFzXSgmocQ0S8gojZDvjNC+/mqKpy5ZuqYj/sfSLIajXPISOaOXJrrxseTFklto0QM
	 JZLMnRks0v8YlDiEo8GFS2zqANcUrkcQiZU2itLxX1q3xGJ9b5OaXNHV3Nl6pzeMIEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C+aGj24B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482EE606A331;
	Wed, 18 Nov 2026 17:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C+aGj24B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95DF11F000C4;
	Wed, 18 Nov 2026 17:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022672;
	bh=aecaVdw7f0cEAn9PYDoaXkRkQ5EvcE4wucXkUSCmSig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C+aGj24BdzDelB19NqaDqIwV1dEhr/gfXI6+dJ3geS4tNmQ4W/2xGar5g6MHRU3wI
	 z9rLVr/kkf/2P2xTODU8jTpSDNCn5+DlY6hjHYlEYkN612hhmBYCbQBd4v4kPO++BM
	 a+h/V9OwjGXbM5UhkLZnx8Xnf/6+kisLLkWNmmRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com,
	Lance Yang <lance.yang@linux.dev>,
	Pedro Falcato <pfalcato@suse.de>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0055/2151] khugepaged: fix readahead lock inversion in collapse_file()
Date: Wed, 18 Nov 2026 15:29:50 +0100
Message-ID: <20261118150123.745982602@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Lance Yang <lance.yang@linux.dev>

[ Upstream commit eadce52a9ef657d561b3e76c9b5f178bd99735f5 ]

collapse_file() can call page_cache_sync_readahead() while still holding
source folios locked. If truncate holds mapping->invalidate_lock
exclusively and waits for one of those folios, readahead waits for
invalidate_lock and neither side can make progress.

We need to release those folio locks before starting readahead. On a page
cache miss, roll back first, populate the collapse range, and retry once.
Doing readahead after rollback avoids an extra pass when all folios are
already present. If another miss occurs on retry, give up rather than keep
retrying while truncate or reclaim removes folios.

Keep page_cache_sync_readahead() and wait for read I/O with
filemap_lock_folio(), releasing each folio before moving to the next. The
existing uptodate check during collapse still handles read errors.

Shmem uses shmem_get_folio() for swapin and fallocated folios without
taking mapping->invalidate_lock, so it is unaffected.

Reported-by: syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=16bf7cd0ebeb1de93aa5
Fixes: 730633f0b7f9 ("mm: Protect operations adding pages to page cache with invalidate_lock")
Cc: stable@vger.kernel.org
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Link: https://patch.msgid.link/20261026152013.10511-1-lance.yang@linux.dev
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/khugepaged.c | 49 +++++++++++++++++++++++++++++++++++++------------
 1 file changed, 37 insertions(+), 12 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 6bff1096de7d8..6fa4d9b7e0129 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1868,6 +1868,8 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 	XA_STATE_ORDER(xas, &mapping->i_pages, start, HPAGE_PMD_ORDER);
 	int nr_none = 0, result = SCAN_SUCCEED;
 	bool is_shmem = shmem_file(file);
+	bool do_readahead = false;
+	bool readahead_done = false;
 
 	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
 	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
@@ -1879,6 +1881,10 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 
 	mapping_set_update(&xas, mapping);
 
+retry:
+	result = SCAN_SUCCEED;
+	do_readahead = false;
+	xas_set_order(&xas, start, HPAGE_PMD_ORDER);
 	__folio_set_locked(new_folio);
 	if (is_shmem)
 		__folio_set_swapbacked(new_folio);
@@ -1943,17 +1949,9 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 			}
 		} else {	/* !is_shmem */
 			if (!folio || xa_is_value(folio)) {
-				xas_unlock_irq(&xas);
-				page_cache_sync_readahead(mapping, &file->f_ra,
-							  file, index,
-							  end - index);
-				/* drain lru cache to help folio_isolate_lru() */
-				lru_add_drain();
-				folio = filemap_lock_folio(mapping, index);
-				if (IS_ERR(folio)) {
-					result = SCAN_FAIL;
-					goto xa_unlocked;
-				}
+				do_readahead = !readahead_done;
+				result = SCAN_FAIL;
+				goto xa_locked;
 			} else if (folio_test_dirty(folio)) {
 				/*
 				 * khugepaged only works on read-only fd,
@@ -2095,7 +2093,10 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 		 * in do_dentry_open() truncating the page cache. This is
 		 * particularly important if there are dirty folios in transit.
 		 */
-		filemap_invalidate_lock_shared(mapping);
+		if (!filemap_invalidate_trylock_shared(mapping)) {
+			result = SCAN_FAIL;
+			goto rollback;
+		}
 		filemap_nr_thps_inc(mapping);
 		/*
 		 * Paired with the fence in do_dentry_open() -> get_write_access()
@@ -2296,6 +2297,30 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 	new_folio->mapping = NULL;
 
 	folio_unlock(new_folio);
+
+	/* Readahead may take invalidate_lock; source folios are unlocked. */
+	if (do_readahead) {
+		for (index = start; index < end;) {
+			folio = filemap_lock_folio(mapping, index);
+			if (IS_ERR(folio)) {
+				page_cache_sync_readahead(mapping, &file->f_ra,
+							  file, index, end - index);
+				folio = filemap_lock_folio(mapping, index);
+				if (IS_ERR(folio)) {
+					result = SCAN_FAIL;
+					goto out_put;
+				}
+			}
+			index = folio_next_index(folio);
+			folio_unlock(folio);
+			folio_put(folio);
+		}
+		/* Drain the local LRU batch before retrying isolation. */
+		lru_add_drain();
+		readahead_done = true;
+		goto retry;
+	}
+out_put:
 	folio_put(new_folio);
 out:
 	VM_BUG_ON(!list_empty(&pagelist));
-- 
2.53.0



