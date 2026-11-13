Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585720;
	b=bS8vqUANhcwDAbNz1kSG8hePO0CFrtGHWgzhOf1Li/sAoq/E3dIpFGUz9zAJoQowN8qU
	 e6OlrvSmZOrdr5bZuq8M9fUID6zdl7ESoqZC1uEvfoVIujBCQhi8SSOWhCAoJaIk9P9zm
	 dg3oF3lFf8URUdlRyjawVDiE6mr8XMd7HvtJL+zdXS8piAhZ1UNRcRx3gOW4RWx1eaTAM
	 ED0juUD+DTKvdSm8r3OsXZPfZUWmeGs6gJDA6K8yi8ke363c55TxQDKT7W2K0SXZoKCjI
	 P0M5JAv12LmT9Hobdjx9BqrcqRefIpVHBfiMFyC+1SdBd/3jTv8QOwtddBeK7faTIDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585720;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Qigot3Ky1q3ZoRHdUEpTqgxGay6GoOPNlO7D/QY7jJw=;
	b=kZnhfHoDw5pW7jHvA3Lvo3gDsUgolrCqFobAffUwfvxG//1rOBpc5eGShFAqkgLH3wzc
	 tceUZpc88MI5sVhnnPrUE3OFOiZhp+aHkdQJDku7eY1Lxyw3YcWWs4LnAvIsT9ekgNI5T
	 X68+uQEFoiumr3fDQiA9pEdXlZjPWKjy9mmApDkEOoglR7qO0oTAvbuFU586fiFJggwxO
	 3VelaY1XAkil2VcJl5x9UMWYYvr1NuqRf903XnNue+HwpM5FlMG97GIfCG8zvJ3zC1T6C
	 o5EkC/T6byxtMP/4yLTOoPLgBfhoOBaYDfgwaojx5Htv0PXBxS6Z9M0Ur7Z03USU+zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="T/mUL9KL";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31462606A8A9;
	Fri, 13 Nov 2026 16:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T/mUL9KL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1C8C1F000C4;
	Fri, 13 Nov 2026 16:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585720;
	bh=Qigot3Ky1q3ZoRHdUEpTqgxGay6GoOPNlO7D/QY7jJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T/mUL9KL+pYU9i04W//fH8vUQcXutCK8sFnclDegBB5tOqoCMS69DrRZZbIB6g8M+
	 +5d0/eD8ngTkGNVB9Hm/iKhVQJYfE3BDJyL0Ofl3/Ez35Q5+tDQpBDl8wS3drB/xSF
	 +TqkkrnQSw3LlWBCeJteV2ty281sC60LSm5TwClc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhe Liu <liuzhe1@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 280/507] blk-iocost: account flush sequence latency only once
Date: Fri, 13 Nov 2026 10:49:44 -0500
Message-ID: <20261113153804.626419851@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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
index 7b8af094ab370..23445d7014334 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2851,6 +2851,9 @@ static void ioc_rqos_done(struct rq_qos *rqos, struct request *rq)
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



