Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD614C6C;
	Tue, 17 Feb 2026 12:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771331633; cv=none; b=a+DQxFr8d+B+EaDBQQt62FUB5m4GsU6kaXN5Vh8d/1JGGx8dDSw8A5LBOd5v/alD25/u1l1ZYWgjJiozEkU0ZWR5b4eRUPirFG5il7ajNLCK9nopt2tOm2QQeb3oskaezYDRoai2MkoqWGBmnwDZB11OYunAd+9bDXzd9xLQkq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771331633; c=relaxed/simple;
	bh=QrEKdO0bkoESQUgN8doxYwY+YjoRwGATC86iFSRLX7I=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=O+Rxu0cSZtV7XOFuD2DZCekzWj7DV8iLcmvy7pmzcIamm/u4wzKUiHGmXufYXeAKMb8K28BIqFWE2upmhhunG1Fhq54O2yGV7og8SLWFduyfM+DUrjcScAsqCHHB8zs4Pl74FCuJ7Td/7PZBPHHzKfU9QHPV4l2a+PYuRvISXaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oMVDGCWX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oMVDGCWX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32EACC4CEF7;
	Tue, 17 Feb 2026 12:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771331633;
	bh=QrEKdO0bkoESQUgN8doxYwY+YjoRwGATC86iFSRLX7I=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=oMVDGCWX2xe+b3/WzdaNLCnS7vkE02rAGk8OaaUbkfWiQRftuua8h1Q5B6IR38TeE
	 WVIkJG++jaD/uG8WQqQBhYukm47L3NT+5lqgBOIVHEdwDLFpkLUSZirVXlmATJcBuv
	 N8cXI7Fs/4DWSFKEdP2nJ67GIDeN6cSVaBHSKwPk=
Subject: Patch "ksmbd: set ATTR_CTIME flags when setting mtime" has been added to the 6.1-stable tree
To: 1468888505@139.com,ddiss@suse.de,gregkh@linuxfoundation.org,linkinjeon@kernel.org,patches@lists.linux.dev,senozhatsky@chromium.org,sfrench@samba.org,stfrench@microsoft.com,tom@talpey.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 17 Feb 2026 13:33:39 +0100
In-Reply-To: <20260211055437.2798668-1-1468888505@139.com>
Message-ID: <2026021738-unable-patriarch-4d0b@gregkh>
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

    ksmbd: set ATTR_CTIME flags when setting mtime

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     ksmbd-set-attr_ctime-flags-when-setting-mtime.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-215750-greg=kroah.com@vger.kernel.org Wed Feb 11 06:54:55 2026
From: Li hongliang <1468888505@139.com>
Date: Wed, 11 Feb 2026 13:54:37 +0800
Subject: ksmbd: set ATTR_CTIME flags when setting mtime
To: gregkh@linuxfoundation.org, stable@vger.kernel.org, linkinjeon@kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org, sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com, ddiss@suse.de, linux-cifs@vger.kernel.org, stfrench@microsoft.com
Message-ID: <20260211055437.2798668-1-1468888505@139.com>

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 21e46a79bbe6c4e1aa73b3ed998130f2ff07b128 ]

David reported that the new warning from setattr_copy_mgtime is coming
like the following.

[  113.215316] ------------[ cut here ]------------
[  113.215974] WARNING: CPU: 1 PID: 31 at fs/attr.c:300 setattr_copy+0x1ee/0x200
[  113.219192] CPU: 1 UID: 0 PID: 31 Comm: kworker/1:1 Not tainted 6.13.0-rc1+ #234
[  113.220127] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.2-3-gd478f380-rebuilt.opensuse.org 04/01/2014
[  113.221530] Workqueue: ksmbd-io handle_ksmbd_work [ksmbd]
[  113.222220] RIP: 0010:setattr_copy+0x1ee/0x200
[  113.222833] Code: 24 28 49 8b 44 24 30 48 89 53 58 89 43 6c 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc 48 89 df e8 77 d6 ff ff e9 cd fe ff ff <0f> 0b e9 be fe ff ff 66 0
[  113.225110] RSP: 0018:ffffaf218010fb68 EFLAGS: 00010202
[  113.225765] RAX: 0000000000000120 RBX: ffffa446815f8568 RCX: 0000000000000003
[  113.226667] RDX: ffffaf218010fd38 RSI: ffffa446815f8568 RDI: ffffffff94eb03a0
[  113.227531] RBP: ffffaf218010fb90 R08: 0000001a251e217d R09: 00000000675259fa
[  113.228426] R10: 0000000002ba8a6d R11: ffffa4468196c7a8 R12: ffffaf218010fd38
[  113.229304] R13: 0000000000000120 R14: ffffffff94eb03a0 R15: 0000000000000000
[  113.230210] FS:  0000000000000000(0000) GS:ffffa44739d00000(0000) knlGS:0000000000000000
[  113.231215] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  113.232055] CR2: 00007efe0053d27e CR3: 000000000331a000 CR4: 00000000000006b0
[  113.232926] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  113.233812] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  113.234797] Call Trace:
[  113.235116]  <TASK>
[  113.235393]  ? __warn+0x73/0xd0
[  113.235802]  ? setattr_copy+0x1ee/0x200
[  113.236299]  ? report_bug+0xf3/0x1e0
[  113.236757]  ? handle_bug+0x4d/0x90
[  113.237202]  ? exc_invalid_op+0x13/0x60
[  113.237689]  ? asm_exc_invalid_op+0x16/0x20
[  113.238185]  ? setattr_copy+0x1ee/0x200
[  113.238692]  btrfs_setattr+0x80/0x820 [btrfs]
[  113.239285]  ? get_stack_info_noinstr+0x12/0xf0
[  113.239857]  ? __module_address+0x22/0xa0
[  113.240368]  ? handle_ksmbd_work+0x6e/0x460 [ksmbd]
[  113.240993]  ? __module_text_address+0x9/0x50
[  113.241545]  ? __module_address+0x22/0xa0
[  113.242033]  ? unwind_next_frame+0x10e/0x920
[  113.242600]  ? __pfx_stack_trace_consume_entry+0x10/0x10
[  113.243268]  notify_change+0x2c2/0x4e0
[  113.243746]  ? stack_depot_save_flags+0x27/0x730
[  113.244339]  ? set_file_basic_info+0x130/0x2b0 [ksmbd]
[  113.244993]  set_file_basic_info+0x130/0x2b0 [ksmbd]
[  113.245613]  ? process_scheduled_works+0xbe/0x310
[  113.246181]  ? worker_thread+0x100/0x240
[  113.246696]  ? kthread+0xc8/0x100
[  113.247126]  ? ret_from_fork+0x2b/0x40
[  113.247606]  ? ret_from_fork_asm+0x1a/0x30
[  113.248132]  smb2_set_info+0x63f/0xa70 [ksmbd]

ksmbd is trying to set the atime and mtime via notify_change without also
setting the ctime. so This patch add ATTR_CTIME flags when setting mtime
to avoid a warning.

Reported-by: David Disseldorp <ddiss@suse.de>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
[ Minor conflict resolved. ]
Signed-off-by: Li hongliang <1468888505@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5739,15 +5739,13 @@ static int set_file_basic_info(struct ks
 		attrs.ia_valid |= (ATTR_ATIME | ATTR_ATIME_SET);
 	}
 
-	attrs.ia_valid |= ATTR_CTIME;
 	if (file_info->ChangeTime)
-		attrs.ia_ctime = ksmbd_NTtimeToUnix(file_info->ChangeTime);
-	else
-		attrs.ia_ctime = inode->i_ctime;
+		inode_set_ctime_to_ts(inode,
+				ksmbd_NTtimeToUnix(file_info->ChangeTime));
 
 	if (file_info->LastWriteTime) {
 		attrs.ia_mtime = ksmbd_NTtimeToUnix(file_info->LastWriteTime);
-		attrs.ia_valid |= (ATTR_MTIME | ATTR_MTIME_SET);
+		attrs.ia_valid |= (ATTR_MTIME | ATTR_MTIME_SET | ATTR_CTIME);
 	}
 
 	if (file_info->Attributes) {
@@ -5789,8 +5787,6 @@ static int set_file_basic_info(struct ks
 			return -EACCES;
 
 		inode_lock(inode);
-		inode->i_ctime = attrs.ia_ctime;
-		attrs.ia_valid &= ~ATTR_CTIME;
 		rc = notify_change(user_ns, dentry, &attrs, NULL);
 		inode_unlock(inode);
 	}


Patches currently in stable-queue which might be from 1468888505@139.com are

queue-6.1/devlink-rate-unset-parent-pointer-in-devl_rate_nodes_destroy.patch
queue-6.1/ksmbd-set-attr_ctime-flags-when-setting-mtime.patch
queue-6.1/clk-mediatek-fix-of_iomap-memory-leak.patch
