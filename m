Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A21F14431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26D63C4339B;
	Wed, 15 Mar 2023 12:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678882819;
	bh=dN1Ejiyh8Q4bmtoYx3dODQLYe/u93IdHdfmpScb9Oo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QzQNSMHoPI0MvbtIHnGm8QhQ0sx6DwemhzIgxyXaxjgfC4ZlETgXhyZnJWgXhqfxj
	 sHTqAdn9q2J6xeDTon310peOSQACYihpcctN/ZM1Npyn8G4L4Pl2DsSddpIkurVqbE
	 zX2OsDXNdZ6d2wKM/RV2u9PMW034V6CAESO/cOHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Eric Biggers <ebiggers@google.com>,
	Tejun Heo <tj@kernel.org>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.10 006/104] ext4: fix cgroup writeback accounting with fs-layer encryption
Date: Wed, 15 Mar 2023 13:11:37 +0100
Message-Id: <20230315115732.251239755@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115731.942692602@linuxfoundation.org>
References: <20230315115731.942692602@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

commit ffec85d53d0f39ee4680a2cf0795255e000e1feb upstream.

When writing a page from an encrypted file that is using
filesystem-layer encryption (not inline encryption), ext4 encrypts the
pagecache page into a bounce page, then writes the bounce page.

It also passes the bounce page to wbc_account_cgroup_owner().  That's
incorrect, because the bounce page is a newly allocated temporary page
that doesn't have the memory cgroup of the original pagecache page.
This makes wbc_account_cgroup_owner() not account the I/O to the owner
of the pagecache page as it should.

Fix this by always passing the pagecache page to
wbc_account_cgroup_owner().

Fixes: 001e4a8775f6 ("ext4: implement cgroup writeback support")
Cc: stable@vger.kernel.org
Reported-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/20230203005503.141557-1-ebiggers@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/page-io.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -416,7 +416,8 @@ static void io_submit_init_bio(struct ex
 
 static void io_submit_add_bh(struct ext4_io_submit *io,
 			     struct inode *inode,
-			     struct page *page,
+			     struct page *pagecache_page,
+			     struct page *bounce_page,
 			     struct buffer_head *bh)
 {
 	int ret;
@@ -430,10 +431,11 @@ submit_and_retry:
 		io_submit_init_bio(io, bh);
 		io->io_bio->bi_write_hint = inode->i_write_hint;
 	}
-	ret = bio_add_page(io->io_bio, page, bh->b_size, bh_offset(bh));
+	ret = bio_add_page(io->io_bio, bounce_page ?: pagecache_page,
+			   bh->b_size, bh_offset(bh));
 	if (ret != bh->b_size)
 		goto submit_and_retry;
-	wbc_account_cgroup_owner(io->io_wbc, page, bh->b_size);
+	wbc_account_cgroup_owner(io->io_wbc, pagecache_page, bh->b_size);
 	io->io_next_block++;
 }
 
@@ -551,8 +553,7 @@ int ext4_bio_write_page(struct ext4_io_s
 	do {
 		if (!buffer_async_write(bh))
 			continue;
-		io_submit_add_bh(io, inode,
-				 bounce_page ? bounce_page : page, bh);
+		io_submit_add_bh(io, inode, page, bounce_page, bh);
 		nr_submitted++;
 		clear_buffer_dirty(bh);
 	} while ((bh = bh->b_this_page) != head);


