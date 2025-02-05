Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C135C142E86;
	Wed,  5 Feb 2025 13:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763163; cv=none; b=L+SO8mnJB73DAlzgYD5zmCzPpzBDP2Bnm2YckzRvtVec5ffOv/mjmoiiyslaawHLfIN+RLzLVZghBJeENMDmog/+u8BAgBHpWnRUKvg/tRIkzWv7gTlfqG8X7oxCqLFnPQgj80g4WfJV+NVwzlrzziC2yj7uWumWz+uzJtF+Qng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763163; c=relaxed/simple;
	bh=XhKS0Y9bZ5hjPCLxmNj9LHxC8osaSApd0XSnDvVX/dQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b3PzCCgIr3fWKR61V9w1y3RxlLgYBaI3Z7vwYWEDDhjswpQb1Lkkdzk4qoI5KR7K12yGD9468YA02SyxRNwLkQ0QxkXg/lUrhU0VF0S0H3rC6q/Ciq+kkLcRnZnBdJdtRlENOQLB/H1QLZNCn0zWazNibnFMfstuBGB36kuSCoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o/A43TV/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o/A43TV/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4638FC4CED1;
	Wed,  5 Feb 2025 13:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763163;
	bh=XhKS0Y9bZ5hjPCLxmNj9LHxC8osaSApd0XSnDvVX/dQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o/A43TV/dMnYarw2sfv5ZmfdL18EwsqfXQQJ4sqXT3qgexCAZ6ziK4wOgsZ3xdUKC
	 E/xYbj6Y5nYg1Sj3XDvwwCbUlIsd91IO6cbSukl40vPOX1NIax/aaXUTkASoDCOOpE
	 7LoFuD0BMBxYATbTXGQIa7K7esbtpXk/4bRbtguQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 003/590] dlm: fix removal of rsb struct that is master and dir record
Date: Wed,  5 Feb 2025 14:35:58 +0100
Message-ID: <20250205134455.360981555@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 134129520beaf3339482c557361ea0bde709cf36 ]

An rsb struct was not being removed in the case where it
was both the master and the dir record.  This case (master
and dir node) was missed in the condition for doing add_scan()
from deactivate_rsb().  Fixing this triggers a related WARN_ON
that needs to be fixed, and requires adjusting where two
del_scan() calls are made.

Fixes: c217adfc8caa ("dlm: fix add_scan and del_scan usage")
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lock.c | 46 ++++++++++++++++++++++++++++++----------------
 1 file changed, 30 insertions(+), 16 deletions(-)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index dddedaef5e93d..0c01e4423ee2a 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -824,9 +824,12 @@ static int find_rsb_dir(struct dlm_ls *ls, const void *name, int len,
 		r->res_first_lkid = 0;
 	}
 
-	/* A dir record will not be on the scan list. */
-	if (r->res_dir_nodeid != our_nodeid)
-		del_scan(ls, r);
+	/* we always deactivate scan timer for the rsb, when
+	 * we move it out of the inactive state as rsb state
+	 * can be changed and scan timers are only for inactive
+	 * rsbs.
+	 */
+	del_scan(ls, r);
 	list_move(&r->res_slow_list, &ls->ls_slow_active);
 	rsb_clear_flag(r, RSB_INACTIVE);
 	kref_init(&r->res_ref); /* ref is now used in active state */
@@ -989,10 +992,10 @@ static int find_rsb_nodir(struct dlm_ls *ls, const void *name, int len,
 		r->res_nodeid = 0;
 	}
 
+	del_scan(ls, r);
 	list_move(&r->res_slow_list, &ls->ls_slow_active);
 	rsb_clear_flag(r, RSB_INACTIVE);
 	kref_init(&r->res_ref);
-	del_scan(ls, r);
 	write_unlock_bh(&ls->ls_rsbtbl_lock);
 
 	goto out;
@@ -1337,9 +1340,13 @@ static int _dlm_master_lookup(struct dlm_ls *ls, int from_nodeid, const char *na
 	__dlm_master_lookup(ls, r, our_nodeid, from_nodeid, true, flags,
 			    r_nodeid, result);
 
-	/* A dir record rsb should never be on scan list. */
-	/* Try to fix this with del_scan? */
-	WARN_ON(!list_empty(&r->res_scan_list));
+	/* A dir record rsb should never be on scan list.
+	 * Except when we are the dir and master node.
+	 * This function should only be called by the dir
+	 * node.
+	 */
+	WARN_ON(!list_empty(&r->res_scan_list) &&
+		r->res_master_nodeid != our_nodeid);
 
 	write_unlock_bh(&ls->ls_rsbtbl_lock);
 
@@ -1430,16 +1437,23 @@ static void deactivate_rsb(struct kref *kref)
 	list_move(&r->res_slow_list, &ls->ls_slow_inactive);
 
 	/*
-	 * When the rsb becomes unused:
-	 * - If it's not a dir record for a remote master rsb,
-	 *   then it is put on the scan list to be freed.
-	 * - If it's a dir record for a remote master rsb,
-	 *   then it is kept in the inactive state until
-	 *   receive_remove() from the master node.
+	 * When the rsb becomes unused, there are two possibilities:
+	 * 1. Leave the inactive rsb in place (don't remove it).
+	 * 2. Add it to the scan list to be removed.
+	 *
+	 * 1 is done when the rsb is acting as the dir record
+	 * for a remotely mastered rsb.  The rsb must be left
+	 * in place as an inactive rsb to act as the dir record.
+	 *
+	 * 2 is done when a) the rsb is not the master and not the
+	 * dir record, b) when the rsb is both the master and the
+	 * dir record, c) when the rsb is master but not dir record.
+	 *
+	 * (If no directory is used, the rsb can always be removed.)
 	 */
-	if (!dlm_no_directory(ls) &&
-	    (r->res_master_nodeid != our_nodeid) &&
-	    (dlm_dir_nodeid(r) != our_nodeid))
+	if (dlm_no_directory(ls) ||
+	    (r->res_master_nodeid == our_nodeid ||
+	     dlm_dir_nodeid(r) != our_nodeid))
 		add_scan(ls, r);
 
 	if (r->res_lvbptr) {
-- 
2.39.5



