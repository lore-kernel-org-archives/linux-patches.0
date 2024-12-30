Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2AD15E8B;
	Mon, 30 Dec 2024 15:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574330; cv=none; b=D1f445TRZ4nHtAk+LHu4WApVaY24qVpfQWzk3Cg7B3Y49zV0vGi4KAZ2VkljqPdXFsRh7ASz2TqWtfTlgSmvSkw+FLHcGJNPitH4yfflMHe+nxosy89zes/OTBgGg37t4w2gtFxnR/e6mZAXkPZbbW9xL0WIqONDWT7gvfF8qKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574330; c=relaxed/simple;
	bh=ybHqSu1Hb12Hr2Pa5uoccPSL4x/zSGlHweRSgQdN/0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jBak2RU++MKkZ1phCD8gA/ssqqkE2liNROI7SFFkzg08aZ/nwlEDNLdMpGn3j1vZarzFMzVWbrk5uFBTvkFoeESCLMHGZGFRrjwtie5nD/ldJNO4aAk4yCz1IoUgrrrXeqpFikUUdLvMG+xJQLIY3LEDpKssCu5LHpxUDdGbRNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jnLTbrpp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jnLTbrpp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B5DC4CED0;
	Mon, 30 Dec 2024 15:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574329;
	bh=ybHqSu1Hb12Hr2Pa5uoccPSL4x/zSGlHweRSgQdN/0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jnLTbrppmYqh8DhWIQXgiq+4mXuBAQYgIozOrc0pjOGA8KvlvXPjSlGImmtacWuCj
	 628QzkBfZQncOvZEMjuNkuznsej2rFEMAagcKjuHo8YSY523NNE+bE1HuVxuDdH3UV
	 RFWMm8WVzYFq+1LeI4HJl9UDRhKwVu1pzKdpDtHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Julian Sun <sunjunchao2870@gmail.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.12 104/114] btrfs: fix transaction atomicity bug when enabling simple quotas
Date: Mon, 30 Dec 2024 16:43:41 +0100
Message-ID: <20241230154222.126113339@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Sun <sunjunchao2870@gmail.com>

commit f2363e6fcc7938c5f0f6ac066fad0dd247598b51 upstream.

Set squota incompat bit before committing the transaction that enables
the feature.

With the config CONFIG_BTRFS_ASSERT enabled, an assertion
failure occurs regarding the simple quota feature.

  [5.596534] assertion failed: btrfs_fs_incompat(fs_info, SIMPLE_QUOTA), in fs/btrfs/qgroup.c:365
  [5.597098] ------------[ cut here ]------------
  [5.597371] kernel BUG at fs/btrfs/qgroup.c:365!
  [5.597946] CPU: 1 UID: 0 PID: 268 Comm: mount Not tainted 6.13.0-rc2-00031-gf92f4749861b #146
  [5.598450] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
  [5.599008] RIP: 0010:btrfs_read_qgroup_config+0x74d/0x7a0
  [5.604303]  <TASK>
  [5.605230]  ? btrfs_read_qgroup_config+0x74d/0x7a0
  [5.605538]  ? exc_invalid_op+0x56/0x70
  [5.605775]  ? btrfs_read_qgroup_config+0x74d/0x7a0
  [5.606066]  ? asm_exc_invalid_op+0x1f/0x30
  [5.606441]  ? btrfs_read_qgroup_config+0x74d/0x7a0
  [5.606741]  ? btrfs_read_qgroup_config+0x74d/0x7a0
  [5.607038]  ? try_to_wake_up+0x317/0x760
  [5.607286]  open_ctree+0xd9c/0x1710
  [5.607509]  btrfs_get_tree+0x58a/0x7e0
  [5.608002]  vfs_get_tree+0x2e/0x100
  [5.608224]  fc_mount+0x16/0x60
  [5.608420]  btrfs_get_tree+0x2f8/0x7e0
  [5.608897]  vfs_get_tree+0x2e/0x100
  [5.609121]  path_mount+0x4c8/0xbc0
  [5.609538]  __x64_sys_mount+0x10d/0x150

The issue can be easily reproduced using the following reproducer:

  root@q:linux# cat repro.sh
  set -e

  mkfs.btrfs -q -f /dev/sdb
  mount /dev/sdb /mnt/btrfs
  btrfs quota enable -s /mnt/btrfs
  umount /mnt/btrfs
  mount /dev/sdb /mnt/btrfs

The issue is that when enabling quotas, at btrfs_quota_enable(), we set
BTRFS_QGROUP_STATUS_FLAG_SIMPLE_MODE at fs_info->qgroup_flags and persist
it in the quota root in the item with the key BTRFS_QGROUP_STATUS_KEY, but
we only set the incompat bit BTRFS_FEATURE_INCOMPAT_SIMPLE_QUOTA after we
commit the transaction used to enable simple quotas.

This means that if after that transaction commit we unmount the filesystem
without starting and committing any other transaction, or we have a power
failure, the next time we mount the filesystem we will find the flag
BTRFS_QGROUP_STATUS_FLAG_SIMPLE_MODE set in the item with the key
BTRFS_QGROUP_STATUS_KEY but we will not find the incompat bit
BTRFS_FEATURE_INCOMPAT_SIMPLE_QUOTA set in the superblock, triggering an
assertion failure at:

  btrfs_read_qgroup_config() -> qgroup_read_enable_gen()

To fix this issue, set the BTRFS_FEATURE_INCOMPAT_SIMPLE_QUOTA flag
immediately after setting the BTRFS_QGROUP_STATUS_FLAG_SIMPLE_MODE.
This ensures that both flags are flushed to disk within the same
transaction.

Fixes: 182940f4f4db ("btrfs: qgroup: add new quota mode for simple quotas")
CC: stable@vger.kernel.org # 6.6+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/qgroup.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1122,6 +1122,7 @@ int btrfs_quota_enable(struct btrfs_fs_i
 	fs_info->qgroup_flags = BTRFS_QGROUP_STATUS_FLAG_ON;
 	if (simple) {
 		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_SIMPLE_MODE;
+		btrfs_set_fs_incompat(fs_info, SIMPLE_QUOTA);
 		btrfs_set_qgroup_status_enable_gen(leaf, ptr, trans->transid);
 	} else {
 		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
@@ -1255,8 +1256,6 @@ out_add_root:
 	spin_lock(&fs_info->qgroup_lock);
 	fs_info->quota_root = quota_root;
 	set_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags);
-	if (simple)
-		btrfs_set_fs_incompat(fs_info, SIMPLE_QUOTA);
 	spin_unlock(&fs_info->qgroup_lock);
 
 	/* Skip rescan for simple qgroups. */


