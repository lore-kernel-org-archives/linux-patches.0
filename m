Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354341D0956;
	Wed,  2 Oct 2024 14:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878397; cv=none; b=OXfcNNg+2x/19c3boiAt0/HkgwWXsBWD6UlKC2Dq7QC2ols3w3BeJzNM2UoyvSYMx7EiYAPcSCTY7JPNFZyG95uu9AJ0tUGoMbG695/2yYSAgp8Yx6w9OI+2Mcxkdv6uguvAXtpc9VsxJ1GhmDGV3Ye8SqyP41scssjV2w11rTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878397; c=relaxed/simple;
	bh=kyfqQXbam9dZT4/sFEi+T6AW6veyJZsaZ4CV9cQ311o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B/fH7sqTIcBeGBKH5fbqEWj5uUhYq/VSxwmdmz4kCmI0fe5vC9ap2rse480q4qieeINkyE8ZJVODBkr/YvA3ilNsIK/VE485fjn8E+8bYYQIOdt6jy5U4JB+ffAqLjj42OxbStAhDdxELNPOMaLCmr8Lxi1Au37YGuT7zWVKdFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P/8jJqFe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P/8jJqFe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7646FC4CEC2;
	Wed,  2 Oct 2024 14:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878396;
	bh=kyfqQXbam9dZT4/sFEi+T6AW6veyJZsaZ4CV9cQ311o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P/8jJqFeOLNLgh4R8GyG7YExci0qUqhXG6J+DY7HCaWSmQFDDfOYnF+/4O0pW+rjr
	 J//Alr09aNMymZef2O7j0H5xhn7En22SZJ/aIkKZck9oVjrIR34M8jclwQptXojxo6
	 LyKtScO+3JFST3SXVvIqiwWnqeddrfCudqXxFJEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 398/634] f2fs: fix to avoid racing in between read and OPU dio write
Date: Wed,  2 Oct 2024 14:58:18 +0200
Message-ID: <20241002125826.814957574@linuxfoundation.org>
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

[ Upstream commit 0cac51185e65dc2a20686184e02f3cafc99eb202 ]

If lfs mode is on, buffered read may race w/ OPU dio write as below,
it may cause buffered read hits unwritten data unexpectly, and for
dio read, the race condition exists as well.

Thread A			Thread B
- f2fs_file_write_iter
 - f2fs_dio_write_iter
  - __iomap_dio_rw
   - f2fs_iomap_begin
    - f2fs_map_blocks
     - __allocate_data_block
      - allocated blkaddr #x
       - iomap_dio_submit_bio
				- f2fs_file_read_iter
				 - filemap_read
				  - f2fs_read_data_folio
				   - f2fs_mpage_readpages
				    - f2fs_map_blocks
				     : get blkaddr #x
				    - f2fs_submit_read_bio
				IRQ
				- f2fs_read_end_io
				 : read IO on blkaddr #x complete
IRQ
- iomap_dio_bio_end_io
 : direct write IO on blkaddr #x complete

In LFS mode, if there is inflight dio, let's wait for its completion,
this policy won't cover all race cases, however it is a tradeoff which
avoids abusing lock around IO paths.

Fixes: f847c699cff3 ("f2fs: allow out-place-update for direct IO in LFS mode")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index fa6299a88492f..ad326c0ab5bd7 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -4590,6 +4590,10 @@ static ssize_t f2fs_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		f2fs_trace_rw_file_path(iocb->ki_filp, iocb->ki_pos,
 					iov_iter_count(to), READ);
 
+	/* In LFS mode, if there is inflight dio, wait for its completion */
+	if (f2fs_lfs_mode(F2FS_I_SB(inode)))
+		inode_dio_wait(inode);
+
 	if (f2fs_should_use_dio(inode, iocb, to)) {
 		ret = f2fs_dio_read_iter(iocb, to);
 	} else {
-- 
2.43.0



