Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA78E145A02;
	Thu, 13 Jun 2024 12:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280665; cv=none; b=N1k8B0dzMboH5UXHVMWMmzbTLtUyYFXwb1RGRwIUqN3ZkV/EnScb8si8OX+7KfVZYsD3bdzqizjhXdAY1n/xPvcOmJCKXW2cIfbmrgCr8cNYEQbNvKIQhd+WccZKjq2WWcaZM8QVRbQYJYB34xCedjj9SFDH+XM9p2CwTaOBwdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280665; c=relaxed/simple;
	bh=A1KHrnIrxxXmqlbNmtfihwimbFayT9pKwRTunOC4v2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IgcWjcIqSj9vidrpufGzNs/njnpemXDHPlNy15p3vJvN5AYwuV5UQtUuhNDh/e+5u9cf0SwJBRrFQI6W8AUtpA7gnad0E7OL0KzJyperLbG4MjKt1f4KvHA3kRaeDOqX7eNadmSQbuSWBhjgK0p3cY1r9Mnn64g0p/TDihFwFKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mtY/LOz0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mtY/LOz0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7636AC2BBFC;
	Thu, 13 Jun 2024 12:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280664;
	bh=A1KHrnIrxxXmqlbNmtfihwimbFayT9pKwRTunOC4v2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mtY/LOz0LFYBz+JKb3+GVVPWPhfCnCINl95uuHMY5OpU8b66TZ3dRUyrYnvdHmNW6
	 z1CB2+55S7SEGggLNqa313NRgQAsbpsPFtYYKr/Xsj75ybWnYXOuLk2xOec8UPIOjg
	 JSnNe2+spsA1DF8tX8X1l0397acXWztRdu8n/qe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 130/137] tracefs: Clear EVENT_INODE flag in tracefs_drop_inode()
Date: Thu, 13 Jun 2024 13:35:10 +0200
Message-ID: <20240613113228.342390472@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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

commit 0bcfd9aa4dafa03b88d68bf66b694df2a3e76cf3 upstream.

When the inode is being dropped from the dentry, the TRACEFS_EVENT_INODE
flag needs to be cleared to prevent a remount from calling
eventfs_remount() on the tracefs_inode private data. There's a race
between the inode is dropped (and the dentry freed) to where the inode is
actually freed. If a remount happens between the two, the eventfs_inode
could be accessed after it is freed (only the dentry keeps a ref count on
it).

Currently the TRACEFS_EVENT_INODE flag is cleared from the dentry iput()
function. But this is incorrect, as it is possible that the inode has
another reference to it. The flag should only be cleared when the inode is
really being dropped and has no more references. That happens in the
drop_inode callback of the inode, as that gets called when the last
reference of the inode is released.

Remove the tracefs_d_iput() function and move its logic to the more
appropriate tracefs_drop_inode() callback function.

Link: https://lore.kernel.org/linux-trace-kernel/20240523051539.908205106@goodmis.org

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Fixes: baa23a8d4360d ("tracefs: Reset permissions on remount if permissions are options")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/inode.c |   33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

--- a/fs/tracefs/inode.c
+++ b/fs/tracefs/inode.c
@@ -439,10 +439,26 @@ static int tracefs_show_options(struct s
 	return 0;
 }
 
+static int tracefs_drop_inode(struct inode *inode)
+{
+	struct tracefs_inode *ti = get_tracefs(inode);
+
+	/*
+	 * This inode is being freed and cannot be used for
+	 * eventfs. Clear the flag so that it doesn't call into
+	 * eventfs during the remount flag updates. The eventfs_inode
+	 * gets freed after an RCU cycle, so the content will still
+	 * be safe if the iteration is going on now.
+	 */
+	ti->flags &= ~TRACEFS_EVENT_INODE;
+
+	return 1;
+}
+
 static const struct super_operations tracefs_super_operations = {
 	.alloc_inode    = tracefs_alloc_inode,
 	.free_inode     = tracefs_free_inode,
-	.drop_inode     = generic_delete_inode,
+	.drop_inode     = tracefs_drop_inode,
 	.statfs		= simple_statfs,
 	.remount_fs	= tracefs_remount,
 	.show_options	= tracefs_show_options,
@@ -469,22 +485,7 @@ static int tracefs_d_revalidate(struct d
 	return !(ei && ei->is_freed);
 }
 
-static void tracefs_d_iput(struct dentry *dentry, struct inode *inode)
-{
-	struct tracefs_inode *ti = get_tracefs(inode);
-
-	/*
-	 * This inode is being freed and cannot be used for
-	 * eventfs. Clear the flag so that it doesn't call into
-	 * eventfs during the remount flag updates. The eventfs_inode
-	 * gets freed after an RCU cycle, so the content will still
-	 * be safe if the iteration is going on now.
-	 */
-	ti->flags &= ~TRACEFS_EVENT_INODE;
-}
-
 static const struct dentry_operations tracefs_dentry_operations = {
-	.d_iput = tracefs_d_iput,
 	.d_revalidate = tracefs_d_revalidate,
 	.d_release = tracefs_d_release,
 };


