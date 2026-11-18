Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042666;
	b=pBZ3L4NMEQwIqZjiWRxolXIKuNDCyruQuf/G2k7y8Khqgcz5jHEXZslRHRtihDTU5THL
	 DnV+uzVIR2T8DSJJqiDqb5F8lT09ybNhXUsbTZIloyvNoicr50yD0Cz7yQ7RiPi8L+np0
	 ZvmHfCC1r12GzMoq57GULBD+A74bOPGFeBI6tco8XHowD+1mhfeX/s+AhmtLhQ0CVbEAO
	 +oix8O3jS+YbR7XxJPeqVTBfIw4xhajtWJtqCIJS/L2Q7L9XxEWVQz0imbhdwktBbLcif
	 3uwgxtXotvdfoONmDs2cxTyf6PbiT4jb35zI6YDBxVGRTPC00FSAuAnr1uZ9msvVZHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042666;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7R9hTmPR/jBw4IgYaONe4gLlXUalBcHpHM9XcXLwbQY=;
	b=PiCZlALr4Y7Yh8xBW8qNiocyuV0mi3YCxuyb84urfr8yBBpnWDlAk+Sk7ig+hONG8U84
	 md7LbNl2xbxxx1HPU6S2iY/Uzu2SdjRoByLBoUdC9ivNCYyedGJK1/ldBeWyvUO7G/0R2
	 UFVCNhmAksMrRaSrxt1kJEHX74+U8riwPdlbL0EYV4oR92huWWRAvr9KDgVbGitV6wNi1
	 DL8Whxj9/CUC90dVo/0Zz9ELEsdarMknEvW89Tsy3jEKRosmyFlTPX4GjN9RFGbowvLgb
	 VNyi1wItk42/PYtBP6GT5k8LkVPsRMfhJYVZfP52cWnyld2VnjxP/it8pWGrqClZLZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FYQaIJ9i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F2E606A320;
	Wed, 18 Nov 2026 22:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FYQaIJ9i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 686FD1F000C4;
	Wed, 18 Nov 2026 22:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042665;
	bh=7R9hTmPR/jBw4IgYaONe4gLlXUalBcHpHM9XcXLwbQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FYQaIJ9icrEylMgMhPeC6qH3vaV9ru9cCI8YOjcI1CfM95DIEI5eroYb4Hw5s5aBb
	 pDSvhbznQet2TzzVrZxIHjKGRVnspOxwGoA3Kbmu6YoREwQhOK+dfj6H8Ck2QEV7D1
	 CSAZeQfbQqIX6AQvkZJaM8iwbnxX6Kl3pxU21wCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3253/3318] block: dont lose the status of a failed flush request
Date: Wed, 18 Nov 2026 16:04:35 +0100
Message-ID: <20261118150457.229376468@linuxfoundation.org>
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

[ Upstream commit 67c43ceaa29e9b904216651697adf20445b219fc ]

flush_end_io() stores the status in fq->rq_status for whoever drops the
last reference to finish the flush sequence. blk_mq_put_rq_ref() calls
it with BLK_STS_OK from tag iterators and the timeout handler and
overwrites an error the real completion stored. With two extra
references, reading /sys/block/<disk>/inflight is enough for that, a
failed flush completes everything waiting on it with success and fsync()
lies to the application.

Only store a status that is an error.

Fixes: 2e315dc07df0 ("blk-mq: grab rq->refcount before calling ->fn in blk_mq_tagset_busy_iter")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20261028164415.1262013-6-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-flush.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index 313f0ffcce42e..8cb7544c49931 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -226,7 +226,13 @@ static enum rq_end_io_ret flush_end_io(struct request *flush_rq,
 	spin_lock_irqsave(&fq->mq_flush_lock, flags);
 
 	if (!req_ref_put_and_test(flush_rq)) {
-		fq->rq_status = error;
+		/*
+		 * Remember the status of the flush for whoever drops the last
+		 * reference. blk_mq_put_rq_ref() gets here with BLK_STS_OK and
+		 * must not wipe it out.
+		 */
+		if (error != BLK_STS_OK)
+			fq->rq_status = error;
 		spin_unlock_irqrestore(&fq->mq_flush_lock, flags);
 		return RQ_END_IO_NONE;
 	}
-- 
2.53.0



