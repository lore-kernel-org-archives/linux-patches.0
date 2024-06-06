Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F6151974EB;
	Thu,  6 Jun 2024 14:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683461; cv=none; b=KRE6J+WlU/6lx+GKLqnP4Ll8c8CWpvq29R/KVKJaWkaIuJYyB65lzyTarsRZ8xglD+gLBVIY8RtR0WMtpaPApHpf2CIdWBs0MaJK83M3Sqjt2e0xb1DdoW5yD2F6IqhForSR4eySyU+JpCAEpq4llbkWx0/xsE4gpavxersL/vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683461; c=relaxed/simple;
	bh=m6MCqIrbAq4fzaPw6BCU+f34OxEUTxYvlEMURG9Vtto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OI5yqmpaqu/A0Xw+Dm4EBKvy9R4QdfG4Dp8pg+k54JAuUpXJajwvYvsFEOKZPmzMA7odC3TAoDyz1e/1aoNZV2dw44mSMRDtMCCYaZl4mo6PHuPpvMgPnMXu51PkSb3N9eXU9q/Fw8hS0dRFu/xejxeih8X6bx8BRL6dZKFH8gE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DHVUxb8X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DHVUxb8X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D6AAC32781;
	Thu,  6 Jun 2024 14:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683461;
	bh=m6MCqIrbAq4fzaPw6BCU+f34OxEUTxYvlEMURG9Vtto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DHVUxb8XuasdRLlKa1A1Rm5dercWyPXoSz30DYMNnwzUE1psswRlFq2YexyKOxkpb
	 qeTS8v8ZzoNuCwY/Us21N7gfXTk/m+7EdT9Q8fkuLmzEXdQ1g1YW67HPCYuhBotF8y
	 Dy3+SoXuSqhpAxkStEWpNEh1q7jSfxnGqnrNQk60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 348/473] f2fs: fix to add missing iput() in gc_data_segment()
Date: Thu,  6 Jun 2024 16:04:37 +0200
Message-ID: <20240606131711.414859301@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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
index d4662ccb94c8f..5a661a0e76632 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1566,10 +1566,15 @@ static int gc_data_segment(struct f2fs_sb_info *sbi, struct f2fs_summary *sum,
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



