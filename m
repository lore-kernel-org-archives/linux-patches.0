Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84EA52D5A01;
	Mon, 17 Aug 2026 14:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975228; cv=none; b=scgwKqvRMyOdDCo3stjUKUwIv55lYRWd2ToSCGbR9Eb/IqRAs9HyQ+8yinnkJvw5tz3S9xHY+00dbfkNEuOBxiOu7ciDfdKzhvQaDC7zZSQPM4I7/+KbPkybg9cSotDZinApmZ8yXiLvO4oetsNO23+vASU2fd0m8+7dbfl5smk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975228; c=relaxed/simple;
	bh=AB+ZgZ6T51Y0vgEGKZeWFNc0B1MsKET+at72F/JDWlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pz2BPz5nfPCNyYdmeenXt7WkE1bQK9RNSH+7mbKfgy4X7m46TBW2/ou6AqXaWLhaLzDhycZcjJNZCz0SEdowGfjDq4nteazh+LiwcFw0Z26XzmFa9iOmjQKYxUHRHzvFG2Sz9a79alafNkAFxYx5wgc5MP9YODf9YFW+rBq2Ik8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KUZoE7IP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KUZoE7IP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCAD81F000E9;
	Mon, 17 Aug 2026 14:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975227;
	bh=sqz6Nx8hAmr4nW/e/tR8Kr5mnTe9WT2CAMDTgT/VNMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KUZoE7IPPAZ+QJI26z86Q5KTy8JKB8V+URZqY7RTwwHJeg+alOq2+nCrb1dNDgTYB
	 vLDxafL7w0PcXknLP0wNHO8cb4HzAcKnqC26U2wVgWOqFD6VVXU9tam3o63nze8XIo
	 loJdb1B5TooHoNOu+Jv/rlOg8oM46W1wO0/wn8uU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 207/250] ovl: dont warn when the mount is completed from another user namespace
Date: Mon, 17 Aug 2026 15:32:48 +0200
Message-ID: <20260817132544.995814962@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

commit 63981fc786daaa626cb14d9be1406f674d79f98f upstream.

fsopen() records the caller's user namespace in fc->user_ns and hands
back an ordinary file descriptor. Nothing ties the task that calls
fsconfig(FSCONFIG_CMD_CREATE) to the task that created the context. The
fd is inherited across fork() and exec() and it can be passed over a
unix socket.

Completing a context from another user namespace is allowed on purpose.
vfs_cmd_create() authorizes the create with mount_capable(), which for
FS_USERNS_MOUNT checks ns_capable(fc->user_ns, CAP_SYS_ADMIN), and that
succeeds for a task holding CAP_SYS_ADMIN in an ancestor of fc->user_ns.
So an unprivileged task can reach the WARN_ON() in ovl_fill_super():
create a user and a mount namespace in a child, call fsopen("overlay")
there, send the fscontext fd to the parent and let the parent issue
FSCONFIG_CMD_CREATE. Both namespaces come from a plain unshare(1) and no
capability is needed anywhere:

  WARNING: fs/overlayfs/super.c:1551 at ovl_fill_super+0x7b9/0x1e20 [overlay]
  CPU: 3 UID: 1000 PID: 3243376 Comm: fswarn
  Call Trace:
   get_tree_nodev+0x71/0xa0
   ovl_get_tree+0x15/0x20 [overlay]
   vfs_get_tree+0x2a/0x100
   vfs_cmd_create+0x60/0xf0
   __do_sys_fsconfig+0x4b2/0x500

The child needs the mount namespace because fsopen() itself gates on
may_mount(), which asks for CAP_SYS_ADMIN in the user namespace owning
the caller's mount namespace. fsconfig() doesn't repeat that check.

It is a WARN_ON() and not a WARN_ON_ONCE(), so the condition can be
raised in a loop to taint the kernel and flood the log, and it panics a
kernel booted with panic_on_warn.

Keep refusing the mount and stop warning about it. ovl_parse_param()
already spells a user namespace check this way for Opt_override_creds.

Fixes: 1784fbc2ed9c ("ovl: port to new mount api")
Cc: stable@vger.kernel.org # v6.5+
Link: https://patch.msgid.link/20260802-work-fill_super-warn-v1-1-4e987911a39a@kernel.org
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/super.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1381,7 +1381,8 @@ int ovl_fill_super(struct super_block *s
 	int err;
 
 	err = -EIO;
-	if (WARN_ON(fc->user_ns != current_user_ns()))
+	/* The fscontext fd may have been passed to another user namespace. */
+	if (fc->user_ns != current_user_ns())
 		goto out_err;
 
 	ovl_set_d_op(sb);


