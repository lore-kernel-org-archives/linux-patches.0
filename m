Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042677;
	b=yuLz8alldKdxec9gqEwsbq8lEzyozueR1/zCM2cya+8xhIA7D9LhFpL0XW6HU2Xx4I2C
	 rqBGfRWKJX2ZAS+oAztcs8n8KFs7quf4lZ7/5wWNmBLhacKJhV4TmeJPUmo75E4GghcSn
	 NDowYT1UffUhOrhYI0SuKJ+VXGCfgJSpHKnLmcbD1hHdbCV7vkD+Y7n0Man/C/BIeUL8R
	 GYfhXX3Jmlm8Pei8TmDv5W+fqgpSCJZQrpOCodMxCWHr3HJYm0CJgrVbYz4j99qdMZ7ax
	 dX6bV9Ih8Qoz89ipIG1DzZFzRUlLN5c0LYnnVmSdkWcvgks1f2tocJPqLfycgsuZN5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042677;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cG9yfd9i8qLen0h3nmx1d/ddR1qnJF5vWNcpT+H0qXI=;
	b=rTr4FbfnJVet8hqO1U0QMt82FClchQbQMG1rLwLmZOfHGqiPQm5qh/qmmcEVZRHBQgrY
	 ExBLutU6rk+Lj1yHqrVlCZG8vxj8LAWHBiPatsn5/lPL5d3WM5K6/1aW3VgKpefRdnbpc
	 jZ3AzPbK4IcXeuZWfgRLrNahfsUdubcN0AUIYLXVvqIkeg6bhQkeTyQTUAv2ychXLzUkt
	 mrr8czfpvh9eccbb6N5djBUF5lGGQQlHMroF0o076i2fzsPt24BFolR4hEDO5KnFyh3/E
	 qU6Xr4BP5EuCkeRYmaJIT54JUAQf4P8eeXND3H+K0YyJ0qrV8rHoRkVxmfHnaBAMFlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lPzwhY2t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7A9606A320;
	Wed, 18 Nov 2026 22:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lPzwhY2t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8837B1F000C4;
	Wed, 18 Nov 2026 22:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042677;
	bh=cG9yfd9i8qLen0h3nmx1d/ddR1qnJF5vWNcpT+H0qXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lPzwhY2tPofkd015DCEMGjCGcIW+0zYh1PZlIQKF5vJ/Z0pDgC3effJXZg2Epn4ui
	 ylfDiUnk4/5zDvECIWHgVfdlkqi1dWnFidVdgJLkTAaYz7Eufvf4V3Lbw4sFPwQFN7
	 HDp6NGaoeyqsLN37NMpXZ4iePnqYbd/a57M4qclw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3257/3318] blk-mq: dont forget a timer the driver has restarted
Date: Wed, 18 Nov 2026 16:04:39 +0100
Message-ID: <20261118150457.338850397@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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
index 9371f95babee9..bd79138a10158 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1629,8 +1629,11 @@ static bool blk_mq_handle_expired(struct request *rq, void *priv)
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



