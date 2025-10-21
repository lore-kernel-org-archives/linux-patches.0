Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE52274B44;
	Tue, 21 Oct 2025 19:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076620; cv=none; b=hs+qtxZjpWC81lk/5K8JJ1pFLlsFV6sVG3uWg02F0k0MI/BJRaUoYIHO2knHOEm6g/ulPCNg5ZtEN+xgGevzpwLKdCK3I+iaM3AbIu1V8VTvtHt0Mv9sNwMbtcslXLSX8bVBLd9RWKYu4DZEcvCxETA1YqZYA9VaMw3RhHAKnMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076620; c=relaxed/simple;
	bh=J+1+dF1tVLBbd/2NGWukJ0ppl2bDYHx1uo0xGmAZZdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uRCCtd0Ns59eHU2MaYKTNQy4KOjIuT41n8H2NCJQcUALllC7K8571cOaE0uLNHdhfVsPn/xN/BQVnyktSoEq4y6TChLhLav5GxZPP9VwRiW4nE/+rDYw4MkB4XdZL+z3vHxce52nHpBE9PSPbdJjQpbdKQfXyUwWf+tRcSjFUVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V/YhfQbV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V/YhfQbV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79B59C4CEF1;
	Tue, 21 Oct 2025 19:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076619;
	bh=J+1+dF1tVLBbd/2NGWukJ0ppl2bDYHx1uo0xGmAZZdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V/YhfQbVlrnXvYuHRwCJ1HsNrE2YM4gmtRBpgi7rT2JCEq1ktjJNkzemVMCkJlGx+
	 tpRNdgokROFqnwIBzYzbGUetR7XM77pOthh0p9mCe8gpnyBKTqflxtw/pK0l5Wtb+s
	 DmPMTdYIPpCETLETvyCau6JeDbH16CBF5a6FOtUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shashank A P <shashank.ap@samsung.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 090/105] fs: quota: create dedicated workqueue for quota_release_work
Date: Tue, 21 Oct 2025 21:51:39 +0200
Message-ID: <20251021195023.787915016@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195021.492915002@linuxfoundation.org>
References: <20251021195021.492915002@linuxfoundation.org>
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

From: Shashank A P <shashank.ap@samsung.com>

[ Upstream commit 72b7ceca857f38a8ca7c5629feffc63769638974 ]

There is a kernel panic due to WARN_ONCE when panic_on_warn is set.

This issue occurs when writeback is triggered due to sync call for an
opened file(ie, writeback reason is WB_REASON_SYNC). When f2fs balance
is needed at sync path, flush for quota_release_work is triggered.
By default quota_release_work is queued to "events_unbound" queue which
does not have WQ_MEM_RECLAIM flag. During f2fs balance "writeback"
workqueue tries to flush quota_release_work causing kernel panic due to
MEM_RECLAIM flag mismatch errors.

This patch creates dedicated workqueue with WQ_MEM_RECLAIM flag
for work quota_release_work.

------------[ cut here ]------------
WARNING: CPU: 4 PID: 14867 at kernel/workqueue.c:3721 check_flush_dependency+0x13c/0x148
Call trace:
 check_flush_dependency+0x13c/0x148
 __flush_work+0xd0/0x398
 flush_delayed_work+0x44/0x5c
 dquot_writeback_dquots+0x54/0x318
 f2fs_do_quota_sync+0xb8/0x1a8
 f2fs_write_checkpoint+0x3cc/0x99c
 f2fs_gc+0x190/0x750
 f2fs_balance_fs+0x110/0x168
 f2fs_write_single_data_page+0x474/0x7dc
 f2fs_write_data_pages+0x7d0/0xd0c
 do_writepages+0xe0/0x2f4
 __writeback_single_inode+0x44/0x4ac
 writeback_sb_inodes+0x30c/0x538
 wb_writeback+0xf4/0x440
 wb_workfn+0x128/0x5d4
 process_scheduled_works+0x1c4/0x45c
 worker_thread+0x32c/0x3e8
 kthread+0x11c/0x1b0
 ret_from_fork+0x10/0x20
Kernel panic - not syncing: kernel: panic_on_warn set ...

Fixes: ac6f420291b3 ("quota: flush quota_release_work upon quota writeback")
CC: stable@vger.kernel.org
Signed-off-by: Shashank A P <shashank.ap@samsung.com>
Link: https://patch.msgid.link/20250901092905.2115-1-shashank.ap@samsung.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/quota/dquot.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -163,6 +163,9 @@ static struct quota_module_name module_n
 /* SLAB cache for dquot structures */
 static struct kmem_cache *dquot_cachep;
 
+/* workqueue for work quota_release_work*/
+static struct workqueue_struct *quota_unbound_wq;
+
 void register_quota_format(struct quota_format_type *fmt)
 {
 	spin_lock(&dq_list_lock);
@@ -891,7 +894,7 @@ void dqput(struct dquot *dquot)
 	put_releasing_dquots(dquot);
 	atomic_dec(&dquot->dq_count);
 	spin_unlock(&dq_list_lock);
-	queue_delayed_work(system_unbound_wq, &quota_release_work, 1);
+	queue_delayed_work(quota_unbound_wq, &quota_release_work, 1);
 }
 EXPORT_SYMBOL(dqput);
 
@@ -3046,6 +3049,11 @@ static int __init dquot_init(void)
 	if (register_shrinker(&dqcache_shrinker, "dquota-cache"))
 		panic("Cannot register dquot shrinker");
 
+	quota_unbound_wq = alloc_workqueue("quota_events_unbound",
+					   WQ_UNBOUND | WQ_MEM_RECLAIM, WQ_MAX_ACTIVE);
+	if (!quota_unbound_wq)
+		panic("Cannot create quota_unbound_wq\n");
+
 	return 0;
 }
 fs_initcall(dquot_init);


