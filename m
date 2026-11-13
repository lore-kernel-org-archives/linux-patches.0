Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591167;
	b=whXHbqShA6TqvY3tmcv8gfY4laXpSNduBrDB7rzBOIMFRuB9qVKijKaaltQbCCnqqHIl
	 rtN4SdOJLpn7Pw9vXlDjj1iuK5TadqNc94nZRbGE9PpDaxUgIbp+kfL0QXL/xyKzd2yzo
	 Y7qs3bNdYbOZjF4zd+txO7zyg9j5bmLxJ1is/1EJaJGei4XE++SDVwxooEmGT2iCWKsWd
	 4Mrd9eETTIcpWUFi4vpzdqct5zLkODUKO5B2Nl8jd4ntWGCdb9cXgyxPMCVBWRcHOQLi+
	 cvR5GWKSik1CpUeFF22ywcm4QABUUvSrr4EO/nfpNe7Y6A+0TeK80NuzA8nXB0+0sLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591167;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vY/bVXOwr+JlYZLGeueUvI23USyIzsBKvVa9nCmtNpA=;
	b=TJW/tQPqLClP/JRj9oxXhNPIEPKOwTzO1wZhV4HXGvh7aJ+TPwbs3YHb11mQsprhwzpX
	 WSU2FAyty4JKMuLCEYB9SnXVXl1oXgWkH4fwBxyssO6ZGIBHNFDX1SGotlam27PPak3AJ
	 hwrqmFpTWRlfZDrHlXthSiPJrCSHucuFDnCugT3nsy4+eRHSKK/6CAIzhc0N2bmjoz9CO
	 /pVfK4lxQOPQKk9cfNh9RDI+1BDXiei3arc3y0NKejYvfsZYWSmikIgXxS+NBUpg1Q43f
	 CNbud/zzgH4rkcUmzQqfgw51ssk2ZvqgVIYUMyNQ+MlK5CVm3dY6MZ+lWeG1BfVRCmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fkeI1qLL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF00606C0AE;
	Fri, 13 Nov 2026 17:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fkeI1qLL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D20401F000C6;
	Fri, 13 Nov 2026 17:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591167;
	bh=vY/bVXOwr+JlYZLGeueUvI23USyIzsBKvVa9nCmtNpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fkeI1qLLc2KV30Qy/WbHUbh3CBLLajdCZ+/LzUp+Sum5XisJ9HC5LvNj0e9pe/MMA
	 mOlSDg0mSMhXKbWtMiEAKSKvUSHTuB/ovcyyd8bqroMQoOZJ1uceDzYDhgL8D4Q77N
	 3GTI1hsIQC57GBPsVUe5R49femlTZLMrk0XETMNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhe Liu <liuzhe1@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 309/670] blk-iocost: account flush sequence latency only once
Date: Fri, 13 Nov 2026 10:47:53 -0500
Message-ID: <20261113153822.380009365@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
index 4707b93493055..b33df932ea1b8 100644
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



