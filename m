Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ECA127CCF0;
	Tue, 27 May 2025 17:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367200; cv=none; b=BEpCDOsnlxJSO1q07TPLGRTEaUl+/3OWiGQX3aurLhZoqF7qcDBbYbr/hqOWEzfnOB/flKxHcbzPaP/Kb36QhnBwtC4qXqfXyUKdV9lTmEXE5Jv+vv6yyd8Q7twxipqG+LQIvtL1AMI30duDUar59A7fx1ThQxsnFYFoEP8s9Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367200; c=relaxed/simple;
	bh=cCt8VtbgO7DqKC5wA0pZ/q+U50CluHlaz+NU6BsjurU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iNU5UNc9hHxWe9MzltH0n2SM+Vujapw7P5+rCVnifuSbyv5W6fZYn1KzXtns7t+0jqM5b04HsBbp5dG034acymY46ShwtF8eWOeDxCUluQQqH0PgwHZOuRB9WRZlOrx4o7EfpxuThQXu3KQ3U8AQvZRrzzSKemjpJIY+xBcRgFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L5MvIrXX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L5MvIrXX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA814C4CEE9;
	Tue, 27 May 2025 17:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367200;
	bh=cCt8VtbgO7DqKC5wA0pZ/q+U50CluHlaz+NU6BsjurU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L5MvIrXXE3BOdCNUliKvZdT6ZKQlkyHikHf8IKFlHyX79Kh5t/W1JgiDZG0VWmYkL
	 2UuK2Z97FaevKUCesBlIY6AOYmP/lppZ3jzKgWw+s2ZTy3wKGm3KDpXyXw8tDulAW4
	 YLuog30NBOUwY91C29iaPtOWMqrLhoqLJDnwXa3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 309/783] null_blk: generate null_blk configfs features string
Date: Tue, 27 May 2025 18:21:46 +0200
Message-ID: <20250527162525.650676089@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

[ Upstream commit 2cadb8ef25a6157b5bd3e8fe0d3e23f32defec25 ]

The null_blk configfs file 'features' provides a string that lists
available null_blk features for userspace programs to reference.
The string is defined as a long constant in the code, which tends to be
forgotten for updates. It also causes checkpatch.pl to report
"WARNING: quoted string split across lines".

To avoid these drawbacks, generate the feature string on the fly. Refer
to the ca_name field of each element in the nullb_device_attrs table and
concatenate them in the given buffer. Also, sorted nullb_device_attrs
table elements in alphabetical order.

Of note is that the feature "index" was missing before this commit.
This commit adds it to the generated string.

Suggested-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Link: https://lore.kernel.org/r/20250226100613.1622564-2-shinichiro.kawasaki@wdc.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/null_blk/main.c | 86 ++++++++++++++++++++---------------
 1 file changed, 49 insertions(+), 37 deletions(-)

diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index 175566a71bb3f..41c2cd5818b4a 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -592,41 +592,41 @@ static ssize_t nullb_device_zone_offline_store(struct config_item *item,
 CONFIGFS_ATTR_WO(nullb_device_, zone_offline);
 
 static struct configfs_attribute *nullb_device_attrs[] = {
-	&nullb_device_attr_size,
+	&nullb_device_attr_badblocks,
+	&nullb_device_attr_blocking,
+	&nullb_device_attr_blocksize,
+	&nullb_device_attr_cache_size,
 	&nullb_device_attr_completion_nsec,
-	&nullb_device_attr_submit_queues,
-	&nullb_device_attr_poll_queues,
+	&nullb_device_attr_discard,
+	&nullb_device_attr_fua,
 	&nullb_device_attr_home_node,
-	&nullb_device_attr_queue_mode,
-	&nullb_device_attr_blocksize,
-	&nullb_device_attr_max_sectors,
-	&nullb_device_attr_irqmode,
 	&nullb_device_attr_hw_queue_depth,
 	&nullb_device_attr_index,
-	&nullb_device_attr_blocking,
-	&nullb_device_attr_use_per_node_hctx,
-	&nullb_device_attr_power,
-	&nullb_device_attr_memory_backed,
-	&nullb_device_attr_discard,
+	&nullb_device_attr_irqmode,
+	&nullb_device_attr_max_sectors,
 	&nullb_device_attr_mbps,
-	&nullb_device_attr_cache_size,
-	&nullb_device_attr_badblocks,
-	&nullb_device_attr_zoned,
-	&nullb_device_attr_zone_size,
+	&nullb_device_attr_memory_backed,
+	&nullb_device_attr_no_sched,
+	&nullb_device_attr_poll_queues,
+	&nullb_device_attr_power,
+	&nullb_device_attr_queue_mode,
+	&nullb_device_attr_rotational,
+	&nullb_device_attr_shared_tag_bitmap,
+	&nullb_device_attr_shared_tags,
+	&nullb_device_attr_size,
+	&nullb_device_attr_submit_queues,
+	&nullb_device_attr_use_per_node_hctx,
+	&nullb_device_attr_virt_boundary,
+	&nullb_device_attr_zone_append_max_sectors,
 	&nullb_device_attr_zone_capacity,
-	&nullb_device_attr_zone_nr_conv,
-	&nullb_device_attr_zone_max_open,
+	&nullb_device_attr_zone_full,
 	&nullb_device_attr_zone_max_active,
-	&nullb_device_attr_zone_append_max_sectors,
-	&nullb_device_attr_zone_readonly,
+	&nullb_device_attr_zone_max_open,
+	&nullb_device_attr_zone_nr_conv,
 	&nullb_device_attr_zone_offline,
-	&nullb_device_attr_zone_full,
-	&nullb_device_attr_virt_boundary,
-	&nullb_device_attr_no_sched,
-	&nullb_device_attr_shared_tags,
-	&nullb_device_attr_shared_tag_bitmap,
-	&nullb_device_attr_fua,
-	&nullb_device_attr_rotational,
+	&nullb_device_attr_zone_readonly,
+	&nullb_device_attr_zone_size,
+	&nullb_device_attr_zoned,
 	NULL,
 };
 
@@ -704,16 +704,28 @@ nullb_group_drop_item(struct config_group *group, struct config_item *item)
 
 static ssize_t memb_group_features_show(struct config_item *item, char *page)
 {
-	return snprintf(page, PAGE_SIZE,
-			"badblocks,blocking,blocksize,cache_size,fua,"
-			"completion_nsec,discard,home_node,hw_queue_depth,"
-			"irqmode,max_sectors,mbps,memory_backed,no_sched,"
-			"poll_queues,power,queue_mode,shared_tag_bitmap,"
-			"shared_tags,size,submit_queues,use_per_node_hctx,"
-			"virt_boundary,zoned,zone_capacity,zone_max_active,"
-			"zone_max_open,zone_nr_conv,zone_offline,zone_readonly,"
-			"zone_size,zone_append_max_sectors,zone_full,"
-			"rotational\n");
+
+	struct configfs_attribute **entry;
+	char delimiter = ',';
+	size_t left = PAGE_SIZE;
+	size_t written = 0;
+	int ret;
+
+	for (entry = &nullb_device_attrs[0]; *entry && left > 0; entry++) {
+		if (!*(entry + 1))
+			delimiter = '\n';
+		ret = snprintf(page + written, left, "%s%c", (*entry)->ca_name,
+			       delimiter);
+		if (ret >= left) {
+			WARN_ONCE(1, "Too many null_blk features to print\n");
+			memzero_explicit(page, PAGE_SIZE);
+			return -ENOBUFS;
+		}
+		left -= ret;
+		written += ret;
+	}
+
+	return written;
 }
 
 CONFIGFS_ATTR_RO(memb_group_, features);
-- 
2.39.5



