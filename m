Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033091;
	b=GMw6r2ZH3gkso3b4zHCaHR4CeT2daEnflq+Qi5wkgvh6ulEWKzM7wCUFxphK8zknRa2R
	 c9/u1DHJQVV2hn4bEF69MzA1ofGcNG/PIGATDUVqozjJjCLmY4YnO2A1yaGzFaVyyi1Yy
	 NIo/C1tzUfIYrP/Qf31IIFfHkWH5TcLQBf2OYwqrg1KTSnq+RrwlO0EvKyusirtu4CNUt
	 8jFU6yHCVcisgQUlLV61ZrBn0RspdVo5eOnqJXLjOv0qIIAcVu+ENAPKiFpRdIxkwDRaI
	 imbaDLMBE0BiCyqPLfGMxWQjmxBiMC4bXiIP8VqCeksYA8w16o2Y4pe2ZKcBE1GREug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033091;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HCPKvqkX76dZM/H/B/cYyaXEIUJikzdo+IJqkolKFio=;
	b=t3+t5BWxwVgcdn2p6ywHFc6WyvvbPs+IfmGw6Vh2Nhx6Iee3U3FvkjRRTSjBJHMcc9JW
	 um6MgK8m6p8QjvaSyz1Dl8kBcdKevoEbwL2tzfoUQ1H4piPMRVvWSc3+N/h0u+LLzIpDb
	 RhdlEcNPeONZTvUCyknd1MdiwNE29G/5pPMoov6aNFiQz7GvLrx3STKHXCpLahCR8DR18
	 b7dXC8TqGiLbapAW88RBtijv/zBWZZvl536cNFEr6R2+6fUA/H6CyuirT0VQt/kubvWqR
	 r7LHv4kUseJ1CbJJ2GVjyXUtdyuaFa2jj05djaJJDIvWRdtTsPgF7qAyCyzHs7Nz3Ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SffCiw5d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59304606A325;
	Wed, 18 Nov 2026 20:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SffCiw5d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF1111F000C4;
	Wed, 18 Nov 2026 20:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033091;
	bh=HCPKvqkX76dZM/H/B/cYyaXEIUJikzdo+IJqkolKFio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SffCiw5dUGxNjMER07FIq2plPKyjuF3xBLHHAYQNXMN2+i8gaZGoURtnVkPhlYRSc
	 RjL8axbPh4fdgjAohO6YgjPFeCHix9rQJRFw/L2gpLKSbl0V4A1uff8RaWPOqrZ/3B
	 LRBrmVCD3NAlGZc9PIzbeQY+lqxTxc07pdbsJQjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1642/1756] blk-iolatency: flush enable_work after going offline
Date: Wed, 18 Nov 2026 16:02:49 +0100
Message-ID: <20261118150115.133259438@linuxfoundation.org>
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
index 6be1c5e020ac9..a82ee8c408c2f 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -645,8 +645,9 @@ static void blkcg_iolatency_exit(struct rq_qos *rqos)
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



