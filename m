Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BFD318A95D;
	Fri, 27 Sep 2024 12:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440014; cv=none; b=gGOH7NsIlHvrgBOFkVfQGrYgpBZV5sFd4V65V4vc07/kdoPzsCUe+0RCD246kydgOEP3QyVDdDw2HZ7Rm14GvV18101vbpoM7bAz1S5TPnFr2BrJdzcWL11rwTkyl0eeJewET2jBnDlIIoLK9wFnNBxb3gSQaNa1Fn8TV/2InXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440014; c=relaxed/simple;
	bh=jHZVW6jPse82CY2XbrfXtYQp+bnb2TCCEEaxYC0n/rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lUSLiybIFSUMg7xQM+cc3gV91JcbitbujRZP1XmJr6r66QlYwAKG2LrQm0bBxjrXOEZ+E5GxqS/agvv1FhN9xY6wpCXf51DB8+O1NeMq45SL4qPkhknglEe3VuIIlwqVJxZSVMQ6dJu1txzvrBPAMpSOQPkhs+Vjb4Ok5xsiIus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uhJHzMya; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uhJHzMya"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1114C4CEC4;
	Fri, 27 Sep 2024 12:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440014;
	bh=jHZVW6jPse82CY2XbrfXtYQp+bnb2TCCEEaxYC0n/rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uhJHzMyazsSk9FpJGmF/pFM/2mq/O07kzWdv+kb3ancfYYB55rquAU16XNGRhnIXm
	 yqvd8bV2kw3i6WrpVFWxJ/JDyLZJWkRMVnARhMQ/kSrLa3m+lGcQqsWhVG1i8w0ify
	 5Yo8WOQ9v2gC4tpEeKaoNZXJVvDhWYWam/IA1agE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yibin Ding <yibin.ding@unisoc.com>,
	Hongyu Jin <hongyu.jin@unisoc.com>,
	Eric Biggers <ebiggers@google.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 35/54] block: Fix where bio IO priority gets set
Date: Fri, 27 Sep 2024 14:23:27 +0200
Message-ID: <20240927121721.162565262@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.714627278@linuxfoundation.org>
References: <20240927121719.714627278@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongyu Jin <hongyu.jin@unisoc.com>

[ Upstream commit f3c89983cb4fc00be64eb0d5cbcfcdf2cacb965e ]

Commit 82b74cac2849 ("blk-ioprio: Convert from rqos policy to direct
call") pushed setting bio I/O priority down into blk_mq_submit_bio()
-- which is too low within block core's submit_bio() because it
skips setting I/O priority for block drivers that implement
fops->submit_bio() (e.g. DM, MD, etc).

Fix this by moving bio_set_ioprio() up from blk-mq.c to blk-core.c and
call it from submit_bio().  This ensures all block drivers call
bio_set_ioprio() during initial bio submission.

Fixes: a78418e6a04c ("block: Always initialize bio IO priority on submit")
Co-developed-by: Yibin Ding <yibin.ding@unisoc.com>
Signed-off-by: Yibin Ding <yibin.ding@unisoc.com>
Signed-off-by: Hongyu Jin <hongyu.jin@unisoc.com>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>
[snitzer: revised commit header]
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20240130202638.62600-2-snitzer@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-core.c | 10 ++++++++++
 block/blk-mq.c   | 10 ----------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index bf058cea9016a..4f25d2c4bc705 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -49,6 +49,7 @@
 #include "blk-pm.h"
 #include "blk-cgroup.h"
 #include "blk-throttle.h"
+#include "blk-ioprio.h"
 
 struct dentry *blk_debugfs_root;
 
@@ -819,6 +820,14 @@ void submit_bio_noacct(struct bio *bio)
 }
 EXPORT_SYMBOL(submit_bio_noacct);
 
+static void bio_set_ioprio(struct bio *bio)
+{
+	/* Nobody set ioprio so far? Initialize it based on task's nice value */
+	if (IOPRIO_PRIO_CLASS(bio->bi_ioprio) == IOPRIO_CLASS_NONE)
+		bio->bi_ioprio = get_current_ioprio();
+	blkcg_set_ioprio(bio);
+}
+
 /**
  * submit_bio - submit a bio to the block device layer for I/O
  * @bio: The &struct bio which describes the I/O
@@ -841,6 +850,7 @@ void submit_bio(struct bio *bio)
 		count_vm_events(PGPGOUT, bio_sectors(bio));
 	}
 
+	bio_set_ioprio(bio);
 	submit_bio_noacct(bio);
 }
 EXPORT_SYMBOL(submit_bio);
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 7cc315527a44c..733d72f4d1cc9 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -40,7 +40,6 @@
 #include "blk-stat.h"
 #include "blk-mq-sched.h"
 #include "blk-rq-qos.h"
-#include "blk-ioprio.h"
 
 static DEFINE_PER_CPU(struct llist_head, blk_cpu_done);
 static DEFINE_PER_CPU(call_single_data_t, blk_cpu_csd);
@@ -2956,14 +2955,6 @@ static bool blk_mq_can_use_cached_rq(struct request *rq, struct blk_plug *plug,
 	return true;
 }
 
-static void bio_set_ioprio(struct bio *bio)
-{
-	/* Nobody set ioprio so far? Initialize it based on task's nice value */
-	if (IOPRIO_PRIO_CLASS(bio->bi_ioprio) == IOPRIO_CLASS_NONE)
-		bio->bi_ioprio = get_current_ioprio();
-	blkcg_set_ioprio(bio);
-}
-
 /**
  * blk_mq_submit_bio - Create and send a request to block device.
  * @bio: Bio pointer.
@@ -2988,7 +2979,6 @@ void blk_mq_submit_bio(struct bio *bio)
 	blk_status_t ret;
 
 	bio = blk_queue_bounce(bio, q);
-	bio_set_ioprio(bio);
 
 	if (plug) {
 		rq = rq_list_peek(&plug->cached_rq);
-- 
2.43.0



