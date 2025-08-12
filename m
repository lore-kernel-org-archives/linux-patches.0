Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1AB92FF169;
	Tue, 12 Aug 2025 18:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024822; cv=none; b=ntOHcSI+g6lcDCJDAE6pgnn7DlWn5Yz7cnOdBbqZH4+8ylHACfFoHAzVomQj2Qjm2Qt2iztXtHNLVfR3qxwF98pjcS98LktTDAKxN1vsZna+KwsfR99bIvkVCg74cY98GIbp1YxVd182QO4azP0huldPaFJCu1YAu4k9n2Avb00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024822; c=relaxed/simple;
	bh=Rmx03Rz9IZtnGCOmUIEe9J6EgrbaYP2q0qoBSxrjirg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AOhfcGD5D9WhtLdJLb7uqnZecgjRwmmegp6sKi9GAuBpmcG1po2JKK7ftI/sEFmru98CMugx8ytSm1NPErN0BDExDwGjaVFwbs1ZlKMPAHIKdTi4wn0VLYfp5tUT2nVBeR4ByHXZVgRW+T76Abvcb/YBdfVz/xjFLcAGet0gFUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mlIXuO0h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mlIXuO0h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10499C4CEF0;
	Tue, 12 Aug 2025 18:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024822;
	bh=Rmx03Rz9IZtnGCOmUIEe9J6EgrbaYP2q0qoBSxrjirg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mlIXuO0hcQpGFlDdYMGh7HWaxzPiVhFb5BHmbgv6aejheAIFjTnpe34aFjyFN7iAL
	 /JmXglIIe2srJClNSAVjvK/MzDA6fWh9BNu/DEFhC5K/SrsmuSitFOi9djqs7HoByO
	 QqxluYNVIT+ZrcdxGBteG4A5kuveSOjQ2JHGl0g4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 486/627] f2fs: fix to calculate dirty data during has_not_enough_free_secs()
Date: Tue, 12 Aug 2025 19:33:01 +0200
Message-ID: <20250812173444.250935399@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index f11822ec3fec..a8ac5309bd90 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -674,8 +674,7 @@ static inline void __get_secs_required(struct f2fs_sb_info *sbi,
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



