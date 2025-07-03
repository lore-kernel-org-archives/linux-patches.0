Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF9CEEBA;
	Thu,  3 Jul 2025 15:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751556263; cv=none; b=V6iW1mYRAdosu0x5m7JD3Z5toD1C/jZHYxWEsBR1/7dNwu8u/V76kXRLM4RyisO7cDTmuU7bWNUgcMADMoqNXA7xBOQ8viBlGRlv/NnzdZSEecPy2t68un9spmWZZkXLuUriswo9dL4eU4lnrWXOhSohLP3kKgLvb3g5pCd5bhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751556263; c=relaxed/simple;
	bh=gXgO5CO9fi0cWIm5ml1bgsovFuf1WLgKWZuwnOi+bc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ht7SrVPYByhl1QXgBKskmmqslTcgI2G4QGuKw+FRGznwx/grwNcq3wYxdVxhjhNuTDP2qx/1yV40AnCke31KprECTnbekDiWIc1jZNe+wLsVgkWeZLTHcZ+6+LKTE8ZxZGxRaypekl9a+jzmjmaMpkZ8iHH0Bs70cdqvex1ex6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CecCLDJf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CecCLDJf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07577C4CEE3;
	Thu,  3 Jul 2025 15:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751556263;
	bh=gXgO5CO9fi0cWIm5ml1bgsovFuf1WLgKWZuwnOi+bc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CecCLDJfDfC9ITuQd5ppvk16hclg6X1EAGst/d8VZJInD6eTXv4drn0oC85uZB4vz
	 30Dxbs9soXVUuRH61tPm3/bhYY0kW+HgmNWHhll5IHb/xRfn4wmaYnUwJo28vQj/1Z
	 dIq5rzl/P098pVfAr1cqNS3r3VWquS54ZVnMjf1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Mark Harmstone <maharmstone@fb.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 096/132] btrfs: update superblocks device bytes_used when dropping chunk
Date: Thu,  3 Jul 2025 16:43:05 +0200
Message-ID: <20250703143943.167655970@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3203,6 +3203,12 @@ int btrfs_remove_chunk(struct btrfs_tran
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


