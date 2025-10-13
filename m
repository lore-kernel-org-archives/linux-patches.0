Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99F030BF7A;
	Mon, 13 Oct 2025 15:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368770; cv=none; b=Gj4t7aJy5iKCHuhwrBq/C7P3no80eAu0ZLab42RZUR5kq7skTVoRvsouZP8x0XXoTeR/4LhBDgi9Ft+hCSLp3qEPIRczP64/W/yvvdFkSi6wYQ5ige480S4rKucqS2NQkWmV5pKfX/D+AwMpvPByFspWg1Kl6p4JxBJ0DHmpWgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368770; c=relaxed/simple;
	bh=vtwrphwyBd50HsY121Vq6gzr9zXUh3hUD+043e2YwqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BVpyo11v1dfap+zkmzR6S9nHsaWxzZwIhP6PH5pXt3E/ERTCmgepacn0wQXJUPbXU4ni21J0eencutVi+sAf01a5etOQTQQjvy0ck9Z87aPG9OgKfFS+DJCB+NT3Zospy3BhQCNnUFsu+h8dLqkNoLFiK9azJZh7JG+FBMs3YzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SgtdVo4a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SgtdVo4a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C38DC4CEE7;
	Mon, 13 Oct 2025 15:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368770;
	bh=vtwrphwyBd50HsY121Vq6gzr9zXUh3hUD+043e2YwqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SgtdVo4a3zqbjNL1iGA3OYlY7GcFsRJCQP8DzMbXAc06Byk2Fra3s0KeOaaWqZCmd
	 F3+mjVoSCqJUO4wJlbUErIX1LfVrJJtzCnE0ZjLOJnXRHgsoJiOOsW96zgP3kasOve
	 Ic7STBIymmOYj6TTF/oSn7XZNTQBzML/SZDwDbAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Andrew Price <anprice@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 014/563] gfs2: Further sanitize lock_dlm.c
Date: Mon, 13 Oct 2025 16:37:55 +0200
Message-ID: <20251013144411.807890665@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit fd70ab7155c4b92a9747d42c02791a0793ab9c66 ]

The gl_req field and GLF_BLOCKING flag are only relevant to gdlm_lock(),
its callback gdlm_ast(), and their helpers, so set and clear them inside
lock_dlm.c.

Also, the LM_FLAG_ANY flag is relevant to gdlm_lock(), but do_xmote()
doesn't pass that flag down to gdlm_lock() as it should.  Fix that by
passing down all the flags.

In addition, document the effect of the LM_FLAG_ANY flag on locks held
in EX mode locally.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: Andrew Price <anprice@redhat.com>
Stable-dep-of: bddb53b776fb ("gfs2: Get rid of GLF_INVALIDATE_IN_PROGRESS")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glock.c    |  6 ------
 fs/gfs2/glock.h    |  4 ++++
 fs/gfs2/lock_dlm.c | 26 ++++++++++++++++++--------
 3 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 3d5cf9c24d78b..45dd73bb884fd 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -715,12 +715,6 @@ __acquires(&gl->gl_lockref.lock)
 			return;
 		do_error(gl, 0); /* Fail queued try locks */
 	}
-	gl->gl_req = target;
-	set_bit(GLF_BLOCKING, &gl->gl_flags);
-	if ((gl->gl_req == LM_ST_UNLOCKED) ||
-	    (gl->gl_state == LM_ST_EXCLUSIVE) ||
-	    (lck_flags & (LM_FLAG_TRY|LM_FLAG_TRY_1CB)))
-		clear_bit(GLF_BLOCKING, &gl->gl_flags);
 	if (!glops->go_inval && !glops->go_sync)
 		goto skip_inval;
 
diff --git a/fs/gfs2/glock.h b/fs/gfs2/glock.h
index 9339a3bff6eeb..d041b922b45e3 100644
--- a/fs/gfs2/glock.h
+++ b/fs/gfs2/glock.h
@@ -68,6 +68,10 @@ enum {
  * also be granted in SHARED.  The preferred state is whichever is compatible
  * with other granted locks, or the specified state if no other locks exist.
  *
+ * In addition, when a lock is already held in EX mode locally, a SHARED or
+ * DEFERRED mode request with the LM_FLAG_ANY flag set will be granted.
+ * (The LM_FLAG_ANY flag is only use for SHARED mode requests currently.)
+ *
  * LM_FLAG_NODE_SCOPE
  * This holder agrees to share the lock within this node. In other words,
  * the glock is held in EX mode according to DLM, but local holders on the
diff --git a/fs/gfs2/lock_dlm.c b/fs/gfs2/lock_dlm.c
index cee5d199d2d87..5daaeaaaf18dd 100644
--- a/fs/gfs2/lock_dlm.c
+++ b/fs/gfs2/lock_dlm.c
@@ -58,6 +58,7 @@ static inline void gfs2_update_stats(struct gfs2_lkstats *s, unsigned index,
 /**
  * gfs2_update_reply_times - Update locking statistics
  * @gl: The glock to update
+ * @blocking: The operation may have been blocking
  *
  * This assumes that gl->gl_dstamp has been set earlier.
  *
@@ -72,12 +73,12 @@ static inline void gfs2_update_stats(struct gfs2_lkstats *s, unsigned index,
  * TRY_1CB flags are set are classified as non-blocking. All
  * other DLM requests are counted as (potentially) blocking.
  */
-static inline void gfs2_update_reply_times(struct gfs2_glock *gl)
+static inline void gfs2_update_reply_times(struct gfs2_glock *gl,
+					   bool blocking)
 {
 	struct gfs2_pcpu_lkstats *lks;
 	const unsigned gltype = gl->gl_name.ln_type;
-	unsigned index = test_bit(GLF_BLOCKING, &gl->gl_flags) ?
-			 GFS2_LKS_SRTTB : GFS2_LKS_SRTT;
+	unsigned index = blocking ? GFS2_LKS_SRTTB : GFS2_LKS_SRTT;
 	s64 rtt;
 
 	preempt_disable();
@@ -119,14 +120,18 @@ static inline void gfs2_update_request_times(struct gfs2_glock *gl)
 static void gdlm_ast(void *arg)
 {
 	struct gfs2_glock *gl = arg;
+	bool blocking;
 	unsigned ret;
 
+	blocking = test_bit(GLF_BLOCKING, &gl->gl_flags);
+	gfs2_update_reply_times(gl, blocking);
+	clear_bit(GLF_BLOCKING, &gl->gl_flags);
+
 	/* If the glock is dead, we only react to a dlm_unlock() reply. */
 	if (__lockref_is_dead(&gl->gl_lockref) &&
 	    gl->gl_lksb.sb_status != -DLM_EUNLOCK)
 		return;
 
-	gfs2_update_reply_times(gl);
 	BUG_ON(gl->gl_lksb.sb_flags & DLM_SBF_DEMOTED);
 
 	if ((gl->gl_lksb.sb_flags & DLM_SBF_VALNOTVALID) && gl->gl_lksb.sb_lvbptr)
@@ -241,7 +246,7 @@ static bool down_conversion(int cur, int req)
 }
 
 static u32 make_flags(struct gfs2_glock *gl, const unsigned int gfs_flags,
-		      const int cur, const int req)
+		      const int req, bool blocking)
 {
 	u32 lkf = 0;
 
@@ -274,7 +279,7 @@ static u32 make_flags(struct gfs2_glock *gl, const unsigned int gfs_flags,
 		 * "upward" lock conversions or else DLM will reject the
 		 * request as invalid.
 		 */
-		if (!down_conversion(cur, req))
+		if (blocking)
 			lkf |= DLM_LKF_QUECVT;
 	}
 
@@ -294,14 +299,20 @@ static int gdlm_lock(struct gfs2_glock *gl, unsigned int req_state,
 		     unsigned int flags)
 {
 	struct lm_lockstruct *ls = &gl->gl_name.ln_sbd->sd_lockstruct;
+	bool blocking;
 	int cur, req;
 	u32 lkf;
 	char strname[GDLM_STRNAME_BYTES] = "";
 	int error;
 
+	gl->gl_req = req_state;
 	cur = make_mode(gl->gl_name.ln_sbd, gl->gl_state);
 	req = make_mode(gl->gl_name.ln_sbd, req_state);
-	lkf = make_flags(gl, flags, cur, req);
+	blocking = !down_conversion(cur, req) &&
+		   !(flags & (LM_FLAG_TRY|LM_FLAG_TRY_1CB));
+	lkf = make_flags(gl, flags, req, blocking);
+	if (blocking)
+		set_bit(GLF_BLOCKING, &gl->gl_flags);
 	gfs2_glstats_inc(gl, GFS2_LKS_DCOUNT);
 	gfs2_sbstats_inc(gl, GFS2_LKS_DCOUNT);
 	if (test_bit(GLF_INITIAL, &gl->gl_flags)) {
@@ -341,7 +352,6 @@ static void gdlm_put_lock(struct gfs2_glock *gl)
 		return;
 	}
 
-	clear_bit(GLF_BLOCKING, &gl->gl_flags);
 	gfs2_glstats_inc(gl, GFS2_LKS_DCOUNT);
 	gfs2_sbstats_inc(gl, GFS2_LKS_DCOUNT);
 	gfs2_update_request_times(gl);
-- 
2.51.0



