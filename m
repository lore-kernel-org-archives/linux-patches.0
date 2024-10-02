Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116041D0BB0;
	Wed,  2 Oct 2024 14:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878403; cv=none; b=HOBi9P0bp/xTPgFd9XVDdcyowkwx1KyZ5QOxU9buyKSIM2ddYIJkFRJJuANzlxudl2p62InXbhlSJRiNG7KCFuN9j7RLJrJuccaBDE3/O0eKVgqR02lhUByMtru/mpth43JWtSGhVwfy4crKTeOaDMyX5s6qyhYtvWm8PLHQsPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878403; c=relaxed/simple;
	bh=+nEmX/7jTFcd0gG0AGGeZSOSDyR6F74DZypHu7pw4/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j1a4bE6JG6hdvNpb8rPV+UdXDJydb6W/DZjJXpddjO8hqd4WttlQveoDbZ3EBbAgZWxdwZvOl12lRsvpn6YiB458Lp7xnoR4euNf3JX17sMKhJlOR9bX5rhZCL8EltUSF+FtfG3sAQ2qd8Lnh+VoY94uSBp6TY8F8ls6m9dmM7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pvBm0xxq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pvBm0xxq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47F6DC4CEC2;
	Wed,  2 Oct 2024 14:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878402;
	bh=+nEmX/7jTFcd0gG0AGGeZSOSDyR6F74DZypHu7pw4/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pvBm0xxqIeeHc4Iew9I4n/PbQ8gBULMXoQp2/EHtQk5uCTEtnb0D6osY8MDPDY7fZ
	 CRlbnJPKidyfkOrn4FKBjNWp2nTSGyqCliQ6j+39tDich28o0DiT7XeDX7N0kJXE6L
	 95gdzkpgY/FNXZa78QDpClx7VgeetkRgf5vBI/nE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 400/634] f2fs: fix to wait page writeback before setting gcing flag
Date: Wed,  2 Oct 2024 14:58:20 +0200
Message-ID: <20241002125826.898849784@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit a4d7f2b3238fd5f76b9e6434a0bd5d2e29049cff ]

Soft IRQ				Thread
- f2fs_write_end_io
					- f2fs_defragment_range
					 - set_page_private_gcing
 - type = WB_DATA_TYPE(page, false);
 : assign type w/ F2FS_WB_CP_DATA
 due to page_private_gcing() is true
  - dec_page_count() w/ wrong type
  - end_page_writeback()

Value of F2FS_WB_CP_DATA reference count may become negative under above
race condition, the root cause is we missed to wait page writeback before
setting gcing page private flag, let's fix it.

Fixes: 2d1fe8a86bf5 ("f2fs: fix to tag gcing flag on page during file defragment")
Fixes: 4961acdd65c9 ("f2fs: fix to tag gcing flag on page during block migration")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 19da00ab31aeb..8425fc33ea403 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2791,6 +2791,8 @@ static int f2fs_defragment_range(struct f2fs_sb_info *sbi,
 				goto clear_out;
 			}
 
+			f2fs_wait_on_page_writeback(page, DATA, true, true);
+
 			set_page_dirty(page);
 			set_page_private_gcing(page);
 			f2fs_put_page(page, 1);
@@ -4184,6 +4186,8 @@ static int redirty_blocks(struct inode *inode, pgoff_t page_idx, int len)
 		/* It will never fail, when page has pinned above */
 		f2fs_bug_on(F2FS_I_SB(inode), !page);
 
+		f2fs_wait_on_page_writeback(page, DATA, true, true);
+
 		set_page_dirty(page);
 		set_page_private_gcing(page);
 		f2fs_put_page(page, 1);
-- 
2.43.0



