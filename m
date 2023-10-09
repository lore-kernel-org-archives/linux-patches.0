Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742FB22F00
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VHrW1BQV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9B27C433C9;
	Mon,  9 Oct 2023 13:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858503;
	bh=1A2XkTBNpQD+ZsyoBUAWeSSHLcNPhO2KO7LK2ypkFbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VHrW1BQVgDiFvCOknzxMwvGyZIBCo9jXSaIQ6rqC4HHDNORko+9iagadbxxw//1mu
	 9pLZ7ub0sE9eBQcuPOwBQpCWC/efzX6OhlnKsvBTq9De2MCX9EVcLfwsNZ5HXbD+xE
	 qmJ2eY8r06bqjXGxD5AWdowQ0NIdUU7p/jo1/zrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 011/226] ext4: mark group as trimmed only if it was fully scanned
Date: Mon,  9 Oct 2023 14:59:32 +0200
Message-ID: <20231009130127.019559647@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130126.697995596@linuxfoundation.org>
References: <20231009130126.697995596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>

[ Upstream commit d63c00ea435a5352f486c259665a4ced60399421 ]

Otherwise nonaligned fstrim calls will works inconveniently for iterative
scanners, for example:

// trim [0,16MB] for group-1, but mark full group as trimmed
fstrim  -o $((1024*1024*128)) -l $((1024*1024*16)) ./m
// handle [16MB,16MB] for group-1, do nothing because group already has the flag.
fstrim  -o $((1024*1024*144)) -l $((1024*1024*16)) ./m

[ Update function documentation for ext4_trim_all_free -- TYT ]

Signed-off-by: Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>
Link: https://lore.kernel.org/r/1650214995-860245-1-git-send-email-dmtrmonakhov@yandex-team.ru
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Stable-dep-of: 45e4ab320c9b ("ext4: move setting of trimmed bit into ext4_try_to_trim_range()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 7bc17eb5ea74a..5c650e28dcb6b 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -5948,6 +5948,7 @@ static int ext4_try_to_trim_range(struct super_block *sb,
  * @start:		first group block to examine
  * @max:		last group block to examine
  * @minblocks:		minimum extent block count
+ * @set_trimmed:	set the trimmed flag if at least one block is trimmed
  *
  * ext4_trim_all_free walks through group's buddy bitmap searching for free
  * extents. When the free block is found, ext4_trim_extent is called to TRIM
@@ -5962,7 +5963,7 @@ static int ext4_try_to_trim_range(struct super_block *sb,
 static ext4_grpblk_t
 ext4_trim_all_free(struct super_block *sb, ext4_group_t group,
 		   ext4_grpblk_t start, ext4_grpblk_t max,
-		   ext4_grpblk_t minblocks)
+		   ext4_grpblk_t minblocks, bool set_trimmed)
 {
 	struct ext4_buddy e4b;
 	int ret;
@@ -5981,7 +5982,7 @@ ext4_trim_all_free(struct super_block *sb, ext4_group_t group,
 	if (!EXT4_MB_GRP_WAS_TRIMMED(e4b.bd_info) ||
 	    minblocks < EXT4_SB(sb)->s_last_trim_minblks) {
 		ret = ext4_try_to_trim_range(sb, &e4b, start, max, minblocks);
-		if (ret >= 0)
+		if (ret >= 0 && set_trimmed)
 			EXT4_MB_GRP_SET_TRIMMED(e4b.bd_info);
 	} else {
 		ret = 0;
@@ -6018,6 +6019,7 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
 	ext4_fsblk_t first_data_blk =
 			le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block);
 	ext4_fsblk_t max_blks = ext4_blocks_count(EXT4_SB(sb)->s_es);
+	bool whole_group, eof = false;
 	int ret = 0;
 
 	start = range->start >> sb->s_blocksize_bits;
@@ -6036,8 +6038,10 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
 		if (minlen > EXT4_CLUSTERS_PER_GROUP(sb))
 			goto out;
 	}
-	if (end >= max_blks)
+	if (end >= max_blks - 1) {
 		end = max_blks - 1;
+		eof = true;
+	}
 	if (end <= first_data_blk)
 		goto out;
 	if (start < first_data_blk)
@@ -6051,6 +6055,7 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
 
 	/* end now represents the last cluster to discard in this group */
 	end = EXT4_CLUSTERS_PER_GROUP(sb) - 1;
+	whole_group = true;
 
 	for (group = first_group; group <= last_group; group++) {
 		grp = ext4_get_group_info(sb, group);
@@ -6069,12 +6074,13 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
 		 * change it for the last group, note that last_cluster is
 		 * already computed earlier by ext4_get_group_no_and_offset()
 		 */
-		if (group == last_group)
+		if (group == last_group) {
 			end = last_cluster;
-
+			whole_group = eof ? true : end == EXT4_CLUSTERS_PER_GROUP(sb) - 1;
+		}
 		if (grp->bb_free >= minlen) {
 			cnt = ext4_trim_all_free(sb, group, first_cluster,
-						end, minlen);
+						 end, minlen, whole_group);
 			if (cnt < 0) {
 				ret = cnt;
 				break;
-- 
2.40.1



