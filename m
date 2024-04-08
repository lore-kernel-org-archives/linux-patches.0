Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0628481A6;
	Mon,  8 Apr 2024 13:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582744; cv=none; b=SwLaZAYVMQCZQqwuFin+Op04djBt8xpkTxNIbBe0E2gVCSrW5pyXMnr1EmDGaDg03XCEm9xzgTHU9imQQ7IFeiRIk/ZRkvn7dZmGLUUON++yQ5MDc609YClkobgmrmhY4pDsASjXl0xEcjLU/641LwBq6F2t/rcik4Zb3K3GwRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582744; c=relaxed/simple;
	bh=eNMQeopq75lRztzjDC02Knl0lmleE3JZvshGWotNfQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kMf3lJCQXE0+LBQQEKPiD7nEOH1sE1mR3l3tuHGrWvuozoJPPvYtoMQVKNjFrcBj6QCkZlsg43+m4GGiajZswAlE+RTt+f0IF5fiGxKotjWm1E5IhEZFOxjqIlX/ZSyjHwAn08MPaQxJvEEKMQgfdOlzPTRPCKS9J39wugsMKUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q0tJ2Dk2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q0tJ2Dk2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 067ABC433C7;
	Mon,  8 Apr 2024 13:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582743;
	bh=eNMQeopq75lRztzjDC02Knl0lmleE3JZvshGWotNfQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q0tJ2Dk2bL7Jv6jHKB1fDOxJf5PDDsgjROpKSt2hIt7u4fq5P9TBYFuar6PzIX8L1
	 9w29/G3iETipjUwmstxUFL2v95OAQZKMzdCrewqaHl6zmK0R/c2WdMCowxwbywHWa0
	 XBZS2VbOoJqzUCMJp9/uFl6og4zbMJ++fpPEzueU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Gabriel Krisman Bertazi <krisman@collabora.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 172/690] inotify: Dont force FS_IN_IGNORED
Date: Mon,  8 Apr 2024 14:50:38 +0200
Message-ID: <20240408125405.789573512@linuxfoundation.org>
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

From: Gabriel Krisman Bertazi <krisman@collabora.com>

[ Upstream commit e0462f91d24756916fded4313d508e0fc52f39c9 ]

According to Amir:

"FS_IN_IGNORED is completely internal to inotify and there is no need
to set it in i_fsnotify_mask at all, so if we remove the bit from the
output of inotify_arg_to_mask() no functionality will change and we will
be able to overload the event bit for FS_ERROR."

This is done in preparation to overload FS_ERROR with the notification
mechanism in fanotify.

Link: https://lore.kernel.org/r/20211025192746.66445-8-krisman@collabora.com
Suggested-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/notify/inotify/inotify_user.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 9fb7701d2f8a0..b87759b8402be 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -94,10 +94,10 @@ static inline __u32 inotify_arg_to_mask(struct inode *inode, u32 arg)
 	__u32 mask;
 
 	/*
-	 * Everything should accept their own ignored and should receive events
-	 * when the inode is unmounted.  All directories care about children.
+	 * Everything should receive events when the inode is unmounted.
+	 * All directories care about children.
 	 */
-	mask = (FS_IN_IGNORED | FS_UNMOUNT);
+	mask = (FS_UNMOUNT);
 	if (S_ISDIR(inode->i_mode))
 		mask |= FS_EVENT_ON_CHILD;
 
-- 
2.43.0



