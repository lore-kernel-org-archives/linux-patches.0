Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35BD22E7BBE;
	Thu,  3 Jul 2025 14:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554588; cv=none; b=JUt7ceG/zxnkrPmeS+AiNLcaHMyu11g5auJukR55Bgelhe8MZ+vdKznBsQxB8ExtTWn2TAuGyXiUcvGMDxaMWarWoMiHsGtwNOd3VJlD+SWnmDRnRVyhu4ZYLWnsUy3X4IV1e6Jivpypd8Thrr0GQ9RbOwxQU0aI4c6+B7ZyZEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554588; c=relaxed/simple;
	bh=CzcB0bvDGTe73W4b2f0zvjzia0Cw10Eg/cpEoItMK54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ibpedAudtcMACVu7KbiFFxX7sOgApPSBPddyvvo1wLe8NH6pJ3RAhClUJQQ9NFyq0tgCD2MmcZTOrWBbNOfGJTJF0DqV8Kwrkqtf3kNvYkkNQFdFwlygVtokTv54q1CaOKycr3hwp0lXbYOKrP8a/Oaph87NIOFkzEL3tZpLoMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dF1iA9LW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dF1iA9LW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8160EC4CEE3;
	Thu,  3 Jul 2025 14:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554588;
	bh=CzcB0bvDGTe73W4b2f0zvjzia0Cw10Eg/cpEoItMK54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dF1iA9LWaBXHqeAmRgfhSIJpCpMBIvsJ0V4BOSJKC/9NMtafp59+l23Ro2gWv47df
	 UPtFa2As4gch75kb1FVQmwDioTJVOUTzUsm5vT2wxxTzZOmSo+HXhYdaCy+ULN+rQt
	 sVkKUudrwm5HqihnZA7BHvgZqqur28sVVUo/r+yU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guang Yuan Wu <gwu@ddn.com>,
	Bernd Schubert <bschubert@ddn.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 017/263] fuse: fix race between concurrent setattrs from multiple nodes
Date: Thu,  3 Jul 2025 16:38:57 +0200
Message-ID: <20250703144004.985763978@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 83ac192e7fdd1..fa90309030e21 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1946,6 +1946,7 @@ int fuse_do_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 	int err;
 	bool trust_local_cmtime = is_wb;
 	bool fault_blocked = false;
+	u64 attr_version;
 
 	if (!fc->default_permissions)
 		attr->ia_valid |= ATTR_FORCE;
@@ -2030,6 +2031,8 @@ int fuse_do_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 		if (fc->handle_killpriv_v2 && !capable(CAP_FSETID))
 			inarg.valid |= FATTR_KILL_SUIDGID;
 	}
+
+	attr_version = fuse_get_attr_version(fm->fc);
 	fuse_setattr_fill(fc, &args, inode, &inarg, &outarg);
 	err = fuse_simple_request(fm, &args);
 	if (err) {
@@ -2055,6 +2058,14 @@ int fuse_do_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
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
 				      fuse_get_cache_mask(inode), 0);
-- 
2.39.5



