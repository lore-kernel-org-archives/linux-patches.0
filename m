Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF9A19E98B;
	Mon, 14 Oct 2024 15:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919248; cv=none; b=einFVzXlfnvr0KPy3mylFssRogyOIsEd2WRnczQR6MiVdK5fb0rkyzUuQ2uPsfK2B4ftu9gTrsahWA45iVfETJRf6mFFFD5GAZhkxDIy0kBJAHqXHUj3TdR6R1Dj3WprcdjoxY2p9n/2NoYC6Qa3DnonkNm0m57w1dM2ueWhMgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919248; c=relaxed/simple;
	bh=oEc0wF8NmS4FjsMGtjpbjbfD6BCJ8QYeIj8mW+1NGl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gj7AeHCHSTupbpJlX6L2GTGgoSA8wQ9q6zYVyTK5zUfnZeLUuJseNfKuMmAaq+v/fMIw+5pprv5t3gYdB28P2UKgii0hNkqOrOrt3wn/+8Kd0bZARSpWYT6sgOTfsnL3Na1r6o7ynPzCcuQ/bn/qaR7sKOEY8agDlpzbJMIIeps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZZxMFwSw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZZxMFwSw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C21AC4CEC3;
	Mon, 14 Oct 2024 15:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919247;
	bh=oEc0wF8NmS4FjsMGtjpbjbfD6BCJ8QYeIj8mW+1NGl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZZxMFwSwkPEWCD3Ph/O1fCq7hNkX2jBEz+/mGWWrllxUsklovD+jeQoE3l3ZFOzhA
	 IQANOzopLI8CGkJ1ToszfHUKQcYpqhicsPGlXoXzKyt8nPbNe3nT8WY3qyvLmc9/Q8
	 3cvzjEBAF5euCbUnxVyVd72fJHIMeZJDJjxQSut0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	"Luis Henriques (SUSE)" <luis.henriques@linux.dev>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.1 554/798] ext4: fix fast commit inode enqueueing during a full journal commit
Date: Mon, 14 Oct 2024 16:18:28 +0200
Message-ID: <20241014141239.761205365@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1317,8 +1317,21 @@ static void ext4_fc_cleanup(journal_t *j
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
@@ -767,9 +767,9 @@ EXPORT_SYMBOL(jbd2_fc_begin_commit);
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


