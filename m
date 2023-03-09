Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71695C960
	for <patches@lists.linux.dev>; Thu,  9 Mar 2023 23:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=nd2m/LNu9NMKcIyRptke6PFaE+tBCNb9V+MN5pDSpQU=; b=3HA+jE0dyswGu9J5ZVVPfPe329
	BO74aE5mhVip8O7KCZwd+SF7eFwb27HJyop6K4tGVHCtQXPIHeTkMP2VAkR0T3MojwU8x6u+tf0Dv
	nBlE2vsMycFdc8mJdNhg9Wjv8EuDGp2Liutocgdvmqk3KDlQD+PgebAyTzprcitwS5UM8JZ4yfkgZ
	UNrRRD4Z1LIzm7QVLI/cT8FeeIAguMrwrgUAi/3NZY3KeND9TvJ0wUDcAtY9ObElBVCcs+W7kwkZ9
	7EyooKOu7ISN/RzkBo8MmRK2IeqGOi5Rh2g77AKzK4W7UpYmr2grBlhpxHPHisC4onhlVIrgPbgEq
	5dxQmXXA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1paPKW-00CIRY-8d; Thu, 09 Mar 2023 23:05:48 +0000
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
	linux-kernel@vger.kernel.org,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH v2 4/6] shmem: skip page split if we're not reclaiming
Date: Thu,  9 Mar 2023 15:05:43 -0800
Message-Id: <20230309230545.2930737-5-mcgrof@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230309230545.2930737-1-mcgrof@kernel.org>
References: <20230309230545.2930737-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

In theory when info->flags & VM_LOCKED we should not be getting
shem_writepage() called so we should be verifying this with a
WARN_ON_ONCE(). Since we should not be swapping then best to ensure
we also don't do the folio split earlier too. So just move the check
early to avoid folio splits in case its a dubious call.

We also have a similar early bail when !total_swap_pages so just move
that earlier to avoid the possible folio split in the same situation.

Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 mm/shmem.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 68e9970baf1e..dfd995da77b4 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1350,6 +1350,12 @@ static int shmem_writepage(struct page *page, struct writeback_control *wbc)
 	if (WARN_ON_ONCE(!wbc->for_reclaim))
 		goto redirty;
 
+	if (WARN_ON_ONCE(info->flags & VM_LOCKED))
+		goto redirty;
+
+	if (!total_swap_pages)
+		goto redirty;
+
 	/*
 	 * If /sys/kernel/mm/transparent_hugepage/shmem_enabled is "always" or
 	 * "force", drivers/gpu/drm/i915/gem/i915_gem_shmem.c gets huge pages,
@@ -1365,10 +1371,6 @@ static int shmem_writepage(struct page *page, struct writeback_control *wbc)
 	}
 
 	index = folio->index;
-	if (info->flags & VM_LOCKED)
-		goto redirty;
-	if (!total_swap_pages)
-		goto redirty;
 
 	/*
 	 * This is somewhat ridiculous, but without plumbing a SWAP_MAP_FALLOC
-- 
2.39.1

