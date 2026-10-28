Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209765;
	b=U7L5k1nXCHlEbbRBv5Y8g+7vK8KPF3eocFLcKoZrP4sVBKXzkJkl0aZ4EZYx6i9lsBx+
	 Y7ZFj2OOP0N4FyIEQ+YvKqBA/Xh7vjE2nKxnsVv2cVCTErazAxHfm/3ZGy4YxTe82+6IG
	 envSyXottXLyYJaF3bZx+9VxDQFGRTesUkkZrWUgMRzMbi0qK3XCSXXDxPDYYAgNqzb3m
	 lr1e3olTc04lTeN6zVqYz/r5QrlcMwiVKYkCk3yNpfeaHJ8t7rdZOYTQLLT8hLSBYTLGf
	 KTPTzY7tVF+qVNdelEgjYxVlP4qdJnQpssnkLzgsoDrJ+DIitEZxietar0ZzmXbEm7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209765;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wJj3xFG9MVj/Wx7u9P2hh6s5sfphEJni+PUK6iGJe84=;
	b=0J1xtQFFSapx6YH7cgebgBn4AAA4QJaMIDCyjyuXUS2+VAgZhwlJtAk9K65CQ3U45syt
	 asisz4vMDNs0oDGUJ5PkcldYAqX/NPEaeMiHDNfssMl30jVocU+stx/7rI4vLtXpuMbC1
	 CHXlkdX0lwIttoDpSD42ohUbaTXBnDHtjvQcG0O1U/+ZsePsTgdDaOJw78G7Cys6jzDpw
	 lKruz3mdfqXjEKxHTz5J3/19G52MzcnFYViMshJILqOT+hs24eaTdpDatgiB3a/VnCE/m
	 44JgC+NHPibtGa7I2nVbPJQZ4ZcdPvggfJzWqc/Wou6zKlHj5zt20Fob2az1M6LIPnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O5RNplk5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34468606A31D;
	Wed, 28 Oct 2026 17:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O5RNplk5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85EBA1F01825;
	Wed, 28 Oct 2026 17:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209765;
	bh=wJj3xFG9MVj/Wx7u9P2hh6s5sfphEJni+PUK6iGJe84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O5RNplk5dg/QQy6CTGBx8jGSP+3Wo/ulpu+arFcWowGYL61ZDgbTmvIAQ5txI8IAA
	 EWUQG3azKphixyYHkZr6Jkdai0RscW3hHe5q1qq2lB+VGlmrVR6x0G2NYDi8xEUEWh
	 gPq6tU4RAwPzF67bNhA30mUkBBESUTtV1sZUIcqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 068/109] io_uring/timeout: keep repeat count on multishot update
Date: Wed, 28 Oct 2026 18:00:52 +0100
Message-ID: <20261028165943.958199437@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
References: <20261028165942.357251485@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -433,8 +433,10 @@ static int io_timeout_update(struct io_r
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
-	timeout->off = 0; /* noseq */
 	data = req->async_data;
+	/* for a multishot request this isn't a sequence, keep the repeats */
+	if (!(data->flags & IORING_TIMEOUT_MULTISHOT))
+		timeout->off = 0; /* noseq */
 	data->ts = *ts;
 
 	list_add_tail(&timeout->list, &ctx->timeout_list);


