Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B34424D72;
	Mon, 17 Aug 2026 14:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978244; cv=none; b=dxR1J8oWSfqBxO2JBR/UbWS1PVTQIVabmlZq11DiAzVUKHHzAtX4h8igg8YOPJ7F3uoHREdGv5I5q1wtCDXmoMyqz+1F2L0mH7LI5FumIuMx0VVOu0zlD8td+uCcMKvpP377EhfKXyvuswCL81hcFm2BOPdUKICdPbYtsu4LJ4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978244; c=relaxed/simple;
	bh=VpEkZTSA2FX9eygQD0krsO56WWOf8YG+tU/jJSn4PTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZH30j8JiW2W0Uxqc2RGPyBII6EWUmv5cK/RNaGjmvTKLEdx26nmn6JwSINpRcr5kmyDi0YyesCi4GzJFeKN42ixYE6e0Q/Ej4WH/+RIKnnUxOpt1wLSl2DePOSN9eXHkUUtPU/4rfsQYdItPG3Wvannhs6PsSLcVwdbUbqcwcFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fGIt0bff; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fGIt0bff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EF371F000E9;
	Mon, 17 Aug 2026 14:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978242;
	bh=UQEEXvdHNjQiWwOJzwhSSXkugd3XOStQrqW8HgsdC2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fGIt0bffKD+OAu17OBlNdzRn2THnmPnhe550SSp9GmrP/x1IrbMDC60QDcxGrXHne
	 D//uktuYmtTVxbVyR3yjktnE+Tqyqr6VngTNziWoq+bLTGBcYqgKG8jXzGT8B1VR8a
	 5IOR6IFjgOCo+IGRyG1Vg/OTOd6dPjWgtseEadkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.12 150/181] binfmt_misc: dont warn when the mount is completed from another user namespace
Date: Mon, 17 Aug 2026 15:34:04 +0200
Message-ID: <20260817132541.592799908@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit 79fdf39f1a31f88cb3833b6f8091fbf6acdca2c6 upstream.

fsopen() records the caller's user namespace in fc->user_ns and hands
back an ordinary file descriptor. Nothing ties the task that calls
fsconfig(FSCONFIG_CMD_CREATE) to the task that created the context. The
fd is inherited across fork() and exec() and it can be passed over a
unix socket.

Completing a context from another user namespace is allowed on purpose.
vfs_cmd_create() authorizes the create with mount_capable(), which for
FS_USERNS_MOUNT checks ns_capable(fc->user_ns, CAP_SYS_ADMIN), and that
succeeds for a task holding CAP_SYS_ADMIN in an ancestor of fc->user_ns.
So an unprivileged task can reach the WARN_ON() in bm_fill_super():
create a user and a mount namespace in a child, call
fsopen("binfmt_misc") there, send the fscontext fd to the parent and let
the parent issue FSCONFIG_CMD_CREATE. Both namespaces come from a plain
unshare(1) and no capability is needed anywhere:

  WARNING: fs/binfmt_misc.c:938 at bm_fill_super+0xa2/0xc0 [binfmt_misc]
  CPU: 15 UID: 1000 PID: 3243382 Comm: fswarn
  Call Trace:
   get_tree_keyed+0x7d/0xb0
   bm_get_tree+0x34/0x90 [binfmt_misc]
   vfs_get_tree+0x2a/0x100
   vfs_cmd_create+0x60/0xf0
   __do_sys_fsconfig+0x4b2/0x500

The child needs the mount namespace because fsopen() itself gates on
may_mount(), which asks for CAP_SYS_ADMIN in the user namespace owning
the caller's mount namespace. fsconfig() doesn't repeat that check.

It is a WARN_ON() and not a WARN_ON_ONCE(), so the condition can be
raised in a loop to taint the kernel and flood the log, and it panics a
kernel booted with panic_on_warn.

Keep refusing the mount and stop warning about it. Nothing in
bm_fill_super() depends on the two namespaces matching, it derives
everything from sb->s_user_ns.

Fixes: 21ca59b365c0 ("binfmt_misc: enable sandboxed mounts")
Cc: stable@vger.kernel.org # v6.7+
Link: https://patch.msgid.link/20260802-work-fill_super-warn-v1-2-4e987911a39a@kernel.org
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/binfmt_misc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -983,7 +983,8 @@ static int bm_fill_super(struct super_bl
 		/* last one */ {""}
 	};
 
-	if (WARN_ON(user_ns != current_user_ns()))
+	/* The fscontext fd may have been passed to another user namespace. */
+	if (user_ns != current_user_ns())
 		return -EINVAL;
 
 	/* Never exec off this instance and never let anything stack on it. */


