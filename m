Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76CA846AF14;
	Tue, 16 Jun 2026 16:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627041; cv=none; b=Jx5pDHdgSHasd46I3jDlzfQDw0ZK8Be5St/StvvW6RLZnfTYRFSoadBYwIrJYhN40eN/yxWwi2CFu3DPcpuv3DJvuVwsFJPnJOaRPkITFIGsFeTTGGYGRHpbTi1N2Q2yxqxUr3hY+S8P7oWErEpQHG6N3zEAhJsgyomaSeoSNXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627041; c=relaxed/simple;
	bh=9FxkNbPWn02faFOZI+CJUUcqJbogWgi8a3KOjlFLiI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G72H/v+1yHcdqD+EWmmYMV5EXysKhzgDq2Ja99gnnihxb1LJgBgKUHlqCmXZPKwz8boltv0yuBhinqn1GnnB+v4CcvtJLlwzu1szcgcq0bFJJFyp82cbZ7Qsm67/aoXFP9jUa+UptZr7dJaPJfv+i8dAeBk7i1NBUZ6WglzZlKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n2DuZiAg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n2DuZiAg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56D31F000E9;
	Tue, 16 Jun 2026 16:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627040;
	bh=o0fSrUwhDfESkm6WXic/mFIX0Y4LBl0XanCZugnyLSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n2DuZiAgyJ7XskhY3Bews5RCmcOAHiYXDalO4k7hl2fIPKfEMJHXX6prKrp/+eJIK
	 isAC10PdilXYEVaD1wAKSbmS5bqhHJqwBeAYrwBznoCoGz5O0e44cAwMGo/08ot5FL
	 tTOwehTb/5wgl6FzoVBNoQu2HXrypiYetDH08SlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Tejun Heo <tj@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 110/261] writeback: Fix use after free in inode_switch_wbs_work_fn()
Date: Tue, 16 Jun 2026 20:29:08 +0530
Message-ID: <20260616145050.162644961@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

From: Jan Kara <jack@suse.cz>

[ Upstream commit 6689f01d6740cf358932b3e97ee968c6099800d9 ]

inode_switch_wbs_work_fn() has a loop like:

  wb_get(new_wb);
  while (1) {
    list = llist_del_all(&new_wb->switch_wbs_ctxs);
    /* Nothing to do? */
    if (!list)
      break;
    ... process the items ...
  }

Now adding of items to the list looks like:

wb_queue_isw()
  if (llist_add(&isw->list, &wb->switch_wbs_ctxs))
    queue_work(isw_wq, &wb->switch_work);

Because inode_switch_wbs_work_fn() loops when processing isw items, it
can happen that wb->switch_work is pending while wb->switch_wbs_ctxs is
empty. This is a problem because in that case wb can get freed (no isw
items -> no wb reference) while the work is still pending causing
use-after-free issues.

We cannot just fix this by cancelling work when freeing wb because that
could still trigger problematic 0 -> 1 transitions on wb refcount due to
wb_get() in inode_switch_wbs_work_fn(). It could be all handled with
more careful code but that seems unnecessarily complex so let's avoid
that until it is proven that the looping actually brings practical
benefit. Just remove the loop from inode_switch_wbs_work_fn() instead.
That way when wb_queue_isw() queues work, we are guaranteed we have
added the first item to wb->switch_wbs_ctxs and nobody is going to
remove it (and drop the wb reference it holds) until the queued work
runs.

Fixes: e1b849cfa6b6 ("writeback: Avoid contention on wb->list_lock when switching inodes")
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260413093618.17244-2-jack@suse.cz
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fs-writeback.c | 36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index a8d21a5f354859..e8afd4fd26f98e 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -559,28 +559,30 @@ void inode_switch_wbs_work_fn(struct work_struct *work)
 	struct inode_switch_wbs_context *isw, *next_isw;
 	struct llist_node *list;
 
+	list = llist_del_all(&new_wb->switch_wbs_ctxs);
 	/*
-	 * Grab out reference to wb so that it cannot get freed under us
+	 * Nothing to do? That would be a problem as references held by isw
+	 * items protect wb from freeing...
+	 */
+	if (WARN_ON_ONCE(!list))
+		return;
+
+	/*
+	 * Grab our reference to wb so that it cannot get freed under us
 	 * after we process all the isw items.
 	 */
 	wb_get(new_wb);
-	while (1) {
-		list = llist_del_all(&new_wb->switch_wbs_ctxs);
-		/* Nothing to do? */
-		if (!list)
-			break;
-		/*
-		 * In addition to synchronizing among switchers, I_WB_SWITCH
-		 * tells the RCU protected stat update paths to grab the i_page
-		 * lock so that stat transfer can synchronize against them.
-		 * Let's continue after I_WB_SWITCH is guaranteed to be
-		 * visible.
-		 */
-		synchronize_rcu();
+	/*
+	 * In addition to synchronizing among switchers, I_WB_SWITCH
+	 * tells the RCU protected stat update paths to grab the i_page
+	 * lock so that stat transfer can synchronize against them.
+	 * Let's continue after I_WB_SWITCH is guaranteed to be
+	 * visible.
+	 */
+	synchronize_rcu();
 
-		llist_for_each_entry_safe(isw, next_isw, list, list)
-			process_inode_switch_wbs(new_wb, isw);
-	}
+	llist_for_each_entry_safe(isw, next_isw, list, list)
+		process_inode_switch_wbs(new_wb, isw);
 	wb_put(new_wb);
 }
 
-- 
2.53.0



