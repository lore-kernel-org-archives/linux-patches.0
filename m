Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 422FF3074B7;
	Tue,  2 Sep 2025 13:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819638; cv=none; b=WeCqxhAzQSQyUoRgawySODF1/JDYZG9O0umq2L35ydMsYvbhcM4itpboH4kzKZFBQOzmJ1xgt4UOKFQkrdob42pDjZyDVh3kFTR+slCHlbWnZ1iEDd1JLaKlSD5HNf3QufhEMHGxTYqeLO5HyMhxO2cDoetRjiWnjs3H6ds73ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819638; c=relaxed/simple;
	bh=QkjlpKKrohaXHhF4yAoDFbHTLeDjA5lwnUUFmik9Ev4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nO80Vuj1gdyLlECnEElVTKp1//+hDI02FREop+JkKAQrCSrrUBEGcqDawYWNaY7ScRpy3MxGrGbrK78DJg9FNfBF70TmtKXX5YX+gGj/5TGuGOIJw34uNd5qrLrad8/npKVdA18Q/OpFSzEQSRcmwXkuLJWgGYC6DY7TasYMOZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TjQYEX5S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TjQYEX5S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B56A2C4CEED;
	Tue,  2 Sep 2025 13:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819638;
	bh=QkjlpKKrohaXHhF4yAoDFbHTLeDjA5lwnUUFmik9Ev4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TjQYEX5SNSi3WxXDMyV/5jB4Ojh4Hn9/1UVPkLM6JhIygQum42OeHe3jz4X9vYErt
	 dkGv2GarWIMEelMneN6qI5QVT6BA48kdmi2WkwXxYDc4ZdkwVakhfpyQmsBXBfR0Hh
	 YqFRj7jdDJJ9W7MZBCnBSrg93QJyGgtXsZNz/WuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suoxing Zhang <aftern00n@qq.com>,
	Qingyue Zhang <chunzhennn@qq.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 093/142] io_uring/kbuf: fix signedness in this_len calculation
Date: Tue,  2 Sep 2025 15:19:55 +0200
Message-ID: <20250902131951.827164904@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qingyue Zhang <chunzhennn@qq.com>

[ Upstream commit c64eff368ac676e8540344d27a3de47e0ad90d21 ]

When importing and using buffers, buf->len is considered unsigned.
However, buf->len is converted to signed int when committing. This can
lead to unexpected behavior if the buffer is large enough to be
interpreted as a negative value. Make min_t calculation unsigned.

Fixes: ae98dbf43d75 ("io_uring/kbuf: add support for incremental buffer consumption")
Co-developed-by: Suoxing Zhang <aftern00n@qq.com>
Signed-off-by: Suoxing Zhang <aftern00n@qq.com>
Signed-off-by: Qingyue Zhang <chunzhennn@qq.com>
Link: https://lore.kernel.org/r/tencent_4DBB3674C0419BEC2C0C525949DA410CA307@qq.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/kbuf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index f2d2cc319faac..81a13338dfab3 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -39,7 +39,7 @@ static bool io_kbuf_inc_commit(struct io_buffer_list *bl, int len)
 		u32 this_len;
 
 		buf = io_ring_head_to_buf(bl->buf_ring, bl->head, bl->mask);
-		this_len = min_t(int, len, buf->len);
+		this_len = min_t(u32, len, buf->len);
 		buf->len -= this_len;
 		if (buf->len) {
 			buf->addr += this_len;
-- 
2.50.1



