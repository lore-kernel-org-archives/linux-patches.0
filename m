Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD16B47A74;
	Mon,  1 Apr 2024 16:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988339; cv=none; b=CG6lJoDwFqty4d0SNDMgjbe62GmZM+8+I18p9IocS2Uhjr8wkY+GD1BelK8l14OIIPcKNDL0uHwQe34ZT6CNVq045vCM3vE/ydpJQXSuXKBmXvUcQn5hZoObn+L4YBKnCo4y9desvVCA4on7PG4v9qV/ahaagfjBlM+0xm+NFBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988339; c=relaxed/simple;
	bh=E+2d6KVodRoinNr7EeThB2ivt4v5vxwk+Kt4nTLwcXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X+r4vpj+8U5PxAsNwKzks1U+t1DI2S/1Jbz7lpXIVVfZo3RTj9NIFchN3XxW32de2O4wkIZDnR8LziwnsgNSdtczEALpeWPj6Dv/fOd3dAlTqR17EsG+5ri6SI461Bu1IxtCGthHTjRC99z5diIIzBJAwrOXeewv8ecXZ7DowKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RdF9Xtof; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RdF9Xtof"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D698C433C7;
	Mon,  1 Apr 2024 16:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988339;
	bh=E+2d6KVodRoinNr7EeThB2ivt4v5vxwk+Kt4nTLwcXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RdF9Xtof6uDA/RijM1H/V7kRMncx6JfU4K/25IYE+JySySYgvdhXF+yGBfv1kAYlv
	 FVRpAyBlN6L/awzaJBaRpNA/Ve5NHpjkoLGpi5I78Kb7XZmIPa2SpZoxxjP9xbMBI3
	 lWhKRBkbPgYvSiQcZvxPa8BCm3K/62bD/5Gd5/3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 155/432] io_uring: clean rings on NO_MMAP alloc fail
Date: Mon,  1 Apr 2024 17:42:22 +0200
Message-ID: <20240401152557.766700385@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit cef59d1ea7170ec753182302645a0191c8aa3382 ]

We make a few cancellation judgements based on ctx->rings, so let's
zero it afer deallocation for IORING_SETUP_NO_MMAP just like it's
done with the mmap case. Likely, it's not a real problem, but zeroing
is safer and better tested.

Cc: stable@vger.kernel.org
Fixes: 03d89a2de25bbc ("io_uring: support for user allocated memory for rings/sqes")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/9ff6cdf91429b8a51699c210e1f6af6ea3f8bdcf.1710255382.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 45d6e440bdc04..13a9d9fcd2ecd 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2757,14 +2757,15 @@ static void io_rings_free(struct io_ring_ctx *ctx)
 	if (!(ctx->flags & IORING_SETUP_NO_MMAP)) {
 		io_mem_free(ctx->rings);
 		io_mem_free(ctx->sq_sqes);
-		ctx->rings = NULL;
-		ctx->sq_sqes = NULL;
 	} else {
 		io_pages_free(&ctx->ring_pages, ctx->n_ring_pages);
 		ctx->n_ring_pages = 0;
 		io_pages_free(&ctx->sqe_pages, ctx->n_sqe_pages);
 		ctx->n_sqe_pages = 0;
 	}
+
+	ctx->rings = NULL;
+	ctx->sq_sqes = NULL;
 }
 
 void *io_mem_alloc(size_t size)
-- 
2.43.0



