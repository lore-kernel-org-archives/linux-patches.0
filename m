Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2078348C47;
	Fri,  4 Sep 2026 05:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500809; cv=none; b=u072T7lRGkB81hb/GfOJC1zeDZjXlH9qu59BVQtK3C8Z8LhySJFwdGoGCkb08NPe6IWYtSGF1B0L1xtZ5mUDAffM6c9/e+2pc5M6bHPrTywFN7k5HwsjTYudGTkQriD1PZAbbtOh3R7QP/GqmfFrFj3Q5UDelqfAKYwtixOe2ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500809; c=relaxed/simple;
	bh=iS3sR51/bVqZSH0E0r5YbJd9SGB7zLOMXgS2eVf1eyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J5unV42wBwPd/PGDqhBFRBCA8G1C/YGa9POr01UCp2EcMHY12YuU9rlpKWB0ADqNF62Ma8WwA/9Rwe5ZFgLIYQDHXddclNm7L08ftiT9zKnAI/pWXTnwOACh/ca577dUQKonrbtAtM9aiNJ3JnFnD4snQIrD4X8myi9gW0s2+9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S5LnRTWQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S5LnRTWQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ECD11F00A3D;
	Fri,  4 Sep 2026 05:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500807;
	bh=aK88KhZyLYEmTwwsB4RMLjsDbmQI3OrURraPFFaQ0dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S5LnRTWQ8/CQP0A7/8Mz0qysuAa0QTMEU3azAE8ILqyjiprLbhMO6yaHQygOdCpLN
	 gKbJhNN7Rymb/DzS1OlFQE0i0USC8qmpZhhYgDAP/Us8AK/hYnVw3TvhmelfYvPbiB
	 Q7i+lPcNqA3REXTq7cR1iIJ6K72Bro4VGcTRsUtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3ef80b4ed02226d04a06@syzkaller.appspotmail.com,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.18 187/552] eventfs: Initialize ei->children and ei->list in init_ei()
Date: Fri,  4 Sep 2026 06:55:44 +0200
Message-ID: <20260904045753.256171403@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -436,6 +436,8 @@ static inline struct eventfs_inode *init
 	if (!ei->name)
 		return NULL;
 	kref_init(&ei->kref);
+	INIT_LIST_HEAD(&ei->children);
+	INIT_LIST_HEAD(&ei->list);
 	return ei;
 }
 
@@ -727,8 +729,6 @@ struct eventfs_inode *eventfs_create_dir
 	ei->entries = entries;
 	ei->nr_entries = size;
 	ei->data = data;
-	INIT_LIST_HEAD(&ei->children);
-	INIT_LIST_HEAD(&ei->list);
 
 	mutex_lock(&eventfs_mutex);
 	if (!parent->is_freed)
@@ -801,9 +801,6 @@ struct eventfs_inode *eventfs_create_eve
 	ei->attr.uid = uid;
 	ei->attr.gid = gid;
 
-	INIT_LIST_HEAD(&ei->children);
-	INIT_LIST_HEAD(&ei->list);
-
 	ti = get_tracefs(inode);
 	ti->flags |= TRACEFS_EVENT_INODE;
 	ti->private = ei;


