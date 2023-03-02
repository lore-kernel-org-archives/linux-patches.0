Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A7010781
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 23:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Hpr/mKVZzGGQqVrubmxhAsrFv4PlfL2VXUxF3A6d69A=; b=hKi5B7rksyIKLYpIpojH3COwse
	6yVboytacnRm0DNMUh5BKMfZwbdWYuNUklJLKFbD4wjEle33GCTpvZJdXbQPCk3hIf0DFStd9tL+t
	jq4IAgiksjYqh8v8mIireTRU6LNVj2zfYQ9mtUda+GZCTq6XHxJgjkKPxVVTVA6t/x9znl5F31erd
	JzgAsoy7GHNSk6QSSzDOJz7LMMAQ1DbbEpT234nu/jFOtmuCwstY5Gm50cCZVHGdz0FpM/qmB87KL
	Z3RJNpaMrZyQyQJFwvIzGInyQpaIjBIYAAKuhUc2yvfiaKNxUBSuS7LOizfLNgOD6cguhCKiDt7p1
	C3zX/D7w==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1pXsL9-003j3M-8Z; Thu, 02 Mar 2023 23:27:59 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: hughd@google.com,
	akpm@linux-foundation.org,
	willy@infradead.org,
	brauner@kernel.org
Cc: linux-mm@kvack.org,
	p.raghav@samsung.com,
	da.gomez@samsung.com,
	a.manzanares@samsung.com,
	dave@stgolabs.net,
	yosryahmed@google.com,
	keescook@chromium.org,
	mcgrof@kernel.org,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] shmem: move reclaim check early on writepages()
Date: Thu,  2 Mar 2023 15:27:55 -0800
Message-Id: <20230302232758.888157-4-mcgrof@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230302232758.888157-1-mcgrof@kernel.org>
References: <20230302232758.888157-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

i915_gem requires huge folios to be split when swapping.
However we have  check for usage of writepages() to ensure
it used only for swap purposes later. Avoid the splits if
we're not being called for reclaim, even if they should in
theory not happen.

This makes the conditions easier to follow on shem_writepage().

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 mm/shmem.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 2b9ff585a553..a5a6da51087e 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1340,6 +1340,18 @@ static int shmem_writepage(struct page *page, struct writeback_control *wbc)
 	swp_entry_t swap;
 	pgoff_t index;
 
+	/*
+	 * Our capabilities prevent regular writeback or sync from ever calling
+	 * shmem_writepage; but a stacking filesystem might use ->writepage of
+	 * its underlying filesystem, in which case tmpfs should write out to
+	 * swap only in response to memory pressure, and not for the writeback
+	 * threads or sync.
+	 */
+	if (!wbc->for_reclaim) {
+		WARN_ON_ONCE(1);	/* Still happens? Tell us about it! */
+		goto redirty;
+	}
+
 	/*
 	 * If /sys/kernel/mm/transparent_hugepage/shmem_enabled is "always" or
 	 * "force", drivers/gpu/drm/i915/gem/i915_gem_shmem.c gets huge pages,
@@ -1360,18 +1372,6 @@ static int shmem_writepage(struct page *page, struct writeback_control *wbc)
 	if (!total_swap_pages)
 		goto redirty;
 
-	/*
-	 * Our capabilities prevent regular writeback or sync from ever calling
-	 * shmem_writepage; but a stacking filesystem might use ->writepage of
-	 * its underlying filesystem, in which case tmpfs should write out to
-	 * swap only in response to memory pressure, and not for the writeback
-	 * threads or sync.
-	 */
-	if (!wbc->for_reclaim) {
-		WARN_ON_ONCE(1);	/* Still happens? Tell us about it! */
-		goto redirty;
-	}
-
 	/*
 	 * This is somewhat ridiculous, but without plumbing a SWAP_MAP_FALLOC
 	 * value into swapfile.c, the only way we can correctly account for a
-- 
2.39.1

