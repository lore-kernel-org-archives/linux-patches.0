Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042668;
	b=YrHtB/NhrUbJk0VcDKWJKwfy+cAs3JQMxTiXObXtTIrD2y5LuLWJnxpnheVXuimLdlUr
	 m6yy+dizv4EH9d5D7pEI2stOU9T+OChJtg82r5JxKlFE+/x2bb0o5GPoKeowfZXizOQrh
	 hZCSU5KOQ/jkLq4EcsoEQwJz4sn4mj1Uoh7lUJF9dvPWc4sD9BFDdBfrGyksQV2biabyI
	 58wFpzUXZaGonG790318OHD6EY8nrc+p5V3CVnOF9wS04wcSzJELQWl5OwA3Bhy56CMcf
	 GtJEe6B16pwvxtHLEoQ7IdrdvE09+lgZwvWNsjIpTmGMuT54Rt1t9kW+Y8QgZrf9R0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042668;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bgXMNO9rj3QxQ2LivXXq8LrbwDmDgQy1VKV7yggtKDs=;
	b=WweOmkDblZBICz7ug655YB6W3weS5PDQadFKr2Fg0SN5YRZN81qXu7So45DUwXEzhICx
	 yedQjB0UpMPYLelWlM/B348okpE1rnQ+8uYfx/TTIUPvtmmO9ZFnzlJJpZXDQmuKaVNhy
	 JndFDsiZWceTzJTgq/pysWi8rGXK3POLFspHqCQCHv7a2x9pXjPYNIrlI7Er+qrQEZ83Y
	 wrv2559EezEJq+lj4JwDfjeo0AhjL8mOFEZ5newqO5yK5RctNecRc5V4lAFNL5rL48cxb
	 Fnys2CiCRGm9bO8tsgdDG4DLsUUeeiv8IG/NPKnBsbk4M8QBlI7e2gm1OhNmJTndYBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r9yOJnqf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B6F606A31C;
	Wed, 18 Nov 2026 22:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r9yOJnqf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A4161F000C4;
	Wed, 18 Nov 2026 22:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042668;
	bh=bgXMNO9rj3QxQ2LivXXq8LrbwDmDgQy1VKV7yggtKDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r9yOJnqfF91Q5Ox+QiVvGtPdGEGCz/p0oc07uZxFiAnDoFw/Psf/JH36qnz9FsK1j
	 CcPCxnuAIbZdgG4k/BPJlqIijyBcZpdh0md638KjGeWlmLeN4tRpbELIaooIBwdnr/
	 dPrN6Hf5NaQpkhzaDnHYIR5JFg51hSgQfXYwh2M8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3254/3318] blk-mq: keep sharing tags fairly after a queue update
Date: Wed, 18 Nov 2026 16:04:36 +0100
Message-ID: <20261118150457.257203344@linuxfoundation.org>
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
index 32b0bb53b8758..58cbf858fe134 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -4979,6 +4979,9 @@ static void __blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set,
 			goto fallback;
 		}
 		blk_mq_map_swqueue(q);
+		/* The new hctxs don't know yet that they share their tags */
+		if (set->flags & BLK_MQ_F_TAG_QUEUE_SHARED)
+			queue_set_hctx_shared(q, true);
 	}
 
 reregister:
-- 
2.53.0



