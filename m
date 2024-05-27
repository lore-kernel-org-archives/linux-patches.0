Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08BFF168C4;
	Mon, 27 May 2024 19:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838014; cv=none; b=rSqUMaysv4K0qhDWZGB2lvM5pPpNhiH1qJ+SvAoiUUf1XWkA1C5G9p3Ti+GTT/1YP1Zlh5kGjvFMgXnGLOib8REOJ7O4tFa6JmKRgv40tQ00FCd18pkXryZuMHsRV/EBGHFllgnS7qp6ewEBGGtmk2Z21E3lZUBFtvF5zyVqfyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838014; c=relaxed/simple;
	bh=uE4MlUEByXuTImpRPdFuz/kttp9CGpM8PnJ8kIaC8Us=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SjjZXhj0L1h4guMGRuhzZFeCzriAVHWLfMrPb6BWR4/aRbsfJpXKOLFjthcL6LghIjuG/OvLdAbH0XKRre6EXWV//zPg0sUut8ctFXD+QOli/84BhQ+Re773FIF7X70ubrEQ0Dj72rzF/kn0aAQ/ZkBxRAQTmEQWvuuZlhxxuwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uZVb9A7s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uZVb9A7s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96423C2BBFC;
	Mon, 27 May 2024 19:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838013;
	bh=uE4MlUEByXuTImpRPdFuz/kttp9CGpM8PnJ8kIaC8Us=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uZVb9A7s5TDIvWXn4SAdJrUkzgOmdOsR84DlA1LTssAILuyPYNyzwXrCp6bhUDhzz
	 yrXMKYhSSU01K6Tvay5vqOKaHh04RpYYYWmdrNoSWa09s/JgobxRMJ19HindUR+KsX
	 bH3dAKCnRYVdpdlhPFp9Hkn07m3fW3G56rSoasPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 234/493] gfs2: finish_xmote cleanup
Date: Mon, 27 May 2024 20:53:56 +0200
Message-ID: <20240527185637.955046285@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 1bf0d751ece0a..0c719fcd4fbc5 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -617,7 +617,6 @@ static void finish_xmote(struct gfs2_glock *gl, unsigned int ret)
 	struct gfs2_holder *gh;
 	unsigned state = ret & LM_OUT_ST_MASK;
 
-	spin_lock(&gl->gl_lockref.lock);
 	trace_gfs2_glock_state_change(gl, state);
 	state_change(gl, state);
 	gh = find_first_waiter(gl);
@@ -665,7 +664,6 @@ static void finish_xmote(struct gfs2_glock *gl, unsigned int ret)
 			       gl->gl_target, state);
 			GLOCK_BUG_ON(gl, 1);
 		}
-		spin_unlock(&gl->gl_lockref.lock);
 		return;
 	}
 
@@ -688,7 +686,6 @@ static void finish_xmote(struct gfs2_glock *gl, unsigned int ret)
 	}
 out:
 	clear_bit(GLF_LOCK, &gl->gl_flags);
-	spin_unlock(&gl->gl_lockref.lock);
 }
 
 static bool is_system_glock(struct gfs2_glock *gl)
@@ -835,15 +832,19 @@ __acquires(&gl->gl_lockref.lock)
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
@@ -1099,11 +1100,12 @@ static void glock_work_func(struct work_struct *work)
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
@@ -2176,8 +2178,11 @@ static void thaw_glock(struct gfs2_glock *gl)
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



