Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BDF8161;
	Thu, 13 Jun 2024 12:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282100; cv=none; b=CMMwLv8LAevc2W8Bd7fMpNJ7IbInwpGExHgh3ljEY6lHvFA+hH0Ha2wI2E9w6mIM/m0wDmHS1a2Xt3EkUvgd1+U4renlAuxT6S9qO5CWaQnNbg0iaYyg203UZPZzlvsTLubKOM5H7OlGvU355ywr8NkeDXoEACfd2Lh7HlPVGB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282100; c=relaxed/simple;
	bh=emPVEi+7WQngeNktXQbKyPEGPWA9iiNMSu/ryfTC0k8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lj6X4nPoYMNZJArUAbYisI2jeiJLOn/NYPgKgvoxXwl+jYkSu9LyZYRDATZrXm/Im/Ad/KZ/dD0Lo0jBjkmdsH7Z3hxugORo9evLVm8DBOZc6XPqIIVxQNCo593ctRZnFd5OyDKF8rzOIoD1zPoA9O///gtYKjfV9mOovMovoNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tLaZpDmX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tLaZpDmX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7064C2BBFC;
	Thu, 13 Jun 2024 12:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282100;
	bh=emPVEi+7WQngeNktXQbKyPEGPWA9iiNMSu/ryfTC0k8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tLaZpDmXrci4wqXbZWnKTGc2yT4QVgbbk0EewVmQV/2ep8gFRyWsc8sVBSxUGtQGW
	 i9yU0zxpTXUrN/74XtshXr5usOqFprfFapT7gYpn8nlkl8999Md2/pyCUDDiOdfevw
	 DFGMsPhMm6t6bhS99jEiEj0yGWFOr6/L+Xm3TIYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 163/402] ext4: fix unit mismatch in ext4_mb_new_blocks_simple
Date: Thu, 13 Jun 2024 13:32:00 +0200
Message-ID: <20240613113308.493338194@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c2fcdee223317..383703e20ea36 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -5886,6 +5886,7 @@ static ext4_fsblk_t ext4_mb_new_blocks_simple(handle_t *handle,
 {
 	struct buffer_head *bitmap_bh;
 	struct super_block *sb = ar->inode->i_sb;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	ext4_group_t group;
 	ext4_grpblk_t blkoff;
 	ext4_grpblk_t max = EXT4_CLUSTERS_PER_GROUP(sb);
@@ -5914,7 +5915,8 @@ static ext4_fsblk_t ext4_mb_new_blocks_simple(handle_t *handle,
 			if (i >= max)
 				break;
 			if (ext4_fc_replay_check_excluded(sb,
-				ext4_group_first_block_no(sb, group) + i)) {
+				ext4_group_first_block_no(sb, group) +
+				EXT4_C2B(sbi, i))) {
 				blkoff = i + 1;
 			} else
 				break;
@@ -5931,7 +5933,7 @@ static ext4_fsblk_t ext4_mb_new_blocks_simple(handle_t *handle,
 		return 0;
 	}
 
-	block = ext4_group_first_block_no(sb, group) + i;
+	block = ext4_group_first_block_no(sb, group) + EXT4_C2B(sbi, i);
 	ext4_mb_mark_bb(sb, block, 1, 1);
 	ar->len = 1;
 
-- 
2.43.0



