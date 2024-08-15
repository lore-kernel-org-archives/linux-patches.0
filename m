Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E395B44376;
	Thu, 15 Aug 2024 14:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730914; cv=none; b=QYUTB2bfx+wW58YRdnu1gi3m1MD7Z0eIZTKxsLZZSBIe1/zD9QzaGT+y9Ct/a9OZqL2bL5sBowGG4N8kLX+KnrNauywArY1ez0VsXouSCWd53d7Tg4PFW9wIVDn4iLkEG6LBe3uB8l37XEY5T3uGTiWV9d+FyCJCjqVrTlz3I9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730914; c=relaxed/simple;
	bh=kgKaA/FKeAfByfZ0s3VgQ0CRC7HdxcGP59bVxh/sgis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QVfIS1Rk1MJX3+uPpFlZz80hYd0oz+wNAsDbdgCnLPSG3cQ4m7g9Gg/1rQqN2W26+iHNkIHKJgIj3SbN/uqdBQnzmTCnF+6Kn6IedqTKQsGISVmWvpErQ1BiX7J5ttlRFJoI+ZFv/C100DSJlfpj3J9RbiigOlzJudZDfUzl//0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MbNNtfGr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MbNNtfGr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58EE3C32786;
	Thu, 15 Aug 2024 14:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730913;
	bh=kgKaA/FKeAfByfZ0s3VgQ0CRC7HdxcGP59bVxh/sgis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MbNNtfGrbjhbiQqLuNyzs3tSQX5MZBa+QPyAD3cgWenQI+EOeDGHCJtUDAhU7j0MO
	 BFgqBkQgfeDBTgmY5KnV7z5Rv0wt2R4Hx5UxZWZnYWW1UC2jI+DpWMwqB5Ct67NFmj
	 +fkWqLNqlDHJIb4DjoH4M9NHHettsZV7KIvHHcAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yue Hu <huyue2@coolpad.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+6c746eea496f34b3161d@syzkaller.appspotmail.com
Subject: [PATCH 6.6 33/67] erofs: avoid debugging output for (de)compressed data
Date: Thu, 15 Aug 2024 15:25:47 +0200
Message-ID: <20240815131839.595087430@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131838.311442229@linuxfoundation.org>
References: <20240815131838.311442229@linuxfoundation.org>
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

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit 496530c7c1dfc159d59a75ae00b572f570710c53 ]

Syzbot reported a KMSAN warning,
erofs: (device loop0): z_erofs_lz4_decompress_mem: failed to decompress -12 in[46, 4050] out[917]
=====================================================
BUG: KMSAN: uninit-value in hex_dump_to_buffer+0xae9/0x10f0 lib/hexdump.c:194
  ..
  print_hex_dump+0x13d/0x3e0 lib/hexdump.c:276
  z_erofs_lz4_decompress_mem fs/erofs/decompressor.c:252 [inline]
  z_erofs_lz4_decompress+0x257e/0x2a70 fs/erofs/decompressor.c:311
  z_erofs_decompress_pcluster fs/erofs/zdata.c:1290 [inline]
  z_erofs_decompress_queue+0x338c/0x6460 fs/erofs/zdata.c:1372
  z_erofs_runqueue+0x36cd/0x3830
  z_erofs_read_folio+0x435/0x810 fs/erofs/zdata.c:1843

The root cause is that the printed decompressed buffer may be filled
incompletely due to decompression failure.  Since they were once only
used for debugging, get rid of them now.

Reported-and-tested-by: syzbot+6c746eea496f34b3161d@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/r/000000000000321c24060d7cfa1c@google.com
Reviewed-by: Yue Hu <huyue2@coolpad.com>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20231227151903.2900413-1-hsiangkao@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/decompressor.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/fs/erofs/decompressor.c b/fs/erofs/decompressor.c
index d36b3963c0bf3..aa59788a61e6e 100644
--- a/fs/erofs/decompressor.c
+++ b/fs/erofs/decompressor.c
@@ -248,15 +248,9 @@ static int z_erofs_lz4_decompress_mem(struct z_erofs_lz4_decompress_ctx *ctx,
 	if (ret != rq->outputsize) {
 		erofs_err(rq->sb, "failed to decompress %d in[%u, %u] out[%u]",
 			  ret, rq->inputsize, inputmargin, rq->outputsize);
-
-		print_hex_dump(KERN_DEBUG, "[ in]: ", DUMP_PREFIX_OFFSET,
-			       16, 1, src + inputmargin, rq->inputsize, true);
-		print_hex_dump(KERN_DEBUG, "[out]: ", DUMP_PREFIX_OFFSET,
-			       16, 1, out, rq->outputsize, true);
-
 		if (ret >= 0)
 			memset(out + ret, 0, rq->outputsize - ret);
-		ret = -EIO;
+		ret = -EFSCORRUPTED;
 	} else {
 		ret = 0;
 	}
-- 
2.43.0



