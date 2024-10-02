Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F0981D150F;
	Wed,  2 Oct 2024 14:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880173; cv=none; b=UCUym5ZmZreDLuhzNmMpTGTz/SP63gygrivcBflEfldvZNT53I6mNiucXRdaOEMshkAKEfc+KSSR1pgB7JGZTkX/rPwupItz0yrMJwJgvomkeXgJE/aOwPiabX+SYJmVZ3sPkRYNcSDEkXfiZIDLgcsZnSqrMA2G5+PsvKjioCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880173; c=relaxed/simple;
	bh=esRzHWybCOLC7XG2XQJj9x0RuGxN/PHG5xmYQYC9AZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tXwjhT1m5gkFEdWowD/zR+YaG2c4NYaZq/dIrvU05PWu1J3LJ4wF4mZYyoKQTfHhH9yfKVcOM0472LbWwk2hJpj2mctP8V6WCv28HRVS164m/KLHrUmcZMnl9cToGbEZGQWYrbVGaZVh/ixmaAi3WDjbeylLcDMQSRTbJsJZS70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ssiRf3j4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ssiRf3j4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B15BC4CEC2;
	Wed,  2 Oct 2024 14:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880172;
	bh=esRzHWybCOLC7XG2XQJj9x0RuGxN/PHG5xmYQYC9AZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ssiRf3j4fOfg3wSwZ8J8YQGWXjEywN5LoCvk1GzHkhb4y9KBJAt11G77IGEJCBS3N
	 xZ7W3MTVzi2ARlX/h7LEol7Ltwji7q9JFqxhW0jXmpsIX010N9SHkjjgP2lZ3noZCe
	 8Hd3q9DoHDs7zbN0TcYcJrq6JTLIkVdWNzKBSOQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 336/538] f2fs: fix to avoid racing in between read and OPU dio write
Date: Wed,  2 Oct 2024 14:59:35 +0200
Message-ID: <20241002125805.694809051@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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
index 81e342bd993c2..8c4c5c6c1ac64 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -4541,6 +4541,10 @@ static ssize_t f2fs_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
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



