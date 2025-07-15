Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B702EB5A2;
	Tue, 15 Jul 2025 13:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587567; cv=none; b=Fky2vxYnPy9Vwyvnt54v1P9an1r3jW80PLpUwtYZq6rV92dQ5NfkSeeEDC9iQyJ50+m3f8n0SO8gLVlpmPnR+xPwzHYJj+vw/mzSEOr9QPIOOSfuzRwSsJlTJrdy7duJJmG3Co4i5457YQIAfGbdCYva1h0qpBJ1HRhPS74/1Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587567; c=relaxed/simple;
	bh=Wycrv70JUobkUpHmn8Fv0xuD8hmqmUfppIBuDjCGoBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GJ2zTiLUvjgYdYcULLyeiCMFTIeI7Cu0h2n5cjcUVCRrcpA3Nur86R97lxL/9kk/dWM5idCC3PArd2MHDwKhuPAt/5vwrri19V6oVRuFfKlWvcoLHzd8DludgUcaU2sftOUA9YX3ksPv8aGtPJy+2aULAXci8NhoZyFme4VRWRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Nj/bjNz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Nj/bjNz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D597C4CEE3;
	Tue, 15 Jul 2025 13:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587567;
	bh=Wycrv70JUobkUpHmn8Fv0xuD8hmqmUfppIBuDjCGoBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Nj/bjNzxg2JyX/5P74GAqMe3kFpxGZQJeXhM6E5w6nJPN013DPBD2aHdeBxxLALG
	 De7yvj5OCT9wYaUPfcSLJvHJmMo/RXXzO1ubsYL3n01a5siQPBNel4+NOmYi5MNBPB
	 mumyZQi2ciYgMee+zrs46aS1Oqbfp4lj3sqDirx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Mark Harmstone <maharmstone@fb.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 059/208] btrfs: update superblocks device bytes_used when dropping chunk
Date: Tue, 15 Jul 2025 15:12:48 +0200
Message-ID: <20250715130813.313373977@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3101,6 +3101,12 @@ int btrfs_remove_chunk(struct btrfs_tran
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
 


