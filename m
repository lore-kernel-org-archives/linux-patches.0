Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B21E9128387;
	Mon,  8 Apr 2024 13:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583838; cv=none; b=DnJUAqhS3t5pI4cta8tn4Mnm0Beb5yoiPDPW/Wf/PPSQo4GY2zcz2R1ZOc1E4cJrft7Lyqe1YkMmLpQC/NU0WgF5Dp6suk2hsGBZEcYQTVfFfyO+1lI3kjY6pPjMeHORi2zNe2PrdRSgZJOUNZU2S0BiMxXwagkDs8f3eGfr/SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583838; c=relaxed/simple;
	bh=K4dXdF2nLlF/AvtFeR9NEZtDrvBEG/cKqMykMOswjvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BqMwW+uzz73KFsvliIiiznf3lOmai1XTC32tpGGJwnRsBgb15dCAktL7NrOj3f003B1aAhvhb4lbKSeii/hwKvGsPlULTPw8BLKvJYJfe9dcHd2nVXb1enlNmOi7euX/p2ai6vkRcPm+pDx84o87OQGHZlRW09bR7Xc7BmuT0J8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PEd2WrlE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PEd2WrlE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38856C433F1;
	Mon,  8 Apr 2024 13:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583838;
	bh=K4dXdF2nLlF/AvtFeR9NEZtDrvBEG/cKqMykMOswjvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PEd2WrlEXwLpMsVl5Stmo0qZ+/WI/a62B6Ng/QH9SiFP+0lRENDCZXKLSie8yqTlC
	 S4Xwx9LqFu2b0bL57XE2aqlRe96u5aESky77oBh/Twma5UdWsJZB1gXpEq2eW7uw/8
	 lsD4h6yixM5ewPo8ye8ZGIXknRwXqHwQIiZ0PpUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Amir Goldstein <amir73il@gmail.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 294/690] inotify: use fsnotify group lock helpers
Date: Mon,  8 Apr 2024 14:52:40 +0200
Message-ID: <20240408125410.269100322@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
---
 fs/notify/inotify/inotify_user.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 0d8e1bead23ea..266b1302290ba 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -632,13 +632,13 @@ static int inotify_update_watch(struct fsnotify_group *group, struct inode *inod
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



