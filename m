Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D80A6361648
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300919; cv=none; b=EsfM32+rcbcA+N2bp6nPK+/ePEJ/dTXihRjCLqjwsIdcPorEmZGVAN5+LFY2XV8UDQ+IFdLouPEFAW9ymeaoLsH7Ebnk4rEOsuqe/+sU/5JatJ8DsenO4r/oAhbBDgKDOZ8anzpfXxT07XV1RpRsbN9AIqtkJXij+uaYZxxI2QE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300919; c=relaxed/simple;
	bh=ODzQ1JyARHrdyC5UA0mwYJsbZhzq5UtDcEMzzNfcUgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pBCODQqDe08ndw1OnXh4Fp+P7jZqQuVzCSusupt89kuENv4dDfv88SGRBHjuz55A8+3rLdDviTi6N+/KdYcvJTzzgkAJzYuynl+1zvQXdDGC4oxZNj3Se+fOZt+8mUX3uhXsc5EN15kFaqTwPUs5RR15IZCjkvC+oMNl6ZEEmCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HBI5pUD0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HBI5pUD0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45E58C19423;
	Sat, 28 Feb 2026 17:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300919;
	bh=ODzQ1JyARHrdyC5UA0mwYJsbZhzq5UtDcEMzzNfcUgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HBI5pUD0mmNXdYTHsWXGM+ht1XfMOn1iyrrDTeXyChOZvash7OFVaqkrimZrHAxQ8
	 vyBMVb/gHItmAGCbV4W4Dx9BTesBztAjHYi+RO/nZNeTYLs3KSV+Ezi7Bdk+Fjk8tp
	 +jLsvEVcHuBaAs76tXXEQ65dglosOw3IxrMhIZyenBV+SfwBEy/NcC/XOq6twsg5rB
	 uh+nmYiBOJ3bHPsNTdCZmQBv8P5GMV+HfnhEOwzV2UvVK8pAe0BEmxjEZWFSpK9BKN
	 /HmUvBdrQIvy5PFfxF5gtJbuVGZG7CLtoT6UwDjCOgsGQmFyBOzvbVz2ZiqzSRLDmG
	 2ekoVNaCAYWAA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 036/752] btrfs: fallback to buffered IO if the data profile has duplication
Date: Sat, 28 Feb 2026 12:35:47 -0500
Message-ID: <20260228174750.1542406-36-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 7c2830f00c3e086292c1ee9f27b61efaf8e76c9a ]

[BACKGROUND]
Inspired by a recent kernel bug report, which is related to direct IO
buffer modification during writeback, that leads to contents mismatch of
different RAID1 mirrors.

[CAUSE AND PROBLEMS]
The root cause is exactly the same explained in commit 968f19c5b1b7
("btrfs: always fallback to buffered write if the inode requires
checksum"), that we can not trust direct IO buffer which can be modified
halfway during writeback.

Unlike data checksum verification, if this happened on inodes without
data checksum but has the data has extra mirrors, it will lead to
stealth data mismatch on different mirrors.

This will be way harder to detect without data checksum.

Furthermore for RAID56, we can even have data without checksum and data
with checksum mixed inside the same full stripe.

In that case if the direct IO buffer got changed halfway for the
nodatasum part, the data with checksum immediately lost its ability to
recover, e.g.:

" " = Good old data or parity calculated using good old data
"X" = Data modified during writeback

              0                32K                      64K
  Data 1      |                                         |  Has csum
  Data 2      |XXXXXXXXXXXXXXXX                         |  No csum
  Parity      |                                         |

In above case, the parity is calculated using data 1 (has csum, from
page cache, won't change during writeback), and old data 2 (has no csum,
direct IO write).

After parity is calculated, but before submission to the storage, direct
IO buffer of data 2 is modified, causing the range [0, 32K) of data 2
has a different content.

Now all data is submitted to the storage, and the fs got fully synced.

Then the device of data 1 is lost, has to be rebuilt from data 2 and
parity. But since the data 2 has some modified data, and the parity is
calculated using old data, the recovered data is no the same for data 1,
causing data checksum mismatch.

[FIX]
Fix the problem by checking the data allocation profile.
If our data allocation profile is either RAID0 or SINGLE, we can allow
true zero-copy direct IO and the end user is fully responsible for any
race.

However this is not going to fix all situations, as it's still possible
to race with balance where the fs got a new data profile after the data
allocation profile check.
But this fix should still greatly reduce the window of the original bug.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=99171
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/direct-io.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
index e29ea28ce90b9..3836414cbe371 100644
--- a/fs/btrfs/direct-io.c
+++ b/fs/btrfs/direct-io.c
@@ -814,6 +814,8 @@ ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
 	ssize_t ret;
 	unsigned int ilock_flags = 0;
 	struct iomap_dio *dio;
+	const u64 data_profile = btrfs_data_alloc_profile(fs_info) &
+				 BTRFS_BLOCK_GROUP_PROFILE_MASK;
 
 	if (iocb->ki_flags & IOCB_NOWAIT)
 		ilock_flags |= BTRFS_ILOCK_TRY;
@@ -827,6 +829,16 @@ ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
 	if (iocb->ki_pos + iov_iter_count(from) <= i_size_read(inode) && IS_NOSEC(inode))
 		ilock_flags |= BTRFS_ILOCK_SHARED;
 
+	/*
+	 * If our data profile has duplication (either extra mirrors or RAID56),
+	 * we can not trust the direct IO buffer, the content may change during
+	 * writeback and cause different contents written to different mirrors.
+	 *
+	 * Thus only RAID0 and SINGLE can go true zero-copy direct IO.
+	 */
+	if (data_profile != BTRFS_BLOCK_GROUP_RAID0 && data_profile != 0)
+		goto buffered;
+
 relock:
 	ret = btrfs_inode_lock(BTRFS_I(inode), ilock_flags);
 	if (ret < 0)
-- 
2.51.0

