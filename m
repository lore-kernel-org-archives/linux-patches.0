Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD6A370AFD;
	Sat, 12 Sep 2026 13:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220008; cv=none; b=KpUwOoLS+IyB8pwvairZ5d4NXRA6T3p+DdUmr4rGjqLZlMe+4XvuMviXHdCIK4tHREE9rnX7xwR6si5Dt4OnxO0zUYVnQOBqq66hnWIqzZwsCs7C2Porbi4uw/baXA0bd/LCA16p2Sh8RA8ubnxAmZtdrEVZAuqp/mydehyJktI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220008; c=relaxed/simple;
	bh=8tOQvPIxeILoFRa1vjccSsPlDCwwMCroHgAhjfsFbiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GLyc4Uphr+vcdMhqz6K8gGAfTFs8yRmoVA+zU961ZI2RrFLNGncxZZQZdfVCfCCzr/HKn0hq9KikF5GPBfW1ZUvK0UuFzTOLRyLBgTwuhyElZG8zAgA5BJayMNFJ1Ne3OfhQ9c7Eued9n8To4zNr/T+72O8QwcXf8gfSxeD0mHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2FmsOx/b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2FmsOx/b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 608891F000FF;
	Sat, 12 Sep 2026 13:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220007;
	bh=OZ8uTMOaXxHzK6XqukNGN3aEJWrOFVOxK7SuO6Egq10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2FmsOx/bqZyVTnFVvHbOeAjILGZjEXx9yqLYawMBsqdVb++jLmC8s9IsPS7bus/xy
	 6hw9U8JUyu7nnmhHYlIoi/vAcURx8RjTYagj5XWxDSaFcSolr6XVJLhhGgbJ1xwqoS
	 1emw/5qtwwdFz6QFhBcp5OMexaSiyg6w9A/CPjYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3ef80b4ed02226d04a06@syzkaller.appspotmail.com,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.6 0089/1424] eventfs: Initialize ei->children and ei->list in init_ei()
Date: Sat, 12 Sep 2026 08:42:01 +0200
Message-ID: <20260912065609.299363501@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -511,6 +511,8 @@ static inline struct eventfs_inode *init
 	if (!ei->name)
 		return NULL;
 	kref_init(&ei->kref);
+	INIT_LIST_HEAD(&ei->children);
+	INIT_LIST_HEAD(&ei->list);
 	return ei;
 }
 
@@ -797,8 +799,6 @@ struct eventfs_inode *eventfs_create_dir
 	ei->entries = entries;
 	ei->nr_entries = size;
 	ei->data = data;
-	INIT_LIST_HEAD(&ei->children);
-	INIT_LIST_HEAD(&ei->list);
 
 	mutex_lock(&eventfs_mutex);
 	if (!parent->is_freed)
@@ -874,9 +874,6 @@ struct eventfs_inode *eventfs_create_eve
 	 */
 	ei->attr.mode |= EVENTFS_SAVE_UID | EVENTFS_SAVE_GID;
 
-	INIT_LIST_HEAD(&ei->children);
-	INIT_LIST_HEAD(&ei->list);
-
 	ti = get_tracefs(inode);
 	ti->flags |= TRACEFS_EVENT_INODE;
 	ti->private = ei;


