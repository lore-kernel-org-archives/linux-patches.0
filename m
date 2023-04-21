Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9EEA6FC6
	for <patches@lists.linux.dev>; Fri, 21 Apr 2023 19:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=RlYZtMcWmG/W2kDdFWLbtYt9Jiujn88dB6HTCMaouxI=; b=qTRjtG4XiiUGR6XLhcw+SFktov
	LoDASQYMHVLj3TTg5Lw0jryhjP4LqtTs5LsbGN8HjKQwWO9XJb2N6gJoJdU2Kbxy3omeTFZdCuvu9
	gYsf5oHp7r0+jNOMXyus067c8U1t8hqR7BaZ7XU9tE5o5lpKgnd7lXd/DLUlJ0pBQsJr0jx9OR/47
	1fBRNIc53lCZDX5v1jMR7xMlrxsp2KBuUX3ZJS59UrN9p8IgGGDnMRpYh9885bwZV49u+cfeaApWm
	7EbwnxAkoRXz2ALy5RYREPDptZqMo4YNQcuh2gLrKyg50PFZ75wR7Mef75Ihe/+CAH3kPwfVf6eN9
	vxETgCxw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1ppwtU-00BlaX-1a;
	Fri, 21 Apr 2023 19:58:08 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: axboe@kernel.dk,
	agk@redhat.com,
	snitzer@kernel.org,
	philipp.reisner@linbit.com,
	lars.ellenberg@linbit.com,
	christoph.boehmwalder@linbit.com,
	hch@infradead.org,
	djwong@kernel.org,
	minchan@kernel.org,
	senozhatsky@chromium.org
Cc: patches@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	dm-devel@redhat.com,
	drbd-dev@lists.linbit.com,
	linux-kernel@vger.kernel.org,
	willy@infradead.org,
	hare@suse.de,
	p.raghav@samsung.com,
	da.gomez@samsung.com,
	kbusch@kernel.org,
	mcgrof@kernel.org
Subject: [PATCH 1/5] dm integrity: simplify by using PAGE_SECTORS_SHIFT
Date: Fri, 21 Apr 2023 12:58:03 -0700
Message-Id: <20230421195807.2804512-2-mcgrof@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230421195807.2804512-1-mcgrof@kernel.org>
References: <20230421195807.2804512-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

The PAGE_SHIFT - SECTOR_SHIFT constant be replaced with PAGE_SECTORS_SHIFT
defined in linux/blt_types.h, which is included by linux/blkdev.h.

This produces no functional changes.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/md/dm-integrity.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 31838b13ea54..a179265970dd 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -752,7 +752,7 @@ static void page_list_location(struct dm_integrity_c *ic, unsigned int section,
 
 	sector = section * ic->journal_section_sectors + offset;
 
-	*pl_index = sector >> (PAGE_SHIFT - SECTOR_SHIFT);
+	*pl_index = sector >> (PAGE_SECTORS_SHIFT);
 	*pl_offset = (sector << SECTOR_SHIFT) & (PAGE_SIZE - 1);
 }
 
@@ -1077,7 +1077,7 @@ static void rw_journal_sectors(struct dm_integrity_c *ic, blk_opf_t opf,
 		return;
 	}
 
-	pl_index = sector >> (PAGE_SHIFT - SECTOR_SHIFT);
+	pl_index = sector >> (PAGE_SECTORS_SHIFT);
 	pl_offset = (sector << SECTOR_SHIFT) & (PAGE_SIZE - 1);
 
 	io_req.bi_opf = opf;
@@ -1201,7 +1201,7 @@ static void copy_from_journal(struct dm_integrity_c *ic, unsigned int section, u
 
 	sector = section * ic->journal_section_sectors + JOURNAL_BLOCK_SECTORS + offset;
 
-	pl_index = sector >> (PAGE_SHIFT - SECTOR_SHIFT);
+	pl_index = sector >> (PAGE_SECTORS_SHIFT);
 	pl_offset = (sector << SECTOR_SHIFT) & (PAGE_SIZE - 1);
 
 	io_req.bi_opf = REQ_OP_WRITE;
@@ -3765,7 +3765,7 @@ static int create_journal(struct dm_integrity_c *ic, char **error)
 	ic->commit_ids[3] = cpu_to_le64(0x4444444444444444ULL);
 
 	journal_pages = roundup((__u64)ic->journal_sections * ic->journal_section_sectors,
-				PAGE_SIZE >> SECTOR_SHIFT) >> (PAGE_SHIFT - SECTOR_SHIFT);
+				PAGE_SIZE >> SECTOR_SHIFT) >> (PAGE_SECTORS_SHIFT);
 	journal_desc_size = journal_pages * sizeof(struct page_list);
 	if (journal_pages >= totalram_pages() - totalhigh_pages() || journal_desc_size > ULONG_MAX) {
 		*error = "Journal doesn't fit into memory";
@@ -4542,7 +4542,7 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned int argc, char **argv
 			spin_lock_init(&bbs->bio_queue_lock);
 
 			sector = i * (BITMAP_BLOCK_SIZE >> SECTOR_SHIFT);
-			pl_index = sector >> (PAGE_SHIFT - SECTOR_SHIFT);
+			pl_index = sector >> (PAGE_SECTORS_SHIFT);
 			pl_offset = (sector << SECTOR_SHIFT) & (PAGE_SIZE - 1);
 
 			bbs->bitmap = lowmem_page_address(ic->journal[pl_index].page) + pl_offset;
-- 
2.39.2

