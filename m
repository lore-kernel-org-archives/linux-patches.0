Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A4B31DF251;
	Tue,  8 Oct 2024 12:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392370; cv=none; b=aPKmc8GKxypCMiQ9Nnop7Br649mzLCqLjN6DzfExxKGMUZCJ9WkuppbEMDDDDE+H6RzJWfp2+2uMVBfWdFk1WlywYilhgvMunGMtTBJ6aZpXxqETikVp6c7MbUwU/Vh04SOkTxrwF6nS9+FzSd7vnC8MGDPw/SOI3k7Z2L3Me04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392370; c=relaxed/simple;
	bh=eMqGbh6zAgFhslnqdtnbR6OiODAcxApfiPje8QOb/PE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UkziZJpAofGgZA9DJOBD7TEJbDmhhhn0t9b5VwGB5eR0SaNCdQgysIlc3fWJwvNeZIiCLiyaR5+DavAG70NNqxxTCCuYZ2X9eqesXEwg1nDUVoPbJpPWhkVQnVXCr7izoYgnqOy5gUhBp2s0BWeScOFMHQ7y8Fd2EKlyLk7QKw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aviYthq+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aviYthq+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 931F1C4CEC7;
	Tue,  8 Oct 2024 12:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392370;
	bh=eMqGbh6zAgFhslnqdtnbR6OiODAcxApfiPje8QOb/PE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aviYthq+MxHndUrCqEYluX2wM5acNeGQ/DRpyt9rYIRItiAeKmo+gkwMIIn8N2qCY
	 Mz0ldNb+Zt+EoPCPBBxbWv/v5LRe7mweHr87GCSo34ytdo8Yjyjq921jHK0GOW1Zli
	 LLTPu0UtRlOIqMZJnfNIE7D17lvrOKZpzhqrV4mU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	"Luis Henriques (SUSE)" <luis.henriques@linux.dev>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.11 395/558] ext4: fix fast commit inode enqueueing during a full journal commit
Date: Tue,  8 Oct 2024 14:07:05 +0200
Message-ID: <20241008115717.826235340@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luis Henriques (SUSE) <luis.henriques@linux.dev>

commit 6db3c1575a750fd417a70e0178bdf6efa0dd5037 upstream.

When a full journal commit is on-going, any fast commit has to be enqueued
into a different queue: FC_Q_STAGING instead of FC_Q_MAIN.  This enqueueing
is done only once, i.e. if an inode is already queued in a previous fast
commit entry it won't be enqueued again.  However, if a full commit starts
_after_ the inode is enqueued into FC_Q_MAIN, the next fast commit needs to
be done into FC_Q_STAGING.  And this is not being done in function
ext4_fc_track_template().

This patch fixes the issue by re-enqueuing an inode into the STAGING queue
during the fast commit clean-up callback when doing a full commit.  However,
to prevent a race with a fast-commit, the clean-up callback has to be called
with the journal locked.

This bug was found using fstest generic/047.  This test creates several 32k
bytes files, sync'ing each of them after it's creation, and then shutting
down the filesystem.  Some data may be loss in this operation; for example a
file may have it's size truncated to zero.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Luis Henriques (SUSE) <luis.henriques@linux.dev>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20240717172220.14201-1-luis.henriques@linux.dev
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/fast_commit.c |   15 ++++++++++++++-
 fs/jbd2/journal.c     |    2 +-
 2 files changed, 15 insertions(+), 2 deletions(-)

--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -1295,8 +1295,21 @@ static void ext4_fc_cleanup(journal_t *j
 		list_del_init(&iter->i_fc_list);
 		ext4_clear_inode_state(&iter->vfs_inode,
 				       EXT4_STATE_FC_COMMITTING);
-		if (tid_geq(tid, iter->i_sync_tid))
+		if (tid_geq(tid, iter->i_sync_tid)) {
 			ext4_fc_reset_inode(&iter->vfs_inode);
+		} else if (full) {
+			/*
+			 * We are called after a full commit, inode has been
+			 * modified while the commit was running. Re-enqueue
+			 * the inode into STAGING, which will then be splice
+			 * back into MAIN. This cannot happen during
+			 * fastcommit because the journal is locked all the
+			 * time in that case (and tid doesn't increase so
+			 * tid check above isn't reliable).
+			 */
+			list_add_tail(&EXT4_I(&iter->vfs_inode)->i_fc_list,
+				      &sbi->s_fc_q[FC_Q_STAGING]);
+		}
 		/* Make sure EXT4_STATE_FC_COMMITTING bit is clear */
 		smp_mb();
 #if (BITS_PER_LONG < 64)
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -740,9 +740,9 @@ EXPORT_SYMBOL(jbd2_fc_begin_commit);
  */
 static int __jbd2_fc_end_commit(journal_t *journal, tid_t tid, bool fallback)
 {
-	jbd2_journal_unlock_updates(journal);
 	if (journal->j_fc_cleanup_callback)
 		journal->j_fc_cleanup_callback(journal, 0, tid);
+	jbd2_journal_unlock_updates(journal);
 	write_lock(&journal->j_state_lock);
 	journal->j_flags &= ~JBD2_FAST_COMMIT_ONGOING;
 	if (fallback)


