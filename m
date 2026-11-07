Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062165;
	b=aL2XIYodv8CYrRY8sB0SyxBdQQVjrVrTtL/NtEhQMLWKu6fctECVl5VLr7xPy8HE3zGE
	 dFbMtSdJ16UgP5uhDlFhcIhOLlcUGvWJL8UWPUrBrkeKUvOi/Dq4YZdBeegr5Oj6SOigh
	 jthaTQ/EpJhknAaQBvex0NrSnfVMOidhH8Elgs2ctXshbfCTMaf7cjQnnirUIBdoFOX1b
	 BSGrHANSzTYg5o8gW3KoO6HAbEOh14W6IiEr12epqp5dperYKPvKAOCTYPm8KvokRLvhJ
	 EuAxqu/pk0fa00vZ1j1OFPWE1Dxc+rajz0kiKyXKSbqh0g2IewPWO7H7kLAYSnFpvIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062165;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uhs4zfFCIpbPfBiBe5o2knngyhwuIUoqYTm9UNp4Ilw=;
	b=40Ouiui8yJBlWrO/536dsQz6UB+xR8xBOMnfvidPhuaFfD6mmMngYjQzXGr7Q1psXrMh
	 9anC9H3911nLF2qMt86GORSbC57M2YQ4ip9ptYcU+nlGuY3HGb7g0K7NJTSDHTazFIXOR
	 KGXtf0L2vzgTiwaxzRux5Ca68wZoJ13SuCTBeZj8abqIzf5t2DEq+1RUQ9eD+4CA99Owv
	 /bx9kA5PWrTI+I/YeB1WkHXRCNGTdRl7r8+sD0N3mvITwUlNfXfWwcalSiBmvzvvtC3t9
	 iKyDACoCmJVyydyp0TL8Zw5yH5owZhy8FCT7XGiLoY4Oh24OiNDan9INVFp41AnLWng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sCN1a9kA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F90606A326;
	Sat,  7 Nov 2026 14:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sCN1a9kA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EC501F0089F;
	Sat,  7 Nov 2026 14:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062165;
	bh=uhs4zfFCIpbPfBiBe5o2knngyhwuIUoqYTm9UNp4Ilw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sCN1a9kA2ZTXizFcyeEA3Haw88Dto8oyl2CuWKwxSPH0UH8uxGxoKJkiBTG4NIvgm
	 VJfhpRVf8YaBlgF/+/mootlRV9F/Gu/d0S2Jiwn8HdGJWuDCOqxfJ6+QBAlply2zNG
	 Z9uVKZm7ZfjzJ3wJr4FHhRhS15oZxLCjbofnYlos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasileios Almpanis <vasileios.almpanis@virtuozzo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1128/1536] block: drop the cached plug time when blk_add_rq_to_plug() flushes
Date: Sat,  7 Nov 2026 08:52:24 -0500
Message-ID: <20261107135029.394013104@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Vasileios Almpanis <vasileios.almpanis@virtuozzo.com>

[ Upstream commit e0f2224433b15a57125d6ac5d46182f99c6c9d08 ]

blk_time_get_ns() caches the current time in the task's plug. The idea
is that the cache lives for one plug and is dropped when the plug is
flushed. __blk_flush_plug() and finish_task_switch() do that.

blk_add_rq_to_plug() also flushes, when the plug has too many requests
or the last request is at least BLK_PLUG_FLUSH_SIZE. But it calls
blk_mq_flush_plug_list() directly and never drops the cached time. So
a task that keeps submitting without sleeping stamps every request
after that with the time first cached in the plug. start_time_ns and
io_start_time_ns are stale and the disk stats charge each request for
the whole time since the plug began.

Drop the cached time after the flush, same as __blk_flush_plug() does.

Fixes: da4c8c3d0975 ("block: cache current nsec time in struct blk_plug")
Cc: stable@vger.kernel.org
Signed-off-by: Vasileios Almpanis <vasileios.almpanis@virtuozzo.com>
Link: https://patch.msgid.link/20260930-blk-plug-ts-flush-v1-1-bf8ca7bc5cd6@virtuozzo.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 6af42682af7d6..930c800f5c62c 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1375,6 +1375,7 @@ static void blk_add_rq_to_plug(struct blk_plug *plug, struct request *rq)
 		   (!blk_queue_nomerges(rq->q) &&
 		    blk_rq_bytes(last) >= BLK_PLUG_FLUSH_SIZE)) {
 		blk_mq_flush_plug_list(plug, false);
+		blk_plug_invalidate_ts();
 		last = NULL;
 		trace_block_plug(rq->q);
 	}
-- 
2.53.0



