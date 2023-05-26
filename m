Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F8DA95F
	for <patches@lists.linux.dev>; Fri, 26 May 2023 07:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=X5+iEoQSxU/Osj6DTwS+zZOMGO87395DKsZwMMPd0uo=; b=dc/TfmJ1je+wYNn6ZVghaEpsuV
	hNonEGR/rf9ZvbCAtb5luxqhaZt290ieMP7zWmNl7lupnAdO9iA0HyVxMj1G/RoRzCtvY/M6prI9u
	lYnSzpeG1xbU/2p54uZWSQ88A0ZYpHndBkZvInbp17tTfW9XSan71VRDhfNHlqoumaNtcu88Wp3k4
	v5FcBIFu+40VmHsGhbu9Jdd5zPt1PTCK0tbUA93ZZq2etcKHzdK8JGRPp3spp0ExpIzmQerGEiH7Q
	xB3QY73a5kLbfciwvYDJY/W2Eb3WRU0xJdfAs6PfVoe8OpyRuSafffwUrlDb8+X5ApvoFmqa5E3Ld
	TAz2AXvA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1q2SIj-001WZu-30;
	Fri, 26 May 2023 07:55:53 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: hughd@google.com,
	akpm@linux-foundation.org,
	willy@infradead.org,
	brauner@kernel.org,
	djwong@kernel.org
Cc: p.raghav@samsung.com,
	da.gomez@samsung.com,
	rohan.puri@samsung.com,
	rpuri.linux@gmail.com,
	a.manzanares@samsung.com,
	dave@stgolabs.net,
	yosryahmed@google.com,
	keescook@chromium.org,
	hare@suse.de,
	kbusch@kernel.org,
	mcgrof@kernel.org,
	patches@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [RFC v2 5/8] shmem: account for larger blocks sizes for shmem_default_max_blocks()
Date: Fri, 26 May 2023 00:55:49 -0700
Message-Id: <20230526075552.363524-6-mcgrof@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230526075552.363524-1-mcgrof@kernel.org>
References: <20230526075552.363524-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

If we end up supporting a larger block size than PAGE_SIZE the
calculations in shmem_default_max_blocks() need to be modified to take
into account the fact that multiple pages would be required for a
single block.

Today the max number of blocks is computed based on the fact that we
will by default use half of the available memory and each block is of
PAGE_SIZE.

And so we end up with:

totalram_pages() / 2

That's because blocksize == PAGE_SIZE. When blocksize > PAGE_SIZE
we need to consider how how many blocks fit into totalram_pages() first,
then just divide by 2. This ends up being:

totalram_pages * PAGE_SIZE / blocksize / 2
totalram_pages * 2^PAGE_SHIFT / 2^bbits / 2
totalram_pages * 2^(PAGE_SHIFT - bbits - 1)

We know bbits > PAGE_SHIFT so we'll end up with a negative
power of 2. 2^(-some_val). We can factor the -1 out by changing
this to a division of power of 2 and flipping the values for
the signs:

-1 * (PAGE_SHIFT - bbits -1) = (-PAGE_SHIFT + bbits + 1)
                             = (bbits - PAGE_SHIFT + 1)

And so we end up with:

totalram_pages / 2^(bbits - PAGE_SHIFT + 1)

The bbits is just the block order.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 mm/shmem.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index c124997f8d93..179fde04f57f 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -138,9 +138,11 @@ static u64 shmem_sb_blocksize(struct shmem_sb_info *sbinfo)
 	return 1UL << sbinfo->block_order;
 }
 
-static unsigned long shmem_default_max_blocks(void)
+static unsigned long shmem_default_max_blocks(unsigned char block_order)
 {
-	return totalram_pages() / 2;
+	if (block_order == shmem_default_block_order())
+		return totalram_pages() / 2;
+	return totalram_pages() >> (block_order - PAGE_SHIFT + 1);
 }
 
 static unsigned long shmem_default_max_inodes(void)
@@ -3905,7 +3907,7 @@ static int shmem_show_options(struct seq_file *seq, struct dentry *root)
 {
 	struct shmem_sb_info *sbinfo = SHMEM_SB(root->d_sb);
 
-	if (sbinfo->max_blocks != shmem_default_max_blocks())
+	if (sbinfo->max_blocks != shmem_default_max_blocks(shmem_default_block_order()))
 		seq_printf(seq, ",size=%luk",
 			sbinfo->max_blocks << (PAGE_SHIFT - 10));
 	if (sbinfo->max_inodes != shmem_default_max_inodes())
@@ -3987,7 +3989,7 @@ static int shmem_fill_super(struct super_block *sb, struct fs_context *fc)
 	 */
 	if (!(sb->s_flags & SB_KERNMOUNT)) {
 		if (!(ctx->seen & SHMEM_SEEN_BLOCKS))
-			ctx->blocks = shmem_default_max_blocks();
+			ctx->blocks = shmem_default_max_blocks(shmem_default_block_order());
 		if (!(ctx->seen & SHMEM_SEEN_INODES))
 			ctx->inodes = shmem_default_max_inodes();
 		if (!(ctx->seen & SHMEM_SEEN_INUMS))
-- 
2.39.2

