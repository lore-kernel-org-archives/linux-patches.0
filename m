Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685E72DF9F;
	Tue, 20 Feb 2024 21:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464935; cv=none; b=o/Q+5XQgr2SZrVtz5w8IICVOwn397CpOl+UdhkWOCGc+EY5fF7dfDGLXAu8t9SYgvWLQgeuh3NniHodtEOe0OnAlsRwlJ08LpYuAQ14Wcwx19HW29EcSsD4g5/C7nwqNAu1kEgQ7pyaAYwWvePi1RySZbyCQZgvwBgtHovaz+Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464935; c=relaxed/simple;
	bh=4tyz4+W9GWvBUmVGyK8rW10NEVakBx0pNwa8y8quzlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tmx/oTiSiIILJQETcH29lGw/aKk9qswdSsaU2GFB8MamW1fT9g/t0yUF7ksQCfb9dLMYYp1/c8nYGz1Q/0fM/0CQNfLZi46drS0TSRNlmEhkaXGwKr16ger2EHkkRe3Cwmc0lnE0LumGxehCo2ykMbas0nLMEMPYWApTdoLQLPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R1pALzqP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R1pALzqP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB860C433F1;
	Tue, 20 Feb 2024 21:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464935;
	bh=4tyz4+W9GWvBUmVGyK8rW10NEVakBx0pNwa8y8quzlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R1pALzqPzrZ8RPZfMuT1gI8MS4hL6BHWomwBUf/aDnn83fLALGZHfIWA6eh7kSV5m
	 7/6a9U8tcxMj4OCHEcqFFQW0UZ/bKCNrNtyJey6zSZIf8IG3z8/iyT76SZ8Xby+QOB
	 V5GOgGLd9VnetB/g0Gn8oGxZd3zHvFE7aMzmJFvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.7 183/309] eventfs: Read ei->entries before ei->children in eventfs_iterate()
Date: Tue, 20 Feb 2024 21:55:42 +0100
Message-ID: <20240220205638.875573731@linuxfoundation.org>
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

commit 704f960dbee2f1634f4b4e16f208cb16eaf41c1e upstream.

In order to apply a shortcut to skip over the current ctx->pos
immediately, by using the ei->entries array, the reading of that array
should be first. Moving the array reading before the linked list reading
will make the shortcut change diff nicer to read.

Link: https://lore.kernel.org/all/CAHk-=wiKwDUDv3+jCsv-uacDcHDVTYsXtBR9=6sGM5mqX+DhOg@mail.gmail.com/
Link: https://lore.kernel.org/linux-trace-kernel/20240104220048.333115095@goodmis.org

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |   46 +++++++++++++++++++++++-----------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -714,8 +714,8 @@ static int eventfs_iterate(struct file *
 	 * Need to create the dentries and inodes to have a consistent
 	 * inode number.
 	 */
-	list_for_each_entry_srcu(ei_child, &ei->children, list,
-				 srcu_read_lock_held(&eventfs_srcu)) {
+	for (i = 0; i < ei->nr_entries; i++) {
+		void *cdata = ei->data;
 
 		if (c > 0) {
 			c--;
@@ -724,23 +724,32 @@ static int eventfs_iterate(struct file *
 
 		ctx->pos++;
 
-		if (ei_child->is_freed)
-			continue;
+		entry = &ei->entries[i];
+		name = entry->name;
 
-		name = ei_child->name;
+		mutex_lock(&eventfs_mutex);
+		/* If ei->is_freed then just bail here, nothing more to do */
+		if (ei->is_freed) {
+			mutex_unlock(&eventfs_mutex);
+			goto out_dec;
+		}
+		r = entry->callback(name, &mode, &cdata, &fops);
+		mutex_unlock(&eventfs_mutex);
+		if (r <= 0)
+			continue;
 
-		dentry = create_dir_dentry(ei, ei_child, ei_dentry);
+		dentry = create_file_dentry(ei, i, ei_dentry, name, mode, cdata, fops);
 		if (!dentry)
 			goto out_dec;
 		ino = dentry->d_inode->i_ino;
 		dput(dentry);
 
-		if (!dir_emit(ctx, name, strlen(name), ino, DT_DIR))
+		if (!dir_emit(ctx, name, strlen(name), ino, DT_REG))
 			goto out_dec;
 	}
 
-	for (i = 0; i < ei->nr_entries; i++) {
-		void *cdata = ei->data;
+	list_for_each_entry_srcu(ei_child, &ei->children, list,
+				 srcu_read_lock_held(&eventfs_srcu)) {
 
 		if (c > 0) {
 			c--;
@@ -749,27 +758,18 @@ static int eventfs_iterate(struct file *
 
 		ctx->pos++;
 
-		entry = &ei->entries[i];
-		name = entry->name;
-
-		mutex_lock(&eventfs_mutex);
-		/* If ei->is_freed then just bail here, nothing more to do */
-		if (ei->is_freed) {
-			mutex_unlock(&eventfs_mutex);
-			goto out_dec;
-		}
-		r = entry->callback(name, &mode, &cdata, &fops);
-		mutex_unlock(&eventfs_mutex);
-		if (r <= 0)
+		if (ei_child->is_freed)
 			continue;
 
-		dentry = create_file_dentry(ei, i, ei_dentry, name, mode, cdata, fops);
+		name = ei_child->name;
+
+		dentry = create_dir_dentry(ei, ei_child, ei_dentry);
 		if (!dentry)
 			goto out_dec;
 		ino = dentry->d_inode->i_ino;
 		dput(dentry);
 
-		if (!dir_emit(ctx, name, strlen(name), ino, DT_REG))
+		if (!dir_emit(ctx, name, strlen(name), ino, DT_DIR))
 			goto out_dec;
 	}
 	ret = 1;


