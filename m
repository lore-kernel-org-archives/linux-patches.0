Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D48158A11;
	Tue,  9 Jul 2024 11:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524208; cv=none; b=SPpTC4X8OLem7dWT3wYETmY1W6rzpn3bXZb67MuPj2A1btt4+Pz6I/AdX8GcGzFA+A0bAwFAgIkgas5H/ShbsbigZMWVNg8ty0hzdr7szEKNeQnJELR6VUel9t7+UMqNpq7hAdEpuXqsOmUssdsr9z3rpq72He/fiePUG9dzHKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524208; c=relaxed/simple;
	bh=rUunRGt5YvKkxTUNkDzOLXhwCBhuJd1aR1XLDpFnGmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GTimUO801Fh9409ojQAXDs/DxN7bCmsqtz2QoCPE675zWrZSCuPq2frsWH1+iAFaKN9FfKa9iskdcdHs5E77EIjYUCoyDjkEuNiIN7p+ZJr1cJVFN0HxMbgjFBN4OqQqtfc20HpykL+59cKpQ03spXPT653YnSL5kKlc5p5WZsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zC78kIhI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zC78kIhI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CE91C32786;
	Tue,  9 Jul 2024 11:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524207;
	bh=rUunRGt5YvKkxTUNkDzOLXhwCBhuJd1aR1XLDpFnGmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zC78kIhIWE3y2XWbPyjcz7p8HHq/exz6tR+lC52m1QQ6R4ZiYJBEy/WzsgWuPTzSg
	 Pqv57i6TpHlgLZRVBumFJTIl1RiVTIrYPTalaQZ1lKY34ToqIy+qZOSU21Rt4yKAKs
	 uu4NzO5SijsQcJWTOa+FJ+V8BheNAfKTranS8LA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a0d1f7e26910be4dc171@syzkaller.appspotmail.com,
	Boris Burkov <boris@bur.io>,
	Jeongjun Park <aha310510@gmail.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 107/197] btrfs: always do the basic checks for btrfs_qgroup_inherit structure
Date: Tue,  9 Jul 2024 13:09:21 +0200
Message-ID: <20240709110713.099503296@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 724d8042cef84496ddb4492dc120291f997ae26b ]

[BUG]
Syzbot reports the following regression detected by KASAN:

  BUG: KASAN: slab-out-of-bounds in btrfs_qgroup_inherit+0x42e/0x2e20 fs/btrfs/qgroup.c:3277
  Read of size 8 at addr ffff88814628ca50 by task syz-executor318/5171

  CPU: 0 PID: 5171 Comm: syz-executor318 Not tainted 6.10.0-rc2-syzkaller-00010-g2ab795141095 #0
  Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/02/2024
  Call Trace:
   <TASK>
   __dump_stack lib/dump_stack.c:88 [inline]
   dump_stack_lvl+0x241/0x360 lib/dump_stack.c:114
   print_address_description mm/kasan/report.c:377 [inline]
   print_report+0x169/0x550 mm/kasan/report.c:488
   kasan_report+0x143/0x180 mm/kasan/report.c:601
   btrfs_qgroup_inherit+0x42e/0x2e20 fs/btrfs/qgroup.c:3277
   create_pending_snapshot+0x1359/0x29b0 fs/btrfs/transaction.c:1854
   create_pending_snapshots+0x195/0x1d0 fs/btrfs/transaction.c:1922
   btrfs_commit_transaction+0xf20/0x3740 fs/btrfs/transaction.c:2382
   create_snapshot+0x6a1/0x9e0 fs/btrfs/ioctl.c:875
   btrfs_mksubvol+0x58f/0x710 fs/btrfs/ioctl.c:1029
   btrfs_mksnapshot+0xb5/0xf0 fs/btrfs/ioctl.c:1075
   __btrfs_ioctl_snap_create+0x387/0x4b0 fs/btrfs/ioctl.c:1340
   btrfs_ioctl_snap_create_v2+0x1f2/0x3a0 fs/btrfs/ioctl.c:1422
   btrfs_ioctl+0x99e/0xc60
   vfs_ioctl fs/ioctl.c:51 [inline]
   __do_sys_ioctl fs/ioctl.c:907 [inline]
   __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:893
   do_syscall_x64 arch/x86/entry/common.c:52 [inline]
   do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
  RIP: 0033:0x7fcbf1992509
  RSP: 002b:00007fcbf1928218 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
  RAX: ffffffffffffffda RBX: 00007fcbf1a1f618 RCX: 00007fcbf1992509
  RDX: 0000000020000280 RSI: 0000000050009417 RDI: 0000000000000003
  RBP: 00007fcbf1a1f610 R08: 00007ffea1298e97 R09: 0000000000000000
  R10: 0000000000000000 R11: 0000000000000246 R12: 00007fcbf19eb660
  R13: 00000000200002b8 R14: 00007fcbf19e60c0 R15: 0030656c69662f2e
   </TASK>

And it also pinned it down to commit b5357cb268c4 ("btrfs: qgroup: do not
check qgroup inherit if qgroup is disabled").

[CAUSE]
That offending commit skips the whole qgroup inherit check if qgroup is
not enabled.

But that also skips the very basic checks like
num_ref_copies/num_excl_copies and the structure size checks.

Meaning if a qgroup enable/disable race is happening at the background,
and we pass a btrfs_qgroup_inherit structure when the qgroup is
disabled, the check would be completely skipped.

Then at the time of transaction commitment, qgroup is re-enabled and
btrfs_qgroup_inherit() is going to use the incorrect structure and
causing the above KASAN error.

[FIX]
Make btrfs_qgroup_check_inherit() only skip the source qgroup checks.
So that even if invalid btrfs_qgroup_inherit structure is passed in, we
can still reject invalid ones no matter if qgroup is enabled or not.

Furthermore we do already have an extra safety inside
btrfs_qgroup_inherit(), which would just ignore invalid qgroup sources,
so even if we only skip the qgroup source check we're still safe.

Reported-by: syzbot+a0d1f7e26910be4dc171@syzkaller.appspotmail.com
Fixes: b5357cb268c4 ("btrfs: qgroup: do not check qgroup inherit if qgroup is disabled")
Reviewed-by: Boris Burkov <boris@bur.io>
Reviewed-by: Jeongjun Park <aha310510@gmail.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/qgroup.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 1167899a16d05..4caa078d972a3 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3065,8 +3065,6 @@ int btrfs_qgroup_check_inherit(struct btrfs_fs_info *fs_info,
 			       struct btrfs_qgroup_inherit *inherit,
 			       size_t size)
 {
-	if (!btrfs_qgroup_enabled(fs_info))
-		return 0;
 	if (inherit->flags & ~BTRFS_QGROUP_INHERIT_FLAGS_SUPP)
 		return -EOPNOTSUPP;
 	if (size < sizeof(*inherit) || size > PAGE_SIZE)
@@ -3090,6 +3088,14 @@ int btrfs_qgroup_check_inherit(struct btrfs_fs_info *fs_info,
 	if (size != struct_size(inherit, qgroups, inherit->num_qgroups))
 		return -EINVAL;
 
+	/*
+	 * Skip the inherit source qgroups check if qgroup is not enabled.
+	 * Qgroup can still be later enabled causing problems, but in that case
+	 * btrfs_qgroup_inherit() would just ignore those invalid ones.
+	 */
+	if (!btrfs_qgroup_enabled(fs_info))
+		return 0;
+
 	/*
 	 * Now check all the remaining qgroups, they should all:
 	 *
-- 
2.43.0



