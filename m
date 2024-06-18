Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70831185E6B;
	Tue, 18 Jun 2024 13:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715624; cv=none; b=X0/kyh3K3jiNJ78iFY2lJseZOj0/ALaemgEHA+nKCQ1gYMEPghh/bYuxH5Vko9C3m2XcEbRwIgyBq6A9AmgqyLUMTJL2eGpCO+49wUNi98bux2/c+Bs3G4y3BsppyqHOUDqZNIvoNvAK8Wva+u7fjnUzCZ+eJ2Cynim3KLnnERw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715624; c=relaxed/simple;
	bh=hKsJ/qjJeNrRaY6Cbisuj3xf4YGoeJXutb/b5jstHyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TEoLkjVQUJBjmpoEQZK40Eyx/I+6qVtqF7a1y1g74FjTtLTtOwwXytxlOwx8p6DZbG16D9zaxlRbCsoywsfD0Ff73JmywoVB5ieOVn+8/HOw8sq49FG5CuPIVCH2+VLn8fXfVNU34kNW002h0MdUG4gKBETv436adxgkW7pDCAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zatHub+L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zatHub+L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94FB5C3277B;
	Tue, 18 Jun 2024 13:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715624;
	bh=hKsJ/qjJeNrRaY6Cbisuj3xf4YGoeJXutb/b5jstHyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zatHub+LNPLUSToLjlsA6mUIXPU4IhlhllxqRafB0TMkQvVAYlO/6Zue9LAEhNG9a
	 8D1RFwelI+n2jmEm19+CwU5GMCItVL7qZWLtb8zf+begGbrp9/A6cW+WkocMrQLg/0
	 Z2nxJGD7Ze0J2hk+IKbk8lLC8r76+998vD/7rBWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Gabriel Krisman Bertazi <krisman@collabora.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 371/770] fsnotify: Protect fsnotify_handle_inode_event from no-inode events
Date: Tue, 18 Jun 2024 14:33:44 +0200
Message-ID: <20240618123421.590483201@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriel Krisman Bertazi <krisman@collabora.com>

[ Upstream commit 24dca90590509a7a6cbe0650100c90c5b8a3468a ]

FAN_FS_ERROR allows events without inodes - i.e. for file system-wide
errors.  Even though fsnotify_handle_inode_event is not currently used
by fanotify, this patch protects other backends from cases where neither
inode or dir are provided.  Also document the constraints of the
interface (inode and dir cannot be both NULL).

Link: https://lore.kernel.org/r/20211025192746.66445-12-krisman@collabora.com
Suggested-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c              | 3 +++
 fs/notify/fsnotify.c             | 3 +++
 include/linux/fsnotify_backend.h | 1 +
 3 files changed, 7 insertions(+)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 87d984e0cdc0c..8cd7d5d6955a0 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -601,6 +601,9 @@ nfsd_file_fsnotify_handle_event(struct fsnotify_mark *mark, u32 mask,
 				struct inode *inode, struct inode *dir,
 				const struct qstr *name, u32 cookie)
 {
+	if (WARN_ON_ONCE(!inode))
+		return 0;
+
 	trace_nfsd_file_fsnotify_handle_event(inode, mask);
 
 	/* Should be no marks on non-regular files */
diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index fde3a1115a170..4034ca566f95c 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -252,6 +252,9 @@ static int fsnotify_handle_inode_event(struct fsnotify_group *group,
 	if (WARN_ON_ONCE(!ops->handle_inode_event))
 		return 0;
 
+	if (WARN_ON_ONCE(!inode && !dir))
+		return 0;
+
 	if ((inode_mark->mask & FS_EXCL_UNLINK) &&
 	    path && d_unlinked(path->dentry))
 		return 0;
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 035438fe4a435..b71dc788018e4 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -136,6 +136,7 @@ struct mem_cgroup;
  * @dir:	optional directory associated with event -
  *		if @file_name is not NULL, this is the directory that
  *		@file_name is relative to.
+ *		Either @inode or @dir must be non-NULL.
  * @file_name:	optional file name associated with event
  * @cookie:	inotify rename cookie
  *
-- 
2.43.0



