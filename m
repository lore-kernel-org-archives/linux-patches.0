Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D0515E5BB;
	Sat, 30 May 2026 18:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166871; cv=none; b=p4AbXE69N9vBjscQKxu8mAnk3Gnecd7h706nY7ktwcyOSAK/CWEiU8KWNfae2JkE3d3ZXOJmtyXQoKXVK4ODMB/R3nNj2Adi6kxxrHybyvclthMItz905s9XUTEe2/5/XlqGBu5muVbfba1jLM8+QNDh6MXvLgVWnDxDB/tufas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166871; c=relaxed/simple;
	bh=BG5LpBDFiTlGo3kGHvBlyv0Mguyno9frwt34g0ZOMlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vxy73tS26rw/NXp+4FILyFof49RPe9UhUUTTDM3H4DpP9NEl9bUZLmB8KZwXkZZUgtMWbZXGL1Lv7Emqt3eDFJjWp0WlyjAaBFaygmNsuiqQYTo27QkNqoUiNu6QaDglZqFClaYRtiihTCjJn/yt4oeQPvbtjSGj4ulnHLFrqvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MrZjWgrS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MrZjWgrS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CECCA1F00893;
	Sat, 30 May 2026 18:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166870;
	bh=ClA1/YryYY7W/JNi4iK27Y+V7MdmXnrrODC0DGfg2QY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MrZjWgrSTaGShbEHJn92YdHTNWB0UnqgUE/E7+zj0G8YE9klf/KH6RKs0MoNRmdMc
	 mXdhPJyCYyTCwopMQEE5WqhdBnQgozn5XryJu4mwh+QYxphWV2+m57q+XFFozMKhjw
	 cq8eSn/LbigMr6FOYv0zBO1VtrFRXbpU8ykagiRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 496/589] btrfs: tracepoints: fix sleep while in atomic context in btrfs_sync_file()
Date: Sat, 30 May 2026 18:06:17 +0200
Message-ID: <20260530160237.657192040@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7e6fcbc6c6c55..dc816accaf38a 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -699,10 +699,8 @@ TRACE_EVENT(btrfs_sync_file,
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



