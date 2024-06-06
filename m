Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351471991B4;
	Thu,  6 Jun 2024 14:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683646; cv=none; b=G8/YPpKWuNwTnU80vBx3As3uhb1K2XQ0u/KdbVq1LFUM4/8wnksdg/Ai2vQmQYyxpchcb8AJiZaZD6o0tLc3TlIXyeRn3PIunDgc3jjquEUEJlXn3csvSJPTn6O77UHwgGVzEsHZCPDVLPEFadNJ0XsFAK6cwrgPWMqqbNd58xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683646; c=relaxed/simple;
	bh=0GUcknW4HHgTXQv46lGlRx4LW3pxeBa27d4K7BxFRJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dCUyYSopbQAS1UxjKT8xcwaI4IjPB4TT35Qt20L2bXWKU1JIF67WmJSdwdsuvY9M+z0zZckabdbz2rpNTGmIHMI0BFHEo3Z0XfFjzFZ+QL6l0MxjB3hL8E9ySj2d6s0E3ZV1Cn+h8LPN06jJIIzDPC4VNP9f6Gxm32pxXjA4v+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vcP807S1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vcP807S1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 134A0C2BD10;
	Thu,  6 Jun 2024 14:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683646;
	bh=0GUcknW4HHgTXQv46lGlRx4LW3pxeBa27d4K7BxFRJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vcP807S1lCp7VovgCHB/T4QtRxTlQ5Ombwv4XJHA2GwNtqzNbjyDwji852PUt73Jk
	 bb+QL8maOtHGjSdHWbwT4bRWo6/fAa9PIZgTWcb+zidz/opxUvflk/5TYE2qfUch2M
	 bNaB6cIIGOyjKt6JI3Bdr9ps/p6UwOUD35JpUoec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 517/744] f2fs: fix to release node block count in error path of f2fs_new_node_page()
Date: Thu,  6 Jun 2024 16:03:09 +0200
Message-ID: <20240606131749.022257880@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 0fa4e57c1db263effd72d2149d4e21da0055c316 ]

It missed to call dec_valid_node_count() to release node block count
in error path, fix it.

Fixes: 141170b759e0 ("f2fs: fix to avoid use f2fs_bug_on() in f2fs_new_node_page()")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/node.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index ab113fd3a3432..c765bda3beaac 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1319,6 +1319,7 @@ struct page *f2fs_new_node_page(struct dnode_of_data *dn, unsigned int ofs)
 	}
 	if (unlikely(new_ni.blk_addr != NULL_ADDR)) {
 		err = -EFSCORRUPTED;
+		dec_valid_node_count(sbi, dn->inode, !ofs);
 		set_sbi_flag(sbi, SBI_NEED_FSCK);
 		f2fs_handle_error(sbi, ERROR_INVALID_BLKADDR);
 		goto fail;
@@ -1345,7 +1346,6 @@ struct page *f2fs_new_node_page(struct dnode_of_data *dn, unsigned int ofs)
 	if (ofs == 0)
 		inc_valid_inode_count(sbi);
 	return page;
-
 fail:
 	clear_node_page_dirty(page);
 	f2fs_put_page(page, 1);
-- 
2.43.0



