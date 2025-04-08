Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49DAA279323;
	Tue,  8 Apr 2025 12:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116902; cv=none; b=YxWYzJLSK/jE4PP5b+0MMVhHsTX1p9ocro0F5Z9HXMFibCemXTeoOjlQoOTXg+oFSHArQkaUMM4NeZmYpLMtqYzlmFjwJbF5x6nInbdHg0w84S/N+gstxBi/RdkAJhSYgHHEnf9tEGFoD+oP1BgfpgiEpon5n+3z7CKx8YbxpCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116902; c=relaxed/simple;
	bh=ZATwbg86x0XOYw3ZJiMOKIUvAz05daeYqVFr8zHG5C4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pjAmzkx3MKt+Y3ruQ2RIJmglqKpQ+FZ8QIFQPRAqmEr3AfoV63acpf5eAE9i2UiUuyEQ7HRnRM7gj68Pzl2f4DKBxtcQeGS0Dv30wN5y+IMSxbrp6B2Zwy3WmNMiHLR5VOapu+P/7rYmoIV4WjZJd04uJEdqUlzduKJwy/53ttM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cgMusYhw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cgMusYhw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC9CFC4CEEA;
	Tue,  8 Apr 2025 12:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116902;
	bh=ZATwbg86x0XOYw3ZJiMOKIUvAz05daeYqVFr8zHG5C4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cgMusYhwJSbWHlAb1qARRuDjgMp/KlqbUtcLy/CBff2r6RClGsF7QVy00KrfXsL4B
	 SqL89Ac9sUHXD5sLKuRpbFvRj62EuoxfQeeMV7Imfz2BgoQ8DHEn4ka7nFnPfxLQIP
	 Cq8cQbfWBO3+qREdiT67URVO8Wc3ypWz0bWGummc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 312/423] ublk: make sure ubq->canceling is set when queue is frozen
Date: Tue,  8 Apr 2025 12:50:38 +0200
Message-ID: <20250408104853.070758963@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 8741d0737921ec1c03cf59aebf4d01400c2b461a ]

Now ublk driver depends on `ubq->canceling` for deciding if the request
can be dispatched via uring_cmd & io_uring_cmd_complete_in_task().

Once ubq->canceling is set, the uring_cmd can be done via ublk_cancel_cmd()
and io_uring_cmd_done().

So set ubq->canceling when queue is frozen, this way makes sure that the
flag can be observed from ublk_queue_rq() reliably, and avoids
use-after-free on uring_cmd.

Fixes: 216c8f5ef0f2 ("ublk: replace monitor with cancelable uring_cmd")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20250327095123.179113-2-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 39 +++++++++++++++++++++++++++++----------
 1 file changed, 29 insertions(+), 10 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index c7d728d686e5a..79b7bd8bfd458 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1416,17 +1416,27 @@ static void ublk_abort_queue(struct ublk_device *ub, struct ublk_queue *ubq)
 	}
 }
 
+/* Must be called when queue is frozen */
+static bool ublk_mark_queue_canceling(struct ublk_queue *ubq)
+{
+	bool canceled;
+
+	spin_lock(&ubq->cancel_lock);
+	canceled = ubq->canceling;
+	if (!canceled)
+		ubq->canceling = true;
+	spin_unlock(&ubq->cancel_lock);
+
+	return canceled;
+}
+
 static bool ublk_abort_requests(struct ublk_device *ub, struct ublk_queue *ubq)
 {
+	bool was_canceled = ubq->canceling;
 	struct gendisk *disk;
 
-	spin_lock(&ubq->cancel_lock);
-	if (ubq->canceling) {
-		spin_unlock(&ubq->cancel_lock);
+	if (was_canceled)
 		return false;
-	}
-	ubq->canceling = true;
-	spin_unlock(&ubq->cancel_lock);
 
 	spin_lock(&ub->lock);
 	disk = ub->ub_disk;
@@ -1438,14 +1448,23 @@ static bool ublk_abort_requests(struct ublk_device *ub, struct ublk_queue *ubq)
 	if (!disk)
 		return false;
 
-	/* Now we are serialized with ublk_queue_rq() */
+	/*
+	 * Now we are serialized with ublk_queue_rq()
+	 *
+	 * Make sure that ubq->canceling is set when queue is frozen,
+	 * because ublk_queue_rq() has to rely on this flag for avoiding to
+	 * touch completed uring_cmd
+	 */
 	blk_mq_quiesce_queue(disk->queue);
-	/* abort queue is for making forward progress */
-	ublk_abort_queue(ub, ubq);
+	was_canceled = ublk_mark_queue_canceling(ubq);
+	if (!was_canceled) {
+		/* abort queue is for making forward progress */
+		ublk_abort_queue(ub, ubq);
+	}
 	blk_mq_unquiesce_queue(disk->queue);
 	put_device(disk_to_dev(disk));
 
-	return true;
+	return !was_canceled;
 }
 
 static void ublk_cancel_cmd(struct ublk_queue *ubq, struct ublk_io *io,
-- 
2.39.5



