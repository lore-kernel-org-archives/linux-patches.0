Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F49B18654
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:48:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B643EC433C8;
	Wed, 20 Sep 2023 11:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210483;
	bh=XpFK2Y8fDDLByprZvMsbmMcssm+siP4qfwuoFyC4eyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A842k3z6p2zknB8EMrRmlXWWG92oiu7Zk7Jxo+D8KWs9niYGZugSZWTnhnV5KU+lv
	 4hBDpmJJmEb0I4ZC7O/6eWx1UVPI8sW/d38SKzhR2SPej9wCJt77o/zNBwAWXFyKcP
	 9SdZ6OtmeK6jOOJDwiiOCUd2tYeQ40PebYcmjPJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengming Zhou <zhouchengming@bytedance.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 092/211] blk-mq: fix tags leak when shrink nr_hw_queues
Date: Wed, 20 Sep 2023 13:28:56 +0200
Message-ID: <20230920112848.668271708@linuxfoundation.org>
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

[ Upstream commit e1dd7bc93029024af5688253b0c05181d6e01f8e ]

Although we don't need to realloc set->tags[] when shrink nr_hw_queues,
we need to free them. Or these tags will be leaked.

How to reproduce:
1. mount -t configfs configfs /mnt
2. modprobe null_blk nr_devices=0 submit_queues=8
3. mkdir /mnt/nullb/nullb0
4. echo 1 > /mnt/nullb/nullb0/power
5. echo 4 > /mnt/nullb/nullb0/submit_queues
6. rmdir /mnt/nullb/nullb0

In step 4, will alloc 9 tags (8 submit queues and 1 poll queue), then
in step 5, new_nr_hw_queues = 5 (4 submit queues and 1 poll queue).
At last in step 6, only these 5 tags are freed, the other 4 tags leaked.

Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20230821095602.70742-1-chengming.zhou@linux.dev
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 953f08354c8c3..d9b365c2eaa0d 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -4402,9 +4402,13 @@ static int blk_mq_realloc_tag_set_tags(struct blk_mq_tag_set *set,
 				       int new_nr_hw_queues)
 {
 	struct blk_mq_tags **new_tags;
+	int i;
 
-	if (set->nr_hw_queues >= new_nr_hw_queues)
+	if (set->nr_hw_queues >= new_nr_hw_queues) {
+		for (i = new_nr_hw_queues; i < set->nr_hw_queues; i++)
+			__blk_mq_free_map_and_rqs(set, i);
 		goto done;
+	}
 
 	new_tags = kcalloc_node(new_nr_hw_queues, sizeof(struct blk_mq_tags *),
 				GFP_KERNEL, set->numa_node);
-- 
2.40.1



