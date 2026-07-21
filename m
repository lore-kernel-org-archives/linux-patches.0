Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A84A3B4E87;
	Tue, 21 Jul 2026 21:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670636; cv=none; b=rFWFhPW6oVcpSWOuaeoFpyZRuC6YKXuSvJ2HZNO9ZLFjZ6r9JLYlOvq4CXusb37tVnUccelnGEB1Pyy1YzGEQunXq75hpah8g3IVuwJw0Q7cW/pEfQALnUZavMhO6z8n+YJmtZvNp0uqNXFJ976XI6T9QHdbe40OTSEn/MRns5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670636; c=relaxed/simple;
	bh=CPNNK9aYwkw8Yv0gHSIwiPNgwXlMkCoThRrtrTBDsMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HmpMtzekTjfWvcL6w7rUpPqtCE7+uJmQHwjZ/pKlNqGC0q1zHKFaQWbCwNQgSjJSdF9CHfAY9xw2R0lpLegM8cA09UqWmTFRhHqU4Lm0qlhcU2exHoQGBb/CP3nV46WFQ++Ibslu7aelySP5vHRsA7GmC9XTvzdPSKqrubHploI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VNuNsxOx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VNuNsxOx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3609C1F000E9;
	Tue, 21 Jul 2026 21:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670634;
	bh=JJfXYl2TMxJ3UddHowFtd4vjXnXj1g3l5L2k+aYIc0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VNuNsxOxbvbskGImAez0SpvoSE3Zjlcj+jxQKzmDLKpYsbaND28jX5u/ArHFrfWHk
	 cfuPZ28Bh6WOcSrDNIgtVKNdTci9+SiVGYLnduV1qAFy2IEtViUiUdHw0X0ePT9Xvl
	 kMymRAPFDx2FPNgLVQdpKdn0dqTdjyzHKGnkVbFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1006/1067] writeback: Avoid contention on wb->list_lock when switching inodes
Date: Tue, 21 Jul 2026 17:26:47 +0200
Message-ID: <20260721152447.074408502@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit e1b849cfa6b61f1c866a908c9e8dd9b5aaab820b ]

There can be multiple inode switch works that are trying to switch
inodes to / from the same wb. This can happen in particular if some
cgroup exits which owns many (thousands) inodes and we need to switch
them all. In this case several inode_switch_wbs_work_fn() instances will
be just spinning on the same wb->list_lock while only one of them makes
forward progress. This wastes CPU cycles and quickly leads to softlockup
reports and unusable system.

Instead of running several inode_switch_wbs_work_fn() instances in
parallel switching to the same wb and contending on wb->list_lock, run
just one work item per wb and manage a queue of isw items switching to
this wb.

Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Stable-dep-of: cba38ec4cbd3 ("writeback: fix race between cgroup_writeback_umount() and inode_switch_wbs()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fs-writeback.c                |   99 ++++++++++++++++++++++++---------------
 include/linux/backing-dev-defs.h |    4 +
 include/linux/writeback.h        |    2 
 mm/backing-dev.c                 |    5 +
 4 files changed, 74 insertions(+), 36 deletions(-)

--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -343,7 +343,8 @@ static struct bdi_writeback *inode_to_wb
 }
 
 struct inode_switch_wbs_context {
-	struct rcu_work		work;
+	/* List of queued switching contexts for the wb */
+	struct llist_node	list;
 
 	/*
 	 * Multiple inodes can be switched at once.  The switching procedure
@@ -353,7 +354,6 @@ struct inode_switch_wbs_context {
 	 * array embedded into struct inode_switch_wbs_context.  Otherwise
 	 * an inode could be left in a non-consistent state.
 	 */
-	struct bdi_writeback	*new_wb;
 	struct inode		*inodes[];
 };
 
@@ -462,13 +462,11 @@ skip_switch:
 	return switched;
 }
 
-static void inode_switch_wbs_work_fn(struct work_struct *work)
+static void process_inode_switch_wbs(struct bdi_writeback *new_wb,
+				     struct inode_switch_wbs_context *isw)
 {
-	struct inode_switch_wbs_context *isw =
-		container_of(to_rcu_work(work), struct inode_switch_wbs_context, work);
 	struct backing_dev_info *bdi = inode_to_bdi(isw->inodes[0]);
 	struct bdi_writeback *old_wb = isw->inodes[0]->i_wb;
-	struct bdi_writeback *new_wb = isw->new_wb;
 	unsigned long nr_switched = 0;
 	struct inode **inodep;
 
@@ -528,6 +526,38 @@ relock:
 	atomic_dec(&isw_nr_in_flight);
 }
 
+void inode_switch_wbs_work_fn(struct work_struct *work)
+{
+	struct bdi_writeback *new_wb = container_of(work, struct bdi_writeback,
+						    switch_work);
+	struct inode_switch_wbs_context *isw, *next_isw;
+	struct llist_node *list;
+
+	/*
+	 * Grab out reference to wb so that it cannot get freed under us
+	 * after we process all the isw items.
+	 */
+	wb_get(new_wb);
+	while (1) {
+		list = llist_del_all(&new_wb->switch_wbs_ctxs);
+		/* Nothing to do? */
+		if (!list)
+			break;
+		/*
+		 * In addition to synchronizing among switchers, I_WB_SWITCH
+		 * tells the RCU protected stat update paths to grab the i_page
+		 * lock so that stat transfer can synchronize against them.
+		 * Let's continue after I_WB_SWITCH is guaranteed to be
+		 * visible.
+		 */
+		synchronize_rcu();
+
+		llist_for_each_entry_safe(isw, next_isw, list, list)
+			process_inode_switch_wbs(new_wb, isw);
+	}
+	wb_put(new_wb);
+}
+
 static bool inode_prepare_wbs_switch(struct inode *inode,
 				     struct bdi_writeback *new_wb)
 {
@@ -557,6 +587,13 @@ static bool inode_prepare_wbs_switch(str
 	return true;
 }
 
+static void wb_queue_isw(struct bdi_writeback *wb,
+			 struct inode_switch_wbs_context *isw)
+{
+	if (llist_add(&isw->list, &wb->switch_wbs_ctxs))
+		queue_work(isw_wq, &wb->switch_work);
+}
+
 /**
  * inode_switch_wbs - change the wb association of an inode
  * @inode: target inode
@@ -570,6 +607,7 @@ static void inode_switch_wbs(struct inod
 	struct backing_dev_info *bdi = inode_to_bdi(inode);
 	struct cgroup_subsys_state *memcg_css;
 	struct inode_switch_wbs_context *isw;
+	struct bdi_writeback *new_wb = NULL;
 
 	/* noop if seems to be already in progress */
 	if (inode->i_state & I_WB_SWITCH)
@@ -594,40 +632,34 @@ static void inode_switch_wbs(struct inod
 	if (!memcg_css)
 		goto out_free;
 
-	isw->new_wb = wb_get_create(bdi, memcg_css, GFP_ATOMIC);
+	new_wb = wb_get_create(bdi, memcg_css, GFP_ATOMIC);
 	css_put(memcg_css);
-	if (!isw->new_wb)
+	if (!new_wb)
 		goto out_free;
 
-	if (!inode_prepare_wbs_switch(inode, isw->new_wb))
+	if (!inode_prepare_wbs_switch(inode, new_wb))
 		goto out_free;
 
 	isw->inodes[0] = inode;
 
-	/*
-	 * In addition to synchronizing among switchers, I_WB_SWITCH tells
-	 * the RCU protected stat update paths to grab the i_page
-	 * lock so that stat transfer can synchronize against them.
-	 * Let's continue after I_WB_SWITCH is guaranteed to be visible.
-	 */
-	INIT_RCU_WORK(&isw->work, inode_switch_wbs_work_fn);
-	queue_rcu_work(isw_wq, &isw->work);
+	wb_queue_isw(new_wb, isw);
 	return;
 
 out_free:
 	atomic_dec(&isw_nr_in_flight);
-	if (isw->new_wb)
-		wb_put(isw->new_wb);
+	if (new_wb)
+		wb_put(new_wb);
 	kfree(isw);
 }
 
-static bool isw_prepare_wbs_switch(struct inode_switch_wbs_context *isw,
+static bool isw_prepare_wbs_switch(struct bdi_writeback *new_wb,
+				   struct inode_switch_wbs_context *isw,
 				   struct list_head *list, int *nr)
 {
 	struct inode *inode;
 
 	list_for_each_entry(inode, list, i_io_list) {
-		if (!inode_prepare_wbs_switch(inode, isw->new_wb))
+		if (!inode_prepare_wbs_switch(inode, new_wb))
 			continue;
 
 		isw->inodes[*nr] = inode;
@@ -651,6 +683,7 @@ bool cleanup_offline_cgwb(struct bdi_wri
 {
 	struct cgroup_subsys_state *memcg_css;
 	struct inode_switch_wbs_context *isw;
+	struct bdi_writeback *new_wb;
 	int nr;
 	bool restart = false;
 
@@ -663,12 +696,12 @@ bool cleanup_offline_cgwb(struct bdi_wri
 
 	for (memcg_css = wb->memcg_css->parent; memcg_css;
 	     memcg_css = memcg_css->parent) {
-		isw->new_wb = wb_get_create(wb->bdi, memcg_css, GFP_KERNEL);
-		if (isw->new_wb)
+		new_wb = wb_get_create(wb->bdi, memcg_css, GFP_KERNEL);
+		if (new_wb)
 			break;
 	}
-	if (unlikely(!isw->new_wb))
-		isw->new_wb = &wb->bdi->wb; /* wb_get() is noop for bdi's wb */
+	if (unlikely(!new_wb))
+		new_wb = &wb->bdi->wb; /* wb_get() is noop for bdi's wb */
 
 	nr = 0;
 	spin_lock(&wb->list_lock);
@@ -680,27 +713,21 @@ bool cleanup_offline_cgwb(struct bdi_wri
 	 * bandwidth restrictions, as writeback of inode metadata is not
 	 * accounted for.
 	 */
-	restart = isw_prepare_wbs_switch(isw, &wb->b_attached, &nr);
+	restart = isw_prepare_wbs_switch(new_wb, isw, &wb->b_attached, &nr);
 	if (!restart)
-		restart = isw_prepare_wbs_switch(isw, &wb->b_dirty_time, &nr);
+		restart = isw_prepare_wbs_switch(new_wb, isw, &wb->b_dirty_time,
+						 &nr);
 	spin_unlock(&wb->list_lock);
 
 	/* no attached inodes? bail out */
 	if (nr == 0) {
 		atomic_dec(&isw_nr_in_flight);
-		wb_put(isw->new_wb);
+		wb_put(new_wb);
 		kfree(isw);
 		return restart;
 	}
 
-	/*
-	 * In addition to synchronizing among switchers, I_WB_SWITCH tells
-	 * the RCU protected stat update paths to grab the i_page
-	 * lock so that stat transfer can synchronize against them.
-	 * Let's continue after I_WB_SWITCH is guaranteed to be visible.
-	 */
-	INIT_RCU_WORK(&isw->work, inode_switch_wbs_work_fn);
-	queue_rcu_work(isw_wq, &isw->work);
+	wb_queue_isw(new_wb, isw);
 
 	return restart;
 }
--- a/include/linux/backing-dev-defs.h
+++ b/include/linux/backing-dev-defs.h
@@ -154,6 +154,10 @@ struct bdi_writeback {
 	struct list_head blkcg_node;	/* anchored at blkcg->cgwb_list */
 	struct list_head b_attached;	/* attached inodes, protected by list_lock */
 	struct list_head offline_node;	/* anchored at offline_cgwbs */
+	struct work_struct switch_work;	/* work used to perform inode switching
+					 * to this wb */
+	struct llist_head switch_wbs_ctxs;	/* queued contexts for
+						 * writeback switching */
 
 	union {
 		struct work_struct release_work;
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -288,6 +288,8 @@ static inline void wbc_init_bio(struct w
 		bio_associate_blkg_from_css(bio, wbc->wb->blkcg_css);
 }
 
+void inode_switch_wbs_work_fn(struct work_struct *work);
+
 #else	/* CONFIG_CGROUP_WRITEBACK */
 
 static inline void inode_attach_wb(struct inode *inode, struct page *page)
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -415,6 +415,7 @@ static void cgwb_release_workfn(struct w
 	wb_exit(wb);
 	bdi_put(bdi);
 	WARN_ON_ONCE(!list_empty(&wb->b_attached));
+	WARN_ON_ONCE(work_pending(&wb->switch_work));
 	call_rcu(&wb->rcu, cgwb_free_rcu);
 }
 
@@ -491,6 +492,8 @@ static int cgwb_create(struct backing_de
 	wb->memcg_css = memcg_css;
 	wb->blkcg_css = blkcg_css;
 	INIT_LIST_HEAD(&wb->b_attached);
+	INIT_WORK(&wb->switch_work, inode_switch_wbs_work_fn);
+	init_llist_head(&wb->switch_wbs_ctxs);
 	INIT_WORK(&wb->release_work, cgwb_release_workfn);
 	set_bit(WB_registered, &wb->state);
 	bdi_get(bdi);
@@ -624,6 +627,8 @@ static int cgwb_bdi_init(struct backing_
 	if (!ret) {
 		bdi->wb.memcg_css = &root_mem_cgroup->css;
 		bdi->wb.blkcg_css = blkcg_root_css;
+		INIT_WORK(&bdi->wb.switch_work, inode_switch_wbs_work_fn);
+		init_llist_head(&bdi->wb.switch_wbs_ctxs);
 	}
 	return ret;
 }


