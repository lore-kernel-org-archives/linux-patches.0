Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45C0B481D7;
	Mon,  1 Apr 2024 16:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989412; cv=none; b=KirKK8NETj+aohSS6M/Crz+xOABGS5/N2gLtVTuGwDRNqBh209U3eG5jbg/Vyoxm70QcgpVx8Dog0Krzf931tZ0MKBr6EnXzqPFOlwWBkV7m2zFyE/yfPa4spljUXZ2bPNdO4tqhSfXEhzrvo53bZrd4Jw2ek8nHiqHVnBitYRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989412; c=relaxed/simple;
	bh=GhJHPcDGxWR6R128J92y7074dw3sbm3gjCnsfxq+G3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k10z00j3/a307cppTyz/duTwVcsUJrhW/dRAJ81uJNkSID2uSr2DsMFvazzG5yXleIWZjp+y4g2nrVfhMiLlJPwtisJhbbLpHYGKzTFbrnSv0FAX1HWAvCOPiGk9QzQfIe5yDqfMvTVCydfVs+krVb8ZvFdtyyAybe2uF6D5tSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=scOzdKyY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="scOzdKyY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52AB7C433F1;
	Mon,  1 Apr 2024 16:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989411;
	bh=GhJHPcDGxWR6R128J92y7074dw3sbm3gjCnsfxq+G3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=scOzdKyYlzP/IP8rIu6gx3ew5KCTvDABTr7XcHTLLc7A0ioUQHnjn+GwPJbNYNumO
	 cuxET1WLsMXYoe5ZvlouWkZznJtohjbHscxvcVgIVAMifQMC2VFnZA2j98yuzuJZ7L
	 9pgiyiMzuGwGdX3i3ADsZLawiDEsCKqmaW39i6fU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	yangerkun <yangerkun@huawei.com>,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 041/396] ext4: correct best extent lstart adjustment logic
Date: Mon,  1 Apr 2024 17:41:30 +0200
Message-ID: <20240401152549.154735132@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit 4fbf8bc733d14bceb16dda46a3f5e19c6a9621c5 ]

When yangerkun review commit 93cdf49f6eca ("ext4: Fix best extent lstart
adjustment logic in ext4_mb_new_inode_pa()"), it was found that the best
extent did not completely cover the original request after adjusting the
best extent lstart in ext4_mb_new_inode_pa() as follows:

  original request: 2/10(8)
  normalized request: 0/64(64)
  best extent: 0/9(9)

When we check if best ex can be kept at start of goal, ac_o_ex.fe_logical
is 2 less than the adjusted best extent logical end 9, so we think the
adjustment is done. But obviously 0/9(9) doesn't cover 2/10(8), so we
should determine here if the original request logical end is less than or
equal to the adjusted best extent logical end.

In addition, add a comment stating when adjusted best_ex will not cover
the original request, and remove the duplicate assertion because adjusting
lstart makes no change to b_ex.fe_len.

Link: https://lore.kernel.org/r/3630fa7f-b432-7afd-5f79-781bc3b2c5ea@huawei.com
Fixes: 93cdf49f6eca ("ext4: Fix best extent lstart adjustment logic in ext4_mb_new_inode_pa()")
Cc:  <stable@kernel.org>
Signed-off-by: yangerkun <yangerkun@huawei.com>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Link: https://lore.kernel.org/r/20240201141845.1879253-1-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index ea5ac2636632b..257b70c5ded45 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -5184,10 +5184,16 @@ ext4_mb_new_inode_pa(struct ext4_allocation_context *ac)
 			.fe_len = ac->ac_orig_goal_len,
 		};
 		loff_t orig_goal_end = extent_logical_end(sbi, &ex);
+		loff_t o_ex_end = extent_logical_end(sbi, &ac->ac_o_ex);
 
-		/* we can't allocate as much as normalizer wants.
-		 * so, found space must get proper lstart
-		 * to cover original request */
+		/*
+		 * We can't allocate as much as normalizer wants, so we try
+		 * to get proper lstart to cover the original request, except
+		 * when the goal doesn't cover the original request as below:
+		 *
+		 * orig_ex:2045/2055(10), isize:8417280 -> normalized:0/2048
+		 * best_ex:0/200(200) -> adjusted: 1848/2048(200)
+		 */
 		BUG_ON(ac->ac_g_ex.fe_logical > ac->ac_o_ex.fe_logical);
 		BUG_ON(ac->ac_g_ex.fe_len < ac->ac_o_ex.fe_len);
 
@@ -5199,7 +5205,7 @@ ext4_mb_new_inode_pa(struct ext4_allocation_context *ac)
 		 * 1. Check if best ex can be kept at end of goal (before
 		 *    cr_best_avail trimmed it) and still cover original start
 		 * 2. Else, check if best ex can be kept at start of goal and
-		 *    still cover original start
+		 *    still cover original end
 		 * 3. Else, keep the best ex at start of original request.
 		 */
 		ex.fe_len = ac->ac_b_ex.fe_len;
@@ -5209,7 +5215,7 @@ ext4_mb_new_inode_pa(struct ext4_allocation_context *ac)
 			goto adjust_bex;
 
 		ex.fe_logical = ac->ac_g_ex.fe_logical;
-		if (ac->ac_o_ex.fe_logical < extent_logical_end(sbi, &ex))
+		if (o_ex_end <= extent_logical_end(sbi, &ex))
 			goto adjust_bex;
 
 		ex.fe_logical = ac->ac_o_ex.fe_logical;
@@ -5217,7 +5223,6 @@ ext4_mb_new_inode_pa(struct ext4_allocation_context *ac)
 		ac->ac_b_ex.fe_logical = ex.fe_logical;
 
 		BUG_ON(ac->ac_o_ex.fe_logical < ac->ac_b_ex.fe_logical);
-		BUG_ON(ac->ac_o_ex.fe_len > ac->ac_b_ex.fe_len);
 		BUG_ON(extent_logical_end(sbi, &ex) > orig_goal_end);
 	}
 
-- 
2.43.0



