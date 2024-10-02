Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40801D0787;
	Wed,  2 Oct 2024 13:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876418; cv=none; b=RYmDI4vgss1U6KoXTJjVvoM3D0cmp0qCLKwQ8nqtMmrM48UzuewXTq8xg2tp6bspEl9vgZ2Xuzo7paPj0mVEg9ELlorsGCrOKsKjYuUukwarov8sGo5l51xRkYp7vQiAZHPn2qSan83PU3ZzPuS6ImjNDKXKngoA1/bKbUovw2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876418; c=relaxed/simple;
	bh=a6KaGTYPXhGX3hKH5bhcW359/ZzTnFSAr2zIsmR1ruk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y12pI+o+e9tx2kJGHECmfwfNrbqd0M1eEQE5MsH3G3hm438YqYB+GpnXLsnHXzOOwATEvcOUwrFFPIeE/XKJim7Bt3aPLY61Q1vXDBZ6dFVywDVy3FhlC7JS1aKs+FPMNVR6U2IRG6D9QS4LyQsg8qw6dZjnbbUwpRGfSJHEzLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DyFxmGCz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DyFxmGCz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D1FEC4CEC5;
	Wed,  2 Oct 2024 13:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876418;
	bh=a6KaGTYPXhGX3hKH5bhcW359/ZzTnFSAr2zIsmR1ruk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DyFxmGCzCsoZzyzhU4ADCGZKZcMQYWz22N0bC32kWG8qlXqkgKt9N8gfmN1zMDGlK
	 eL36lJzk7RErGn4ti0ynSt+onseAZYKRAGdpZkUjgWcUG3w+rvfQgarXAeHeYZ7l7s
	 +hesIt8dE5+djLcxMWXgLDGI3danwiihh19GuPnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 438/695] f2fs: fix to wait page writeback before setting gcing flag
Date: Wed,  2 Oct 2024 14:57:16 +0200
Message-ID: <20241002125839.944293868@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index bf448dbe2c551..e178e3ebde04e 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2790,6 +2790,8 @@ static int f2fs_defragment_range(struct f2fs_sb_info *sbi,
 				goto clear_out;
 			}
 
+			f2fs_wait_on_page_writeback(page, DATA, true, true);
+
 			set_page_dirty(page);
 			set_page_private_gcing(page);
 			f2fs_put_page(page, 1);
@@ -4190,6 +4192,8 @@ static int redirty_blocks(struct inode *inode, pgoff_t page_idx, int len)
 		/* It will never fail, when page has pinned above */
 		f2fs_bug_on(F2FS_I_SB(inode), !page);
 
+		f2fs_wait_on_page_writeback(page, DATA, true, true);
+
 		set_page_dirty(page);
 		set_page_private_gcing(page);
 		f2fs_put_page(page, 1);
-- 
2.43.0



