Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B319930C349;
	Mon, 13 Oct 2025 15:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368773; cv=none; b=rN3hxTuxyytqn+NrCh3tyi6ANOJLAG4c45/mJVbIGxQCGqTjqx9rnd/r03Gy5x1Qph3U4FEmbnwXqqCDtkAjQ6P6bOKWQLcOhsAF6Fb7wqiQYD6P6gh93bfjfgCmRC1pfy4oEP3hXuN96VTfvoGcbaX72CeYLt2qt2HO9J/pLEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368773; c=relaxed/simple;
	bh=4Tg3aHe1Se+rBKzhbyDSt0pmq/Ji2DNLQsf26OQubYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rxged//LeoUcG6OwDqKhygRsphoNGGpfLrzduSV5xLRYHPsBqcA0R7X991pTvBZ6cmMMu80bYOsnr/aWpv14uwGQkU9ZnKzY3sZWRNmyPKQRmB3fUoKskewuHqJ4pJR+JrKMJ+c2vcLi2LtJG7QkWGqqORu2mBIa/jPuAW25gU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FYFGKlCA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FYFGKlCA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34F36C4CEE7;
	Mon, 13 Oct 2025 15:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368773;
	bh=4Tg3aHe1Se+rBKzhbyDSt0pmq/Ji2DNLQsf26OQubYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FYFGKlCAZSVE3szWCs2XWM4063aNyaB5mI5Nd0OELWEsWx0TvO4KGUClStTRkQHZf
	 GOOhjLYfg4JkgtmoHniOs2DYaf20A32LCdNuctJoQayB++ZmGW+r56dlJEL4f02rfb
	 YkQ9LOv7b4mCwJpjR+MxvrvCuGrlG+PWqs13PFO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Andrew Price <anprice@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 015/563] gfs2: Fix LM_FLAG_TRY* logic in add_to_queue
Date: Mon, 13 Oct 2025 16:37:56 +0200
Message-ID: <20251013144411.843541568@linuxfoundation.org>
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

[ Upstream commit 0c23e24164d83086e75581b0cf930f4e161636d6 ]

The logic in add_to_queue() for determining whether a LM_FLAG_TRY or
LM_FLAG_TRY_1CB holder should be queued does not make any sense: we are
interested in wether or not the new operation will block behind an
existing or future holder in the queue, but the current code checks for
ongoing locking or ->go_inval() operations, which has little to do with
that.

Replace that code with something more sensible, remove the incorrect
add_to_queue() function annotations, remove the similarly misguided
do_error(gl, 0) call in do_xmote(), and add a missing comment to the
same call in do_promote().

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: Andrew Price <anprice@redhat.com>
Stable-dep-of: bddb53b776fb ("gfs2: Get rid of GLF_INVALIDATE_IN_PROGRESS")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glock.c | 47 ++++++++++++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 23 deletions(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 45dd73bb884fd..5edf125b39fe3 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -502,7 +502,7 @@ static bool do_promote(struct gfs2_glock *gl)
 			 */
 			if (list_is_first(&gh->gh_list, &gl->gl_holders))
 				return false;
-			do_error(gl, 0);
+			do_error(gl, 0); /* Fail queued try locks */
 			break;
 		}
 		set_bit(HIF_HOLDER, &gh->gh_iflags);
@@ -713,7 +713,6 @@ __acquires(&gl->gl_lockref.lock)
 		if (test_and_set_bit(GLF_INVALIDATE_IN_PROGRESS,
 				     &gl->gl_flags))
 			return;
-		do_error(gl, 0); /* Fail queued try locks */
 	}
 	if (!glops->go_inval && !glops->go_sync)
 		goto skip_inval;
@@ -1454,6 +1453,24 @@ void gfs2_print_dbg(struct seq_file *seq, const char *fmt, ...)
 	va_end(args);
 }
 
+static bool gfs2_should_queue_trylock(struct gfs2_glock *gl,
+				      struct gfs2_holder *gh)
+{
+	struct gfs2_holder *current_gh, *gh2;
+
+	current_gh = find_first_holder(gl);
+	if (current_gh && !may_grant(gl, current_gh, gh))
+		return false;
+
+	list_for_each_entry(gh2, &gl->gl_holders, gh_list) {
+		if (test_bit(HIF_HOLDER, &gh2->gh_iflags))
+			continue;
+		if (!(gh2->gh_flags & (LM_FLAG_TRY | LM_FLAG_TRY_1CB)))
+			return false;
+	}
+	return true;
+}
+
 static inline bool pid_is_meaningful(const struct gfs2_holder *gh)
 {
         if (!(gh->gh_flags & GL_NOPID))
@@ -1472,27 +1489,20 @@ static inline bool pid_is_meaningful(const struct gfs2_holder *gh)
  */
 
 static inline void add_to_queue(struct gfs2_holder *gh)
-__releases(&gl->gl_lockref.lock)
-__acquires(&gl->gl_lockref.lock)
 {
 	struct gfs2_glock *gl = gh->gh_gl;
 	struct gfs2_sbd *sdp = gl->gl_name.ln_sbd;
 	struct gfs2_holder *gh2;
-	int try_futile = 0;
 
 	GLOCK_BUG_ON(gl, gh->gh_owner_pid == NULL);
 	if (test_and_set_bit(HIF_WAIT, &gh->gh_iflags))
 		GLOCK_BUG_ON(gl, true);
 
-	if (gh->gh_flags & (LM_FLAG_TRY | LM_FLAG_TRY_1CB)) {
-		if (test_bit(GLF_LOCK, &gl->gl_flags)) {
-			struct gfs2_holder *current_gh;
-
-			current_gh = find_first_holder(gl);
-			try_futile = !may_grant(gl, current_gh, gh);
-		}
-		if (test_bit(GLF_INVALIDATE_IN_PROGRESS, &gl->gl_flags))
-			goto fail;
+	if ((gh->gh_flags & (LM_FLAG_TRY | LM_FLAG_TRY_1CB)) &&
+	    !gfs2_should_queue_trylock(gl, gh)) {
+		gh->gh_error = GLR_TRYFAILED;
+		gfs2_holder_wake(gh);
+		return;
 	}
 
 	list_for_each_entry(gh2, &gl->gl_holders, gh_list) {
@@ -1504,15 +1514,6 @@ __acquires(&gl->gl_lockref.lock)
 			continue;
 		goto trap_recursive;
 	}
-	list_for_each_entry(gh2, &gl->gl_holders, gh_list) {
-		if (try_futile &&
-		    !(gh2->gh_flags & (LM_FLAG_TRY | LM_FLAG_TRY_1CB))) {
-fail:
-			gh->gh_error = GLR_TRYFAILED;
-			gfs2_holder_wake(gh);
-			return;
-		}
-	}
 	trace_gfs2_glock_queue(gh, 1);
 	gfs2_glstats_inc(gl, GFS2_LKS_QCOUNT);
 	gfs2_sbstats_inc(gl, GFS2_LKS_QCOUNT);
-- 
2.51.0



