Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC344F1E5;
	Tue, 14 May 2024 11:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686001; cv=none; b=R+GInM6c+ULT73UoU70gewSp1DmSxsgSN9XR3b15mdUmSeOa7iIoZiXlEo3+ZnOi2NzzDx1ojfwGEswLUBhMaOeKowdpQl9le5u3ZbUp4At8YE+k6lEwnRovclkUNShEbr84VMWM1ZcMGKbfNz2QA/z/2khbsdMMBRmoEy0Tsa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686001; c=relaxed/simple;
	bh=grnUAatkmRCOXuowGyPCTaAcCBQcUmdwZ32WJy2/qTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RcU+MWpZbSquE9gkrxT2gif3G92PlBjlnVfGSrPTbtyPbP/q2DQgqI5mjcQgpO6oUdqTt6FvdlFUeaXyYFJJYt7VfBgEXooox20Nig+aCfHfP1Fjf28ieAP7HQTiegAu0SALOVPELpozof0nmPJrZ4QGx6rzHRdXyci/5ya36IM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xs2/dZDN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xs2/dZDN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17B23C2BD10;
	Tue, 14 May 2024 11:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686001;
	bh=grnUAatkmRCOXuowGyPCTaAcCBQcUmdwZ32WJy2/qTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xs2/dZDN97zrcmv5CCSr87Zoxh9caSKx/Kvp9zl6dSwt4GYF5nG0/leq4lNb5O2oQ
	 4aBtPXZTkLx9Ff6f/CLoJcDZq33sarRTyFH5nC2IG6bdx/16hX/bIRA/V/X7l71tIP
	 Y6gvldYS8gtwWq9QsYoYOaGMYqrYmZtbvHuP0lFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 293/301] eventfs: Do not treat events directory different than other directories
Date: Tue, 14 May 2024 12:19:24 +0200
Message-ID: <20240514101043.323145487@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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


