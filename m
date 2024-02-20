Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF6C151CD8;
	Tue, 20 Feb 2024 21:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464248; cv=none; b=fEFmiYHoMjwGi7BhCbLBAGPmse6/v25F35cHkjtPlMf6Cb7zcXFFCCS9PLYbrdIi2tvDyj6nxZXlAma3sSICzeVXmvGelkWtq0tVZD70rN78EyIp4n30PtmK+6o2p4okFiB7Dzn6FTEh8VYiHDALpQ0Ji0GBJwvbsKTY+tPuv9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464248; c=relaxed/simple;
	bh=+eMblBrEDHw5gWozKPMLVeu4eFcYV+e37JR0k4w3rmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KvJDWvsPGB+mY9ijcaR7L5vnb1NHOej/37804dcjPq3MJkPCJRAoz5P+EDvtQJDe5JcGK5T93lzBjMt9Mno8Xf/IHwTo71ordbkvPldZwqigV1U1KlarRmlh+A1KsLSJqBvIwBA3NQJfaF/7Lhp0nQyNdmQfsojtfKm/7EhIyqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ik5Wx3is; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ik5Wx3is"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9218FC43390;
	Tue, 20 Feb 2024 21:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464248;
	bh=+eMblBrEDHw5gWozKPMLVeu4eFcYV+e37JR0k4w3rmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ik5Wx3isLjeBxWkGb9+L8dHrR5iDpxHSO/Yot6uSMM/FdhVtwa3sKQSfG3P74/dcX
	 BAbOp1s7zpuNKQKpuYw94/6zd2OLjLclr5Js7Do/em0RCqDL+kq1bUBebRDqqTUcpt
	 idMM2ekevZCbt8oUlmyd5iA+8N8pMYr06lSPcQBI=
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
Subject: [PATCH 6.6 297/331] eventfs: Read ei->entries before ei->children in eventfs_iterate()
Date: Tue, 20 Feb 2024 21:56:53 +0100
Message-ID: <20240220205647.398371997@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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
@@ -752,8 +752,8 @@ static int eventfs_iterate(struct file *
 	 * Need to create the dentries and inodes to have a consistent
 	 * inode number.
 	 */
-	list_for_each_entry_srcu(ei_child, &ei->children, list,
-				 srcu_read_lock_held(&eventfs_srcu)) {
+	for (i = 0; i < ei->nr_entries; i++) {
+		void *cdata = ei->data;
 
 		if (c > 0) {
 			c--;
@@ -762,23 +762,32 @@ static int eventfs_iterate(struct file *
 
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
@@ -787,27 +796,18 @@ static int eventfs_iterate(struct file *
 
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


