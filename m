Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23AA020C03B;
	Fri,  6 Dec 2024 15:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497958; cv=none; b=By29ZEZEVU0F+yDWiRGKNwcUM7aqFtqEjbRj+IiKFR3d6V7VgJwlHGLloHAC57PUwU+YLXyAhqY2NCV2PomdVJN6ROfR7BmzdGsX05IrMCXU3TNMi2ntrvEXSvNIWmhT38zKuiMrniTt4UDScMeMsG11lh99TvMwnExdXdRUmuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497958; c=relaxed/simple;
	bh=TTSxrRgMlxRAxDmddcjSJAXy7eN/xKMavQBhjELIFJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dUV1XYJnvl01UpXz/0dew9tRkbrUk8lD0Q8KEiz7q0R19F9ffXBkvU7TFisHDK507QZwK1+jJFBWwFrdNPgMcnHMhjtVnPuj4xZZC1HXfba7JuPfHWmLedbygSGgAXW3kmir8QXBU3Q3xMrC9s5lAVELyu4LYOaffVXC4PnG418=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iakc7W/g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iakc7W/g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B75EC4CED1;
	Fri,  6 Dec 2024 15:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497958;
	bh=TTSxrRgMlxRAxDmddcjSJAXy7eN/xKMavQBhjELIFJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iakc7W/ghDhG7nYCisv8Cv4XozhfsoCUH8QB9Zq804XdkubA+8d7lQ+Xmj2jzICoc
	 DFcULFAlavy4HxlRK6fKRUTh+oMIQqH+P6qraetct3ldVAjUr0N2lXrlm2c4Ch6Ifm
	 2lGznHcTAvWBt82+pYD1pdXuiU08NcjA+4J4iBWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 443/676] gfs2: Remove and replace gfs2_glock_queue_work
Date: Fri,  6 Dec 2024 15:34:22 +0100
Message-ID: <20241206143710.661307442@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

[ Upstream commit 1e86044402c45b70a9b31beeaefb5cc732a7470c ]

There are no more callers of gfs2_glock_queue_work() left, so remove
that helper.  With that, we can now rename __gfs2_glock_queue_work()
back to gfs2_glock_queue_work() to get rid of some unnecessary clutter.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glock.c | 35 +++++++++++++++--------------------
 1 file changed, 15 insertions(+), 20 deletions(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index f38d8558f4c18..2c0908a302102 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -274,7 +274,7 @@ static void gfs2_glock_remove_from_lru(struct gfs2_glock *gl)
  * Enqueue the glock on the work queue.  Passes one glock reference on to the
  * work queue.
  */
-static void __gfs2_glock_queue_work(struct gfs2_glock *gl, unsigned long delay) {
+static void gfs2_glock_queue_work(struct gfs2_glock *gl, unsigned long delay) {
 	if (!queue_delayed_work(glock_workqueue, &gl->gl_work, delay)) {
 		/*
 		 * We are holding the lockref spinlock, and the work was still
@@ -287,12 +287,6 @@ static void __gfs2_glock_queue_work(struct gfs2_glock *gl, unsigned long delay)
 	}
 }
 
-static void gfs2_glock_queue_work(struct gfs2_glock *gl, unsigned long delay) {
-	spin_lock(&gl->gl_lockref.lock);
-	__gfs2_glock_queue_work(gl, delay);
-	spin_unlock(&gl->gl_lockref.lock);
-}
-
 static void __gfs2_glock_put(struct gfs2_glock *gl)
 {
 	struct gfs2_sbd *sdp = gl->gl_name.ln_sbd;
@@ -337,7 +331,8 @@ void gfs2_glock_put_async(struct gfs2_glock *gl)
 	if (lockref_put_or_lock(&gl->gl_lockref))
 		return;
 
-	__gfs2_glock_queue_work(gl, 0);
+	GLOCK_BUG_ON(gl, gl->gl_lockref.count != 1);
+	gfs2_glock_queue_work(gl, 0);
 	spin_unlock(&gl->gl_lockref.lock);
 }
 
@@ -814,7 +809,7 @@ __acquires(&gl->gl_lockref.lock)
 			 */
 			clear_bit(GLF_LOCK, &gl->gl_flags);
 			clear_bit(GLF_DEMOTE_IN_PROGRESS, &gl->gl_flags);
-			__gfs2_glock_queue_work(gl, GL_GLOCK_DFT_HOLD);
+			gfs2_glock_queue_work(gl, GL_GLOCK_DFT_HOLD);
 			return;
 		} else {
 			clear_bit(GLF_INVALIDATE_IN_PROGRESS, &gl->gl_flags);
@@ -844,7 +839,7 @@ __acquires(&gl->gl_lockref.lock)
 
 	/* Complete the operation now. */
 	finish_xmote(gl, target);
-	__gfs2_glock_queue_work(gl, 0);
+	gfs2_glock_queue_work(gl, 0);
 }
 
 /**
@@ -891,7 +886,7 @@ __acquires(&gl->gl_lockref.lock)
 	clear_bit(GLF_LOCK, &gl->gl_flags);
 	smp_mb__after_atomic();
 	gl->gl_lockref.count++;
-	__gfs2_glock_queue_work(gl, 0);
+	gfs2_glock_queue_work(gl, 0);
 	return;
 
 out_unlock:
@@ -1124,12 +1119,12 @@ static void glock_work_func(struct work_struct *work)
 		drop_refs--;
 		if (gl->gl_name.ln_type != LM_TYPE_INODE)
 			delay = 0;
-		__gfs2_glock_queue_work(gl, delay);
+		gfs2_glock_queue_work(gl, delay);
 	}
 
 	/*
 	 * Drop the remaining glock references manually here. (Mind that
-	 * __gfs2_glock_queue_work depends on the lockref spinlock begin held
+	 * gfs2_glock_queue_work depends on the lockref spinlock begin held
 	 * here as well.)
 	 */
 	gl->gl_lockref.count -= drop_refs;
@@ -1616,7 +1611,7 @@ int gfs2_glock_nq(struct gfs2_holder *gh)
 		     test_and_clear_bit(GLF_FROZEN, &gl->gl_flags))) {
 		set_bit(GLF_REPLY_PENDING, &gl->gl_flags);
 		gl->gl_lockref.count++;
-		__gfs2_glock_queue_work(gl, 0);
+		gfs2_glock_queue_work(gl, 0);
 	}
 	run_queue(gl, 1);
 	spin_unlock(&gl->gl_lockref.lock);
@@ -1681,7 +1676,7 @@ static void __gfs2_glock_dq(struct gfs2_holder *gh)
 		    !test_bit(GLF_DEMOTE, &gl->gl_flags) &&
 		    gl->gl_name.ln_type == LM_TYPE_INODE)
 			delay = gl->gl_hold_time;
-		__gfs2_glock_queue_work(gl, delay);
+		gfs2_glock_queue_work(gl, delay);
 	}
 }
 
@@ -1905,7 +1900,7 @@ void gfs2_glock_cb(struct gfs2_glock *gl, unsigned int state)
 			delay = gl->gl_hold_time;
 	}
 	handle_callback(gl, state, delay, true);
-	__gfs2_glock_queue_work(gl, delay);
+	gfs2_glock_queue_work(gl, delay);
 	spin_unlock(&gl->gl_lockref.lock);
 }
 
@@ -1965,7 +1960,7 @@ void gfs2_glock_complete(struct gfs2_glock *gl, int ret)
 
 	gl->gl_lockref.count++;
 	set_bit(GLF_REPLY_PENDING, &gl->gl_flags);
-	__gfs2_glock_queue_work(gl, 0);
+	gfs2_glock_queue_work(gl, 0);
 	spin_unlock(&gl->gl_lockref.lock);
 }
 
@@ -2025,7 +2020,7 @@ __acquires(&lru_lock)
 		gl->gl_lockref.count++;
 		if (demote_ok(gl))
 			handle_callback(gl, LM_ST_UNLOCKED, 0, false);
-		__gfs2_glock_queue_work(gl, 0);
+		gfs2_glock_queue_work(gl, 0);
 		spin_unlock(&gl->gl_lockref.lock);
 		cond_resched_lock(&lru_lock);
 	}
@@ -2163,7 +2158,7 @@ static void thaw_glock(struct gfs2_glock *gl)
 
 	spin_lock(&gl->gl_lockref.lock);
 	set_bit(GLF_REPLY_PENDING, &gl->gl_flags);
-	__gfs2_glock_queue_work(gl, 0);
+	gfs2_glock_queue_work(gl, 0);
 	spin_unlock(&gl->gl_lockref.lock);
 }
 
@@ -2182,7 +2177,7 @@ static void clear_glock(struct gfs2_glock *gl)
 		gl->gl_lockref.count++;
 		if (gl->gl_state != LM_ST_UNLOCKED)
 			handle_callback(gl, LM_ST_UNLOCKED, 0, false);
-		__gfs2_glock_queue_work(gl, 0);
+		gfs2_glock_queue_work(gl, 0);
 	}
 	spin_unlock(&gl->gl_lockref.lock);
 }
-- 
2.43.0



