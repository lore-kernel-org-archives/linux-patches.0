Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E0022DE6E5;
	Thu,  3 Jul 2025 14:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751553881; cv=none; b=E2QpEHHO0zPkSRhQFGN4MzdT4blerYONvB1wsWkx+x6ce6TOyHvjTEnDyFhGCfs/K1rt7Mv+s2IF5d+MD5LzOKjjZBgBse6mBBmybmXt5WLOYVL3rzFP3nC6157gX8O7Kf0LqJr+MYtjDzHgNEeb0Jghu65c+iRgj4olq9g+yz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751553881; c=relaxed/simple;
	bh=ft+Dwkmiob4WtVKhlmCh+UNG5NXpnBBcyzbWCsNFdaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dVUxDYPYJOuaGrzUCSJkLl3PLOtjSvsO4EJmp/Zq8xQhI0ICrgqvK2YcYofSfYNsdJPCHOSIzm1FRMUODdl907o4E3O5Ykos1t4+0NYtZrECUwnKnOqf9tnFiXVb73UdSKvqhlm5djPdTxtSg4zpAIc6SiH0W6Yh1sKIksBR7D4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dgjowKXw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dgjowKXw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57D3AC4CEED;
	Thu,  3 Jul 2025 14:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751553880;
	bh=ft+Dwkmiob4WtVKhlmCh+UNG5NXpnBBcyzbWCsNFdaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dgjowKXwlCzQXkYi7gC0Ix00yDkNLmDNQm6VJjMwP6gV0KCzZgvs/k+eeRddYHPXs
	 IAlrXGLvB4Ay9dG9AgAY/W/T+uL6jJzD7xYlRTEBC9KU/n6OJ6eNKH/zwiqju2n6Tv
	 yNnr5bxWQg/Lnl2xzrocvKk1hMZnLvlPi3UEP7JU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guang Yuan Wu <gwu@ddn.com>,
	Bernd Schubert <bschubert@ddn.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 012/218] fuse: fix race between concurrent setattrs from multiple nodes
Date: Thu,  3 Jul 2025 16:39:20 +0200
Message-ID: <20250703143956.450551288@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

From: Guang Yuan Wu <gwu@ddn.com>

[ Upstream commit 69efbff69f89c9b2b72c4d82ad8b59706add768a ]

When mounting a user-space filesystem on multiple clients, after
concurrent ->setattr() calls from different node, stale inode
attributes may be cached in some node.

This is caused by fuse_setattr() racing with
fuse_reverse_inval_inode().

When filesystem server receives setattr request, the client node
with valid iattr cached will be required to update the fuse_inode's
attr_version and invalidate the cache by fuse_reverse_inval_inode(),
and at the next call to ->getattr() they will be fetched from user
space.

The race scenario is:
1. client-1 sends setattr (iattr-1) request to server
2. client-1 receives the reply from server
3. before client-1 updates iattr-1 to the cached attributes by
   fuse_change_attributes_common(), server receives another setattr
   (iattr-2) request from client-2
4. server requests client-1 to update the inode attr_version and
   invalidate the cached iattr, and iattr-1 becomes staled
5. client-2 receives the reply from server, and caches iattr-2
6. continue with step 2, client-1 invokes
   fuse_change_attributes_common(), and caches iattr-1

The issue has been observed from concurrent of chmod, chown, or
truncate, which all invoke ->setattr() call.

The solution is to use fuse_inode's attr_version to check whether
the attributes have been modified during the setattr request's
lifetime.  If so, mark the attributes as invalid in the function
fuse_change_attributes_common().

Signed-off-by: Guang Yuan Wu <gwu@ddn.com>
Reviewed-by: Bernd Schubert <bschubert@ddn.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/dir.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index ff543dc09130e..ce7324d0d9ed1 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1921,6 +1921,7 @@ int fuse_do_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 	int err;
 	bool trust_local_cmtime = is_wb;
 	bool fault_blocked = false;
+	u64 attr_version;
 
 	if (!fc->default_permissions)
 		attr->ia_valid |= ATTR_FORCE;
@@ -2005,6 +2006,8 @@ int fuse_do_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 		if (fc->handle_killpriv_v2 && !capable(CAP_FSETID))
 			inarg.valid |= FATTR_KILL_SUIDGID;
 	}
+
+	attr_version = fuse_get_attr_version(fm->fc);
 	fuse_setattr_fill(fc, &args, inode, &inarg, &outarg);
 	err = fuse_simple_request(fm, &args);
 	if (err) {
@@ -2030,6 +2033,14 @@ int fuse_do_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 		/* FIXME: clear I_DIRTY_SYNC? */
 	}
 
+	if (fi->attr_version > attr_version) {
+		/*
+		 * Apply attributes, for example for fsnotify_change(), but set
+		 * attribute timeout to zero.
+		 */
+		outarg.attr_valid = outarg.attr_valid_nsec = 0;
+	}
+
 	fuse_change_attributes_common(inode, &outarg.attr, NULL,
 				      ATTR_TIMEOUT(&outarg),
 				      fuse_get_cache_mask(inode));
-- 
2.39.5



