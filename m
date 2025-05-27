Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B1827FB3D;
	Tue, 27 May 2025 17:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368549; cv=none; b=j8hD9zPunmBLNVt3NyL77vp5aoEtlglfZut6tB143f1GTAK/qx6XR934M/1dNXsm662fpHYP+CaTKLgwRvapWLl/MfgWtuwtj42jCXbnw/6P1C3RnAC4XBvhNbZi8ZTmSVHZdVRcN12EuOpHfQxvMmUk/33Ds/TttfBa1usR6Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368549; c=relaxed/simple;
	bh=uHw1Jfj4PHIPHaL4AxuAiWEfjkFmlhYRpf5K8YgF/z8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JalnLHmKzsfvITdKMPVYSTR7y3yDFwEgOdH1EXUDIyzGlLe6RhJU4/OBQZXYGZoDsg2Vg+CyW916cLb2gfxUHEWEr40E3lQ/IopQCBfodDg97hTeFqkIW8SCKvUW6jjd6G6utzfvslWWrH5GTNk1wBvQfWeeuxuM1d+BV5gJn+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ItH7J4m8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ItH7J4m8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85E38C4CEE9;
	Tue, 27 May 2025 17:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368548;
	bh=uHw1Jfj4PHIPHaL4AxuAiWEfjkFmlhYRpf5K8YgF/z8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ItH7J4m8dC0btRao9yanmwxSh4bKC+oW5tZBswN8H3RbOf0ANyNEX51emvsY6+bYe
	 kIzysS+nC14yheAn66gDCDu7ykJGbBfZ26468tLTGd4RbX3oopbO2JA9HnJs1l3q7m
	 +OQdITKdf92hdu3HCfWDX6sAHAOUtIB1lr5g5BOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 711/783] io_uring: fix overflow resched cqe reordering
Date: Tue, 27 May 2025 18:28:28 +0200
Message-ID: <20250527162542.071196375@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit a7d755ed9ce9738af3db602eb29d32774a180bc7 ]

Leaving the CQ critical section in the middle of a overflow flushing
can cause cqe reordering since the cache cq pointers are reset and any
new cqe emitters that might get called in between are not going to be
forced into io_cqe_cache_refill().

Fixes: eac2ca2d682f9 ("io_uring: check if we need to reschedule during overflow flush")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/90ba817f1a458f091f355f407de1c911d2b93bbf.1747483784.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 52c9fa6c06450..1f60883d78c64 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -632,6 +632,7 @@ static void __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool dying)
 		 * to care for a non-real case.
 		 */
 		if (need_resched()) {
+			ctx->cqe_sentinel = ctx->cqe_cached;
 			io_cq_unlock_post(ctx);
 			mutex_unlock(&ctx->uring_lock);
 			cond_resched();
-- 
2.39.5



