Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1917101C5;
	Sat,  3 Feb 2024 04:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933396; cv=none; b=mDbGSIYx8PPUXx0m320nGFwBOctEjwpaBYsmzLUe5th1A8I5HDac20DF/BvphBaBQ59fN22pO4WbkhPVYKrGMS4gy053JRmA4cWRhTsUWoIduhKrfOwD1vDBbFch3hiyJu9XDA4LqDf3NtT+WLcd4L2bXvpywheE5FmXfmqPTPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933396; c=relaxed/simple;
	bh=kXufJV42T/yHpRR4asT35p4wo4nG8RMxGuj2jZgThzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uKF3p9Enz1RqFyC1OAFRMHva3CDd+RYz4fvZ2x7K2qo3ckATMdgzEbqXi8QuE0HlPFDfEwwB+wYKc7rqpI/t9n3QOczgMPJi4/FuUjCSljl+nFnqVZkYL6d459SXSBb95UxG3SsrW6ectrr5l36n8oR1x45KsvktfowQDdFfy50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xy8w4rHW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xy8w4rHW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A93CCC433C7;
	Sat,  3 Feb 2024 04:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933395;
	bh=kXufJV42T/yHpRR4asT35p4wo4nG8RMxGuj2jZgThzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xy8w4rHWuzlZBTIVMHm5iBH63IP9HPkRc4E39F5dvzBE4oKQjfb6IRcKCVtLeab5C
	 RbVHaPXIkw0JXHw2UlyhgV9bAW6wN4Bxel4ye8PVyvjpzSyHWmufn6fYzfN6CcW8jC
	 rJgOM6G7h9H28i+SedFAMfaCfzxZGfTLKIUX8KDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 112/219] f2fs: fix write pointers on zoned device after roll forward
Date: Fri,  2 Feb 2024 20:04:45 -0800
Message-ID: <20240203035333.113293671@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit 9dad4d964291295ef48243d4e03972b85138bc9f ]

1. do roll forward recovery
2. update current segments pointers
3. fix the entire zones' write pointers
4. do checkpoint

Reviewed-by: Daeho Jeong <daehojeong@google.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/recovery.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index 4f4db465220f..53a6487f91e4 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -898,6 +898,8 @@ int f2fs_recover_fsync_data(struct f2fs_sb_info *sbi, bool check_only)
 	if (!err && fix_curseg_write_pointer && !f2fs_readonly(sbi->sb) &&
 			f2fs_sb_has_blkzoned(sbi)) {
 		err = f2fs_fix_curseg_write_pointer(sbi);
+		if (!err)
+			err = f2fs_check_write_pointer(sbi);
 		ret = err;
 	}
 
-- 
2.43.0



