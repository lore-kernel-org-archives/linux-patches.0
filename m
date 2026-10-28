Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210295;
	b=Uozpg6oPznr70s9he6NCN5wlbqPHQ1PJsdaivF+FJZG8dZyArJ0e2fIVKdwxqr7gX87x
	 FmD2ZgVJGGwVH+WVZaMUc6uU5JWFMCLAf0wPuY33JwR8Hdqrd4I0Eyt8Hltci0F4JsX1h
	 vOaqLF6MZ57UIdY/4q8QtelcXAr+KS/Mbwla06JT+q+XjaS/dkPqn15aAxYZOJGBTBufI
	 fTWEQKTIUWhQgtqhgCvtw6Vi9I71xQBxIZ/K8R+kzXo4oSbE0QCPPTOq1Lz1lTw77P5rs
	 4hdQnhVh6fdJBDv++ny9c24Ycp5Owrq24/qhLZPuttJN81rfloZjkV7r7VqqvHTPl8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210295;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MNV4btmOTW25v0yBu1KyQw/wSdceq91davPbDJe+N4Q=;
	b=UXAPkTVW/T931rhDJ/8IgP+4QKYpBjgtG5sQrIBTQaM2/aqYUoXAAGtvQjxkppPOw4H5
	 QKpnXTdMKcSYM9z9noWy2Ef4wUk96Dk3UgN389edHl2OU/YzURDAQ6OLuefdvJmAtBPXq
	 BU9c/ppmwpkmD6NvOAhgXS5K7b81bW5BfmQfZo5pNCf1ADhLldOYW5VI1iYdaYoFAK8wx
	 2K7+a8iB/7nmbRgm7UABlmPhjyYduZs1fI3rtteGm3bucnRIsZNIpAhQVywYctCAeIBoa
	 kTJtXZWLrElSGvwPIUkasCQIWfOsQahjAPkJ4nTbBHL+iweOOg+D7t7ZxzL7PhR5fIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ecRFK3XK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D91606A31D;
	Wed, 28 Oct 2026 17:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ecRFK3XK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C4141F01825;
	Wed, 28 Oct 2026 17:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210295;
	bh=MNV4btmOTW25v0yBu1KyQw/wSdceq91davPbDJe+N4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ecRFK3XKBcLAhBeytlIAz8jZ5aO2ZDTX117SFwai3SY792e9D2boTtxEJH2t7d/GM
	 hy7ouCGsoIJMl3T+ONocuJccyLfb7phLrGbfZwOH2R3H5VV26b+sBTTHaCf+3FA7Bd
	 UEbzfN0E8e+B0F9wszxagp39e/vWJ6S2HoOV+7Xk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 143/168] io_uring/timeout: keep repeat count on multishot update
Date: Wed, 28 Oct 2026 18:01:19 +0100
Message-ID: <20261028165946.468878507@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -411,8 +411,10 @@ static int io_timeout_update(struct io_r
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
-	timeout->off = 0; /* noseq */
 	data = req->async_data;
+	/* for a multishot request this isn't a sequence, keep the repeats */
+	if (!(data->flags & IORING_TIMEOUT_MULTISHOT))
+		timeout->off = 0; /* noseq */
 	data->ts = *ts;
 
 	list_add_tail(&timeout->list, &ctx->timeout_list);


