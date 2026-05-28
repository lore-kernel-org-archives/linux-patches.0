Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0BE23254A8;
	Thu, 28 May 2026 20:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999244; cv=none; b=YXbMUkk6O2X6NgB4zq+CnG6ANTQnoxw7c6Qd2YcHzWGfFWtjmYnXnLDZp+XhltTrLaSOplHAqYTAPZKS4jNPBF3UO7RmM2BGm5wU0BWX9oKA7k/j0fxSzf8Mz+hxAdevK/g2pLW+xt6p9fW0AustMWi5jTeLWeIDuD7sGL3rTFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999244; c=relaxed/simple;
	bh=I80hdjl6n5beXAFJClYf9TXOASO6qduk/xqUlfqKmhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jH8v4ZtEsQv3IGFWw151Mb3lOyCACnzu0WInsjEtcaAVd7rO9UiPUtrpHualHtzl74yaJNUAOED+ZP3GdjAT7QKAi6nIbZicyDttojDOMtrn+FxQqsN7oRXNgFKODDfnSpMo80/RLY2BSfhMY21mHCaqmG5tSbdmHOcFiiT767A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vpxomfFG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vpxomfFG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13BCB1F000E9;
	Thu, 28 May 2026 20:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999243;
	bh=Ebn2TKDtijNATtSnETxZz2VSpy7BN9O0zpJNQeTqk/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vpxomfFGwL4Qsf12bROtehGHB9rSbrhGvWqpD80ggRDqsRnNmn4PTUF/hh5q+HuD8
	 dAwb9KxTB3bCKJJUPqbWsde5odd4vnKA65TI9KdajVA8XyVsLMJcPr2YHwLvXB0mB9
	 Am/KEwA4pSopbaZTcw3An/r8XX+rRYe8p4ZLaLVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 459/461] block: avoid use-after-free in disk_free_zone_resources()
Date: Thu, 28 May 2026 21:49:48 +0200
Message-ID: <20260528194700.827257554@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit f6982769910ecddabdb5b8b9afdab0bb8b6668ac ]

The function disk_update_zone_resources() may call
disk_free_zone_resources() in case of error, and following this,
blk_revalidate_disk_zones() will again calls disk_free_zone_resources() if
disk_update_zone_resources() failed. If a zone worker thread is being used
(which is the default for a rotational media zoned device),
disk_free_zone_resources() will try to stop the zone worker thread twice
because disk->zone_wplugs_worker is not reset to NULL when the worker
thread is stopped the first time.

In disk_free_zone_resources(), fix this by correctly clearing
disk->zone_wplugs_worker to NULL when the worker thread is stopped.

And while at it, since disk_free_zone_resources() is always called after a
failed call to disk_update_zone_resources(), remove the unnecessary call
to disk_free_zone_resources() in disk_update_zone_resources().

Fixes: 1365b6904fd0 ("block: allow submitting all zone writes from a single context")
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260522115622.588535-1-dlemoal@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-zoned.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index af724ce650801..fe29fe4b6dccc 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -2016,8 +2016,10 @@ static void disk_set_zones_cond_array(struct gendisk *disk, u8 *zones_cond)
 
 void disk_free_zone_resources(struct gendisk *disk)
 {
-	if (disk->zone_wplugs_worker)
+	if (disk->zone_wplugs_worker) {
 		kthread_stop(disk->zone_wplugs_worker);
+		disk->zone_wplugs_worker = NULL;
+	}
 	WARN_ON_ONCE(!list_empty(&disk->zone_wplugs_list));
 
 	if (disk->zone_wplugs_wq) {
@@ -2150,9 +2152,6 @@ static int disk_update_zone_resources(struct gendisk *disk,
 	ret = queue_limits_commit_update(q, &lim);
 
 unfreeze:
-	if (ret)
-		disk_free_zone_resources(disk);
-
 	blk_mq_unfreeze_queue(q, memflags);
 
 	return ret;
-- 
2.53.0



