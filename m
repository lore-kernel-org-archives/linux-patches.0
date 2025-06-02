Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA28225791;
	Mon,  2 Jun 2025 15:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877424; cv=none; b=dR4qv1yPW5F2uadoBy67vfu94r8qO4mTsOiMpW1zZ3kyCKmSiniK6zYfsjt8Zdz6Fk+F35AqxyqnddqM/RR9foT3HrR0lFRrRmDeG4mOdfjxfhTtFSOC4AlpNPVFMDnw1DkMPpvfw7jPfDoDezdHTlktpNqoCE8BfBgKYG0xmgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877424; c=relaxed/simple;
	bh=qSJGXFMUGNMHDtr5LowcuFcW57ruJiTGxNlaQQadoPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pXVxtvnztYJNjADlRAMxFPw2aue9BUpuPp5MMFosNpcCP1qa4sw9oTpv2882GJe+Jcm+semZO78dFpiGD8FzvXY+SxTfMs1GFzcbK73rox9PY6rd0tZFSBaYVPye1qy8TdSoKWiKuHN/TRaMEwo3HIdp+DXdLx+qR4EjiPh4bg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LCbpbpzQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LCbpbpzQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3092C4CEEB;
	Mon,  2 Jun 2025 15:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877424;
	bh=qSJGXFMUGNMHDtr5LowcuFcW57ruJiTGxNlaQQadoPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LCbpbpzQdKMpLQ3kmytEVuyHzzFa53R8vn9Lpoqsotwt8llafdRyZO2WHCWxlu/N8
	 0J4ZEdZRFh+F6hsIG9SREjF5G7QSgnLSNqeWdOnhB8VnHzDDyjYz1nlDjl4iLQGK7e
	 HGIKykh05XIrnQAD4rhkK4pm2qSblJoshttv1Bwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 243/325] io_uring: fix overflow resched cqe reordering
Date: Mon,  2 Jun 2025 15:48:39 +0200
Message-ID: <20250602134329.658617640@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f39d66589180e..ad462724246a7 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -627,6 +627,7 @@ static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 		 * to care for a non-real case.
 		 */
 		if (need_resched()) {
+			ctx->cqe_sentinel = ctx->cqe_cached;
 			io_cq_unlock_post(ctx);
 			mutex_unlock(&ctx->uring_lock);
 			cond_resched();
-- 
2.39.5



