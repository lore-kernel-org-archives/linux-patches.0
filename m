Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132C153A7;
	Fri,  6 Dec 2024 15:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497603; cv=none; b=hdrOjFWLvP8NF/qqcrrqg6ZUYuuQCdcHzLQgpzZiWHO5rxhrAsy4xhAPWeGDdUgFVHoOQLtmZj8OEM7tc+shPg02nUwqO0j55tfIbW/nwixYthWDI3wUiproy9Ydg/r5kfimWM8neGOdaueiZEnEASnWpcoQTip/fQ1ALhFDFGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497603; c=relaxed/simple;
	bh=M79huJH0pu5XaIDp9ciHbWwl2paqDpod+2rvEiox1ZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L1Uov24n32rmCJS91MjUKhAGZGnSDjk6D6swbPmAbu4bO+/HLErb0CC4BeMrDqwqsxZkUGZR0UJ2QW47DXiB5/Uz4LjPMjLbUbJw0UrfO1vdNCgbhGGBwHwNFYp88Gf4fSgtnuXS7okS9dYjNWMHfkIvDTnXMoe7e+0UN2IDqdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jrLdMmTv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jrLdMmTv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CEEFC4CED1;
	Fri,  6 Dec 2024 15:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497602;
	bh=M79huJH0pu5XaIDp9ciHbWwl2paqDpod+2rvEiox1ZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jrLdMmTve68Y5NrYStvsVsx2fPvQpa+V6qIU5kwq6Q2UUJvIuvUW3ldoP1V+gvZNM
	 zprsROcfaSb9SIuPwsX3u5aryizaG5SA8iZTKcN58kaJehhPnUHsbTAn2JRjmP3JS6
	 wqkMGTDqwDHrqE73FMije/+jVZZOGgao4csMv8FQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 337/676] gfs2: Replace gfs2_glock_queue_put with gfs2_glock_put_async
Date: Fri,  6 Dec 2024 15:32:36 +0100
Message-ID: <20241206143706.508724799@linuxfoundation.org>
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

[ Upstream commit ee2be7d7c7f32783f60ee5fe59b91548a4571f10 ]

Function gfs2_glock_queue_put() puts a glock reference by enqueuing
glock work instead of putting the reference directly.  This ensures that
the operation won't sleep, but it is costly and really only necessary
when putting the final glock reference.  Replace it with a new
gfs2_glock_put_async() function that only queues glock work when putting
the last glock reference.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Stable-dep-of: 7c6f714d8847 ("gfs2: Fix unlinked inode cleanup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glock.c | 27 +++++++++++++++++----------
 fs/gfs2/glock.h |  2 +-
 fs/gfs2/log.c   |  2 +-
 fs/gfs2/super.c |  4 ++--
 4 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 685e3ef9e9008..88ddc9828c6c0 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -311,14 +311,6 @@ static void __gfs2_glock_put(struct gfs2_glock *gl)
 	sdp->sd_lockstruct.ls_ops->lm_put_lock(gl);
 }
 
-/*
- * Cause the glock to be put in work queue context.
- */
-void gfs2_glock_queue_put(struct gfs2_glock *gl)
-{
-	gfs2_glock_queue_work(gl, 0);
-}
-
 /**
  * gfs2_glock_put() - Decrement reference count on glock
  * @gl: The glock to put
@@ -333,6 +325,22 @@ void gfs2_glock_put(struct gfs2_glock *gl)
 	__gfs2_glock_put(gl);
 }
 
+/*
+ * gfs2_glock_put_async - Decrement reference count without sleeping
+ * @gl: The glock to put
+ *
+ * Decrement the reference count on glock immediately unless it is the last
+ * reference.  Defer putting the last reference to work queue context.
+ */
+void gfs2_glock_put_async(struct gfs2_glock *gl)
+{
+	if (lockref_put_or_lock(&gl->gl_lockref))
+		return;
+
+	__gfs2_glock_queue_work(gl, 0);
+	spin_unlock(&gl->gl_lockref.lock);
+}
+
 /**
  * may_grant - check if it's ok to grant a new lock
  * @gl: The glock
@@ -2533,8 +2541,7 @@ static void gfs2_glock_iter_next(struct gfs2_glock_iter *gi, loff_t n)
 	if (gl) {
 		if (n == 0)
 			return;
-		if (!lockref_put_not_zero(&gl->gl_lockref))
-			gfs2_glock_queue_put(gl);
+		gfs2_glock_put_async(gl);
 	}
 	for (;;) {
 		gl = rhashtable_walk_next(&gi->hti);
diff --git a/fs/gfs2/glock.h b/fs/gfs2/glock.h
index f7ee9ca948eee..29fd58de0597d 100644
--- a/fs/gfs2/glock.h
+++ b/fs/gfs2/glock.h
@@ -186,7 +186,7 @@ int gfs2_glock_get(struct gfs2_sbd *sdp, u64 number,
 		   int create, struct gfs2_glock **glp);
 struct gfs2_glock *gfs2_glock_hold(struct gfs2_glock *gl);
 void gfs2_glock_put(struct gfs2_glock *gl);
-void gfs2_glock_queue_put(struct gfs2_glock *gl);
+void gfs2_glock_put_async(struct gfs2_glock *gl);
 
 void __gfs2_holder_init(struct gfs2_glock *gl, unsigned int state,
 		        u16 flags, struct gfs2_holder *gh,
diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 767549066066c..2be5551241b3a 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -790,7 +790,7 @@ void gfs2_glock_remove_revoke(struct gfs2_glock *gl)
 {
 	if (atomic_dec_return(&gl->gl_revokes) == 0) {
 		clear_bit(GLF_LFLUSH, &gl->gl_flags);
-		gfs2_glock_queue_put(gl);
+		gfs2_glock_put_async(gl);
 	}
 }
 
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 1200cb8059995..b37f8bd79286a 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -1054,7 +1054,7 @@ static int gfs2_drop_inode(struct inode *inode)
 
 		gfs2_glock_hold(gl);
 		if (!gfs2_queue_try_to_evict(gl))
-			gfs2_glock_queue_put(gl);
+			gfs2_glock_put_async(gl);
 		return 0;
 	}
 
@@ -1270,7 +1270,7 @@ static int gfs2_dinode_dealloc(struct gfs2_inode *ip)
 static void gfs2_glock_put_eventually(struct gfs2_glock *gl)
 {
 	if (current->flags & PF_MEMALLOC)
-		gfs2_glock_queue_put(gl);
+		gfs2_glock_put_async(gl);
 	else
 		gfs2_glock_put(gl);
 }
-- 
2.43.0



