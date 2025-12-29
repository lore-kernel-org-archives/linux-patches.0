Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23506330672;
	Mon, 29 Dec 2025 16:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025738; cv=none; b=UmmqlLDY3bfbOnKdb7N9PguyGA6r91lLlrFzMdfP2kOfJ+xXG7Qiyq4bHulRa1+bIBObTKheila2iO7LFg/Vf/x8vF6MKmMXfjMkt3s6FV0cxv2DEa95GJzcNI1CwCdD8kFTu6IDon6pLhT7//O7niqkRl82MBzTaEa2hboXhGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025738; c=relaxed/simple;
	bh=V5InzV8Rr6ye4X3EoAsBKegrAIJpo6OGdpATjdTcoi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M9hKEShRhNglG5WfqrtuXCJz2WKpf6XQ2pbx+CbgCA0v+h/sZaEboYFF4UKCPdE0e5TyGZMCZPDJl7Npz0rPhV1CdYiSjw4tU5eyH5V/tSh8t7vShEcmcoCjF5l8smiWZxSUvEjHCHqw+iX4C1fgvPwK45u4PpAfkRthpeTDGgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wqJnIxUE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wqJnIxUE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92986C4CEF7;
	Mon, 29 Dec 2025 16:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025738;
	bh=V5InzV8Rr6ye4X3EoAsBKegrAIJpo6OGdpATjdTcoi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wqJnIxUEdqxfGqHg6k6rQVyN5DuiUvupYcxKxHc8rto+KohInov2fVArNEAqbkp9S
	 z89jhCBBimv0N/18EuQkr2jUcTJ5tgS3VPikAwyy59sUyWmi+bbR1Ru5FAtTTra55I
	 gACLBaBM/eBr3iyJJIjcjE4xknmYhy0rg/XuM07s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Xiaole He <hexiaole1994@126.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.18 320/430] f2fs: fix uninitialized one_time_gc in victim_sel_policy
Date: Mon, 29 Dec 2025 17:12:02 +0100
Message-ID: <20251229160736.105897452@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiaole He <hexiaole1994@126.com>

commit 392711ef18bff524a873b9c239a73148c5432262 upstream.

The one_time_gc field in struct victim_sel_policy is conditionally
initialized but unconditionally read, leading to undefined behavior
that triggers UBSAN warnings.

In f2fs_get_victim() at fs/f2fs/gc.c:774, the victim_sel_policy
structure is declared without initialization:

    struct victim_sel_policy p;

The field p.one_time_gc is only assigned when the 'one_time' parameter
is true (line 789):

    if (one_time) {
        p.one_time_gc = one_time;
        ...
    }

However, this field is unconditionally read in subsequent get_gc_cost()
at line 395:

    if (p->one_time_gc && (valid_thresh_ratio < 100) && ...)

When one_time is false, p.one_time_gc contains uninitialized stack
memory. Hence p.one_time_gc is an invalid bool value.

UBSAN detects this invalid bool value:

    UBSAN: invalid-load in fs/f2fs/gc.c:395:7
    load of value 77 is not a valid value for type '_Bool'
    CPU: 3 UID: 0 PID: 1297 Comm: f2fs_gc-252:16 Not tainted 6.18.0-rc3
    #5 PREEMPT(voluntary)
    Hardware name: OpenStack Foundation OpenStack Nova,
    BIOS 1.13.0-1ubuntu1.1 04/01/2014
    Call Trace:
     <TASK>
     dump_stack_lvl+0x70/0x90
     dump_stack+0x14/0x20
     __ubsan_handle_load_invalid_value+0xb3/0xf0
     ? dl_server_update+0x2e/0x40
     ? update_curr+0x147/0x170
     f2fs_get_victim.cold+0x66/0x134 [f2fs]
     ? sched_balance_newidle+0x2ca/0x470
     ? finish_task_switch.isra.0+0x8d/0x2a0
     f2fs_gc+0x2ba/0x8e0 [f2fs]
     ? _raw_spin_unlock_irqrestore+0x12/0x40
     ? __timer_delete_sync+0x80/0xe0
     ? timer_delete_sync+0x14/0x20
     ? schedule_timeout+0x82/0x100
     gc_thread_func+0x38b/0x860 [f2fs]
     ? gc_thread_func+0x38b/0x860 [f2fs]
     ? __pfx_autoremove_wake_function+0x10/0x10
     kthread+0x10b/0x220
     ? __pfx_gc_thread_func+0x10/0x10 [f2fs]
     ? _raw_spin_unlock_irq+0x12/0x40
     ? __pfx_kthread+0x10/0x10
     ret_from_fork+0x11a/0x160
     ? __pfx_kthread+0x10/0x10
     ret_from_fork_asm+0x1a/0x30
     </TASK>

This issue is reliably reproducible with the following steps on a
100GB SSD /dev/vdb:

    mkfs.f2fs -f /dev/vdb
    mount /dev/vdb /mnt/f2fs_test
    fio --name=gc --directory=/mnt/f2fs_test --rw=randwrite \
        --bs=4k --size=8G --numjobs=12 --fsync=4 --runtime=10 \
        --time_based
    echo 1 > /sys/fs/f2fs/vdb/gc_urgent

The uninitialized value causes incorrect GC victim selection, leading
to unpredictable garbage collection behavior.

Fix by zero-initializing the entire victim_sel_policy structure to
ensure all fields have defined values.

Fixes: e791d00bd06c ("f2fs: add valid block ratio not to do excessive GC for one time GC")
Cc: stable@kernel.org
Signed-off-by: Xiaole He <hexiaole1994@126.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/gc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -774,7 +774,7 @@ int f2fs_get_victim(struct f2fs_sb_info
 {
 	struct dirty_seglist_info *dirty_i = DIRTY_I(sbi);
 	struct sit_info *sm = SIT_I(sbi);
-	struct victim_sel_policy p;
+	struct victim_sel_policy p = {0};
 	unsigned int secno, last_victim;
 	unsigned int last_segment;
 	unsigned int nsearched;


