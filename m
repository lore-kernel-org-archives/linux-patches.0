Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 256C42E7BD6;
	Thu,  3 Jul 2025 14:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554277; cv=none; b=a51rc2A0HZuRJOD4N89LLxz6fVtnmE3ohUggdTt+RZJEhggVrdg6heQhUbXO7slRS+NZXUGs9lpIYO/Iy8zk3aFRqz4eCQ6FbSk+Nih+h2GslUoYdZNZnUlZpRwIZLJG+Eclu0EE2XjZZjLIsKPsd97D6QKslnl8HinWqPI6XZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554277; c=relaxed/simple;
	bh=OKIAeMx2J7Xd2baLxCwbAKylEffI8dbTTeU6e2sPd7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kz+U5ODxiPwOn1yexrhmH7CvNNw/+QaAcr2bhbHT3bQhJa7TgXLD3eNtEM5kttL9E14mKqIm2VAgoDuz3xa4LBwWxujeaRlEPugyjV5hdAOcjWfvp5G9znQuW4poRPfuw+Gu1kD18JFKDM4m8T7fDmqgNXHAzNTWoaEBup69P0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yX3hOjxm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yX3hOjxm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84566C4CEE3;
	Thu,  3 Jul 2025 14:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554276;
	bh=OKIAeMx2J7Xd2baLxCwbAKylEffI8dbTTeU6e2sPd7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yX3hOjxm5OsVlNsV+pnZexGKuhMO7lAb6UTaPCXQcorhgD06Gg1MUTCe7/qWxQxJd
	 a6161N+BWXx9AqGM8TQu6+TxDa+E6ZsrBkWrShWIfmEezLzvsXrwJVzv9fd6kkMnsa
	 +fO3Y9PPUqjpG1fkRwvLCCXYCRTGFfI7LBmY79Ug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Mark Harmstone <maharmstone@fb.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.12 136/218] btrfs: update superblocks device bytes_used when dropping chunk
Date: Thu,  3 Jul 2025 16:41:24 +0200
Message-ID: <20250703144001.554159445@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

From: Mark Harmstone <maharmstone@fb.com>

commit ae4477f937569d097ca5dbce92a89ba384b49bc6 upstream.

Each superblock contains a copy of the device item for that device. In a
transaction which drops a chunk but doesn't create any new ones, we were
correctly updating the device item in the chunk tree but not copying
over the new bytes_used value to the superblock.

This can be seen by doing the following:

  # dd if=/dev/zero of=test bs=4096 count=2621440
  # mkfs.btrfs test
  # mount test /root/temp

  # cd /root/temp
  # for i in {00..10}; do dd if=/dev/zero of=$i bs=4096 count=32768; done
  # sync
  # rm *
  # sync
  # btrfs balance start -dusage=0 .
  # sync

  # cd
  # umount /root/temp
  # btrfs check test

For btrfs-check to detect this, you will also need my patch at
https://github.com/kdave/btrfs-progs/pull/991.

Change btrfs_remove_dev_extents() so that it adds the devices to the
fs_info->post_commit_list if they're not there already. This causes
btrfs_commit_device_sizes() to be called, which updates the bytes_used
value in the superblock.

Fixes: bbbf7243d62d ("btrfs: combine device update operations during transaction commit")
CC: stable@vger.kernel.org # 5.10+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Mark Harmstone <maharmstone@fb.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/volumes.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3268,6 +3268,12 @@ int btrfs_remove_chunk(struct btrfs_tran
 					device->bytes_used - dev_extent_len);
 			atomic64_add(dev_extent_len, &fs_info->free_chunk_space);
 			btrfs_clear_space_info_full(fs_info);
+
+			if (list_empty(&device->post_commit_list)) {
+				list_add_tail(&device->post_commit_list,
+					      &trans->transaction->dev_update_list);
+			}
+
 			mutex_unlock(&fs_info->chunk_mutex);
 		}
 	}


