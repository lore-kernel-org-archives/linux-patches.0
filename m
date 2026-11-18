Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028258;
	b=vCeWrZjUVVkTJBitKvE2hhbkLc2vYc6PQGUAynjqmZGJDXFy+fNboHcUfDbIEUKyd5YX
	 EmARciwFCIhUpO+PZrjADXvOn5L1OnJvItMqHTYF0ksEQNhfxDpcPO1uGi1G31RJjpUAO
	 nvGmPLa0FpwfQQ6upBvouBJYzVQN/aCm/SYhNSs5UBB3EEj7cFPFNr9DYbPtujCQFROwm
	 65EZymN//24T3wh819lO32/JPnbEs3t4l3qsCscgpPf/B4fvgh9bEg2VAo2M/3nRU5Bi3
	 yTAji3D7bukXmmrMjRqHmE21AkM0z4Ukg8h+fjAflkm/MZRNcSeqHx5Smd8Pagl70TA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028258;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8g2r+39woUfeFBAm8uM1F2kkydhLeJVSSashK90FApQ=;
	b=nyxDumUZBy9QW6ewXOq0yM++oeNWoo5uc1iNhA1w7RIC2dxZCjv0wGkNdprW8rYbmZgE
	 o3eMePlijbWzyw0INjCYwB91iYVdpgOLaPX6c5DQZ3MOns8o/SxYANyughLVgEelvpJO+
	 6jyy58BBSJjvqIUuo/mxk1CvaXa9qbMww1C1AtS84vbdk04RZQEdhnSghukH4BymB2Xza
	 yPP+L/rEXxPC/dnvUYapoFlMnsggZ5hYBa4hMXGYdzF24iGQiPaxTEKv3jrN4y8CLeJM9
	 NmpwCb6TiH8f+dct04x0NfZX8H0T4Tyor3DBHOEGGgcTRkiKdCu3uVZzdzNwUcIRrzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q59GrvU0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4A4606A31C;
	Wed, 18 Nov 2026 18:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q59GrvU0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C21831F000C4;
	Wed, 18 Nov 2026 18:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028258;
	bh=8g2r+39woUfeFBAm8uM1F2kkydhLeJVSSashK90FApQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q59GrvU0WxV5tP4D4rPzrD49CryKVA53HcFuVHzgoQaB0v9u4jApywtynbbv2vIwm
	 SoPySzbxNZGjFbQ/NvzsDVvdYIqpanQXWmHf1jSXDaYGPZ9XZ2DLUw3K46kxAPT5Ea
	 +YOEQPpzXfIP8VChWQgkOfNec2DS1WCZ3MXpzs0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Hannes Reinecke <hare@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2080/2151] blk-mq: free the bitmaps of tags in the SRCU callback
Date: Wed, 18 Nov 2026 16:03:35 +0100
Message-ID: <20261118150237.483200519@linuxfoundation.org>
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

[ Upstream commit 10b249e9b05eed0c4c65b9b89dfc2cf33d68d19a ]

Commit ad0d05dbddc1 keeps struct blk_mq_tags and the requests until the
iterators under tags_srcu are gone, but the two bitmaps they walk are
still freed right away. When the number of hardware queues shrinks,
blk_mq_tagset_busy_iter() may be about to walk tags that
__blk_mq_update_nr_hw_queues() frees. sbitmap_free() clears the map
pointer, so that's a NULL dereference or a use-after-free, depending on
the timing.

Free the bitmaps with the rest in the callback.

Fixes: ad0d05dbddc1 ("blk-mq: Defer freeing of tags page_list to SRCU callback")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Link: https://patch.msgid.link/20261028164415.1262013-44-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq-tag.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index d168c0a080e3c..4e4da442bf940 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -605,17 +605,17 @@ static void blk_mq_free_tags_callback(struct rcu_head *head)
 		kmemleak_free(page_address(page));
 		__free_pages(page, page->private);
 	}
+	/* An iterator may walk the bitmaps for as long as it may see the tags */
+	sbitmap_queue_free(&tags->bitmap_tags);
+	sbitmap_queue_free(&tags->breserved_tags);
 	kfree(tags);
 }
 
 void blk_mq_free_tags(struct blk_mq_tag_set *set, struct blk_mq_tags *tags)
 {
-	sbitmap_queue_free(&tags->bitmap_tags);
-	sbitmap_queue_free(&tags->breserved_tags);
-
 	/* if tags pages is not allocated yet, free tags directly */
 	if (list_empty(&tags->page_list)) {
-		kfree(tags);
+		blk_mq_free_tags_callback(&tags->rcu_head);
 		return;
 	}
 
-- 
2.53.0



