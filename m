Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4CD3264FE;
	Tue, 31 Mar 2026 17:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976984; cv=none; b=mijcxjC2HXc5HVXzUh0jEk2cqNJjkQBXvjODpK1wKN/RjNyF6oilseJjBJfynNaI5SekE/H+OoQlWGz6DWbnOccLprlq66prp1ouRqe9kol82UJF172HDD2s3enlTiAHHvswTJiotmKr1pje9gvrnl1DwhTXyfbOOnrEYDJay/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976984; c=relaxed/simple;
	bh=2NXcXFNL7QHHFfHfmR0NRS+1LjIpaXCuWJxdQCuG7PA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P9UDSZdrW3xndgFhrfkxITQR5WaG+Wsiz7ADbLeKn/eLQpGDaqoI6jGriVwHD87avPyokkILV+1C8FlIzJ8lskYBmaSjxsSGs0qqIyXGclSCCVt/esULZboTJPDb9qaxt9jwG/j0bIctMrAXWXVWZblyDs9t/juMPuD6bDC+8FA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y3AmDyB4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y3AmDyB4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BC5DC2BCB2;
	Tue, 31 Mar 2026 17:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976983;
	bh=2NXcXFNL7QHHFfHfmR0NRS+1LjIpaXCuWJxdQCuG7PA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y3AmDyB4qFhZH3nvbzgt4YZUnbMPUqY+aLZSSON8+tD2LjRqQVWDmwPA70q2/U/71
	 IW/mBuk4jH3VON9/fE0HtCj8mHfslwn2yyVUDiLHDUNcyzXljt42F6/zayZC41Uxzj
	 iFMaZ20XM0Z+jTIbg80YsJEig6gGFk2I5e6ebPoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 302/309] btrfs: fix leak of kobject name for sub-group space_info
Date: Tue, 31 Mar 2026 18:23:25 +0200
Message-ID: <20260331161804.682284534@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

[ Upstream commit a4376d9a5d4c9610e69def3fc0b32c86a7ab7a41 ]

When create_space_info_sub_group() allocates elements of
space_info->sub_group[], kobject_init_and_add() is called for each
element via btrfs_sysfs_add_space_info_type(). However, when
check_removing_space_info() frees these elements, it does not call
btrfs_sysfs_remove_space_info() on them. As a result, kobject_put() is
not called and the associated kobj->name objects are leaked.

This memory leak is reproduced by running the blktests test case
zbd/009 on kernels built with CONFIG_DEBUG_KMEMLEAK. The kmemleak
feature reports the following error:

unreferenced object 0xffff888112877d40 (size 16):
  comm "mount", pid 1244, jiffies 4294996972
  hex dump (first 16 bytes):
    64 61 74 61 2d 72 65 6c 6f 63 00 c4 c6 a7 cb 7f  data-reloc......
  backtrace (crc 53ffde4d):
    __kmalloc_node_track_caller_noprof+0x619/0x870
    kstrdup+0x42/0xc0
    kobject_set_name_vargs+0x44/0x110
    kobject_init_and_add+0xcf/0x150
    btrfs_sysfs_add_space_info_type+0xfc/0x210 [btrfs]
    create_space_info_sub_group.constprop.0+0xfb/0x1b0 [btrfs]
    create_space_info+0x211/0x320 [btrfs]
    btrfs_init_space_info+0x15a/0x1b0 [btrfs]
    open_ctree+0x33c7/0x4a50 [btrfs]
    btrfs_get_tree.cold+0x9f/0x1ee [btrfs]
    vfs_get_tree+0x87/0x2f0
    vfs_cmd_create+0xbd/0x280
    __do_sys_fsconfig+0x3df/0x990
    do_syscall_64+0x136/0x1540
    entry_SYSCALL_64_after_hwframe+0x76/0x7e

To avoid the leak, call btrfs_sysfs_remove_space_info() instead of
kfree() for the elements.

Fixes: f92ee31e031c ("btrfs: introduce btrfs_space_info sub-group")
Link: https://lore.kernel.org/linux-block/b9488881-f18d-4f47-91a5-3c9bf63955a5@wdc.com/
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/block-group.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 4689ef206d0ee..a277c8cc91661 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -4464,7 +4464,7 @@ static void check_removing_space_info(struct btrfs_space_info *space_info)
 		for (int i = 0; i < BTRFS_SPACE_INFO_SUB_GROUP_MAX; i++) {
 			if (space_info->sub_group[i]) {
 				check_removing_space_info(space_info->sub_group[i]);
-				kfree(space_info->sub_group[i]);
+				btrfs_sysfs_remove_space_info(space_info->sub_group[i]);
 				space_info->sub_group[i] = NULL;
 			}
 		}
-- 
2.53.0



