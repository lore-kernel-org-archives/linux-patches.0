Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E0D430ACEA;
	Mon, 13 Oct 2025 15:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367716; cv=none; b=gflc96AwkNdWm1/fWpe5GDKducyEtud73sHv9YDkIIXBxYkPniQW4CwVXjzxY3V9OEUsi3Oc/inklcwx4nc+TwzUHIOJggaTnJPb/lxpsz2DwFozUeF3ldUr8dXmrEkve4AKGFlQJ/WIRitk41PfLjF2QQvoZyXFIa2qObF3wQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367716; c=relaxed/simple;
	bh=fOnjbeODVetse5ljQwi61eDC2coiM6k4NbWHor4W6uY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tG1UgpaE13unEU+Os43fjbw8wyDDKcbTmtxojgUctvdtxAkxl17v/XKAxlxppUEVLX1vZhyQfjj6Q5X4WDkfPQThCgbyLNhElU4fZjtFGtuWAMVNEIq7k4vSmvufOvLf7+aL/cIEM8t9SuVNQgrF9i8hby4wFGqglS9BMjqh4VU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BiYMY8O3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BiYMY8O3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8FA4C4CEE7;
	Mon, 13 Oct 2025 15:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367716;
	bh=fOnjbeODVetse5ljQwi61eDC2coiM6k4NbWHor4W6uY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BiYMY8O3ThkvKnmdMUQpt6NtJqIVPe/vZTU2ZFU1tvrclDSkQfT4BMYYhp7/GYHXv
	 cI2L6cCBIGnDTMZUvPXYYzeXVOX0KT87LVPNtecvXfhwTtmy6PcUOCqU/oXZt30YAW
	 X4wpI8WMStwRxKvTIQb8ibIXuFZDsWD7Wt0kDTsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 064/196] f2fs: fix condition in __allow_reserved_blocks()
Date: Mon, 13 Oct 2025 16:44:15 +0200
Message-ID: <20251013144317.511773764@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit e75ce117905d2830976a289e718470f3230fa30a ]

If reserve_root mount option is not assigned, __allow_reserved_blocks()
will return false, it's not correct, fix it.

Fixes: 7e65be49ed94 ("f2fs: add reserved blocks for root user")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/f2fs.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 7329f706da83c..ab2ddd09d8131 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -2296,8 +2296,6 @@ static inline bool __allow_reserved_blocks(struct f2fs_sb_info *sbi,
 {
 	if (!inode)
 		return true;
-	if (!test_opt(sbi, RESERVE_ROOT))
-		return false;
 	if (IS_NOQUOTA(inode))
 		return true;
 	if (uid_eq(F2FS_OPTION(sbi).s_resuid, current_fsuid()))
@@ -2318,7 +2316,7 @@ static inline unsigned int get_available_block_count(struct f2fs_sb_info *sbi,
 	avail_user_block_count = sbi->user_block_count -
 					sbi->current_reserved_blocks;
 
-	if (!__allow_reserved_blocks(sbi, inode, cap))
+	if (test_opt(sbi, RESERVE_ROOT) && !__allow_reserved_blocks(sbi, inode, cap))
 		avail_user_block_count -= F2FS_OPTION(sbi).root_reserved_blocks;
 
 	if (unlikely(is_sbi_flag_set(sbi, SBI_CP_DISABLED))) {
-- 
2.51.0



