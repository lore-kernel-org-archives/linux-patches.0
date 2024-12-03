Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC041D9341;
	Tue,  3 Dec 2024 15:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239039; cv=none; b=aXpV2uypsG5SEpnFhCjBDlLMkMlODCZE3ozaPG2lbsW8h/Nebzk/fik3Z1corPFC4NR5ILM6Kd6V4yUnvnYJNzkHNXqSxiDLOvsnxqTWFECZBsTFhWm4P9/P/bWmNW/G+wuqFh4d0XnLQQ67kKOrGf4OFmniEJl/8lpJNAtVxeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239039; c=relaxed/simple;
	bh=rDNCTsHOXLm4Q+uiqMd6W2qG1qqKikOebwQhoFMMEuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GBt6ylMoG9euD1GwDV54inEpw6bCKLlUy3EMucYqEkc12c+UrMweAn/B2Otw7PP3l9AJyp8WiXuron1W5GO7RdW22vZ6aWcmgnSJ0cyNIQAemtTfqGWNbTo1pbvsE7GFTkT73EwykyCgnyt0p51g2T1bOuR386OZuqCn7dAy57E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LTd/RefH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LTd/RefH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36E71C4CECF;
	Tue,  3 Dec 2024 15:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239039;
	bh=rDNCTsHOXLm4Q+uiqMd6W2qG1qqKikOebwQhoFMMEuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LTd/RefHY9Q5L9CO3TCiYgHTs7dQ3nESPKNLJepIuuErO8HCmE9LpdXJa0vQsHAZh
	 CyEiINctgpXA9DRruVmX+p6iHWnH5d+wFv64R/UxUCc9YIzU35dZ7UljM5pP8r5/LS
	 YiuDccG0bfuHBd0wz22GFMQPuhktnlppzAnM4IwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 484/817] gfs2: Fix unlinked inode cleanup
Date: Tue,  3 Dec 2024 15:40:56 +0100
Message-ID: <20241203144014.764100129@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index b7f5347e4b41b..3af6120d55b51 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1013,7 +1013,7 @@ bool gfs2_queue_try_to_evict(struct gfs2_glock *gl)
 				  &gl->gl_delete, 0);
 }
 
-static bool gfs2_queue_verify_delete(struct gfs2_glock *gl, bool later)
+bool gfs2_queue_verify_delete(struct gfs2_glock *gl, bool later)
 {
 	struct gfs2_sbd *sdp = gl->gl_name.ln_sbd;
 	unsigned long delay;
diff --git a/fs/gfs2/glock.h b/fs/gfs2/glock.h
index adf0091cc98f9..63e101d448e96 100644
--- a/fs/gfs2/glock.h
+++ b/fs/gfs2/glock.h
@@ -245,6 +245,7 @@ static inline int gfs2_glock_nq_init(struct gfs2_glock *gl,
 void gfs2_glock_cb(struct gfs2_glock *gl, unsigned int state);
 void gfs2_glock_complete(struct gfs2_glock *gl, int ret);
 bool gfs2_queue_try_to_evict(struct gfs2_glock *gl);
+bool gfs2_queue_verify_delete(struct gfs2_glock *gl, bool later);
 void gfs2_cancel_delete_work(struct gfs2_glock *gl);
 void gfs2_flush_delete_work(struct gfs2_sbd *sdp);
 void gfs2_gl_hash_clear(struct gfs2_sbd *sdp);
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 29c7728167652..5393031297153 100644
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
index 6678060ed4d2b..e22c1edc32b39 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -1045,7 +1045,7 @@ static int gfs2_drop_inode(struct inode *inode)
 		struct gfs2_glock *gl = ip->i_iopen_gh.gh_gl;
 
 		gfs2_glock_hold(gl);
-		if (!gfs2_queue_try_to_evict(gl))
+		if (!gfs2_queue_verify_delete(gl, true))
 			gfs2_glock_put_async(gl);
 		return 0;
 	}
-- 
2.43.0



