Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D581D52D;
	Thu, 23 May 2024 13:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470128; cv=none; b=o9SqI7E3ogHDC9rRlsHiey4hcYK28PIG16Fet4+3gLfQ/Tb2hYpjMBnANWn5//YTaDomB+QHRMQIeBZfBEG/ig3yZxjZhn199woDkQ3oc2e1m03+yvLaReFeYdXktA4bgmeI8/TVTFcLEYqSNiMOYy3veN1BJl9bmY3w0tx+4VI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470128; c=relaxed/simple;
	bh=/F3xNlIT68ioa67sz2a4CU+UJiNJLR6AmW123vCda6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=al7PDkxvLxck3zgCxvfNajfYOHKW6yWFGPxyxxIaMTNzP00yI69T+qUoz1rwcjmeoHeK1L8dmtmbIo6L5/Jzp1rO+S1L/2IcZdCPQKH4BZVue2FDF5CR691V3WOONbyFvUdI0GiJvFul0WDT1szT68SoIvsXYY8viU1u9yWrAxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zsv0I1mO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zsv0I1mO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EAFBC2BD10;
	Thu, 23 May 2024 13:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470128;
	bh=/F3xNlIT68ioa67sz2a4CU+UJiNJLR6AmW123vCda6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zsv0I1mONm6eCJRsTmKdBzjOapzcUb4Dk3vXrS5mtZ4JN5R/saaZXl1v3BeH3D0gl
	 qUZqEwgKrezV/vXNR+0NesapGBgxngtrct8rdxy64IJmdgutqMofM/EjyzXtnY42Cj
	 dthsL4syWlIeTpPepTD2xHJ/yfIV7n2VHgPRiRLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Hulk Robot <hulkci@huawei.com>,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	syzbot+2a58d88f0fb315c85363@syzkaller.appspotmail.com,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>
Subject: [PATCH 5.4 02/16] ext4: fix bug_on in __es_tree_search
Date: Thu, 23 May 2024 15:12:35 +0200
Message-ID: <20240523130325.837613911@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130325.743454852@linuxfoundation.org>
References: <20240523130325.743454852@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

commit d36f6ed761b53933b0b4126486c10d3da7751e7f upstream.

Hulk Robot reported a BUG_ON:
==================================================================
kernel BUG at fs/ext4/extents_status.c:199!
[...]
RIP: 0010:ext4_es_end fs/ext4/extents_status.c:199 [inline]
RIP: 0010:__es_tree_search+0x1e0/0x260 fs/ext4/extents_status.c:217
[...]
Call Trace:
 ext4_es_cache_extent+0x109/0x340 fs/ext4/extents_status.c:766
 ext4_cache_extents+0x239/0x2e0 fs/ext4/extents.c:561
 ext4_find_extent+0x6b7/0xa20 fs/ext4/extents.c:964
 ext4_ext_map_blocks+0x16b/0x4b70 fs/ext4/extents.c:4384
 ext4_map_blocks+0xe26/0x19f0 fs/ext4/inode.c:567
 ext4_getblk+0x320/0x4c0 fs/ext4/inode.c:980
 ext4_bread+0x2d/0x170 fs/ext4/inode.c:1031
 ext4_quota_read+0x248/0x320 fs/ext4/super.c:6257
 v2_read_header+0x78/0x110 fs/quota/quota_v2.c:63
 v2_check_quota_file+0x76/0x230 fs/quota/quota_v2.c:82
 vfs_load_quota_inode+0x5d1/0x1530 fs/quota/dquot.c:2368
 dquot_enable+0x28a/0x330 fs/quota/dquot.c:2490
 ext4_quota_enable fs/ext4/super.c:6137 [inline]
 ext4_enable_quotas+0x5d7/0x960 fs/ext4/super.c:6163
 ext4_fill_super+0xa7c9/0xdc00 fs/ext4/super.c:4754
 mount_bdev+0x2e9/0x3b0 fs/super.c:1158
 mount_fs+0x4b/0x1e4 fs/super.c:1261
[...]
==================================================================

Above issue may happen as follows:
-------------------------------------
ext4_fill_super
 ext4_enable_quotas
  ext4_quota_enable
   ext4_iget
    __ext4_iget
     ext4_ext_check_inode
      ext4_ext_check
       __ext4_ext_check
        ext4_valid_extent_entries
         Check for overlapping extents does't take effect
   dquot_enable
    vfs_load_quota_inode
     v2_check_quota_file
      v2_read_header
       ext4_quota_read
        ext4_bread
         ext4_getblk
          ext4_map_blocks
           ext4_ext_map_blocks
            ext4_find_extent
             ext4_cache_extents
              ext4_es_cache_extent
               ext4_es_cache_extent
                __es_tree_search
                 ext4_es_end
                  BUG_ON(es->es_lblk + es->es_len < es->es_lblk)

The error ext4 extents is as follows:
0af3 0300 0400 0000 00000000    extent_header
00000000 0100 0000 12000000     extent1
00000000 0100 0000 18000000     extent2
02000000 0400 0000 14000000     extent3

In the ext4_valid_extent_entries function,
if prev is 0, no error is returned even if lblock<=prev.
This was intended to skip the check on the first extent, but
in the error image above, prev=0+1-1=0 when checking the second extent,
so even though lblock<=prev, the function does not return an error.
As a result, bug_ON occurs in __es_tree_search and the system panics.

To solve this problem, we only need to check that:
1. The lblock of the first extent is not less than 0.
2. The lblock of the next extent  is not less than
   the next block of the previous extent.
The same applies to extent_idx.

Cc: stable@kernel.org
Fixes: 5946d089379a ("ext4: check for overlapping extents in ext4_valid_extent_entries()")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220518120816.1541863-1-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reported-by: syzbot+2a58d88f0fb315c85363@syzkaller.appspotmail.com
[gpiccoli: Manual backport due to unrelated missing patches.]
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/extents.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -409,7 +409,7 @@ static int ext4_valid_extent_entries(str
 {
 	unsigned short entries;
 	ext4_lblk_t lblock = 0;
-	ext4_lblk_t prev = 0;
+	ext4_lblk_t cur = 0;
 
 	if (eh->eh_entries == 0)
 		return 1;
@@ -435,12 +435,12 @@ static int ext4_valid_extent_entries(str
 
 			/* Check for overlapping extents */
 			lblock = le32_to_cpu(ext->ee_block);
-			if ((lblock <= prev) && prev) {
+			if (lblock < cur) {
 				pblock = ext4_ext_pblock(ext);
 				es->s_last_error_block = cpu_to_le64(pblock);
 				return 0;
 			}
-			prev = lblock + ext4_ext_get_actual_len(ext) - 1;
+			cur = lblock + ext4_ext_get_actual_len(ext);
 			ext++;
 			entries--;
 		}
@@ -460,13 +460,13 @@ static int ext4_valid_extent_entries(str
 
 			/* Check for overlapping index extents */
 			lblock = le32_to_cpu(ext_idx->ei_block);
-			if ((lblock <= prev) && prev) {
+			if (lblock < cur) {
 				*pblk = ext4_idx_pblock(ext_idx);
 				return 0;
 			}
 			ext_idx++;
 			entries--;
-			prev = lblock;
+			cur = lblock + 1;
 		}
 	}
 	return 1;


