Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3DED35F8B2;
	Wed,  3 Dec 2025 16:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780149; cv=none; b=eKP1HjdSOMHyDIig7BF8RYzlfKBL4dTAA8Hc8YtgxLAI/ZINNWXgQJYg5LHp9wlBuPCJCf6eT13gb4GDRfWf+FFYf0f+grT1qE7oW3EE9wQmeV1oTB7TrlBvwVbZfSrYoUqqNK7thenMcXrvNN3RKCZFd4cwF9vUstmWMuCRylY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780149; c=relaxed/simple;
	bh=2n5I/mDYhuQrkgpa/VyrtEP923Dgtf8bpJqZeY3UDYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kkyf3UkAT5iWtL6WMJu2MRRNFv78V5PlmxWz3PLmfI5KLya6WTW85ggh3fHSsGA53CJgHe9r1tHQhGEL/kYzT8WngulnGeKivhWlDzHhCfFpS5a/ZLvBxVpFTVoOh2xbhfVZTO4y8egHuiKh5186ciJ0xunlbqtmgV3ohhxTWCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z/zSEd2C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z/zSEd2C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F92EC4CEF5;
	Wed,  3 Dec 2025 16:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780148;
	bh=2n5I/mDYhuQrkgpa/VyrtEP923Dgtf8bpJqZeY3UDYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z/zSEd2CnPyaCiZEPtBtKbf8ae+o4zVB1OucPdFp08hwEF/P6aJVoUlHLWGLQ2dKN
	 4rhtmrJhzXpEU5SsTccWGElpxWbWYDtI1fyeisVyZIn+rokoH141NgtNkN0GojyDiv
	 J3st1qDqX1XBEHAdl9bcQ3MWId5rjErJNpbk4dOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lance Yang <lance.yang@linux.dev>,
	Google Big Sleep <big-sleep-vuln-reports@google.com>,
	David Hildenbrand <david@redhat.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 471/568] mm/secretmem: fix use-after-free race in fault handler
Date: Wed,  3 Dec 2025 16:27:53 +0100
Message-ID: <20251203152457.950870433@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lance Yang <lance.yang@linux.dev>

[ Upstream commit 6f86d0534fddfbd08687fa0f01479d4226bc3c3d ]

When a page fault occurs in a secret memory file created with
`memfd_secret(2)`, the kernel will allocate a new page for it, mark the
underlying page as not-present in the direct map, and add it to the file
mapping.

If two tasks cause a fault in the same page concurrently, both could end
up allocating a page and removing the page from the direct map, but only
one would succeed in adding the page to the file mapping.  The task that
failed undoes the effects of its attempt by (a) freeing the page again
and (b) putting the page back into the direct map.  However, by doing
these two operations in this order, the page becomes available to the
allocator again before it is placed back in the direct mapping.

If another task attempts to allocate the page between (a) and (b), and the
kernel tries to access it via the direct map, it would result in a
supervisor not-present page fault.

Fix the ordering to restore the direct map before the page is freed.

Link: https://lkml.kernel.org/r/20251031120955.92116-1-lance.yang@linux.dev
Fixes: 1507f51255c9 ("mm: introduce memfd_secret system call to create "secret" memory areas")
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Reported-by: Google Big Sleep <big-sleep-vuln-reports@google.com>
Closes: https://lore.kernel.org/linux-mm/CAEXGt5QeDpiHTu3K9tvjUTPqo+d-=wuCNYPa+6sWKrdQJ-ATdg@mail.gmail.com/
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[rppt: replaced folio with page in the patch and in the changelog]
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/secretmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/secretmem.c b/mm/secretmem.c
index 18954eae995fc..b570a6e25b6be 100644
--- a/mm/secretmem.c
+++ b/mm/secretmem.c
@@ -82,13 +82,13 @@ static vm_fault_t secretmem_fault(struct vm_fault *vmf)
 		__SetPageUptodate(page);
 		err = add_to_page_cache_lru(page, mapping, offset, gfp);
 		if (unlikely(err)) {
-			put_page(page);
 			/*
 			 * If a split of large page was required, it
 			 * already happened when we marked the page invalid
 			 * which guarantees that this call won't fail
 			 */
 			set_direct_map_default_noflush(page);
+			put_page(page);
 			if (err == -EEXIST)
 				goto retry;
 
-- 
2.51.0



