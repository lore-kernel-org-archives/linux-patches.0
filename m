Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A23B8F70
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 19:54:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8424EC433C7;
	Sun, 16 Jul 2023 19:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537283;
	bh=Xn0/SXd3oC4MEoGrp9tZs65bUlTo8nFdT+pLdGs2c/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RlrIRmvDqSlvBzXlc3oUlgPsq7hZAmQQygj+lmnA+3T/KJKX3yeL84eMRot6KW0XG
	 8Aq5Hwh/j/lQh1/7sGij+ITxFZ9po2nQFrAuWvG5rLRvqzyaiOfDz30iBu99BjPkiM
	 UMGZ9bC4mGYT4U4qaj/nWcWnqVRB6g0Vr9aQK7go=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 041/800] block: fix blktrace debugfs entries leakage
Date: Sun, 16 Jul 2023 21:38:14 +0200
Message-ID: <20230716194950.048187130@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit dd7de3704af9989b780693d51eaea49a665bd9c2 ]

Commit 99d055b4fd4b ("block: remove per-disk debugfs files in
blk_unregister_queue") moves blk_trace_shutdown() from
blk_release_queue() to blk_unregister_queue(), this is safe if blktrace
is created through sysfs, however, there is a regression in corner
case.

blktrace can still be enabled after del_gendisk() through ioctl if
the disk is opened before del_gendisk(), and if blktrace is not shutdown
through ioctl before closing the disk, debugfs entries will be leaked.

Fix this problem by shutdown blktrace in disk_release(), this is safe
because blk_trace_remove() is reentrant.

Fixes: 99d055b4fd4b ("block: remove per-disk debugfs files in blk_unregister_queue")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20230610022003.2557284-4-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/genhd.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/block/genhd.c b/block/genhd.c
index 1cb489b927d50..bb895397e9385 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -25,8 +25,9 @@
 #include <linux/pm_runtime.h>
 #include <linux/badblocks.h>
 #include <linux/part_stat.h>
-#include "blk-throttle.h"
+#include <linux/blktrace_api.h>
 
+#include "blk-throttle.h"
 #include "blk.h"
 #include "blk-mq-sched.h"
 #include "blk-rq-qos.h"
@@ -1171,6 +1172,8 @@ static void disk_release(struct device *dev)
 	might_sleep();
 	WARN_ON_ONCE(disk_live(disk));
 
+	blk_trace_remove(disk->queue);
+
 	/*
 	 * To undo the all initialization from blk_mq_init_allocated_queue in
 	 * case of a probe failure where add_disk is never called we have to
-- 
2.39.2



