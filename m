Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815E53570D5;
	Wed, 21 Jan 2026 18:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019849; cv=none; b=NRbD50/XdsIjg1qV7H4XftL/MUU+so7OGq8iz1A3Z+lIW0lNAGIZnoj2Y6svbABI6aEK6S4JTYTE6h7dobutFHQbhADmlsG1SstDQ9PlrZIFEKwlxXXe+yb5NR9xbpoUQW0Sd4wkk9bce6I23f1FMRsKfhgdzFFBe/KTEaBKvFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019849; c=relaxed/simple;
	bh=3gShXI/XXbxGrWMs7wHQRm/cWJnVziGeLzsbL9uL7yE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pv5dMkdAubySfA4FCny4CgluBNbItdwurfw4Y3Da9vge5wM3iCuqGnhguj3RAg1mjOMcZOBPRHhYw5bHH0EJyuBXcgnMIWg5QbB9rZPbUAtaRIzmPK+O9gKgiy6U7XisowayO4Q6vsa201KFzbW+ez0jplax9hPo8udOT7f7/Zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u5tb4WsD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u5tb4WsD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D96C4CEF1;
	Wed, 21 Jan 2026 18:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019849;
	bh=3gShXI/XXbxGrWMs7wHQRm/cWJnVziGeLzsbL9uL7yE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u5tb4WsDjtUV7JpWwrym3oUA5DI9rQwrQ/Bc/VLqlDeZ8AY3PFjoibUmuS3t0rFnQ
	 6F+Er3YAZ3ZCEnIzl94wIAesFwePz5PY5/qAkCMS4d23F17CI4PowNrvWRofNln7GA
	 wEqSzn2ABqPd85JYrhlo7iXnNflTwqYGNRV+jV9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Robbie Ko <robbieko@synology.com>,
	David Sterba <dsterba@suse.com>,
	=?UTF-8?q?Motiejus=20Jak=C5=A1tys?= <motiejus@jakstys.lt>
Subject: [PATCH 6.12 124/139] btrfs: fix deadlock in wait_current_trans() due to ignored transaction type
Date: Wed, 21 Jan 2026 19:16:12 +0100
Message-ID: <20260121181415.915531128@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robbie Ko <robbieko@synology.com>

commit 5037b342825df7094a4906d1e2a9674baab50cb2 upstream.

When wait_current_trans() is called during start_transaction(), it
currently waits for a blocked transaction without considering whether
the given transaction type actually needs to wait for that particular
transaction state. The btrfs_blocked_trans_types[] array already defines
which transaction types should wait for which transaction states, but
this check was missing in wait_current_trans().

This can lead to a deadlock scenario involving two transactions and
pending ordered extents:

  1. Transaction A is in TRANS_STATE_COMMIT_DOING state

  2. A worker processing an ordered extent calls start_transaction()
     with TRANS_JOIN

  3. join_transaction() returns -EBUSY because Transaction A is in
     TRANS_STATE_COMMIT_DOING

  4. Transaction A moves to TRANS_STATE_UNBLOCKED and completes

  5. A new Transaction B is created (TRANS_STATE_RUNNING)

  6. The ordered extent from step 2 is added to Transaction B's
     pending ordered extents

  7. Transaction B immediately starts commit by another task and
     enters TRANS_STATE_COMMIT_START

  8. The worker finally reaches wait_current_trans(), sees Transaction B
     in TRANS_STATE_COMMIT_START (a blocked state), and waits
     unconditionally

  9. However, TRANS_JOIN should NOT wait for TRANS_STATE_COMMIT_START
     according to btrfs_blocked_trans_types[]

  10. Transaction B is waiting for pending ordered extents to complete

  11. Deadlock: Transaction B waits for ordered extent, ordered extent
      waits for Transaction B

This can be illustrated by the following call stacks:
  CPU0                              CPU1
                                    btrfs_finish_ordered_io()
                                      start_transaction(TRANS_JOIN)
                                        join_transaction()
                                          # -EBUSY (Transaction A is
                                          # TRANS_STATE_COMMIT_DOING)
  # Transaction A completes
  # Transaction B created
  # ordered extent added to
  # Transaction B's pending list
  btrfs_commit_transaction()
    # Transaction B enters
    # TRANS_STATE_COMMIT_START
    # waiting for pending ordered
    # extents
                                        wait_current_trans()
                                          # waits for Transaction B
                                          # (should not wait!)

Task bstore_kv_sync in btrfs_commit_transaction waiting for ordered
extents:

  __schedule+0x2e7/0x8a0
  schedule+0x64/0xe0
  btrfs_commit_transaction+0xbf7/0xda0 [btrfs]
  btrfs_sync_file+0x342/0x4d0 [btrfs]
  __x64_sys_fdatasync+0x4b/0x80
  do_syscall_64+0x33/0x40
  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Task kworker in wait_current_trans waiting for transaction commit:

  Workqueue: btrfs-syno_nocow btrfs_work_helper [btrfs]
  __schedule+0x2e7/0x8a0
  schedule+0x64/0xe0
  wait_current_trans+0xb0/0x110 [btrfs]
  start_transaction+0x346/0x5b0 [btrfs]
  btrfs_finish_ordered_io.isra.0+0x49b/0x9c0 [btrfs]
  btrfs_work_helper+0xe8/0x350 [btrfs]
  process_one_work+0x1d3/0x3c0
  worker_thread+0x4d/0x3e0
  kthread+0x12d/0x150
  ret_from_fork+0x1f/0x30

Fix this by passing the transaction type to wait_current_trans() and
checking btrfs_blocked_trans_types[cur_trans->state] against the given
type before deciding to wait. This ensures that transaction types which
are allowed to join during certain blocked states will not unnecessarily
wait and cause deadlocks.

Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Robbie Ko <robbieko@synology.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Cc: Motiejus Jakštys <motiejus@jakstys.lt>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/transaction.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -520,13 +520,14 @@ static inline int is_transaction_blocked
  * when this is done, it is safe to start a new transaction, but the current
  * transaction might not be fully on disk.
  */
-static void wait_current_trans(struct btrfs_fs_info *fs_info)
+static void wait_current_trans(struct btrfs_fs_info *fs_info, unsigned int type)
 {
 	struct btrfs_transaction *cur_trans;
 
 	spin_lock(&fs_info->trans_lock);
 	cur_trans = fs_info->running_transaction;
-	if (cur_trans && is_transaction_blocked(cur_trans)) {
+	if (cur_trans && is_transaction_blocked(cur_trans) &&
+	    (btrfs_blocked_trans_types[cur_trans->state] & type)) {
 		refcount_inc(&cur_trans->use_count);
 		spin_unlock(&fs_info->trans_lock);
 
@@ -701,12 +702,12 @@ again:
 		sb_start_intwrite(fs_info->sb);
 
 	if (may_wait_transaction(fs_info, type))
-		wait_current_trans(fs_info);
+		wait_current_trans(fs_info, type);
 
 	do {
 		ret = join_transaction(fs_info, type);
 		if (ret == -EBUSY) {
-			wait_current_trans(fs_info);
+			wait_current_trans(fs_info, type);
 			if (unlikely(type == TRANS_ATTACH ||
 				     type == TRANS_JOIN_NOSTART))
 				ret = -ENOENT;
@@ -1003,7 +1004,7 @@ out:
 
 void btrfs_throttle(struct btrfs_fs_info *fs_info)
 {
-	wait_current_trans(fs_info);
+	wait_current_trans(fs_info, TRANS_START);
 }
 
 bool btrfs_should_end_transaction(struct btrfs_trans_handle *trans)


