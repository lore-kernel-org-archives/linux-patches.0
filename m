Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B611DDDB;
	Thu, 13 Jun 2024 12:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282276; cv=none; b=DgrP8hcopOx2SI1cLdrHPVMSF7CudV0tY9YKjL3pF5tPAVhSf3Sagqxb9Orbx6bDS2pgh62w751i5tfI2/Vb85SPui2Cy5lXP/w8MBqZrxz2I9AaHeiM/bgt78Uv2AT9ytELuMS6ceBF5eh5xkE4tydaclfA6f2V9o+V0u4bs3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282276; c=relaxed/simple;
	bh=7DHCxhGErL14IxVwsSFkwrtFaoAICwW5hCazLEJT61U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GV1cuRXmQB1yPZZdd68ZvS/www2CB2GQRQS4MhEoJpgoQlakriRhzbgluO+/ox9eZfSBVnhPqMJJnUzGDiQ1t3qwAHk1tsJWVrfR8Ip2k21x0tXYea0acGCAeKcSVsz55oAGzQERGcYqu7EW2tbbs16B+/jz4AuiwDRKQm86+NY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fQQWyWEp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fQQWyWEp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26E16C2BBFC;
	Thu, 13 Jun 2024 12:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282276;
	bh=7DHCxhGErL14IxVwsSFkwrtFaoAICwW5hCazLEJT61U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fQQWyWEpUbM9XCKVED8bAhHfYxplNL6XPpWF5ijLUpuM6O8UURN1IQ3Lm4CUad7Ss
	 4Dxmr+Pm1X7ZvOlURtdIsCPUIvZmeULVe6F5PngHfSVyibDBH/iYdQ8o6/rH1s4Lzp
	 pJ6z/qsK1cRetQcUUN0hCNCOexYXlMEq0lo4xzio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 181/402] f2fs: fix to wait on page writeback in __clone_blkaddrs()
Date: Thu, 13 Jun 2024 13:32:18 +0200
Message-ID: <20240613113309.210435896@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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
index 9b7ecbb974258..3d811594d0d5c 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1276,6 +1276,9 @@ static int __clone_blkaddrs(struct inode *src_inode, struct inode *dst_inode,
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



