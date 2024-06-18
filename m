Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903F81514ED;
	Tue, 18 Jun 2024 13:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715994; cv=none; b=rgA8zxGVXl2NTDTSyimhj2QSoSoN25Tc8+UjEmFojQPNPGwltp5/cqjsUHCSf3w1cPN4l0xoDT3fzVR4RpMf3VsribkiUehl95fHe6mD/1sAT+Wbzk0BllLzr5WHA/KnNoa5ehss191yr4dHUG30rr4Es9aqcIJo5YZ60lehcNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715994; c=relaxed/simple;
	bh=uVo9m7/G0i4GevAKSMoEOclQ94iDD+xnvc+hOTc3wqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gZ4JpD5qkpEUNI/9NF7R9wcHdPbzVWTJTGVNqeqmGEMhK7w79M/RE64KHkjp4MprePuAowY3R8oTgf1TcsCMcESMBkD7MBzh7yLxGBRiuCLP0pu+u0S65OttBm7UDwXjaSwTDET3N5SwyzNyElyUWmztWUtB567UOm/aIRzs4qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RJ0nJqFa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RJ0nJqFa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CF6BC3277B;
	Tue, 18 Jun 2024 13:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715994;
	bh=uVo9m7/G0i4GevAKSMoEOclQ94iDD+xnvc+hOTc3wqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RJ0nJqFaurw0JzE8OA4le+PlvSgP71t0uBGDT4dmhpmyYpH6bF/AKP1QZWNaVRNkr
	 YOwJoTP2HWorwKUyA9/Dx0qTAWrK7SkoLmJTcC03qUYSAzrGrmBTKXPkKxGNj88r2J
	 TqE947LWNCA0ZDJSeeRLo+UlT6f1ALlXSk0d0vaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Amir Goldstein <amir73il@gmail.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 497/770] inotify: use fsnotify group lock helpers
Date: Tue, 18 Jun 2024 14:35:50 +0200
Message-ID: <20240618123426.503213065@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit 642054b87058019be36033f73c3e48ffff1915aa ]

inotify inode marks pin the inode so there is no need to set the
FSNOTIFY_GROUP_NOFS flag.

Link: https://lore.kernel.org/r/20220422120327.3459282-8-amir73il@gmail.com
Suggested-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220321112310.vpr7oxro2xkz5llh@quack3.lan/
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/inotify/inotify_user.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 9e1cf8392385a..3d5d536f8fd63 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -627,13 +627,13 @@ static int inotify_update_watch(struct fsnotify_group *group, struct inode *inod
 {
 	int ret = 0;
 
-	mutex_lock(&group->mark_mutex);
+	fsnotify_group_lock(group);
 	/* try to update and existing watch with the new arg */
 	ret = inotify_update_existing_watch(group, inode, arg);
 	/* no mark present, try to add a new one */
 	if (ret == -ENOENT)
 		ret = inotify_new_watch(group, inode, arg);
-	mutex_unlock(&group->mark_mutex);
+	fsnotify_group_unlock(group);
 
 	return ret;
 }
-- 
2.43.0



