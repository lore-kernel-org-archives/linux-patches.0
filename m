Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0BF22DF9F;
	Tue, 20 Feb 2024 21:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464162; cv=none; b=I8RGpuptYsyZPKAODvWhLJ0s+8K9UMZvxc1YxmBM6rIn7a3tdEkX9i2umf8ktmWllgY+a8tr7ODztmIh4PhFgWDdtfKRiCmg3XmaTJlX0DdkB4KZdcPgfWmT9g4XxH3cZSnf6sYa6Trzdq84M0zzhH54VBpUC+2gvJrgiWnBZiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464162; c=relaxed/simple;
	bh=F5A9KnQqu0t2QMKvdXR/mHSZUP3Y2t3ly0YslMK2YnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tGu7HW+anczO42uRRUOBCIDzdpZvsHqBF+sb5J10wTA/Q36tqt2iaRAlSjo/o5cdIAwEXdjeTayKvkLygOt1jaVMfgAqKTfUduNHa3MhaqACkwygn7MIMa/4ZXXEG4VBh20rtFwKclI3MWs3ecezAZjCUOlx23jHdToHW+f9uho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gFKOaelv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gFKOaelv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EE78C433C7;
	Tue, 20 Feb 2024 21:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464162;
	bh=F5A9KnQqu0t2QMKvdXR/mHSZUP3Y2t3ly0YslMK2YnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gFKOaelvBasMiaKVjdgaTPTWQQ7XDPifnofngsCmGu1eDly8VD9EOr3IJUATz+Fhi
	 ZpZKalUcAZzO7W2foInxy9uBtd7CXOi92nB28HghI0p+PgzGFF2tESVklg6hdj5stn
	 v3vk/gFRf2zHsyL0JLLXRUgEJd83CeJOm8+FgKKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 243/331] blk-wbt: Fix detection of dirty-throttled tasks
Date: Tue, 20 Feb 2024 21:55:59 +0100
Message-ID: <20240220205645.440266432@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

From: Jan Kara <jack@suse.cz>

commit f814bdda774c183b0cc15ec8f3b6e7c6f4527ba5 upstream.

The detection of dirty-throttled tasks in blk-wbt has been subtly broken
since its beginning in 2016. Namely if we are doing cgroup writeback and
the throttled task is not in the root cgroup, balance_dirty_pages() will
set dirty_sleep for the non-root bdi_writeback structure. However
blk-wbt checks dirty_sleep only in the root cgroup bdi_writeback
structure. Thus detection of recently throttled tasks is not working in
this case (we noticed this when we switched to cgroup v2 and suddently
writeback was slow).

Since blk-wbt has no easy way to get to proper bdi_writeback and
furthermore its intention has always been to work on the whole device
rather than on individual cgroups, just move the dirty_sleep timestamp
from bdi_writeback to backing_dev_info. That fixes the checking for
recently throttled task and saves memory for everybody as a bonus.

CC: stable@vger.kernel.org
Fixes: b57d74aff9ab ("writeback: track if we're sleeping on progress in balance_dirty_pages()")
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20240123175826.21452-1-jack@suse.cz
[axboe: fixup indentation errors]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-wbt.c                  |    4 ++--
 include/linux/backing-dev-defs.h |    7 +++++--
 mm/backing-dev.c                 |    2 +-
 mm/page-writeback.c              |    2 +-
 4 files changed, 9 insertions(+), 6 deletions(-)

--- a/block/blk-wbt.c
+++ b/block/blk-wbt.c
@@ -165,9 +165,9 @@ static void wb_timestamp(struct rq_wb *r
  */
 static bool wb_recent_wait(struct rq_wb *rwb)
 {
-	struct bdi_writeback *wb = &rwb->rqos.disk->bdi->wb;
+	struct backing_dev_info *bdi = rwb->rqos.disk->bdi;
 
-	return time_before(jiffies, wb->dirty_sleep + HZ);
+	return time_before(jiffies, bdi->last_bdp_sleep + HZ);
 }
 
 static inline struct rq_wait *get_rq_wait(struct rq_wb *rwb,
--- a/include/linux/backing-dev-defs.h
+++ b/include/linux/backing-dev-defs.h
@@ -141,8 +141,6 @@ struct bdi_writeback {
 	struct delayed_work dwork;	/* work item used for writeback */
 	struct delayed_work bw_dwork;	/* work item used for bandwidth estimate */
 
-	unsigned long dirty_sleep;	/* last wait */
-
 	struct list_head bdi_node;	/* anchored at bdi->wb_list */
 
 #ifdef CONFIG_CGROUP_WRITEBACK
@@ -179,6 +177,11 @@ struct backing_dev_info {
 	 * any dirty wbs, which is depended upon by bdi_has_dirty().
 	 */
 	atomic_long_t tot_write_bandwidth;
+	/*
+	 * Jiffies when last process was dirty throttled on this bdi. Used by
+	 * blk-wbt.
+	 */
+	unsigned long last_bdp_sleep;
 
 	struct bdi_writeback wb;  /* the root writeback info for this bdi */
 	struct list_head wb_list; /* list of all wbs */
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -436,7 +436,6 @@ static int wb_init(struct bdi_writeback
 	INIT_LIST_HEAD(&wb->work_list);
 	INIT_DELAYED_WORK(&wb->dwork, wb_workfn);
 	INIT_DELAYED_WORK(&wb->bw_dwork, wb_update_bandwidth_workfn);
-	wb->dirty_sleep = jiffies;
 
 	err = fprop_local_init_percpu(&wb->completions, gfp);
 	if (err)
@@ -921,6 +920,7 @@ int bdi_init(struct backing_dev_info *bd
 	INIT_LIST_HEAD(&bdi->bdi_list);
 	INIT_LIST_HEAD(&bdi->wb_list);
 	init_waitqueue_head(&bdi->wb_waitq);
+	bdi->last_bdp_sleep = jiffies;
 
 	return cgwb_bdi_init(bdi);
 }
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1921,7 +1921,7 @@ pause:
 			break;
 		}
 		__set_current_state(TASK_KILLABLE);
-		wb->dirty_sleep = now;
+		bdi->last_bdp_sleep = jiffies;
 		io_schedule_timeout(pause);
 
 		current->dirty_paused_when = now + pause;


