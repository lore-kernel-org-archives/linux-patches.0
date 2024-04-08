Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288212DF73;
	Mon,  8 Apr 2024 13:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582793; cv=none; b=sPOi/hEic3uD/xc/S3VzKBovuRwMtVVoQS0VLCw/dRDh1fTMi/y6120YK14pW61HH9PC1nfhivvaT7tmCQDJ0A6AXV0OmqJdJhjh4j6RPv3xjCpxR3h68amen7g4XWEaTdNQrHEZSN3gj+VleMSMJxr40YOr5OKKpuYCQQzQbbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582793; c=relaxed/simple;
	bh=Ok3HL6gw0QzLFRLNig6jWIz8sc1MKrD2Bs7zD9Jl7YA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lg+HvCsnHiORG99z2YagXuAY/q/Jex/a7N2kW1JQCEM6LCOPh+Qx8lzCeyjW2+ze6Lq5kA2IyepMAOQOPXH7XoazjrXE/VoKCy9IWAAO83E62jRD4i+gWZdMxNjEsLi8r6w8hPaRqxGWWX7CHAg6jHkNpyhtMduRsnmBhdmjFf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SnZ4djaH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SnZ4djaH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5870C43399;
	Mon,  8 Apr 2024 13:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582793;
	bh=Ok3HL6gw0QzLFRLNig6jWIz8sc1MKrD2Bs7zD9Jl7YA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SnZ4djaHuBK8EpZklMt/0HXpsuqp1Nq13APg+Qxoh41BDtuHjw9b2LKODJud2JyCT
	 xNI9cuVuMT7RqNODJNReNFa0S+QujY/1fhdPpc7NMIgoj2CF7nAh2CFeE5wu6kgRPe
	 9Ihdisli7gRt871zsMj2vyHr1aCA4xs0A5A4nC5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Gabriel Krisman Bertazi <krisman@collabora.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 176/690] fsnotify: Protect fsnotify_handle_inode_event from no-inode events
Date: Mon,  8 Apr 2024 14:50:42 +0200
Message-ID: <20240408125405.934763379@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
---
 fs/nfsd/filecache.c              | 3 +++
 fs/notify/fsnotify.c             | 3 +++
 include/linux/fsnotify_backend.h | 1 +
 3 files changed, 7 insertions(+)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 1e8c31ed6c7c4..fbc0628c599af 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -595,6 +595,9 @@ nfsd_file_fsnotify_handle_event(struct fsnotify_mark *mark, u32 mask,
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



