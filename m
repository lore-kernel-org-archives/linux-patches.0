Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EF8E1993A0;
	Thu,  6 Jun 2024 14:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683250; cv=none; b=uA1H6V5ng6G6LFd+sfNug1sMn0kKTjxOBfCsl5j4jfoIPi5ylHr0oHK+IinmA/8rTizjdv+kKzxggmPUQlni8Zo1NUD+27ohGdhXkQ24UNkHPv8ZW863sYGUeN6nbN9ZLiWnnxGGNU0Rid59e3Z6bryqrbtfVWpQpbkBGMOBIvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683250; c=relaxed/simple;
	bh=xj8ShCJk2CHgP+VsAkP0xFVqwigOFQdm+GXbvdOsfS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fYtFa1qDI7cK+QpOGAhna7P5i13r+mCnyFaWIEAdBI9YFXO2/hBZAkvgBhFGLEzOj9bdRvK+GPTL6JxpM6bHmDo7qMyztai7NT5FmagRvTE++wmUsCbHCtr1gp4JcotOTFMMeBns8/GQP5gYrMUNVe+XNqiovvAlVQjCGi5JnEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LD+Lo8ZE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LD+Lo8ZE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A831C2BD10;
	Thu,  6 Jun 2024 14:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683250;
	bh=xj8ShCJk2CHgP+VsAkP0xFVqwigOFQdm+GXbvdOsfS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LD+Lo8ZE+98s18f2vQdSPUNBPzJrzpa+n47BtXkXE5ObbRseStWB2ouJjteNyqOwX
	 3GTNbXHEjLSOdp4UgMWME9mLcK+LOD2qXwOq1fo/or8lDiAOs3uZxUVgEC9EvUvQUP
	 8agyvXh0R8JReUq6WLwM+9LSucFMU/bcXqA5Gu3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 194/744] gfs2: finish_xmote cleanup
Date: Thu,  6 Jun 2024 15:57:46 +0200
Message-ID: <20240606131738.661861042@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 1cd28e15864054f3c48baee9eecda1c0441c48ac ]

Currently, function finish_xmote() takes and releases the glock
spinlock.  However, all of its callers immediately take that spinlock
again, so it makes more sense to take the spin lock before calling
finish_xmote() already.

With that, thaw_glock() is the only place that sets the GLF_HAVE_REPLY
flag outside of the glock spinlock, but it also takes that spinlock
immediately thereafter.  Change that to set the bit when the spinlock is
already held.  This allows to switch from test_and_clear_bit() to
test_bit() and clear_bit() in glock_work_func().

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Stable-dep-of: 9947a06d29c0 ("gfs2: do_xmote fixes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glock.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 7af12c8fb577d..009a6a6312c2f 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -600,7 +600,6 @@ static void finish_xmote(struct gfs2_glock *gl, unsigned int ret)
 	struct gfs2_holder *gh;
 	unsigned state = ret & LM_OUT_ST_MASK;
 
-	spin_lock(&gl->gl_lockref.lock);
 	trace_gfs2_glock_state_change(gl, state);
 	state_change(gl, state);
 	gh = find_first_waiter(gl);
@@ -648,7 +647,6 @@ static void finish_xmote(struct gfs2_glock *gl, unsigned int ret)
 			       gl->gl_target, state);
 			GLOCK_BUG_ON(gl, 1);
 		}
-		spin_unlock(&gl->gl_lockref.lock);
 		return;
 	}
 
@@ -671,7 +669,6 @@ static void finish_xmote(struct gfs2_glock *gl, unsigned int ret)
 	}
 out:
 	clear_bit(GLF_LOCK, &gl->gl_flags);
-	spin_unlock(&gl->gl_lockref.lock);
 }
 
 static bool is_system_glock(struct gfs2_glock *gl)
@@ -818,15 +815,19 @@ __acquires(&gl->gl_lockref.lock)
 		if (ret == -EINVAL && gl->gl_target == LM_ST_UNLOCKED &&
 		    target == LM_ST_UNLOCKED &&
 		    test_bit(DFL_UNMOUNT, &ls->ls_recover_flags)) {
+			spin_lock(&gl->gl_lockref.lock);
 			finish_xmote(gl, target);
-			gfs2_glock_queue_work(gl, 0);
+			__gfs2_glock_queue_work(gl, 0);
+			spin_unlock(&gl->gl_lockref.lock);
 		} else if (ret) {
 			fs_err(sdp, "lm_lock ret %d\n", ret);
 			GLOCK_BUG_ON(gl, !gfs2_withdrawing_or_withdrawn(sdp));
 		}
 	} else { /* lock_nolock */
+		spin_lock(&gl->gl_lockref.lock);
 		finish_xmote(gl, target);
-		gfs2_glock_queue_work(gl, 0);
+		__gfs2_glock_queue_work(gl, 0);
+		spin_unlock(&gl->gl_lockref.lock);
 	}
 out:
 	spin_lock(&gl->gl_lockref.lock);
@@ -1082,11 +1083,12 @@ static void glock_work_func(struct work_struct *work)
 	struct gfs2_glock *gl = container_of(work, struct gfs2_glock, gl_work.work);
 	unsigned int drop_refs = 1;
 
-	if (test_and_clear_bit(GLF_REPLY_PENDING, &gl->gl_flags)) {
+	spin_lock(&gl->gl_lockref.lock);
+	if (test_bit(GLF_REPLY_PENDING, &gl->gl_flags)) {
+		clear_bit(GLF_REPLY_PENDING, &gl->gl_flags);
 		finish_xmote(gl, gl->gl_reply);
 		drop_refs++;
 	}
-	spin_lock(&gl->gl_lockref.lock);
 	if (test_bit(GLF_PENDING_DEMOTE, &gl->gl_flags) &&
 	    gl->gl_state != LM_ST_UNLOCKED &&
 	    gl->gl_demote_state != LM_ST_EXCLUSIVE) {
@@ -2144,8 +2146,11 @@ static void thaw_glock(struct gfs2_glock *gl)
 		return;
 	if (!lockref_get_not_dead(&gl->gl_lockref))
 		return;
+
+	spin_lock(&gl->gl_lockref.lock);
 	set_bit(GLF_REPLY_PENDING, &gl->gl_flags);
-	gfs2_glock_queue_work(gl, 0);
+	__gfs2_glock_queue_work(gl, 0);
+	spin_unlock(&gl->gl_lockref.lock);
 }
 
 /**
-- 
2.43.0



