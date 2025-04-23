Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F4B127D788;
	Wed, 23 Apr 2025 14:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419603; cv=none; b=RA/jM0G0eHL7S9aw7EvZtNGtaW4o4XhN6JbfpLgGG6H7ru+pCbJ1I8V6RXUE5N1iO7edBFDdTtFE9tBvlytMUkairYtROc59h0NADTVNqpJc6YrY6s5WVpROjeEaswtQWAsM4eLMs9G3seHGQPQ5Yy6XteWRDREpgqUsDZujTmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419603; c=relaxed/simple;
	bh=C/D/MEmfQGY8mXD/qJGj49Dk12TtBWhrjfJrIyTDcew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KgUEz0sam7Fr9bYU/xOy5ZHNiV44JlIZovYydolRgAgZG18QXoWDhV/oenswuiYFJG9jzYadmUPvyyLfe3yy5xGo+DGstsAC1Vprh8eopmLsTYqcYmbbeRa/+fUOlfB4F7bZD9jQihsQddRFCdMlsfiTk8xm1bNxcpe+pXmJdEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OhmaZMIO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OhmaZMIO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5877AC4CEE2;
	Wed, 23 Apr 2025 14:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419601;
	bh=C/D/MEmfQGY8mXD/qJGj49Dk12TtBWhrjfJrIyTDcew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OhmaZMIOmGQ77jKFIyMDCsjSKae65I4NdO0i13A61jhFaj5IwvL9d6LICBGZUjkvt
	 hNwQcT7NFEM1WsF78vj2iJZ4zyEG1cabG8G3AaSAIUFMY/FzOyNbJm5kKaZ+tTG/2u
	 CkuGfFqzQQUyjhoyqs5No0SsfyqTKAMtu7H6bl+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@suse.de>,
	Ming Lei <ming.lei@redhat.com>,
	John Garry <john.g.garry@oracle.com>,
	Daniel Wagner <wagi@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 008/223] blk-mq: introduce blk_mq_map_hw_queues
Date: Wed, 23 Apr 2025 16:41:20 +0200
Message-ID: <20250423142617.460275438@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Wagner <wagi@kernel.org>

[ Upstream commit 1452e9b470c903fc4137a448e9f5767e92d68229 ]

blk_mq_pci_map_queues and blk_mq_virtio_map_queues will create a CPU to
hardware queue mapping based on affinity information. These two function
share common code and only differ on how the affinity information is
retrieved. Also, those functions are located in the block subsystem
where it doesn't really fit in. They are virtio and pci subsystem
specific.

Thus introduce provide a generic mapping function which uses the
irq_get_affinity callback from bus_type.

Originally idea from Ming Lei <ming.lei@redhat.com>

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
Link: https://lore.kernel.org/r/20241202-refactor-blk-affinity-helpers-v6-4-27211e9c2cd5@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: a2d5a0072235 ("scsi: smartpqi: Use is_kdump_kernel() to check for kdump")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq-cpumap.c  | 37 +++++++++++++++++++++++++++++++++++++
 include/linux/blk-mq.h |  2 ++
 2 files changed, 39 insertions(+)

diff --git a/block/blk-mq-cpumap.c b/block/blk-mq-cpumap.c
index 9638b25fd5212..ad8d6a363f24a 100644
--- a/block/blk-mq-cpumap.c
+++ b/block/blk-mq-cpumap.c
@@ -11,6 +11,7 @@
 #include <linux/smp.h>
 #include <linux/cpu.h>
 #include <linux/group_cpus.h>
+#include <linux/device/bus.h>
 
 #include "blk.h"
 #include "blk-mq.h"
@@ -54,3 +55,39 @@ int blk_mq_hw_queue_to_node(struct blk_mq_queue_map *qmap, unsigned int index)
 
 	return NUMA_NO_NODE;
 }
+
+/**
+ * blk_mq_map_hw_queues - Create CPU to hardware queue mapping
+ * @qmap:	CPU to hardware queue map
+ * @dev:	The device to map queues
+ * @offset:	Queue offset to use for the device
+ *
+ * Create a CPU to hardware queue mapping in @qmap. The struct bus_type
+ * irq_get_affinity callback will be used to retrieve the affinity.
+ */
+void blk_mq_map_hw_queues(struct blk_mq_queue_map *qmap,
+			  struct device *dev, unsigned int offset)
+
+{
+	const struct cpumask *mask;
+	unsigned int queue, cpu;
+
+	if (!dev->bus->irq_get_affinity)
+		goto fallback;
+
+	for (queue = 0; queue < qmap->nr_queues; queue++) {
+		mask = dev->bus->irq_get_affinity(dev, queue + offset);
+		if (!mask)
+			goto fallback;
+
+		for_each_cpu(cpu, mask)
+			qmap->mq_map[cpu] = qmap->queue_offset + queue;
+	}
+
+	return;
+
+fallback:
+	WARN_ON_ONCE(qmap->nr_queues > 1);
+	blk_mq_clear_mq_map(qmap);
+}
+EXPORT_SYMBOL_GPL(blk_mq_map_hw_queues);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 7b5e5388c3801..d5229fd6f054b 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -947,6 +947,8 @@ void blk_mq_unfreeze_queue_non_owner(struct request_queue *q);
 void blk_freeze_queue_start_non_owner(struct request_queue *q);
 
 void blk_mq_map_queues(struct blk_mq_queue_map *qmap);
+void blk_mq_map_hw_queues(struct blk_mq_queue_map *qmap,
+			  struct device *dev, unsigned int offset);
 void blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set, int nr_hw_queues);
 
 void blk_mq_quiesce_queue_nowait(struct request_queue *q);
-- 
2.39.5



