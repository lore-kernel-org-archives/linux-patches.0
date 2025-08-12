Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 884762FF16F;
	Tue, 12 Aug 2025 18:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021635; cv=none; b=UOZUTGtm5DdPNHdTRAT5UetWqbOrXPhg6C2R8NDGWuuHVxZR+4o9vkMT0Vs7lJsY17YQOsMduYzjc+R71JbI+oOy3lCYvJ/9cYE6x8zJAZk+dlYVTO9gu4H0qRY5CJWf30/4ZXqHWUN04Y7AOW+dOd5o/mV77+kshKSQnwaIX4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021635; c=relaxed/simple;
	bh=zhfEiJ1bYdfx2IDH7IjVJxxrrPdea/nLBvXdQlP5Q5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MmVUpr58zyeNCLlwm/EIhh5rat3zrOLtw9v6yAmqBkm4KLbhfDKfMzoQtPM/KOlvO2cJl/aLCCrxml97a5ZoYrd3aSt5NaWS2g08z81NFwcl7/W44/e9wotqgGZ9NiF6gAIwGvBPZqg7oRh+AopX+j9vXPDufxn5l0H/kmvz+0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z9GmcMor; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z9GmcMor"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 963D2C4CEF1;
	Tue, 12 Aug 2025 18:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021635;
	bh=zhfEiJ1bYdfx2IDH7IjVJxxrrPdea/nLBvXdQlP5Q5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z9GmcMor8t+aJ6t4MOUxeFBS2os30A795yimRBWy78unrFDtsP0EkI81gWNoB/DWQ
	 OHzk03i8aC3Syfw+u2uR9txaEzCNpxDuyZIty8k+TDFPIOIJ41qRDopVx2cdFHyB/b
	 SWimMIArqXCksaYkssf1+leBa3vDw5oqGML9Xm0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 179/262] f2fs: fix to calculate dirty data during has_not_enough_free_secs()
Date: Tue, 12 Aug 2025 19:29:27 +0200
Message-ID: <20250812173000.745486409@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 66b89687fab1..a51a56bd0b61 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -606,8 +606,7 @@ static inline void __get_secs_required(struct f2fs_sb_info *sbi,
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



