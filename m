Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E13BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:36:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED38C433EF;
	Tue,  7 Mar 2023 18:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214162;
	bh=YLdiUgVhBv3bV48AniyjMASGnPGb+33LGqHi0IVj/YI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yXsX/P+oFYyCN1xZS5tf3biA73vQF+tcwlp5ZmPpfHy6Ln0wlI+SUm11E6XLEUDfO
	 A9MdCxdkse0h6WQBew+fOmPchIU2Vq5fpZ8nOeZu4bE6BsYi5WzedUfntN8uziNZC5
	 yvoagrmxFg4OUa095MgoYXBwOvCWAp9SdkO7xBYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 743/885] brd: return 0/-error from brd_insert_page()
Date: Tue,  7 Mar 2023 18:01:17 +0100
Message-Id: <20230307170034.214425566@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jens Axboe <axboe@kernel.dk>

commit db0ccc44a20b4bb3039c0f6885a1f9c3323c7673 upstream.

It currently returns a page, but callers just check for NULL/page to
gauge success. Clean this up and return the appropriate error directly
instead.

Cc: stable@vger.kernel.org # 5.10+
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/brd.c |   26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -78,11 +78,9 @@ static struct page *brd_lookup_page(stru
 }
 
 /*
- * Look up and return a brd's page for a given sector.
- * If one does not exist, allocate an empty page, and insert that. Then
- * return it.
+ * Insert a new page for a given sector, if one does not already exist.
  */
-static struct page *brd_insert_page(struct brd_device *brd, sector_t sector)
+static int brd_insert_page(struct brd_device *brd, sector_t sector)
 {
 	pgoff_t idx;
 	struct page *page;
@@ -90,7 +88,7 @@ static struct page *brd_insert_page(stru
 
 	page = brd_lookup_page(brd, sector);
 	if (page)
-		return page;
+		return 0;
 
 	/*
 	 * Must use NOIO because we don't want to recurse back into the
@@ -99,11 +97,11 @@ static struct page *brd_insert_page(stru
 	gfp_flags = GFP_NOIO | __GFP_ZERO | __GFP_HIGHMEM;
 	page = alloc_page(gfp_flags);
 	if (!page)
-		return NULL;
+		return -ENOMEM;
 
 	if (radix_tree_preload(GFP_NOIO)) {
 		__free_page(page);
-		return NULL;
+		return -ENOMEM;
 	}
 
 	spin_lock(&brd->brd_lock);
@@ -120,8 +118,7 @@ static struct page *brd_insert_page(stru
 	spin_unlock(&brd->brd_lock);
 
 	radix_tree_preload_end();
-
-	return page;
+	return 0;
 }
 
 /*
@@ -174,16 +171,17 @@ static int copy_to_brd_setup(struct brd_
 {
 	unsigned int offset = (sector & (PAGE_SECTORS-1)) << SECTOR_SHIFT;
 	size_t copy;
+	int ret;
 
 	copy = min_t(size_t, n, PAGE_SIZE - offset);
-	if (!brd_insert_page(brd, sector))
-		return -ENOSPC;
+	ret = brd_insert_page(brd, sector);
+	if (ret)
+		return ret;
 	if (copy < n) {
 		sector += copy >> SECTOR_SHIFT;
-		if (!brd_insert_page(brd, sector))
-			return -ENOSPC;
+		ret = brd_insert_page(brd, sector);
 	}
-	return 0;
+	return ret;
 }
 
 /*


