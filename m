Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF39C46D56A;
	Tue, 21 Jul 2026 17:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656600; cv=none; b=FcPyW1pczcxn34azE1xTkiXGtbFCP5Yt06g9exI2/XK62BFd1eRoixAdpHS10QVXda8UYTjllwsPLn9Ot6bPpt5bwfNYMQUql4xqMymqiZ4QDK2BW1WCdoXshZMBWuRFuMJvG0yJYMvrkhKyb9c1VGRaD6nztF0w7Sq0//No6Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656600; c=relaxed/simple;
	bh=iUcPrPz1jV1SdVFSguWRQJJHyghXO8NY5SkPRqHBfZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KRJYovwGe68FQ7oN50SKJJHFba033laQqDTkao+G5zOqSXbYBN5VLQ9PJdJSPRwaIzM4yPRuonYTlKZw8VT4uLLuYXxFog3l5pyEoTqQB4+5dHoWvpwRs9gw3CZOhuNpV+uSPWteIIZHXeCEaZMFI3FNcwi1RuRzQO4zgu3NXQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tkMjsZoL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tkMjsZoL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EDE81F000E9;
	Tue, 21 Jul 2026 17:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656598;
	bh=U9w+l6E+KqUE3cbp1Je+4fUK8uODsDZIkWFaZtzK4+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tkMjsZoLOoHj/TSHb4hgz42UqVcNUh5CqVInzouPSmo4OobwhIfnT/j2KAsCiQrqv
	 FMqNxn/MMnk58/hNndzdx9fXcPjRAXaJoosvV1v2ivenn8eIvu+z5KP8pBtMeaKG7R
	 mJrXtCeaZVXLY2mi5lCxsUICXrg5PqcAi9YUDjIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Alexander Mikhalitsyn <aleksandr.mikhalitsyn@futurfusion.io>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0421/1611] vfs: add FS_USERNS_DELEGATABLE flag and set it for NFS
Date: Tue, 21 Jul 2026 17:08:57 +0200
Message-ID: <20260721152524.735437915@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit c5d6cac28646b0d5d81ef632be748ae93c1f36c7 ]

Commit e1c5ae59c0f2 ("fs: don't allow non-init s_user_ns for filesystems
without FS_USERNS_MOUNT") prevents the mount of any filesystem inside a
container that doesn't have FS_USERNS_MOUNT set.

This broke NFS mounts in our containerized environment. We have a daemon
somewhat like systemd-mountfsd running in the init_ns. A process does a
fsopen() inside the container and passes it to the daemon via unix
socket.

The daemon then vets that the request is for an allowed NFS server and
performs the mount. This now fails because the fc->user_ns is set to the
value in the container and NFS doesn't set FS_USERNS_MOUNT.  We don't
want to add FS_USERNS_MOUNT to NFS since that would allow the container
to mount any NFS server (even malicious ones).

Add a new FS_USERNS_DELEGATABLE flag, and enable it on NFS.

Fixes: e1c5ae59c0f2 ("fs: don't allow non-init s_user_ns for filesystems without FS_USERNS_MOUNT")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260129-twmount-v1-1-4874ed2a15c4@kernel.org
Acked-by: Anna Schumaker <anna.schumaker@oracle.com>
Reviewed-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@futurfusion.io>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/fs_context.c |  8 ++++++--
 fs/super.c          | 11 ++++++-----
 include/linux/fs.h  |  1 +
 3 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/fs/nfs/fs_context.c b/fs/nfs/fs_context.c
index b4679b7161b096..128ebd48b4f4ba 100644
--- a/fs/nfs/fs_context.c
+++ b/fs/nfs/fs_context.c
@@ -1768,7 +1768,9 @@ struct file_system_type nfs_fs_type = {
 	.init_fs_context	= nfs_init_fs_context,
 	.parameters		= nfs_fs_parameters,
 	.kill_sb		= nfs_kill_super,
-	.fs_flags		= FS_RENAME_DOES_D_MOVE|FS_BINARY_MOUNTDATA,
+	.fs_flags		= FS_RENAME_DOES_D_MOVE	|
+				  FS_BINARY_MOUNTDATA	|
+				  FS_USERNS_DELEGATABLE,
 };
 MODULE_ALIAS_FS("nfs");
 EXPORT_SYMBOL_GPL(nfs_fs_type);
@@ -1780,7 +1782,9 @@ struct file_system_type nfs4_fs_type = {
 	.init_fs_context	= nfs_init_fs_context,
 	.parameters		= nfs_fs_parameters,
 	.kill_sb		= nfs_kill_super,
-	.fs_flags		= FS_RENAME_DOES_D_MOVE|FS_BINARY_MOUNTDATA,
+	.fs_flags		= FS_RENAME_DOES_D_MOVE	|
+				  FS_BINARY_MOUNTDATA	|
+				  FS_USERNS_DELEGATABLE,
 };
 MODULE_ALIAS_FS("nfs4");
 MODULE_ALIAS("nfs4");
diff --git a/fs/super.c b/fs/super.c
index 4c79f170ac0d27..ce6e5b4ff3c5f6 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -737,12 +737,13 @@ struct super_block *sget_fc(struct fs_context *fc,
 	int err;
 
 	/*
-	 * Never allow s_user_ns != &init_user_ns when FS_USERNS_MOUNT is
-	 * not set, as the filesystem is likely unprepared to handle it.
-	 * This can happen when fsconfig() is called from init_user_ns with
-	 * an fs_fd opened in another user namespace.
+	 * Never allow s_user_ns != &init_user_ns when FS_USERNS_MOUNT or
+	 * FS_USERNS_DELEGATABLE is not set, as the filesystem is likely
+	 * unprepared to handle it. This can happen when fsconfig() is called
+	 * from init_user_ns with an fs_fd opened in another user namespace.
 	 */
-	if (user_ns != &init_user_ns && !(fc->fs_type->fs_flags & FS_USERNS_MOUNT)) {
+	if (user_ns != &init_user_ns &&
+	    !(fc->fs_type->fs_flags & (FS_USERNS_MOUNT | FS_USERNS_DELEGATABLE))) {
 		errorfc(fc, "VFS: Mounting from non-initial user namespace is not allowed");
 		return ERR_PTR(-EPERM);
 	}
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 39269c7d167e6d..6374649060ba34 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2693,6 +2693,7 @@ struct file_system_type {
 #define FS_MGTIME		64	/* FS uses multigrain timestamps */
 #define FS_LBS			128	/* FS supports LBS */
 #define FS_POWER_FREEZE		256	/* Always freeze on suspend/hibernate */
+#define FS_USERNS_DELEGATABLE	1024	/* Can be mounted inside userns from outside */
 #define FS_RENAME_DOES_D_MOVE	32768	/* FS will handle d_move() during rename() internally. */
 	int (*init_fs_context)(struct fs_context *);
 	const struct fs_parameter_spec *parameters;
-- 
2.53.0



