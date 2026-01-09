Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52EDC35BDDB;
	Fri,  9 Jan 2026 12:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962855; cv=none; b=E4G4XoBwoNL+PCracPWqqTN6RD6W6NAfeXbxatjj+GQPWlfLlgBkAXnjxTebFMCytcA7kPGPq1M9/Xn3VmpbWiqgTQQtEau0uDYD5c9MYV7LtGzC2O2SjLCNSWOGdieOBfIqKCfoQ0twl9HjiR0N9SXjnHMELbYUFof9sDMTk0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962855; c=relaxed/simple;
	bh=aSN3fQw5bBtJi/+WPeBt4lyQqY1Kj9nBIjNGiXJHdS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mq/BMPRHxNt7OwUoojb3Z9TiUJJLBVlnnsvLrSnLRJUUHXbsMPf+APZz+LuubfLtWdYq2GXDFwzq76PL6A2c48e0C3jWr7jMnuUA39l2YDcoGzNc4Fhakg1/vDOaBf3TZRkYcf9mhNw/K9FdAtuN7YSJeOmfhXod64A0u/aPCT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V+QP6p3W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V+QP6p3W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEF45C4CEF1;
	Fri,  9 Jan 2026 12:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962855;
	bh=aSN3fQw5bBtJi/+WPeBt4lyQqY1Kj9nBIjNGiXJHdS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V+QP6p3Whs4nGjO4QiK/wojvV/JV8yBltCdOR+un6aewu8oUoITzqWsQnRyY4qVtD
	 NEmLYNE3Muj9Ct719XTqkOXW0WI8TgDM6YDAlrQ0apa8b8Hwk2Fp8X6nAnh2EMVORL
	 0gU6SCOOP09iDO+3hq/LVfQ8+CtJhrvcc1uVM9RM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raju Cheerla <rcheerla@redhat.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 511/634] blk-mq: add helper for checking if one CPU is mapped to specified hctx
Date: Fri,  9 Jan 2026 12:43:09 +0100
Message-ID: <20260109112136.782488652@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

commit 7b815817aa58d2e2101feb2fcf64c60cae0b2695 upstream.

Commit a46c27026da1 ("blk-mq: don't schedule block kworker on isolated CPUs")
rules out isolated CPUs from hctx->cpumask, and hctx->cpumask should only be
used for scheduling kworker.

Add helper blk_mq_cpu_mapped_to_hctx() and apply it into cpuhp handlers.

This patch avoids to forget clearing INACTIVE of hctx state in case that one
isolated CPU becomes online, and fixes hang issue when allocating request
from this hctx's tags.

Cc: Raju Cheerla <rcheerla@redhat.com>
Fixes: a46c27026da1 ("blk-mq: don't schedule block kworker on isolated CPUs")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20240517020514.149771-1-ming.lei@redhat.com
Tested-by: Raju Cheerla <rcheerla@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-mq.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3579,12 +3579,28 @@ static int blk_mq_hctx_notify_offline(un
 	return ret;
 }
 
+/*
+ * Check if one CPU is mapped to the specified hctx
+ *
+ * Isolated CPUs have been ruled out from hctx->cpumask, which is supposed
+ * to be used for scheduling kworker only. For other usage, please call this
+ * helper for checking if one CPU belongs to the specified hctx
+ */
+static bool blk_mq_cpu_mapped_to_hctx(unsigned int cpu,
+		const struct blk_mq_hw_ctx *hctx)
+{
+	struct blk_mq_hw_ctx *mapped_hctx = blk_mq_map_queue_type(hctx->queue,
+			hctx->type, cpu);
+
+	return mapped_hctx == hctx;
+}
+
 static int blk_mq_hctx_notify_online(unsigned int cpu, struct hlist_node *node)
 {
 	struct blk_mq_hw_ctx *hctx = hlist_entry_safe(node,
 			struct blk_mq_hw_ctx, cpuhp_online);
 
-	if (cpumask_test_cpu(cpu, hctx->cpumask))
+	if (blk_mq_cpu_mapped_to_hctx(cpu, hctx))
 		clear_bit(BLK_MQ_S_INACTIVE, &hctx->state);
 	return 0;
 }
@@ -3602,7 +3618,7 @@ static int blk_mq_hctx_notify_dead(unsig
 	enum hctx_type type;
 
 	hctx = hlist_entry_safe(node, struct blk_mq_hw_ctx, cpuhp_dead);
-	if (!cpumask_test_cpu(cpu, hctx->cpumask))
+	if (!blk_mq_cpu_mapped_to_hctx(cpu, hctx))
 		return 0;
 
 	ctx = __blk_mq_get_ctx(hctx->queue, cpu);


