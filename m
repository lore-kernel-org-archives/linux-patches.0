Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5071F1DE4E0;
	Thu, 28 May 2026 20:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000907; cv=none; b=e0hQVNtEKsw0wa516eVf/eja3zjmlI/zkH5Xj13dP9pJsQWA8lLIt5scDAMHegLPHz8bIMQXDHmW0t9RVWp7UmHleZPMFCb/krv8xnfBJ0GjKTKwiaSIXQxFH+9OjTjUOwH6ECZ2goU5zN5AxIYvreQmKgr3Rblyx653xQCzqto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000907; c=relaxed/simple;
	bh=WtZhdgxIh5d7tv73vmIt+Vp1InX8szkSy5NIOcXfkyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pgVLGh3QXv0DPcor88RxHv9/XjpNIgfXTpOJ+7Rr32B3AyQp5GU4zfvtRviOChq+RUPKlMEAuP+ThB9Tu7YPulwoyV3FBTT4du3ke4FXGbTtzaaD8vDnXb/gSj+kwbF0dFN71bgETcFiV/KJ80qLpm0F3bvHk368lx3CuNLEIhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iJh9hpHo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iJh9hpHo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE5F11F000E9;
	Thu, 28 May 2026 20:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000906;
	bh=a3tA06hBirVTDIpGt+QPndQusVTpofr4Z+hSq87evY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iJh9hpHoz13u+3R60eDS4g3FkKH5DUU3wfFmg2H1sS0K/fo1NMx/Wo2EdsrV5rmCg
	 PJf4uWWNn8gVZmCVfEceT3Prkd/GLWNnX4zPkGiyf8/H1qHqAsK0SC9bSmwPTNoju+
	 58NLuKLBiNStBisIcyz03ydGGx40kTllmyZAJAhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 165/272] btrfs: tracepoints: fix sleep while in atomic context in btrfs_sync_file()
Date: Thu, 28 May 2026 21:48:59 +0200
Message-ID: <20260528194633.950477584@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit c73370c677646e86fc4b1780fb07027bdf847375 ]

The trace event btrfs_sync_file() is called in an atomic context (all trace
events are) and its call to dput(), which is needed due to the call to
dget_parent(), can sleep, triggering a kernel splat.

This can be reproduced by enabling the trace event and running btrfs/056
from fstests for example. The splat shown in dmesg is the following:

  [53.919] BUG: sleeping function called from invalid context at fs/dcache.c:970
  [53.947] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 32773, name: xfs_io
  [53.988] preempt_count: 2, expected: 0
  [53.967] RCU nest depth: 0, expected: 0
  [53.943] Preemption disabled at:
  [53.944] [<0000000000000000>] 0x0
  [54.078] CPU: 0 UID: 0 PID: 32773 Comm: xfs_io Tainted: G        W           7.1.0-rc1-btrfs-next-232+ #1 PREEMPT(full)
  [54.070] Tainted: [W]=WARN
  [54.071] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.2-0-gea1b7a073390-prebuilt.qemu.org 04/01/2014
  [54.072] Call Trace:
  [54.074]  <TASK>
  [54.076]  dump_stack_lvl+0x56/0x80
  [54.079]  __might_resched.cold+0xd6/0x10f
  [54.072]  dput.part.0+0x24/0x110
  [54.078]  trace_event_raw_event_btrfs_sync_file+0x75/0x140 [btrfs]
  [54.089]  btrfs_sync_file+0x1ed/0x530 [btrfs]
  [54.087]  ? __handle_mm_fault+0x8ae/0xed0
  [54.089]  btrfs_do_write_iter+0x172/0x210 [btrfs]
  [54.091]  vfs_write+0x21f/0x450
  [54.094]  __x64_sys_pwrite64+0x8d/0xc0
  [54.096]  ? do_user_addr_fault+0x20c/0x670
  [54.099]  do_syscall_64+0x60/0xf20
  [54.092]  ? clear_bhb_loop+0x60/0xb0
  [54.094]  entry_SYSCALL_64_after_hwframe+0x76/0x7e

So stop using dget_parent() and dput() and access the parent dentry
directly as dentry->d_parent. This is also what ext4 is doing in
its equivalent trace event ext4_sync_file_enter().

Fixes: a85b46db143f ("btrfs: tracepoints: get correct superblock from dentry in event btrfs_sync_file()")
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/btrfs.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index b964cba4169c2..6382a570c76c5 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -773,10 +773,8 @@ TRACE_EVENT(btrfs_sync_file,
 	TP_fast_assign(
 		struct dentry *dentry = file_dentry(file);
 		struct inode *inode = file_inode(file);
-		struct dentry *parent = dget_parent(dentry);
-		struct inode *parent_inode = d_inode(parent);
+		struct inode *parent_inode = d_inode(dentry->d_parent);
 
-		dput(parent);
 		TP_fast_assign_fsid(btrfs_sb(inode->i_sb));
 		__entry->ino		= btrfs_ino(BTRFS_I(inode));
 		__entry->parent		= btrfs_ino(BTRFS_I(parent_inode));
-- 
2.53.0



