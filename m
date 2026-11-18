Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056960;
	b=Fst/uUkluZetU6i4d7hzb7A0p/LDxW36uHkdxmgzPNu3MacuNyartsjALd6DUz38jrxF
	 i1x1MHEgNIgvs4FQosy3iREb+DkR0nBmGoipGy+lWcWr4eD0a6pdAaAdhExF0pCYhMVKf
	 u8g3kWEFVmAu6T24WplHfh5YdrjTgJxq1xK+6DLXHJ+HJa37vvIQebxlBSSi9lzNl9ZbX
	 7nH59gstWeJ2tX6fnlpo1T8/0wQwBpFCnSJ6bZH/xn6rBlRVDGLQCH2zGuukszbGFntyE
	 e1NzrtXJmV+7VU1k/CdXbJflP2nYcbQUklHxXDJpZZ1MOyF+Alxfw4aAFVuteq7vU/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056960;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K+unV3BqTy1VBBl445qxneyHzr+xIl0MVkyhArvMq8s=;
	b=yuc1Hz2FsaJbkACFh/YLGFBIzf5cUbDtkG7x/jCbZkjP/6k3vmRAZwy8WcAZDSQOFqJy
	 +bV2/ZusssIxaAOrn7SFO/rzNTSbzjfOCZG3iDHxzl78nMRpaunUi8bseaAfEYAfBzhM9
	 NAQ8tdkdb5XErU67NRudq/pMYuAlS7Kn6g94KX0h5ATULfNHjU3f99o4n3lKIwXyQ0+UI
	 t2pQ5nchtd97FaMzZu+rJ6l0dGhg+YKcJyZ1Vub5r3LNX/Yvc7oFvVB5d4CYWMdAwE9Yp
	 RBwwVYxE5G7ehsUdpVTHHwvi1E/lbIsuXiZtAOcqbyF7f1uIx+EMdu3VDjU43nHeJDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eZY46Fqj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA35E606A31C;
	Thu, 19 Nov 2026 02:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eZY46Fqj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35A291F000C4;
	Thu, 19 Nov 2026 02:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056960;
	bh=K+unV3BqTy1VBBl445qxneyHzr+xIl0MVkyhArvMq8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eZY46Fqj37J3gyFYgGpF6gpYNxPgLmXXRPSI1ufCTAwqIHSNCk0ICMsny+JJvwlo6
	 0t2R6zE6TKu6x0s4T2K6hN+397oSDwjWugEBVrAFKWwpwjhsMOKpk/bj3DdzwuZZMu
	 hS8UzmOqnl8P/Xc11V5Z49zBnOm8rqxRM4HALmyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2175/2214] blk-mq: keep sharing tags fairly after a queue update
Date: Wed, 18 Nov 2026 16:04:11 +0100
Message-ID: <20261118150137.398708970@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 62ccdc6f7a093..82ef4af158ca6 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3819,6 +3819,9 @@ static void __blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set,
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



