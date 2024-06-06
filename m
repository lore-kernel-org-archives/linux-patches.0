Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58122196DAB;
	Thu,  6 Jun 2024 14:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683379; cv=none; b=fw46SSC1umGerz2pflPSbst2N3VGHtDyOFcwoW5Fplwvqp8LN8CYeF1c2/WNIK6Ne689x1DJWucJkqtqnY3J8DVAssUZW43YkCtNSFCO6doTRsXvPSVJJorBRO+SJLooXRoKpQo6iHYOWhGyJ1uPoyxIUzHzG55FodZQK9VSr8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683379; c=relaxed/simple;
	bh=OtFkjlumPLXyjMu+MsykojxjLdIGZuKe+oAZryC2zI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ucR8PROYCe42uv1xBgKI7tc29xT6Zau+vx649Xvz9WDMiMDza4mlUQX6meam8Cs6kiNY4XGNAgMBU0uQaY0zF5iD8ud7PO+UG/TXBpr7mm88txx05AcElVd9nAuOntajujW99TRnm3VQ/DW9bFvR4LJjR5DAYArTN9pfdrS2jZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EZoZU67L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EZoZU67L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38D15C2BD10;
	Thu,  6 Jun 2024 14:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683379;
	bh=OtFkjlumPLXyjMu+MsykojxjLdIGZuKe+oAZryC2zI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EZoZU67LwMz5yE4abju04w9GyKxys8mDEfJn+qfkib4oPpGv8xEmw3ChRN2sBMnW5
	 1C6rCfD01H5HBJqViLSAsEYN8KG8/XGsRuksBgsqCIuwsYi7Z6/GgWbZklRev8nkNV
	 YvuHfcemJVfz5GUryFu+r0issIaLiJrtOmjgJGRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 262/473] ext4: fix unit mismatch in ext4_mb_new_blocks_simple
Date: Thu,  6 Jun 2024 16:03:11 +0200
Message-ID: <20240606131708.613133720@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

From: Kemeng Shi <shikemeng@huaweicloud.com>

[ Upstream commit 497885f72d930305d8e61b6b616b22b4da1adf90 ]

The "i" returned from mb_find_next_zero_bit is in cluster unit and we
need offset "block" corresponding to "i" in block unit. Convert "i" to
block unit to fix the unit mismatch.

Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Link: https://lore.kernel.org/r/20230603150327.3596033-3-shikemeng@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 3f4830abd236 ("ext4: fix potential unnitialized variable")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index eaa5db60865a4..a809a80589857 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -5874,6 +5874,7 @@ static ext4_fsblk_t ext4_mb_new_blocks_simple(handle_t *handle,
 {
 	struct buffer_head *bitmap_bh;
 	struct super_block *sb = ar->inode->i_sb;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	ext4_group_t group;
 	ext4_grpblk_t blkoff;
 	ext4_grpblk_t max = EXT4_CLUSTERS_PER_GROUP(sb);
@@ -5902,7 +5903,8 @@ static ext4_fsblk_t ext4_mb_new_blocks_simple(handle_t *handle,
 			if (i >= max)
 				break;
 			if (ext4_fc_replay_check_excluded(sb,
-				ext4_group_first_block_no(sb, group) + i)) {
+				ext4_group_first_block_no(sb, group) +
+				EXT4_C2B(sbi, i))) {
 				blkoff = i + 1;
 			} else
 				break;
@@ -5919,7 +5921,7 @@ static ext4_fsblk_t ext4_mb_new_blocks_simple(handle_t *handle,
 		return 0;
 	}
 
-	block = ext4_group_first_block_no(sb, group) + i;
+	block = ext4_group_first_block_no(sb, group) + EXT4_C2B(sbi, i);
 	ext4_mb_mark_bb(sb, block, 1, 1);
 	ar->len = 1;
 
-- 
2.43.0



