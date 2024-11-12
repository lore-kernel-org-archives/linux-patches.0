Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B58B219E23;
	Tue, 12 Nov 2024 10:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408321; cv=none; b=afiRNGJQisg4CJCCDbCv2A11JykFA7qTCNyk/pQAD+5baqop75nlLI5DRbzTppM8bWoW2j3RncEA2KRFWXNFwcWqQLq9RcwHgb1NIL6x60Vij+fnPvhjHCvlykDWRmYdcK5Y9nuiGPX1aTor1a7S2MjDcHdb1HBoIsB1cHJF3bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408321; c=relaxed/simple;
	bh=wbCI4opvV8kBW5mZSDUUs8Q+XSH/7w4CMDvcYjax2pU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AzVzlur+nY5zH+oYEQnOXtNDRy1PTyqkBEoXPnzIJUr9hA97Cd7Fw3d6muyOCj37PGNTIPIb1fnv7NUag4mlaCO6E7jNOBfcvXeBcx6OeBy6RMFST6eYfFz2woIPBKIBvnl/582r6TQncMPN38wi7zNM4S5Cl4JbNUYzyGMx+RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2SLexu3L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2SLexu3L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED93C4CECD;
	Tue, 12 Nov 2024 10:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408320;
	bh=wbCI4opvV8kBW5mZSDUUs8Q+XSH/7w4CMDvcYjax2pU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2SLexu3LYS5QeeooI55mUHlivVk4Yh1ic8zmv6TqMAoNmFBvZOXNFe3zMP5R27bo1
	 uETTOfmnOyNHewvV9Msh+iOL2JBSqpoeImL/0SOIEpAIbyDoaQJgHtK499FqM7U8zn
	 v2jr/XNw+gNhfwXQydltQ8jqDC8VxMuNVR74/FIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Sandeen <sandeen@redhat.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Shuah Khan <shuah@kernel.org>,
	Ali Zahraee <ahzahraee@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Kalesh Singh <kaleshsingh@google.com>
Subject: [PATCH 6.11 125/184] tracing: Fix tracefs mount options
Date: Tue, 12 Nov 2024 11:21:23 +0100
Message-ID: <20241112101905.664209414@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kalesh Singh <kaleshsingh@google.com>

commit e4d32142d1de8bcafd90ea5f4f557104f0969c41 upstream.

Commit 78ff64081949 ("vfs: Convert tracefs to use the new mount API")
converted tracefs to use the new mount APIs caused mount options
(e.g. gid=<gid>) to not take effect.

The tracefs superblock can be updated from multiple paths:
    - on fs_initcall() to init_trace_printk_function_export()
    - from a work queue to initialize eventfs
      tracer_init_tracefs_work_func()
    - fsconfig() syscall to mount or remount of tracefs

The tracefs superblock root inode gets created early on in
init_trace_printk_function_export().

With the new mount API, tracefs effectively uses get_tree_single() instead
of the old API mount_single().

Previously, mount_single() ensured that the options are always applied to
the superblock root inode:
    (1) If the root inode didn't exist, call fill_super() to create it
        and apply the options.
    (2) If the root inode exists, call reconfigure_single() which
        effectively calls tracefs_apply_options() to parse and apply
        options to the subperblock's fs_info and inode and remount
        eventfs (if necessary)

On the other hand, get_tree_single() effectively calls vfs_get_super()
which:
    (3) If the root inode doesn't exists, calls fill_super() to create it
        and apply the options.
    (4) If the root inode already exists, updates the fs_context root
        with the superblock's root inode.

(4) above is always the case for tracefs mounts, since the super block's
root inode will already be created by init_trace_printk_function_export().

This means that the mount options get ignored:
    - Since it isn't applied to the superblock's root inode, it doesn't
      get inherited by the children.
    - Since eventfs is initialized from a separate work queue and
      before call to mount with the options, and it doesn't get remounted
      for mount.

Ensure that the mount options are applied to the super block and eventfs
is remounted to respect the mount options.

To understand this better, if fstab has the following:

 tracefs  /sys/kernel/tracing  tracefs   nosuid,nodev,noexec,gid=tracing 0  0

On boot up, permissions look like:

 # ls -l /sys/kernel/tracing/trace
 -rw-r----- 1 root root 0 Nov  1 08:37 /sys/kernel/tracing/trace

When it should look like:

 # ls -l /sys/kernel/tracing/trace
 -rw-r----- 1 root tracing 0 Nov  1 08:37 /sys/kernel/tracing/trace

Link: https://lore.kernel.org/r/536e99d3-345c-448b-adee-a21389d7ab4b@redhat.com/

Cc: Eric Sandeen <sandeen@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Ali Zahraee <ahzahraee@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: stable@vger.kernel.org
Fixes: 78ff64081949 ("vfs: Convert tracefs to use the new mount API")
Link: https://lore.kernel.org/20241030171928.4168869-2-kaleshsingh@google.com
Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/inode.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/tracefs/inode.c b/fs/tracefs/inode.c
index 1748dff58c3b..cfc614c638da 100644
--- a/fs/tracefs/inode.c
+++ b/fs/tracefs/inode.c
@@ -392,6 +392,9 @@ static int tracefs_reconfigure(struct fs_context *fc)
 	struct tracefs_fs_info *sb_opts = sb->s_fs_info;
 	struct tracefs_fs_info *new_opts = fc->s_fs_info;
 
+	if (!new_opts)
+		return 0;
+
 	sync_filesystem(sb);
 	/* structure copy of new mount options to sb */
 	*sb_opts = *new_opts;
@@ -478,14 +481,17 @@ static int tracefs_fill_super(struct super_block *sb, struct fs_context *fc)
 	sb->s_op = &tracefs_super_operations;
 	sb->s_d_op = &tracefs_dentry_operations;
 
-	tracefs_apply_options(sb, false);
-
 	return 0;
 }
 
 static int tracefs_get_tree(struct fs_context *fc)
 {
-	return get_tree_single(fc, tracefs_fill_super);
+	int err = get_tree_single(fc, tracefs_fill_super);
+
+	if (err)
+		return err;
+
+	return tracefs_reconfigure(fc);
 }
 
 static void tracefs_free_fc(struct fs_context *fc)
-- 
2.47.0



