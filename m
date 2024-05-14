Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D9042A9C;
	Tue, 14 May 2024 10:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684109; cv=none; b=hQ3Cw4DDz9p3Bx2m2QhusBIO8d4HDzch0mNzr7+yVFxqHqFg9KQIL34FNiJTD8nWZhfNDkIATMjPrA+1921ut/4KQXv7fFNExtjppHTg+caP2icjZAnAaMotZH2DHBdr9vRtqPS1jC6vE9CfQGnNC7ydl9nSRi9rZXmXSMPcSPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684109; c=relaxed/simple;
	bh=6phRdbtZSwo4nc/BKN5+xKUurvSPCaig7Bn1e7dYPVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AjGgZu6DExHZ6QsE2moyCDNy8DBQ/CuC9Hvl1JpXqszYG0WqZHZgEEKWr+laMNs23qJ7IcQO9trD6g2D8D+cySml2t/F10Xqwn1fHzNzVhppnekS8+InWkcsZxy3/qgQtFTG0SiKG+n0LYwxPe7o9Hhq+CvemZF0OHTIN5V/SMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sH832HI1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sH832HI1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A878CC2BD10;
	Tue, 14 May 2024 10:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684109;
	bh=6phRdbtZSwo4nc/BKN5+xKUurvSPCaig7Bn1e7dYPVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sH832HI1X4+YxvRF+xoWa/zQAb9U1UK1RXliRhmMeV9jjku9zrVpUQPY89Ckfyv0I
	 Dp3ImDh0tMTERdO3gEIVV1GBoKMfnUvZlITeW0Ww4+2caY8vLFYdwVUN1E27vHu6td
	 qvZW2V5eh2BI2jPDqPXeMHgF3ST0Eidtuv5QbHRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.8 326/336] tracefs: Still use mount point as default permissions for instances
Date: Tue, 14 May 2024 12:18:50 +0200
Message-ID: <20240514101050.930675580@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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


