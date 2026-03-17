Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F246F186E58;
	Tue, 17 Mar 2026 17:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767819; cv=none; b=GUpFrpHc8OSIYnW0MayQNmiugNjFBfzGOTbQOgvA+LZmsoH4Tg9tcKQjm/fykjZ7n4GCIzJnmzQ5LB9iajFofTt7HSmx6xaJ1sH12oDekhYip2uak5P1zPq4FNRmWT9E1qevjUWLMuhAG/45jEvk/gWdAroybVWIGqIjFb7woYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767819; c=relaxed/simple;
	bh=B3y2VF+xQX6Z/t+/ipvXKciZCYnc/KqXke8m6BYjUKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jmIEwXPVHH3QQkhpKZIzIe7UBMA1Mg7MmW6rfB7IsL0XSbHAsO3c2ZdA6F8jlFvFqAOc42i6ZQ0aOa4OHThveEB6lnLy77rEvW46NfyvzaZYOGmetRasXWitgmRSZVC0x8MK3WbAlgjJMX32DjelmgX0LXVbQU27s/zMmS5CiNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GjwqcKz9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GjwqcKz9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0803C4CEF7;
	Tue, 17 Mar 2026 17:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767818;
	bh=B3y2VF+xQX6Z/t+/ipvXKciZCYnc/KqXke8m6BYjUKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GjwqcKz9D/+N8Fw6QJ4WNkugQcAsIJtzgG0KTxQgYXIw7x2GiE+x0Q7WxJ1qpKo18
	 woVL4wJ72I4lHpdH8q28vNxi31+d7FPIOZO0m81gmClZmRx+txzD6pmQv3oYRx0+vE
	 SRjAwu2PSvaF7K90aU8DGFGAI1mhYUJltokwiO5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.18 164/333] ceph: add a bunch of missing ceph_path_info initializers
Date: Tue, 17 Mar 2026 17:33:13 +0100
Message-ID: <20260317163005.443994140@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Kellermann <max.kellermann@ionos.com>

commit 43323a5934b660afae687e8e4e95ac328615a5c4 upstream.

ceph_mdsc_build_path() must be called with a zero-initialized
ceph_path_info parameter, or else the following
ceph_mdsc_free_path_info() may crash.

Example crash (on Linux 6.18.12):

  virt_to_cache: Object is not a Slab page!
  WARNING: CPU: 184 PID: 2871736 at mm/slub.c:6732 kmem_cache_free+0x316/0x400
  [...]
  Call Trace:
   [...]
   ceph_open+0x13d/0x3e0
   do_dentry_open+0x134/0x480
   vfs_open+0x2a/0xe0
   path_openat+0x9a3/0x1160
  [...]
  cache_from_obj: Wrong slab cache. names_cache but object is from ceph_inode_info
  WARNING: CPU: 184 PID: 2871736 at mm/slub.c:6746 kmem_cache_free+0x2dd/0x400
  [...]
  kernel BUG at mm/slub.c:634!
  Oops: invalid opcode: 0000 [#1] SMP NOPTI
  RIP: 0010:__slab_free+0x1a4/0x350

Some of the ceph_mdsc_build_path() callers had initializers, but
others had not, even though they were all added by commit 15f519e9f883
("ceph: fix race condition validating r_parent before applying state").
The ones without initializer are suspectible to random crashes.  (I can
imagine it could even be possible to exploit this bug to elevate
privileges.)

Unfortunately, these Ceph functions are undocumented and its semantics
can only be derived from the code.  I see that ceph_mdsc_build_path()
initializes the structure only on success, but not on error.

Calling ceph_mdsc_free_path_info() after a failed
ceph_mdsc_build_path() call does not even make sense, but that's what
all callers do, and for it to be safe, the structure must be
zero-initialized.  The least intrusive approach to fix this is
therefore to add initializers everywhere.

Cc: stable@vger.kernel.org
Fixes: 15f519e9f883 ("ceph: fix race condition validating r_parent before applying state")
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/debugfs.c |    4 ++--
 fs/ceph/dir.c     |    2 +-
 fs/ceph/file.c    |    4 ++--
 fs/ceph/inode.c   |    2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -79,7 +79,7 @@ static int mdsc_show(struct seq_file *s,
 		if (req->r_inode) {
 			seq_printf(s, " #%llx", ceph_ino(req->r_inode));
 		} else if (req->r_dentry) {
-			struct ceph_path_info path_info;
+			struct ceph_path_info path_info = {0};
 			path = ceph_mdsc_build_path(mdsc, req->r_dentry, &path_info, 0);
 			if (IS_ERR(path))
 				path = NULL;
@@ -98,7 +98,7 @@ static int mdsc_show(struct seq_file *s,
 		}
 
 		if (req->r_old_dentry) {
-			struct ceph_path_info path_info;
+			struct ceph_path_info path_info = {0};
 			path = ceph_mdsc_build_path(mdsc, req->r_old_dentry, &path_info, 0);
 			if (IS_ERR(path))
 				path = NULL;
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1362,7 +1362,7 @@ static int ceph_unlink(struct inode *dir
 	if (!dn) {
 		try_async = false;
 	} else {
-		struct ceph_path_info path_info;
+		struct ceph_path_info path_info = {0};
 		path = ceph_mdsc_build_path(mdsc, dn, &path_info, 0);
 		if (IS_ERR(path)) {
 			try_async = false;
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -397,7 +397,7 @@ int ceph_open(struct inode *inode, struc
 	if (!dentry) {
 		do_sync = true;
 	} else {
-		struct ceph_path_info path_info;
+		struct ceph_path_info path_info = {0};
 		path = ceph_mdsc_build_path(mdsc, dentry, &path_info, 0);
 		if (IS_ERR(path)) {
 			do_sync = true;
@@ -807,7 +807,7 @@ int ceph_atomic_open(struct inode *dir,
 	if (!dn) {
 		try_async = false;
 	} else {
-		struct ceph_path_info path_info;
+		struct ceph_path_info path_info = {0};
 		path = ceph_mdsc_build_path(mdsc, dn, &path_info, 0);
 		if (IS_ERR(path)) {
 			try_async = false;
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2562,7 +2562,7 @@ int __ceph_setattr(struct mnt_idmap *idm
 	if (!dentry) {
 		do_sync = true;
 	} else {
-		struct ceph_path_info path_info;
+		struct ceph_path_info path_info = {0};
 		path = ceph_mdsc_build_path(mdsc, dentry, &path_info, 0);
 		if (IS_ERR(path)) {
 			do_sync = true;


