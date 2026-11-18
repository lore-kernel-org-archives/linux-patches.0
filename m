Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028244;
	b=NehU1oGH933G6lt/wSFrAUtg9InE0Awvjs4xtL4hvkT+IVM014kllFcRnpmT47Z37FpA
	 AxjaXhD5/QzX3VMLy7YnV+PMT9uNZTMcrGflMLzKyUpbafXVjpCTRWzmyVSOZst10BNL5
	 BSTmfQ+mfPVUAjZGWYci8oyY3zrarYn9ljyoTWaGgtAO3jIZw5fGjhlbYjmXUmfIh7u7s
	 7yANyw2MmZI9dmefvQrMaSREBMfK5eGIW6CSdLCazcjBYVpScnyFjzu3aE2qLYFnCg+Dw
	 BlZoEIXhMrg0YTHiykp1KNod6FgXdoiLJkrSlP5BMunTttqXz7BocRJOs632z0k9jvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028244;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j4smUo5IDgqsAiCCIWgmVRm3+oRc4ucwwSn/kBzjnvE=;
	b=oZ/UucIYAOw4/1RRGB/CzF7JARzHBegnq+FYlnGda0rrLSBgnwVEfvYbG4EawGt8J+aO
	 KXeKivL+azFdxdxa9BjeSB5F7uLglCNbkBYozWjD2Gn5UbFkC0t1xB6J78cEHNccX7egP
	 4oem4qa+RwKFwQPtYCB1T+q5FK7KTco9cXrUlsM9x4qdCrtKtZOEbAkTzPLqyyXbkZHRB
	 E4k1og/N1SpF9IZx5MXE3KR8ibAlFXuG2Jjn482/ubzu+FD+vmqmgZ6qaMFlSDHiMjmqI
	 hQWHe7mi36YGSOBqZF430t8foW6PijTzj9vMIGRxZAnpoUtS8XVUaI4PZ1e34TIewzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fuF753tY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20DB6606A31C;
	Wed, 18 Nov 2026 18:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fuF753tY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79CA51F000C4;
	Wed, 18 Nov 2026 18:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028244;
	bh=j4smUo5IDgqsAiCCIWgmVRm3+oRc4ucwwSn/kBzjnvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fuF753tYq1+90robeoRhJ2kCblCzt5BTZ83GvIgt8PHwVhAaELt5xnTw9FdAUdd/F
	 KYpOjgWYPbytiWODgVn/9D4wahIUyia8RpEZb8lrmXu43nfCAbEi+alq8s0wvZea3j
	 LHBn637UT3a2spyMKXsOqpph5j1YRImD/OOO8gBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2075/2151] blk-mq: dont forget a timer the driver has restarted
Date: Wed, 18 Nov 2026 16:03:30 +0100
Message-ID: <20261118150237.305303621@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

[ Upstream commit 0db9f8968a8941d4fc9fddf220d4983d9b68deaf ]

If ->timeout() returns BLK_EH_RESET_TIMER, blk_add_timer() gives the
request a new deadline that blk_mq_timeout_work() doesn't know about
when it picks the next expiry. A 2s nbd read next to a 60s one expires
once and then not again for a minute. Let the new deadline take part.

Fixes: 320ae51feed5 ("blk-mq: new multi-queue block IO queueing mechanism")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261028164415.1262013-32-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 65af6d5bd7ebc..8d22f0b6cb316 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1740,8 +1740,11 @@ static bool blk_mq_handle_expired(struct request *rq, void *priv)
 {
 	struct blk_expired_data *expired = priv;
 
-	if (blk_mq_req_expired(rq, expired))
+	if (blk_mq_req_expired(rq, expired)) {
 		blk_mq_rq_timed_out(rq);
+		/* If its timer has been started again, count the new deadline */
+		blk_mq_req_expired(rq, expired);
+	}
 	return true;
 }
 
-- 
2.53.0



