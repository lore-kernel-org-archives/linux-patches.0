Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022317;
	b=dMyadfg5FMMM0/VfiRf7niRI6ZTSwgSknTXUWO4zRk/mT5l00XFT7mIYGyv0SACWzmHB
	 KKsOXtAfaAyVJd8beIKhjCfAs2wi5PsYZty/9cug1xeLjbA0Uhbm+Vc9OYO5ygfusP4CN
	 hwTuXyw2d4kx4mw+iULd6bRUB8C1unL2Qcoru06m0lTqbGPK714Br/OUyZjHYv2R3ANnR
	 MoRRV9prDj7DOMsnd6J7FsUxVG+4otWzXjaW78AX2vIIp3H15qCoLysPVTmJDh6VSfdjz
	 zYzYCWKErji+PAqVzVq5z+6g+4LmtFA7ExZ2CjlEof7/E8oZT7CwTUqFp7ZJwA7OzAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022317;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pQzKPQhbhISphn08r8Pke2x3KulHv111gav6XOtYA8A=;
	b=tpdAC14Lxe4NnR9eI9mzQEaD1cAA/pNTGvhfi12gFtycb+fxBxpW7o5Af2TdWgbhdWMe
	 b2BQZTv0ncBkPJk20byXIlkcRmVXjZpoT32paqVf9KYCQG4QTRei+MP+x0T5tivA+PEjP
	 SrjttKG5wgolN92qJ0kJZ494AS6BdaqZF1DIwT9P+Ev1syhxgQa6hCS0NvbmZfdKvSTV9
	 3f/N+Rr5CJ+j+ehZmBSQ6VdMl5M8ro7h77Bv23WHvVgUh9K6woO8Bs61yF+01IKrs9gFj
	 lsnlCTXdeitRmBIk/RzfKjhmKICrHnZUl9gjJ+4FQccqf2GdMJBuTDe/QbLiU2J8xZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xchIdlp1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B7C606A31C;
	Wed, 18 Nov 2026 17:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xchIdlp1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6830F1F000C6;
	Wed, 18 Nov 2026 17:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022317;
	bh=pQzKPQhbhISphn08r8Pke2x3KulHv111gav6XOtYA8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xchIdlp1L2DK0IA+IhQ2p0CBudVzCc+gvzFzuz23z5zwAt+/XSuFd5PfK+zHYWMJ8
	 RRoxBH+vt2epjJ2AsycsdMMrNrzTl1VDRQaRnUqGOW081hxP5PPubxWcAjCRgC24dv
	 aQGfR+lzX4kBcfPjrRTwvzAIEqO7/ydp0sg9e3/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2582/2651] blk-mq: keep sharing tags fairly after a queue update
Date: Wed, 18 Nov 2026 16:03:42 +0100
Message-ID: <20261118150417.276721007@linuxfoundation.org>
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

[ Upstream commit 620cfc7a664278a55d068ed88fff1242fddc4ef2 ]

A hctx only gets BLK_MQ_F_TAG_QUEUE_SHARED from
blk_mq_add_queue_tag_set(). The hctxs blk_mq_update_nr_hw_queues()
allocates for queues that joined long ago never get it, so they aren't
counted in active_queues and hctx_may_queue() lets them take all the
tags. One NVMe namespace can starve the others after the first update.

Set the flag on the new hctxs.

Fixes: 868f2f0b7206 ("blk-mq: dynamic h/w context count")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20261028164415.1262013-30-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 7a07ae9dc6fa6..9f0e3af0f3366 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -5184,6 +5184,9 @@ static void __blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set,
 			goto fallback;
 		}
 		blk_mq_map_swqueue(q);
+		/* The new hctxs don't know yet that they share their tags */
+		if (set->flags & BLK_MQ_F_TAG_QUEUE_SHARED)
+			queue_set_hctx_shared(q, true);
 	}
 switch_back:
 	/* The blk_mq_elv_switch_back unfreezes queue for us. */
-- 
2.53.0



