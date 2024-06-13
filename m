Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADAB51442EF;
	Thu, 13 Jun 2024 12:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281095; cv=none; b=aR80XpMB4jAqGUX/VxBXQ9GhPkiMHzjIUTLFv96ceHxY6eBS7G8zPHdk/KsCH10IRkY0LaxPXpZLP/7KQ1pb8jlDsQXtLIrIxYioTYWxX8N6gscg1rsVMv11ODExzC0e8B6oRIMHObG8deumZOHDc4QjMMLKSNidzqbRQmfhjRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281095; c=relaxed/simple;
	bh=lA513DET9COYzMdC8eP2zwAmIxQDiOA1iwi7N0NnalE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rVPArRyGR3H5iTARr+vfntT/eYOuUVOffzigLp556RICWhUFpO/yN7K0Eh+PoYkCvGnToInNU4iij0sdkVFphtVFegl/tmOpc7qGBwilei86XjYHrsGWFHfIOqnOp/Yjp3GEeaZyPsIbhdcKRf7I0pxUWk/DN1iPeIbhpSdx8rQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iqspcUg4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iqspcUg4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34CCBC2BBFC;
	Thu, 13 Jun 2024 12:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281095;
	bh=lA513DET9COYzMdC8eP2zwAmIxQDiOA1iwi7N0NnalE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iqspcUg4MNxA0oyuj6wmiebs2wCtaYbtK/Ys+/hWi6cqz5EywWX/j7+2L0GFkWBwZ
	 8yttrkt3s0gg66I0dMypHJwwXhBJwsvQths6rLNFi6X0Lu27wyzPf1RYHB1tR+NjE7
	 srhhCeFMct8XoB24O2wPkcCm4SY12/EnnXZPaEWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 139/317] f2fs: fix to wait on page writeback in __clone_blkaddrs()
Date: Thu, 13 Jun 2024 13:32:37 +0200
Message-ID: <20240613113252.942331579@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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
 fs/f2fs/file.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 40e805014f719..678d72a870259 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1253,6 +1253,8 @@ static int __clone_blkaddrs(struct inode *src_inode, struct inode *dst_inode,
 				f2fs_put_page(psrc, 1);
 				return PTR_ERR(pdst);
 			}
+			f2fs_wait_on_page_writeback(pdst, DATA, true, true);
+
 			f2fs_copy_page(psrc, pdst);
 			set_page_dirty(pdst);
 			f2fs_put_page(pdst, 1);
-- 
2.43.0



