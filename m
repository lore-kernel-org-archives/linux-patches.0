Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 614C435503A;
	Tue,  6 Jan 2026 17:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720249; cv=none; b=IaNGCVWekYfKyZX3F6b8Mhow128ply2y7QhKj5fbImk+4XVtpX5fP76ytnp4d2lH1E2VVv1LcZFZRPxDTfc92jQfZn+8Ewf3i45u+TW5Ung1UyzCK3qQL7hfZKfQ3IEcwFQGyO5NdVxjJ89+2JDbz/M96Qhss56P+xORqqwCZWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720249; c=relaxed/simple;
	bh=RD01njYhuik0L66G7iJqzlkicboBtzIHfud2VAPHk7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p9B6H5xrguBd7vmvQzyWhUBkLkFgRLJ7oHlGn0hF4ZkbakE1eTj57S9ENVX55S/0ZWS2inYTSDzI/rSy8hLqYBU6cdELPMGFY7uxlfnhEl5JQCLJhixEiV9k9ArAuUeJWT9hgdo/bqX9v9G8kZSmR6/Ds5KEbK+9TC8FcX2xtno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VPruJE+K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VPruJE+K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4E73C116C6;
	Tue,  6 Jan 2026 17:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720249;
	bh=RD01njYhuik0L66G7iJqzlkicboBtzIHfud2VAPHk7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VPruJE+KPRhOOaL2I3lTTHx6bmWsH4mQ9GCy7l5EgyMU8AJcvZi8xoLDWEWFhpko5
	 kT7GQz6KBssn6gcPdgmEwX2V7As868xQzjbzRbYGHLUZFBYnf7iHaK4CgE5/78yF+X
	 5g9lf2Nh0Q+xcfSVlIY0QkNd7umsNNBaVropIr/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6e493c165d26d6fcbf72@syzkaller.appspotmail.com,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.12 172/567] jbd2: use a per-journal lock_class_key for jbd2_trans_commit_key
Date: Tue,  6 Jan 2026 17:59:14 +0100
Message-ID: <20260106170457.688775041@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit 524c3853831cf4f7e1db579e487c757c3065165c upstream.

syzbot is reporting possibility of deadlock due to sharing lock_class_key
for jbd2_handle across ext4 and ocfs2. But this is a false positive, for
one disk partition can't have two filesystems at the same time.

Reported-by: syzbot+6e493c165d26d6fcbf72@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=6e493c165d26d6fcbf72
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Tested-by: syzbot+6e493c165d26d6fcbf72@syzkaller.appspotmail.com
Reviewed-by: Jan Kara <jack@suse.cz>
Message-ID: <987110fc-5470-457a-a218-d286a09dd82f@I-love.SAKURA.ne.jp>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jbd2/journal.c    |    6 ++++--
 include/linux/jbd2.h |    6 ++++++
 2 files changed, 10 insertions(+), 2 deletions(-)

--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1526,7 +1526,6 @@ static journal_t *journal_init_common(st
 			struct block_device *fs_dev,
 			unsigned long long start, int len, int blocksize)
 {
-	static struct lock_class_key jbd2_trans_commit_key;
 	journal_t *journal;
 	int err;
 	int n;
@@ -1535,6 +1534,7 @@ static journal_t *journal_init_common(st
 	if (!journal)
 		return ERR_PTR(-ENOMEM);
 
+	lockdep_register_key(&journal->jbd2_trans_commit_key);
 	journal->j_blocksize = blocksize;
 	journal->j_dev = bdev;
 	journal->j_fs_dev = fs_dev;
@@ -1565,7 +1565,7 @@ static journal_t *journal_init_common(st
 	journal->j_max_batch_time = 15000; /* 15ms */
 	atomic_set(&journal->j_reserved_credits, 0);
 	lockdep_init_map(&journal->j_trans_commit_map, "jbd2_handle",
-			 &jbd2_trans_commit_key, 0);
+			 &journal->jbd2_trans_commit_key, 0);
 
 	/* The journal is marked for error until we succeed with recovery! */
 	journal->j_flags = JBD2_ABORT;
@@ -1618,6 +1618,7 @@ err_cleanup:
 	kfree(journal->j_wbuf);
 	jbd2_journal_destroy_revoke(journal);
 	journal_fail_superblock(journal);
+	lockdep_unregister_key(&journal->jbd2_trans_commit_key);
 	kfree(journal);
 	return ERR_PTR(err);
 }
@@ -2199,6 +2200,7 @@ int jbd2_journal_destroy(journal_t *jour
 		crypto_free_shash(journal->j_chksum_driver);
 	kfree(journal->j_fc_wbuf);
 	kfree(journal->j_wbuf);
+	lockdep_unregister_key(&journal->jbd2_trans_commit_key);
 	kfree(journal);
 
 	return err;
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1268,6 +1268,12 @@ struct journal_s
 	 */
 	struct lockdep_map	j_trans_commit_map;
 #endif
+	/**
+	 * @jbd2_trans_commit_key:
+	 *
+	 * "struct lock_class_key" for @j_trans_commit_map
+	 */
+	struct lock_class_key	jbd2_trans_commit_key;
 
 	/**
 	 * @j_fc_cleanup_callback:


