Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF8D31748;
	Fri, 24 Nov 2023 18:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e5tivaIJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF4DFC433C8;
	Fri, 24 Nov 2023 18:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851858;
	bh=0VITVK+hBvY5QCKMlf4TTvmOQld067iQ7PAGL4FLtUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e5tivaIJSdr2eAC2SbJQNmAB+EC5yVyAV3ipk+rS/7ZGo9Dya5wanlJVgWrnQKSGe
	 vjn2Oc2S82RZx6+ajJbX/iQSDFLhwYqSoXqkIaNLHSyZP5ebSrOpzkyg3SEpkJXjut
	 W+IevOl4j47qJOD21mEKVk6hSvtKoNm+ad0e9Rwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3e5130844b0c0e2b4948@syzkaller.appspotmail.com,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 124/372] gfs2: Silence "suspicious RCU usage in gfs2_permission" warning
Date: Fri, 24 Nov 2023 17:48:31 +0000
Message-ID: <20231124172014.613150229@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
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

[ Upstream commit 074d7306a4fe22fcac0b53f699f92757ab1cee99 ]

Commit 0abd1557e21c added rcu_dereference() for dereferencing ip->i_gl
in gfs2_permission.  This now causes lockdep to complain when
gfs2_permission is called in non-RCU context:

    WARNING: suspicious RCU usage in gfs2_permission

Switch to rcu_dereference_check() and check for the MAY_NOT_BLOCK flag
to shut up lockdep when we know that dereferencing ip->i_gl is safe.

Fixes: 0abd1557e21c ("gfs2: fix an oops in gfs2_permission")
Reported-by: syzbot+3e5130844b0c0e2b4948@syzkaller.appspotmail.com
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/inode.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index d126b02893eb0..23e6962cdd6e3 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -1845,6 +1845,7 @@ static const char *gfs2_get_link(struct dentry *dentry,
 int gfs2_permission(struct user_namespace *mnt_userns, struct inode *inode,
 		    int mask)
 {
+	int may_not_block = mask & MAY_NOT_BLOCK;
 	struct gfs2_inode *ip;
 	struct gfs2_holder i_gh;
 	struct gfs2_glock *gl;
@@ -1852,14 +1853,14 @@ int gfs2_permission(struct user_namespace *mnt_userns, struct inode *inode,
 
 	gfs2_holder_mark_uninitialized(&i_gh);
 	ip = GFS2_I(inode);
-	gl = rcu_dereference(ip->i_gl);
+	gl = rcu_dereference_check(ip->i_gl, !may_not_block);
 	if (unlikely(!gl)) {
 		/* inode is getting torn down, must be RCU mode */
-		WARN_ON_ONCE(!(mask & MAY_NOT_BLOCK));
+		WARN_ON_ONCE(!may_not_block);
 		return -ECHILD;
         }
 	if (gfs2_glock_is_locked_by_me(gl) == NULL) {
-		if (mask & MAY_NOT_BLOCK)
+		if (may_not_block)
 			return -ECHILD;
 		error = gfs2_glock_nq_init(gl, LM_ST_SHARED, LM_FLAG_ANY, &i_gh);
 		if (error)
-- 
2.42.0



