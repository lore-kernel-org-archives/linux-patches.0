Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050817;
	b=dijh12kAurV3rsYLfeY4iWLBAcy9Z23IKEf22C4DvqX0hgKMCYxZXgJumaQuo7zIRtjB
	 TWYCmJwwmpPPRvRqpnhG6Triukz/EUoBuqaxeTb25WJ+v1lBwBdnmQH/InkNdTPGIx020
	 NP5bg/F3xkZq5AOvs4yHpZnaZpZKXmLABdN/mWg1RjCbg/JSfAB1mfc3IyOGnPbpeqLge
	 9ILzTPcS43N35m5+pfkz3AtUVm2HLWjyiVoXd0JyxXTiOQ5tBF+BoIZRqwxfj2wSUJ+wL
	 BvcDt+P4X6N279RueM2uYSwNG+wMYTilVfmDXfA8mil6f48Gv181kg+l7rb2rfKc9sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050817;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jxHbENQDWlrFRJ9D1ukl/jrxgtevc79ghJwbSFAw1lE=;
	b=DUThwhaycTs9BrmPRHTtnTL5P70R5UMoAzv1Z2Kvd1rQE3Tqgdb1xi2ShPBaiH4QmlfT
	 BIKHBe5BkYhd2lEK9dwud4OQehMkQ7z+GPIYUbHRBKDuag60lk4KGckVLvKNe9wF9BAOV
	 N0VFFuyldzoQR4xd2QigBbVSg6DDmH/6S0trDzQb9Y9QqcncMHT7Q7gNLFcz9/N/Xvacr
	 iNRH8wIlke4aZzYnV9qdThjuHZyqYFM7GXAx2u/mKo5JZ3hYlSGSDGLf1uPXwchpW+ZUx
	 C0lq0Wl6JZWctq8cdnV6oCGqF+vF1XtjBeCYFs+zRqq1H/+eWPsPrvrbeydOKQxeB6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nwoitMBC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7628606A325;
	Thu, 19 Nov 2026 01:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nwoitMBC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB67B1F000C4;
	Thu, 19 Nov 2026 01:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050817;
	bh=jxHbENQDWlrFRJ9D1ukl/jrxgtevc79ghJwbSFAw1lE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nwoitMBCSc8FIlGQ4z2as5L8y+GQHNPnudE4fzuyRaOBu78rxEeDnIOEVUEMbf2XV
	 6F58nHvPvicHIQ4INlLB0m3AnmKofFmSHbJzbrEKYERstu5wWL8bD4F8ANxUtmzKUY
	 D+jyPRStdwkrR+tYVVIuRK8BocpJzuwA47ioXZp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2803/2857] blk-mq: dont forget a timer the driver has restarted
Date: Wed, 18 Nov 2026 16:03:57 +0100
Message-ID: <20261118150342.517818662@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4229ec5899268..a918e1188f233 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1630,8 +1630,11 @@ static bool blk_mq_handle_expired(struct request *rq, void *priv)
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



