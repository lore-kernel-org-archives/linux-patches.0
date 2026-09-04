Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7419135AC03;
	Fri,  4 Sep 2026 05:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500942; cv=none; b=VMrFUdeqgkXWP5oNeOQjMIIUb9oR5I5MUw6vYrCs3BltIm24B3ltRJLaMAZ5eQCrXh1NOeNElgOkB6FrYwI6md2sgLdzz5vkOu2vMtHBFlIWy0Z7iLkww2tj+spUUuTAbCtuolh50Pzig63/ik2McH2Mmi0/LqrL72QQjn5M+3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500942; c=relaxed/simple;
	bh=ZCnzVWvWAnmvUZ8nqBh03bJ22mgxCY+2wI4P2lXTpg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dKrsMRCgThlNMGMWsd/PZ5/7UTRD+Uq9A9vcGsPxz6MKOAbf7DLdzljmmrbknAXSnDU3AhkbQq4/nmZ0mq28uH6W4VnvYymTHrHyaLes2C51I3dHC0YKUPqa6B3+nVqlcMWIdao6D+4t12xkAhMfBduS0y7aDHQ2diNKWSExdH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rR2+5bTf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rR2+5bTf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D5371F00A3D;
	Fri,  4 Sep 2026 05:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500940;
	bh=tyT9Xrt6NjkDyxvnSN0QC0rOKOrAvJ2fRBAF2OxkpmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rR2+5bTfu7MVli+zee02rZeh0uS5aXlCB955/SHPlfxWChtoTXFZ+yI4ZzXJmIYdE
	 vlL1FtgCeITlFEikYqKSTcv32oY6R++/yhqYkAc2lAuvXbVrLy8ELoZ2KikritQWEQ
	 3nvot1laLUhM4gYiJ9wcj+HK60cyVCEIz0w/frKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Vjaceslavs Klimovs <vklimovs@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 234/552] dm-io: clone the source bio instead of copying its biovec
Date: Fri,  4 Sep 2026 06:56:31 +0200
Message-ID: <20260904045754.789251639@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Keith Busch <kbusch@kernel.org>

commit 62dc37a819a5a5de5cba989ad9e96ee214b9253e upstream.

For DM_IO_BIO requests, do_region() built each destination bio by walking
the source bio's biovec and re-adding the pages one at a time, tracking
the remaining transfer in sectors. The vector lengths are byte granular
and need not be sector aligned (e.g. a misaligned O_DIRECT buffer split
across pages), so the sector-based accounting could lose a sub-sector
fragment: to_sector() truncated the remainder and the outer loop spun
forever submitting empty bios, hanging the I/O.

There is no need to rebuild the biovec at all. The destination reads into
(or writes from) exactly the same pages as the source bio, so the bio can
simply clone the source's biovec with bio_alloc_clone() and remap it to
the target device. The clone inherits the source's iterator and alignment,
and the block layer splits it to the target's limits on submission, so the
whole region maps to a single cloned bio with no manual page copying or
sector accounting.

This removes the per-page copy path (and its open-coded bvec dpages
helpers) for bio-backed I/O and fixes the hang on misaligned direct I/O to
a dm-mirror device. Page-list, vma and kmem sources keep the existing copy
path.

Fixes: 7eac33186957 ("iomap: simplify direct io validity check")
Fixes: 5ff3f74e145a ("block: simplify direct io validity check")
Cc: stable@vger.kernel.org
Reported-by: Dr. David Alan Gilbert <linux@treblig.org>
Reported-by: Vjaceslavs Klimovs <vklimovs@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-io.c | 67 +++++++++++++++++-----------------------------
 1 file changed, 24 insertions(+), 43 deletions(-)

diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index 1db565b37620..28adfeb58f24 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -170,12 +170,11 @@ struct dpages {
 			 struct page **p, unsigned long *len, unsigned int *offset);
 	void (*next_page)(struct dpages *dp);
 
-	union {
-		unsigned int context_u;
-		struct bvec_iter context_bi;
-	};
+	unsigned int context_u;
 	void *context_ptr;
 
+	struct bio *orig_bio;
+
 	void *vma_invalidate_address;
 	unsigned long vma_invalidate_size;
 };
@@ -210,44 +209,6 @@ static void list_dp_init(struct dpages *dp, struct page_list *pl, unsigned int o
 	dp->context_ptr = pl;
 }
 
-/*
- * Functions for getting the pages from a bvec.
- */
-static void bio_get_page(struct dpages *dp, struct page **p,
-			 unsigned long *len, unsigned int *offset)
-{
-	struct bio_vec bvec = bvec_iter_bvec((struct bio_vec *)dp->context_ptr,
-					     dp->context_bi);
-
-	*p = bvec.bv_page;
-	*len = bvec.bv_len;
-	*offset = bvec.bv_offset;
-
-	/* avoid figuring it out again in bio_next_page() */
-	dp->context_bi.bi_sector = (sector_t)bvec.bv_len;
-}
-
-static void bio_next_page(struct dpages *dp)
-{
-	unsigned int len = (unsigned int)dp->context_bi.bi_sector;
-
-	bvec_iter_advance((struct bio_vec *)dp->context_ptr,
-			  &dp->context_bi, len);
-}
-
-static void bio_dp_init(struct dpages *dp, struct bio *bio)
-{
-	dp->get_page = bio_get_page;
-	dp->next_page = bio_next_page;
-
-	/*
-	 * We just use bvec iterator to retrieve pages, so it is ok to
-	 * access the bvec table directly here
-	 */
-	dp->context_ptr = bio->bi_io_vec;
-	dp->context_bi = bio->bi_iter;
-}
-
 /*
  * Functions for getting the pages from a VMA.
  */
@@ -332,6 +293,21 @@ static void do_region(const blk_opf_t opf, unsigned int region,
 		return;
 	}
 
+	if (dp->orig_bio) {
+		bio = bio_alloc_clone(where->bdev, dp->orig_bio, GFP_NOIO,
+				      &io->client->bios);
+		bio->bi_iter.bi_sector = where->sector;
+		bio->bi_iter.bi_size = where->count << SECTOR_SHIFT;
+		bio->bi_opf = opf;
+		bio->bi_end_io = endio;
+		bio->bi_ioprio = ioprio;
+		store_io_and_region_in_bio(bio, io, region);
+
+		atomic_inc(&io->count);
+		submit_bio(bio);
+		return;
+	}
+
 	/*
 	 * where->count may be zero if op holds a flush and we need to
 	 * send a zero-sized flush.
@@ -468,6 +444,7 @@ static int dp_init(struct dm_io_request *io_req, struct dpages *dp,
 
 	dp->vma_invalidate_address = NULL;
 	dp->vma_invalidate_size = 0;
+	dp->orig_bio = NULL;
 
 	switch (io_req->mem.type) {
 	case DM_IO_PAGE_LIST:
@@ -475,7 +452,11 @@ static int dp_init(struct dm_io_request *io_req, struct dpages *dp,
 		break;
 
 	case DM_IO_BIO:
-		bio_dp_init(dp, io_req->mem.ptr.bio);
+		/*
+		 * The destination bios clone this bio's biovec directly, so
+		 * there are no per-page accessors to set up here.
+		 */
+		dp->orig_bio = io_req->mem.ptr.bio;
 		break;
 
 	case DM_IO_VMA:
-- 
2.55.0



