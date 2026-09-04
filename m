Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F158C3B14B4;
	Fri,  4 Sep 2026 05:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499000; cv=none; b=b2nkMjgYpNifqp6xH+JeLl87BjzIZpnJ3vwZcFpjTjKfbY5+XUQIxQX/VAklQW17EuL41g+1LW+qUlFNvwEDRaXExt4CT0HVEQHc5i5HVZ3VpO6BlOxAjdC4IXEQu7VHgXlqUpP9XjINhrUVp8aBiVApzZnsxbas3gAygDhEjuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499000; c=relaxed/simple;
	bh=qvQxj31RhmV4ygNo87gDYmN1mHc7yerDsyDDxhy83+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vGOZzJYfDMM6y1//FGY9rXkAQDiESirj1q8YKJeWyctbcWCm8BXFvubeLAE4s7HKHq2nyTn2ZTlAGwYMVoQWqM3H7+T28ammBEwKBIG6Ml23n/x9Aie3nFBR9xgy0QsZJePowJ8IsGnTNCdfW7WlICeJi0NmzL82qioay6iY7Ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZI3XFubi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZI3XFubi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D7F51F00A3D;
	Fri,  4 Sep 2026 05:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498998;
	bh=5sLZz4Xg8enDJfFqKIDgDY0plIPBJl/VwDARS/5VlQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZI3XFubijpm8Kd81RWrI8FxH2tYzrrvZmzCP8KxvVrO8lR3wD/yNqydfJ+w6t379q
	 g9kXRxuUYVIMv/fMVisR3vJycZWxt+cfT3DdryCyZVwUU4OBd/pPNqVAamhPmzggT0
	 auYlJtPgoR6jqqEakQeQFJK6y+AzMasZYvTLGeao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3ef80b4ed02226d04a06@syzkaller.appspotmail.com,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.2 260/713] eventfs: Initialize ei->children and ei->list in init_ei()
Date: Fri,  4 Sep 2026 06:53:48 +0200
Message-ID: <20260904045809.666111967@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Deepanshu Kartikey <kartikey406@gmail.com>

commit 1704aaaf5d22bc765c168402350d191e24e245bc upstream.

eventfs_create_dir() allocates the eventfs_inode and initializes it with
init_ei(). But this does not initialize the eventfs_inode list_heads. If
the eventfs_create_dir() fails due to memory pressure, it will call
free_ei() before it initialized the lists, and that checks to make sure
the eventfs_inode has no children. But because the list wasn't
initialized, it will give a false warning.

Fix it by moving the list initialization into init_ei().

Cc: stable@vger.kernel.org
Fixes: 5790b1fb3d67 ("eventfs: Remove eventfs_file and just use eventfs_inode")
Reported-by: syzbot+3ef80b4ed02226d04a06@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=3ef80b4ed02226d04a06
Link: https://patch.msgid.link/20260824144653.54044-1-kartikey406@gmail.com
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
[ Rewrote change log ]
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -438,6 +438,8 @@ static inline struct eventfs_inode *init
 	if (!ei->name)
 		return NULL;
 	kref_init(&ei->kref);
+	INIT_LIST_HEAD(&ei->children);
+	INIT_LIST_HEAD(&ei->list);
 	return ei;
 }
 
@@ -725,8 +727,6 @@ struct eventfs_inode *eventfs_create_dir
 	ei->entries = entries;
 	ei->nr_entries = size;
 	ei->data = data;
-	INIT_LIST_HEAD(&ei->children);
-	INIT_LIST_HEAD(&ei->list);
 
 	scoped_guard(mutex, &eventfs_mutex) {
 		if (!parent->is_freed)
@@ -798,9 +798,6 @@ struct eventfs_inode *eventfs_create_eve
 	ei->attr.uid = uid;
 	ei->attr.gid = gid;
 
-	INIT_LIST_HEAD(&ei->children);
-	INIT_LIST_HEAD(&ei->list);
-
 	ti = get_tracefs(inode);
 	ti->flags |= TRACEFS_EVENT_INODE;
 	ti->private = ei;


