Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5AD4221DB6;
	Fri, 24 Apr 2026 13:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777038158; cv=none; b=TgV1/BNH2PFNjlovRB6Lx/quLq0mJtbvAsacVs0wch8IzY6spdOJZhw3nUjeqmV6anc7tYUM0ACXiicFbigguhoxgZljQ+dCBLEd35JyI1yF+dUkBh7yqF93DwPETQl5WAYWGiIzSXUtvM1vjTAs58DmDoBDazobQTC0NW7MxAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777038158; c=relaxed/simple;
	bh=QgL6JtZFyFNzw2H+Tr3ShFZcwUFvIZD9vnSJNDJhIOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ub8moxCOsPlsB/6/4740snhHgl080pfBvb/UMnMcFzho1/HNe6Mc7B2FytHNEf48pJ11G7oAcQzAtdzoFYYMCxpBSoC17dkkMfMT6yxzTE/KYLdJYLO4mzXYdihHQCLP1jcHCYoBWxHhLlrUYJojBzZNF0RBUWMXISkYu9BLuh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ko4zT96B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ko4zT96B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CD33C19425;
	Fri, 24 Apr 2026 13:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777038158;
	bh=QgL6JtZFyFNzw2H+Tr3ShFZcwUFvIZD9vnSJNDJhIOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ko4zT96BS47qDlQxP0jcK5Pyc37ItWyn6mAwqyHmbJ1XeZo2u7duxkg91l89Db0Tr
	 iDE7ZYOX66qoSNgirSNNCewuU+X+r4AXAR6cXSm7R2Mibiv71gQhbHAI6lldppOP1c
	 v5874XpgljRk2suygjDaOLYJjSY8gxztuCF20ghw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Tejun Heo <tj@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.18 46/55] writeback: Fix use after free in inode_switch_wbs_work_fn()
Date: Fri, 24 Apr 2026 15:31:25 +0200
Message-ID: <20260424132439.600334826@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132430.006424517@linuxfoundation.org>
References: <20260424132430.006424517@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 6689f01d6740cf358932b3e97ee968c6099800d9 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fs-writeback.c |   36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -558,28 +558,30 @@ void inode_switch_wbs_work_fn(struct wor
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
 


