Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA5228EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 13:57:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE200C433D2;
	Mon, 30 Jan 2023 13:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087027;
	bh=Vc+oqlFvOnG/SNB/9oKJRG0Cz+DFYU1NDZI8sYzoq8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fvXV8HSz6aYAjQ5JyOBjZTQX+MdHYbUUV9a5wRjRZByfwlNjGjyklT/3RaTDQWtI1
	 XJPzGnrIotY99/Uhr+n1CSYkhb7S623u6xS5nXZEFO4E5SSmpKNl5NjLXD0PCIc9G7
	 xv9JRHug2HSICb1Mn6bB4iot0egKMbY7x4DAh/PI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 036/313] block: factor out a blk_debugfs_remove helper
Date: Mon, 30 Jan 2023 14:47:51 +0100
Message-Id: <20230130134338.363861608@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 6fc75f309d291d328b4ea2f91bef0ff56e4bc7c2 ]

Split the debugfs removal from blk_unregister_queue into a helper so that
the it can be reused for blk_register_queue error handling.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20221114042637.1009333-3-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 49e4d04f0486 ("block: Drop spurious might_sleep() from blk_put_queue()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-sysfs.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 2b1cf0b2a5c7..3d6951a0b4e7 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -797,6 +797,19 @@ struct kobj_type blk_queue_ktype = {
 	.release	= blk_release_queue,
 };
 
+static void blk_debugfs_remove(struct gendisk *disk)
+{
+	struct request_queue *q = disk->queue;
+
+	mutex_lock(&q->debugfs_mutex);
+	blk_trace_shutdown(q);
+	debugfs_remove_recursive(q->debugfs_dir);
+	q->debugfs_dir = NULL;
+	q->sched_debugfs_dir = NULL;
+	q->rqos_debugfs_dir = NULL;
+	mutex_unlock(&q->debugfs_mutex);
+}
+
 /**
  * blk_register_queue - register a block layer queue with sysfs
  * @disk: Disk of which the request queue should be registered with sysfs.
@@ -922,11 +935,5 @@ void blk_unregister_queue(struct gendisk *disk)
 	kobject_del(&q->kobj);
 	mutex_unlock(&q->sysfs_dir_lock);
 
-	mutex_lock(&q->debugfs_mutex);
-	blk_trace_shutdown(q);
-	debugfs_remove_recursive(q->debugfs_dir);
-	q->debugfs_dir = NULL;
-	q->sched_debugfs_dir = NULL;
-	q->rqos_debugfs_dir = NULL;
-	mutex_unlock(&q->debugfs_mutex);
+	blk_debugfs_remove(disk);
 }
-- 
2.39.0



