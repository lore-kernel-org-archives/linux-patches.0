Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1BA19750D;
	Thu,  6 Jun 2024 14:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682953; cv=none; b=fYfuvydletTCOEIkyv0vSe5usLHh6HjPhAdJS5/1pEojqcjm6mHXgQqSSb+mGcc6/gen5waQ8NUj/FAOCBFL/56tGeDQbb8pTAjsCfWWHcCdUXiKV+ahOxNBU9yjsE1PmxzVqeCESzGK9kagTolOxSacLus875jZg0g3rtVq9ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682953; c=relaxed/simple;
	bh=AzpNvo/aLXW2BV65ih4uprZcnwasEmpm5Yz3K/7BSMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eh0Esaa+n9S9WS1UxPAMJxMMNygsIbVtzCXkEQP1OaZ3Lh4M6kyQkUmnDDlNEEriX/pZYLx8zLiUnb8vemg1DmaQWrVzZtXyfcqJyzeG0ubBI2i7tJpYklF3S7cGHOgxc8ehDbgKDsATvakDZ4020GTrxWBmcd0MqwIeExKvvvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T9uLV8JG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T9uLV8JG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B43EC2BD10;
	Thu,  6 Jun 2024 14:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682953;
	bh=AzpNvo/aLXW2BV65ih4uprZcnwasEmpm5Yz3K/7BSMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T9uLV8JGWiRmR3L2HzAYVAvFhmZ8KexO31KsXQnEgkLQMTdIgyUo0329ZdAozwFPx
	 XBcBtJS+kEIJlIdO7usOlVStNaSQfoAYB2yiT4jCyp6kWHIx26vKR6hlUvLEC+cUxI
	 j5BsJ9MiANTxHz2H9fLjBXvyvZHzwGhiFOvkiLXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 118/374] f2fs: fix to add missing iput() in gc_data_segment()
Date: Thu,  6 Jun 2024 16:01:37 +0200
Message-ID: <20240606131655.878939084@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit a798ff17cd2dabe47d5d4ed3d509631793c36e19 ]

During gc_data_segment(), if inode state is abnormal, it missed to call
iput(), fix it.

Fixes: b73e52824c89 ("f2fs: reposition unlock_new_inode to prevent accessing invalid inode")
Fixes: 9056d6489f5a ("f2fs: fix to do sanity check on inode type during garbage collection")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/gc.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 8852814dab7f6..e86c7f01539a7 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1554,10 +1554,15 @@ static int gc_data_segment(struct f2fs_sb_info *sbi, struct f2fs_summary *sum,
 			int err;
 
 			inode = f2fs_iget(sb, dni.ino);
-			if (IS_ERR(inode) || is_bad_inode(inode) ||
-					special_file(inode->i_mode))
+			if (IS_ERR(inode))
 				continue;
 
+			if (is_bad_inode(inode) ||
+					special_file(inode->i_mode)) {
+				iput(inode);
+				continue;
+			}
+
 			err = f2fs_gc_pinned_control(inode, gc_type, segno);
 			if (err == -EAGAIN) {
 				iput(inode);
-- 
2.43.0



