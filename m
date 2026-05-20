Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A3B36D9E7;
	Wed, 20 May 2026 16:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294933; cv=none; b=LKb51EDVz+2C+BuqBUzeAVt+7gfe46JiTiSKEGtJwp3sqQmLb8NP7MC6d38Roq08N7el03lPsUlEFUYxKUhYIbVuzDMa8X0rYOLxu3eTbR9aKU2iABl3sinhqasznDWynSBCu6gpHWA2Xt0dxPoKjToWH7PcidPMpQZuIP61g7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294933; c=relaxed/simple;
	bh=6DXbqdQFng45Gzhyz3gzQaLrxlxGOoZZ5p8f+TpyJOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=flXibOH98/9DNMXlUusagrEcIOJ7qS6z2CEKXz2UwGcdURC8VgHm8qwG8qV7l0sr6PU4rVXKM0DIfaCNm2sKr3NuZTiJHwLIsMfG8XYq3N1kSeJCEjIowBRREATPQLPD1HR9v//eWGM5rfBHVao3qx1LDpEU9GK/GUZQcqf/4fA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z8nWlyMO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z8nWlyMO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99BF71F00893;
	Wed, 20 May 2026 16:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294932;
	bh=aTaPl2S9Y/yr3O8GAWBg7DV2QdjozvHb60LJ0sBGWbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z8nWlyMO1rgpARCc+X7+zFwepfxxpCRnlGxn5CAEUfIdDdsWnWz83j4IWDS7NrPg3
	 GG2XOjMFKdLO8HR5Oel1PS9jMIUTJ6JW+75lkzfEcGlaRnF1+/oRfoAN4IP05nH48j
	 hFWfaDOApkpDBaHGJTQ/T9mBhpP9h5d8JyQG7+DA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	kernel test robot <lkp@intel.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0228/1146] dma-fence: Fix sparse warnings due __rcu annotations
Date: Wed, 20 May 2026 18:07:58 +0200
Message-ID: <20260520162153.413202679@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>

[ Upstream commit 62918542b7bf08860a60ebbde7654486e0ac0776 ]

__rcu annotations on the return types from dma_fence_driver_name() and
dma_fence_timeline_name() cause sparse to complain because both the
constant signaled strings, and the strings return by the dma_fence_ops are
not __rcu annotated.

For a simple fix it is easiest to cast them with __rcu added and undo the
smarts from the tracpoints side of things. There is no functional change
since the rest is left in place. Later we can consider changing the
dma_fence_ops return types too, and handle all the individual drivers
which define them.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Fixes: 506aa8b02a8d ("dma-fence: Add safe access helpers and document the rules")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202506162214.1eA69hLe-lkp@intel.com/
Reviewed-by: Christian König <christian.koenig@amd.com>
Link: https://lore.kernel.org/r/20250616155952.24259-1-tvrtko.ursulin@igalia.com
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma-buf/dma-fence.c      |  8 ++++----
 include/trace/events/dma_fence.h | 35 +++++---------------------------
 2 files changed, 9 insertions(+), 34 deletions(-)

diff --git a/drivers/dma-buf/dma-fence.c b/drivers/dma-buf/dma-fence.c
index 35afcfcac5910..abb6d8f8f95d2 100644
--- a/drivers/dma-buf/dma-fence.c
+++ b/drivers/dma-buf/dma-fence.c
@@ -1133,9 +1133,9 @@ const char __rcu *dma_fence_driver_name(struct dma_fence *fence)
 			 "RCU protection is required for safe access to returned string");
 
 	if (!dma_fence_test_signaled_flag(fence))
-		return fence->ops->get_driver_name(fence);
+		return (const char __rcu *)fence->ops->get_driver_name(fence);
 	else
-		return "detached-driver";
+		return (const char __rcu *)"detached-driver";
 }
 EXPORT_SYMBOL(dma_fence_driver_name);
 
@@ -1165,8 +1165,8 @@ const char __rcu *dma_fence_timeline_name(struct dma_fence *fence)
 			 "RCU protection is required for safe access to returned string");
 
 	if (!dma_fence_test_signaled_flag(fence))
-		return fence->ops->get_timeline_name(fence);
+		return (const char __rcu *)fence->ops->get_driver_name(fence);
 	else
-		return "signaled-timeline";
+		return (const char __rcu *)"signaled-timeline";
 }
 EXPORT_SYMBOL(dma_fence_timeline_name);
diff --git a/include/trace/events/dma_fence.h b/include/trace/events/dma_fence.h
index 4814a65b68dcb..3abba45c0601a 100644
--- a/include/trace/events/dma_fence.h
+++ b/include/trace/events/dma_fence.h
@@ -9,37 +9,12 @@
 
 struct dma_fence;
 
-DECLARE_EVENT_CLASS(dma_fence,
-
-	TP_PROTO(struct dma_fence *fence),
-
-	TP_ARGS(fence),
-
-	TP_STRUCT__entry(
-		__string(driver, dma_fence_driver_name(fence))
-		__string(timeline, dma_fence_timeline_name(fence))
-		__field(unsigned int, context)
-		__field(unsigned int, seqno)
-	),
-
-	TP_fast_assign(
-		__assign_str(driver);
-		__assign_str(timeline);
-		__entry->context = fence->context;
-		__entry->seqno = fence->seqno;
-	),
-
-	TP_printk("driver=%s timeline=%s context=%u seqno=%u",
-		  __get_str(driver), __get_str(timeline), __entry->context,
-		  __entry->seqno)
-);
-
 /*
  * Safe only for call sites which are guaranteed to not race with fence
  * signaling,holding the fence->lock and having checked for not signaled, or the
  * signaling path itself.
  */
-DECLARE_EVENT_CLASS(dma_fence_unsignaled,
+DECLARE_EVENT_CLASS(dma_fence,
 
 	TP_PROTO(struct dma_fence *fence),
 
@@ -64,14 +39,14 @@ DECLARE_EVENT_CLASS(dma_fence_unsignaled,
 		  __entry->seqno)
 );
 
-DEFINE_EVENT(dma_fence_unsignaled, dma_fence_emit,
+DEFINE_EVENT(dma_fence, dma_fence_emit,
 
 	TP_PROTO(struct dma_fence *fence),
 
 	TP_ARGS(fence)
 );
 
-DEFINE_EVENT(dma_fence_unsignaled, dma_fence_init,
+DEFINE_EVENT(dma_fence, dma_fence_init,
 
 	TP_PROTO(struct dma_fence *fence),
 
@@ -85,14 +60,14 @@ DEFINE_EVENT(dma_fence, dma_fence_destroy,
 	TP_ARGS(fence)
 );
 
-DEFINE_EVENT(dma_fence_unsignaled, dma_fence_enable_signal,
+DEFINE_EVENT(dma_fence, dma_fence_enable_signal,
 
 	TP_PROTO(struct dma_fence *fence),
 
 	TP_ARGS(fence)
 );
 
-DEFINE_EVENT(dma_fence_unsignaled, dma_fence_signaled,
+DEFINE_EVENT(dma_fence, dma_fence_signaled,
 
 	TP_PROTO(struct dma_fence *fence),
 
-- 
2.53.0



