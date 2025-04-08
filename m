Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D9B26656B;
	Tue,  8 Apr 2025 11:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110785; cv=none; b=J0Mrz/zWn/BxRRmq7fT0irSmHMjpEnSRGfgjuXnEeAmhLAURD8Lbxhibru+VJgBlKQ7Ub/N5yQ8c3OLMui7pVpV+MDETXGXjvzpRFdKj9+1IVVgFGS8ozWfZryi9WYsvQMCpRwPyBJfVbIGAovuVKfO7f85XjwTyvaPMPGEOhWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110785; c=relaxed/simple;
	bh=axXOm+AkryL76qRNhBhqadc84z08i0a0GjYQGKdW9wM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ayifAeyhPQEcu2HN3XjPMADJPPitzQY6gxBS1/7+itg+SCze9/507Xinf84WvZAJSj5WdP6kdSLBEU7tFrdE8zGkbtoJvlWXGkD+AtkcAn/hIuuxT3qI627UuYTDbVy55EM96fNOgwpnxnOEsnMM3NaEL2OV36RcN2EAEt1munM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gEyCYSYs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gEyCYSYs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57A39C4CEE5;
	Tue,  8 Apr 2025 11:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110785;
	bh=axXOm+AkryL76qRNhBhqadc84z08i0a0GjYQGKdW9wM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gEyCYSYsJ57bcGsBLxqSXMb+68jNKob3gcqxB2E+L+9h/2htOsqLTFCWkxQOVZ/2w
	 TQfkYNeDW4vrXXs27EukHVS6Ii6mYl6Vg/cPauBAxx0U9kLX39NZljqLzGlBT+ea/Q
	 j1N6HEzfWkhciv/rUzdkVWDIBXyZ/+pFaHGnnLlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chunhai Guo <guochunhai@vivo.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 193/731] f2fs: fix missing discard for active segments
Date: Tue,  8 Apr 2025 12:41:30 +0200
Message-ID: <20250408104918.769845066@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chunhai Guo <guochunhai@vivo.com>

[ Upstream commit 21263d035ff21fa0ccf79adba20bab9cd8cca0f2 ]

During a checkpoint, the current active segment X may not be handled
properly. This occurs when segment X has 0 valid blocks and a non-zero
number of discard blocks, for the following reasons:

locate_dirty_segment() does not mark any active segment as a prefree
segment. As a result, segment X is not included in dirty_segmap[PRE], and
f2fs_clear_prefree_segments() skips it when handling prefree segments.

add_discard_addrs() skips any segment with 0 valid blocks, so segment X is
also skipped.

Consequently, no `struct discard_cmd` is actually created for segment X.
However, the ckpt_valid_map and cur_valid_map of segment X are synced by
seg_info_to_raw_sit() during the current checkpoint process. As a result,
it cannot find the missing discard bits even in subsequent checkpoints.
Consequently, the value of sbi->discard_blks remains non-zero. Thus, when
f2fs is umounted, CP_TRIMMED_FLAG will not be set due to the non-zero
sbi->discard_blks.

Relevant code process:

f2fs_write_checkpoint()
    f2fs_flush_sit_entries()
         list_for_each_entry_safe(ses, tmp, head, set_list) {
             for_each_set_bit_from(segno, bitmap, end) {
                 ...
                 add_discard_addrs(sbi, cpc, false); // skip segment X due to its 0 valid blocks
                 ...
                 seg_info_to_raw_sit(); // sync ckpt_valid_map with cur_valid_map for segment X
                 ...
             }
         }
    f2fs_clear_prefree_segments(); // segment X is not included in dirty_segmap[PRE] and is skipped

This issue is easy to reproduce with the following operations:

root # mkfs.f2fs -f /dev/f2fs_dev
root # mount -t f2fs /dev/f2fs_dev /mnt_point
root # dd if=/dev/blk_dev of=/mnt_point/1.bin bs=4k count=256
root # sync
root # rm /mnt_point/1.bin
root # umount /mnt_point
root # dump.f2fs /dev/f2fs_dev | grep "checkpoint state"
Info: checkpoint state = 45 :  crc compacted_summary unmount ---- 'trimmed' flag is missing

Since add_discard_addrs() can handle active segments with non-zero valid
blocks, it is reasonable to fix this issue by allowing it to also handle
active segments with 0 valid blocks.

Fixes: b29555505d81 ("f2fs: add key functions for small discards")
Signed-off-by: Chunhai Guo <guochunhai@vivo.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 2b415926641f0..384bca002ec9a 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -2096,7 +2096,9 @@ static bool add_discard_addrs(struct f2fs_sb_info *sbi, struct cp_control *cpc,
 		return false;
 
 	if (!force) {
-		if (!f2fs_realtime_discard_enable(sbi) || !se->valid_blocks ||
+		if (!f2fs_realtime_discard_enable(sbi) ||
+			(!se->valid_blocks &&
+				!IS_CURSEG(sbi, cpc->trim_start)) ||
 			SM_I(sbi)->dcc_info->nr_discards >=
 				SM_I(sbi)->dcc_info->max_discards)
 			return false;
-- 
2.39.5



