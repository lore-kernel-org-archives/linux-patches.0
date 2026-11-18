Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062166;
	b=xvvWNFpnZ3b49/aybhN0n1TD7S530Ioa8tkXd6f+l18Ks4MnZiq5oW8bvpY/cfochait
	 ac+c7D2BgGl9aCEL99+6ePbYr5WW26guzgFssjOzZS+Y0v2mvXHuB1wIuZ3wGNS7/Pdhu
	 gWK3K1Ww18fGpbfiZ9MV1iaSHo+lF+RryN+UxKbypaPDtAcvTfFsHgcmKo9ItNt9xzkGv
	 vZxDxlDkcE32G2yd9YeuxBiZeUnBWCZcrTiMb8hhQNfuBQTB92LWvSkOtkbEj5QglBJEQ
	 RpdnVlLYlwlcD7a1drCon5QThvJaFgjaXoc9GrwdzunTPiqyX02SGG/kjPoN/muZpxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062166;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=27YBaPufAYwK4vgErJ6X+UDlW9i+bm8gvHvVC2A2aJk=;
	b=PZ5Bajygmb3BNaAyr0sTfH1U+UmvcmocTl8ZoOkWxsiDQEreMHN6Gi1qk5/2jqQbZErl
	 iMtCvxpqfqaUwoXshtF40x+hIyox3Fj7mubHwFEVRj15wV1jjy8YAORwp9geVYYwcZn9w
	 aT6OPRPRfiEjzH8U51Edhg514WUXs4Y5ocbklTtwSh8iydBQP2rA3unJdPaPfny0RloYU
	 76VVijBm05SMnhwlg5mAiC1gjd+vu3WecULbLIwRyI1hY3rIfRly8db9s2KvdOCusHQdp
	 NyJ7p1PRXse+ve1SAgQj+waSwk62xkNv3J/97tjIdax1gSOuvVpeqMpZPg7WVqOyFDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2eS8lUBS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871D9606A325;
	Thu, 19 Nov 2026 04:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2eS8lUBS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93A8C1F000C4;
	Thu, 19 Nov 2026 04:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062166;
	bh=27YBaPufAYwK4vgErJ6X+UDlW9i+bm8gvHvVC2A2aJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2eS8lUBS19pi5VGv1v3VN4zbME8eHK7n4bPDGuuidESfgSVfAbvre4k91RbFAH+/n
	 eacPwJj1Dn9BQ2soKmFMibYEP6WZX5VLO29TDo6JlVBF+TtoiXO7sm7hjrO0bbjCPd
	 Y/rCYevCmUk5ErFtVaUoH6Z0JxV+me9Y+/+ZBFZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1812/1848] blk-mq: keep sharing tags fairly after a queue update
Date: Wed, 18 Nov 2026 16:04:10 +0100
Message-ID: <20261118150035.281601333@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e81af96eb18a7..057de68ff219d 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3776,6 +3776,9 @@ static void __blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set,
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



