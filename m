Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 126AE346FB8;
	Tue,  6 Jan 2026 17:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720332; cv=none; b=OEk68VNLJx2DkCZHiWFznZdZfJAZ9UjfX9xbL/MfUkr5pNlXidboJ+3Oe05iCWGMkBFH6oko4XMhXhslo5Euq0BwfWVSU6j6LG4XyOVNWXFSpvKoc4lIdPBHm31OUO6X/jcw7QYQQrXy58rcFqRkdQfldHefkE3kP6oD+4kYhu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720332; c=relaxed/simple;
	bh=J5g5ca0O5+Ni3NbeTjB31wb37qxfQerSJ4GxiR3LcbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lpHcFscKOdcpN0H6DTnTBvVEP5ArI5eeY+vImnNSjzfnB8aXxGKdtkvW4yCAbiDVksXa76DSc8Tqh4hjVji0uxkmRkbZH/QKNjB2fV+G5OUwmdKj9JZNExjazvpS7oaao9lRmLWVvCpB7kGOBOoFfUlRsFnLd4EJ+vSST6OEpvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bauwr3BI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bauwr3BI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39059C116C6;
	Tue,  6 Jan 2026 17:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720331;
	bh=J5g5ca0O5+Ni3NbeTjB31wb37qxfQerSJ4GxiR3LcbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bauwr3BIFdZRzw8Nsn41Y9VpPIdEt/Xb2+VbapIbF/kwVFKXpIup2ocoIn04hIDik
	 4vUofERQsbIZHPP2HHr8YXGcgbUTjYcRfNyHGXbB0uXbIS2vMSEpbC3EeRZMDYgiJS
	 qdG9TsTn9coHuqsaDYs5Y1vc4nMq5ls0H0reMUJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jan Prusakowski <jprusakowski@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.12 203/567] f2fs: ensure node page reads complete before f2fs_put_super() finishes
Date: Tue,  6 Jan 2026 17:59:45 +0100
Message-ID: <20260106170458.834356386@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Jan Prusakowski <jprusakowski@google.com>

commit 297baa4aa263ff8f5b3d246ee16a660d76aa82c4 upstream.

Xfstests generic/335, generic/336 sometimes crash with the following message:

F2FS-fs (dm-0): detect filesystem reference count leak during umount, type: 9, count: 1
------------[ cut here ]------------
kernel BUG at fs/f2fs/super.c:1939!
Oops: invalid opcode: 0000 [#1] SMP NOPTI
CPU: 1 UID: 0 PID: 609351 Comm: umount Tainted: G        W           6.17.0-rc5-xfstests-g9dd1835ecda5 #1 PREEMPT(none)
Tainted: [W]=WARN
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:f2fs_put_super+0x3b3/0x3c0
Call Trace:
 <TASK>
 generic_shutdown_super+0x7e/0x190
 kill_block_super+0x1a/0x40
 kill_f2fs_super+0x9d/0x190
 deactivate_locked_super+0x30/0xb0
 cleanup_mnt+0xba/0x150
 task_work_run+0x5c/0xa0
 exit_to_user_mode_loop+0xb7/0xc0
 do_syscall_64+0x1ae/0x1c0
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
 </TASK>
---[ end trace 0000000000000000 ]---

It appears that sometimes it is possible that f2fs_put_super() is called before
all node page reads are completed.
Adding a call to f2fs_wait_on_all_pages() for F2FS_RD_NODE fixes the problem.

Cc: stable@kernel.org
Fixes: 20872584b8c0b ("f2fs: fix to drop all dirty meta/node pages during umount()")
Signed-off-by: Jan Prusakowski <jprusakowski@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/super.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1654,14 +1654,6 @@ static void f2fs_put_super(struct super_
 		truncate_inode_pages_final(META_MAPPING(sbi));
 	}
 
-	for (i = 0; i < NR_COUNT_TYPE; i++) {
-		if (!get_pages(sbi, i))
-			continue;
-		f2fs_err(sbi, "detect filesystem reference count leak during "
-			"umount, type: %d, count: %lld", i, get_pages(sbi, i));
-		f2fs_bug_on(sbi, 1);
-	}
-
 	f2fs_bug_on(sbi, sbi->fsync_node_num);
 
 	f2fs_destroy_compress_inode(sbi);
@@ -1672,6 +1664,15 @@ static void f2fs_put_super(struct super_
 	iput(sbi->meta_inode);
 	sbi->meta_inode = NULL;
 
+	/* Should check the page counts after dropping all node/meta pages */
+	for (i = 0; i < NR_COUNT_TYPE; i++) {
+		if (!get_pages(sbi, i))
+			continue;
+		f2fs_err(sbi, "detect filesystem reference count leak during "
+			"umount, type: %d, count: %lld", i, get_pages(sbi, i));
+		f2fs_bug_on(sbi, 1);
+	}
+
 	/*
 	 * iput() can update stat information, if f2fs_write_checkpoint()
 	 * above failed with error.


