Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590383;
	b=DFwm8ZAkJwRuoW9xIR4YQaj1/q8OwT4rARYlPUhIQSFf0GVXWBGbmSNkbyMTFoJOESo1
	 ZHRaZn2nSRdwKglabP8e2ZuzDWwAvE1kTOBeZBpzuPTVV67NW20594Jv0CTc4OMJXvRsy
	 L94IEvPkM2p4LaOm2hoc5bBniTiHX/GKkaGqWZm/LdPYYxBEkhlarIXNwjz3yFbmhUiXw
	 N+ZidVkRgIJwsX31xUkb9sEPoMhK6t1Wx0yKEC3dpAn2RIA4ne8gxIRjiwpMaS3wn0S5e
	 /j1OkINn8m0PrCVGKYLLYMdUJN3GgJwZHUZoab0X3iXucpeNtXQKg2bAX3+ksdrk/ZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590383;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zve0AzWwsy0HP0hriUTbO61n/KyD+wGajAoYakU3SXo=;
	b=OS+JXtO+hs4fTX4RmqleiOC+X4hECcL+c6bCgq1dx/H6URCZGaX6PBTzxDYfvMqnx9eB
	 /OFTP/53gm7Bi7+qM5cPyvtdhpl7v+YZ/iNvnS2tLF5HywlFrbdlcSH2fcfWmgILhOQFc
	 QPEHGy1ikhWmQkb/CFM6dcVnySorgbgblghp02kXF5/X5Zlb++Tegs1+xRl7Jk6ZGXW8T
	 GW9SD4KJnAwKn+Hgt50Ixaq+Lkx1rH0Mfi+JPQO9qV5Hj62hutZRjaiUBDBEcYr8r+ixi
	 eD0zMl1+y+hkQVKDktD6mGs31Cg+Y1kegyJzMmamb2a7P/2VhhsfdNyvYnq5FKP0gkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Lt5ebCQ/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38113606E677;
	Fri, 13 Nov 2026 17:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lt5ebCQ/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D91F51F000C6;
	Fri, 13 Nov 2026 17:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590383;
	bh=zve0AzWwsy0HP0hriUTbO61n/KyD+wGajAoYakU3SXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lt5ebCQ/di5atzq9Y/53l7nJddcuQQDSnFgtxCVJwjKLnyHl07D0XfZCKDl+deGuH
	 ozwSEQQgbYvEn7fymZeUt+FOztHLtGrncQpztoWOeAysU/eWzzgQ7NfOsaAhkq4ZhH
	 1PijyXpx28o3XQreVxmIcsG4cNGrhg4Y5qXuA+b0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhe Liu <liuzhe1@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 353/686] blk-iocost: account flush sequence latency only once
Date: Fri, 13 Nov 2026 10:48:06 -0500
Message-ID: <20261113153832.878835058@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 5c7cdb493768c..8c0214d48e3e6 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2818,6 +2818,9 @@ static void ioc_rqos_done(struct rq_qos *rqos, struct request *rq)
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



