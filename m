Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BEF5143899;
	Thu, 13 Jun 2024 11:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279640; cv=none; b=CyK1zfN8FMQqH92ZNwqOhNTUf1dmw2R0fdGRqwBc8bGs1uecCcYp4rQ/UrYt7lUc26VUOGoBLx2BkCvzoowpVgZX2ss0yHARMslc471arEv1E7BUMgGJKJnCwo9Bp3CZPdNBjb4Q7cA+FDbVcdJCpZMTGcKruUsGPDEfN1fYwtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279640; c=relaxed/simple;
	bh=GBBxO0bUkQL4+sCpC6LtvJpE/lyqJ3ggau0pUMmQoeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AU9k7602YcAyM1v1fTsM/l3z73HybUaSBViCc9qzzUt5jzWshRoAMqSnVW988KSWmteOEg6WOBZc3aQPsGoXk7tnfgqWPSLmu4PpFZFU3B95tUn1m2TICMBjJQxcnUY3poYsnzPYB2n3Y9zvz0MbrlysHuzZkZJhbCgD2bnXX8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v5nlj/+z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v5nlj/+z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5BDAC32786;
	Thu, 13 Jun 2024 11:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279640;
	bh=GBBxO0bUkQL4+sCpC6LtvJpE/lyqJ3ggau0pUMmQoeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v5nlj/+zvk3aZ4P8Y86SjTgfIQpn6c+kJEvF2lPOzQY4hDmFCH9tJ88MFF4u8VvOp
	 L0gQkkDbLAXar6KrEg+jv5xKdcV+wlJhJ0E/Js9ZutobKn+CNeKo7mN6qMEW9D5hY6
	 0b5E0Qdj7D2qeGkYV5XDPJ6a5HQmTlpwvRA4z2fQ=
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
Subject: [PATCH 6.9 144/157] tracefs: Clear EVENT_INODE flag in tracefs_drop_inode()
Date: Thu, 13 Jun 2024 13:34:29 +0200
Message-ID: <20240613113232.974258162@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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


