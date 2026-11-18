Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061805;
	b=j2RNcOZn/Vcy1I94e+q6AF8jQnzZ1HwHbymuVxv0XPgpoxh0VgMT0cPM8Xqm4LKUeqmQ
	 0wA2WwEzQbfdMqTBmBmMelkPdVeu+LwzFzn0v5PuVMcbXN645ijOzpwh2zsJ+a0PKh9FX
	 wBK1DrzbcQBqDxZds4nY3CRdBNpjvP08vqqCrNqdn/GROnSJRkSFJrkGw8EF4I1bHiMGx
	 5cEkt/lCV3E39oZ4stheOWyx0L/IosLOFF38jcxFhsRHetxiFO0tucR75Sd/F1sdRBF4X
	 H5Ak4pmjsCFpo8mixAFkTOvYRNll0RDfYgzRHlT64LgXOfysOY70LeEURd49wc8Uc8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061805;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=77hg61ZIHWoV7SmGamBZNLp6UzOMqhNU+/Hwv9oZm7M=;
	b=l1JzVLrm3AOfSqcRitAa9G47xJFw3kEjxPafW8p2tY025X95/Wpoi7FMK7C8Uz/6Rh0V
	 /FaKTcUlcIy3+fmUdBQ957PIVqy6E0+FNw+IRErgIP3/MVRlqQzFDq2ISE3yxUh4eKvxZ
	 BToB9trx2N3+sJJj+XAIFbJaMlLTEg4MQTm4AAyiQAtkUTyRM0Khp0qGcat59r7op4wl8
	 1b1XVtVntnpj6vJUIrnLNFPXThAA4MDx8o/hhoJTSVOIGULMpCLdpro+ah80rBYuOeLb/
	 Yx72rfUErET77FFUhmIEsmWg1nq9keFAQ0EFOfzHsfAa/N7aS47W1P1+PwJI9MivlxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aulOFXnn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 599FF606A320;
	Thu, 19 Nov 2026 04:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aulOFXnn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD221F000C4;
	Thu, 19 Nov 2026 04:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061805;
	bh=77hg61ZIHWoV7SmGamBZNLp6UzOMqhNU+/Hwv9oZm7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aulOFXnnKix22CJul1IDeE82pxneVJpqIqGcd5XGjLCBvd9y/tkDi4B3CwaW2uytZ
	 UL2FIxfdnMspXVnjcZgcIZNjXyO7bmaEeAieQcOhBjej5yEeLiYU3sK9u0aCdTPSJG
	 DZlqd/6y2WNaUkwrW14cIEMfpebtFvzXj/X+J3H0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Cui <cuitao@kylinos.cn>,
	Christoph Hellwig <hch@lst.de>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1682/1848] blk-iocost: account zone append completions in latency stats
Date: Wed, 18 Nov 2026 16:02:00 +0100
Message-ID: <20261118150030.191861012@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tao Cui <cuitao@kylinos.cn>

[ Upstream commit c38975c427cc3d3f6eb66a36143893be5cdf4ebd ]

ioc_rqos_done() only accounts READ and WRITE completions, so zone
append completions are excluded from the latency window: the vrate
feedback loop cannot see ZA-induced latency, leaving it unable to
respond to device saturation caused by zone appends.  Similarly,
calc_size_vtime_cost_builtin() does not classify zone append as a
write operation.

Charging (the cost model) and feedback (the latency window) are
separate mechanisms, so this is not covered by the previous patch
that prices zone appends.

Treat zone append as WRITE for both latency accounting and cost
classification.

Fixes: 0512a75b98f8 ("block: Introduce REQ_OP_ZONE_APPEND")
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://patch.msgid.link/20260922043856.2020116-4-cui.tao@linux.dev
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-iocost.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 57cf12ed2e15d..ca4013e359b2c 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2559,6 +2559,7 @@ static void calc_size_vtime_cost_builtin(struct request *rq, struct ioc *ioc,
 	case REQ_OP_READ:
 		*costp = pages * ioc->params.lcoefs[LCOEF_RPAGE];
 		break;
+	case REQ_OP_ZONE_APPEND:
 	case REQ_OP_WRITE:
 		*costp = pages * ioc->params.lcoefs[LCOEF_WPAGE];
 		break;
@@ -2795,6 +2796,7 @@ static void ioc_rqos_done(struct rq_qos *rqos, struct request *rq)
 		pidx = QOS_RLAT;
 		rw = READ;
 		break;
+	case REQ_OP_ZONE_APPEND:
 	case REQ_OP_WRITE:
 		pidx = QOS_WLAT;
 		rw = WRITE;
-- 
2.53.0



