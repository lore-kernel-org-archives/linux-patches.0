Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89431BC39;
	Sat,  3 Feb 2024 04:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933780; cv=none; b=UcebVHF5Mhle5PLuMVSF0/s+stg2YjsrB4Yo6HJdjymcS0yBRC/QftA0NKS+mDVkmWdN9XXgt2xz2cGgwCLlsdHA9tXxRGfNFe958GFzd6Rssw436Z2hnzM8bSnfP2Jh73vg2taw5xL62qmlLA044xGbAbARS9Jpe1OVGBUaMVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933780; c=relaxed/simple;
	bh=hPaNIWpTEADtap4UEOKjCrOmpD3R9BvDDArmq9AEHxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jMWD9UYMJz45tpb/ijpo1zEOxKV61z4vnBGW7THw5/0wwV5lkpU0SeDw5aRMVifLdOEAfU7ewi8aGT2QPK/zbHKXXGYu8oAfeaWm1lU8keFnwemPNSphp6FVh9bBZgjFEcRzvHc8pI+z1LWKGwnNa6qwkVKj8iVjaaHZpYeDNJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BJ7rrE1G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BJ7rrE1G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8122CC433C7;
	Sat,  3 Feb 2024 04:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933780;
	bh=hPaNIWpTEADtap4UEOKjCrOmpD3R9BvDDArmq9AEHxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BJ7rrE1GNr5pgQ+t7uov9aZjLtOxm9oOXtWSbHH4kO88os62rSFW7EruifwYcKpMt
	 3Mr1UJQSznxWckVEbWar6jAhVfjHj0TgkTX2ImxYd8xHsjWNlRBhpatKzQWZIOoRpM
	 EVp1hAFj2X3DB+fg3X4klCOLu9IgrdZ2ybltHxEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 060/353] ext4: unify the type of flexbg_size to unsigned int
Date: Fri,  2 Feb 2024 20:02:58 -0800
Message-ID: <20240203035405.698087238@linuxfoundation.org>
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

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit 658a52344fb139f9531e7543a6e0015b630feb38 ]

The maximum value of flexbg_size is 2^31, but the maximum value of int
is (2^31 - 1), so overflow may occur when the type of flexbg_size is
declared as int.

For example, when uninit_mask is initialized in ext4_alloc_group_tables(),
if flexbg_size == 2^31, the initialized uninit_mask is incorrect, and this
may causes set_flexbg_block_bitmap() to trigger a BUG_ON().

Therefore, the flexbg_size type is declared as unsigned int to avoid
overflow and memory waste.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20231023013057.2117948-2-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 5d1935ac02ca ("ext4: avoid online resizing failures due to oversized flex bg")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/resize.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 4fe061edefdd..c6d4539d4c1f 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -228,7 +228,7 @@ struct ext4_new_flex_group_data {
  *
  * Returns NULL on failure otherwise address of the allocated structure.
  */
-static struct ext4_new_flex_group_data *alloc_flex_gd(unsigned long flexbg_size)
+static struct ext4_new_flex_group_data *alloc_flex_gd(unsigned int flexbg_size)
 {
 	struct ext4_new_flex_group_data *flex_gd;
 
@@ -283,7 +283,7 @@ static void free_flex_gd(struct ext4_new_flex_group_data *flex_gd)
  */
 static int ext4_alloc_group_tables(struct super_block *sb,
 				struct ext4_new_flex_group_data *flex_gd,
-				int flexbg_size)
+				unsigned int flexbg_size)
 {
 	struct ext4_new_group_data *group_data = flex_gd->groups;
 	ext4_fsblk_t start_blk;
@@ -384,12 +384,12 @@ static int ext4_alloc_group_tables(struct super_block *sb,
 		group = group_data[0].group;
 
 		printk(KERN_DEBUG "EXT4-fs: adding a flex group with "
-		       "%d groups, flexbg size is %d:\n", flex_gd->count,
+		       "%u groups, flexbg size is %u:\n", flex_gd->count,
 		       flexbg_size);
 
 		for (i = 0; i < flex_gd->count; i++) {
 			ext4_debug(
-			       "adding %s group %u: %u blocks (%d free, %d mdata blocks)\n",
+			       "adding %s group %u: %u blocks (%u free, %u mdata blocks)\n",
 			       ext4_bg_has_super(sb, group + i) ? "normal" :
 			       "no-super", group + i,
 			       group_data[i].blocks_count,
@@ -1606,7 +1606,7 @@ static int ext4_flex_group_add(struct super_block *sb,
 static int ext4_setup_next_flex_gd(struct super_block *sb,
 				    struct ext4_new_flex_group_data *flex_gd,
 				    ext4_fsblk_t n_blocks_count,
-				    unsigned long flexbg_size)
+				    unsigned int flexbg_size)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_super_block *es = sbi->s_es;
@@ -1990,8 +1990,9 @@ int ext4_resize_fs(struct super_block *sb, ext4_fsblk_t n_blocks_count)
 	ext4_fsblk_t o_blocks_count;
 	ext4_fsblk_t n_blocks_count_retry = 0;
 	unsigned long last_update_time = 0;
-	int err = 0, flexbg_size = 1 << sbi->s_log_groups_per_flex;
+	int err = 0;
 	int meta_bg;
+	unsigned int flexbg_size = ext4_flex_bg_size(sbi);
 
 	/* See if the device is actually as big as what was requested */
 	bh = ext4_sb_bread(sb, n_blocks_count - 1, 0);
-- 
2.43.0



