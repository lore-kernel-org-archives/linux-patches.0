Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2D9C963
	for <patches@lists.linux.dev>; Thu,  9 Mar 2023 23:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Mj38/Shbs9ZyLGljvL78FJsMrZNw4adJNB7STaV6cuA=; b=seeJm9gYP9E41NpNLIQfn02A+C
	oxlZ3k6wzYiLUH1KFiSb05cnPDxxE85TUCsL05PdvvOaU6QIuFDUpzxwIZeM5WsxwhAmZzqgZSSl7
	8hBYfYuPOrxwUcjZKpqMjt3Nb6f22NzLkFsgK7K/Y5Lb/XJs0ZAhpfXLhj0DRTUwjaOTXI8FGUT5d
	44OtbSzlkiJoESExutB36lEeI9dejYMgU7S7R7ApLodCoJtM4HPACPX51Ftk7Pyfct5xSDZ0+nutl
	pXExNQXMnX+lTj1Bareamc66niruXfSdjnmbxhqrUnXtYCLtmkZtYwcGSf+KatBCDrZ3pe1ZlEhyX
	pd/xldcA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1paPKW-00CIRU-5W; Thu, 09 Mar 2023 23:05:48 +0000
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
Subject: [PATCH v2 2/6] shmem: set shmem_writepage() variables early
Date: Thu,  9 Mar 2023 15:05:41 -0800
Message-Id: <20230309230545.2930737-3-mcgrof@kernel.org>
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

shmem_writepage() sets up variables typically used *after* a possible
huge page split. However even if that does happen the address space
mapping should not change, and the inode does not change either. So it
should be safe to set that from the very beginning.

This commit makes no functional changes.

Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 mm/shmem.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 7fff1a3af092..2b9ff585a553 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1334,9 +1334,9 @@ int shmem_unuse(unsigned int type)
 static int shmem_writepage(struct page *page, struct writeback_control *wbc)
 {
 	struct folio *folio = page_folio(page);
-	struct shmem_inode_info *info;
-	struct address_space *mapping;
-	struct inode *inode;
+	struct address_space *mapping = folio->mapping;
+	struct inode *inode = mapping->host;
+	struct shmem_inode_info *info = SHMEM_I(inode);
 	swp_entry_t swap;
 	pgoff_t index;
 
@@ -1354,10 +1354,7 @@ static int shmem_writepage(struct page *page, struct writeback_control *wbc)
 		folio_clear_dirty(folio);
 	}
 
-	mapping = folio->mapping;
 	index = folio->index;
-	inode = mapping->host;
-	info = SHMEM_I(inode);
 	if (info->flags & VM_LOCKED)
 		goto redirty;
 	if (!total_swap_pages)
-- 
2.39.1

