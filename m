Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062F636B07C;
	Thu, 19 Mar 2026 12:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773921710; cv=none; b=skZmMcN4A+5iRFR8mV7BKys5cijMyWUGKq74Z9eqfsRxmK+7gtpi89RAgbuwSfKlZ89sirkzLO+SP8rCjYCLbYLPACtmToUc2kqZzYG62EhUwL/d0T3SyHURGfEobgMWi3n8Z1yavs1gNziYGbHyv7tM4jlsCCdAipi45UWtSDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773921710; c=relaxed/simple;
	bh=qrrebqt85HR9K8FE9JnPTsqIPghjBh7k06QMaP35Gvc=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=P6iAYyqdpcuY0waJTyjsGit0RRM8AqqPQrxnDYTkPn+G6nojxseKuouQnyY1MZyGWDg0DUbr0m3F59YKea8ULEIyFFu1P/9h0Kv4ugek/Wo2vxC9eEPrHWN0tMgF2lQuthL6j1NFt7sGEnOtsTQi6diAuK78dyBfw0Cn1JUxbjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P+WbSty0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P+WbSty0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81D71C2BC87;
	Thu, 19 Mar 2026 12:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773921709;
	bh=qrrebqt85HR9K8FE9JnPTsqIPghjBh7k06QMaP35Gvc=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=P+WbSty00ZFEWVKuH0Rc+0kzh1EqIU+odRHB+6Jry95m7WYw5wjdAM7pc9SgLjrTa
	 JVDskwgrfMpPEzwClIOdOURelvFsPtv9060klDJrbQUy9IfsxyHvJe1QH17fcFryDP
	 Di6K7sN4OXHEuUw6IUcXlJcZ9p+6gWQ0Y0EGOXBw=
Subject: Patch "f2fs: zone: fix to avoid inconsistence in between SIT and SSA" has been added to the 6.6-stable tree
To: 1468888505@139.com,chao@kernel.org,daehojeong@google.com,gregkh@linuxfoundation.org,jaegeuk@kernel.org,linux-f2fs-devel@lists.sourceforge.net,patches@lists.linux.dev
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Thu, 19 Mar 2026 13:01:25 +0100
In-Reply-To: <20260304055556.2595295-1-1468888505@139.com>
Message-ID: <2026031925-underling-compacter-ea20@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    f2fs: zone: fix to avoid inconsistence in between SIT and SSA

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     f2fs-zone-fix-to-avoid-inconsistence-in-between-sit-and-ssa.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-222982-greg=kroah.com@vger.kernel.org Wed Mar  4 06:56:20 2026
From: Li hongliang <1468888505@139.com>
Date: Wed,  4 Mar 2026 13:55:56 +0800
Subject: f2fs: zone: fix to avoid inconsistence in between SIT and SSA
To: gregkh@linuxfoundation.org, stable@vger.kernel.org, chao@kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org, jaegeuk@kernel.org, daehojeong@google.com, linux-f2fs-devel@lists.sourceforge.net
Message-ID: <20260304055556.2595295-1-1468888505@139.com>

From: Chao Yu <chao@kernel.org>

[ Upstream commit 773704c1ef96a8b70d0d186ab725f50548de82c4 ]

w/ below testcase, it will cause inconsistence in between SIT and SSA.

create_null_blk 512 2 1024 1024
mkfs.f2fs -m /dev/nullb0
mount /dev/nullb0 /mnt/f2fs/
touch /mnt/f2fs/file
f2fs_io pinfile set /mnt/f2fs/file
fallocate -l 4GiB /mnt/f2fs/file

F2FS-fs (nullb0): Inconsistent segment (0) type [1, 0] in SSA and SIT
CPU: 5 UID: 0 PID: 2398 Comm: fallocate Tainted: G           O       6.13.0-rc1 #84
Tainted: [O]=OOT_MODULE
Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
Call Trace:
 <TASK>
 dump_stack_lvl+0xb3/0xd0
 dump_stack+0x14/0x20
 f2fs_handle_critical_error+0x18c/0x220 [f2fs]
 f2fs_stop_checkpoint+0x38/0x50 [f2fs]
 do_garbage_collect+0x674/0x6e0 [f2fs]
 f2fs_gc_range+0x12b/0x230 [f2fs]
 f2fs_allocate_pinning_section+0x5c/0x150 [f2fs]
 f2fs_expand_inode_data+0x1cc/0x3c0 [f2fs]
 f2fs_fallocate+0x3c3/0x410 [f2fs]
 vfs_fallocate+0x15f/0x4b0
 __x64_sys_fallocate+0x4a/0x80
 x64_sys_call+0x15e8/0x1b80
 do_syscall_64+0x68/0x130
 entry_SYSCALL_64_after_hwframe+0x67/0x6f
RIP: 0033:0x7f9dba5197ca
F2FS-fs (nullb0): Stopped filesystem due to reason: 4

The reason is f2fs_gc_range() may try to migrate block in curseg, however,
its SSA block is not uptodate due to the last summary block data is still
in cache of curseg.

In this patch, we add a condition in f2fs_gc_range() to check whether
section is opened or not, and skip block migration for opened section.

Fixes: 9703d69d9d15 ("f2fs: support file pinning for zoned devices")
Reviewed-by: Daeho Jeong <daehojeong@google.com>
Cc: Daeho Jeong <daehojeong@google.com>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
[ Minor conflict resolved. ]
Signed-off-by: Li hongliang <1468888505@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/gc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -2019,6 +2019,9 @@ int f2fs_gc_range(struct f2fs_sb_info *s
 		if (!get_valid_blocks(sbi, segno, true))
 			continue;
 
+		if (IS_CURSEC(sbi, GET_SEC_FROM_SEG(sbi, segno)))
+			continue;
+
 		do_garbage_collect(sbi, segno, &gc_list, FG_GC,
 						dry_run_sections == 0);
 		put_gc_inode(&gc_list);


Patches currently in stable-queue which might be from 1468888505@139.com are

queue-6.6/pnfs-fix-a-deadlock-when-returning-a-delegation-during-open.patch
queue-6.6/net-add-support-for-segmenting-tcp-fraglist-gso-packets.patch
queue-6.6/f2fs-zone-fix-to-avoid-inconsistence-in-between-sit-and-ssa.patch
queue-6.6/net-fix-segmentation-of-forwarding-fraglist-gro.patch
queue-6.6/nfs-pass-explicit-offset-count-to-trace-events.patch
queue-6.6/net-gso-fix-tcp-fraglist-segmentation-after-pull-from-frag_list.patch
queue-6.6/nfs-fix-a-deadlock-involving-nfs_release_folio.patch
