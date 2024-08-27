Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF7D1C8FD4;
	Tue, 27 Aug 2024 15:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771911; cv=none; b=J1mm1TVPvkjOy2tg3e3YxH2KQU8Q7odj8+bnGvIf53FfsxG//pZM4pltpPfHdJ94A7KY17pAU+bQMSZ+NzUDtx8MZsP+kOpU8DLNehQIw1plK1T/eSQ+/JsyTmHZsoh9FqHKAdrjFBmSKzEC+S8xNHD3bzy2U+5e6Fat1FDWMdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771911; c=relaxed/simple;
	bh=OYmQlU1T8pRm5RMfYJpV5gxixJoaaVVHgYdzSb3NyIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qSzjMUxZfuLcHRkQDbx8FB/M6WSHGz+Y7DB+Pv26zpbP42JcgLDedTB9H82yjbnYBbQXgsvtPRer71hV0lB1eZ68WJKoWy4Qi3s6f77ZJ7EHi3ULGBmEsJg73kFIgw5k/NrnSThudl0MN5GyrcEu4OvEznCXwscvk+jT5cbajpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mglv0wSB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mglv0wSB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DB4CC61067;
	Tue, 27 Aug 2024 15:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771911;
	bh=OYmQlU1T8pRm5RMfYJpV5gxixJoaaVVHgYdzSb3NyIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mglv0wSBsyaY+GEiT5t0Utk8lYvZpSYREwPpmL+FyC75eN7+By/0sQD25xx1d4syN
	 RnqUornQa09a0viSI7BTiY4xQ+Bkw5hHQ1Jz6GzGYsjmNh0IfGWjScwVB4ADuCAfRk
	 1hME1KLRD2ImAIRvyUM/M1QPdcynxLmHD0PDew58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yue Hu <huyue2@coolpad.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+6c746eea496f34b3161d@syzkaller.appspotmail.com
Subject: [PATCH 6.1 057/321] erofs: avoid debugging output for (de)compressed data
Date: Tue, 27 Aug 2024 16:36:05 +0200
Message-ID: <20240827143840.405788901@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1eefa4411e066..708bf142b1888 100644
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



