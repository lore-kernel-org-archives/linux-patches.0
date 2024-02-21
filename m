Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4357776037;
	Wed, 21 Feb 2024 14:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525243; cv=none; b=Rf3u6RII1vwakvLUFaslHyNKiDNuxLoAGV7iVea+KhIPA5Q2jPZ3yEBgdFbgKEpOGj3EH6aW8FmvirvMXHdHYBoIshwDNM9zFx+Ikj/+iZDzucWFLk2mfbMzbLbjwXj9ggbWhrU+mfjTlD3FSOBur65exCM7GQ9tKknYdqRlsbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525243; c=relaxed/simple;
	bh=yPxsJpA8xvqLMFGJf9lkQsWHLreNuqwJ/MwxUpOEZgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nLbxRwV8Nb5mUP3QvXNKoB+O9FRWyqpXdal7ZojORIU7EE4ONtcL4yyvGH2cuqtwnFSpQvhVZBXwJJlJSK8llwN1P/iKz5P0mhNIx/IaFar1iBORI5XGabh+1hcBAiznhctz+R+AC02dmbTR5kW1beLxW31TkhZ2KVwT7eFBciM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uV80StZc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uV80StZc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17E0FC433C7;
	Wed, 21 Feb 2024 14:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525241;
	bh=yPxsJpA8xvqLMFGJf9lkQsWHLreNuqwJ/MwxUpOEZgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uV80StZcmorJjyyMwvamadysc9CyFKZwocVv20kt4g7iqaViFZT+yayYi6jrx6l1Y
	 htS3pU1gCzgb45kSew7lkPMRZzmH8SXYzvx/a37IUFWmcqDGNWx4+sKKs0HB6nlUhb
	 myZzpTRiWQ5ZPHDJajq1VzscSPGVH+wlG3VXnVHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+39ba34a099ac2e9bd3cb@syzkaller.appspotmail.com,
	Osama Muhammad <osmtendev@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 073/267] FS:JFS:UBSAN:array-index-out-of-bounds in dbAdjTree
Date: Wed, 21 Feb 2024 14:06:54 +0100
Message-ID: <20240221125942.271909258@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Osama Muhammad <osmtendev@gmail.com>

[ Upstream commit 9862ec7ac1cbc6eb5ee4a045b5d5b8edbb2f7e68 ]

Syzkaller reported the following issue:

UBSAN: array-index-out-of-bounds in fs/jfs/jfs_dmap.c:2867:6
index 196694 is out of range for type 's8[1365]' (aka 'signed char[1365]')
CPU: 1 PID: 109 Comm: jfsCommit Not tainted 6.6.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/04/2023
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1e7/0x2d0 lib/dump_stack.c:106
 ubsan_epilogue lib/ubsan.c:217 [inline]
 __ubsan_handle_out_of_bounds+0x11c/0x150 lib/ubsan.c:348
 dbAdjTree+0x474/0x4f0 fs/jfs/jfs_dmap.c:2867
 dbJoin+0x210/0x2d0 fs/jfs/jfs_dmap.c:2834
 dbFreeBits+0x4eb/0xda0 fs/jfs/jfs_dmap.c:2331
 dbFreeDmap fs/jfs/jfs_dmap.c:2080 [inline]
 dbFree+0x343/0x650 fs/jfs/jfs_dmap.c:402
 txFreeMap+0x798/0xd50 fs/jfs/jfs_txnmgr.c:2534
 txUpdateMap+0x342/0x9e0
 txLazyCommit fs/jfs/jfs_txnmgr.c:2664 [inline]
 jfs_lazycommit+0x47a/0xb70 fs/jfs/jfs_txnmgr.c:2732
 kthread+0x2d3/0x370 kernel/kthread.c:388
 ret_from_fork+0x48/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x11/0x20 arch/x86/entry/entry_64.S:304
 </TASK>
================================================================================
Kernel panic - not syncing: UBSAN: panic_on_warn set ...
CPU: 1 PID: 109 Comm: jfsCommit Not tainted 6.6.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/04/2023
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1e7/0x2d0 lib/dump_stack.c:106
 panic+0x30f/0x770 kernel/panic.c:340
 check_panic_on_warn+0x82/0xa0 kernel/panic.c:236
 ubsan_epilogue lib/ubsan.c:223 [inline]
 __ubsan_handle_out_of_bounds+0x13c/0x150 lib/ubsan.c:348
 dbAdjTree+0x474/0x4f0 fs/jfs/jfs_dmap.c:2867
 dbJoin+0x210/0x2d0 fs/jfs/jfs_dmap.c:2834
 dbFreeBits+0x4eb/0xda0 fs/jfs/jfs_dmap.c:2331
 dbFreeDmap fs/jfs/jfs_dmap.c:2080 [inline]
 dbFree+0x343/0x650 fs/jfs/jfs_dmap.c:402
 txFreeMap+0x798/0xd50 fs/jfs/jfs_txnmgr.c:2534
 txUpdateMap+0x342/0x9e0
 txLazyCommit fs/jfs/jfs_txnmgr.c:2664 [inline]
 jfs_lazycommit+0x47a/0xb70 fs/jfs/jfs_txnmgr.c:2732
 kthread+0x2d3/0x370 kernel/kthread.c:388
 ret_from_fork+0x48/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x11/0x20 arch/x86/entry/entry_64.S:304
 </TASK>
Kernel Offset: disabled
Rebooting in 86400 seconds..

The issue is caused when the value of lp becomes greater than
CTLTREESIZE which is the max size of stree. Adding a simple check
solves this issue.

Dave:
As the function returns a void, good error handling
would require a more intrusive code reorganization, so I modified
Osama's patch at use WARN_ON_ONCE for lack of a cleaner option.

The patch is tested via syzbot.

Reported-by: syzbot+39ba34a099ac2e9bd3cb@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=39ba34a099ac2e9bd3cb
Signed-off-by: Osama Muhammad <osmtendev@gmail.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_dmap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index ea330ce921b1..e8c1f3738c39 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -2935,6 +2935,9 @@ static void dbAdjTree(dmtree_t * tp, int leafno, int newval)
 	/* is the current value the same as the old value ?  if so,
 	 * there is nothing to do.
 	 */
+	if (WARN_ON_ONCE(lp >= CTLTREESIZE))
+		return;
+
 	if (tp->dmt_stree[lp] == newval)
 		return;
 
-- 
2.43.0



