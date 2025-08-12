Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8A11D416C;
	Tue, 12 Aug 2025 18:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022793; cv=none; b=UCWSAUIYp3qZmKbqL7J0glo6j1RRFAcrzepvlX3Z3d4qQTTOZyinIGgnkR8hsu3nmpcwQQNzhkwpsKa67glp7pHOYXY+IVO2HOSqJE0ZczJCuyKdTaXJjajLUOjxDN5IChmKDcHAQjbAxjx98sRinEBVh4o9GTEWr6Ky+egZfNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022793; c=relaxed/simple;
	bh=tbhTJHZkRsNEBCcBhRpvfTYUCdGhpdyD9UfrKmAE0k0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TbzG8CMEakuvOMl4LUgH+JaN1oKOPyh2YX1TphvJfS/4jUmeCQjH2mYv/azRoXQOrVVQJEXJVlfVtknmmrWp8xwO+Q0P/UQCIimhnKMQo18kuPlDW8XbY4vpRwQ+SzCLpxeuUg+SuNx3Jwx/0LiLjegrdWSuSF2SsROLT6Xvo1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=07g5//oi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="07g5//oi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EC9DC4CEF6;
	Tue, 12 Aug 2025 18:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022793;
	bh=tbhTJHZkRsNEBCcBhRpvfTYUCdGhpdyD9UfrKmAE0k0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=07g5//oi1+4vH0BsoPcFiNsurhnBfdIwpFPmnw1MkPHCg9OiqNMxeUFkioguSFUc6
	 ecYJrObJjHou42sbd0QOHpF1mm7DYQetr/xWZYpRvIcJyAi8G+9F/L/R6TB+5KSz36
	 +etrs5kmVqPEf9hFuQZRHwWr2jslkP7I0Kk/i0Bg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 261/369] f2fs: fix to calculate dirty data during has_not_enough_free_secs()
Date: Tue, 12 Aug 2025 19:29:18 +0200
Message-ID: <20250812173024.582699431@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit e194e140ab7de2ce2782e64b9e086a43ca6ff4f2 ]

In lfs mode, dirty data needs OPU, we'd better calculate lower_p and
upper_p w/ them during has_not_enough_free_secs(), otherwise we may
encounter out-of-space issue due to we missed to reclaim enough
free section w/ foreground gc.

Fixes: 36abef4e796d ("f2fs: introduce mode=lfs mount option")
Cc: Daeho Jeong <daehojeong@google.com>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index 7d7d709b55ff..f8f94301350c 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -626,8 +626,7 @@ static inline void __get_secs_required(struct f2fs_sb_info *sbi,
 	unsigned int dent_blocks = total_dent_blocks % CAP_BLKS_PER_SEC(sbi);
 	unsigned int data_blocks = 0;
 
-	if (f2fs_lfs_mode(sbi) &&
-		unlikely(is_sbi_flag_set(sbi, SBI_CP_DISABLED))) {
+	if (f2fs_lfs_mode(sbi)) {
 		total_data_blocks = get_pages(sbi, F2FS_DIRTY_DATA);
 		data_secs = total_data_blocks / CAP_BLKS_PER_SEC(sbi);
 		data_blocks = total_data_blocks % CAP_BLKS_PER_SEC(sbi);
-- 
2.39.5



