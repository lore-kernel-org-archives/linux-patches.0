Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B642ED53B
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 23:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=qG5U0uWPFmEbIzb8qGwDd3VP74J/BRogOkPK92T1eiw=; b=4Mn4cSCAgRAwfc+ofEk7syFvU4
	lgI+PixYXC7I6rMVPFt85Y4M8oB/dWwp5q6YY7j/3hgM2uh2P7ZtiZ22ho1zzeWefT3wd+huLJpxd
	mvGW2hfn1RtW61xAcyyeVfH9HN8JlRi29H3roFcGHcEC+b/G8QXX5LxaV7GoFHadburRxTnA/MMf9
	+OPgxbeXJdcEcdQlRLQ0xbxT//SyOp14A7a7SO3dbpZWiKOO2+0j1sd9qtehWMvQZKVPoRxZhSOC9
	XOO9h5XjMa5XF91JikH0HlR1tccdHYPW2mUwbxqK+PvPIFK+WTgqQha6vzzE6HKxjq0hmzN8pLejD
	/ppNx6LQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1pXsL9-003j3O-BB; Thu, 02 Mar 2023 23:27:59 +0000
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
Subject: [PATCH 4/6] shmem: skip page split if we're not reclaiming
Date: Thu,  2 Mar 2023 15:27:56 -0800
Message-Id: <20230302232758.888157-5-mcgrof@kernel.org>
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

In theory when info->flags & VM_LOCKED we should not be getting
shem_writepage() called so we should be verifying this with a
WARN_ON_ONCE(). Since we should not be swapping then best to ensure
we also don't do the folio split earlier too. So just move the check
early to avoid folio splits in case its a dubious call.

We also have a similar early bail when !total_swap_pages so just move
that earlier to avoid the possible folio split in the same situation.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 mm/shmem.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index a5a6da51087e..6006dbb7dbcb 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1352,6 +1352,12 @@ static int shmem_writepage(struct page *page, struct writeback_control *wbc)
 		goto redirty;
 	}
 
+	if (WARN_ON_ONCE(info->flags & VM_LOCKED))
+		goto redirty;
+
+	if (!total_swap_pages)
+		goto redirty;
+
 	/*
 	 * If /sys/kernel/mm/transparent_hugepage/shmem_enabled is "always" or
 	 * "force", drivers/gpu/drm/i915/gem/i915_gem_shmem.c gets huge pages,
@@ -1367,10 +1373,6 @@ static int shmem_writepage(struct page *page, struct writeback_control *wbc)
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

