Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBCD8194A45;
	Tue, 27 May 2025 17:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366708; cv=none; b=Jn4Q0ZZzCjY/+6ly4xNkSOjorr+opjB/lbykkEsxGlIQBfRwloWwFCjycvvFF+XZ+yqLrooX8gwHpzyG3lPn6CjSe8p6BDQlGNVUy+PemhnF7qcV2TVSUCPEOa5l+QjKPxDt1R+GBl1wk7f4V3XapLfWAlPtG8BoDnI57B8IwZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366708; c=relaxed/simple;
	bh=Ce0/m/yFPvNobzdaR4hQFCkTXFxYq/YY/LKkwp22cCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u6UEEa39+WvBhEifJkrB8ZMPBOZlR9KylQZikENJk31WkCqMYl3rpVcfRv+4wAP6AD5r96uDL5hHbf5HvjJTSyz9UHd9QcoUlCElMAJHn2ddslzpmam+RwisunBCYX/B4LQKm7jjIr6GbDjCwyHPaNg4CWBLeZcN+dB1tzrc8l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Of+wQ0zA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Of+wQ0zA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A16CC4CEE9;
	Tue, 27 May 2025 17:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366707;
	bh=Ce0/m/yFPvNobzdaR4hQFCkTXFxYq/YY/LKkwp22cCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Of+wQ0zAbPk14XKhfATAIG5U/0zEBooABBvHKuTBC8Ot/zTxXJ7XVLDUr/3U1kq3A
	 bLq6Hy8QtC6hwIn7najqrK92XSiuZR91WQT9nk0nuTqBtuJddkxD2gc7gKvAApuvqb
	 nRgVeLZgFsM7oVSsW1sG7w2mv6qjXq6tGzindPg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@infradead.org>,
	Kun Hu <huk23@m.fudan.edu.cn>,
	Jiaji Qin <jjtan24@m.fudan.edu.cn>,
	Ming Lei <ming.lei@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 148/783] loop: move vfs_fsync() out of loop_update_dio()
Date: Tue, 27 May 2025 18:19:05 +0200
Message-ID: <20250527162519.186886744@linuxfoundation.org>
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

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 86947bdc28894520ed5aab0cf21b99ff0b659e07 ]

If vfs_flush() is called with queue frozen, the queue freeze lock may be
connected with FS internal lock, and lockdep warning can be triggered
because the queue freeze lock is connected with too many global or
sub-system locks.

Fix the warning by moving vfs_fsync() out of loop_update_dio():

- vfs_fsync() is only needed when switching to dio

- only loop_change_fd() and loop_configure() may switch from buffered
IO to direct IO, so call vfs_fsync() directly here. This way is safe
because either loop is in unbound, or new file isn't attached

- for the other two cases of set_status and set_block_size, direct IO
can only become off, so no need to call vfs_fsync()

Cc: Christoph Hellwig <hch@infradead.org>
Reported-by: Kun Hu <huk23@m.fudan.edu.cn>
Reported-by: Jiaji Qin <jjtan24@m.fudan.edu.cn>
Closes: https://lore.kernel.org/linux-block/359BC288-B0B1-4815-9F01-3A349B12E816@m.fudan.edu.cn/T/#u
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20250318072955.3893805-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/loop.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index b378d2aa49f06..1e5ef09cdde68 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -205,8 +205,6 @@ static bool lo_can_use_dio(struct loop_device *lo)
  */
 static inline void loop_update_dio(struct loop_device *lo)
 {
-	bool dio_in_use = lo->lo_flags & LO_FLAGS_DIRECT_IO;
-
 	lockdep_assert_held(&lo->lo_mutex);
 	WARN_ON_ONCE(lo->lo_state == Lo_bound &&
 		     lo->lo_queue->mq_freeze_depth == 0);
@@ -215,10 +213,6 @@ static inline void loop_update_dio(struct loop_device *lo)
 		lo->lo_flags |= LO_FLAGS_DIRECT_IO;
 	if ((lo->lo_flags & LO_FLAGS_DIRECT_IO) && !lo_can_use_dio(lo))
 		lo->lo_flags &= ~LO_FLAGS_DIRECT_IO;
-
-	/* flush dirty pages before starting to issue direct I/O */
-	if ((lo->lo_flags & LO_FLAGS_DIRECT_IO) && !dio_in_use)
-		vfs_fsync(lo->lo_backing_file, 0);
 }
 
 /**
@@ -568,6 +562,13 @@ static int loop_change_fd(struct loop_device *lo, struct block_device *bdev,
 	if (get_loop_size(lo, file) != get_loop_size(lo, old_file))
 		goto out_err;
 
+	/*
+	 * We might switch to direct I/O mode for the loop device, write back
+	 * all dirty data the page cache now that so that the individual I/O
+	 * operations don't have to do that.
+	 */
+	vfs_fsync(file, 0);
+
 	/* and ... switch */
 	disk_force_media_change(lo->lo_disk);
 	memflags = blk_mq_freeze_queue(lo->lo_queue);
@@ -1046,6 +1047,13 @@ static int loop_configure(struct loop_device *lo, blk_mode_t mode,
 	if (error)
 		goto out_unlock;
 
+	/*
+	 * We might switch to direct I/O mode for the loop device, write back
+	 * all dirty data the page cache now that so that the individual I/O
+	 * operations don't have to do that.
+	 */
+	vfs_fsync(file, 0);
+
 	loop_update_dio(lo);
 	loop_sysfs_init(lo);
 
-- 
2.39.5



