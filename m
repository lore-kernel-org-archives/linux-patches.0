Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A485469D02;
	Wed, 21 Feb 2024 13:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521283; cv=none; b=CzxYcIWRIFV2H4dDLBBgfNlBm/C+rqW/udBwpxW3tbn7JNgONXypcMBLjA9y1VQTpEUHcz7tQLIkCIj3KG3Cau4Mg5T2oriv2n+ajL71KsZj/suSjcDJqqyn6bSu1LFdTurerttGRtQa9vg94+8ahmyHsqqoZ7JsZYx5KhxT1NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521283; c=relaxed/simple;
	bh=xQQ5ZzNzyhaXbnZ+e85sbt8IDUHT9xOgMm2I0e86Wm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kOuarAsWIHxzDHzWKe2/DLA9yt/CUyRgaHdcrlzjx4Qy8720cG742elK6INErhDlc0F3N8Q97Le18oCSWzZECUBHc6Emu/kNwYCh/wv0Lkvl6woXSVJ2BLAYpKXUdWQPyDEoftwF31owTObT1guogDJlKXkp0p38XOuAEQjXkXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nQPQi81b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nQPQi81b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1116DC433C7;
	Wed, 21 Feb 2024 13:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521283;
	bh=xQQ5ZzNzyhaXbnZ+e85sbt8IDUHT9xOgMm2I0e86Wm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nQPQi81bs1q7qWc3W+3aSUuWEbtMBK3Yk8QGKpKoSVWqP5lwlSzLqHuiIczLbHyPs
	 A92UihB8aSECHq3BmF1AhoSTbk5PDRDMchl1NRQCao+Tj/mLI9F4ctWBhnZmXbabDp
	 v2hWx9YrunnsdVSxd83H5TwhQZfqCC3W1myn8Mkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Bin <yebin10@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 071/202] ext4: fix inconsistent between segment fstrim and full fstrim
Date: Wed, 21 Feb 2024 14:06:12 +0100
Message-ID: <20240221125934.114645804@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 0572ae09c729..df390979058f 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -5213,13 +5213,15 @@ static int ext4_try_to_trim_range(struct super_block *sb,
 		struct ext4_buddy *e4b, ext4_grpblk_t start,
 		ext4_grpblk_t max, ext4_grpblk_t minblocks)
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
@@ -5228,7 +5230,10 @@ static int ext4_try_to_trim_range(struct super_block *sb,
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



