Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD411A76BE;
	Tue, 30 Jul 2024 17:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360599; cv=none; b=TLvob88dLDD6uSFL51VDoBBfw9MPtpoDWZzAllEdtk3OCP5EzZfVsCGLwBVYbSAPhco8vPzCMmLwCpLxndJfwaMEs331jTSQMFBix6q4edIzKr0/NLzLnJCx21VG9k7neavLwkb0xrLJEIrZ2PL4cUbtxtX2ytGCTiiYi1hVQ64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360599; c=relaxed/simple;
	bh=7uxjgYRn8MpGc4mOEydyjddqBJaKWHaW4ra7JxQRgak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=adDzPtXNChEt79vT2gkmnoQUh51aA1mCcAIjom/2P330HjmHN7XIo48/ygl9YKIa2kf2GM3yfBWYcaWeSQP/O+ciOLo3qVIpdQcEuPSOl+V7Gp4tdFKve84zds2mLOKGHlb122JYLrQDGVnNz3W1Lv0iuGRxfBnjZM/m24MSjFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ddm69TEu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ddm69TEu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F2C8C32782;
	Tue, 30 Jul 2024 17:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360598;
	bh=7uxjgYRn8MpGc4mOEydyjddqBJaKWHaW4ra7JxQRgak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ddm69TEuLvdCFh7bvCqzOBsqn46UjpCMrf/Ikq1ovVvTno768xJA8Q33X3wdVHG+1
	 aEO1USkuWX02/ON2/MkmTOFMiH/mTCylqZqkyGza3Ug5BX50dO/GhLRh9L1AbFvV/q
	 lh01rx0qqzlQhimx86xUI8fbL86ev2eHwIm9r+Xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sheng Yong <shengyong@oppo.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 748/809] f2fs: fix start segno of large section
Date: Tue, 30 Jul 2024 17:50:24 +0200
Message-ID: <20240730151754.500805306@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sheng Yong <shengyong@oppo.com>

[ Upstream commit 8c409989678e92e4a737e7cd2bb04f3efb81071a ]

get_ckpt_valid_blocks() checks valid ckpt blocks in current section.
It counts all vblocks from the first to the last segment in the
large section. However, START_SEGNO() is used to get the first segno
in an SIT block. This patch fixes that to get the correct start segno.

Fixes: 61461fc921b7 ("f2fs: fix to avoid touching checkpointed data in get_victim()")
Signed-off-by: Sheng Yong <shengyong@oppo.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index e1c0f418aa11f..bfc01a521cb98 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -347,7 +347,8 @@ static inline unsigned int get_ckpt_valid_blocks(struct f2fs_sb_info *sbi,
 				unsigned int segno, bool use_section)
 {
 	if (use_section && __is_large_section(sbi)) {
-		unsigned int start_segno = START_SEGNO(segno);
+		unsigned int secno = GET_SEC_FROM_SEG(sbi, segno);
+		unsigned int start_segno = GET_SEG_FROM_SEC(sbi, secno);
 		unsigned int blocks = 0;
 		int i;
 
-- 
2.43.0



