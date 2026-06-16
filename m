Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9ED53C09E1;
	Tue, 16 Jun 2026 18:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632992; cv=none; b=DABQNpj8hZsSDS53+miyxyDiSEO6wv7ZWpmPuTaPCgbP8NRdjAMPMrN2wwYTV76QrHKIpn4h8liz/tGTj70yxbrso6JyFfkdc4aNNJ85VjH7DEsbadXSkCXL0Et3Ta1SDbF1WhuHISjMSCbovcu/p85+YLbu794BJmkUY5Dq5yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632992; c=relaxed/simple;
	bh=/lgJgjUzFXbymbFrN7AQO7jg3gekc2+sv78UQ1tDjjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eOwnR3LIGKbzOkroY0wPBYRHyQDzHM/bBmftffKvXIqEsJ13RFewZloATyZqKbVnef5K4pA4g3frW6QFaZ1DAcwq29voIYdOGcp2L7k2tO+DzI4o6igcyKj7wg7tyu4XZK9q2AR22o5k6Rt0LnS13uFX/T+1bmSm6tyWOGiI1+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2jkSnd3y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2jkSnd3y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5B101F000E9;
	Tue, 16 Jun 2026 18:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632991;
	bh=bz0V/ZxlDqh6KYo0vWNe7uwv9nHGkBGhX/IjgQxTfzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2jkSnd3yiq49UiD27YNLarhe1D2JZC1rz5C+asVq2/U642cTdiClXASKD2/92ags1
	 WqoqBnF/BhP0kxIm4oEfCUP/fFsm6ETcOleZPYTPd4/ucFXCIIlSBEqTvleO/jMLZe
	 Ir1Bll57rDYt6/jaU2kDBaOT2Md3GkS7d6u6rHKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 483/522] mm/migrate: dont call folio_putback_active_hugetlb() on dst hugetlb folio
Date: Tue, 16 Jun 2026 20:30:30 +0530
Message-ID: <20260616145148.417252104@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

From: David Hildenbrand <david@redhat.com>

[ Upstream commit ba23f58de896842028b4b33b95530f08288396fe ]

We replaced a simple put_page() by a putback_active_hugepage() call in
commit 3aaa76e125c1 ("mm: migrate: hugetlb: putback destination hugepage
to active list"), to set the "active" flag on the dst hugetlb folio.

Nowadays, we decoupled the "active" list from the flag, by calling the
flag "migratable".

Calling "putback" on something that wasn't allocated is weird and not
future proof, especially if we might reach that path when migration failed
and we just want to free the freshly allocated hugetlb folio.

Let's simply handle the migratable flag and the active list flag in
move_hugetlb_state(), where we know that allocation succeeded and already
handle the temporary flag; use a simple folio_put() to return our
reference.

Link: https://lkml.kernel.org/r/20250113131611.2554758-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 3c2d42b8ee34 ("mm/memory-failure: fix hugetlb_lock AA deadlock in get_huge_page_for_hwpoison")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |   10 ++++++++++
 mm/migrate.c |    8 ++++----
 2 files changed, 14 insertions(+), 4 deletions(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -7555,6 +7555,16 @@ void move_hugetlb_state(struct page *old
 		}
 		spin_unlock_irq(&hugetlb_lock);
 	}
+
+	/*
+	 * Our old page is isolated and has "migratable" cleared until it
+	 * is putback. As migration succeeded, set the new page "migratable"
+	 * and add it to the active list.
+	 */
+	spin_lock_irq(&hugetlb_lock);
+	SetHPageMigratable(newpage);
+	list_move_tail(&newpage->lru, &(page_hstate(newpage))->hugepage_activelist);
+	spin_unlock_irq(&hugetlb_lock);
 }
 
 /*
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1460,14 +1460,14 @@ out:
 		list_move_tail(&src->lru, ret);
 
 	/*
-	 * If migration was not successful and there's a freeing callback, use
-	 * it.  Otherwise, put_page() will drop the reference grabbed during
-	 * isolation.
+	 * If migration was not successful and there's a freeing callback,
+	 * return the folio to that special allocator. Otherwise, simply drop
+	 * our additional reference.
 	 */
 	if (put_new_page)
 		put_new_page(new_hpage, private);
 	else
-		putback_active_hugepage(new_hpage);
+		folio_put(dst);
 
 	return rc;
 }


