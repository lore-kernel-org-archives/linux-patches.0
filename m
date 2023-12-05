Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380FD6AA0;
	Tue,  5 Dec 2023 03:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b+isCYqb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A5B1C433C7;
	Tue,  5 Dec 2023 03:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746508;
	bh=LKXLSVTwIfVoI6y3YWEQjMAknizSJ7pjZRzGlKDDamU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b+isCYqb/5ujAq8jk9xVwpLlIz4nOopkzuSsjwRG+X0IWfWsqv09JYg1HcUTm+GGy
	 Bs/O7yhCObRPJeVrzT/Wg+SR3r73YfNgw+ZeO0Ik4Vg7TbXTGkgr4TBQkmeNK53Klm
	 vJLeaIExQiZQVvtVVFxuszzy3OQz1VoinV9o7zh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 049/134] io_uring: dont guard IORING_OFF_PBUF_RING with SETUP_NO_MMAP
Date: Tue,  5 Dec 2023 12:15:21 +0900
Message-ID: <20231205031538.709444774@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

commit 6f007b1406637d3d73d42e41d7e8d9b245185e69 upstream.

This flag only applies to the SQ and CQ rings, it's perfectly valid
to use a mmap approach for the provided ring buffers. Move the
check into where it belongs.

Cc: stable@vger.kernel.org
Fixes: 03d89a2de25b ("io_uring: support for user allocated memory for rings/sqes")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3436,16 +3436,18 @@ static void *io_uring_validate_mmap_requ
 	struct page *page;
 	void *ptr;
 
-	/* Don't allow mmap if the ring was setup without it */
-	if (ctx->flags & IORING_SETUP_NO_MMAP)
-		return ERR_PTR(-EINVAL);
-
 	switch (offset & IORING_OFF_MMAP_MASK) {
 	case IORING_OFF_SQ_RING:
 	case IORING_OFF_CQ_RING:
+		/* Don't allow mmap if the ring was setup without it */
+		if (ctx->flags & IORING_SETUP_NO_MMAP)
+			return ERR_PTR(-EINVAL);
 		ptr = ctx->rings;
 		break;
 	case IORING_OFF_SQES:
+		/* Don't allow mmap if the ring was setup without it */
+		if (ctx->flags & IORING_SETUP_NO_MMAP)
+			return ERR_PTR(-EINVAL);
 		ptr = ctx->sq_sqes;
 		break;
 	case IORING_OFF_PBUF_RING: {


