Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B890C5028C;
	Tue, 14 May 2024 11:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685987; cv=none; b=u4XzAQbZ6n3SXx5Qv8b7Bu8VtRzOSFLR5wTWI1mVMb+0ROh/KczBt2K7juyNiuFSuv4LsoEG5bRfj7uAvqGlPBxVPVW0jfz8UmSOpTxD//MaUShLhRAcFqZSpeRlue42HVJ6Mslnn31y1AOH5l8TFVuDeS3XyyR04ZoBYgtFsko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685987; c=relaxed/simple;
	bh=p9M40+J11mnJVl15l31K02Bkpz95UfLG2c7Wpt+h+Pw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uy1UYvjkTb9jLLUo+nbLwSUYqjaVAHkZU0Fc5aNmd4xYShgUy+XfS/s7P2F7F/wyPWsG90e82P4QWYamk5jCzeBXLG3nD/tUklCDzO+88/RM8UjZJnJCvJhlfN+J6a6m/xuGjAbTlJnqgiGAymUYwfB49cnLxNi8zf9aUoSKHNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zrm93ABz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zrm93ABz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21D7DC2BD10;
	Tue, 14 May 2024 11:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685987;
	bh=p9M40+J11mnJVl15l31K02Bkpz95UfLG2c7Wpt+h+Pw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zrm93ABzRc962GRMTgN9As9j+r1U3kWC+/LX4dSqlWhMe3lcxYPzAqDaH9qZcsa9C
	 IqKOiXCUg4O1Nv2IwuUotIfS8UdefSTLVVXjBWOWiQzKM0ZEHEkSMhF2WaDIVdkvFJ
	 H1avdRRBrAdPAIZAD1aq89QEDgWiO9rnQP9lWe4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 291/301] tracefs: Still use mount point as default permissions for instances
Date: Tue, 14 May 2024 12:19:22 +0200
Message-ID: <20240514101043.248323776@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit 6599bd5517be66c8344f869f3ca3a91bc10f2b9e upstream.

If the instances directory's permissions were never change, then have it
and its children use the mount point permissions as the default.

Currently, the permissions of instance directories are determined by the
instance directory's permissions itself. But if the tracefs file system is
remounted and changes the permissions, the instance directory and its
children should use the new permission.

But because both the instance directory and its children use the instance
directory's inode for permissions, it misses the update.

To demonstrate this:

  # cd /sys/kernel/tracing/
  # mkdir instances/foo
  # ls -ld instances/foo
 drwxr-x--- 5 root root 0 May  1 19:07 instances/foo
  # ls -ld instances
 drwxr-x--- 3 root root 0 May  1 18:57 instances
  # ls -ld current_tracer
 -rw-r----- 1 root root 0 May  1 18:57 current_tracer

  # mount -o remount,gid=1002 .
  # ls -ld instances
 drwxr-x--- 3 root root 0 May  1 18:57 instances
  # ls -ld instances/foo/
 drwxr-x--- 5 root root 0 May  1 19:07 instances/foo/
  # ls -ld current_tracer
 -rw-r----- 1 root lkp 0 May  1 18:57 current_tracer

Notice that changing the group id to that of "lkp" did not affect the
instances directory nor its children. It should have been:

  # ls -ld current_tracer
 -rw-r----- 1 root root 0 May  1 19:19 current_tracer
  # ls -ld instances/foo/
 drwxr-x--- 5 root root 0 May  1 19:25 instances/foo/
  # ls -ld instances
 drwxr-x--- 3 root root 0 May  1 19:19 instances

  # mount -o remount,gid=1002 .
  # ls -ld current_tracer
 -rw-r----- 1 root lkp 0 May  1 19:19 current_tracer
  # ls -ld instances
 drwxr-x--- 3 root lkp 0 May  1 19:19 instances
  # ls -ld instances/foo/
 drwxr-x--- 5 root lkp 0 May  1 19:25 instances/foo/

Where all files were updated by the remount gid update.

Link: https://lore.kernel.org/linux-trace-kernel/20240502200905.686838327@goodmis.org

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Fixes: 8186fff7ab649 ("tracefs/eventfs: Use root and instance inodes as default ownership")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/inode.c |   27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

--- a/fs/tracefs/inode.c
+++ b/fs/tracefs/inode.c
@@ -180,16 +180,39 @@ static void set_tracefs_inode_owner(stru
 {
 	struct tracefs_inode *ti = get_tracefs(inode);
 	struct inode *root_inode = ti->private;
+	kuid_t uid;
+	kgid_t gid;
+
+	uid = root_inode->i_uid;
+	gid = root_inode->i_gid;
+
+	/*
+	 * If the root is not the mount point, then check the root's
+	 * permissions. If it was never set, then default to the
+	 * mount point.
+	 */
+	if (root_inode != d_inode(root_inode->i_sb->s_root)) {
+		struct tracefs_inode *rti;
+
+		rti = get_tracefs(root_inode);
+		root_inode = d_inode(root_inode->i_sb->s_root);
+
+		if (!(rti->flags & TRACEFS_UID_PERM_SET))
+			uid = root_inode->i_uid;
+
+		if (!(rti->flags & TRACEFS_GID_PERM_SET))
+			gid = root_inode->i_gid;
+	}
 
 	/*
 	 * If this inode has never been referenced, then update
 	 * the permissions to the superblock.
 	 */
 	if (!(ti->flags & TRACEFS_UID_PERM_SET))
-		inode->i_uid = root_inode->i_uid;
+		inode->i_uid = uid;
 
 	if (!(ti->flags & TRACEFS_GID_PERM_SET))
-		inode->i_gid = root_inode->i_gid;
+		inode->i_gid = gid;
 }
 
 static int tracefs_permission(struct mnt_idmap *idmap,


