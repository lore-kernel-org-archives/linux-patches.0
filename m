Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 497662DF9F;
	Tue, 20 Feb 2024 21:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464954; cv=none; b=aEs7d9yywQPOoqpAiWDOkq1uPL4uptz8mCYvTdF1K5fdvghko3eTQpSUs9uL61bk1mxvrM85apWRs3enZ6bKTt1mbtZZhwhPqD/La149KA/lfbCd7nxdXboI+AIppZ+3LMQzf46fdML0wK2xsNlWK01kv8DijEkFbPUYs20SHwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464954; c=relaxed/simple;
	bh=1Bx9ZOHEiH3YHYzb4sE46ehr+v8BwHkxbML7RRJ/4UI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TP1WDZeNfCRKmcRWIUiXpBbbyoIkGlAhLmcPwNJFJFH8jC6pUCp6VwN34S7iOs8cBA6KdSZA63vmNSQrYNnL1Yq/MK8ymsmXdQ+FaeqfSq+jtI+bwi+8seD9xTCU9zh4wUNfHDXD+akQ7LJqGdCkKLA8aVlGG/ArxoCVK7CGe48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fpzVEI7H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fpzVEI7H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE49EC433F1;
	Tue, 20 Feb 2024 21:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464954;
	bh=1Bx9ZOHEiH3YHYzb4sE46ehr+v8BwHkxbML7RRJ/4UI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fpzVEI7HRTFwVQWN5iyrymN3PqglNjoZdijozWqSyQmA+gUvM0z6pvGZmN53R7+ly
	 6VF0AzBrhcMWGjl/vewwAGodEepfNfR8w0g8AY4sVyiJS3W1gkMl3VH15uK6jKcxX6
	 kHtX9TOJ/m8dVtVxgzyXFUgPF+EsyitTzB0yuXt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH 6.7 188/309] eventfs: Save directory inodes in the eventfs_inode structure
Date: Tue, 20 Feb 2024 21:55:47 +0100
Message-ID: <20240220205639.035201018@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

commit 834bf76add3e6168038150f162cbccf1fd492a67 upstream.

The eventfs inodes and directories are allocated when referenced. But this
leaves the issue of keeping consistent inode numbers and the number is
only saved in the inode structure itself. When the inode is no longer
referenced, it can be freed. When the file that the inode was representing
is referenced again, the inode is once again created, but the inode number
needs to be the same as it was before.

Just making the inode numbers the same for all files is fine, but that
does not work with directories. The find command will check for loops via
the inode number and having the same inode number for directories triggers:

  # find /sys/kernel/tracing
find: File system loop detected;
'/sys/kernel/debug/tracing/events/initcall/initcall_finish' is part of the same file system loop as
'/sys/kernel/debug/tracing/events/initcall'.
[..]

Linus pointed out that the eventfs_inode structure ends with a single
32bit int, and on 64 bit machines, there's likely a 4 byte hole due to
alignment. We can use this hole to store the inode number for the
eventfs_inode. All directories in eventfs are represented by an
eventfs_inode and that data structure can hold its inode number.

That last int was also purposely placed at the end of the structure to
prevent holes from within. Now that there's a 4 byte number to hold the
inode, both the inode number and the last integer can be moved up in the
structure for better cache locality, where the llist and rcu fields can be
moved to the end as they are only used when the eventfs_inode is being
deleted.

Link: https://lore.kernel.org/all/CAMuHMdXKiorg-jiuKoZpfZyDJ3Ynrfb8=X+c7x0Eewxn-YRdCA@mail.gmail.com/
Link: https://lore.kernel.org/linux-trace-kernel/20240122152748.46897388@gandalf.local.home

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Fixes: 53c41052ba31 ("eventfs: Have the inodes all for files and directories all be the same")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |   14 +++++++++++---
 fs/tracefs/internal.h    |    7 ++++---
 2 files changed, 15 insertions(+), 6 deletions(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -34,7 +34,15 @@ static DEFINE_MUTEX(eventfs_mutex);
 
 /* Choose something "unique" ;-) */
 #define EVENTFS_FILE_INODE_INO		0x12c4e37
-#define EVENTFS_DIR_INODE_INO		0x134b2f5
+
+/* Just try to make something consistent and unique */
+static int eventfs_dir_ino(struct eventfs_inode *ei)
+{
+	if (!ei->ino)
+		ei->ino = get_next_ino();
+
+	return ei->ino;
+}
 
 /*
  * The eventfs_inode (ei) itself is protected by SRCU. It is released from
@@ -358,7 +366,7 @@ static struct dentry *create_dir(struct
 	inode->i_fop = &eventfs_file_operations;
 
 	/* All directories will have the same inode number */
-	inode->i_ino = EVENTFS_DIR_INODE_INO;
+	inode->i_ino = eventfs_dir_ino(ei);
 
 	ti = get_tracefs(inode);
 	ti->flags |= TRACEFS_EVENT_INODE;
@@ -764,7 +772,7 @@ static int eventfs_iterate(struct file *
 
 		name = ei_child->name;
 
-		ino = EVENTFS_DIR_INODE_INO;
+		ino = eventfs_dir_ino(ei_child);
 
 		if (!dir_emit(ctx, name, strlen(name), ino, DT_DIR))
 			goto out_dec;
--- a/fs/tracefs/internal.h
+++ b/fs/tracefs/internal.h
@@ -55,6 +55,10 @@ struct eventfs_inode {
 	struct eventfs_attr		*entry_attrs;
 	struct eventfs_attr		attr;
 	void				*data;
+	unsigned int			is_freed:1;
+	unsigned int			is_events:1;
+	unsigned int			nr_entries:30;
+	unsigned int			ino;
 	/*
 	 * Union - used for deletion
 	 * @llist:	for calling dput() if needed after RCU
@@ -64,9 +68,6 @@ struct eventfs_inode {
 		struct llist_node	llist;
 		struct rcu_head		rcu;
 	};
-	unsigned int			is_freed:1;
-	unsigned int			is_events:1;
-	unsigned int			nr_entries:30;
 };
 
 static inline struct tracefs_inode *get_tracefs(const struct inode *inode)


