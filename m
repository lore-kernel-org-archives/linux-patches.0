Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694B246444;
	Tue, 10 Sep 2024 09:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961016; cv=none; b=IppIy5Al/5N9iMF5FlecyZgEjdVLeXuvD0CKkEn3cjpX0IIQ3Bdq88OSrsXcQmnY0iVsZKjjnDslQXvcAIaSk1ACFMfhr84YcswMyzpfSJlVNLj71ZH+72b9nB7VowNiyMMoXREGbkndTy33M7HQwb8QA6j0qJE8Yx2bLwDX/eM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961016; c=relaxed/simple;
	bh=UEiwqx/tjVd0kmpnDPbjWfwUfx+3zJy4CR5aUjMydww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WDyDSIKFa7QC/jCqeD4pOqMAe4r5J1kiW10WWTBsbjDnREOOxngdEL9jvo99R+O2kXArB2bPiyFX9lAmAbnQBKTbFYtN6FdhZntqKWyEYtXnF+MaUg9PI8NpYfWMjBO6UPZXMQQdM4GmtAZhfAnnIFTvZfWLHZxDDm6OxNgwzfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RfkGC0w/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RfkGC0w/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E0AC4CEC3;
	Tue, 10 Sep 2024 09:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961016;
	bh=UEiwqx/tjVd0kmpnDPbjWfwUfx+3zJy4CR5aUjMydww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RfkGC0w/3tevCbBXGf8mfFFkz2Dp4Or0pmJZqP7aB5pJ0pNFBMiG/imtK/H2tT9MG
	 74G0m/zjPljAG614j2hppzFac5f8p1jhG60YPYDm1cLK1t1J7E5k4oPn+kBS5sKokn
	 p1qo+6ME5c68/YzbZpdonY+O3tlu2B+ETBey4v7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4.19 24/96] nilfs2: fix missing cleanup on rollforward recovery error
Date: Tue, 10 Sep 2024 11:31:26 +0200
Message-ID: <20240910092542.508861207@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092541.383432924@linuxfoundation.org>
References: <20240910092541.383432924@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

commit 5787fcaab9eb5930f5378d6a1dd03d916d146622 upstream.

In an error injection test of a routine for mount-time recovery, KASAN
found a use-after-free bug.

It turned out that if data recovery was performed using partial logs
created by dsync writes, but an error occurred before starting the log
writer to create a recovered checkpoint, the inodes whose data had been
recovered were left in the ns_dirty_files list of the nilfs object and
were not freed.

Fix this issue by cleaning up inodes that have read the recovery data if
the recovery routine fails midway before the log writer starts.

Link: https://lkml.kernel.org/r/20240810065242.3701-1-konishi.ryusuke@gmail.com
Fixes: 0f3e1c7f23f8 ("nilfs2: recovery functions")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/recovery.c |   35 +++++++++++++++++++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)

--- a/fs/nilfs2/recovery.c
+++ b/fs/nilfs2/recovery.c
@@ -709,6 +709,33 @@ static void nilfs_finish_roll_forward(st
 }
 
 /**
+ * nilfs_abort_roll_forward - cleaning up after a failed rollforward recovery
+ * @nilfs: nilfs object
+ */
+static void nilfs_abort_roll_forward(struct the_nilfs *nilfs)
+{
+	struct nilfs_inode_info *ii, *n;
+	LIST_HEAD(head);
+
+	/* Abandon inodes that have read recovery data */
+	spin_lock(&nilfs->ns_inode_lock);
+	list_splice_init(&nilfs->ns_dirty_files, &head);
+	spin_unlock(&nilfs->ns_inode_lock);
+	if (list_empty(&head))
+		return;
+
+	set_nilfs_purging(nilfs);
+	list_for_each_entry_safe(ii, n, &head, i_dirty) {
+		spin_lock(&nilfs->ns_inode_lock);
+		list_del_init(&ii->i_dirty);
+		spin_unlock(&nilfs->ns_inode_lock);
+
+		iput(&ii->vfs_inode);
+	}
+	clear_nilfs_purging(nilfs);
+}
+
+/**
  * nilfs_salvage_orphan_logs - salvage logs written after the latest checkpoint
  * @nilfs: nilfs object
  * @sb: super block instance
@@ -766,15 +793,19 @@ int nilfs_salvage_orphan_logs(struct the
 		if (unlikely(err)) {
 			nilfs_err(sb, "error %d writing segment for recovery",
 				  err);
-			goto failed;
+			goto put_root;
 		}
 
 		nilfs_finish_roll_forward(nilfs, ri);
 	}
 
- failed:
+put_root:
 	nilfs_put_root(root);
 	return err;
+
+failed:
+	nilfs_abort_roll_forward(nilfs);
+	goto put_root;
 }
 
 /**


