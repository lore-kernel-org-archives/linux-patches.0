Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E77C61FFE;
	Tue, 12 Aug 2025 18:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023202; cv=none; b=eTNDjVFjf/FtAD854TFzCE5Moe3R4xO7GHIP9LJsZNb7Q6UVt0tmgU7KyA/xcRLKrUnCoY+lkPVgfUV79GOv3FvKLhKEgK40PSrq9/av2tmQbhGCLBgSopALfLQm+ZW5RNaPy+T2yFymYrBmHc0GRUjWQGe5WB7+hdpmXNNvvMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023202; c=relaxed/simple;
	bh=97bAZiUdVvzMEfrFqunKEFeDVotUXlTjYACziFB3UCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=osl7RT/ccmPFLHvMMDxlb5/p+53fTcXd2RMTQAYf7ep/8LkfCw4jKEIYxy+t/z5CbYccwsBCs1xLEoZzFmM8DQ2At5ah+5bE1d2geqfJ6dJDW7G/RIT0pVOjOO/X9q+Qb0PJ9ms0XfWsbIdWfCnLu2EhmoGn+jqMJzT8q1AgX8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X90Kgy3R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X90Kgy3R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCD6BC4CEF0;
	Tue, 12 Aug 2025 18:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023202;
	bh=97bAZiUdVvzMEfrFqunKEFeDVotUXlTjYACziFB3UCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X90Kgy3Rsfaq0TjWTHShB9bC6umPLT1nJJaqAan/ehhlLSiEF7/onHLXBSOX0skFj
	 EQkbRT6fJgKiaAq4LzE5B09pTuUSibriVLvC6+e0e45wLz1AEVJBY0zmKhUwOg5B6f
	 0iR/Lv0ctqDUsIDlfpVj78PGG67xUAOjqSpXDI+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8c0bc9f818702ff75b76@syzkaller.appspotmail.com,
	Yangtao Li <frank.li@vivo.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 011/627] hfsplus: remove mutex_lock check in hfsplus_free_extents
Date: Tue, 12 Aug 2025 19:25:06 +0200
Message-ID: <20250812173419.752824918@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yangtao Li <frank.li@vivo.com>

[ Upstream commit fcb96956c921f1aae7e7b477f2435c56f77a31b4 ]

Syzbot reported an issue in hfsplus filesystem:

------------[ cut here ]------------
WARNING: CPU: 0 PID: 4400 at fs/hfsplus/extents.c:346
	hfsplus_free_extents+0x700/0xad0
Call Trace:
<TASK>
hfsplus_file_truncate+0x768/0xbb0 fs/hfsplus/extents.c:606
hfsplus_write_begin+0xc2/0xd0 fs/hfsplus/inode.c:56
cont_expand_zero fs/buffer.c:2383 [inline]
cont_write_begin+0x2cf/0x860 fs/buffer.c:2446
hfsplus_write_begin+0x86/0xd0 fs/hfsplus/inode.c:52
generic_cont_expand_simple+0x151/0x250 fs/buffer.c:2347
hfsplus_setattr+0x168/0x280 fs/hfsplus/inode.c:263
notify_change+0xe38/0x10f0 fs/attr.c:420
do_truncate+0x1fb/0x2e0 fs/open.c:65
do_sys_ftruncate+0x2eb/0x380 fs/open.c:193
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd

To avoid deadlock, Commit 31651c607151 ("hfsplus: avoid deadlock
on file truncation") unlock extree before hfsplus_free_extents(),
and add check wheather extree is locked in hfsplus_free_extents().

However, when operations such as hfsplus_file_release,
hfsplus_setattr, hfsplus_unlink, and hfsplus_get_block are executed
concurrently in different files, it is very likely to trigger the
WARN_ON, which will lead syzbot and xfstest to consider it as an
abnormality.

The comment above this warning also describes one of the easy
triggering situations, which can easily trigger and cause
xfstest&syzbot to report errors.

[task A]			[task B]
->hfsplus_file_release
  ->hfsplus_file_truncate
    ->hfs_find_init
      ->mutex_lock
    ->mutex_unlock
				->hfsplus_write_begin
				  ->hfsplus_get_block
				    ->hfsplus_file_extend
				      ->hfsplus_ext_read_extent
				        ->hfs_find_init
					  ->mutex_lock
    ->hfsplus_free_extents
      WARN_ON(mutex_is_locked) !!!

Several threads could try to lock the shared extents tree.
And warning can be triggered in one thread when another thread
has locked the tree. This is the wrong behavior of the code and
we need to remove the warning.

Fixes: 31651c607151f ("hfsplus: avoid deadlock on file truncation")
Reported-by: syzbot+8c0bc9f818702ff75b76@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/00000000000057fa4605ef101c4c@google.com/
Signed-off-by: Yangtao Li <frank.li@vivo.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Link: https://lore.kernel.org/r/20250529061807.2213498-1-frank.li@vivo.com
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hfsplus/extents.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/hfsplus/extents.c b/fs/hfsplus/extents.c
index a6d61685ae79..b1699b3c246a 100644
--- a/fs/hfsplus/extents.c
+++ b/fs/hfsplus/extents.c
@@ -342,9 +342,6 @@ static int hfsplus_free_extents(struct super_block *sb,
 	int i;
 	int err = 0;
 
-	/* Mapping the allocation file may lock the extent tree */
-	WARN_ON(mutex_is_locked(&HFSPLUS_SB(sb)->ext_tree->tree_lock));
-
 	hfsplus_dump_extent(extent);
 	for (i = 0; i < 8; extent++, i++) {
 		count = be32_to_cpu(extent->block_count);
-- 
2.39.5



