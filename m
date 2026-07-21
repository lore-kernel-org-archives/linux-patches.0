Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF8B46AA62;
	Tue, 21 Jul 2026 15:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648059; cv=none; b=Tfy+6R0PJ8OuXRPDn/Jd1iwUstaO76cOLnTyAtbeDwt5PZecbCm4di0dTxp6jLOGLm8GvZVxaSCQS3niW+7K0AbydPfJGzk59fcIOEAqCCH5OqDZQ9ECCnk5or/TY4FooHXzR/tu7836y6W/rd2xRWKZ5vLSr9Yp7cBaJR/+6O8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648059; c=relaxed/simple;
	bh=P9NFqOPQ+ahnEAmnYRZ+YeWM0M6Grv5rI5fBpk8sY2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tPSZ0m/waEHlNCXDZOEOsKVpvTT9Qu0tDE+xq435YRhp3j6iMSh5JMjARTJvwi690c9+Hm6dQ/mbnRBim9nSBtwvkkh9Pvx2ZuO7POITfSzMDKyo13WnDk89v526ENpp+sfbiiQjwVVqV2Rs4qDW79P6Kw23dRUvVE0zzfELnf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XmQTpHyL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XmQTpHyL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66EB11F000E9;
	Tue, 21 Jul 2026 15:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648057;
	bh=WUqoHTTN7TD+0YNLF4CcQ3ZD8lceHyyKIY+Zdq79w8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XmQTpHyLU4UbG2suqP6OcLysEEKoNbNJmlTbM7Xw3B1muAKxX+f5FgQpHYGdZnz2f
	 gj9Kf+XMk9FevJepcIH13yLEDcUOvLclJrcKUouE5yTFFe32PjrdLO1sqC8FON9gkU
	 vhNVkNGCqhFsUVV7eupAN61P4uZlUannKAyVohsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Philipp Stanner <phasta@kernel.org>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0056/2077] dma-fence: Fix potential tracepoint null pointer dereferences
Date: Tue, 21 Jul 2026 16:55:29 +0200
Message-ID: <20260721152554.014075514@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>

[ Upstream commit e94b9f01543cc6a83538c2c2cc645a424d3015ca ]

Trace_dma_fence_signaled, trace_dma_fence_wait_end and
trace_dma_fence_destroy can all currently dereference a null fence->ops
pointer after it has been reset on fence signalling.

Lets use the safe string getters for most tracepoints to avoid this class
of a problem, while for the signal tracepoint we move it to before ops are
cleared to avoid losing the driver and timeline name information. Apart
from moving it we also need to add a new tracepoint class to bypass the
safe name getters since the signaled bit is already set.

For dma_fence_init we also need to use the new tracepoint class since the
rcu read lock is not held there, and we can do the same for the enable
signaling since there we are certain the fence cannot be signaled while
we are holding the lock and have even validated the fence->ops.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Fixes: 541c8f2468b9 ("dma-buf: detach fence ops on signal v3")
Cc: Christian König <christian.koenig@amd.com>
Cc: Philipp Stanner <phasta@kernel.org>
Cc: Boris Brezillon <boris.brezillon@collabora.com>
Cc: linux-media@vger.kernel.org
Cc: linaro-mm-sig@lists.linaro.org
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Link: https://lore.kernel.org/r/20260415083207.40513-2-tvrtko.ursulin@igalia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma-buf/dma-fence.c      |  3 ++-
 include/trace/events/dma_fence.h | 40 +++++++++++++++++++++++++++-----
 2 files changed, 36 insertions(+), 7 deletions(-)

diff --git a/drivers/dma-buf/dma-fence.c b/drivers/dma-buf/dma-fence.c
index a2aa82f4eedd49..b3bfa6943a8e13 100644
--- a/drivers/dma-buf/dma-fence.c
+++ b/drivers/dma-buf/dma-fence.c
@@ -363,6 +363,8 @@ void dma_fence_signal_timestamp_locked(struct dma_fence *fence,
 				      &fence->flags)))
 		return;
 
+	trace_dma_fence_signaled(fence);
+
 	/*
 	 * When neither a release nor a wait operation is specified set the ops
 	 * pointer to NULL to allow the fence structure to become independent
@@ -377,7 +379,6 @@ void dma_fence_signal_timestamp_locked(struct dma_fence *fence,
 
 	fence->timestamp = timestamp;
 	set_bit(DMA_FENCE_FLAG_TIMESTAMP_BIT, &fence->flags);
-	trace_dma_fence_signaled(fence);
 
 	list_for_each_entry_safe(cur, tmp, &cb_list, node) {
 		INIT_LIST_HEAD(&cur->node);
diff --git a/include/trace/events/dma_fence.h b/include/trace/events/dma_fence.h
index 3abba45c0601a4..5b10a9e06fb4ec 100644
--- a/include/trace/events/dma_fence.h
+++ b/include/trace/events/dma_fence.h
@@ -9,12 +9,40 @@
 
 struct dma_fence;
 
+DECLARE_EVENT_CLASS(dma_fence,
+
+	TP_PROTO(struct dma_fence *fence),
+
+	TP_ARGS(fence),
+
+	TP_STRUCT__entry(
+		__string(driver, dma_fence_driver_name(fence))
+		__string(timeline, dma_fence_timeline_name(fence))
+		__field(unsigned int, context)
+		__field(unsigned int, seqno)
+	),
+
+	TP_fast_assign(
+		__assign_str(driver);
+		__assign_str(timeline);
+		__entry->context = fence->context;
+		__entry->seqno = fence->seqno;
+	),
+
+	TP_printk("driver=%s timeline=%s context=%u seqno=%u",
+		  __get_str(driver), __get_str(timeline), __entry->context,
+		  __entry->seqno)
+);
+
 /*
  * Safe only for call sites which are guaranteed to not race with fence
- * signaling,holding the fence->lock and having checked for not signaled, or the
- * signaling path itself.
+ * signaling, holding the fence->lock and having checked for not signaled, or
+ * the signaling path itself.
+ *
+ * TODO: Remove the need for this event class when drivers switch to independent
+ *       fences.
  */
-DECLARE_EVENT_CLASS(dma_fence,
+DECLARE_EVENT_CLASS(dma_fence_ops,
 
 	TP_PROTO(struct dma_fence *fence),
 
@@ -46,7 +74,7 @@ DEFINE_EVENT(dma_fence, dma_fence_emit,
 	TP_ARGS(fence)
 );
 
-DEFINE_EVENT(dma_fence, dma_fence_init,
+DEFINE_EVENT(dma_fence_ops, dma_fence_init,
 
 	TP_PROTO(struct dma_fence *fence),
 
@@ -60,14 +88,14 @@ DEFINE_EVENT(dma_fence, dma_fence_destroy,
 	TP_ARGS(fence)
 );
 
-DEFINE_EVENT(dma_fence, dma_fence_enable_signal,
+DEFINE_EVENT(dma_fence_ops, dma_fence_enable_signal,
 
 	TP_PROTO(struct dma_fence *fence),
 
 	TP_ARGS(fence)
 );
 
-DEFINE_EVENT(dma_fence, dma_fence_signaled,
+DEFINE_EVENT(dma_fence_ops, dma_fence_signaled,
 
 	TP_PROTO(struct dma_fence *fence),
 
-- 
2.53.0



