Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6132156C6B;
	Tue, 18 Jun 2024 13:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715632; cv=none; b=EStX2LyI8iyyASYpqOkZrh0LDx9qvjhuBA0wY595OTPBiJ57XC1kQGtg1JeUw2cR2DLpoAs9wRx866AdQtCfxSPoO/IEqtTX2T8a7YNl6AV9wFT1Q7qbvToG0uIPW6ZJ8Fg5l8yVvnzl/rJT+hlbDwIRBBYeII9T7MBp9cbJxvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715632; c=relaxed/simple;
	bh=FCacr9bHZdAvP7Zr/P5W+lhXNGYsfARZJM8CRP9nOTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TFsRzSor4KcBHXABY16wSnN5WBxxRZuKh0lv4uwDsJRr9/e/I3j2W2uilWXrWfq8DYHjdrn3NXw83X0tDI0v9I3TNnAyaqeZD64x6sK+TKalQi7+/cRpiPA1Rhiy7rpQ5oj7MHyBw7udmCQgMnKnsWVtRBaLZ39q03+nbAoYscs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fqMmggVr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fqMmggVr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D732C3277B;
	Tue, 18 Jun 2024 13:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715632;
	bh=FCacr9bHZdAvP7Zr/P5W+lhXNGYsfARZJM8CRP9nOTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fqMmggVrsX1zWX2+AfHuexztqhDMfARFDZfp1G4kYepIQTrTAbDG2eM0VfL+EWkyv
	 Z7+v5a6JgN+fbIUT1nwPBo8ek+m4aZJqeEGOd7yYnyX/XlZchJfKNsOxHVFxlp5qiX
	 MModQICl3WdvQQAahbYfIeOjOq0d/WdeHZ3yHv9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Gabriel Krisman Bertazi <krisman@collabora.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 373/770] fanotify: Support null inode event in fanotify_dfid_inode
Date: Tue, 18 Jun 2024 14:33:46 +0200
Message-ID: <20240618123421.667671776@linuxfoundation.org>
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

[ Upstream commit 12f47bf0f0990933d95d021d13d31bda010648fd ]

FAN_FS_ERROR doesn't support DFID, but this function is still called for
every event.  The problem is that it is not capable of handling null
inodes, which now can happen in case of superblock error events.  For
this case, just returning dir will be enough.

Link: https://lore.kernel.org/r/20211025192746.66445-14-krisman@collabora.com
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/fanotify/fanotify.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index c620b4f6fe123..397ee623ff1e8 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -452,7 +452,7 @@ static struct inode *fanotify_dfid_inode(u32 event_mask, const void *data,
 	if (event_mask & ALL_FSNOTIFY_DIRENT_EVENTS)
 		return dir;
 
-	if (S_ISDIR(inode->i_mode))
+	if (inode && S_ISDIR(inode->i_mode))
 		return inode;
 
 	return dir;
-- 
2.43.0



