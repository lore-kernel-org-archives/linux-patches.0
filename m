Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 342FB2EE299;
	Thu,  3 Jul 2025 15:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554886; cv=none; b=HT1DpmJcV1ZIFYWGPKp2YpB7iRSzKiUeMTHykqdYHF/ZxCBOf86KMxqvggzRPuKmrnJWAmvRSeOT0A1YMEd7zW8EAfh/3yt0EtzR1+5sLny5V0CssGnQODV7FDbMn8VgdGgDazd2Yk0YbiJm9KTCqYyWnP37r0D2ftvE20sFFOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554886; c=relaxed/simple;
	bh=zDiY1dJmBbkdMgCvkK4WhP0prqEQgybr6k/WuLrnwbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SvryxYGE27IQNnMqqyy8L3C5z0t68Pciuddy3gKBP7DziATmtAh1lCB/jVfeTl7EtWwzgdJrwufr9w9XiYyZQ+BuWDbkxjxxJ6Nzp2uBM90vDrcUVyHgQQOFRN/d8hq2v8BajAqNJqw9+InVy8QCm/AVbdLMbg7OqpXB5bDMdRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eITiMBV0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eITiMBV0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFEF4C4CEF3;
	Thu,  3 Jul 2025 15:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554886;
	bh=zDiY1dJmBbkdMgCvkK4WhP0prqEQgybr6k/WuLrnwbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eITiMBV0FtGDOCx5713S/Kl4QdZtUcq65FBSYM6Dsd5TzWirH+qMp6Tnru5rb4ue6
	 CaCwKtUaDcuyLW0Ap5b4uJbJPY3K3xrKumVxQF90usReBl3IUuDzEfcHSq+F56/mtW
	 G3AX+L0XUI7i/igE+ysuHzxs88v15kFizZKzblHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 092/263] io_uring/zcrx: improve area validation
Date: Thu,  3 Jul 2025 16:40:12 +0200
Message-ID: <20250703144007.986197276@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit d760d3f59f0d8d0df2895db30d36cf23106d6b05 ]

dmabuf backed area will be taking an offset instead of addresses, and
io_buffer_validate() is not flexible enough to facilitate it. It also
takes an iovec, which may truncate the u64 length zcrx takes. Add a new
helper function for validation.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/0b3b735391a0a8f8971bf0121c19765131fddd3b.1746097431.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 0ec33c81d9c7 ("io_uring/zcrx: fix area release on registration failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/rsrc.c | 27 +++++++++++++++------------
 io_uring/rsrc.h |  2 +-
 io_uring/zcrx.c |  7 +++----
 3 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 794d4ae6f0bc8..6d61683223870 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -80,10 +80,21 @@ static int io_account_mem(struct io_ring_ctx *ctx, unsigned long nr_pages)
 	return 0;
 }
 
-int io_buffer_validate(struct iovec *iov)
+int io_validate_user_buf_range(u64 uaddr, u64 ulen)
 {
-	unsigned long tmp, acct_len = iov->iov_len + (PAGE_SIZE - 1);
+	unsigned long tmp, base = (unsigned long)uaddr;
+	unsigned long acct_len = (unsigned long)PAGE_ALIGN(ulen);
 
+	/* arbitrary limit, but we need something */
+	if (ulen > SZ_1G || !ulen)
+		return -EFAULT;
+	if (check_add_overflow(base, acct_len, &tmp))
+		return -EOVERFLOW;
+	return 0;
+}
+
+static int io_buffer_validate(struct iovec *iov)
+{
 	/*
 	 * Don't impose further limits on the size and buffer
 	 * constraints here, we'll -EINVAL later when IO is
@@ -91,17 +102,9 @@ int io_buffer_validate(struct iovec *iov)
 	 */
 	if (!iov->iov_base)
 		return iov->iov_len ? -EFAULT : 0;
-	if (!iov->iov_len)
-		return -EFAULT;
-
-	/* arbitrary limit, but we need something */
-	if (iov->iov_len > SZ_1G)
-		return -EFAULT;
 
-	if (check_add_overflow((unsigned long)iov->iov_base, acct_len, &tmp))
-		return -EOVERFLOW;
-
-	return 0;
+	return io_validate_user_buf_range((unsigned long)iov->iov_base,
+					  iov->iov_len);
 }
 
 static void io_release_ubuf(void *priv)
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index b52242852ff34..4373524f993c7 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -83,7 +83,7 @@ int io_register_rsrc_update(struct io_ring_ctx *ctx, void __user *arg,
 			    unsigned size, unsigned type);
 int io_register_rsrc(struct io_ring_ctx *ctx, void __user *arg,
 			unsigned int size, unsigned int type);
-int io_buffer_validate(struct iovec *iov);
+int io_validate_user_buf_range(u64 uaddr, u64 ulen);
 
 bool io_check_coalesce_buffer(struct page **page_array, int nr_pages,
 			      struct io_imu_folio_data *data);
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index ecb59182d9b2c..0771a57d81a5b 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -205,7 +205,6 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
 {
 	struct io_zcrx_area *area;
 	int i, ret, nr_pages, nr_iovs;
-	struct iovec iov;
 
 	if (area_reg->flags || area_reg->rq_area_token)
 		return -EINVAL;
@@ -214,11 +213,11 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
 	if (area_reg->addr & ~PAGE_MASK || area_reg->len & ~PAGE_MASK)
 		return -EINVAL;
 
-	iov.iov_base = u64_to_user_ptr(area_reg->addr);
-	iov.iov_len = area_reg->len;
-	ret = io_buffer_validate(&iov);
+	ret = io_validate_user_buf_range(area_reg->addr, area_reg->len);
 	if (ret)
 		return ret;
+	if (!area_reg->addr)
+		return -EFAULT;
 
 	ret = -ENOMEM;
 	area = kzalloc(sizeof(*area), GFP_KERNEL);
-- 
2.39.5



