Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B1D2D9492;
	Thu,  3 Jul 2025 15:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555425; cv=none; b=Ar6ed5GC0iHoFgfm4QReM9E6RPgjmw8A66SHVxDm+jQDb67aNIMxhTlPemWNmewNU535FO6P6dKullC+/fiaU7Jp9GW5/j7pGeU2a5F9W7mFWCMEdgN0uFwHMdkfDi1ZSbl8R407dDgl9z8NBGwdVxwEvga8C5ySYePaaOBvt3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555425; c=relaxed/simple;
	bh=ex9lhKvW9/1U5kp0cX+hsXxGssVKOh2J07vrL/WMArs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QA3Eit1uJwjeElAI+uzYLp4qEUOS+QW8adUHeHUNNO6zVmIJPUOT5a1n15J8gxv0VsGIwV2P8CoaRzALvLeH6wf9KUvLsyP9ESJdTJ8Z0lhI8qzuj24iKGxDapDeUI/4kmaHFuTL3Qb+jf/MSr3f4Rnq5RTDytVZ+BbqOxUWtkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xtgAsqjr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xtgAsqjr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A408C4CEE3;
	Thu,  3 Jul 2025 15:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555425;
	bh=ex9lhKvW9/1U5kp0cX+hsXxGssVKOh2J07vrL/WMArs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xtgAsqjrLCr5xAjdVLgrRFot9Q/hDAk2104+nY2pkP8+cXaDTC7MAIEWoaYj1vuue
	 4QpZLyxjjgs29lkIVy4dvVhWDPlhSFleKiJr/dbB8Tad+S6wyHuZkrjcN9R5mggW5y
	 ysfEbBAI7BYRrBVumMSU5FYRzTzFDMm1A5Ytx7/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guang Yuan Wu <gwu@ddn.com>,
	Bernd Schubert <bschubert@ddn.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 010/139] fuse: fix race between concurrent setattrs from multiple nodes
Date: Thu,  3 Jul 2025 16:41:13 +0200
Message-ID: <20250703143941.579816012@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 82951a535d2d4..0b84284ece98f 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1860,6 +1860,7 @@ int fuse_do_setattr(struct dentry *dentry, struct iattr *attr,
 	int err;
 	bool trust_local_cmtime = is_wb;
 	bool fault_blocked = false;
+	u64 attr_version;
 
 	if (!fc->default_permissions)
 		attr->ia_valid |= ATTR_FORCE;
@@ -1944,6 +1945,8 @@ int fuse_do_setattr(struct dentry *dentry, struct iattr *attr,
 		if (fc->handle_killpriv_v2 && !capable(CAP_FSETID))
 			inarg.valid |= FATTR_KILL_SUIDGID;
 	}
+
+	attr_version = fuse_get_attr_version(fm->fc);
 	fuse_setattr_fill(fc, &args, inode, &inarg, &outarg);
 	err = fuse_simple_request(fm, &args);
 	if (err) {
@@ -1969,6 +1972,14 @@ int fuse_do_setattr(struct dentry *dentry, struct iattr *attr,
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



