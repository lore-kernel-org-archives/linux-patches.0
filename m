Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E524C27732;
	Thu, 16 Jul 2026 14:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211660; cv=none; b=sHXjyPZUcbTkgI6pbALMLtN2EPh2pohAH6WxjFxckAVWLYYxIHm9kU1gHwJYrXjiL8mtCstHFucnsGUduU9o/OMjd9BGYnTBoaGhtWo7jqYb71j2nG5uIKZDjRIuxd0Ek5jifZo2w1J7Iu5iZVuCcbSeUHwOlZMdcjjnSksDFiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211660; c=relaxed/simple;
	bh=bkoLWbt3tQqCB2PJKRKOld/aepwgRtk/MDVUEGEMJHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gjZBpQOrSgGuS2skf0wC61Xu4CaVJLaZLan4cwxrXIPW2JAQZD8M+rBoC9tkCgCJ3kpSylobkwI8qjrJQCw+Hnk9dZnBJ02A6Ou3lNnv3R8g0M7DFlJyfiPZkJl0WZ4cDgxR8lQEQr/At7FUL542H+9IMN2j8Ywt+rP210leIRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dN3cyadH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dN3cyadH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE961F000E9;
	Thu, 16 Jul 2026 14:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211658;
	bh=4WySG8F52oNasoNZP3CaECjyXyFZqUgQj0H2KlkLmBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dN3cyadHZsMIfh26ZGBf2UJGyP0wgwL3delaBwnYVRcYVWfXtQLn1EEmESt9EuW1K
	 6WpSNL9nT+uLd9db/EgsQQzjxsOUbCS9EteR3YEuX8r05/gbPx8k+E4jPlGVeT4M3i
	 hzmqy3fNtOoC0xHxnSXWCLhHLNXRwdVJ+iHFufVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Ming Lei <ming.lei@redhat.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Jens Axboe <axboe@kernel.dk>,
	Konstantin Andreev <andreev@swemel.ru>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 031/349] block: fix queue freeze vs limits lock order in sysfs store methods
Date: Thu, 16 Jul 2026 15:29:25 +0200
Message-ID: <20260716133034.006801140@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit c99f66e4084a62a2cc401c4704a84328aeddc9ec ]

queue_attr_store() always freezes a device queue before calling the
attribute store operation. For attributes that control queue limits, the
store operation will also lock the queue limits with a call to
queue_limits_start_update(). However, some drivers (e.g. SCSI sd) may
need to issue commands to a device to obtain limit values from the
hardware with the queue limits locked. This creates a potential ABBA
deadlock situation if a user attempts to modify a limit (thus freezing
the device queue) while the device driver starts a revalidation of the
device queue limits.

Avoid such deadlock by not freezing the queue before calling the
->store_limit() method in struct queue_sysfs_entry and instead use the
queue_limits_commit_update_frozen helper to freeze the queue after taking
the limits lock.

This also removes taking the sysfs lock for the store_limit method as
it doesn't protect anything here, but creates even more nesting.
Hopefully it will go away from the actual sysfs methods entirely soon.

(commit log adapted from a similar patch from  Damien Le Moal)

Fixes: ff956a3be95b ("block: use queue_limits_commit_update in queue_discard_max_store")
Fixes: 0327ca9d53bf ("block: use queue_limits_commit_update in queue_max_sectors_store")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Link: https://lore.kernel.org/r/20250110054726.1499538-7-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Konstantin Andreev <andreev@swemel.ru>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-sysfs.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index c9e572ae0b9c63..a5b6bcdfb9aa0a 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -684,22 +684,24 @@ queue_attr_store(struct kobject *kobj, struct attribute *attr,
 			return res;
 	}
 
-	mutex_lock(&q->sysfs_lock);
-	blk_mq_freeze_queue(q);
 	if (entry->store_limit) {
 		struct queue_limits lim = queue_limits_start_update(q);
 
 		res = entry->store_limit(disk, page, length, &lim);
 		if (res < 0) {
 			queue_limits_cancel_update(q);
-		} else {
-			res = queue_limits_commit_update(q, &lim);
-			if (!res)
-				res = length;
+			return res;
 		}
-	} else {
-		res = entry->store(disk, page, length);
+
+		res = queue_limits_commit_update_frozen(q, &lim);
+		if (res)
+			return res;
+		return length;
 	}
+
+	mutex_lock(&q->sysfs_lock);
+	blk_mq_freeze_queue(q);
+	res = entry->store(disk, page, length);
 	blk_mq_unfreeze_queue(q);
 	mutex_unlock(&q->sysfs_lock);
 	return res;
-- 
2.53.0



