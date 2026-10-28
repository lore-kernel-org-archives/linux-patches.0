Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210501;
	b=Yyhjqjiv3svloev1FkG9xhEAw3u/3jcGRuvnik06x6gY9pm63GQ98mlgxK3S8tcTy8kR
	 +STyCf4RNB3gK1V364nGFIKdVC2NjZbOoE+3YMz5MuEDoZGE4TtETN+xqbK8PalDAiOM3
	 1VkzIgxQLLH914qIoh/HzqMKkW7waeVnSrBAjVJQxfgAUirm7gEf+amU7KDirqVQ3qwTi
	 As40mAXH1jdCPKo7yDq+36SufafmQZ1DPBvvh2Whnj7iGrHk63eQpuPspHURVPSiwSzo2
	 vogRGDAp6lQLpAo+t7fBpc+HEefjzBUC35DD8wZXeizU6XtrNRegTBZfzpi0IN7trwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210501;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z5Cha6JMaMcUtNruaEi082JyELjff/E+hGX5bJ+XQww=;
	b=n67oi5/SoYR/Wyrbm5L7rCW1xCFPKW2xZY4FdQGxg7TrmFqMmuNskZe9I5SlGcSr+6uL
	 VPNHw4yA8WRhYimtcnh4uZfpZfTfEeFuA1bk+c351f8HC9XU3QOJkJqwdYb6vj9whaaDN
	 8MAQ4SqU1tiOZ5P9830U6ACiwEUXWgoG4LDFEu4926LGe6RxNJNb2ejcpok10lTfgXRal
	 ARb4E3lejRTyCJ3eo3ApAXgf1DpyJOBdW/j6FCYaxE/mpY+IPwMpxfR3wFJOIf5MAdbLI
	 aPMG9YcP0+gX6Wv7fnEIfICy4CY/uwvYWYXgAratQBBAb7RZijcbAVwJBY9fXqkZUHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fhbrifui;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004A8606A31C;
	Wed, 28 Oct 2026 18:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fhbrifui
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54AF81F01829;
	Wed, 28 Oct 2026 18:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210500;
	bh=z5Cha6JMaMcUtNruaEi082JyELjff/E+hGX5bJ+XQww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fhbrifuiXl0+NsNawYGdi5/OLHktQCI2BM6wcG9bn63jkRqQy34bRfaOW0rMBiL3v
	 xwxFj2P73YEQem4T/Bb4a7EVN4yVfpcpTiWQfcltuXqKCraonR9CKN0vGeNDmDXK+9
	 QDId/PvZuX3Ewc71wnC+LnK7y+1ePR8V1IkTS8h8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Longlong Xia <xialonglong@kylinos.cn>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Jens Axboe <axboe@kernel.dk>,
	Minchan Kim <minchan@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 049/571] zram: fix out-of-bounds access in read_block_state()
Date: Wed, 28 Oct 2026 17:53:16 +0100
Message-ID: <20261028170009.192422741@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Longlong Xia <xialonglong@kylinos.cn>

[ Upstream commit 391f057f44a51cc9418da5cba78b014324174264 ]

read_block_state() calculates nr_pages before taking dev_lock.  If the
device is reset and reinitialized with a smaller disksize before lock
acquisition, nr_pages still describes the old table.  The subsequent loop
can then call slot_lock() past the end of the newly allocated table.

Read disksize after acquiring dev_lock and checking that the device is
initialized.  The read lock then keeps the table and its bound stable for
the duration of the scan.

Link: https://lore.kernel.org/20260804065919.3970386-3-xialonglong2025@163.com
Fixes: c0265342bff4 ("zram: introduce zram memory tracking")
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/zram/zram_drv.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index d1f4b61509a0c..5c44967b1c73f 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -885,7 +885,7 @@ static ssize_t read_block_state(struct file *file, char __user *buf,
 	char *kbuf;
 	ssize_t index, written = 0;
 	struct zram *zram = file->private_data;
-	unsigned long nr_pages = zram->disksize >> PAGE_SHIFT;
+	unsigned long nr_pages;
 
 	kbuf = kvmalloc(count, GFP_KERNEL);
 	if (!kbuf)
@@ -898,6 +898,8 @@ static ssize_t read_block_state(struct file *file, char __user *buf,
 		return -EINVAL;
 	}
 
+	nr_pages = zram->disksize >> PAGE_SHIFT;
+
 	for (index = *ppos; index < nr_pages; index++) {
 		int copied;
 		struct timespec64 ts;
-- 
2.53.0



