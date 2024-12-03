Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916971E25E3;
	Tue,  3 Dec 2024 16:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242833; cv=none; b=uhsqwzfNtJuPB7C8GJqN8w+6YFTrKtG4mcC29TM0Z1zsmrCdXqncJMRrzOYuCciWhGjU+1qcYtcXXjC6dEaty0GuMmCGt/CmHPNwmP48dwjG1z8MFF+tQtogeLKptYv6gGhlFsy5hl4csn/FvNHYQLkXEMecWVKLoQq+H9cBrDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242833; c=relaxed/simple;
	bh=XlakH/4w1RRqPn4Z66+m8ILItioAyhDyBIhsjzODBMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IBD+5owJJ1AonSAwylY7M9SemiSzjYpOwmmxMdBLbK0fxcT0aOu0aZ7PPnot5qoRGe/lhPsDVwZs5hIHkchSomA5AfGvQXg9nd2gncz1bxkHIWE+1x1gTpLDnsjntMz3R8EAyU9ZSNJdzrk2P77fPuZDh4JCG8dQQHo/WTIz1Ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L4fDTS7T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L4fDTS7T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E99BC4CECF;
	Tue,  3 Dec 2024 16:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242833;
	bh=XlakH/4w1RRqPn4Z66+m8ILItioAyhDyBIhsjzODBMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L4fDTS7TXweTCVq8gDc+JWRhqjW822GeLZXacQULZr0sQo6KN2umv2AO75xQrw8bT
	 hN1Sg3PgQ4t8aIt9+nTe9nVaveJBKkk4MOQRpd0q+Vis6Fv1LwMepugvyRABDcUw9t
	 re5MMi0dhl3ytLulRQ6kRP5rwKdTczdj7+7CU8y8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 792/826] blk-mq: add non_owner variant of start_freeze/unfreeze queue APIs
Date: Tue,  3 Dec 2024 15:48:39 +0100
Message-ID: <20241203144814.654464132@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit 8acdd0e7bfadda6b5103f2960d293581954454ed ]

Add non_owner variant of start_freeze/unfreeze queue APIs, so that the
caller knows that what they are doing, and we can skip lockdep support
for non_owner variant in per-call level.

Prepare for supporting lockdep for freezing/unfreezing queue.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20241025003722.3630252-2-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 3802f73bd807 ("block: fix uaf for flush rq while iterating tags")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c         | 20 ++++++++++++++++++++
 include/linux/blk-mq.h |  2 ++
 2 files changed, 22 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index fbd63d189c740..0beed0ae0aeba 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -196,6 +196,26 @@ void blk_mq_unfreeze_queue(struct request_queue *q)
 }
 EXPORT_SYMBOL_GPL(blk_mq_unfreeze_queue);
 
+/*
+ * non_owner variant of blk_freeze_queue_start
+ *
+ * Unlike blk_freeze_queue_start, the queue doesn't need to be unfrozen
+ * by the same task.  This is fragile and should not be used if at all
+ * possible.
+ */
+void blk_freeze_queue_start_non_owner(struct request_queue *q)
+{
+	blk_freeze_queue_start(q);
+}
+EXPORT_SYMBOL_GPL(blk_freeze_queue_start_non_owner);
+
+/* non_owner variant of blk_mq_unfreeze_queue */
+void blk_mq_unfreeze_queue_non_owner(struct request_queue *q)
+{
+	__blk_mq_unfreeze_queue(q, false);
+}
+EXPORT_SYMBOL_GPL(blk_mq_unfreeze_queue_non_owner);
+
 /*
  * FIXME: replace the scsi_internal_device_*block_nowait() calls in the
  * mpt3sas driver such that this function can be removed.
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 4fecf46ef681b..c5063e0a38a05 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -925,6 +925,8 @@ void blk_freeze_queue_start(struct request_queue *q);
 void blk_mq_freeze_queue_wait(struct request_queue *q);
 int blk_mq_freeze_queue_wait_timeout(struct request_queue *q,
 				     unsigned long timeout);
+void blk_mq_unfreeze_queue_non_owner(struct request_queue *q);
+void blk_freeze_queue_start_non_owner(struct request_queue *q);
 
 void blk_mq_map_queues(struct blk_mq_queue_map *qmap);
 void blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set, int nr_hw_queues);
-- 
2.43.0



