Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1E048CC1;
	Sat,  3 Feb 2024 04:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933757; cv=none; b=KLOfdPN3mdJcRs36h2YVXpyb+fbMVVSNAslWB2efIChBiT446yTDHeS4irxk8i2m2dGQi0c7XobzdSAq3drq2jqGD5x0u1rpVfRUBvvLvW/2GITMnDgoZi5qTcrGlY1oBZQCbMeq706UVtPVJKdrwnEHekKOEOdxU4Fwb+nvyT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933757; c=relaxed/simple;
	bh=ulXdhQf0rdjOuvK8yHDnW1UoTy3L6XIQ84IahF4pAqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l4AYFfkzB8O+nCDgj5lqmcSXPXrvSla/7qzG+Pxe3uNue2pPoTvHQxdOlGkebma/9aTgGcsxQb/rvQ15GUYo4tWkLrQW4QdvwpljCvaIelJJdbNnQ9Fyy2n0mo8VqRdbFDzh/p5yr3ZahVML3X8F/JSAQldexTkQECnnpHQt2P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d7RePiSt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d7RePiSt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6716EC433F1;
	Sat,  3 Feb 2024 04:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933757;
	bh=ulXdhQf0rdjOuvK8yHDnW1UoTy3L6XIQ84IahF4pAqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d7RePiStEq81A0alULaPV4nuD3Tqz0t9RHpIg9J47/9aJTb3Z9Qj4aSQtpKkSiJGy
	 R9mz4fpELXUPlS9+JyaSapmNZCkQacsAjehJIH2LWiKrHiN/3rB8RaTBLyiSengR0X
	 mAtWUYHpUTGnp0mNXxW9+laODCJJt8WqQTvpYho0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 054/353] ext4: treat end of range as exclusive in ext4_zero_range()
Date: Fri,  2 Feb 2024 20:02:52 -0800
Message-ID: <20240203035405.510409849@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

From: Ojaswin Mujoo <ojaswin@linux.ibm.com>

[ Upstream commit 92573369144f40397e8514440afdf59f24905b40 ]

The call to filemap_write_and_wait_range() assumes the range passed to be
inclusive, so fix the call to make sure we follow that.

Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/e503107a7c73a2b68dec645c5ad798c437717c45.1698856309.git.ojaswin@linux.ibm.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/extents.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index d5efe076d3d3..01299b55a567 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4523,7 +4523,8 @@ static long ext4_zero_range(struct file *file, loff_t offset,
 	 * Round up offset. This is not fallocate, we need to zero out
 	 * blocks, so convert interior block aligned part of the range to
 	 * unwritten and possibly manually zero out unaligned parts of the
-	 * range.
+	 * range. Here, start and partial_begin are inclusive, end and
+	 * partial_end are exclusive.
 	 */
 	start = round_up(offset, 1 << blkbits);
 	end = round_down((offset + len), 1 << blkbits);
@@ -4609,7 +4610,8 @@ static long ext4_zero_range(struct file *file, loff_t offset,
 		 * disk in case of crash before zeroing trans is committed.
 		 */
 		if (ext4_should_journal_data(inode)) {
-			ret = filemap_write_and_wait_range(mapping, start, end);
+			ret = filemap_write_and_wait_range(mapping, start,
+							   end - 1);
 			if (ret) {
 				filemap_invalidate_unlock(mapping);
 				goto out_mutex;
-- 
2.43.0



