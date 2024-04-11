Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 158101494AA;
	Thu, 11 Apr 2024 10:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831607; cv=none; b=fQ5BMIv2CDirENNH+C7c9Ly0n2atrDe3eB2UmQq+bUvLVYaL8nqOwJBE0vJz5ZOkPFMQgwjUOC7X8Ta/1lC823GkPM767uwwbTU0/rbCP8nCwYqgvub8HXPBLVPNs8H6zdQOLO4hB10ejyz49lVNHbPfqcRUQ3BoZpwqTbRmTZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831607; c=relaxed/simple;
	bh=ZkLaPYJaQM2QotBckkxbm7PXKUHfktbdhFVxsz2iI1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OYtdubyxnlC5uxaa+y/RnYADw0rB3nGWy1jtRzsaOHddrxWilhSEAYFlz8d3/C0YFAUwIh6dF6hZX1C7v7TmPUZhZ3Vpqw2H/3zjmoQnDlgH+gFmuhjD898LMBCx1Wg4G06lhEoF3dP2OHNv+jqE0GO3TYAsSI7ER64EkvPwzwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mj9RH8mB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mj9RH8mB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E51CC433C7;
	Thu, 11 Apr 2024 10:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831606;
	bh=ZkLaPYJaQM2QotBckkxbm7PXKUHfktbdhFVxsz2iI1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mj9RH8mBWd0pMVnSkLoMs4sTQFkAdSCgd4D51BUEcN8x3IJVe1ibXOEq9utUa8I3K
	 Z2DkNoD+zAEfmyHoG8dHlN15gl8TQ1Oh6Xm+Ko5ohtFA/bIRX/sotfOBVYaUIOWpvm
	 IfaXJrAZuvzjfs/UZSrHZFUNlPHyT8Szz5hV3g+g=
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
Subject: [PATCH 5.10 026/294] ext4: correct best extent lstart adjustment logic
Date: Thu, 11 Apr 2024 11:53:09 +0200
Message-ID: <20240411095436.425361896@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 61988b7b5be77..6ce59e2ac2d47 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4162,10 +4162,16 @@ ext4_mb_new_inode_pa(struct ext4_allocation_context *ac)
 			.fe_len = ac->ac_g_ex.fe_len,
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
 
@@ -4177,7 +4183,7 @@ ext4_mb_new_inode_pa(struct ext4_allocation_context *ac)
 		 * 1. Check if best ex can be kept at end of goal and still
 		 *    cover original start
 		 * 2. Else, check if best ex can be kept at start of goal and
-		 *    still cover original start
+		 *    still cover original end
 		 * 3. Else, keep the best ex at start of original request.
 		 */
 		ex.fe_len = ac->ac_b_ex.fe_len;
@@ -4187,7 +4193,7 @@ ext4_mb_new_inode_pa(struct ext4_allocation_context *ac)
 			goto adjust_bex;
 
 		ex.fe_logical = ac->ac_g_ex.fe_logical;
-		if (ac->ac_o_ex.fe_logical < extent_logical_end(sbi, &ex))
+		if (o_ex_end <= extent_logical_end(sbi, &ex))
 			goto adjust_bex;
 
 		ex.fe_logical = ac->ac_o_ex.fe_logical;
@@ -4195,7 +4201,6 @@ ext4_mb_new_inode_pa(struct ext4_allocation_context *ac)
 		ac->ac_b_ex.fe_logical = ex.fe_logical;
 
 		BUG_ON(ac->ac_o_ex.fe_logical < ac->ac_b_ex.fe_logical);
-		BUG_ON(ac->ac_o_ex.fe_len > ac->ac_b_ex.fe_len);
 		BUG_ON(extent_logical_end(sbi, &ex) > orig_goal_end);
 	}
 
-- 
2.43.0



