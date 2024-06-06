Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FADF198E79;
	Thu,  6 Jun 2024 14:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683465; cv=none; b=gn7vcgJmzhF/G5AyawH6me0q3i4fxreQtTmCp/5N8HAVDD4ffjAUa4vd8jXXi0WD6vO+ZP4QHlSbJdbYWa7pmYAJuadnBtyW2JfS9VebogL6p00unjLHi92XLnCoS2wnl3EHnMOgvl0Tcvs0ZwLYVNAhqUAWB+77OKYE9tvPsas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683465; c=relaxed/simple;
	bh=eyHpBuJE9XcnxwqN9apNk32vHJdUxNc5ejXYzVQtI/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h2xCF36fCPVHB9K+Dy6hraPU22GE8JphGj2K502ozqbzFs1Z8r78UcYZf0hozsj+OALBt1QNSaPRB8+xKQioeL5KJh1nHEQgl/APP+/82PPWBTR8WQ1ROH8Qc/Mdg5a6S1B2OqkSP4h7Aqkt0s2BX61DaMuQ8f1pTnaIBK5r+YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cUHzQpPE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cUHzQpPE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 648FAC32782;
	Thu,  6 Jun 2024 14:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683465;
	bh=eyHpBuJE9XcnxwqN9apNk32vHJdUxNc5ejXYzVQtI/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cUHzQpPEa3cRkUKuPVdIAy7xwJnZTSe6HJtq+Py5WnXgdGqRNS+3lEZVAX/5fxTRw
	 OLBFMOt4OgCy73oG8uhH7FVAigMZmz3A+xF6G5dW31tiss2kz5OH5D7GcuREtVUizA
	 viumde97F08AZg4f0qrY0DYXlZAmVHK5Cl6AGPOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 396/744] f2fs: fix to wait on page writeback in __clone_blkaddrs()
Date: Thu,  6 Jun 2024 16:01:08 +0200
Message-ID: <20240606131745.163280532@linuxfoundation.org>
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

[ Upstream commit d3876e34e7e789e2cbdd782360fef2a777391082 ]

In below race condition, dst page may become writeback status
in __clone_blkaddrs(), it needs to wait writeback before update,
fix it.

Thread A				GC Thread
- f2fs_move_file_range
  - filemap_write_and_wait_range(dst)
					- gc_data_segment
					 - f2fs_down_write(dst)
					 - move_data_page
					  - set_page_writeback(dst_page)
					  - f2fs_submit_page_write
					 - f2fs_up_write(dst)
  - f2fs_down_write(dst)
  - __exchange_data_block
   - __clone_blkaddrs
    - f2fs_get_new_data_page
    - memcpy_page

Fixes: 0a2aa8fbb969 ("f2fs: refactor __exchange_data_block for speed up")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index ee5df9adaf775..7f631a617ee99 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1305,6 +1305,9 @@ static int __clone_blkaddrs(struct inode *src_inode, struct inode *dst_inode,
 				f2fs_put_page(psrc, 1);
 				return PTR_ERR(pdst);
 			}
+
+			f2fs_wait_on_page_writeback(pdst, DATA, true, true);
+
 			memcpy_page(pdst, 0, psrc, 0, PAGE_SIZE);
 			set_page_dirty(pdst);
 			set_page_private_gcing(pdst);
-- 
2.43.0



