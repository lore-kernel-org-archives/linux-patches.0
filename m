Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C534625DD15;
	Tue, 11 Mar 2025 15:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705561; cv=none; b=t0VXkKqDTsDxEPCl+hKZcTJ99rv7AnI6rr9I9X5soNdRQfufP4AHqUDjyDa0rFS8b1yYjNgdgzHZrGqFzOPZgc75wWM8PMJozn1OXW+OEZOZLtmxT9qm0QwqGt18s0eekWDaSHamjLOz+2thf1ryObvz0qmvt3+5w2iN+zYsK74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705561; c=relaxed/simple;
	bh=McSY4pxcotu1gGKEwe7bApoNosSgKB+18sdNDAYO9Dc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q/RcrKylzl0HgXMt6quODrHlN6LA3NC0MR3sQ/Na+mfu3SH6OYKPl85B0eXAdJK4lxFWR4O70ff0KAVaTkHGBfCQi9GfhjhPnJNqD10ud3mMDLpuk58JAlaehXwyWJUjZaUQD5+eSMDjQ0UE9gPEWWVjVw2phv5Y1IAYkHSQ8tM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jOhoSFvW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jOhoSFvW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B165C4CEE9;
	Tue, 11 Mar 2025 15:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705561;
	bh=McSY4pxcotu1gGKEwe7bApoNosSgKB+18sdNDAYO9Dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jOhoSFvWHM3uhE2kvIUwnD2ggtOf6tNSoaro00h4mFwyW7uavrhhtYKJATMBGDzTW
	 dHJy8dqRQWSY/7MsHkLzOIRozu0DfCLRRAOz9MNaAkTpE9ZJgoiK2Q6hECDNOkDe9o
	 wczzn4iPMmrOChO+n9gKZ2K5s3G+Xh5i+/KkzUZE=
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
Subject: [PATCH 5.4 058/328] ocfs2: mark dquot as inactive if failed to start trans while releasing dquot
Date: Tue, 11 Mar 2025 15:57:08 +0100
Message-ID: <20250311145717.201836095@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 1ce3780e8b499..742bf103d2eb2 100644
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



