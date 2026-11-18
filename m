Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037744;
	b=yyHWS8+bxg8LP3tcnxi6SSfjjT+ST09dEBPx49ekcjLfvxDKXPxTIJP1w2cfzIjlXd0W
	 7vK8VqiYcr1idHiclRxscoFhMqLIFe5TmzJ2RsZiXcbK0I6Rc/96ucC3DQVI64PiJEgRQ
	 sq/ClF8LaHgOKLEs+nJ87G0prAL7QtQW1ef69kuf75z/gwMYERPRuOcX7y1J315kqDcW/
	 ulBWHtuSikm1MicaTnYpfK4L4FiDFosFq4blp92G5lr2TkUtY5JBnEZmxEjkoCizQydD+
	 /W3dZ0zaABRwdtC7CREEFnnFOQP8WTd40FcvbbI1PnLazlVG0KqseQ9/vVzS3U9LVkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037744;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GPOeGNhTsle7MpYV22eVVOOK5qNUz1sjfzS5eHPtqg0=;
	b=TWZo3ZTqTq9JcuI693YS++J9XCQHx8V7lx7fnzi9bfzN5pD9wqbfXkpjKIRr2vicLv35
	 nU52/IrHkpBNpJI2qFlXSc9n458FwFlsCFLgGTZlVGQ6Elt8coNBehSKMY4mVNBbx8Vcr
	 zBYcDW56Aljv6I8BEQdFzzWnht2buWx0lw9wd0fAEvxUBisNFzURYKNKjmfw45fm/t7pQ
	 ZGmjX2D8rbdEeeBv2huIznsbLhoysK9v+mFU6BYPcFx0PB6WZ2Hm9gVcmIWSVntCvXLyQ
	 FhRBTiuWNd4NZ5FXJZO5At3VIBkYQs9lmG/Fwrj733Hmflx3ADBvME3vHnmnhTBx7gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VZIFknfo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61706606A325;
	Wed, 18 Nov 2026 21:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VZIFknfo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7CD61F000C5;
	Wed, 18 Nov 2026 21:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037744;
	bh=GPOeGNhTsle7MpYV22eVVOOK5qNUz1sjfzS5eHPtqg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VZIFknfoSEDYfcspRMaG/Ai7+xX9V96vlcyQmc0zSc3bw7794xuf8Se863HBziNXj
	 Q3pfIYvoWHKuclZ8j15wPxXh8XpOVl+a6Mp9J1f2tmIkQRRezbEzYDSPD//03ueF15
	 Rcr8AxGMKWAGqeSXAlslDMPEW0g0ByzF8QvCtyII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhe Liu <liuzhe1@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1503/3318] blk-iocost: account flush sequence latency only once
Date: Wed, 18 Nov 2026 15:35:25 +0100
Message-ID: <20261118150406.009534771@linuxfoundation.org>
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

From: Zhe Liu <liuzhe1@kylinos.cn>

[ Upstream commit e9804489e27dd6e33aec5511fe3780ff3009f57f ]

A flush sequence with a DATA phase can complete its original request
twice. Both completions invoke ioc_rqos_done(), causing the request to
contribute two latency samples and adding the same queue wait time
twice. This gives such requests disproportionate weight compared to
ordinary writes, distorting the device-wide latency and queue wait
feedback used to adjust iocost's virtual time rate.

Skip requests marked RQF_FLUSH_SEQ in ioc_rqos_done(). The flag is set
when the request enters the flush machinery and is still set when the
data phase completes; blk_flush_restore_request() clears it before the
final completion, so accounting happens only once, after the whole
sequence finishes. The remaining sample covers the request's lifetime
through any postflush, and its queue wait time is accumulated only
once.

Fixes: 7caa47151ab2e ("blkcg: implement blk-iocost")
Cc: stable@vger.kernel.org
Signed-off-by: Zhe Liu <liuzhe1@kylinos.cn>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://patch.msgid.link/20261102061802.408173-1-liuzhe1@kylinos.cn
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-iocost.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 99efec392dec6..874618b6e1769 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2819,6 +2819,9 @@ static void ioc_rqos_done(struct rq_qos *rqos, struct request *rq)
 	if (!ioc->enabled || !rq->alloc_time_ns || !rq->start_time_ns)
 		return;
 
+	if (unlikely(rq->rq_flags & RQF_FLUSH_SEQ))
+		return;
+
 	switch (req_op(rq)) {
 	case REQ_OP_READ:
 		pidx = QOS_RLAT;
-- 
2.53.0



