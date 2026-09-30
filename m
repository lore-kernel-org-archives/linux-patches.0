Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F65E5275B5;
	Wed, 30 Sep 2026 17:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790057; cv=none; b=mnfPf5G/By0yKNfYSvLhn3LoV4lRxQOxJzwMOCcF8EUtuXbBuOO7J6HNm9napnMbdTa2ACo3DBVjPzAIbVf35ySf/4SUWFLwzs1ahd6SpMcPPk6/WA888WIhYDpzfdvKTZiWrDH1TzsPkiJqmyi6n2VtZqmvW0bE88rF6wIzmDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790057; c=relaxed/simple;
	bh=wbxlC4j5NqXELvN0AxhUSPxUoHtgftA0P+hAfPwjc/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I6VzijsV3ba2Vo5AwgmuSGvaI3KJWV5LEyq6DX+F38TKQcDev6ZMiPad1dshBBGrSG4uQCOwx9r1pT4XfxpNJMpk/MVnjMSl+MnDY8qpmDsZy6rP3hzuDX1PN6mTGZEbG+DABDBTGADvH/a8usD7sX4wmdz67NJcpwGvlpGQ0Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jitcDycF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jitcDycF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9D2B1F000FF;
	Wed, 30 Sep 2026 17:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790056;
	bh=zKB84UQuI0zyPwAn2awzwq6ri3M48wkKWWXo5/YlrPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jitcDycFSHv/eaJgsNcgLB/G3DcdESFCfIIeOpU/xUzZKcOvqncudaPE7kI02LHGw
	 zHal7jj4WBBzhkp4jN2aBkzf35pPd2uE1/wFLRb1chRe1qNJutf3zji0LGCERxIl2y
	 ML2ybE0JnJEqaWTjMKjrOpp5fkg3J5DM+72A6eXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Sunmin Jeong <s_min.jeong@samsung.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 696/877] f2fs: accurately adjust free_sections during free_segment_range
Date: Wed, 30 Sep 2026 17:26:47 +0200
Message-ID: <20260930152429.698074586@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Daeho Jeong <daehojeong@google.com>

[ Upstream commit 8c963d1738fdca400082ff5f9d99e083de4f4e70 ]

In free_segment_range(), MAIN_SECS(sbi) is temporarily reduced by `secs`
to restrict block allocation to the safe remaining main area while valid
blocks in the truncated range are evacuated by GC.

However, FREE_I(sbi)->free_sections tracks the total number of free
sections across the whole filesystem. If any sections within the
truncated range were already free upon entering free_segment_range(),
failing to deduct them from free_sections causes the filesystem to
overestimate available free sections in the active, reduced main area.
This leads to inconsistent free section accounting during GC data
migration and can trigger unexpected allocation failures or assertion
errors when space is tight.

Fix this by calculating the number of already-free sections in the
truncated range, deducting them from free_sections upon entering
free_segment_range(), and restoring them on exit.

Fixes: b4b10061ef98 ("f2fs: refactor resize_fs to avoid meta updates in progress")
Cc: stable@vger.kernel.org
Signed-off-by: Daeho Jeong <daehojeong@google.com>
Signed-off-by: Sunmin Jeong <s_min.jeong@samsung.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
[ retained gc_mode and gc_type declarations needed by the older inline GC reset logic. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/gc.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -2144,8 +2144,9 @@ int f2fs_gc_range(struct f2fs_sb_info *s
 static int free_segment_range(struct f2fs_sb_info *sbi,
 				unsigned int secs, bool dry_run)
 {
-	unsigned int next_inuse, start, end;
+	unsigned int secno, next_inuse, start, end, end_secno;
 	struct cp_control cpc = { CP_RESIZE, 0, 0, 0 };
+	unsigned int freed_secs = 0;
 	int gc_mode, gc_type;
 	int err = 0;
 	int type;
@@ -2154,6 +2155,7 @@ static int free_segment_range(struct f2f
 	MAIN_SECS(sbi) -= secs;
 	start = MAIN_SECS(sbi) * SEGS_PER_SEC(sbi);
 	end = MAIN_SEGS(sbi) - 1;
+	end_secno = GET_SEC_FROM_SEG(sbi, end);
 
 	mutex_lock(&DIRTY_I(sbi)->seglist_lock);
 	for (gc_mode = 0; gc_mode < MAX_GC_POLICY; gc_mode++)
@@ -2165,6 +2167,14 @@ static int free_segment_range(struct f2f
 			sbi->next_victim_seg[gc_type] = NULL_SEGNO;
 	mutex_unlock(&DIRTY_I(sbi)->seglist_lock);
 
+	spin_lock(&FREE_I(sbi)->segmap_lock);
+	for (secno = MAIN_SECS(sbi); secno <= end_secno; secno++) {
+		if (!test_bit(secno, FREE_I(sbi)->free_secmap))
+			freed_secs++;
+	}
+	FREE_I(sbi)->free_sections -= freed_secs;
+	spin_unlock(&FREE_I(sbi)->segmap_lock);
+
 	/* Move out cursegs from the target range */
 	for (type = CURSEG_HOT_DATA; type < NR_CURSEG_TYPE; type++) {
 		err = f2fs_allocate_segment_for_resize(sbi, type, start, end);
@@ -2189,6 +2199,9 @@ static int free_segment_range(struct f2f
 		f2fs_bug_on(sbi, 1);
 	}
 out:
+	spin_lock(&FREE_I(sbi)->segmap_lock);
+	FREE_I(sbi)->free_sections += freed_secs;
+	spin_unlock(&FREE_I(sbi)->segmap_lock);
 	MAIN_SECS(sbi) += secs;
 	return err;
 }


