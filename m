Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BBC0381D6;
	Fri, 24 Nov 2023 18:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EQJtHyb8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AB66C433C7;
	Fri, 24 Nov 2023 18:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849680;
	bh=EIkD6F3UtHqT1RPzi0h3iN2rz8V76WUXxk2diPWwh/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EQJtHyb8NZgVIQlqEZrlEEf2TF0AX1VGLbk+5uSqgI61KXbQkDwlN4MNjlF5tVpew
	 NGJjrqeMlzxTQoGMo9Hf7+ehvO7zEBScGrryISvVXfoibwCGaM7ymXcZoMy73yjnpc
	 ZoZbsL0VUVxL0ggnnC3ZOJmi85u3CtowrLOz6Gx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 6.6 278/530] dm crypt: account large pages in cc->n_allocated_pages
Date: Fri, 24 Nov 2023 17:47:24 +0000
Message-ID: <20231124172036.505949963@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 9793c269da6cd339757de6ba5b2c8681b54c99af upstream.

The commit 5054e778fcd9c ("dm crypt: allocate compound pages if
possible") changed dm-crypt to use compound pages to improve
performance. Unfortunately, there was an oversight: the allocation of
compound pages was not accounted at all. Normal pages are accounted in
a percpu counter cc->n_allocated_pages and dm-crypt is limited to
allocate at most 2% of memory. Because compound pages were not
accounted at all, dm-crypt could allocate memory over the 2% limit.

Fix this by adding the accounting of compound pages, so that memory
consumption of dm-crypt is properly limited.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: 5054e778fcd9c ("dm crypt: allocate compound pages if possible")
Cc: stable@vger.kernel.org	# v6.5+
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-crypt.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1699,11 +1699,17 @@ retry:
 		order = min(order, remaining_order);
 
 		while (order > 0) {
+			if (unlikely(percpu_counter_read_positive(&cc->n_allocated_pages) +
+					(1 << order) > dm_crypt_pages_per_client))
+				goto decrease_order;
 			pages = alloc_pages(gfp_mask
 				| __GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_NOWARN | __GFP_COMP,
 				order);
-			if (likely(pages != NULL))
+			if (likely(pages != NULL)) {
+				percpu_counter_add(&cc->n_allocated_pages, 1 << order);
 				goto have_pages;
+			}
+decrease_order:
 			order--;
 		}
 
@@ -1741,10 +1747,13 @@ static void crypt_free_buffer_pages(stru
 
 	if (clone->bi_vcnt > 0) { /* bio_for_each_folio_all crashes with an empty bio */
 		bio_for_each_folio_all(fi, clone) {
-			if (folio_test_large(fi.folio))
+			if (folio_test_large(fi.folio)) {
+				percpu_counter_sub(&cc->n_allocated_pages,
+						1 << folio_order(fi.folio));
 				folio_put(fi.folio);
-			else
+			} else {
 				mempool_free(&fi.folio->page, &cc->page_pool);
+			}
 		}
 	}
 }


