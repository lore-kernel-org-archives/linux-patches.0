Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78FB5373BE0;
	Thu, 12 Mar 2026 20:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773347349; cv=none; b=Jbbmm8Z5PLbrCYafhqkmrjm2ugkEWq6qBN/pUax7vv4ZLb+Ab50457f/9+vJe1tXHLwDbNV8eZaAA2LfmhP6vaHRv/o+dWy+5rrqntsI5q2xZtupNJcwjZxLYm58Mi2QRMqH3akV4zwWmil57eeYjNN4ZJ5u6XMIJDDIrYosqB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773347349; c=relaxed/simple;
	bh=ISfROsuQtI8Uj58cPZ4FYfAExg7dob9ShqhtTq0dmBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iU/fDYWClMDb+YLWRR+vLXaGsnFbwoXE/FOYUGT97lvNZ57f0CbFZVaaNB6tQwa4zy1czcx6b3qsAHv3EMczpIo5lF8d0SRQkCJmGfz1/xJ8qH1btURReQac2R+SWfh1ldSrMMOpiIjzhmsR0C8PNLs7yFeimJtIYa70xHq/u/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gxqsgfWS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gxqsgfWS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76CCCC4CEF7;
	Thu, 12 Mar 2026 20:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773347349;
	bh=ISfROsuQtI8Uj58cPZ4FYfAExg7dob9ShqhtTq0dmBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gxqsgfWSXaBBr27Oq6ZyE6ht2Kvm20d1ZxAuo/UEPqRPtDiFR/EeUUtAEANCQ95hU
	 VUUUscgHZXh7QRMWZ5DURkrj78RkaZpaMSYG1NQA/ZoCNdVtZzjtW4iXEqRd5ul3YC
	 ytBGmsrkoMgziGxCropwPsNJ42jQPW/vVTtWIMeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1713b1aa266195b916c2@syzkaller.appspotmail.com,
	stable@kernel.org,
	Baokun Li <libaokun1@huawei.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.12 261/265] ext4: fix potential null deref in ext4_mb_init()
Date: Thu, 12 Mar 2026 21:10:48 +0100
Message-ID: <20260312201027.778152784@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

From: Baokun Li <libaokun1@huawei.com>

commit 3c3fac6bc0a9c00dbe65d8dc0d3a282afe4d3188 upstream.

In ext4_mb_init(), ext4_mb_avg_fragment_size_destroy() may be called
when sbi->s_mb_avg_fragment_size remains uninitialized (e.g., if groupinfo
slab cache allocation fails). Since ext4_mb_avg_fragment_size_destroy()
lacks null pointer checking, this leads to a null pointer dereference.

==================================================================
EXT4-fs: no memory for groupinfo slab cache
BUG: kernel NULL pointer dereference, address: 0000000000000000
PGD 0 P4D 0
Oops: Oops: 0002 [#1] SMP PTI
CPU:2 UID: 0 PID: 87 Comm:mount Not tainted 6.17.0-rc2 #1134 PREEMPT(none)
RIP: 0010:_raw_spin_lock_irqsave+0x1b/0x40
Call Trace:
 <TASK>
 xa_destroy+0x61/0x130
 ext4_mb_init+0x483/0x540
 __ext4_fill_super+0x116d/0x17b0
 ext4_fill_super+0xd3/0x280
 get_tree_bdev_flags+0x132/0x1d0
 vfs_get_tree+0x29/0xd0
 do_new_mount+0x197/0x300
 __x64_sys_mount+0x116/0x150
 do_syscall_64+0x50/0x1c0
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
==================================================================

Therefore, add necessary null check to ext4_mb_avg_fragment_size_destroy()
to prevent this issue. The same fix is also applied to
ext4_mb_largest_free_orders_destroy().

Reported-by: syzbot+1713b1aa266195b916c2@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1713b1aa266195b916c2
Cc: stable@kernel.org
Fixes: f7eaacbb4e54 ("ext4: convert free groups order lists to xarrays")
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/mballoc.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3678,16 +3678,26 @@ static void ext4_discard_work(struct wor
 
 static inline void ext4_mb_avg_fragment_size_destroy(struct ext4_sb_info *sbi)
 {
+	if (!sbi->s_mb_avg_fragment_size)
+		return;
+
 	for (int i = 0; i < MB_NUM_ORDERS(sbi->s_sb); i++)
 		xa_destroy(&sbi->s_mb_avg_fragment_size[i]);
+
 	kfree(sbi->s_mb_avg_fragment_size);
+	sbi->s_mb_avg_fragment_size = NULL;
 }
 
 static inline void ext4_mb_largest_free_orders_destroy(struct ext4_sb_info *sbi)
 {
+	if (!sbi->s_mb_largest_free_orders)
+		return;
+
 	for (int i = 0; i < MB_NUM_ORDERS(sbi->s_sb); i++)
 		xa_destroy(&sbi->s_mb_largest_free_orders[i]);
+
 	kfree(sbi->s_mb_largest_free_orders);
+	sbi->s_mb_largest_free_orders = NULL;
 }
 
 int ext4_mb_init(struct super_block *sb)


