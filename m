Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022233;
	b=KIjg2kUSWc/1ZGAuhmNPB/1rRJbZz94yyAZCNYW73S76WEKDHNynF0KpUhktbvCjPqFh
	 6SfUHU8qTySdGxbxuGh4jkdhVfW/AV80UuA5h7Ov6kndxBeQRqvL8ES9bTiDjgglop7OC
	 XVOf45GWji5QwR91SBLsWsJ4bEX/Q3X7B3tKGiEuIX2S88Jj9hjpBE4RGutpRfYfiUwe7
	 3I9xNNduDpoEgmbU/c1+xg2nnROzXqE8FNcfwceNCmyoecdzs4tWV/L31xeRtRLCGg4Xq
	 1QUtdqTglrR8dAfgTczhdycp1dksdyzOG2bDq5Wp+Cj+r2raT4z3c7/+w8dhJvvvbLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022233;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eEuOoi2C5B46xUHkuuwlDQNhC2ajSM9w/jEZNpncaVc=;
	b=PvHB8VHAPzUWKm2PtHLue+XmnIIGw5t7BRVKhwinXgh9U7Bh3M9HnvIlQE3j27bK7Lc5
	 0dzDUpgFqZFkh5e5L/DCP3ekYp7UnyrWza++wB9MUaKV8L4BAnoleZvrLwI8Z14XpEO6U
	 NQIN2myxqyZ19LXN4trHRKvJ5y8tnxhP+o7FdfRH8vszTRU/zdXlECQpS6faVH1dT9I6z
	 yoju5YCwrVkQcUn7vRjX1zaRgg3hZpbaqs7bBngu8kJKReyyY5Zy3iOoDajISku2WJBRn
	 bESkQ+gN3W6XyXw9IVWHpLwiaKkcQxXD8tSOVZAyLodlGs5n4pB2GvGDzrEKIQkWdpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="V5ly/2sN";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942B9606A32F;
	Wed, 18 Nov 2026 17:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V5ly/2sN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A58471F000C5;
	Wed, 18 Nov 2026 17:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022233;
	bh=eEuOoi2C5B46xUHkuuwlDQNhC2ajSM9w/jEZNpncaVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V5ly/2sNI8cCHofopgx8B1vMX3kx0tvGEmDyEc6oLFfuffjQQJKTuzzEXS+w8TH/l
	 TlVnykH01VSdJ/wAW68y+LBAomSy7duaN3W36Ct9T7yCo2EmbsgMpZzppRfZZ3154M
	 khbLptRTXmdUmBT7dl29VlPgr8TdMoOPVfBse6MQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Hannes Reinecke <hare@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2590/2651] blk-mq: free the bitmaps of tags in the SRCU callback
Date: Wed, 18 Nov 2026 16:03:50 +0100
Message-ID: <20261118150417.517101336@linuxfoundation.org>
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
index 6e01309226716..04805808ccf9b 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -611,17 +611,17 @@ static void blk_mq_free_tags_callback(struct rcu_head *head)
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



