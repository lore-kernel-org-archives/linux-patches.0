Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 293FA1E7640;
	Tue, 15 Oct 2024 11:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992953; cv=none; b=bM8LMAQxAiNxSGgIiDSuoPWtpJccAySvdDykGsRSJNJ9zYtPhl/8TCMnBUvoy2ucyeq+UrRA9tbEeRfDCx7KXM0M33syaaN9O8yN2hBrUDL+t+PavSMXoddXoiw3zLbi7pU6Q5AD4bK4+caqXgfOYgwPI/wSXWvAQdQ1Tr5QdME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992953; c=relaxed/simple;
	bh=zmwG59XJpimU35xB/hoqD3a/OgJMaH7BlqatH5ZP27o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jZt6no/OKl/koXVb4tfdKk/kOeiSk3ZOgzjpMDacazHvWP1hRbN5Pe0QIsqMKYP5F2s5m2K3aBS375Mx/O8tKlfKZj9EU+EQxRdEVNUUN9yFcXTRyWDMavWfYlmtLCZBQlCqAPA9tVcI/pCQIwapq9L+B1L9ZcxsUmByiHpDyDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wFnRjt1Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wFnRjt1Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F0B5C4CEC6;
	Tue, 15 Oct 2024 11:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992953;
	bh=zmwG59XJpimU35xB/hoqD3a/OgJMaH7BlqatH5ZP27o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wFnRjt1YQBZEWDxj0nnyIAVKGMgTQo3zwEwVHdQ0UqsDFoSbt/ZQG3uNQ7hrDWGKr
	 e+vBRp3zF684APNUlKwVtiKsZmqx83NfWIcLAN+cM1TMCZXML1Q3y9RJBE7M6SUt6/
	 XHHlQFKvwQISvJRnL1ITqxS1vDdsmHjuZdLzanSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 267/691] f2fs: fix to wait page writeback before setting gcing flag
Date: Tue, 15 Oct 2024 13:23:35 +0200
Message-ID: <20241015112450.945360011@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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
index 2f2cd520f55d6..0427994c9b50a 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2683,6 +2683,8 @@ static int f2fs_defragment_range(struct f2fs_sb_info *sbi,
 				goto clear_out;
 			}
 
+			f2fs_wait_on_page_writeback(page, DATA, true, true);
+
 			set_page_dirty(page);
 			set_page_private_gcing(page);
 			f2fs_put_page(page, 1);
@@ -4015,6 +4017,8 @@ static int redirty_blocks(struct inode *inode, pgoff_t page_idx, int len)
 		/* It will never fail, when page has pinned above */
 		f2fs_bug_on(F2FS_I_SB(inode), !page);
 
+		f2fs_wait_on_page_writeback(page, DATA, true, true);
+
 		set_page_dirty(page);
 		set_page_private_gcing(page);
 		f2fs_put_page(page, 1);
-- 
2.43.0



