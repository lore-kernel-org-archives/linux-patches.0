Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C12CE27F749;
	Wed,  4 Feb 2026 14:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216869; cv=none; b=llj49GiHHrshd35nC0qFVXBxW9NsSk27wbNqHwRJaawe02FYGEetar/sesK6ndepL9Q0c7mKu+/J7ytt3jRZ0pqFjuaQN6s/pY/RKpV0LMOYbiBpNjofZqKpTlKD+ldBy85mdOxzXub8Bljzw3cDrH/0gJGG8T5OWvqBPnw9R20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216869; c=relaxed/simple;
	bh=MQcS2ggLBHiC/3mzrOylQnohmZMJtaQ10ihVrcpetcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YrQkLz66Y+kfprZb3nyzM/OHD7IKdTXa1K/Mp/xDb4EDUhY2ML08fCoTVEy5G1dn3X88kt8j0XMu6T0S7dmCYlvH9tLegk2+iBPvJTvV7YViKbBbFK5O085/9TbAtcJ5/8WWmKB+tTTA+DJnUFOSRrzxjs84Aiv8f7vqY2DU7OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y+7B+P10; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y+7B+P10"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF39C4CEF7;
	Wed,  4 Feb 2026 14:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216869;
	bh=MQcS2ggLBHiC/3mzrOylQnohmZMJtaQ10ihVrcpetcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y+7B+P102Ue8Dh2q1Bxr6Wt+TEd5xItSr8gsUzs+Yhnl6aovg19O9qgNKTfsS5/RI
	 jAfdY9kME7u6aGiK5MKrtuMpzGX2yZp8D6/U+2tl0C3S4DsxNjr8UBkHv7dfNuy/I/
	 z3NyRd225B95JHIsAHbxAztHYhV6JYZZNB6dgZp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Robbie Ko <robbieko@synology.com>,
	David Sterba <dsterba@suse.com>,
	=?UTF-8?q?Motiejus=20Jak=C5=A1tys?= <motiejus@jakstys.lt>
Subject: [PATCH 5.15 054/206] btrfs: fix deadlock in wait_current_trans() due to ignored transaction type
Date: Wed,  4 Feb 2026 15:38:05 +0100
Message-ID: <20260204143900.164187684@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -528,13 +528,14 @@ static inline int is_transaction_blocked
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
 
@@ -680,12 +681,12 @@ again:
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
@@ -952,7 +953,7 @@ out:
 
 void btrfs_throttle(struct btrfs_fs_info *fs_info)
 {
-	wait_current_trans(fs_info);
+	wait_current_trans(fs_info, TRANS_START);
 }
 
 static bool should_end_transaction(struct btrfs_trans_handle *trans)


