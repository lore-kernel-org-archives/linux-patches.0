Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C3A7AD48
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:26:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D50C1C433EF;
	Wed,  4 Jan 2023 16:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672849601;
	bh=TuhTPwIYu1257aBk7QcadP3//fuKc7XG7FRq2/tMhGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sMdR1BZ3XEmXwoF+acKfBpCSBSwKNhoXu3fDh8BixA5GYYp4/6R0nNgnAsHxeLAsT
	 MnZUGGKkAkPctm67qGlmKJMCnMxbwPh1MjwRmQpGDZCa6d/75rxzEzq8W2ExZYIJfP
	 qKAFJnBT7w2fcMPKPNWqyx8IN1MXuVPYFeJOqdvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Jan Kara <jack@suse.cz>,
	stable@kernel.org,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.0 158/177] ext4: fix bad checksum after online resize
Date: Wed,  4 Jan 2023 17:07:29 +0100
Message-Id: <20230104160512.462148019@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Baokun Li <libaokun1@huawei.com>

commit a408f33e895e455f16cf964cb5cd4979b658db7b upstream.

When online resizing is performed twice consecutively, the error message
"Superblock checksum does not match superblock" is displayed for the
second time. Here's the reproducer:

	mkfs.ext4 -F /dev/sdb 100M
	mount /dev/sdb /tmp/test
	resize2fs /dev/sdb 5G
	resize2fs /dev/sdb 6G

To solve this issue, we moved the update of the checksum after the
es->s_overhead_clusters is updated.

Fixes: 026d0d27c488 ("ext4: reduce computation of overhead during resize")
Fixes: de394a86658f ("ext4: update s_overhead_clusters in the superblock during an on-line resize")
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20221117040341.1380702-2-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/resize.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1476,8 +1476,6 @@ static void ext4_update_super(struct sup
 	 * active. */
 	ext4_r_blocks_count_set(es, ext4_r_blocks_count(es) +
 				reserved_blocks);
-	ext4_superblock_csum_set(sb);
-	unlock_buffer(sbi->s_sbh);
 
 	/* Update the free space counts */
 	percpu_counter_add(&sbi->s_freeclusters_counter,
@@ -1513,6 +1511,8 @@ static void ext4_update_super(struct sup
 		ext4_calculate_overhead(sb);
 	es->s_overhead_clusters = cpu_to_le32(sbi->s_overhead);
 
+	ext4_superblock_csum_set(sb);
+	unlock_buffer(sbi->s_sbh);
 	if (test_opt(sb, DEBUG))
 		printk(KERN_DEBUG "EXT4-fs: added group %u:"
 		       "%llu blocks(%llu free %llu reserved)\n", flex_gd->count,


