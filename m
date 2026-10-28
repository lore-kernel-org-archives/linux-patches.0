Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207269;
	b=sTti0C1flbvwyhjs4rbVORtDao0+zNyV67XZU6HkpSrvHudjx0MhrwtwLI7BOruDUdob
	 8DGeopgipI9T2JSAMsHMEdyP0s51rYTRZQI7IRdMfZLfv8uRemlZgDvIdRiox1MWBTpC1
	 lIOqcf59s18QOYoUOqPlJcTefRLC91UaC2VULXOt6EgH94Rl6y0PKCV3Z9mC6rAZTZ/VW
	 PdFM9112PPCxwJ0JfbarbCgNIL6p6xMEmiGNmAX47bfw+8+ZEF62IAP9z/HstBzhkgA4G
	 e8fmXpaIF4guP2gzLCK1Q19V/k82jOidvBQ5PqSc+vozVQndrABshv4dlp2wG4w1k2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207269;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aC4EX0IcgWaWlzCHh+MwN/SNrhOwrxIet52+6XMNUIo=;
	b=5gmK7E98KLB+Gp+6td+UivZhlsFFyoIaT9Y4NBzYFd59UpvCivOn6/mQLsjm4nqxJs3J
	 QCyuPYWftEMomdmrPsJdF2P8KK/+EOXLEocaKQUNkZ1L8f/ZguazuQh138mH61yhiOkJe
	 rBp3iwYwTrkplKzdstSTfhBEekU7gityjKdBnIaZH634PjmQsqj6H/6KdRGBbGooK9Jn3
	 DSDmcW0q9YZiPdJauFQFG9u2/ITXIiFfILrj/fFqqGA8k4a+y7ZfPwl0e1b35UkoKbYYO
	 msIKKKLVUVxey6mcCjOc5TlY1SApHQZcWdJkGPzeHGEYF1WlZ2uIh5YyT/3G0tQRBCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lMJBF4S7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E89606A320;
	Wed, 28 Oct 2026 17:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lMJBF4S7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEEF21F01825;
	Wed, 28 Oct 2026 17:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207269;
	bh=aC4EX0IcgWaWlzCHh+MwN/SNrhOwrxIet52+6XMNUIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lMJBF4S7Z/gCW0UcP5dC/dUrBK1fvGjoJrtsTDr2QJzMBfL39DyimgLJrrJujsaHm
	 euBrXpO3d348DgyUc6MzhG+gPjjOssh/DcNtUqv1QjSfSWCg3ZuPvLK4l1aTw6AZ7W
	 afOxptfCmXy/2uM4PtJkZ3O2kzNwFuUqYbVhqBPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 46/88] io_uring/timeout: keep repeat count on multishot update
Date: Wed, 28 Oct 2026 17:59:54 +0100
Message-ID: <20261028165943.198897642@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.107695352@linuxfoundation.org>
References: <20261028165942.107695352@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

Commit 3dc2a32cd356ee382aa4a8c7d844c53b2c0ad83b upstream.

IORING_TIMEOUT_UPDATE clears ->off of the timeout it updates, to turn a
timeout that waits for a number of completions into a pure one. For a
multishot timeout ->off isn't a sequence though, it tells whether the
number of repeats is limited: io_timeout_finish() only looks at
->repeats if ->off is set.

A multishot timeout that was set up to fire N times hence fires forever
once its interval has been updated. Leave ->off alone for those, they are
never treated as sequence timeouts anyway.

Fixes: ea97f6c8558e ("io_uring: add support for multishot timeouts")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-30-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/timeout.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -475,8 +475,10 @@ static int io_timeout_update(struct io_r
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
-	timeout->off = 0; /* noseq */
 	data = req->async_data;
+	/* for a multishot request this isn't a sequence, keep the repeats */
+	if (!(data->flags & IORING_TIMEOUT_MULTISHOT))
+		timeout->off = 0; /* noseq */
 	data->time = time;
 
 	list_add_tail(&timeout->list, &ctx->timeout_list);


