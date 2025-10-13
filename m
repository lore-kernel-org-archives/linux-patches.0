Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E53930C614;
	Mon, 13 Oct 2025 15:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368240; cv=none; b=rdYtBoFce2YQkyaojtohJ8FfB++wCw0lQdoH81VRZwn4+qUP00h+q6EcdoSPkChqk1bDVta+9fu1aAJpI1c/tcSJbyPr+IhdT2kQLLLH6ammWg1NJVJDqaVSX/GKOBpEI9O7VdMdZJg01G4/ShmFPR/ZA8ls8cCrN2K+DHWzvf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368240; c=relaxed/simple;
	bh=1epM/zyXAKlkXBB2VaSlwjmm2W99oypffgxQglBji2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pnA88JdWvfnEDSOVDhUWSvfcBGnJoUVikawZxtuxhN6ufh8s4iGHSbX+4Bgn4c+WvaAnpPFHVSv92m/Bv7CG0DrpQXMEv+34fyM6EnCAITO/CHUvaP+yMO9Qq2uXDHwPnubdW4VLm/uvPB48h2fl//f5FG/ESDlGjZLlcWO6vxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=euTE0LCT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="euTE0LCT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E522CC4CEFE;
	Mon, 13 Oct 2025 15:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368240;
	bh=1epM/zyXAKlkXBB2VaSlwjmm2W99oypffgxQglBji2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=euTE0LCTxS9latSXNk76mUjLohhHKwWzSGacJ6HrI1n4jFj0DV4o3eOlLuAQou2Er
	 gplZz57L3gyjBN69pvb51wPdi7/TdfrJDBXYV+fnXlV2WV3sFSBpIoqxDiS+mPM/SE
	 h12HOEu52qL+QgVz2N8GGpNIwMEaU3mg73E3SHvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 092/262] f2fs: fix condition in __allow_reserved_blocks()
Date: Mon, 13 Oct 2025 16:43:54 +0200
Message-ID: <20251013144329.441871825@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2dec22f2ea639..0d3ef487f72ac 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -2331,8 +2331,6 @@ static inline bool __allow_reserved_blocks(struct f2fs_sb_info *sbi,
 {
 	if (!inode)
 		return true;
-	if (!test_opt(sbi, RESERVE_ROOT))
-		return false;
 	if (IS_NOQUOTA(inode))
 		return true;
 	if (uid_eq(F2FS_OPTION(sbi).s_resuid, current_fsuid()))
@@ -2353,7 +2351,7 @@ static inline unsigned int get_available_block_count(struct f2fs_sb_info *sbi,
 	avail_user_block_count = sbi->user_block_count -
 					sbi->current_reserved_blocks;
 
-	if (!__allow_reserved_blocks(sbi, inode, cap))
+	if (test_opt(sbi, RESERVE_ROOT) && !__allow_reserved_blocks(sbi, inode, cap))
 		avail_user_block_count -= F2FS_OPTION(sbi).root_reserved_blocks;
 
 	if (unlikely(is_sbi_flag_set(sbi, SBI_CP_DISABLED))) {
-- 
2.51.0



