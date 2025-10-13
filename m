Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B83B27815E;
	Mon, 13 Oct 2025 15:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369376; cv=none; b=QDhqgjXlFCbaqKBEahK1t/WUwQetTJXI8AF9YGseYBJ3YEkBTIbl0J/l4UcPlTIEF6S/p0DtydDwdIsMLWQlbHo3bYFVr4CCbCoSC0sBvkAud93CcRdn7VxQ9G2wVH62uR1N8CqzySO+XLjDxIHbAYwdc0m3hOJHwxWbBaO9BJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369376; c=relaxed/simple;
	bh=JVA7CMdvFx3tdkvYvgPJ5ZApbEYta289z5uFcHewUy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WiUeDYSWrLP0DHlnSUhNTUtXJBGrQsC4UC+BM8SEclhBpTwXGU6Fc2572DC/eQkpIT65s0GODq33agYTokN9zuPrz0K/Q1y99mKuLxVBQAdKF9MhAJGs2ggYNilxv+JncJMqvMxak2YO1rDgEvy2axZtN5zIS5Ouum5ZSRxbKFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QuG+ahyw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QuG+ahyw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 173FBC4CEE7;
	Mon, 13 Oct 2025 15:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369376;
	bh=JVA7CMdvFx3tdkvYvgPJ5ZApbEYta289z5uFcHewUy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QuG+ahyw2C5rlYdNfJKzn7d2mHGW3njAxW3jPoqtguv88KVI9ytqpXlzU3LajsyVr
	 hsvep9wBX5quaLiOgdhXLYKhXvcvZ+/1udYECvDC5lohX31/FdxRYgO5Rx058XM3Px
	 YC1JcjrlFHiDdp02wbvpqwSRkeXGYnx1epDXisd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 224/563] f2fs: fix condition in __allow_reserved_blocks()
Date: Mon, 13 Oct 2025 16:41:25 +0200
Message-ID: <20251013144419.395401468@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index b4b62ac46bc64..dac7d44885e47 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -2361,8 +2361,6 @@ static inline bool __allow_reserved_blocks(struct f2fs_sb_info *sbi,
 {
 	if (!inode)
 		return true;
-	if (!test_opt(sbi, RESERVE_ROOT))
-		return false;
 	if (IS_NOQUOTA(inode))
 		return true;
 	if (uid_eq(F2FS_OPTION(sbi).s_resuid, current_fsuid()))
@@ -2383,7 +2381,7 @@ static inline unsigned int get_available_block_count(struct f2fs_sb_info *sbi,
 	avail_user_block_count = sbi->user_block_count -
 					sbi->current_reserved_blocks;
 
-	if (!__allow_reserved_blocks(sbi, inode, cap))
+	if (test_opt(sbi, RESERVE_ROOT) && !__allow_reserved_blocks(sbi, inode, cap))
 		avail_user_block_count -= F2FS_OPTION(sbi).root_reserved_blocks;
 
 	if (unlikely(is_sbi_flag_set(sbi, SBI_CP_DISABLED))) {
-- 
2.51.0



