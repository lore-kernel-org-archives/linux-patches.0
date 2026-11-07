Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063084;
	b=QIW0h7Ge1Aj7UXWNA1elhsg2XyyefHdVv0lSGk1GyI+IfmOlWqNWV7jo5VNx06i2NVlt
	 6SgmyuZLWSNWeAsdPhgkEsKVogPhvNZDLvvurQzkEC7h2iSOhGPT67D05DzAg042q+aLL
	 3RCBLxWn74uSw9Ah33wuNle86AHJYJrO0R7pQ9kGskiyJUWCTdSmEXBGgWhDjpSFII7V+
	 f+OTYyQzkN+WVNpqWIfZ7pnu8XtJQkNK7ajrNSPbpwyDOdnTVUQFlBoRJZ1u139wwu1oN
	 vakvl7+nPyW6KonFL4bxpZoKLEH2MCK/DzkYmftSu+WrG9l07Y76CsSgeoisGhEI4Hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063084;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b7RpZ/6OnegPYM351wpZkCH5htuIX1a681nQ34p5CUI=;
	b=4DkYq+1Y5WDT8EjXKZ6p+wGOVcY/LRfWFu0sAENs27Gy3H9jlXNkX34tkskDDu82gNgA
	 OVMLXTLCmFutfXS0xXpXnDaVpxCjbGc6WrviUftg8kWT78Nb//2qvdHCYbB+1jFdA2Cvu
	 rPviQWX6L/pNQh33GF9xHAiU79th8pOQpXQJbwU+UkMiOLNp02s9d7bixfyimMNWDHty8
	 PgEnRVYIGq1pqDB71CY8uM8sWhX5iovgRbUgLgO0qKhMImU3OLjtJVr699cB4N+WoVGov
	 qlrlr6p57sFzWHv3r6UcUGBhMk/wIZmV8lXIPN4GzlstlpB5VcpwV73Qt9PSQ7wkroA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ogVVJImZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 688F7606D81B;
	Sat,  7 Nov 2026 14:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ogVVJImZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B5BC1F0089F;
	Sat,  7 Nov 2026 14:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063084;
	bh=b7RpZ/6OnegPYM351wpZkCH5htuIX1a681nQ34p5CUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ogVVJImZ/wSs3vHYJlhZIaJ4isa2OE9GmTUQLM68x1xDYrjKo03NfZyiEi/1tyPO3
	 OdIVZBM8TmIW8X5Pmn3eT/IzAFpsRqWru9ubn6bV1wgRrGhEPwQNl5vO5iM/Vr7d1k
	 7rvzmgCCABAXwM2pMlkITk2SaSYAV2SX0RB9+YYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasileios Almpanis <vasileios.almpanis@virtuozzo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 323/869] block: drop the cached plug time when blk_add_rq_to_plug() flushes
Date: Sat,  7 Nov 2026 08:50:05 -0500
Message-ID: <20261107134903.416296046@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index ba0c48d58e134..73ee5a9ea51d6 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1428,6 +1428,7 @@ static void blk_add_rq_to_plug(struct blk_plug *plug, struct request *rq)
 		   (!blk_queue_nomerges(rq->q) &&
 		    blk_rq_bytes(last) >= BLK_PLUG_FLUSH_SIZE)) {
 		blk_mq_flush_plug_list(plug, false);
+		blk_plug_invalidate_ts();
 		last = NULL;
 		trace_block_plug(rq->q);
 	}
-- 
2.53.0



