Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0F22609FD;
	Wed, 20 May 2026 17:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298532; cv=none; b=Z5uFH6/RDGLL4ezky2yv7A2iZYqgmOMgVwv2u8rVcLpjvZgmY8+1UoQumvuqwaIw+wwokQ8acOERdI8/+HI48o+Lf/kg/n+wHn2cpFSR2UabsLJvsKeBPUOHY7XS1W0eACUuaAPFTfd9Q4tmpjmHtTt2t5JtAXsUH7c78wihamE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298532; c=relaxed/simple;
	bh=9wghZ+C8Z+R80eMPwVGcbMolE3/rYPSU3WqjRW49JAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F79eWuM7C7Yc1PikUlLpf9CE/GTnvokC76S8+2RQWxSTxQE8ZzHFW3XOhnAOCD6+C2zajedLUrMYmurfoXcyrzMoqd4LPPHBOFyiTpiPMzZ5QZsmSb62GuEg9R4nDxeWzYHv8H3rfE83SNd5Y0pHSrRjKKetym/AcPAHDpEH7kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cB9gAzvM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cB9gAzvM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96F4B1F000E9;
	Wed, 20 May 2026 17:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298531;
	bh=gebNyAdEEye7AvWTpZJhZ2NNa9Lsr2jxHv7M2aihF6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cB9gAzvMwOAclsVtzq7qI/IKnGQu3F5I5zjehtjWQgvdGUEp5mEDbz7COg8Vmo2Dv
	 SJf1BpYg7DqI6088uUSAgOLiqd9sOYyQdrpvTWseIOR/bsNwfb09NnsnCH4H7tB5TF
	 wm8Czq2TUfH6QhxQzR+B8BuNidX9qOiWYNJXBrQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian A. Ehrhardt" <lk@c--e.de>,
	David Howells <dhowells@redhat.com>,
	David Gow <davidgow@google.com>,
	Kees Cook <kees@kernel.org>,
	Petr Mladek <pmladek@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 439/957] lib: kunit_iov_iter: fix memory leaks
Date: Wed, 20 May 2026 18:15:22 +0200
Message-ID: <20260520162144.042073535@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian A. Ehrhardt <lk@c--e.de>

[ Upstream commit 0b49c7d0ae697fcecd7377cb7dda220f7cd096ff ]

Use vfree() instead of vunmap() to free the buffer allocated by
iov_kunit_create_buffer() because vunmap() does not honour
VM_MAP_PUT_PAGES.  In order for this to work the page array itself must
not be managed by kunit.

Remove the folio_put() when destroying a folioq.  This is handled by
vfree(), now.

Pointed out by sashiko.dev on a previous iteration of this series.

Tested by running the kunit test 10000 times in a loop.

Link: https://lkml.kernel.org/r/20260326214905.818170-4-lk@c--e.de
Fixes: 2d71340ff1d4 ("iov_iter: Kunit tests for copying to/from an iterator")
Signed-off-by: Christian A. Ehrhardt <lk@c--e.de>
Cc: David Howells <dhowells@redhat.com>
Cc: David Gow <davidgow@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/tests/kunit_iov_iter.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/lib/tests/kunit_iov_iter.c b/lib/tests/kunit_iov_iter.c
index 48342736d0164..43e63bf4c0956 100644
--- a/lib/tests/kunit_iov_iter.c
+++ b/lib/tests/kunit_iov_iter.c
@@ -42,7 +42,7 @@ static inline u8 pattern(unsigned long x)
 
 static void iov_kunit_unmap(void *data)
 {
-	vunmap(data);
+	vfree(data);
 }
 
 static void *__init iov_kunit_create_buffer(struct kunit *test,
@@ -53,17 +53,22 @@ static void *__init iov_kunit_create_buffer(struct kunit *test,
 	unsigned long got;
 	void *buffer;
 
-	pages = kunit_kcalloc(test, npages, sizeof(struct page *), GFP_KERNEL);
-        KUNIT_ASSERT_NOT_ERR_OR_NULL(test, pages);
+	pages = kzalloc_objs(struct page *, npages, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, pages);
 	*ppages = pages;
 
 	got = alloc_pages_bulk(GFP_KERNEL, npages, pages);
 	if (got != npages) {
 		release_pages(pages, got);
+		kvfree(pages);
 		KUNIT_ASSERT_EQ(test, got, npages);
 	}
 
 	buffer = vmap(pages, npages, VM_MAP | VM_MAP_PUT_PAGES, PAGE_KERNEL);
+	if (buffer == NULL) {
+		release_pages(pages, got);
+		kvfree(pages);
+	}
         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, buffer);
 
 	kunit_add_action_or_reset(test, iov_kunit_unmap, buffer);
@@ -369,9 +374,6 @@ static void iov_kunit_destroy_folioq(void *data)
 
 	for (folioq = data; folioq; folioq = next) {
 		next = folioq->next;
-		for (int i = 0; i < folioq_nr_slots(folioq); i++)
-			if (folioq_folio(folioq, i))
-				folio_put(folioq_folio(folioq, i));
 		kfree(folioq);
 	}
 }
-- 
2.53.0



