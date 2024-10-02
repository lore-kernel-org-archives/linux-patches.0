Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 067931D04BA;
	Wed,  2 Oct 2024 13:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876413; cv=none; b=Axv2iIlT6J15ejEthMBBnC9Sm1WRjFFbiIpXP3IpN6QTAztpsNhAp8KuNTxP8vcdLxvp6v2KjE5eH9kv3VKBUY+OXAdbugaVbm3w2BqbaEMKsapy4GjKS7yUEnThF9+id6heQxPU6qwlF9SLw/qPPLXQAD9JtkXtKfF3oNZY46o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876413; c=relaxed/simple;
	bh=u8C4R6P1DtLWQl8elXNqj7fOR6Ue0muLmhsI1/ZUrPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CyIJeBKsI2EzyIrH7dHkwK8NBL+EVghKTsqi2ZZv7RFWMPDlgLf7vQEmKrXTwLzw6sUlI3/8mDkctfIQRQCvfbG8gcqjhKaRJwPNXjBFrTrTuwZOtjAqdqq/omqJP9TFj3/ACnr/PImmTjSv53XM4MR/Subusba4TdZGNtiuFsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0hIiqg9X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0hIiqg9X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 824B3C4CEC5;
	Wed,  2 Oct 2024 13:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876412;
	bh=u8C4R6P1DtLWQl8elXNqj7fOR6Ue0muLmhsI1/ZUrPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0hIiqg9X7WYwm/hNlfO2q9fcUBGAluudi+GoviQIgUP7WJb0JyNYySpQg1yZaykmn
	 6ftFRWNlNGN/uHKoBcjMlcn9S1w8XDKbSreuVCax4Up45i30rnOeZpdDVOBQ/yxBaz
	 jnzxZcT8a9IGcnOv42XTmW6hu/1G97Ev0IjTN/RQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 436/695] f2fs: fix to avoid racing in between read and OPU dio write
Date: Wed,  2 Oct 2024 14:57:14 +0200
Message-ID: <20241002125839.864637527@linuxfoundation.org>
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
index f42d1e41a82b1..afa43d1aa030a 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -4600,6 +4600,10 @@ static ssize_t f2fs_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
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



