Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042674;
	b=hwET+k7S4q4o4taxLXqEG9x/7VHp3ObY+pa3+BgaP5Vf7PCNLMeBOhiyLp7zUbBBrsD/
	 i8yk0wVeIeFjGHSm6HuWywXHdU5wRNco/3pHGZg84dQkNETDvRACgqlPcfYgnVRD+f6e6
	 FE9miiM++L6FVmJ58GdA6DEf3smt68TvyhpnsycYZppn27Nx9eFldLh/BRCPZzswGLjMI
	 5g7U9cvDz0N4cpHddrL2YKnlH2iifinTqh3dSxjkf7+OjzVbqlpmtLABUkbLicZusrsjM
	 Zi07I3D7EWpwWn4kxAbqbf954jq+SnWZwbSBCi3PMLosfb9jKSlx1EXn/HiODzuxcmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042674;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=agSSSVrnLMsuj6FNp+nPROXEZvTrmMEoXaV2/dlmCX0=;
	b=FGpX1GgzOr9BPHeOJ+2EvH1awotZHJeRcnPeLwIgi2mRc65hvaZTrEkZ9v7ropwFVQaf
	 1N3nw8bSn6FugxCE2MK8kQb4sXZq4nl2Sm5NGLRavK/KlUKKEdx1ED7i/55+lIqWzS/yw
	 g0XJXH05heSM7ebCEUGfDmHV8pqX4xUZLlz3j8FDg+TQ87v/l+Gv+2qwGvKFMJLvUlfNY
	 CxEoyUxJSLyDdQwy4txYo8mLlg0o8Jsg4ghHv1b0ORV5qmzPlVTHlWYBMY80SGFlfhTII
	 w2w/Qy+ViIneIheOOR6QolLFmcMaGTwXikx+8+pC3aI35jivjWIFtmCsCFCIS/Pr0NQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h5SZMwIc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D90606A31C;
	Wed, 18 Nov 2026 22:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h5SZMwIc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6D761F000C4;
	Wed, 18 Nov 2026 22:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042674;
	bh=agSSSVrnLMsuj6FNp+nPROXEZvTrmMEoXaV2/dlmCX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h5SZMwIc8Asa50hRgsTluuqFixKeomBv3rCtR9jL/TWYf/+UCmVqJ+nO2+5ecDifK
	 7Wd7ox4FMuyD7K5eqCyRIKSL396atZVGGvSvUQpObTtgGCsm2LxodyH1rCPuDJaNql
	 qwdsBrbKiDDB7++4e8E/Rkhpil8BgNt+Aw2klko8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3256/3318] blk-mq: dont bring back flags of a completed request
Date: Wed, 18 Nov 2026 16:04:38 +0100
Message-ID: <20261118150457.311483175@linuxfoundation.org>
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
index 58cbf858fe134..9371f95babee9 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1558,7 +1558,7 @@ EXPORT_SYMBOL_GPL(blk_mq_queue_inflight);
 
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
index 5590a4996c3b0..dfaa5aef2edff 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -276,6 +276,20 @@ static inline void bio_integrity_free(struct bio *bio)
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



