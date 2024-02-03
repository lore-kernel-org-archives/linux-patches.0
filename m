Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A50010A1C;
	Sat,  3 Feb 2024 04:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933355; cv=none; b=TCdLQ/XG6Z/KkQpzIIPM2x3xETj3OSePYP9Gly98YLcb5Cr13Pq0bG+kO+zlS15IQ90lSK9NklURYV8X+ei53k8SGoRqh4rietLU/k3Lteg0qheOVXq2N110fpEzJdrWQVnU3vUh5Uorc3KvYSleWyk2IjD1sGIYlPOQ3RnPLCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933355; c=relaxed/simple;
	bh=j2ErxtO4+aSfwwXca9vhGo/dFQxqWQ/MGL8sITEYOes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p2oRyXJVRPob0ioDPRrDZG3ndI1yxnWP/L0fWbGXxirCtSVQqJc7XrO4I2tZkmwe6gCPWOC2ylm0sUwcSQ1DN+oBc0uCU7rMEsIgFEGbHoj+737fxpOIpi+VyRLDbLMNk62S3ELXyK7JkHgqRWMegWC2fboTsnOfpdfBcX5I4hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MTWKDEoA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MTWKDEoA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F4AC433F1;
	Sat,  3 Feb 2024 04:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933355;
	bh=j2ErxtO4+aSfwwXca9vhGo/dFQxqWQ/MGL8sITEYOes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MTWKDEoAa3NSnzPR4GhUEa3s+NkRby0tZiH0hYCanZwtoVOAbGOt/cgQkVbqEOHPu
	 jYYcoMEXOkacYZ3fTgGlsEvkOvipxgc/o+8KBDKP+V5LWT52M2dB5NMNO9xwAiXG0i
	 OetaL8kPZjY4dd+kqBvFcaFxXl3WT207gmLlU5WI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Bin <yebin10@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 041/219] ext4: fix inconsistent between segment fstrim and full fstrim
Date: Fri,  2 Feb 2024 20:03:34 -0800
Message-ID: <20240203035322.287845291@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

From: Ye Bin <yebin10@huawei.com>

[ Upstream commit 68da4c44b994aea797eb9821acb3a4a36015293e ]

Suppose we issue two FITRIM ioctls for ranges [0,15] and [16,31] with
mininum length of trimmed range set to 8 blocks. If we have say a range of
blocks 10-22 free, this range will not be trimmed because it straddles the
boundary of the two FITRIM ranges and neither part is big enough. This is a
bit surprising to some users that call FITRIM on smaller ranges of blocks
to limit impact on the system. Also XFS trims all free space extents that
overlap with the specified range so we are inconsistent among filesystems.
Let's change ext4_try_to_trim_range() to consider for trimming the whole
free space extent that straddles the end of specified range, not just the
part of it within the range.

Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20231216010919.1995851-1-yebin10@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 33be702d6e38..c1515daf1def 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -6444,13 +6444,15 @@ static int ext4_try_to_trim_range(struct super_block *sb,
 __acquires(ext4_group_lock_ptr(sb, e4b->bd_group))
 __releases(ext4_group_lock_ptr(sb, e4b->bd_group))
 {
-	ext4_grpblk_t next, count, free_count;
+	ext4_grpblk_t next, count, free_count, last, origin_start;
 	bool set_trimmed = false;
 	void *bitmap;
 
+	last = ext4_last_grp_cluster(sb, e4b->bd_group);
 	bitmap = e4b->bd_bitmap;
-	if (start == 0 && max >= ext4_last_grp_cluster(sb, e4b->bd_group))
+	if (start == 0 && max >= last)
 		set_trimmed = true;
+	origin_start = start;
 	start = max(e4b->bd_info->bb_first_free, start);
 	count = 0;
 	free_count = 0;
@@ -6459,7 +6461,10 @@ __releases(ext4_group_lock_ptr(sb, e4b->bd_group))
 		start = mb_find_next_zero_bit(bitmap, max + 1, start);
 		if (start > max)
 			break;
-		next = mb_find_next_bit(bitmap, max + 1, start);
+
+		next = mb_find_next_bit(bitmap, last + 1, start);
+		if (origin_start == 0 && next >= last)
+			set_trimmed = true;
 
 		if ((next - start) >= minblocks) {
 			int ret = ext4_trim_extent(sb, start, next - start, e4b);
-- 
2.43.0



