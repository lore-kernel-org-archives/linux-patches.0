Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6681C2DB1;
	Tue, 27 Aug 2024 15:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772768; cv=none; b=swAL+YB4XSDnEJEDNmcxf6N7jUS09dDXHI/6F/0o6RIyBk6zWPYjJlqq4NHNoYHeHCtNNcTvQKWzGNXPKi9vF2tzPnkgOOCO3e1mgZ86qFN9QDGjtYzTa0GsQGjnxA1LDzimLTMxL2al6vyC8NBFNtwQ3sJTRVnuLb4F1qOPSyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772768; c=relaxed/simple;
	bh=+MuQKt2bX2k5QZPj5ZMPYuMPU6yYofG4uuPZq0bG1gw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e8kHmViAvfXPaCr9h71HZAxi405+78Lsvd6w09L6UgZwT9EKq6hdCADVhkQMxTzs1AC51aXw6dqRHojSxiFC9CYpPX97hQqm2yranOjsatjP7ql1K/gonLTvetFuMP4bDYx6wFme3nQS9DcpmjhaT9FB1E92CLre79q5cWY6/2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C1Hzczyl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C1Hzczyl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C727C61043;
	Tue, 27 Aug 2024 15:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772768;
	bh=+MuQKt2bX2k5QZPj5ZMPYuMPU6yYofG4uuPZq0bG1gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C1HzczylUUSkwYcRAsACmgafSdulOlLej67I99yvcEes9GbPC4DpPVFuT1nhb9mMx
	 sZlyf8pzkqQHet2X7ywvyxyGNDbGKTY/RPEgfctOpLjooY4IlWvTdDewql1MO0YwAv
	 iecEiCwou6X0IE23kR83TB0N3yvTygHPvSgzyFIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 6.1 314/321] gfs2: Remove LM_FLAG_PRIORITY flag
Date: Tue, 27 Aug 2024 16:40:22 +0200
Message-ID: <20240827143850.210718393@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Gruenbacher <agruenba@redhat.com>

commit 0b93bac2271e11beb980fca037a34a9819c7dc37 upstream.

The last user of this flag was removed in commit b77b4a4815a9 ("gfs2:
Rework freeze / thaw logic").

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/filesystems/gfs2-glocks.rst |    3 +--
 fs/gfs2/glock.c                           |   23 ++++++-----------------
 fs/gfs2/glock.h                           |    9 ---------
 fs/gfs2/lock_dlm.c                        |    5 -----
 4 files changed, 7 insertions(+), 33 deletions(-)

--- a/Documentation/filesystems/gfs2-glocks.rst
+++ b/Documentation/filesystems/gfs2-glocks.rst
@@ -20,8 +20,7 @@ The gl_holders list contains all the que
 just the holders) associated with the glock. If there are any
 held locks, then they will be contiguous entries at the head
 of the list. Locks are granted in strictly the order that they
-are queued, except for those marked LM_FLAG_PRIORITY which are
-used only during recovery, and even then only for journal locks.
+are queued.
 
 There are three lock states that users of the glock layer can request,
 namely shared (SH), deferred (DF) and exclusive (EX). Those translate
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -661,8 +661,7 @@ static void finish_xmote(struct gfs2_glo
 		if (gh && !test_bit(GLF_DEMOTE_IN_PROGRESS, &gl->gl_flags)) {
 			/* move to back of queue and try next entry */
 			if (ret & LM_OUT_CANCELED) {
-				if ((gh->gh_flags & LM_FLAG_PRIORITY) == 0)
-					list_move_tail(&gh->gh_list, &gl->gl_holders);
+				list_move_tail(&gh->gh_list, &gl->gl_holders);
 				gh = find_first_waiter(gl);
 				gl->gl_target = gh->gh_state;
 				goto retry;
@@ -749,8 +748,7 @@ __acquires(&gl->gl_lockref.lock)
 	    gh && !(gh->gh_flags & LM_FLAG_NOEXP))
 		goto skip_inval;
 
-	lck_flags &= (LM_FLAG_TRY | LM_FLAG_TRY_1CB | LM_FLAG_NOEXP |
-		      LM_FLAG_PRIORITY);
+	lck_flags &= (LM_FLAG_TRY | LM_FLAG_TRY_1CB | LM_FLAG_NOEXP);
 	GLOCK_BUG_ON(gl, gl->gl_state == target);
 	GLOCK_BUG_ON(gl, gl->gl_state == gl->gl_target);
 	if ((target == LM_ST_UNLOCKED || target == LM_ST_DEFERRED) &&
@@ -1528,27 +1526,20 @@ fail:
 		}
 		if (test_bit(HIF_HOLDER, &gh2->gh_iflags))
 			continue;
-		if (unlikely((gh->gh_flags & LM_FLAG_PRIORITY) && !insert_pt))
-			insert_pt = &gh2->gh_list;
 	}
 	trace_gfs2_glock_queue(gh, 1);
 	gfs2_glstats_inc(gl, GFS2_LKS_QCOUNT);
 	gfs2_sbstats_inc(gl, GFS2_LKS_QCOUNT);
 	if (likely(insert_pt == NULL)) {
 		list_add_tail(&gh->gh_list, &gl->gl_holders);
-		if (unlikely(gh->gh_flags & LM_FLAG_PRIORITY))
-			goto do_cancel;
 		return;
 	}
 	list_add_tail(&gh->gh_list, insert_pt);
-do_cancel:
 	gh = list_first_entry(&gl->gl_holders, struct gfs2_holder, gh_list);
-	if (!(gh->gh_flags & LM_FLAG_PRIORITY)) {
-		spin_unlock(&gl->gl_lockref.lock);
-		if (sdp->sd_lockstruct.ls_ops->lm_cancel)
-			sdp->sd_lockstruct.ls_ops->lm_cancel(gl);
-		spin_lock(&gl->gl_lockref.lock);
-	}
+	spin_unlock(&gl->gl_lockref.lock);
+	if (sdp->sd_lockstruct.ls_ops->lm_cancel)
+		sdp->sd_lockstruct.ls_ops->lm_cancel(gl);
+	spin_lock(&gl->gl_lockref.lock);
 	return;
 
 trap_recursive:
@@ -2296,8 +2287,6 @@ static const char *hflags2str(char *buf,
 		*p++ = 'e';
 	if (flags & LM_FLAG_ANY)
 		*p++ = 'A';
-	if (flags & LM_FLAG_PRIORITY)
-		*p++ = 'p';
 	if (flags & LM_FLAG_NODE_SCOPE)
 		*p++ = 'n';
 	if (flags & GL_ASYNC)
--- a/fs/gfs2/glock.h
+++ b/fs/gfs2/glock.h
@@ -68,14 +68,6 @@ enum {
  * also be granted in SHARED.  The preferred state is whichever is compatible
  * with other granted locks, or the specified state if no other locks exist.
  *
- * LM_FLAG_PRIORITY
- * Override fairness considerations.  Suppose a lock is held in a shared state
- * and there is a pending request for the deferred state.  A shared lock
- * request with the priority flag would be allowed to bypass the deferred
- * request and directly join the other shared lock.  A shared lock request
- * without the priority flag might be forced to wait until the deferred
- * requested had acquired and released the lock.
- *
  * LM_FLAG_NODE_SCOPE
  * This holder agrees to share the lock within this node. In other words,
  * the glock is held in EX mode according to DLM, but local holders on the
@@ -86,7 +78,6 @@ enum {
 #define LM_FLAG_TRY_1CB		0x0002
 #define LM_FLAG_NOEXP		0x0004
 #define LM_FLAG_ANY		0x0008
-#define LM_FLAG_PRIORITY	0x0010
 #define LM_FLAG_NODE_SCOPE	0x0020
 #define GL_ASYNC		0x0040
 #define GL_EXACT		0x0080
--- a/fs/gfs2/lock_dlm.c
+++ b/fs/gfs2/lock_dlm.c
@@ -222,11 +222,6 @@ static u32 make_flags(struct gfs2_glock
 		lkf |= DLM_LKF_NOQUEUEBAST;
 	}
 
-	if (gfs_flags & LM_FLAG_PRIORITY) {
-		lkf |= DLM_LKF_NOORDER;
-		lkf |= DLM_LKF_HEADQUE;
-	}
-
 	if (gfs_flags & LM_FLAG_ANY) {
 		if (req == DLM_LOCK_PR)
 			lkf |= DLM_LKF_ALTCW;


