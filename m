Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D9080603;
	Wed, 21 Feb 2024 14:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524674; cv=none; b=uXsLN+alt60MKo0hmN+lDgDAcQBi4Uz3vFaCdDhjMPT8eNy4xEbQnYzw8DdVFpA4tzvycC92CLm4faVNYf0QEhjAkWqoIkZW1/VrYPlCadyIOk7vdeSCl0QcH5w1yqEcTl/Tu47VVq4zT2La0CjFJFMmy+fqf5GqDJEha0vtHa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524674; c=relaxed/simple;
	bh=Fm58CDfWF20/Xfd4WrQsSMo7gQKpdRicjkFYYJk3aEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MQ+zE8UDWt0q66gD1vErC7n7Iolbu7CpE8K8Kb1XzpqPgP+qtmI3Hn11hRh2e9C5msHhWGEpMyBJFge5j5pGP04BE9Ho9LNagySqKwVbl8ccwJU8oyRlIAVUJ2enuFNeoS5zdabjyLXZxLjLHN/JE+LI8A9LgvCGaqWCBXPjgJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MVqXPVww; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MVqXPVww"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F62C433F1;
	Wed, 21 Feb 2024 14:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524674;
	bh=Fm58CDfWF20/Xfd4WrQsSMo7gQKpdRicjkFYYJk3aEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MVqXPVwwS3ywbgmD0mJrbaWYuPt5aKQ06iYeeNcrKP0B0GISLnxJoEnC8A7mm2Se6
	 +cq6IM5U83aDJB7ETcognh2dZBtxRLOvUYcr3yCnZiiaieoR8noq/91kwWXr+X/Ow6
	 DIKzitw92jzPkygOiT2Hbj+fjFhB+mnTWZcdzM4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 287/379] btrfs: do not ASSERT() if the newly created subvolume already got read
Date: Wed, 21 Feb 2024 14:07:46 +0100
Message-ID: <20240221130003.399065444@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1553,8 +1553,17 @@ static struct btrfs_root *btrfs_get_root
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


