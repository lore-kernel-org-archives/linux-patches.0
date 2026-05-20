Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A413F65E6;
	Wed, 20 May 2026 17:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299998; cv=none; b=gQC9Vm5UC2qcygpPQZdmuBV+p8sFDHfyBlTpDJEw4jBJ/QYpjszSIx9tbAdpuo7lD1b2lKgv9SbEBOfxE0x2cnoW/yBTWFw3Tu+YV7YM6jbI4sot6oItCXJGdzGhHlwi5RWt/X3WqJYmsgJFOA7m9knjc8neK2xEnWVg3R2gK+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299998; c=relaxed/simple;
	bh=Mp1eaa4gIBx323x72iYhDNRoA7ZXvtpEDt+Pu15QVNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nvUOr+/7i84w7HMWitC4u6ab/Q8f9VNsXMKgc+jwI9ZTiMTjTVxkKnsTTaVHVCOdFGeDSHS//cOKk9GP2CJvubJnei4SiMjm0GXSelmAKMn76/mA6PppVqR6dazT9dw701uhbR78mnv+4d3R9G0bh8Nk1gYv6htOpMNJTvKNMBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aXtevr04; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aXtevr04"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7BF01F000E9;
	Wed, 20 May 2026 17:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299997;
	bh=fjvDaB5GWEhaYxSuMiWGovGMJCGzYJdZjEMifRSTDdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aXtevr0486HA5XWlvPXxPhpFh8xxFbXKUUSe1QSnUDGsOZGXq45CUTx0Pgllq7z25
	 nJwvjDrMyymyz88GlopUISXXehZfSQVEQIMQa6/uKv0vBvW9I0ySaHxKDyOfERyehB
	 Ovq6qUw/H0QlzgttboPp0VK9ZiLyBKX8fYJeE9Ck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 001/666] io_uring/kbuf: use mem_is_zero()
Date: Wed, 20 May 2026 18:13:32 +0200
Message-ID: <20260520162111.260571789@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

commit 1724849072854a66861d461b298b04612702d685 upstream.

Make use of mem_is_zero() for reserved fields checking.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/11fe27b7a831329bcdb4ea087317ef123ba7c171.1747150490.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/kbuf.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -705,8 +705,7 @@ int io_register_pbuf_ring(struct io_ring
 
 	if (copy_from_user(&reg, arg, sizeof(reg)))
 		return -EFAULT;
-
-	if (reg.resv[0] || reg.resv[1] || reg.resv[2])
+	if (!mem_is_zero(reg.resv, sizeof(reg.resv)))
 		return -EINVAL;
 	if (reg.flags & ~(IOU_PBUF_RING_MMAP | IOU_PBUF_RING_INC))
 		return -EINVAL;
@@ -773,9 +772,7 @@ int io_unregister_pbuf_ring(struct io_ri
 
 	if (copy_from_user(&reg, arg, sizeof(reg)))
 		return -EFAULT;
-	if (reg.resv[0] || reg.resv[1] || reg.resv[2])
-		return -EINVAL;
-	if (reg.flags)
+	if (!mem_is_zero(reg.resv, sizeof(reg.resv)) || reg.flags)
 		return -EINVAL;
 
 	bl = io_buffer_get_list(ctx, reg.bgid);
@@ -793,14 +790,11 @@ int io_register_pbuf_status(struct io_ri
 {
 	struct io_uring_buf_status buf_status;
 	struct io_buffer_list *bl;
-	int i;
 
 	if (copy_from_user(&buf_status, arg, sizeof(buf_status)))
 		return -EFAULT;
-
-	for (i = 0; i < ARRAY_SIZE(buf_status.resv); i++)
-		if (buf_status.resv[i])
-			return -EINVAL;
+	if (!mem_is_zero(buf_status.resv, sizeof(buf_status.resv)))
+		return -EINVAL;
 
 	bl = io_buffer_get_list(ctx, buf_status.buf_group);
 	if (!bl)


