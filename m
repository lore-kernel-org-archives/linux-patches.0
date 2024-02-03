Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE481118F;
	Sat,  3 Feb 2024 04:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933513; cv=none; b=U/x7W0xxannnJ+Kh14EgdITMg3oqiasDQ+3OZRqgbv15WsMDnpq82PPjX8LSOtbjq7IkKW+Z9qtlRnJH/K7rOxPFdBiZBE3jwLXqcZ7ALUeF4y8IGzkb3yXltvQYB2SIVpXMO5mNNuyfIAoj7RGGVf1/SLnDI0Tb6byW4G6TEGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933513; c=relaxed/simple;
	bh=V71VIgkQBilAeFSu4jHcFvEpUNSIzrOYWQRHt5PdF0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e1BFa7827DCxG/rfQQirx3ToEFhlMHBMe+hhQqoKpf+NRFxQGBpnFz4MRpVoG0XBPU0LA7a2vDI69yxeedp9Yv6nSIPSC8sgmE18HzI4bE/Z13xa3Mo2Blb2ggsdSA1bxj8ZXFjH2dCxJbfnfWudDJFIfvU2Sj8u9npPRIGCf0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rD34ocGI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rD34ocGI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06D92C433B1;
	Sat,  3 Feb 2024 04:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933513;
	bh=V71VIgkQBilAeFSu4jHcFvEpUNSIzrOYWQRHt5PdF0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rD34ocGIVhi0UqqbWuyFRTDeDjcTYqS06WRfeH40im+OqZAJQt58COnpslNZCQMvb
	 g+BS6zIaEvYKMCku1auBH8ZM6ScNXGMUcSXTAja/5p++R5a0orB0gSz+weTqp7RSHh
	 leXWrYYIdWjpxf3eOhjlEWnXVose2x4Z3pqeZ14w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 050/322] ext4: treat end of range as exclusive in ext4_zero_range()
Date: Fri,  2 Feb 2024 20:02:27 -0800
Message-ID: <20240203035400.730286655@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4d8496d1a8ac..4c3e2f38349d 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4522,7 +4522,8 @@ static long ext4_zero_range(struct file *file, loff_t offset,
 	 * Round up offset. This is not fallocate, we need to zero out
 	 * blocks, so convert interior block aligned part of the range to
 	 * unwritten and possibly manually zero out unaligned parts of the
-	 * range.
+	 * range. Here, start and partial_begin are inclusive, end and
+	 * partial_end are exclusive.
 	 */
 	start = round_up(offset, 1 << blkbits);
 	end = round_down((offset + len), 1 << blkbits);
@@ -4608,7 +4609,8 @@ static long ext4_zero_range(struct file *file, loff_t offset,
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



