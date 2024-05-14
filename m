Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B5A1CFB2;
	Tue, 14 May 2024 10:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684122; cv=none; b=Gk9vGvKkgi21fhD3+7buDPPHXMtfuRwF9Atdf8msAbpQYdIhIaaZCjcxnJc3k4c3x6qMZM05LoDrY26DMDORx7edLiG33e0UnJoENVI9N+KyaYOJ2vsEOl8GV4VtMUsszlP6e8oZY6QP5mNCKT11u+ceNNiEuzT9bPLC4fesWlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684122; c=relaxed/simple;
	bh=1hPihjOctIh47vkOgn8fXAWWm7t9zucR4J9BIuPK9K4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lHHEmM3AueWapMpO4w8aUoW59WvrCz6n5wnz0Al/lUjOlNi6Fy0fyK9yqzPlFu/nvQtuq+WWPVHxHkHpWQ0Gy9tkhIOGrFf0F1vbSHdx/rL1ufkcuF2fTorlLd860QTlFYH6xazPzDJGFm8Q9z2hsFG4r4aIBefQsZSNPikqvp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PHBvOktp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PHBvOktp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20FA7C2BD10;
	Tue, 14 May 2024 10:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684122;
	bh=1hPihjOctIh47vkOgn8fXAWWm7t9zucR4J9BIuPK9K4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PHBvOktp2AX5rUYEa519TUJtiIKgXAXJEUmmN2sRHwkO+rMAQaj5lPWAQNJoOahWz
	 XyZ6fPYuQM25NkiGYeFrP1AJvoGRWsa7RqkV24fri8uJOuAbGVVuOQ2QxuhM/h9qd3
	 FJzl/ppvUHn6CxJmNakfS78pgFX87mdiFPui5uPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.8 328/336] eventfs: Do not treat events directory different than other directories
Date: Tue, 14 May 2024 12:18:52 +0200
Message-ID: <20240514101051.006481645@linuxfoundation.org>
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

commit 22e61e15af731dbe46704c775d2335e56fcef4e9 upstream.

Treat the events directory the same as other directories when it comes to
permissions. The events directory was considered different because it's
dentry is persistent, whereas the other directory dentries are created
when accessed. But the way tracefs now does its ownership by using the
root dentry's permissions as the default permissions, the events directory
can get out of sync when a remount is performed setting the group and user
permissions.

Remove the special case for the events directory on setting the
attributes. This allows the updates caused by remount to work properly as
well as simplifies the code.

Link: https://lore.kernel.org/linux-trace-kernel/20240502200906.002923579@goodmis.org

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Fixes: 8186fff7ab649 ("tracefs/eventfs: Use root and instance inodes as default ownership")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |   16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -163,21 +163,7 @@ static int eventfs_set_attr(struct mnt_i
 	 * determined by the parent directory.
 	 */
 	if (dentry->d_inode->i_mode & S_IFDIR) {
-		/*
-		 * The events directory dentry is never freed, unless its
-		 * part of an instance that is deleted. It's attr is the
-		 * default for its child files and directories.
-		 * Do not update it. It's not used for its own mode or ownership.
-		 */
-		if (ei->is_events) {
-			/* But it still needs to know if it was modified */
-			if (iattr->ia_valid & ATTR_UID)
-				ei->attr.mode |= EVENTFS_SAVE_UID;
-			if (iattr->ia_valid & ATTR_GID)
-				ei->attr.mode |= EVENTFS_SAVE_GID;
-		} else {
-			update_attr(&ei->attr, iattr);
-		}
+		update_attr(&ei->attr, iattr);
 
 	} else {
 		name = dentry->d_name.name;


