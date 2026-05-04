Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4A93D5667;
	Mon,  4 May 2026 14:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903801; cv=none; b=MhTxg9mivvhu2ssafNV+M5fw1l+oxKuCaRoyOf0qQIeBeZWGR87vNGCFqoA+ih7iKFkO/CXTt37JfsWhosN+9b36hQ3O457xcFqnGzrQs3tYOIby8Uw1N4lyihcMcW0TijRBiyO6cQTiKHo74fyzHFWkB66yUeyT8C+8jgp/cVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903801; c=relaxed/simple;
	bh=HhFPu3AX7Nw5Icsprw7W4rUdH0F5rE+/OCrQQEtwlUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cBNXjL/ok0QccRzB8AbMTQnmVSyaxohZQEPzT3/4v7T7R9d4RKdho4OqDPFvn1CVRCrE2ARprfM1KqoA59QfbqOumhBhxULiZ8QyLEevboEf4dzRsxLiLl6xvZr3ka4QDOrXOI6DIvcKEaNNgLqGmYp55DU+oEqGD6eIxgRZ9BA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l2zg7uxI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l2zg7uxI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70846C2BCB8;
	Mon,  4 May 2026 14:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903801;
	bh=HhFPu3AX7Nw5Icsprw7W4rUdH0F5rE+/OCrQQEtwlUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l2zg7uxII1BnaJyaFaPTcUOKiJEmvfjVlnd7P9sQnscUgjv4f9Li6XuchAKTJCotc
	 OtsrH6XqTnoVoDsE0m9l7PTGu0h5uN7ZQ7lBDK1DMYTYpyb0fAFk6pWrUI/p972hNa
	 he/7oYo046nb0G6J/aOdzXORD91T480wappFBtLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.18 068/275] jbd2: fix deadlock in jbd2_journal_cancel_revoke()
Date: Mon,  4 May 2026 15:50:08 +0200
Message-ID: <20260504135145.458799434@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

From: Zhang Yi <yi.zhang@huawei.com>

commit 981fcc5674e67158d24d23e841523eccba19d0e7 upstream.

Commit f76d4c28a46a ("fs/jbd2: use sleeping version of
__find_get_block()") changed jbd2_journal_cancel_revoke() to use
__find_get_block_nonatomic() which holds the folio lock instead of
i_private_lock. This breaks the lock ordering (folio -> buffer) and
causes an ABBA deadlock when the filesystem blocksize < pagesize:

     T1                                T2
ext4_mkdir()
 ext4_init_new_dir()
  ext4_append()
   ext4_getblk()
    lock_buffer()    <- A
                                   sync_blockdev()
                                    blkdev_writepages()
                                     writeback_iter()
                                      writeback_get_folio()
                                       folio_lock()   <- B
     ext4_journal_get_create_access()
      jbd2_journal_cancel_revoke()
       __find_get_block_nonatomic()
        folio_lock()  <- B
                                     block_write_full_folio()
                                      lock_buffer()   <- A

This can occasionally cause generic/013 to hang.

Fix by only calling __find_get_block_nonatomic() when the passed
buffer_head doesn't belong to the bdev, which is the only case that we
need to look up its bdev alias. Otherwise, the lookup is redundant since
the found buffer_head is equal to the one we passed in.

Fixes: f76d4c28a46a ("fs/jbd2: use sleeping version of __find_get_block()")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Link: https://patch.msgid.link/20260409114204.917154-1-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jbd2/revoke.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/fs/jbd2/revoke.c
+++ b/fs/jbd2/revoke.c
@@ -428,6 +428,7 @@ void jbd2_journal_cancel_revoke(handle_t
 	journal_t *journal = handle->h_transaction->t_journal;
 	int need_cancel;
 	struct buffer_head *bh = jh2bh(jh);
+	struct address_space *bh_mapping = bh->b_folio->mapping;
 
 	jbd2_debug(4, "journal_head %p, cancelling revoke\n", jh);
 
@@ -464,13 +465,14 @@ void jbd2_journal_cancel_revoke(handle_t
 	 * buffer_head?  If so, we'd better make sure we clear the
 	 * revoked status on any hashed alias too, otherwise the revoke
 	 * state machine will get very upset later on. */
-	if (need_cancel) {
+	if (need_cancel && !sb_is_blkdev_sb(bh_mapping->host->i_sb)) {
 		struct buffer_head *bh2;
+
 		bh2 = __find_get_block_nonatomic(bh->b_bdev, bh->b_blocknr,
 						 bh->b_size);
 		if (bh2) {
-			if (bh2 != bh)
-				clear_buffer_revoked(bh2);
+			WARN_ON_ONCE(bh2 == bh);
+			clear_buffer_revoked(bh2);
 			__brelse(bh2);
 		}
 	}


