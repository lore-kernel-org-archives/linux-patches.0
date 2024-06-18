Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2F413A40D;
	Tue, 18 Jun 2024 13:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715612; cv=none; b=UOqSGjcKnWcHJkTeJQ+SkqulfPQaaWMdXjr2R3s7C9hYRzr9uLWYZnLSTodYxC6uVvVLPizDP+7HdnCbQ+Tdg8uy0zGn8VpI2QRMspCYHbwZOqcc5xU+Ifdjg9qux540Qh7NdHi4zJdHnDJmpsEd/vB0OBdD5BtERkQWBp1Kbig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715612; c=relaxed/simple;
	bh=t50OpRo8y1Su9BbGrlGuofUG/KKlJfK6d9o9qrLvIwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N5NVRDxoUcDzQ20zjV+dmf/DhMNWH8pEjk8TAkB2ywi05YCbX02MwXDWULjieNNADGnoeGEGXYz/ZdDnN9GX6z58KeBBp20CmGwgOi+O9PRfiR1rDqGsv8VFayEJfrev7tWDEUeDDgkk0o6P0xJc/iZqZDQoEfp3ppwiCxrY5So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ranLRn9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ranLRn9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04494C3277B;
	Tue, 18 Jun 2024 13:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715612;
	bh=t50OpRo8y1Su9BbGrlGuofUG/KKlJfK6d9o9qrLvIwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2ranLRn93j9vfc7JKO0ZC6x6p7qyUHKZ3VcsOPHJcIU3IVQ8jtpIKEYeX7NnFr2xt
	 LreVh5EamGDb6MLUIgq4RnqT+dVGhdPG2Ap8n+iBB3YE/YEqc0NOOIWp3ZQuRqPgbz
	 Fy22P64gGZoDQiDtVAn6G41pjixnHlMGnJc3MY5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Gabriel Krisman Bertazi <krisman@collabora.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 367/770] inotify: Dont force FS_IN_IGNORED
Date: Tue, 18 Jun 2024 14:33:40 +0200
Message-ID: <20240618123421.434582935@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/inotify/inotify_user.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 62cd91bc00b83..9676c3f2df3d7 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -89,10 +89,10 @@ static inline __u32 inotify_arg_to_mask(struct inode *inode, u32 arg)
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



