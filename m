Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC5239FEA;
	Fri, 24 Nov 2023 18:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0cmkoFUp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43C00C433C7;
	Fri, 24 Nov 2023 18:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700848991;
	bh=v9SLjszPzf+zuhpr0NUvLqgNEGruqPgr7aojp9eVaAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0cmkoFUptvFGp9kbHTHbpMqshH5RHEFnI34XsaP3vs/nRmD/DQbrnirjyAoiFULHj
	 T6y5n0ntSYwEN8omqXz7JaoK+O7j5na+BtL0aooL7DpEUxBCNJDnvvOMOOczexHVGu
	 NVMW3wURGqArogrAvg0YL2sOaJ6ci3IkiXxCCRA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 4.14 55/57] ext4: remove gdb backup copy for meta bg in setup_new_flex_group_blocks
Date: Fri, 24 Nov 2023 17:51:19 +0000
Message-ID: <20231124171932.377050365@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171930.281665051@linuxfoundation.org>
References: <20231124171930.281665051@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kemeng Shi <shikemeng@huaweicloud.com>

commit 40dd7953f4d606c280074f10d23046b6812708ce upstream.

Wrong check of gdb backup in meta bg as following:
first_group is the first group of meta_bg which contains target group, so
target group is always >= first_group. We check if target group has gdb
backup by comparing first_group with [group + 1] and [group +
EXT4_DESC_PER_BLOCK(sb) - 1]. As group >= first_group, then [group + N] is
> first_group. So no copy of gdb backup in meta bg is done in
setup_new_flex_group_blocks.

No need to do gdb backup copy in meta bg from setup_new_flex_group_blocks
as we always copy updated gdb block to backups at end of
ext4_flex_group_add as following:

ext4_flex_group_add
  /* no gdb backup copy for meta bg any more */
  setup_new_flex_group_blocks

  /* update current group number */
  ext4_update_super
    sbi->s_groups_count += flex_gd->count;

  /*
   * if group in meta bg contains backup is added, the primary gdb block
   * of the meta bg will be copy to backup in new added group here.
   */
  for (; gdb_num <= gdb_num_end; gdb_num++)
    update_backups(...)

In summary, we can remove wrong gdb backup copy code in
setup_new_flex_group_blocks.

Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Theodore Ts'o <tytso@mit.edu>
Link: https://lore.kernel.org/r/20230826174712.4059355-5-shikemeng@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/resize.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -557,13 +557,8 @@ static int setup_new_flex_group_blocks(s
 		if (meta_bg == 0 && !ext4_bg_has_super(sb, group))
 			goto handle_itb;
 
-		if (meta_bg == 1) {
-			ext4_group_t first_group;
-			first_group = ext4_meta_bg_first_group(sb, group);
-			if (first_group != group + 1 &&
-			    first_group != group + EXT4_DESC_PER_BLOCK(sb) - 1)
-				goto handle_itb;
-		}
+		if (meta_bg == 1)
+			goto handle_itb;
 
 		block = start + ext4_bg_has_super(sb, group);
 		/* Copy all of the GDT blocks into the backup in this group */


