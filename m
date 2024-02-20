Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF7E152DE6;
	Tue, 20 Feb 2024 21:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464251; cv=none; b=SV2wWxSWLXOOANNVR/+0cSDYFDh6YidUw1V/nCR+U2rClIieyLUDYw0pRUJIy6H+PvfPl/iEAOyTqe6FCY1KUeREHmem4hXUJ8I5SRQhYY8OrgwFl7FXvKMecoYPdRvi0HuMWnInbm/mGBcWVSxOlzTyLc00mY+2eZMJBbaXC4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464251; c=relaxed/simple;
	bh=aRDTbEk2dwUfCvRhigjbs9pE6a9Jfn1V0SOoSiydBUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WdRZhFRd8LVoUzDNw/254gbL2Z1mc58Wumb7nbTv5R9vBiDqPi1hR/DEnwY5bxMOs24QL4XTrqMk+U4j7X3/+6n2newsWmltd9eMOQtJ4pmcc8FYHnf71vUmr6xVYkVcSSlTnVpCeAn1p8NThEgRG1wdFH0Par6rcwAEqIvQllA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rycl3KQr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rycl3KQr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2630C433C7;
	Tue, 20 Feb 2024 21:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464251;
	bh=aRDTbEk2dwUfCvRhigjbs9pE6a9Jfn1V0SOoSiydBUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rycl3KQrRSrXhWulQdu/g2fkhu1awF2KCow4daf/5Kahp0TmXAcrcEZjJrCdyJOVx
	 rJd0Q6nwlAsnGCEn8UNgol/rg6DvRKrfO4W/mN0DK5f9fstaAtqhrJh5h2lIfxFJVQ
	 uXPUAU42OpGHDaCUYLTQoXJno2z2eP8sLfaEvK1w=
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
Subject: [PATCH 6.6 298/331] eventfs: Shortcut eventfs_iterate() by skipping entries already read
Date: Tue, 20 Feb 2024 21:56:54 +0100
Message-ID: <20240220205647.435245552@linuxfoundation.org>
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
@@ -746,21 +746,15 @@ static int eventfs_iterate(struct file *
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
@@ -769,7 +763,7 @@ static int eventfs_iterate(struct file *
 		/* If ei->is_freed then just bail here, nothing more to do */
 		if (ei->is_freed) {
 			mutex_unlock(&eventfs_mutex);
-			goto out_dec;
+			goto out;
 		}
 		r = entry->callback(name, &mode, &cdata, &fops);
 		mutex_unlock(&eventfs_mutex);
@@ -778,14 +772,17 @@ static int eventfs_iterate(struct file *
 
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
 


