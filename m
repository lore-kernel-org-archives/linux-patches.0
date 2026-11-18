Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022328;
	b=Lm0DpS0UkrqlX4tU9TpufzurUIDUOvRaFOTNGslUtqsjBujmD9H8Hd5DIh2iP7fd7tjf
	 rRoV0mQ54wfcl4U1xS3Hp6gbCcTFVxB0H64JjMrHVlLDhA47vxoPZUHMBhyGN70uesTt9
	 QaYQu4q9ow4bKUXmN6YnEYwzE4ozAIYtOusMf5x5miGKieqCI1OxBNnMlkIC4kDBgENCJ
	 TuSAAzcHpNGcc+LWEoeopDINkoGtO/fHYXjrmEQ1MqNoli2kNKbCzz4D7ufWKu8QheKF5
	 KbAdLJxp5SHCuHdZpvkimRp9a05nM21FC464qg+mz6+aQ8iXr6SCFJjcwI62OZqhiAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022328;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ka13mOVwkJKRGbwCdPxgCN1ad25AFOumy3MfY8+AmXk=;
	b=W60WxK5PK3Y41g7iMNELj4mteYtee7vTtyGlyvRHYKn0a1486xZFLbDFMngH5Q/qWsZP
	 IsQ6xVXAXfARLzyDFPR1dW3fM/gXSKISAtDMaj0G9dAQRAe6/JlwFQSTViPac9nqQFFFF
	 9s3BnGgcJrkSlzoHrF4c1/Bt3GUKtGDJfPHk4EhkSub+qWt3bis3feD3/D1WDKHLyHUhf
	 Lc+6wUsv3axqp83xxw4DWXXmuNiraLk+7xMGeSN7/WPYDhA6svgGfuhsKiNEsW1nESuQ4
	 0uGnDkxw1wMEuMrW3iPHD5+f1rEf+FeKI6AZU30DxugJk7KBQg1IH9Qcvn4Lb+4MJhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v7UOArAi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD4E606A31C;
	Wed, 18 Nov 2026 17:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v7UOArAi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9DE91F000C4;
	Wed, 18 Nov 2026 17:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022328;
	bh=ka13mOVwkJKRGbwCdPxgCN1ad25AFOumy3MfY8+AmXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v7UOArAijEnbMbXLoxlneFVfUNYDxNaW97g+2b5T4y63GN5DFqlVUnCW2rX65eUb1
	 RvM7qnwDEBzlm5UiepKVcNlb0A21HW6ri8eGy0fjPcMTK7cFN6/+xzU7k1imQtiao1
	 y5b3blWSyf6nn3fiG/rWnfHPFok111gVhzUBB6FM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2583/2651] blk-mq: dont bring back flags of a completed request
Date: Wed, 18 Nov 2026 16:03:43 +0100
Message-ID: <20261118150417.308427364@linuxfoundation.org>
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

[ Upstream commit 9531230ee1fcb8eca2c9cbb9bf02651cbf798842 ]

The timeout handler sets and clears RQF_TIMED_OUT in a request it only
holds a reference to, with a plain read-modify-write, while the
completion clears flags in rq_flags the same way. If the two interleave,
blk_mq_finish_request() runs twice with the flags back: the zone write
plug reference is dropped twice and the scheduler's ->finish_request()
is called again.

Change RQF_TIMED_OUT with cmpxchg, so the handler never writes back a
flag that changed under it.

Fixes: e5c0ca13659e ("blk-mq: release scheduler resource when request completes")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20261028164415.1262013-31-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c      |  2 +-
 block/blk-timeout.c |  3 ++-
 block/blk.h         | 14 ++++++++++++++
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 9f0e3af0f3366..3440e6906f5a4 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1639,7 +1639,7 @@ EXPORT_SYMBOL_GPL(blk_mq_queue_inflight);
 
 static void blk_mq_rq_timed_out(struct request *req)
 {
-	req->rq_flags |= RQF_TIMED_OUT;
+	blk_rq_change_timed_out(req, true);
 	if (req->q->mq_ops->timeout) {
 		enum blk_eh_timer_return ret;
 
diff --git a/block/blk-timeout.c b/block/blk-timeout.c
index 1b8de0417fc1a..0590720e38c7f 100644
--- a/block/blk-timeout.c
+++ b/block/blk-timeout.c
@@ -137,7 +137,8 @@ void blk_add_timer(struct request *req)
 	if (!req->timeout)
 		req->timeout = q->rq_timeout;
 
-	req->rq_flags &= ~RQF_TIMED_OUT;
+	if (req->rq_flags & RQF_TIMED_OUT)
+		blk_rq_change_timed_out(req, false);
 
 	expiry = jiffies + req->timeout;
 	WRITE_ONCE(req->deadline, expiry);
diff --git a/block/blk.h b/block/blk.h
index 50abfd9328861..694d3f94ced5b 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -332,6 +332,20 @@ static inline void bio_integrity_free(struct bio *bio)
 unsigned long blk_rq_timeout(unsigned long timeout);
 void blk_add_timer(struct request *req);
 
+/*
+ * The timeout handler changes RQF_TIMED_OUT in a request which it does not
+ * own: whoever completes it changes rq_flags at the same time, with plain
+ * loads and stores. Never write back a flag that has changed under us.
+ */
+static inline void blk_rq_change_timed_out(struct request *rq, bool set)
+{
+	req_flags_t old = READ_ONCE(rq->rq_flags), new;
+
+	do {
+		new = set ? old | RQF_TIMED_OUT : old & ~RQF_TIMED_OUT;
+	} while (!try_cmpxchg(&rq->rq_flags, &old, new));
+}
+
 enum bio_merge_status {
 	BIO_MERGE_OK,
 	BIO_MERGE_NONE,
-- 
2.53.0



