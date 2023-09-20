Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2778A27701
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:52:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E930C433C8;
	Wed, 20 Sep 2023 11:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210744;
	bh=VfQ96Z2Gl+Q2kZ1MiUCHenWai9OOy6ikjvJF64tlRcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XDu9uLuGPdRPxcXXvTZfG6/eeAjzYvDFRmtmsMGOzGWmG0q6y/aVjd8YbSfTTH+9l
	 duyUvKoD71A3yE+uQnY2yufhOpVHe8rGyANjffSphWoGI/Y8Ru1XekVeaFaJgjRQSn
	 Jq8StacSVUkC91JzhgqOYgNhuzEUY6byxA3prXWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengming Zhou <zhouchengming@bytedance.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.5 163/211] blk-mq: prealloc tags when increase tagset nr_hw_queues
Date: Wed, 20 Sep 2023 13:30:07 +0200
Message-ID: <20230920112850.941684982@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112845.859868994@linuxfoundation.org>
References: <20230920112845.859868994@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengming Zhou <zhouchengming@bytedance.com>

commit 7222657e51b5626d10154b3e48ad441c33b5da96 upstream.

Just like blk_mq_alloc_tag_set(), it's better to prepare all tags before
using to map to queue ctxs in blk_mq_map_swqueue(), which now have to
consider empty set->tags[].

The good point is that we can fallback easily if increasing nr_hw_queues
fail, instead of just mapping to hctx[0] when fail in blk_mq_map_swqueue().

And the fallback path already has tags free & clean handling, so all
is good.

Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20230821095602.70742-3-chengming.zhou@linux.dev
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-mq.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -4420,6 +4420,16 @@ static int blk_mq_realloc_tag_set_tags(s
 		       sizeof(*set->tags));
 	kfree(set->tags);
 	set->tags = new_tags;
+
+	for (i = set->nr_hw_queues; i < new_nr_hw_queues; i++) {
+		if (!__blk_mq_alloc_map_and_rqs(set, i)) {
+			while (--i >= set->nr_hw_queues)
+				__blk_mq_free_map_and_rqs(set, i);
+			return -ENOMEM;
+		}
+		cond_resched();
+	}
+
 done:
 	set->nr_hw_queues = new_nr_hw_queues;
 	return 0;


