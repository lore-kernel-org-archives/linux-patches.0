Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99BE92B9C7;
	Sun,  1 Sep 2024 16:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208889; cv=none; b=XWE57o1PjRGlni4lA8U/3thzZffCemvbZRjA8Lj++ZRBKTlkY3V5HS6sP2y22joxwV/yUW4iyDS3bOBb1m4Uyhk3PBlzb47VoqJjAkJHiPCMpSssp7KbYu40C2mzweZBQZm5Eb7dap4AM8bhbwSot8izc8kBlgFzlus9VVxrA/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208889; c=relaxed/simple;
	bh=WRU8RP/ZGjYZED8A4xue+6K4BkqqTGT07nYaLsqskZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rpuLfbwvEp1e3K9IZYeqpficJP8RjYbZ6ooYpGCN+3VqNnQ1432BoO1PNsSe2rlKZFl25wBJ2exJG38Uiy/9J1QifE8dzsK/rDeg2GEHBAvVw5L9kuzHTHKhQtfmvBvLk5yVFLnqWaxSReNNuhsb6HPYGbr3/lXm2r18ZSQiUEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IflE0XPR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IflE0XPR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 168A9C4CEC3;
	Sun,  1 Sep 2024 16:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208889;
	bh=WRU8RP/ZGjYZED8A4xue+6K4BkqqTGT07nYaLsqskZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IflE0XPRrWLkfl/h/H10OPYJejDWrizcLUiHlRjTPkKqFUTFT4fWkmdyFwicxLdY5
	 7Ov62cisNUUxDbpCnITWKlbt1QTYSyjG584z46ljNtEaLdeVFvgNHu6O4YBuPqYzS8
	 a5jb2jKkIeMzIttb2OV8WzNMPqgDNny5+JZqmG9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 071/134] ext4: set the type of max_zeroout to unsigned int to avoid overflow
Date: Sun,  1 Sep 2024 18:16:57 +0200
Message-ID: <20240901160812.773764064@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

[ Upstream commit 261341a932d9244cbcd372a3659428c8723e5a49 ]

The max_zeroout is of type int and the s_extent_max_zeroout_kb is of
type uint, and the s_extent_max_zeroout_kb can be freely modified via
the sysfs interface. When the block size is 1024, max_zeroout may
overflow, so declare it as unsigned int to avoid overflow.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20240319113325.3110393-9-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/extents.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 90b12c7c0f20a..fed3dfed2c249 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3591,9 +3591,10 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 	struct ext4_extent *ex, *abut_ex;
 	ext4_lblk_t ee_block, eof_block;
 	unsigned int ee_len, depth, map_len = map->m_len;
-	int allocated = 0, max_zeroout = 0;
 	int err = 0;
 	int split_flag = EXT4_EXT_DATA_VALID2;
+	int allocated = 0;
+	unsigned int max_zeroout = 0;
 
 	ext_debug("ext4_ext_convert_to_initialized: inode %lu, logical"
 		"block %llu, max_blocks %u\n", inode->i_ino,
-- 
2.43.0



