Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32BF7378838;
	Fri,  4 Sep 2026 06:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501960; cv=none; b=cOn/d+NAkqmf+i2ti72ORceYqfP8dzWYB5W42SQYe/DD1MiLcAl7N+mPJXc5ZSuGbZ/WGK0C4rUhCZldFNmJcJecrxQqKl1USFabD4MJeUA/thWcB7cLd9mPJ/WN/qY877vBA+03NuPWNmsiiloNz+UIvkh1tgSKaiBECrd1hsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501960; c=relaxed/simple;
	bh=nXKDim0EiW7qHs+W6vA0mk3m5Nns55xu2EAFwWBgY40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g2S7iYC5InHyT9/ChsFofwFAIRgcyi5nWiaNbqSa098tWuFxeSOHBsbpGtulfgv9ZQstRIKsKE4y9GY2izg+3KUwPC7jhFyoXqwQquZnQVNsCQAs0AAb443XsTSUjSVKN751t8QjimJbtgJelsqdvMHr8dw7oivHUNfZo1v5A6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Liqdf+5D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Liqdf+5D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F6691F00A3D;
	Fri,  4 Sep 2026 06:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501959;
	bh=Mu72vxYFQWrUPTD2FH11W4kmZc045iHsioWpbmy+O/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Liqdf+5DuRvZEJFNPzuO5KBeDzqO9URCLXtlBb2L4lmNsQ3F4kkb8unqqbMu7Hi/C
	 Ov98a7YCmhao8EKB8tWMOF7uzpfiE8pgjujoeFIE47NlKqM8p+DZbAPxqJt9fMwH65
	 j6i6RNtEqqN2o2W4YRu4G4dc24MkdQp3nCTDN9dY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Ming Lei <ming.lei@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	John Garry <john.g.garry@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 004/403] block: mark GFP_NOIO around sysfs ->store()
Date: Fri,  4 Sep 2026 06:56:47 +0200
Message-ID: <20260904045734.910886138@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <tom.leiming@gmail.com>

[ Upstream commit 7c0be4ead1f8f5f8be0803f347de0de81e3b8e1c ]

sysfs ->store is called with queue freezed, meantime we have several
->store() callbacks(update_nr_requests, wbt, scheduler) to allocate
memory with GFP_KERNEL which may run into direct reclaim code path,
then potential deadlock can be caused.

Fix the issue by marking NOIO around sysfs ->store()

Reported-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Link: https://lore.kernel.org/r/20250113015833.698458-1-ming.lei@redhat.com
Link: https://lore.kernel.org/linux-block/Z4RkemI9f6N5zoEF@fedora/T/#mc774c65eeca5c024d29695f9ac6152b87763f305
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-sysfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index a5b6bcdfb9aa0..d53ffff112ff2 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -668,6 +668,7 @@ queue_attr_store(struct kobject *kobj, struct attribute *attr,
 	struct queue_sysfs_entry *entry = to_queue(attr);
 	struct gendisk *disk = container_of(kobj, struct gendisk, queue_kobj);
 	struct request_queue *q = disk->queue;
+	unsigned int noio_flag;
 	ssize_t res;
 
 	if (!entry->store_limit && !entry->store)
@@ -701,7 +702,9 @@ queue_attr_store(struct kobject *kobj, struct attribute *attr,
 
 	mutex_lock(&q->sysfs_lock);
 	blk_mq_freeze_queue(q);
+	noio_flag = memalloc_noio_save();
 	res = entry->store(disk, page, length);
+	memalloc_noio_restore(noio_flag);
 	blk_mq_unfreeze_queue(q);
 	mutex_unlock(&q->sysfs_lock);
 	return res;
-- 
2.53.0



