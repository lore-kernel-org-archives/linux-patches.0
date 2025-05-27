Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E0314AD2B;
	Tue, 27 May 2025 17:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366843; cv=none; b=Wb4ohSKhJd9sP4hcRkMROZHzSmh2l8q7pKW+3nY2o8csO8WZSQx3nzSGut1d36qPm3yWGl2LGdZvKT0WuAPeOw4flEiDnQnPGQFKUeZ2rD/RRNDFnKCYtRlZPK95KxlrL9R1mVETtEt6BwxCb4rTHpWt0tdkHMixzG8KJfTTYyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366843; c=relaxed/simple;
	bh=sxOZTO+yrHlo7UUlqbj35sa/wL0U9JFzOa9VogLi9uQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MU9D4wbb9FJV1YmDRDio81enOqXwAZgOYO9XZaEz7yTSfKqnsS+zuzAU49xKu2jabufewZ/Te8zPJ4J9uDsukLBdZys8P0AheY0eOOodbcAWX/7bzXjd4P5rT/ESIMrbGFZbpdUgBpc9aSJTTuOOKE6GuDQh21vHyXPtqCkMfS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c0/zdvAv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c0/zdvAv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7B59C4CEE9;
	Tue, 27 May 2025 17:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366843;
	bh=sxOZTO+yrHlo7UUlqbj35sa/wL0U9JFzOa9VogLi9uQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c0/zdvAv37BHL3TuAvA6XfTBZ0dVfzaS2FYLGqOky/72abyWxxjjiN97epijDqY7l
	 Jk55ZneXWWju66/Pjp3W8fCxks0URo1U61OMBEec+Bp4e7Dmn6bhFNtkJhisS4Ewy/
	 THZVvdVZ1NGlN3d97D8GSF5sVQg9kvR6EO0MKinw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 195/783] ext4: do not convert the unwritten extents if data writeback fails
Date: Tue, 27 May 2025 18:19:52 +0200
Message-ID: <20250527162521.094635232@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit e856f93e0fb249955f7d5efb18fe20500a9ccc6d ]

When dioread_nolock is turned on (the default), it will convert unwritten
extents to written at ext4_end_io_end(), even if the data writeback fails.

It leads to the possibility that stale data may be exposed when the
physical block corresponding to the file data is read-only (i.e., writes
return -EIO, but reads are normal).

Therefore a new ext4_io_end->flags EXT4_IO_END_FAILED is added, which
indicates that some bio write-back failed in the current ext4_io_end.
When this flag is set, the unwritten to written conversion is no longer
performed. Users can read the data normally until the caches are dropped,
after that, the failed extents can only be read to all 0.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Link: https://patch.msgid.link/20250122110533.4116662-3-libaokun@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ext4.h    |  3 ++-
 fs/ext4/page-io.c | 16 ++++++++++++++--
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index df30d9f235123..d4d285d999311 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -278,7 +278,8 @@ struct ext4_system_blocks {
 /*
  * Flags for ext4_io_end->flags
  */
-#define	EXT4_IO_END_UNWRITTEN	0x0001
+#define EXT4_IO_END_UNWRITTEN	0x0001
+#define EXT4_IO_END_FAILED	0x0002
 
 struct ext4_io_end_vec {
 	struct list_head list;		/* list of io_end_vec */
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 69b8a7221a2b1..f041a5d93716f 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -181,14 +181,25 @@ static int ext4_end_io_end(ext4_io_end_t *io_end)
 		   "list->prev 0x%p\n",
 		   io_end, inode->i_ino, io_end->list.next, io_end->list.prev);
 
-	io_end->handle = NULL;	/* Following call will use up the handle */
-	ret = ext4_convert_unwritten_io_end_vec(handle, io_end);
+	/*
+	 * Do not convert the unwritten extents if data writeback fails,
+	 * or stale data may be exposed.
+	 */
+	io_end->handle = NULL;  /* Following call will use up the handle */
+	if (unlikely(io_end->flag & EXT4_IO_END_FAILED)) {
+		ret = -EIO;
+		if (handle)
+			jbd2_journal_free_reserved(handle);
+	} else {
+		ret = ext4_convert_unwritten_io_end_vec(handle, io_end);
+	}
 	if (ret < 0 && !ext4_forced_shutdown(inode->i_sb)) {
 		ext4_msg(inode->i_sb, KERN_EMERG,
 			 "failed to convert unwritten extents to written "
 			 "extents -- potential data loss!  "
 			 "(inode %lu, error %d)", inode->i_ino, ret);
 	}
+
 	ext4_clear_io_unwritten_flag(io_end);
 	ext4_release_io_end(io_end);
 	return ret;
@@ -344,6 +355,7 @@ static void ext4_end_bio(struct bio *bio)
 			     bio->bi_status, inode->i_ino,
 			     (unsigned long long)
 			     bi_sector >> (inode->i_blkbits - 9));
+		io_end->flag |= EXT4_IO_END_FAILED;
 		mapping_set_error(inode->i_mapping,
 				blk_status_to_errno(bio->bi_status));
 	}
-- 
2.39.5



