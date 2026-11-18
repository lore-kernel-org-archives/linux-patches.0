Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022120;
	b=3odqTPsmjbeyCfLXtC79UbLC7G7f4qBXsDIzqYTg6EJm23FE10hABdXiIBrXJk0o/n74
	 XeyyMT7E3JutrQjNFMcNd1RKp7W58oTS7ocfh3+Y7fDN7STsnkEjE45VR+Hmt9Sr7X5iJ
	 3egBprOJOVqPFo/bv3ivcJ2nhMnNsVXmNIR0ONw++SoO9n6r8+a6ayORGIryhHm26tCP0
	 GivMaGF5J61zFN6blSZuoamTgxKBkSenS5zz8vjuHHSGHMEdhMdIKNwH2ZzFEqX/+bwrV
	 GZU33mysAU4RRI0ZL4VkemSKuNwjjUXVw1e2f8iwMZukibfOty3/l23w8ph6UJKNhcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022120;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ouiRwAEzifrn2c9ifH87RqKkjXM30yhKh/dRm7LrF1w=;
	b=SK3uPTucIu0xc9VPTYwtl0KgqQdmuPq/qwpO4Z+UmPF9E+40aYNgaPXN59lIdftV7fdu
	 b0g2fTArlXDoGUnp4zxOs2BJSld1tXPlWsG+qVy0qUXxQkLGw8j1oZyVpvUa1u48SL0+l
	 s/g6s0BSRNIvOJSUKajSihe6ZLcwzGa+SKwee395YxuEPABjuX7OWoNLI7iZNHpVrkxja
	 GfGX9dqKaFmgbTgh5ekG2qudXgbXevU3+meHqHDzcpmOrlzB/VA9IJr9KG/QBWdBwz4td
	 BKDsaOFCTdWX3bCHjAc7ArR2Qg6oygWYxY5dbdKclrt8Qr+nD9+nVjWyxs1sdA049FA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CLVZFBzj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5D5606A320;
	Wed, 18 Nov 2026 17:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CLVZFBzj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29ADC1F000C4;
	Wed, 18 Nov 2026 17:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022120;
	bh=ouiRwAEzifrn2c9ifH87RqKkjXM30yhKh/dRm7LrF1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CLVZFBzjVHualy25ewdvstnPo67+axj4/1pgph98vNSsyVH3641r+lptXcXAwQLqy
	 T8Ef1dFhO11+ZIqWw0D9Tn9L6Is8hhZxxyXnwyehQ1MiFSAYRYnrBS+gt2sfNsYLXo
	 KTFjnauHczhQHCf0knpq9uL7LS/6hufzZ1JeRtfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2550/2651] blk-iolatency: flush enable_work after going offline
Date: Wed, 18 Nov 2026 16:03:10 +0100
Message-ID: <20261118150416.307344310@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

[ Upstream commit 020f61242d6ebeba5f8f2ef6e429aeffdd63f1c1 ]

blkcg_iolatency_exit() flushes enable_work before it deactivates the
policy, but iolatency_pd_offline() schedules it again for the last group
with a target, so the blk_iolatency is freed with the work queued. Flush
it after the deactivation.

Fixes: 8a177a36da6c ("blk-iolatency: Fix inflight count imbalances and IO hangs on offline")
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://patch.msgid.link/20261028164415.1262013-24-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-iolatency.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index 2caa79a008ad1..c15b1aba606c1 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -637,8 +637,9 @@ static void blkcg_iolatency_exit(struct rq_qos *rqos)
 	struct blk_iolatency *blkiolat = BLKIOLATENCY(rqos);
 
 	timer_shutdown_sync(&blkiolat->timer);
-	flush_work(&blkiolat->enable_work);
 	blkcg_deactivate_policy(rqos->disk, &blkcg_policy_iolatency);
+	/* iolatency_pd_offline() schedules it for the last group with a target */
+	flush_work(&blkiolat->enable_work);
 	kfree(blkiolat);
 }
 
-- 
2.53.0



