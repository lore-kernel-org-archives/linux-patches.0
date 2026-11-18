Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033166;
	b=BLr1nx8jpo4p09Cwnvko/Xc5Jb+8nry3sxMve+tF/LijthjsMl6R2prLLH/JRyYP1z9/
	 yEeXunDtXvhRzAyAs74AZL8ZKgqSrXCDTTRjOIVXuEd75vIKB1ohOws4DmESv4N4PPJwq
	 JXF5IEVfhwJuWaSV9bqS/0ny2rHHqFUwmjfYoWYq1EAO6BtfdDojI8KoC9tTBvsNZ87yc
	 1sZznP9dq0qIT32AwxcE2HcNukt8HUf9DcSxTR5xlfmCav8MgNAJ1ZPT1T31zs17CQ5u/
	 JnumBVFyg2p8eG4L2XDO+xM8RLQD78YlZS+dpoiXnptZli0/bH9hZ50Qm3Px/O13ZlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033166;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NrjEDJ0IpL9Uq1XVDb8+3npxD6x7bRqiW3X1WL9DAXk=;
	b=oufKMj20AfHEE5DM7XqG+kPLtPdpHIJ+MqOW72/UOHLrnw9fbUeRA52NlNTajtUSID2c
	 3w/wSPh78Xp7HB+f0lEKxR7nhMwgSUoPf+/bDq/+KbGDxYW4wZx6siLFu2hUNEhGufjmw
	 94J+kNh40hSrzCBJAC5aHxhR7EqOV0IA8TJgtSk6izpiN5Ih4+FUFtgRyd+JfI/v5JE/m
	 pSMtKyVawaVXBgVP7Xe/Tqnci6X+tL0bueEgUpfF4dns4ZvD0G6eAAWqo+q3urLTtqmnP
	 IFeWcRn9iei+u3Gvv0FVuE/wkbqED+rxWB52Hz0uv9fF//APy9kIPIOW7mYv0jzA0Lg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p81jwrNq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8314F606A320;
	Wed, 18 Nov 2026 20:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p81jwrNq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D35351F000C5;
	Wed, 18 Nov 2026 20:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033166;
	bh=NrjEDJ0IpL9Uq1XVDb8+3npxD6x7bRqiW3X1WL9DAXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p81jwrNqjoSNwHjPzlpLw7BvsLqcKlPFfVlgnyHRyLdjETvqySwipWn4uCit+2E7w
	 REnFjzbo2iusC1huiYAyGsK6VJKL5ie/mkI4/3FIMNtoQxfyNoKUuyfVvCAb7NLY8w
	 RU6Lw3f6OmJkpbLrl1DysTUCW19b3Fb68D6SQkxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1671/1756] blk-mq: keep sharing tags fairly after a queue update
Date: Wed, 18 Nov 2026 16:03:18 +0100
Message-ID: <20261118150116.216892029@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index c5be2e8578a7b..2ef0a69b6dd42 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -5058,6 +5058,9 @@ static void __blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set,
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



