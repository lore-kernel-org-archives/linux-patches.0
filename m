Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91DC42DF9F;
	Tue, 20 Feb 2024 21:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464938; cv=none; b=Z+d3fCwsc5Zx7MGiE7SQkk0XORxM8+srzOZFkza1CMRwhIshQQCsk190Wk7LUABaSyMQgbUNdXMqKaWOGgp0vR4+ACjY1/Q0LOQ1U5BijM7Y2BA6aQYvr6ixukciS1fOS1iqdrPEozUsTiuB1c6zAPfsUF80D0pBZTzWW/WYKGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464938; c=relaxed/simple;
	bh=6MfjIff8zrYYVPdtKtekUBJyqe04ycINib7GLuR71YU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T78zAGF01qqC78ckLDN73BRC2D7dEgbPSr5L1Ra0Y9aV/D40+sNlcQCTxSLvS4WUGQCQDF+AsR1ivz9h1vJInHOMoyFx3IFsZjuHBo6PAJDrlURzeHzco3gJobeqP60eqdpDA/x2Q6lzBAFsyhRktMI8SiedDSVsza38PP5BgUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lOBgN7hv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lOBgN7hv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01021C433F1;
	Tue, 20 Feb 2024 21:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464938;
	bh=6MfjIff8zrYYVPdtKtekUBJyqe04ycINib7GLuR71YU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lOBgN7hvDnHyBiyW1yDzarNEBeQP9LnHVDpBzE23Aaao7ZzPGhO0NPk+4UKHHyOBn
	 Bu4WcHqOiQa/gw9N+PGLNOVwy9I1qhE+bI7dhhr+6talnaZxUjEUqu6bQZ17zwWKKu
	 gWouJ860pXgUaojYr7XdNLsnWxUa8NqwLa44rd/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.7 184/309] eventfs: Shortcut eventfs_iterate() by skipping entries already read
Date: Tue, 20 Feb 2024 21:55:43 +0100
Message-ID: <20240220205638.911286825@linuxfoundation.org>
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

commit 1de94b52d5e8d8b32f0252f14fad1f1edc2e71f1 upstream.

As the ei->entries array is fixed for the duration of the eventfs_inode,
it can be used to skip over already read entries in eventfs_iterate().

That is, if ctx->pos is greater than zero, there's no reason in doing the
loop across the ei->entries array for the entries less than ctx->pos.
Instead, start the lookup of the entries at the current ctx->pos.

Link: https://lore.kernel.org/all/CAHk-=wiKwDUDv3+jCsv-uacDcHDVTYsXtBR9=6sGM5mqX+DhOg@mail.gmail.com/
Link: https://lore.kernel.org/linux-trace-kernel/20240104220048.494956957@goodmis.org

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -708,21 +708,15 @@ static int eventfs_iterate(struct file *
 	if (!ei || !ei_dentry)
 		goto out;
 
-	ret = 0;
-
 	/*
 	 * Need to create the dentries and inodes to have a consistent
 	 * inode number.
 	 */
-	for (i = 0; i < ei->nr_entries; i++) {
-		void *cdata = ei->data;
-
-		if (c > 0) {
-			c--;
-			continue;
-		}
+	ret = 0;
 
-		ctx->pos++;
+	/* Start at 'c' to jump over already read entries */
+	for (i = c; i < ei->nr_entries; i++, ctx->pos++) {
+		void *cdata = ei->data;
 
 		entry = &ei->entries[i];
 		name = entry->name;
@@ -731,7 +725,7 @@ static int eventfs_iterate(struct file *
 		/* If ei->is_freed then just bail here, nothing more to do */
 		if (ei->is_freed) {
 			mutex_unlock(&eventfs_mutex);
-			goto out_dec;
+			goto out;
 		}
 		r = entry->callback(name, &mode, &cdata, &fops);
 		mutex_unlock(&eventfs_mutex);
@@ -740,14 +734,17 @@ static int eventfs_iterate(struct file *
 
 		dentry = create_file_dentry(ei, i, ei_dentry, name, mode, cdata, fops);
 		if (!dentry)
-			goto out_dec;
+			goto out;
 		ino = dentry->d_inode->i_ino;
 		dput(dentry);
 
 		if (!dir_emit(ctx, name, strlen(name), ino, DT_REG))
-			goto out_dec;
+			goto out;
 	}
 
+	/* Subtract the skipped entries above */
+	c -= min((unsigned int)c, (unsigned int)ei->nr_entries);
+
 	list_for_each_entry_srcu(ei_child, &ei->children, list,
 				 srcu_read_lock_held(&eventfs_srcu)) {
 


