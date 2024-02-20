Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A0514A4E6;
	Tue, 20 Feb 2024 21:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464390; cv=none; b=GESfLEyw20g1pJ7F62v6gcRLf/hfXG8Fe9RKQW1BwmQsr/Po+oz9a3L0/3mLpx1F9LT9SlWzg7KazKgsZ074l5ZeOWdaf7TmUzPWehYvX5EueX5gOtCfzhVXBOboeb1GIF/4LF45AHJF58TKhOmc9Gs3EcDuLraWaob7RLAykzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464390; c=relaxed/simple;
	bh=MDkRv3hydYMdvMogZ6of5bd9/JYi8D+TlIWiHjbof+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cWXeMxXHSwBgmliv/yx38ns3tONuyuz4kDZvSmvFe3MQdbYZ8JaLCM/b4krn0LKvnVm44u4GGM0Pvd3d9wol5ijY1uC7+xDw1OTZgl5aU+uzSzfxpBOhRqsPlteDMPqPI5pOcDbX9LDOI/r9jx8goWyQMvnuex0DEAPFntzH148=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P0fzn4/8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P0fzn4/8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CF0DC433C7;
	Tue, 20 Feb 2024 21:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464389;
	bh=MDkRv3hydYMdvMogZ6of5bd9/JYi8D+TlIWiHjbof+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P0fzn4/8BRbgIrqyFabyN7tNoWuvs63vX3n6FZK9vcmCsQFJhBrIuThT5NSOvE8uk
	 YZYxZSrdXXuVZIhSds1xVxBoFaAZgm9sGJqLmxGEgRcH0jGVoo6qwtbnfxMVDOvmjA
	 8ZtPxZ47/RAEcCHDIorQwcG2k+cPJSkHKCSKHTIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.7 010/309] btrfs: do not ASSERT() if the newly created subvolume already got read
Date: Tue, 20 Feb 2024 21:52:49 +0100
Message-ID: <20240220205633.456789730@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

commit e03ee2fe873eb68c1f9ba5112fee70303ebf9dfb upstream.

[BUG]
There is a syzbot crash, triggered by the ASSERT() during subvolume
creation:

 assertion failed: !anon_dev, in fs/btrfs/disk-io.c:1319
 ------------[ cut here ]------------
 kernel BUG at fs/btrfs/disk-io.c:1319!
 invalid opcode: 0000 [#1] PREEMPT SMP KASAN
 RIP: 0010:btrfs_get_root_ref.part.0+0x9aa/0xa60
  <TASK>
  btrfs_get_new_fs_root+0xd3/0xf0
  create_subvol+0xd02/0x1650
  btrfs_mksubvol+0xe95/0x12b0
  __btrfs_ioctl_snap_create+0x2f9/0x4f0
  btrfs_ioctl_snap_create+0x16b/0x200
  btrfs_ioctl+0x35f0/0x5cf0
  __x64_sys_ioctl+0x19d/0x210
  do_syscall_64+0x3f/0xe0
  entry_SYSCALL_64_after_hwframe+0x63/0x6b
 ---[ end trace 0000000000000000 ]---

[CAUSE]
During create_subvol(), after inserting root item for the newly created
subvolume, we would trigger btrfs_get_new_fs_root() to get the
btrfs_root of that subvolume.

The idea here is, we have preallocated an anonymous device number for
the subvolume, thus we can assign it to the new subvolume.

But there is really nothing preventing things like backref walk to read
the new subvolume.
If that happens before we call btrfs_get_new_fs_root(), the subvolume
would be read out, with a new anonymous device number assigned already.

In that case, we would trigger ASSERT(), as we really expect no one to
read out that subvolume (which is not yet accessible from the fs).
But things like backref walk is still possible to trigger the read on
the subvolume.

Thus our assumption on the ASSERT() is not correct in the first place.

[FIX]
Fix it by removing the ASSERT(), and just free the @anon_dev, reset it
to 0, and continue.

If the subvolume tree is read out by something else, it should have
already get a new anon_dev assigned thus we only need to free the
preallocated one.

Reported-by: Chenyuan Yang <chenyuan0y@gmail.com>
Fixes: 2dfb1e43f57d ("btrfs: preallocate anon block device at first phase of snapshot creation")
CC: stable@vger.kernel.org # 5.15+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/disk-io.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1315,8 +1315,17 @@ static struct btrfs_root *btrfs_get_root
 again:
 	root = btrfs_lookup_fs_root(fs_info, objectid);
 	if (root) {
-		/* Shouldn't get preallocated anon_dev for cached roots */
-		ASSERT(!anon_dev);
+		/*
+		 * Some other caller may have read out the newly inserted
+		 * subvolume already (for things like backref walk etc).  Not
+		 * that common but still possible.  In that case, we just need
+		 * to free the anon_dev.
+		 */
+		if (unlikely(anon_dev)) {
+			free_anon_bdev(anon_dev);
+			anon_dev = 0;
+		}
+
 		if (check_ref && btrfs_root_refs(&root->root_item) == 0) {
 			btrfs_put_root(root);
 			return ERR_PTR(-ENOENT);


