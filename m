Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E843518893F;
	Fri, 27 Sep 2024 12:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440395; cv=none; b=KZ7V/GEB/rFHr9MDJnRz+vB7RzsVTGucode8N55BE6O+vUm2c9CuLBHIg4AnSRN4olabYl0UHwAWnZwWwQi0DV0mLYqbRJpyYygUjM0eiXsOdDU6vhXxod6a4t9Fd5laEMU9XTMXuaJqW2OGmXOFxBb2M7XB4vbnklzH+ADZsfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440395; c=relaxed/simple;
	bh=g4cM6g2U6FQPFx6q3/VJW48THhTbPFQpAY8PPCaeLhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vCum0QxaxF66KtS2DM2ZZ0XONueIBg9EovGcOjzj/IbyjeUy8ZU7epCdjiq+F738hEXG9irSFxJSVe8ekVF189Am+lI2htoAom4xv1GUFKiLPYaEoWFBAPbBFzq1/xNJejyr7a+THBVXS4ADw5WxEGeG7afMvFq+mQ5teY+xlgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v00vZ2Y8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v00vZ2Y8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74473C4CEC4;
	Fri, 27 Sep 2024 12:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440394;
	bh=g4cM6g2U6FQPFx6q3/VJW48THhTbPFQpAY8PPCaeLhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v00vZ2Y8ssm/W7o4/jvdUjP7E4Wv/IXacwND2HxIvmnPpUdHqDmzffiTvsAmXVtOf
	 tOEQYE5eRCiyimCNdH3RRjoY6q+llsXTzpNF53wVuya/YAJiSO65vvAYkrpJ0lvXy3
	 mOsnp2wJOyEYJ2N4H1haX3ZdOf4VpM3JvkUCkgPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Bin <yebin10@huawei.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Dave Chinner <david@fromorbit.com>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 6.1 41/73] xfs: fix BUG_ON in xfs_getbmap()
Date: Fri, 27 Sep 2024 14:23:52 +0200
Message-ID: <20240927121721.596282462@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.897851549@linuxfoundation.org>
References: <20240927121719.897851549@linuxfoundation.org>
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

From: Ye Bin <yebin10@huawei.com>

[ Upstream commit 8ee81ed581ff35882b006a5205100db0b57bf070 ]

There's issue as follows:
XFS: Assertion failed: (bmv->bmv_iflags & BMV_IF_DELALLOC) != 0, file: fs/xfs/xfs_bmap_util.c, line: 329
------------[ cut here ]------------
kernel BUG at fs/xfs/xfs_message.c:102!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 14612 Comm: xfs_io Not tainted 6.3.0-rc2-next-20230315-00006-g2729d23ddb3b-dirty #422
RIP: 0010:assfail+0x96/0xa0
RSP: 0018:ffffc9000fa178c0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000001 RCX: ffff888179a18000
RDX: 0000000000000000 RSI: ffff888179a18000 RDI: 0000000000000002
RBP: 0000000000000000 R08: ffffffff8321aab6 R09: 0000000000000000
R10: 0000000000000001 R11: ffffed1105f85139 R12: ffffffff8aacc4c0
R13: 0000000000000149 R14: ffff888269f58000 R15: 000000000000000c
FS:  00007f42f27a4740(0000) GS:ffff88882fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000b92388 CR3: 000000024f006000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 xfs_getbmap+0x1a5b/0x1e40
 xfs_ioc_getbmap+0x1fd/0x5b0
 xfs_file_ioctl+0x2cb/0x1d50
 __x64_sys_ioctl+0x197/0x210
 do_syscall_64+0x39/0xb0
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Above issue may happen as follows:
         ThreadA                       ThreadB
do_shared_fault
 __do_fault
  xfs_filemap_fault
   __xfs_filemap_fault
    filemap_fault
                             xfs_ioc_getbmap -> Without BMV_IF_DELALLOC flag
			      xfs_getbmap
			       xfs_ilock(ip, XFS_IOLOCK_SHARED);
			       filemap_write_and_wait
 do_page_mkwrite
  xfs_filemap_page_mkwrite
   __xfs_filemap_fault
    xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
    iomap_page_mkwrite
     ...
     xfs_buffered_write_iomap_begin
      xfs_bmapi_reserve_delalloc -> Allocate delay extent
                              xfs_ilock_data_map_shared(ip)
	                      xfs_getbmap_report_one
			       ASSERT((bmv->bmv_iflags & BMV_IF_DELALLOC) != 0)
	                        -> trigger BUG_ON

As xfs_filemap_page_mkwrite() only hold XFS_MMAPLOCK_SHARED lock, there's
small window mkwrite can produce delay extent after file write in xfs_getbmap().
To solve above issue, just skip delalloc extents.

Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_bmap_util.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -314,15 +314,13 @@ xfs_getbmap_report_one(
 	if (isnullstartblock(got->br_startblock) ||
 	    got->br_startblock == DELAYSTARTBLOCK) {
 		/*
-		 * Delalloc extents that start beyond EOF can occur due to
-		 * speculative EOF allocation when the delalloc extent is larger
-		 * than the largest freespace extent at conversion time.  These
-		 * extents cannot be converted by data writeback, so can exist
-		 * here even if we are not supposed to be finding delalloc
-		 * extents.
+		 * Take the flush completion as being a point-in-time snapshot
+		 * where there are no delalloc extents, and if any new ones
+		 * have been created racily, just skip them as being 'after'
+		 * the flush and so don't get reported.
 		 */
-		if (got->br_startoff < XFS_B_TO_FSB(ip->i_mount, XFS_ISIZE(ip)))
-			ASSERT((bmv->bmv_iflags & BMV_IF_DELALLOC) != 0);
+		if (!(bmv->bmv_iflags & BMV_IF_DELALLOC))
+			return 0;
 
 		p->bmv_oflags |= BMV_OF_DELALLOC;
 		p->bmv_block = -2;


