Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2FA5196D90;
	Thu,  6 Jun 2024 14:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683669; cv=none; b=RrKOF0j47iGnVt43C1tnfgaWCZ+zZr1MHXEJzoSJVPrSlPvLI4dT++rqvXJMxH3GUaeYHT0IyROvZmvdOcmK2/RqXvy84IsnqB6zzWBH75HRS0Ei+LCcYxHY3sZ2+7BT9OFj84cpbBshc2m7tCrVGqMop5iJZW78luhdh7wsv6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683669; c=relaxed/simple;
	bh=vJuqWGY3tdwAN+zYvbDEI7b4TbWMuOvbAldeXjuPQIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=btbx4+7Y+fKqARZ81BrTegnHqSzzIHBcTgp8PCW5EgIP/eiNepchH7Yf/t1lYVuZVxzDRm1IHpDFoUon/MysIu8gdrXT3KEPmhv0AUN0Bo5MKZxC58l+5WEOw9bGiNimQV06lEkZiEqeCUY2XYToMAoN8pZxXcmPoEns0A/rag0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XvBt4zD1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XvBt4zD1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8B4CC2BD10;
	Thu,  6 Jun 2024 14:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683668;
	bh=vJuqWGY3tdwAN+zYvbDEI7b4TbWMuOvbAldeXjuPQIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XvBt4zD1PIoPsQSqCtCdvOMos6itbBURGuKE8ciE6xp/P0IE+iLB2oAybeGJp+y8v
	 K882CsduTjqfd1KXLqHesCA5Le7hro4EHvR93BD6a5nXWSTqNtEzOVc1NVaZ4qA0hu
	 9zs8QCeffxDsPrKXOvdmZCqFaj0Q8boHits7DuvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 556/744] eventfs: Have "events" directory get permissions from its parent
Date: Thu,  6 Jun 2024 16:03:48 +0200
Message-ID: <20240606131750.292084355@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

[ Upstream commit d57cf30c4c07837799edec949102b0adf58bae79 ]

The events directory gets its permissions from the root inode. But this
can cause an inconsistency if the instances directory changes its
permissions, as the permissions of the created directories under it should
inherit the permissions of the instances directory when directories under
it are created.

Currently the behavior is:

 # cd /sys/kernel/tracing
 # chgrp 1002 instances
 # mkdir instances/foo
 # ls -l instances/foo
[..]
 -r--r-----  1 root lkp  0 May  1 18:55 buffer_total_size_kb
 -rw-r-----  1 root lkp  0 May  1 18:55 current_tracer
 -rw-r-----  1 root lkp  0 May  1 18:55 error_log
 drwxr-xr-x  1 root root 0 May  1 18:55 events
 --w-------  1 root lkp  0 May  1 18:55 free_buffer
 drwxr-x---  2 root lkp  0 May  1 18:55 options
 drwxr-x--- 10 root lkp  0 May  1 18:55 per_cpu
 -rw-r-----  1 root lkp  0 May  1 18:55 set_event

All the files and directories under "foo" has the "lkp" group except the
"events" directory. That's because its getting its default value from the
mount point instead of its parent.

Have the "events" directory make its default value based on its parent's
permissions. That now gives:

 # ls -l instances/foo
[..]
 -rw-r-----  1 root lkp 0 May  1 21:16 buffer_subbuf_size_kb
 -r--r-----  1 root lkp 0 May  1 21:16 buffer_total_size_kb
 -rw-r-----  1 root lkp 0 May  1 21:16 current_tracer
 -rw-r-----  1 root lkp 0 May  1 21:16 error_log
 drwxr-xr-x  1 root lkp 0 May  1 21:16 events
 --w-------  1 root lkp 0 May  1 21:16 free_buffer
 drwxr-x---  2 root lkp 0 May  1 21:16 options
 drwxr-x--- 10 root lkp 0 May  1 21:16 per_cpu
 -rw-r-----  1 root lkp 0 May  1 21:16 set_event

Link: https://lore.kernel.org/linux-trace-kernel/20240502200906.161887248@goodmis.org

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Fixes: 8186fff7ab649 ("tracefs/eventfs: Use root and instance inodes as default ownership")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/tracefs/event_inode.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/fs/tracefs/event_inode.c b/fs/tracefs/event_inode.c
index fd111e10f04e4..3b785f4ca95e4 100644
--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -37,6 +37,7 @@ static DEFINE_MUTEX(eventfs_mutex);
 
 struct eventfs_root_inode {
 	struct eventfs_inode		ei;
+	struct inode			*parent_inode;
 	struct dentry			*events_dir;
 };
 
@@ -226,12 +227,23 @@ static int eventfs_set_attr(struct mnt_idmap *idmap, struct dentry *dentry,
 
 static void update_events_attr(struct eventfs_inode *ei, struct super_block *sb)
 {
-	struct inode *root;
+	struct eventfs_root_inode *rei;
+	struct inode *parent;
+
+	rei = get_root_inode(ei);
+
+	/* Use the parent inode permissions unless root set its permissions */
+	parent = rei->parent_inode;
 
-	/* Get the tracefs root inode. */
-	root = d_inode(sb->s_root);
-	ei->attr.uid = root->i_uid;
-	ei->attr.gid = root->i_gid;
+	if (rei->ei.attr.mode & EVENTFS_SAVE_UID)
+		ei->attr.uid = rei->ei.attr.uid;
+	else
+		ei->attr.uid = parent->i_uid;
+
+	if (rei->ei.attr.mode & EVENTFS_SAVE_GID)
+		ei->attr.gid = rei->ei.attr.gid;
+	else
+		ei->attr.gid = parent->i_gid;
 }
 
 static void set_top_events_ownership(struct inode *inode)
@@ -810,6 +822,7 @@ struct eventfs_inode *eventfs_create_events_dir(const char *name, struct dentry
 	// Note: we have a ref to the dentry from tracefs_start_creating()
 	rei = get_root_inode(ei);
 	rei->events_dir = dentry;
+	rei->parent_inode = d_inode(dentry->d_sb->s_root);
 
 	ei->entries = entries;
 	ei->nr_entries = size;
@@ -819,10 +832,15 @@ struct eventfs_inode *eventfs_create_events_dir(const char *name, struct dentry
 	uid = d_inode(dentry->d_parent)->i_uid;
 	gid = d_inode(dentry->d_parent)->i_gid;
 
-	/* This is used as the default ownership of the files and directories */
 	ei->attr.uid = uid;
 	ei->attr.gid = gid;
 
+	/*
+	 * When the "events" directory is created, it takes on the
+	 * permissions of its parent. But can be reset on remount.
+	 */
+	ei->attr.mode |= EVENTFS_SAVE_UID | EVENTFS_SAVE_GID;
+
 	INIT_LIST_HEAD(&ei->children);
 	INIT_LIST_HEAD(&ei->list);
 
-- 
2.43.0



