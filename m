Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA18E199E9D;
	Tue, 10 Sep 2024 10:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963605; cv=none; b=d0xGAlgBnajzm0QtubU7OYIU1OwtsIrw5kHKAtWZJFY0jabvVqbeoW9+NHFs0jOSpmMSPR4Suq3/7JUgEB0l2OZSwCAG8DLMKsRXwS0EqIYLVB6AbNFUXLsjgE8IZ1hoN8UxD0RkFASB5IgYkYVH8OB5C3vEsg16MoY8xxpe/zY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963605; c=relaxed/simple;
	bh=A1qVX9GEpkp9zJgJiifMM65DZVfR232yjpuPDSHPnm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OgBpaicCmpwxd29OS/giWNprsAEmOI7EfYUGJ0WYUCbwKNvJrdb5IzQitdRm25U64mioGLlY4ZVA7zaX0EHJ60UwQNzs5IM3y5tm0VDvM7s3BNYZobsALlaUir09aDWEMvQu8UvmgHLhdrCpbvhmElvzvLEP2Rp3P7s1MS4H4NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ZIRuGlI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ZIRuGlI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34492C4CEC3;
	Tue, 10 Sep 2024 10:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963605;
	bh=A1qVX9GEpkp9zJgJiifMM65DZVfR232yjpuPDSHPnm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0ZIRuGlIMP8/oQ+Q9L3C31Rrj4fASNsE4hFxv1tGgeIsYMepGdHQxUuM6fOiZD/bk
	 H4msNrhuDwqdltrSowTqChBaTZZ8p/Cew2YMp69fsXtYEBoy5PR0XGohzSpMEOHtpt
	 Q4AWauru6D7/W86GIriAh894GGMQX4qd6YvZjgSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 088/214] nilfs2: fix missing cleanup on rollforward recovery error
Date: Tue, 10 Sep 2024 11:31:50 +0200
Message-ID: <20240910092602.351431293@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


