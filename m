Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5421E17A2FE;
	Wed, 19 Feb 2025 09:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956523; cv=none; b=nRLJkjXSf2UJjhdD8Iulm9H+zDyhEB2izlf28CVPozg07G9mRgyud6TBGlDtMH03iTg3hnZoEMiFLYQB1oVJwaxKrcCNePnS05uGU6kM3TRod77D1Ama/56juCv1/QJAXNEXIxd6UoAv/7l2Ixob+t2L2l3NledecRosV60V/CA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956523; c=relaxed/simple;
	bh=sXfv+yVXqXQyYuzbqtSozsK3ZQor9pmpDqlG7A7oPTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R5Gmy8beVbSsIQit9fRGRyYjkT6Jm4e9hMaI2wn3qgo/J2c+R8h2Np8V9BkWJMf9Hy/IlbPrfOCMLwE36c4pze188hmiA9pJmCbDbyvdj4NKwfWWONh70BNf5y+w6dZZY4lHF1BwO7YNdFDm0g4GfouO8Me+Nh4PVMOWKl1mgNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LSun7rxC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LSun7rxC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71211C4CEE6;
	Wed, 19 Feb 2025 09:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956522;
	bh=sXfv+yVXqXQyYuzbqtSozsK3ZQor9pmpDqlG7A7oPTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LSun7rxCQWDwasF5eqGVFuA5cqgO8stt9YivH657VsMcs5G8lPKnqQlXKceG0kd+G
	 yLRWFUxFUIVTUQrRYJHw5RT2HcE4KTR+B2ZWzwzEUWZ5KCciQsj+I7GMF/Rnb26zQO
	 Nf84HDHa9HEbvsKJViLv/Dtk3oJb9k00aoPVsUEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Yue <glass.su@suse.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 206/578] ocfs2: mark dquot as inactive if failed to start trans while releasing dquot
Date: Wed, 19 Feb 2025 09:23:30 +0100
Message-ID: <20250219082701.159365275@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Su Yue <glass.su@suse.com>

[ Upstream commit 276c61385f6bc3223a5ecd307cf4aba2dfbb9a31 ]

While running fstests generic/329, the kernel workqueue
quota_release_workfn is dead looping in calling ocfs2_release_dquot().
The ocfs2 state is already readonly but ocfs2_release_dquot wants to
start a transaction but fails and returns.

=====================================================================
[ 2918.123602 ][  T275 ] On-disk corruption discovered. Please run
fsck.ocfs2 once the filesystem is unmounted.
[ 2918.124034 ][  T275 ] (kworker/u135:1,275,11):ocfs2_release_dquot:765
ERROR: status = -30
[ 2918.124452 ][  T275 ] (kworker/u135:1,275,11):ocfs2_release_dquot:795
ERROR: status = -30
[ 2918.124883 ][  T275 ] (kworker/u135:1,275,11):ocfs2_start_trans:357
ERROR: status = -30
[ 2918.125276 ][  T275 ] OCFS2: abort (device dm-0): ocfs2_start_trans:
Detected aborted journal
[ 2918.125710 ][  T275 ] On-disk corruption discovered. Please run
fsck.ocfs2 once the filesystem is unmounted.
=====================================================================

ocfs2_release_dquot() is much like dquot_release(), which is called by
ext4 to handle similar situation.  So here fix it by marking the dquot as
inactive like what dquot_release() does.

Link: https://lkml.kernel.org/r/20250106140653.92292-1-glass.su@suse.com
Fixes: 9e33d69f553a ("ocfs2: Implementation of local and global quota file handling")
Signed-off-by: Su Yue <glass.su@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/quota_global.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index 0dffd6a44d39d..24b031dc44ee1 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -749,6 +749,11 @@ static int ocfs2_release_dquot(struct dquot *dquot)
 	handle = ocfs2_start_trans(osb,
 		ocfs2_calc_qdel_credits(dquot->dq_sb, dquot->dq_id.type));
 	if (IS_ERR(handle)) {
+		/*
+		 * Mark dquot as inactive to avoid endless cycle in
+		 * quota_release_workfn().
+		 */
+		clear_bit(DQ_ACTIVE_B, &dquot->dq_flags);
 		status = PTR_ERR(handle);
 		mlog_errno(status);
 		goto out_ilock;
-- 
2.39.5



