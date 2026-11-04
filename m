Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826855;
	b=n33cBO9oFQw7GP8mGUkvN6oltziwp4YmNrn1iW/QvRixIYoUc7CMzT48+e6tJBxvDp+g
	 Sl+a5y95mc95Q/NFt1BhfXTTmtt4VsC1tYUZOETsyAKlKHRWo7PY7QE2dwSFWsTcUyOEE
	 kpSbuUCHpwGgUXTrgaGO4lvBxBa6b8xx9SxgIQbKOxKNeY1JWpfMC6wSzmdwiuadQUt8i
	 X/EnoqwK8KLpcF3dl0BH2/d5GTrw4aJnk2VVn35UltTX3dTNsMNR+OVRGyfhLU9RyzMTO
	 g46o5ARxt0b568sasr6+zzHmOw5sM2a9XSjA3Pcb2vpV+ytZzy+ed9xXzb0vXe4DKWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826855;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZUsM9tJY+YyrczOnzsgEYB6aM9nf+y69tNQ8CTriaE0=;
	b=y4TYqR8Ks7wR2VfzIdEpAGB1oSI4ri3A7B/XfJ3PX0hpjXzzgny2KqzNIR9lcPcraXwb
	 KLJHksKfS+JIhXqNi2Tku2NDvpTdQAecVFjb8Na6QNlaUhgCAxkjAxDI5AlazOBy/O+qk
	 raiz4+5IvNOeposhbbDCZTKZecgVMMBu3JHs865cSVwL8VfeTo7ZMGHZS8xB0K0mekaeA
	 B+aKFH1/r6J+FBB+rvsa159nrQ3vlTA6Re/X5FjaV26Xyawvz+9X2F7TYP8pB08qU83T3
	 FWrG8ahX5KCPOAAu0JFTHlkgXoHF0WncsV8LU6AEFWS4TGz2GlQxeyvswG3bt8Q959w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EnJlNCtQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2543607042D;
	Wed,  4 Nov 2026 21:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EnJlNCtQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CE1F1F00A02;
	Wed,  4 Nov 2026 21:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826854;
	bh=ZUsM9tJY+YyrczOnzsgEYB6aM9nf+y69tNQ8CTriaE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EnJlNCtQI00j7s8qR79tTY0OaOJW74TTF/uc0E0OPstEQkGtrp+mJw3NaPskIQ3Dy
	 le2qFvnMm3fbR4GI5ZGcFgmZ7539c5vJaxEHTeMQvQmL5cwqA0+yLzBmQ9o7DVZ0vB
	 gST44tMzL8sDIUXyTG3FdTi5U47td4W07i12lAws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 046/547] io_uring/timeout: keep repeat count on multishot update
Date: Wed,  4 Nov 2026 16:03:50 -0500
Message-ID: <20261104211039.623707746@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 3dc2a32cd356ee382aa4a8c7d844c53b2c0ad83b ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/timeout.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index fbf0ba1ba7f9f..38ee4e966e8e7 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -475,8 +475,10 @@ static int io_timeout_update(struct io_ring_ctx *ctx, __u64 user_data,
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
-	timeout->off = 0; /* noseq */
 	data = req->async_data;
+	/* for a multishot request this isn't a sequence, keep the repeats */
+	if (!(data->flags & IORING_TIMEOUT_MULTISHOT))
+		timeout->off = 0; /* noseq */
 	data->time = time;
 
 	list_add_tail(&timeout->list, &ctx->timeout_list);
-- 
2.53.0



