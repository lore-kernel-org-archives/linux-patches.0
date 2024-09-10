Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C2218DF88;
	Tue, 10 Sep 2024 10:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964916; cv=none; b=FT90YGp/KgfJEzuv40zOj/9ReGX+PX8u2AxCH+MS13N1P7HjqZzP39rkMXebJ9ReOlVRkNdGVgh39x8pXtN0jb9aJIdgTIWv/BHbIqza3YD2Gc7sEcdzlqj3hEauKGDDaGJSwG5srFUY7Txj7tf3OsqAW284nVHGyCquk+Eb+qI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964916; c=relaxed/simple;
	bh=b/fNIPAxikXA0ebjbvSLJteOPew2QLkIVsROXcTvqo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D5PovPz77FwguzxCRlG+AVFpMyvtcGwZB4emD2Y9pwgXRA+97Qh1C8ci3GaM10Qo38U68f9OyTgjH5R2FvCpj4l3zxH++jkelP51ooXN19J0QyHrHTNcctnvr1RpNUtcCwbJwg/5bS/7I5lV0gRABjIgQIkJJsnusqM270k0Tzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U5EPZ5pN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U5EPZ5pN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A05C4CEC3;
	Tue, 10 Sep 2024 10:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964916;
	bh=b/fNIPAxikXA0ebjbvSLJteOPew2QLkIVsROXcTvqo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U5EPZ5pNa4RMfmZpO0NqVZ2dlUYQQFhNMh0LjuOqpc2ZUQfmYaB74971oOwOWMuGf
	 GcoMv9dSQnSCr/dru/irnEnP8MmxB0G6BIO/GABSZ4m2l1j76yGoPEphkcs6t91KsF
	 y88K4mxb1sZWEFUh35GL8UCq8YNSLhzo1aDwCtMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Hugo SIMELIERE <hsimeliere.opensource@witekio.com>
Subject: [PATCH 5.10 075/186] btrfs: fix use-after-free after failure to create a snapshot
Date: Tue, 10 Sep 2024 11:32:50 +0200
Message-ID: <20240910092557.617472969@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

commit 28b21c558a3753171097193b6f6602a94169093a upstream.

At ioctl.c:create_snapshot(), we allocate a pending snapshot structure and
then attach it to the transaction's list of pending snapshots. After that
we call btrfs_commit_transaction(), and if that returns an error we jump
to 'fail' label, where we kfree() the pending snapshot structure. This can
result in a later use-after-free of the pending snapshot:

1) We allocated the pending snapshot and added it to the transaction's
   list of pending snapshots;

2) We call btrfs_commit_transaction(), and it fails either at the first
   call to btrfs_run_delayed_refs() or btrfs_start_dirty_block_groups().
   In both cases, we don't abort the transaction and we release our
   transaction handle. We jump to the 'fail' label and free the pending
   snapshot structure. We return with the pending snapshot still in the
   transaction's list;

3) Another task commits the transaction. This time there's no error at
   all, and then during the transaction commit it accesses a pointer
   to the pending snapshot structure that the snapshot creation task
   has already freed, resulting in a user-after-free.

This issue could actually be detected by smatch, which produced the
following warning:

  fs/btrfs/ioctl.c:843 create_snapshot() warn: '&pending_snapshot->list' not removed from list

So fix this by not having the snapshot creation ioctl directly add the
pending snapshot to the transaction's list. Instead add the pending
snapshot to the transaction handle, and then at btrfs_commit_transaction()
we add the snapshot to the list only when we can guarantee that any error
returned after that point will result in a transaction abort, in which
case the ioctl code can safely free the pending snapshot and no one can
access it anymore.

CC: stable@vger.kernel.org # 5.10+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Hugo SIMELIERE <hsimeliere.opensource@witekio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ioctl.c       |    5 +----
 fs/btrfs/transaction.c |   24 ++++++++++++++++++++++++
 fs/btrfs/transaction.h |    2 ++
 3 files changed, 27 insertions(+), 4 deletions(-)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -853,10 +853,7 @@ static int create_snapshot(struct btrfs_
 		goto fail;
 	}
 
-	spin_lock(&fs_info->trans_lock);
-	list_add(&pending_snapshot->list,
-		 &trans->transaction->pending_snapshots);
-	spin_unlock(&fs_info->trans_lock);
+	trans->pending_snapshot = pending_snapshot;
 
 	ret = btrfs_commit_transaction(trans);
 	if (ret)
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2075,6 +2075,27 @@ static inline void btrfs_wait_delalloc_f
 	}
 }
 
+/*
+ * Add a pending snapshot associated with the given transaction handle to the
+ * respective handle. This must be called after the transaction commit started
+ * and while holding fs_info->trans_lock.
+ * This serves to guarantee a caller of btrfs_commit_transaction() that it can
+ * safely free the pending snapshot pointer in case btrfs_commit_transaction()
+ * returns an error.
+ */
+static void add_pending_snapshot(struct btrfs_trans_handle *trans)
+{
+	struct btrfs_transaction *cur_trans = trans->transaction;
+
+	if (!trans->pending_snapshot)
+		return;
+
+	lockdep_assert_held(&trans->fs_info->trans_lock);
+	ASSERT(cur_trans->state >= TRANS_STATE_COMMIT_START);
+
+	list_add(&trans->pending_snapshot->list, &cur_trans->pending_snapshots);
+}
+
 int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
@@ -2161,6 +2182,8 @@ int btrfs_commit_transaction(struct btrf
 
 	spin_lock(&fs_info->trans_lock);
 	if (cur_trans->state >= TRANS_STATE_COMMIT_START) {
+		add_pending_snapshot(trans);
+
 		spin_unlock(&fs_info->trans_lock);
 		refcount_inc(&cur_trans->use_count);
 		ret = btrfs_end_transaction(trans);
@@ -2243,6 +2266,7 @@ int btrfs_commit_transaction(struct btrf
 	 * COMMIT_DOING so make sure to wait for num_writers to == 1 again.
 	 */
 	spin_lock(&fs_info->trans_lock);
+	add_pending_snapshot(trans);
 	cur_trans->state = TRANS_STATE_COMMIT_DOING;
 	spin_unlock(&fs_info->trans_lock);
 	wait_event(cur_trans->writer_wait,
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -122,6 +122,8 @@ struct btrfs_trans_handle {
 	struct btrfs_transaction *transaction;
 	struct btrfs_block_rsv *block_rsv;
 	struct btrfs_block_rsv *orig_rsv;
+	/* Set by a task that wants to create a snapshot. */
+	struct btrfs_pending_snapshot *pending_snapshot;
 	refcount_t use_count;
 	unsigned int type;
 	/*


