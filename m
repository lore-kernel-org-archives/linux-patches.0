Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770393F12EF;
	Mon, 17 Aug 2026 14:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975231; cv=none; b=RSwGkYUXy1o9u32D9sQX0QUFE0ZwRNw+7nQjQFRHsrfWx/RbVRhOj4A1stq8e64Os9ylS9Kf8KmTz9ckIMw803u8a+Pkm/SQ3WaCYamHLirQGA5jVBtHfzDqPbhvbOydYG9A22vuOH7NhE/k8xgIDKIaP1zfJw55h59SNVXo3sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975231; c=relaxed/simple;
	bh=UhAdvaj3t9Twht492jYNFaPD7FMUYSY0GKNYjCqpZ2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kJfH3lv7acwegLPs/eQ/QjGALrMkq1W3+1jXeCwRMTilWMkq+hXtitSdndBCN3xtuAlDn2DoFOJozvsNuB2LCVK7lUh1wHXmycAYStuC7o2MhfP9Wdf15lWIDDSY4O2V5BJDDhv+utRNRERGA5mCtstxUk6EipKvTcb1u+HbqH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zC8ni5g1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zC8ni5g1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C39731F00A3A;
	Mon, 17 Aug 2026 14:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975230;
	bh=+WG/R8yImWQNsYwO6YPWx2/RN2DdeNvGUgluc1u4K4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zC8ni5g1G+BmW3jLB5rXwSrWO7DgXF5Yx8p8j8pyuMCbMv//5JEFvoMRr2CnbuOsm
	 GihVmQ+Hq7h6QkZn/dCWMAKxZN4YiR/sBM7N/DYb+FRUuBuxi/nppKu2rcozDGHnoz
	 lY7Fk4H3K454aJ28EtgrULdbE7e9lp5pNKUudCTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 208/250] binfmt_misc: dont warn when the mount is completed from another user namespace
Date: Mon, 17 Aug 2026 15:32:49 +0200
Message-ID: <20260817132545.043748647@linuxfoundation.org>
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
@@ -953,7 +953,8 @@ static int bm_fill_super(struct super_bl
 		/* last one */ {""}
 	};
 
-	if (WARN_ON(user_ns != current_user_ns()))
+	/* The fscontext fd may have been passed to another user namespace. */
+	if (user_ns != current_user_ns())
 		return -EINVAL;
 
 	/* Never exec off this instance and never let anything stack on it. */


