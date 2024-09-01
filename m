Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 869AC1E87B;
	Sun,  1 Sep 2024 16:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208545; cv=none; b=UrxrTsH7mdegZsXlcZ0XPqxZENz9Y7iw7sZVUo1FJGbbjy0ol5RzSMBhdB8qVMbh4H9R/pRAR+ES+RSQVwb3sp5OUNSQ7Faxb4jUTGyY56xLQSlMNw6AGOg9HkRiUYw1rcEbSyUnN/zc1NVlYa4gyhewD3W+9HK6BnsqzyVemwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208545; c=relaxed/simple;
	bh=jKaqa0IP2wwSJoFaDUG4DogTFAdqjdto1/kdLLJgBhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GLXdG88Rxl8GW/6sYcx0ZKHuGkD+yzmHlCcjiIxdjAiytzMoimZvTm5qJfL6eEG+bD9AB5081nhQ3bSngGkzYJ7VjsuuTKpsvLa16LP5IkRPLswwYnXZwK8PU9UdaN9of05NyEojGK10+sPVBulOmJ52oSp+F1za8tD2g15QGns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XchD042b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XchD042b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DA65C4CEC3;
	Sun,  1 Sep 2024 16:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208545;
	bh=jKaqa0IP2wwSJoFaDUG4DogTFAdqjdto1/kdLLJgBhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XchD042bnTqbv5SITH8AWRmI2YvY7zKvUBLBe25qVAQR+20m7jH12L4dXR3DJHTIv
	 viqcSILbHmweNph5qr30iDXeUR42MlODSmfCa0iBDpiyjVoHnKIv6RLs7oxqqErRxP
	 ruMrJ2MuTT/WZOvdxRA3ZIAVB2td/jmSZ2QZLCSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 114/149] io_uring/kbuf: return correct iovec count from classic buffer peek
Date: Sun,  1 Sep 2024 18:17:05 +0200
Message-ID: <20240901160821.743169278@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit f274495aea7b15225b3d83837121b22ef96e560c ]

io_provided_buffers_select() returns 0 to indicate success, but it should
be returning 1 to indicate that 1 vec was mapped. This causes peeking
to fail with classic provided buffers, and while that's not a use case
that anyone should use, it should still work correctly.

The end result is that no buffer will be selected, and hence a completion
with '0' as the result will be posted, without a buffer attached.

Fixes: 35c8711c8fc4 ("io_uring/kbuf: add helpers for getting/peeking multiple buffers")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/kbuf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 1af2bd56af44a..bdfa30b38321b 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -129,7 +129,7 @@ static int io_provided_buffers_select(struct io_kiocb *req, size_t *len,
 
 	iov[0].iov_base = buf;
 	iov[0].iov_len = *len;
-	return 0;
+	return 1;
 }
 
 static struct io_uring_buf *io_ring_head_to_buf(struct io_uring_buf_ring *br,
-- 
2.43.0



