Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B91A755E4C;
	Tue,  9 Jul 2024 11:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524685; cv=none; b=mGmr0aOUINq3cg7kJKY+24jKkxJSF9mC2ySm6iN7dCNZzBCoaBXgZMxZBPLcT2vNMDCaEo7uMx2wTyYKZlCIo+77VNBoRmh1aV0nu9srnt66gqwHpMHxXEJ1/lKJS1iVv+vRcA4KqWy0DBopg2HqQvoZs36lKuHxhCNmddmejXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524685; c=relaxed/simple;
	bh=9rV/l0Y1ClMlfHUeG51+pv+1KX9XZEvRT+5hgO62+DE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=smBW4u0lf1g8X0eNElpOfha8sCPFlSc4GJZQT3wzGLVtrXRGnvCRu/MaIYOhJ0wOJvlQSGzX21RRSMhSRI0M23ydmfjw5gGvmy1FtdCWX8bhvHzenmn8NMUODKBSaLiEnUrZXmW40P7gREPmutTX0vOU7hKWRXbDGb2EZgPzx68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YGdV0sT0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YGdV0sT0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 420B5C3277B;
	Tue,  9 Jul 2024 11:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524685;
	bh=9rV/l0Y1ClMlfHUeG51+pv+1KX9XZEvRT+5hgO62+DE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YGdV0sT0iJJTmW3skhtTOLfHZ7eqd5JlEZr91zddO5i8rBb0ZauMlo9IXnwRKac+m
	 t0dp3ziHs/n1SFH+JQNrR+f17jNGs0R6Nn+ga7G9Pj3/BvZ0SFSX9VvnPjksbrlw+0
	 S024p4u1nyRlUVz2tmIcfHqbPokfGHpYULKnjidc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
	Filipe Manana <fdmanana@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 067/102] btrfs: fix adding block group to a reclaim list and the unused list during reclaim
Date: Tue,  9 Jul 2024 13:10:30 +0200
Message-ID: <20240709110653.987438539@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
References: <20240709110651.353707001@linuxfoundation.org>
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

From: Naohiro Aota <naohiro.aota@wdc.com>

commit 48f091fd50b2eb33ae5eaea9ed3c4f81603acf38 upstream.

There is a potential parallel list adding for retrying in
btrfs_reclaim_bgs_work and adding to the unused list. Since the block
group is removed from the reclaim list and it is on a relocation work,
it can be added into the unused list in parallel. When that happens,
adding it to the reclaim list will corrupt the list head and trigger
list corruption like below.

Fix it by taking fs_info->unused_bgs_lock.

  [177.504][T2585409] BTRFS error (device nullb1): error relocating ch= unk 2415919104
  [177.514][T2585409] list_del corruption. next->prev should be ff1100= 0344b119c0, but was ff11000377e87c70. (next=3Dff110002390cd9c0)
  [177.529][T2585409] ------------[ cut here ]------------
  [177.537][T2585409] kernel BUG at lib/list_debug.c:65!
  [177.545][T2585409] Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
  [177.555][T2585409] CPU: 9 PID: 2585409 Comm: kworker/u128:2 Tainted: G        W          6.10.0-rc5-kts #1
  [177.568][T2585409] Hardware name: Supermicro SYS-520P-WTR/X12SPW-TF, BIOS 1.2 02/14/2022
  [177.579][T2585409] Workqueue: events_unbound btrfs_reclaim_bgs_work[btrfs]
  [177.589][T2585409] RIP: 0010:__list_del_entry_valid_or_report.cold+0x70/0x72
  [177.624][T2585409] RSP: 0018:ff11000377e87a70 EFLAGS: 00010286
  [177.633][T2585409] RAX: 000000000000006d RBX: ff11000344b119c0 RCX:0000000000000000
  [177.644][T2585409] RDX: 000000000000006d RSI: 0000000000000008 RDI:ffe21c006efd0f40
  [177.655][T2585409] RBP: ff110002e0509f78 R08: 0000000000000001 R09:ffe21c006efd0f08
  [177.665][T2585409] R10: ff11000377e87847 R11: 0000000000000000 R12:ff110002390cd9c0
  [177.676][T2585409] R13: ff11000344b119c0 R14: ff110002e0508000 R15:dffffc0000000000
  [177.687][T2585409] FS:  0000000000000000(0000) GS:ff11000fec880000(0000) knlGS:0000000000000000
  [177.700][T2585409] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [177.709][T2585409] CR2: 00007f06bc7b1978 CR3: 0000001021e86005 CR4:0000000000771ef0
  [177.720][T2585409] DR0: 0000000000000000 DR1: 0000000000000000 DR2:0000000000000000
  [177.731][T2585409] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:0000000000000400
  [177.742][T2585409] PKRU: 55555554
  [177.748][T2585409] Call Trace:
  [177.753][T2585409]  <TASK>
  [177.759][T2585409]  ? __die_body.cold+0x19/0x27
  [177.766][T2585409]  ? die+0x2e/0x50
  [177.772][T2585409]  ? do_trap+0x1ea/0x2d0
  [177.779][T2585409]  ? __list_del_entry_valid_or_report.cold+0x70/0x72
  [177.788][T2585409]  ? do_error_trap+0xa3/0x160
  [177.795][T2585409]  ? __list_del_entry_valid_or_report.cold+0x70/0x72
  [177.805][T2585409]  ? handle_invalid_op+0x2c/0x40
  [177.812][T2585409]  ? __list_del_entry_valid_or_report.cold+0x70/0x72
  [177.820][T2585409]  ? exc_invalid_op+0x2d/0x40
  [177.827][T2585409]  ? asm_exc_invalid_op+0x1a/0x20
  [177.834][T2585409]  ? __list_del_entry_valid_or_report.cold+0x70/0x72
  [177.843][T2585409]  btrfs_delete_unused_bgs+0x3d9/0x14c0 [btrfs]

There is a similar retry_list code in btrfs_delete_unused_bgs(), but it is
safe, AFAICS. Since the block group was in the unused list, the used bytes
should be 0 when it was added to the unused list. Then, it checks
block_group->{used,reserved,pinned} are still 0 under the
block_group->lock. So, they should be still eligible for the unused list,
not the reclaim list.

The reason it is safe there it's because because we're holding
space_info->groups_sem in write mode.

That means no other task can allocate from the block group, so while we
are at deleted_unused_bgs() it's not possible for other tasks to
allocate and deallocate extents from the block group, so it can't be
added to the unused list or the reclaim list by anyone else.

The bug can be reproduced by btrfs/166 after a few rounds. In practice
this can be hit when relocation cannot find more chunk space and ends
with ENOSPC.

Reported-by: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Suggested-by: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Fixes: 4eb4e85c4f81 ("btrfs: retry block group reclaim without infinite loop")
CC: stable@vger.kernel.org # 5.15+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/block-group.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1720,8 +1720,17 @@ void btrfs_reclaim_bgs_work(struct work_
 next:
 		if (ret) {
 			/* Refcount held by the reclaim_bgs list after splice. */
-			btrfs_get_block_group(bg);
-			list_add_tail(&bg->bg_list, &retry_list);
+			spin_lock(&fs_info->unused_bgs_lock);
+			/*
+			 * This block group might be added to the unused list
+			 * during the above process. Move it back to the
+			 * reclaim list otherwise.
+			 */
+			if (list_empty(&bg->bg_list)) {
+				btrfs_get_block_group(bg);
+				list_add_tail(&bg->bg_list, &retry_list);
+			}
+			spin_unlock(&fs_info->unused_bgs_lock);
 		}
 		btrfs_put_block_group(bg);
 


