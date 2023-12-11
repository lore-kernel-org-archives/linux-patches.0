Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B304FBE1;
	Mon, 11 Dec 2023 18:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q9W2lOLQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5F6FC433CA;
	Mon, 11 Dec 2023 18:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319466;
	bh=FNEKQXBom0b/+ZBtkfQQtVEeKnZTi3yYrWm15VaxkjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q9W2lOLQ3HcB3e9oewwgAYeS4xZzO2YwgLXH7XCvJ63QAtxliLXaQ6UBWlf8ZbKz2
	 p2VQaDBDh/MyusnB+ul9rCfg7C3va+Jp2R5CHPrbC1gndszTXz2gz/PU7OWX4OtKys
	 fT56fSGe17/7wJ3GrB63ibxpMRiCAbHMtPTzaLVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 116/244] io_uring/kbuf: check for buffer list readiness after NULL check
Date: Mon, 11 Dec 2023 19:20:09 +0100
Message-ID: <20231211182051.002976772@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

[ Upstream commit 9865346b7e8374b57f1c3ccacdc77846c6352ff4 ]

Move the buffer list 'is_ready' check below the validity check for
the buffer list for a given group.

Fixes: 5cf4f52e6d8a ("io_uring: free io_buffer_list entries via RCU")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/kbuf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 12eec4778c5b1..e8516f3bbbaaa 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -743,6 +743,8 @@ void *io_pbuf_get_address(struct io_ring_ctx *ctx, unsigned long bgid)
 
 	bl = __io_buffer_get_list(ctx, smp_load_acquire(&ctx->io_bl), bgid);
 
+	if (!bl || !bl->is_mmap)
+		return NULL;
 	/*
 	 * Ensure the list is fully setup. Only strictly needed for RCU lookup
 	 * via mmap, and in that case only for the array indexed groups. For
@@ -750,8 +752,6 @@ void *io_pbuf_get_address(struct io_ring_ctx *ctx, unsigned long bgid)
 	 */
 	if (!smp_load_acquire(&bl->is_ready))
 		return NULL;
-	if (!bl || !bl->is_mmap)
-		return NULL;
 
 	return bl->buf_ring;
 }
-- 
2.42.0



