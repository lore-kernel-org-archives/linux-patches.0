Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060164;
	b=1g+hHee7Dj5HQqak5c6TI5vG6cZSamUbxbuK1HkcuxV3K6vwZ2lxB9JTksUA2n2d4B0O
	 2VRHcFF0UvqJxx9g9U11+vq3e8fhLWW5S1BmfbjqM9x/PLKAWFXgj+tuJdZQBSlyokm5q
	 AMDX58kszovk2jd7DrEOimi8TPZDq/RpFEg+sxJ4cBGV9XEVfikVW1OX0sYEkmf8cdxvX
	 qfY4ahf/ms84uFB5pN/yoVmhd0PdpJkIg9zujrq/axGSr7z7UpW2EwCLD3QOELb80e+wQ
	 SoPEsIuELMeYyhx+S/hbgu7YKtPerjy/UzoRGb0BWCzLiH21/3Q9Y0JAsVgvCFDFdvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060164;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SAZeN/tNjypHnSQ4qxnk8lT6wBlRFB16WyVc5qUlekw=;
	b=VUj6in2bOs6pHpJZVD9NNrcurlt67f6sO2ljJ3+uMf8eqKj1Hrl1jhJnBejQnA+B2msj
	 Dlz17XCWmCclgK9xMlfaTcMGyDiZS+fmO7+S5Xw9zjisdQqZ1MMalH34LoQt4xyOr1nIW
	 if7mE0UkoPo2P+zfc0bRMle4ej48GWx36fmgFtZRl/MswxEQ84T75KbjSGuKrmwKZqBhM
	 rvTBPqj9n3Z/D5mWM92Oce8+cTP92V46blygiW+eaUTAH+1j1xWCrvmO3lEdBZut+XgKo
	 egQlP2DGy+GjMT0A/I7lqLEON+b/5XfKg9M55cweZHR1hzX3aV3ORfU7JxRsxmCgyIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j7ysi8ef;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DFF0606A320;
	Thu, 19 Nov 2026 03:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j7ysi8ef
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B8E31F000C4;
	Thu, 19 Nov 2026 03:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060164;
	bh=SAZeN/tNjypHnSQ4qxnk8lT6wBlRFB16WyVc5qUlekw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j7ysi8efjWTGtqU9eZoXebHcYI2wPp5mXCYDoVv8n2+utZjWQxOnz05ewMtTjBT4j
	 XgxgBOyYD+pkvvYcZIbOEztgJ2+AOqcDmc+02kSnBbD8+/fnxo20BWYCh//WdZ04sY
	 k6AH0YyrbwBi6h/60e4qfyB+mohybFnk+FXO7OwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhe Liu <liuzhe1@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1100/1848] blk-iocost: account flush sequence latency only once
Date: Wed, 18 Nov 2026 15:52:18 +0100
Message-ID: <20261118150005.123749544@linuxfoundation.org>
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
index f7e6590d66d9b..e5f7f1edc3b6f 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2786,6 +2786,9 @@ static void ioc_rqos_done(struct rq_qos *rqos, struct request *rq)
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



