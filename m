Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D203D47A64;
	Mon,  1 Apr 2024 17:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990804; cv=none; b=SLRmv8/CiXMGbnmpmAapl9CXWPNxjh6ChyBKwpYxfzG56onyB1U7Wh4Vm1lZvHfc8oj/UuSW5dtA8Y/Muf02h7gbYCXYr9gR6hDKsNb2p7yC+/2kylbkoXX9eBU0CSYyRnUmXJgEIffzA0i1GdCH6ER9mchqq1eDgIwZyrp358k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990804; c=relaxed/simple;
	bh=7j2pdZ2R1I/+clyHNTa2o4MMp1JR+fWeUvEEXej+XCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ser/H3uSkEQYO0g7zM4yDEj6aFp/IlCNjIEO0MnpWl1ujYU174X10JK6WSQTdGaPPG5QgdrbdoKGeBC3foKZR0Zwq8AFIW+o0o8y16Ez07OY1Phnk7eHlDvwp9xTuPZCRLDqBvuA9sPdUMhP0Ck9GZ+FjiRTZ+Z2WbQpyavzXj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AhJsO6O9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AhJsO6O9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A059C433C7;
	Mon,  1 Apr 2024 17:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990804;
	bh=7j2pdZ2R1I/+clyHNTa2o4MMp1JR+fWeUvEEXej+XCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AhJsO6O91jS2X93RIHTPMfYDo/EdkLvfmsnjIXz2Lmw7+MDgtwK3uSpkZnPFkK8o6
	 6SPZnQ7vg77IOOS7+rWbhIWbHSx1Pxq4fIFt6xYVpcdwzjC8F9jxxADwyBQJq1uzZG
	 wTlW9n446w5aseqd0Y7X2Jb/z5sJX5FobNTURBoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabian Vogt <fvogt@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 071/272] btrfs: qgroup: always free reserved space for extent records
Date: Mon,  1 Apr 2024 17:44:21 +0200
Message-ID: <20240401152532.780887472@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit d139ded8b9cdb897bb9539eb33311daf9a177fd2 ]

[BUG]
If qgroup is marked inconsistent (e.g. caused by operations needing full
subtree rescan, like creating a snapshot and assign to a higher level
qgroup), btrfs would immediately start leaking its data reserved space.

The following script can easily reproduce it:

  mkfs.btrfs -O quota -f $dev
  mount $dev $mnt
  btrfs subvolume create $mnt/subv1
  btrfs qgroup create 1/0 $mnt

  # This snapshot creation would mark qgroup inconsistent,
  # as the ownership involves different higher level qgroup, thus
  # we have to rescan both source and snapshot, which can be very
  # time consuming, thus here btrfs just choose to mark qgroup
  # inconsistent, and let users to determine when to do the rescan.
  btrfs subv snapshot -i 1/0 $mnt/subv1 $mnt/snap1

  # Now this write would lead to qgroup rsv leak.
  xfs_io -f -c "pwrite 0 64k" $mnt/file1

  # And at unmount time, btrfs would report 64K DATA rsv space leaked.
  umount $mnt

And we would have the following dmesg output for the unmount:

  BTRFS info (device dm-1): last unmount of filesystem 14a3d84e-f47b-4f72-b053-a8a36eef74d3
  BTRFS warning (device dm-1): qgroup 0/5 has unreleased space, type 0 rsv 65536

[CAUSE]
Since commit e15e9f43c7ca ("btrfs: introduce
BTRFS_QGROUP_RUNTIME_FLAG_NO_ACCOUNTING to skip qgroup accounting"),
we introduce a mode for btrfs qgroup to skip the timing consuming
backref walk, if the qgroup is already inconsistent.

But this skip also covered the data reserved freeing, thus the qgroup
reserved space for each newly created data extent would not be freed,
thus cause the leakage.

[FIX]
Make the data extent reserved space freeing mandatory.

The qgroup reserved space handling is way cheaper compared to the
backref walking part, and we always have the super sensitive leak
detector, thus it's definitely worth to always free the qgroup
reserved data space.

Reported-by: Fabian Vogt <fvogt@suse.com>
Fixes: e15e9f43c7ca ("btrfs: introduce BTRFS_QGROUP_RUNTIME_FLAG_NO_ACCOUNTING to skip qgroup accounting")
CC: stable@vger.kernel.org # 6.1+
Link: https://bugzilla.suse.com/show_bug.cgi?id=1216196
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/qgroup.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index b3472bf6b288f..c14d4f70e84bd 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2800,11 +2800,6 @@ int btrfs_qgroup_account_extents(struct btrfs_trans_handle *trans)
 					goto cleanup;
 			}
 
-			/* Free the reserved data space */
-			btrfs_qgroup_free_refroot(fs_info,
-					record->data_rsv_refroot,
-					record->data_rsv,
-					BTRFS_QGROUP_RSV_DATA);
 			/*
 			 * Use BTRFS_SEQ_LAST as time_seq to do special search,
 			 * which doesn't lock tree or delayed_refs and search
@@ -2826,6 +2821,11 @@ int btrfs_qgroup_account_extents(struct btrfs_trans_handle *trans)
 			record->old_roots = NULL;
 			new_roots = NULL;
 		}
+		/* Free the reserved data space */
+		btrfs_qgroup_free_refroot(fs_info,
+				record->data_rsv_refroot,
+				record->data_rsv,
+				BTRFS_QGROUP_RSV_DATA);
 cleanup:
 		ulist_free(record->old_roots);
 		ulist_free(new_roots);
-- 
2.43.0



