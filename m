Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 127992DF9F;
	Tue, 20 Feb 2024 21:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464204; cv=none; b=t1/her1aswR92v52aMjwbwTRKKAqzNyMQmf3VLtYUwNFyjAUF4gM/1v209NbwdQ2KAYvKzmSobnrY6TmTLZrelUHTy+/0pxvMFCn5rwxNR58pSzidmqLbf5JVbd6rrf0vkWJQUtRQQ0yzrMBbkaxxj8FIj7lnFH3SwUdAIYHSXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464204; c=relaxed/simple;
	bh=G/Mw08yD+sPd0HO6SHkgSHDPfMieG3qUvb1dO01sZSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JTiSx+IkQqhbXIbTmsNs+kv1Zyu4S+5Gwn9kFpchV2K5gpf68i4uAqIoQ22Z4aghBZeGzXz/pxJKsTZc4o1VFilf5JwezPD30Ucd6LWLDMwfn7spD/Fqcm6oPuXV5Q7qvOUXAlHUNPpAWFuhkkk6ABJtebvyH3F6DfVuODtfBWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z3FeGCkf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z3FeGCkf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 871A3C433C7;
	Tue, 20 Feb 2024 21:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464203;
	bh=G/Mw08yD+sPd0HO6SHkgSHDPfMieG3qUvb1dO01sZSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z3FeGCkfPYb0IJ0sLVPk73gVV46A6M/W9lz0bTJRjW5Df8rrFwyObzwxww1rabPOQ
	 yqBwQmaOeYG1+kvis++wkRwx3nmtyanESoCt6BZAyiTcmapqN8PqCUD0aKtSVCCp1z
	 CNaGgTRuSfSV6eV6bdYLY0D8xvw38qEwZuJsgdew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Josef Bacik <josef@toxicpanda.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 284/331] eventfs: Move taking of inode_lock into dcache_dir_open_wrapper()
Date: Tue, 20 Feb 2024 21:56:40 +0100
Message-ID: <20240220205646.895397324@linuxfoundation.org>
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

commit bcae32c5632fc0a0dbce46fa731cd23403117e66 upstream.

The both create_file_dentry() and create_dir_dentry() takes a boolean
parameter "lookup", as on lookup the inode_lock should already be taken,
but for dcache_dir_open_wrapper() it is not taken.

There's no reason that the dcache_dir_open_wrapper() can't take the
inode_lock before calling these functions. In fact, it's better if it
does, as the lock can be held throughout both directory and file
creations.

This also simplifies the code, and possibly prevents unexpected race
conditions when the lock is released.

Link: https://lkml.kernel.org/r/20231121231112.528544825@goodmis.org

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Fixes: 5790b1fb3d672 ("eventfs: Remove eventfs_file and just use eventfs_inode")
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |   16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -347,15 +347,8 @@ create_file_dentry(struct eventfs_inode
 
 	mutex_unlock(&eventfs_mutex);
 
-	/* The lookup already has the parent->d_inode locked */
-	if (!lookup)
-		inode_lock(parent->d_inode);
-
 	dentry = create_file(name, mode, attr, parent, data, fops);
 
-	if (!lookup)
-		inode_unlock(parent->d_inode);
-
 	mutex_lock(&eventfs_mutex);
 
 	if (IS_ERR_OR_NULL(dentry)) {
@@ -453,15 +446,8 @@ create_dir_dentry(struct eventfs_inode *
 	}
 	mutex_unlock(&eventfs_mutex);
 
-	/* The lookup already has the parent->d_inode locked */
-	if (!lookup)
-		inode_lock(parent->d_inode);
-
 	dentry = create_dir(ei, parent);
 
-	if (!lookup)
-		inode_unlock(parent->d_inode);
-
 	mutex_lock(&eventfs_mutex);
 
 	if (IS_ERR_OR_NULL(dentry) && !ei->is_freed) {
@@ -693,6 +679,7 @@ static int dcache_dir_open_wrapper(struc
 		return -ENOMEM;
 	}
 
+	inode_lock(parent->d_inode);
 	list_for_each_entry_srcu(ei_child, &ei->children, list,
 				 srcu_read_lock_held(&eventfs_srcu)) {
 		d = create_dir_dentry(ei, ei_child, parent, false);
@@ -725,6 +712,7 @@ static int dcache_dir_open_wrapper(struc
 			cnt++;
 		}
 	}
+	inode_unlock(parent->d_inode);
 	srcu_read_unlock(&eventfs_srcu, idx);
 	ret = dcache_dir_open(inode, file);
 


