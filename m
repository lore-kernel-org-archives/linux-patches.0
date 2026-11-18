Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033172;
	b=vtQSQf2Xegwts231GofIoloDYl1Y9m9R4sdgT0IwAIQT3XDNr+bogQSyuQ4DXC8DyLwk
	 hVbvANWc+Vm1Ewy0Q+GD07wRVawvUMuzPAfI2GTNbHXX36rOME6vu8Pz6eIWA2/Lg0GQa
	 4WIGlq+IYMppD8VC9iRvLkfRJqzYLvo1eIsaKOz9H6Sc1vmCGr7RfS/4Isf8zFYZyJ2Hv
	 xCIdL1ovoki5ZSilblQW9jfwA88qzqGQ3/22bWrkPjZyfKp5efgh5X4ATjoqvcFCKvyO2
	 weKjV19esqQ1+KlerghWJ5+wAHFmX6FZ0S5LHcQd6lLanLixSfl/kvm3fGgYclqk53g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033172;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z9tvhmqmJCK0CB6cmGi6wT2nmH/W4ZZK4kH0imjvukc=;
	b=cQ55QlV5me3wzPdP7ssmtFETEW2VedalaIB9ni+JVu7vxVh2BLTmo1OEui1hsieXSDEC
	 JE3NWlnOJE3Grq6POJ+IW2TaogOXM/b/FVj/WiaV26IO5p+Ged66Y5ImibXxfCz1noEmF
	 B4fXaaiPW1e9oKJCpw6a4lDTtfpFHXFTl/5jhV57UA9mRNIEJe9Gp9VlV6Umc3hgwmu69
	 hLhwsN+j0g5MhuDaa7NPWH/0JKH1t/4m9i2sSHoDkez7T++xA6RSHR0+VlAgdCR/cJu1X
	 BJSKT+cp3+Ugg3KOlUwCK5OfXXzTFEET03g7v/So580Lvi0kaOjMJ++zX3hfcJ+WkxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xIKkcFz6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2524D606A336;
	Wed, 18 Nov 2026 20:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xIKkcFz6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 769AC1F000C4;
	Wed, 18 Nov 2026 20:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033172;
	bh=Z9tvhmqmJCK0CB6cmGi6wT2nmH/W4ZZK4kH0imjvukc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xIKkcFz6UhD1+dT1teD/+yXYO1jKsiioRA7InkCYhimCgJg+4gUxYUArW4VWauXxy
	 wMon4RE5hVJSeoxuHMmtAHFFpshWolTxZ+aLqwXqttzgA2wtKOss7eGPvdhjcYOc04
	 5ToceL3CIKT8NmeSDAY1yOJDantPg4FPaC3angnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1673/1756] blk-mq: dont forget a timer the driver has restarted
Date: Wed, 18 Nov 2026 16:03:20 +0100
Message-ID: <20261118150116.285810581@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c3c5a5c0772fd..7c5415ca2450d 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1689,8 +1689,11 @@ static bool blk_mq_handle_expired(struct request *rq, void *priv)
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



