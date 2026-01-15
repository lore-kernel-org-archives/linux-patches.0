Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C35029B200;
	Thu, 15 Jan 2026 17:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497713; cv=none; b=SA5bY5XMXHVblk9aEdES/yXbbYK/tr9FXcT/CzGfsQAMoq598BGhn4Qh2SeVWzi13Fu1QosZBTq7tIFcyBXRfWWptDBMU0aNEo9RaEZeYB2+dnHU/wt/iRTRXVnkv6GP2AIbuGKya9Yd1m+N4z/+mPAqKlU8On6xZqMP1hlfvzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497713; c=relaxed/simple;
	bh=9RucrUMRjvT/KRVGB0qVYaSEZQ5Q3m+I0ON+rZECQ9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LzfOWnymsr92eCYiXBCT35uLng8hUGSSRvfo09f/HY9Q5D7tTHl1Cc5niGuG//jKOC6SjrVPyJj0BU7GAWgvQyI3rGO/CquNbOKwDskXDrhMPzIl61sE3dsc21EWiR+CbD7Bq0HJ8jRCo3+MuIbshBJogkTxEIUe4WnCiiCP0w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fWzDgm2n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fWzDgm2n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15692C116D0;
	Thu, 15 Jan 2026 17:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497713;
	bh=9RucrUMRjvT/KRVGB0qVYaSEZQ5Q3m+I0ON+rZECQ9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fWzDgm2nN1R1iVw+jWvo4F82qRLL+2SXxFJiRFwNdBV/FjbaYRT2/J1UKUm64rKkj
	 lF94uyJdtsYSd/6kZ8hfPIwcpK6bFDtZY9AGk/TOnxQ28mljOkhr0jxuwscKQi3jOG
	 QBU7LMgTw0jSgqzkICxHp0gQN3GQnIFhR+zp9hB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alkis Georgopoulos <alkisg@gmail.com>,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 178/554] Revert "nfs: clear SB_RDONLY before getting superblock"
Date: Thu, 15 Jan 2026 17:44:04 +0100
Message-ID: <20260115164252.710289509@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit d216b698d44e33417ad4cc796cb04ccddbb8c0ee ]

This reverts commit 8cd9b785943c57a136536250da80ba1eb6f8eb18.

Silently ignoring the "ro" and "rw" mount options causes user confusion,
and regressions.

Reported-by: Alkis Georgopoulos<alkisg@gmail.com>
Cc: Li Lingfeng <lilingfeng3@huawei.com>
Fixes: 8cd9b785943c ("nfs: clear SB_RDONLY before getting superblock")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/super.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index aa11a6dcf6ce7..f91cb1267b44e 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1269,17 +1269,8 @@ int nfs_get_tree_common(struct fs_context *fc)
 	if (IS_ERR(server))
 		return PTR_ERR(server);
 
-	/*
-	 * When NFS_MOUNT_UNSHARED is not set, NFS forces the sharing of a
-	 * superblock among each filesystem that mounts sub-directories
-	 * belonging to a single exported root path.
-	 * To prevent interference between different filesystems, the
-	 * SB_RDONLY flag should be removed from the superblock.
-	 */
 	if (server->flags & NFS_MOUNT_UNSHARED)
 		compare_super = NULL;
-	else
-		fc->sb_flags &= ~SB_RDONLY;
 
 	/* -o noac implies -o sync */
 	if (server->flags & NFS_MOUNT_NOAC)
-- 
2.51.0



