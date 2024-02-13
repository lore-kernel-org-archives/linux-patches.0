Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99AEFA93C;
	Tue, 13 Feb 2024 17:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707846030; cv=none; b=D1tqVgFEtYvRFLVbYjyJ+iMJDlzh9LCJ26o6Wx6yJc6AK26hID8nkzMp1OT21Mi+bhh8PB+hi/08QCXhwU9TrJ3IeVwXbmqG1v/gesRsbCtzhSKjFuKN4WzFIa43IDsd/8ZW5FoaNwPImCBrlf/NaR+X8kwKoxF+flxW5dSiebE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707846030; c=relaxed/simple;
	bh=Byzx4kBAifj4Jr7wkSLp6+78+mOHSO2/lj6zxiVPBQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l9rRPU+EY+e2HnmUQ7swK9Eg4UUSj1LYnq9KiN08LBggxeA+OarWOOR9JNr7Z/9mSdK/s1wzxzhA0efgO3l8IBcUwV3hRvQ0eg+WSbUgxtendk+ZOEUuV6K6gKFnLCyRPQZUKWXZYPSYPBp0X69optKjVAVFtSmAGkRJBGIpiJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ePMuNx38; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ePMuNx38"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB548C433F1;
	Tue, 13 Feb 2024 17:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707846030;
	bh=Byzx4kBAifj4Jr7wkSLp6+78+mOHSO2/lj6zxiVPBQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ePMuNx38INxEEhguoZuUv7AfM7xmNaOxeDvsMsSdwhCTqYtzETA4g7zyT9CZVezMX
	 XwZ8r7l8ly2eLC/lc61h0g7cBnVqE6ejTi3bE4TZguizb/UVAiGy2widGp+NRrZEVQ
	 KgOnyxpLOKHIN1uGTDGVLdP0rOXfykyKUrYcNITI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Yue <glass.su@suse.com>,
	Brian Foster <bfoster@redhat.com>,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 6.7 116/124] bcachefs: kvfree bch_fs::snapshots in bch2_fs_snapshots_exit
Date: Tue, 13 Feb 2024 18:22:18 +0100
Message-ID: <20240213171857.117707563@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Su Yue <glass.su@suse.com>

commit 369acf97d6fd5da620d053d0f1878ffe32eff555 upstream.

bch_fs::snapshots is allocated by kvzalloc in __snapshot_t_mut.
It should be freed by kvfree not kfree.
Or umount will triger:

[  406.829178 ] BUG: unable to handle page fault for address: ffffe7b487148008
[  406.830676 ] #PF: supervisor read access in kernel mode
[  406.831643 ] #PF: error_code(0x0000) - not-present page
[  406.832487 ] PGD 0 P4D 0
[  406.832898 ] Oops: 0000 [#1] PREEMPT SMP PTI
[  406.833512 ] CPU: 2 PID: 1754 Comm: umount Kdump: loaded Tainted: G           OE      6.7.0-rc7-custom+ #90
[  406.834746 ] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Arch Linux 1.16.3-1-1 04/01/2014
[  406.835796 ] RIP: 0010:kfree+0x62/0x140
[  406.836197 ] Code: 80 48 01 d8 0f 82 e9 00 00 00 48 c7 c2 00 00 00 80 48 2b 15 78 9f 1f 01 48 01 d0 48 c1 e8 0c 48 c1 e0 06 48 03 05 56 9f 1f 01 <48> 8b 50 08 48 89 c7 f6 c2 01 0f 85 b0 00 00 00 66 90 48 8b 07 f6
[  406.837810 ] RSP: 0018:ffffb9d641607e48 EFLAGS: 00010286
[  406.838213 ] RAX: ffffe7b487148000 RBX: ffffb9d645200000 RCX: ffffb9d641607dc4
[  406.838738 ] RDX: 000065bb00000000 RSI: ffffffffc0d88b84 RDI: ffffb9d645200000
[  406.839217 ] RBP: ffff9a4625d00068 R08: 0000000000000001 R09: 0000000000000001
[  406.839650 ] R10: 0000000000000001 R11: 000000000000001f R12: ffff9a4625d4da80
[  406.840055 ] R13: ffff9a4625d00000 R14: ffffffffc0e2eb20 R15: 0000000000000000
[  406.840451 ] FS:  00007f0a264ffb80(0000) GS:ffff9a4e2d500000(0000) knlGS:0000000000000000
[  406.840851 ] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  406.841125 ] CR2: ffffe7b487148008 CR3: 000000018c4d2000 CR4: 00000000000006f0
[  406.841464 ] Call Trace:
[  406.841583 ]  <TASK>
[  406.841682 ]  ? __die+0x1f/0x70
[  406.841828 ]  ? page_fault_oops+0x159/0x470
[  406.842014 ]  ? fixup_exception+0x22/0x310
[  406.842198 ]  ? exc_page_fault+0x1ed/0x200
[  406.842382 ]  ? asm_exc_page_fault+0x22/0x30
[  406.842574 ]  ? bch2_fs_release+0x54/0x280 [bcachefs]
[  406.842842 ]  ? kfree+0x62/0x140
[  406.842988 ]  ? kfree+0x104/0x140
[  406.843138 ]  bch2_fs_release+0x54/0x280 [bcachefs]
[  406.843390 ]  kobject_put+0xb7/0x170
[  406.843552 ]  deactivate_locked_super+0x2f/0xa0
[  406.843756 ]  cleanup_mnt+0xba/0x150
[  406.843917 ]  task_work_run+0x59/0xa0
[  406.844083 ]  exit_to_user_mode_prepare+0x197/0x1a0
[  406.844302 ]  syscall_exit_to_user_mode+0x16/0x40
[  406.844510 ]  do_syscall_64+0x4e/0xf0
[  406.844675 ]  entry_SYSCALL_64_after_hwframe+0x6e/0x76
[  406.844907 ] RIP: 0033:0x7f0a2664e4fb

Signed-off-by: Su Yue <glass.su@suse.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/bcachefs/snapshot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/bcachefs/snapshot.c
+++ b/fs/bcachefs/snapshot.c
@@ -1709,5 +1709,5 @@ int bch2_snapshots_read(struct bch_fs *c
 
 void bch2_fs_snapshots_exit(struct bch_fs *c)
 {
-	kfree(rcu_dereference_protected(c->snapshots, true));
+	kvfree(rcu_dereference_protected(c->snapshots, true));
 }


