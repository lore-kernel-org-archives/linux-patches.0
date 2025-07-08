Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058148F5B;
	Tue,  8 Jul 2025 16:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992936; cv=none; b=GHflSAIfx84M2PYXqq68Vcqi96cVOOeibuflwExcrlI0bdpKOWEidHXnnavhf273BciSvsjJ1dtcSdy3g4vy0oHbQp9UPiPsSX0QnXL0GZhVxgn/DMQeCubaR+Eas9TJz9XOWmo6AlRENYDgQkYaQa9kxjfKYzAJB4vgW6Z9Ga0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992936; c=relaxed/simple;
	bh=SFpNC2r1nCfyhTnPYWxuysrLiufE8ravO9oz1Pmahiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FkPPdGI9brjdMJbHtw2FdMqPWkJ4wdCiilWW6B7P+OPbkJFdqDr4fSoz+7R2iyqvPGDHgF12y+PiWxx9+OQ76smlvlB9rKCQYwWTEr51NWMnL+0IC2dtdd9YPwMi81WyjSIQiG/c3i9iB4oE6sqcd2mNoPdLfWQBqBylyk/uy5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pdVFz7i5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pdVFz7i5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AC58C4CEF0;
	Tue,  8 Jul 2025 16:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992935;
	bh=SFpNC2r1nCfyhTnPYWxuysrLiufE8ravO9oz1Pmahiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pdVFz7i57Z/2nzB1JKe7Xrxv5CB+yghJVCH2t/b5ILNR3d3Pt2rIDNKjhVBHp0Enq
	 p2bDhVDW+QK04ZPpPbRu0IRuaKiqR42nylvNvBfpUxvAjRQLE4Zo4hsDgWGSYz9bmh
	 uRiB8iknhmDtLwx42a9ilHZPeEzhudKSGVxn2mvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 101/232] gfs2: Initialize gl_no_formal_ino earlier
Date: Tue,  8 Jul 2025 18:21:37 +0200
Message-ID: <20250708162244.086882400@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 1072b3aa6863bc4d91006038b032bfb4dcc98dec ]

Set gl_no_formal_ino of the iopen glock to the generation of the
associated inode (ip->i_no_formal_ino) as soon as that value is known.
This saves us from setting it later, possibly repeatedly, when queuing
GLF_VERIFY_DELETE work.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Stable-dep-of: 2c63986dd35f ("gfs2: deallocate inodes in gfs2_create_inode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glock.c | 1 -
 fs/gfs2/glops.c | 9 ++++++++-
 fs/gfs2/inode.c | 1 +
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index aecce4bb5e1a9..ed699f2872f55 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -985,7 +985,6 @@ static bool gfs2_try_evict(struct gfs2_glock *gl)
 		ip = NULL;
 	spin_unlock(&gl->gl_lockref.lock);
 	if (ip) {
-		gl->gl_no_formal_ino = ip->i_no_formal_ino;
 		set_bit(GIF_DEFERRED_DELETE, &ip->i_flags);
 		d_prune_aliases(&ip->i_inode);
 		iput(&ip->i_inode);
diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 72a0601ce65e2..4b6b23c638e29 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -494,11 +494,18 @@ int gfs2_inode_refresh(struct gfs2_inode *ip)
 static int inode_go_instantiate(struct gfs2_glock *gl)
 {
 	struct gfs2_inode *ip = gl->gl_object;
+	struct gfs2_glock *io_gl;
+	int error;
 
 	if (!ip) /* no inode to populate - read it in later */
 		return 0;
 
-	return gfs2_inode_refresh(ip);
+	error = gfs2_inode_refresh(ip);
+	if (error)
+		return error;
+	io_gl = ip->i_iopen_gh.gh_gl;
+	io_gl->gl_no_formal_ino = ip->i_no_formal_ino;
+	return 0;
 }
 
 static int inode_go_held(struct gfs2_holder *gh)
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 3be24285ab01d..2d2f7646440f5 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -751,6 +751,7 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	if (error)
 		goto fail_free_inode;
 	gfs2_cancel_delete_work(io_gl);
+	io_gl->gl_no_formal_ino = ip->i_no_formal_ino;
 
 retry:
 	error = insert_inode_locked4(inode, ip->i_no_addr, iget_test, &ip->i_no_addr);
-- 
2.39.5



