Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7915B31F9BE;
	Wed, 20 May 2026 16:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295928; cv=none; b=Rq6OlP2dewdX20GqMQvykPvfHfDMqGwq5qho0lSwO22ke+u1zOxyExSLMG6xHyHxU0IV7ZLLj9JwRPL6ZhKcSFBu9BFArt25eBZ3wGifQwjwX03OL19LURgnpn02HRpVJ1f0DkDEwCV8sIay+DFgvm3eucjIzEYcjka16fqtErU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295928; c=relaxed/simple;
	bh=5yYE/syqt5ZKByl1oR8GghVHxyq4hpuG6Jj/xLje4EI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mAQXkwuRDEr+R5tnz0ZrDI1Bvjt0wNjNsKPx1gFd7L8W1Feqy/i6Dfxv+jJlYoqjJEO7F/vRZprdLh6BREcisM6HalcYzNLk6iKEQ4zWVZ6IaQxt3BF2RxQXvEVTJ41c94povXaVBUsIH+ZxsAw3NjPskNt2ERpDpTbnM7fiUFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fa9A/VTg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fa9A/VTg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CD0A1F000E9;
	Wed, 20 May 2026 16:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295926;
	bh=P7FOTMBBMoxFz5pjq7p9z2fP5zAaxcgVm34WQmn6Zng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fa9A/VTgwQ6ehCaqES9JVESQXBAhKdDCUBoB4f6qv+9cRrbRXEdYw/L8xDe4E+8Wk
	 ibLeoYKbRvavJXou8F+olwRHLRICzOKOAFNCwkTvmDqxqeOn9EvwKVCw/7Uf0D96cL
	 jjPK5vKfXR/VlhDdWQ55aCbKuGp7vdWgVCQQGxBQ=
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
Subject: [PATCH 7.0 0565/1146] lib: kunit_iov_iter: fix memory leaks
Date: Wed, 20 May 2026 18:13:35 +0200
Message-ID: <20260520162200.970834770@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index bb847e5010eb2..d16449bdb8334 100644
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



