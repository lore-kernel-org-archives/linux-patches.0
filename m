Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A947D39FED;
	Fri, 24 Nov 2023 18:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d8ifv0pM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34814C433C7;
	Fri, 24 Nov 2023 18:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849340;
	bh=jUKcC5T/M0Sg8DWe/nNTi5kcwwRJwcviYmh+Qu2SgZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d8ifv0pMKGeQGwQ2JbiOU6k73Fxxs6WGeT5b7sp0NUUzK+oo8GzfARYi/kcTFl/Ua
	 h5VHe/nkO2EK4XoOvjCIM99NQcHEMHoDt5ceBYe9RFiUZWfwL5xE7ST0yMHYHFjj9k
	 009ojIk434oOjVGPUpWUoopI6Rv8cAOjUEXBp4s8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 143/530] gfs2: fix an oops in gfs2_permission
Date: Fri, 24 Nov 2023 17:45:09 +0000
Message-ID: <20231124172032.435387649@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 0abd1557e21c617bd13fc18f7725fc6363c05913 ]

In RCU mode, we might race with gfs2_evict_inode(), which zeroes
->i_gl.  Freeing of the object it points to is RCU-delayed, so
if we manage to fetch the pointer before it's been replaced with
NULL, we are fine.  Check if we'd fetched NULL and treat that
as "bail out and tell the caller to get out of RCU mode".

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/inode.c | 11 +++++++++--
 fs/gfs2/super.c |  2 +-
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 0eac045079047..eb4bbe1728c06 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -1868,14 +1868,21 @@ int gfs2_permission(struct mnt_idmap *idmap, struct inode *inode,
 {
 	struct gfs2_inode *ip;
 	struct gfs2_holder i_gh;
+	struct gfs2_glock *gl;
 	int error;
 
 	gfs2_holder_mark_uninitialized(&i_gh);
 	ip = GFS2_I(inode);
-	if (gfs2_glock_is_locked_by_me(ip->i_gl) == NULL) {
+	gl = rcu_dereference(ip->i_gl);
+	if (unlikely(!gl)) {
+		/* inode is getting torn down, must be RCU mode */
+		WARN_ON_ONCE(!(mask & MAY_NOT_BLOCK));
+		return -ECHILD;
+        }
+	if (gfs2_glock_is_locked_by_me(gl) == NULL) {
 		if (mask & MAY_NOT_BLOCK)
 			return -ECHILD;
-		error = gfs2_glock_nq_init(ip->i_gl, LM_ST_SHARED, LM_FLAG_ANY, &i_gh);
+		error = gfs2_glock_nq_init(gl, LM_ST_SHARED, LM_FLAG_ANY, &i_gh);
 		if (error)
 			return error;
 	}
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 02d93da21b2b0..0dd5641990b90 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -1550,7 +1550,7 @@ static void gfs2_evict_inode(struct inode *inode)
 		wait_on_bit_io(&ip->i_flags, GIF_GLOP_PENDING, TASK_UNINTERRUPTIBLE);
 		gfs2_glock_add_to_lru(ip->i_gl);
 		gfs2_glock_put_eventually(ip->i_gl);
-		ip->i_gl = NULL;
+		rcu_assign_pointer(ip->i_gl, NULL);
 	}
 }
 
-- 
2.42.0



