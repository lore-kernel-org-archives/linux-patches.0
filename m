Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4111A735
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x8IABE+M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDB49C433C7;
	Mon,  9 Oct 2023 13:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696859433;
	bh=p040UTFxSY4qML5XDqt3gG2lIOQLXpFWvTCpjNMzkfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x8IABE+Msm/4Z+1uZ1Wr/sPeHkTNC8mQY7z7nTPk7dCPuGd/V5FTyC6JM/dJoHKTP
	 GWSMLXDgfE4XeENFAoz/7tYyC2jTxEISPQMtDZSDalVyIEWCNm7o3A9L+57UdSE0MI
	 dyeXoctIh9XRApmR2ayxKWLffkVMn9ujLg7nuSIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Dilger <adilger@dilger.ca>,
	Wang Jianchao <wangjianchao@kuaishou.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 20/91] ext4: remove the group parameter of ext4_trim_extent
Date: Mon,  9 Oct 2023 15:05:52 +0200
Message-ID: <20231009130112.230241072@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130111.518916887@linuxfoundation.org>
References: <20231009130111.518916887@linuxfoundation.org>
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

From: Wang Jianchao <wangjianchao@kuaishou.com>

[ Upstream commit bd2eea8d0a6b6a9aca22f20bf74f73b71d8808af ]

Get rid of the 'group' parameter of ext4_trim_extent as we can get
it from the 'e4b'.

Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Signed-off-by: Wang Jianchao <wangjianchao@kuaishou.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20210724074124.25731-2-jianchao.wan9@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 45e4ab320c9b ("ext4: move setting of trimmed bit into ext4_try_to_trim_range()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 7692c12b85285..7b81094831754 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -5149,19 +5149,19 @@ int ext4_group_add_blocks(handle_t *handle, struct super_block *sb,
  * @sb:		super block for the file system
  * @start:	starting block of the free extent in the alloc. group
  * @count:	number of blocks to TRIM
- * @group:	alloc. group we are working with
  * @e4b:	ext4 buddy for the group
  *
  * Trim "count" blocks starting at "start" in the "group". To assure that no
  * one will allocate those blocks, mark it as used in buddy bitmap. This must
  * be called with under the group lock.
  */
-static int ext4_trim_extent(struct super_block *sb, int start, int count,
-			     ext4_group_t group, struct ext4_buddy *e4b)
+static int ext4_trim_extent(struct super_block *sb,
+		int start, int count, struct ext4_buddy *e4b)
 __releases(bitlock)
 __acquires(bitlock)
 {
 	struct ext4_free_extent ex;
+	ext4_group_t group = e4b->bd_group;
 	int ret = 0;
 
 	trace_ext4_trim_extent(sb, group, start, count);
@@ -5237,8 +5237,7 @@ ext4_trim_all_free(struct super_block *sb, ext4_group_t group,
 		next = mb_find_next_bit(bitmap, max + 1, start);
 
 		if ((next - start) >= minblocks) {
-			ret = ext4_trim_extent(sb, start,
-					       next - start, group, &e4b);
+			ret = ext4_trim_extent(sb, start, next - start, &e4b);
 			if (ret && ret != -EOPNOTSUPP)
 				break;
 			ret = 0;
-- 
2.40.1



