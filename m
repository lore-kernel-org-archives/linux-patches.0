Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028238;
	b=1dhV2c7trl4ZoI5bezMqMv6ERjtJ78anq0hiLKrpZM3mDQhfPGaZGc8Pii59/uGiTFMw
	 QrKlXXwY4126eGYf+JgZpAFDZinDM9Ny4oexKfpDov/DlmVXIL25sJU/LALQC9WJ6dz2W
	 Jz2XwMeYddkWOUUjZeflEsv+auOTvM6FYO8gQQxOTUaAHmgB8tVuakaSFKwfBhPKZPMot
	 4x3OoqLIsAd5L/12Sq98egkzjv0ST2ALEufMxk526VSysCJsyNUp8ruCuWtTx9ZDNcaSL
	 375SwTDhToSg8DtFFIvWeNg5JrazQaNtHeRQOtN8HnF7unk6923hlP1DxKlCijcXIdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028238;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ftRYZZP9Gsua93iwgj5uDTC4/KfmpDfFwULRv/Cx7mU=;
	b=0zdOlwvIHGCsSjQw1uW+1BJ0SxHVzLQct8G3MoAzqedrdbQhDwyEnDOxvdIPRcXtdmt+
	 zAYgzcnTZtASTUYwELT11fyakmjV50bTXVBsys70L5u7ZhDuc6rNzgMgXSLYCg5pc8i0x
	 Mdfy3yKV5gM6Nq/vVRzEKEBt+CSNyOhWsS/Ha2I93otNM6M5M+38vr1AJPo6Er3cWYokC
	 YJCOyannCl3amCUXCxUVMTEjkIpnyJu2YhzYkHoFoERMpvxTt6J0uR048WwLTHfWSnOhX
	 7Vj8Li515PnT3hlyIHp/DcJkuWhXSSlsjn8WJZ/4V95tU+c5umnOF3Fu2p3YMgcMxhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B5nYJuui;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9841F606A31C;
	Wed, 18 Nov 2026 18:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B5nYJuui
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3B291F000C4;
	Wed, 18 Nov 2026 18:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028238;
	bh=ftRYZZP9Gsua93iwgj5uDTC4/KfmpDfFwULRv/Cx7mU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B5nYJuuiDshzuQU+nt90nmbufwVSrYfmP6Hsq0zReDjJOqhhogUusU7KzSvcBms01
	 ciXLAW3Olx3SYLOAgm7QT9P2Kr2G36IVGuQbNpOHSd6qavwkGLwAPrx3d2Dv88mvUt
	 PBp7u6KvOnD4MPBVn05nz+EkcAHHnUetrtpinZTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2073/2151] blk-mq: keep sharing tags fairly after a queue update
Date: Wed, 18 Nov 2026 16:03:28 +0100
Message-ID: <20261118150237.231021615@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 170e6d068ccef..4c41374a8bb9c 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -5180,6 +5180,9 @@ static void __blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set,
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



