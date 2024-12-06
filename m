Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF3513E03A;
	Fri,  6 Dec 2024 15:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497614; cv=none; b=Cs9hax/QLEbvQVdgjdWQkcF5D8a7mq3j5RJdLur4qfe7UAGviHIVWPPkkHtWWcXFH3eRbEPj67FyvKTbjbE0Kcm0EOtd6lIRduR0/ciO7VlcSgmK2qexNMB8CaqdscP0eHRvdJuBAUo2xOLB+5aTgKpS04GJmpDui+0A2MuwRuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497614; c=relaxed/simple;
	bh=H+RCeZ/7ia2Zs57xEhl2hElL1PYCmqcsqgGYM8YkapQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KKg3aDG8Y3tTRZ69/ZtKnM7FnI0RVLth3MMLcgjCuG5o4d1ZDyZPjRoenwothTXU0WqK95iIcgOaohyFR5qd/twFaAfB2JbF8gVhrtM6l7L8Jv1lqJ5U0myZ6TuO7aP6PlzyfccjctAOXAWiDbd9H9lsKAYOAcQaI2cnAm9Uu3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yu73cGxq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yu73cGxq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBAF8C4CED1;
	Fri,  6 Dec 2024 15:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497614;
	bh=H+RCeZ/7ia2Zs57xEhl2hElL1PYCmqcsqgGYM8YkapQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yu73cGxq2WwcewGxjdYfa0SZM8tqh+Oq2px4/khmfkO90F9KD48BMzQSoxJx/3HpW
	 nWfC9Vv+W0+EV5VCtSIHafj9RCBjyh7gCwD9dn4lGh9B4hQ/cucD2MsUulc0AkgcVv
	 A5ABTzG/Jrok5OTO5Dgs7XiRENyikNM3uzz5gLjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 340/676] gfs2: Fix unlinked inode cleanup
Date: Fri,  6 Dec 2024 15:32:39 +0100
Message-ID: <20241206143706.631594892@linuxfoundation.org>
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

[ Upstream commit 7c6f714d88475ceae5342264858a641eafa19632 ]

Before commit f0e56edc2ec7 ("gfs2: Split the two kinds of glock "delete"
work"), function delete_work_func() was used to trigger the eviction of
in-memory inodes from remote as well as deleting unlinked inodes at a
later point.  These two kinds of work were then split into two kinds of
work, and the two places in the code were deferred deletion of inodes is
required accidentally ended up queuing the wrong kind of work.  This
caused unlinked inodes to be left behind, which could in the worst case
fill up filesystems and require a filesystem check to recover.

Fix that by queuing the right kind of work in try_rgrp_unlink() and
gfs2_drop_inode().

Fixes: f0e56edc2ec7 ("gfs2: Split the two kinds of glock "delete" work")
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glock.c | 2 +-
 fs/gfs2/glock.h | 1 +
 fs/gfs2/rgrp.c  | 2 +-
 fs/gfs2/super.c | 2 +-
 4 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index e9b5a8eaf3003..20fb2296fe3e0 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1028,7 +1028,7 @@ bool gfs2_queue_try_to_evict(struct gfs2_glock *gl)
 				  &gl->gl_delete, 0);
 }
 
-static bool gfs2_queue_verify_delete(struct gfs2_glock *gl, bool later)
+bool gfs2_queue_verify_delete(struct gfs2_glock *gl, bool later)
 {
 	struct gfs2_sbd *sdp = gl->gl_name.ln_sbd;
 	unsigned long delay;
diff --git a/fs/gfs2/glock.h b/fs/gfs2/glock.h
index 29fd58de0597d..aae9fabbb76cc 100644
--- a/fs/gfs2/glock.h
+++ b/fs/gfs2/glock.h
@@ -259,6 +259,7 @@ static inline int gfs2_glock_nq_init(struct gfs2_glock *gl,
 void gfs2_glock_cb(struct gfs2_glock *gl, unsigned int state);
 void gfs2_glock_complete(struct gfs2_glock *gl, int ret);
 bool gfs2_queue_try_to_evict(struct gfs2_glock *gl);
+bool gfs2_queue_verify_delete(struct gfs2_glock *gl, bool later);
 void gfs2_cancel_delete_work(struct gfs2_glock *gl);
 void gfs2_flush_delete_work(struct gfs2_sbd *sdp);
 void gfs2_gl_hash_clear(struct gfs2_sbd *sdp);
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 396d0f4a259d5..4a5e2732d1da2 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1879,7 +1879,7 @@ static void try_rgrp_unlink(struct gfs2_rgrpd *rgd, u64 *last_unlinked, u64 skip
 		 */
 		ip = gl->gl_object;
 
-		if (ip || !gfs2_queue_try_to_evict(gl))
+		if (ip || !gfs2_queue_verify_delete(gl, false))
 			gfs2_glock_put(gl);
 		else
 			found++;
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index b37f8bd79286a..09285dc782cf8 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -1053,7 +1053,7 @@ static int gfs2_drop_inode(struct inode *inode)
 		struct gfs2_glock *gl = ip->i_iopen_gh.gh_gl;
 
 		gfs2_glock_hold(gl);
-		if (!gfs2_queue_try_to_evict(gl))
+		if (!gfs2_queue_verify_delete(gl, true))
 			gfs2_glock_put_async(gl);
 		return 0;
 	}
-- 
2.43.0



