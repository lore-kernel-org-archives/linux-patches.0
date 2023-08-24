Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F8211701
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 14:52:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52764C433C8;
	Thu, 24 Aug 2023 14:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692888721;
	bh=VRN0+1MgvXpVMK+iqPvx2E0hyMCdkrgIOjCCHc8nGmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D30VsXgIh9Vd0E/HrFAZniewcG9bxqPv8G4krdGC2mBIjumvPi9GLTLOiaC7wEI4B
	 RH0DxVSO0TrN9ut6zY+1qclouH2UvZ3Ni2i/HR4Uzn10ErvZHOxnGpak/DDYAhtkZ+
	 Te8HC+mrP+maJwclJx/PMag5GrhaeTELa08loF5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tariq Toukan <tariqt@nvidia.com>,
	Maxim Mikityanskiy <maximmi@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 007/139] net/tls: Multi-threaded calls to TX tls_dev_del
Date: Thu, 24 Aug 2023 16:48:50 +0200
Message-ID: <20230824145023.915967084@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824145023.559380953@linuxfoundation.org>
References: <20230824145023.559380953@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tariq Toukan <tariqt@nvidia.com>

[ Upstream commit 7adc91e0c93901a0eeeea10665d0feb48ffde2d4 ]

Multiple TLS device-offloaded contexts can be added in parallel via
concurrent calls to .tls_dev_add, while calls to .tls_dev_del are
sequential in tls_device_gc_task.

This is not a sustainable behavior. This creates a rate gap between add
and del operations (addition rate outperforms the deletion rate).  When
running for enough time, the TLS device resources could get exhausted,
failing to offload new connections.

Replace the single-threaded garbage collector work with a per-context
alternative, so they can be handled on several cores in parallel. Use
a new dedicated destruct workqueue for this.

Tested with mlx5 device:
Before: 22141 add/sec,   103 del/sec
After:  11684 add/sec, 11684 del/sec

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 6b47808f223c ("net: tls: avoid discarding data on record close")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tls.h    |  2 ++
 net/tls/tls_device.c | 63 ++++++++++++++++++++++----------------------
 2 files changed, 33 insertions(+), 32 deletions(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index bf3d63a527885..eda0015c5c592 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -179,6 +179,8 @@ struct tls_offload_context_tx {
 
 	struct scatterlist sg_tx_data[MAX_SKB_FRAGS];
 	void (*sk_destruct)(struct sock *sk);
+	struct work_struct destruct_work;
+	struct tls_context *ctx;
 	u8 driver_state[] __aligned(8);
 	/* The TLS layer reserves room for driver specific state
 	 * Currently the belief is that there is not enough
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 19ba57245777b..8012bd86437c9 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -45,10 +45,8 @@
  */
 static DECLARE_RWSEM(device_offload_lock);
 
-static void tls_device_gc_task(struct work_struct *work);
+static struct workqueue_struct *destruct_wq __read_mostly;
 
-static DECLARE_WORK(tls_device_gc_work, tls_device_gc_task);
-static LIST_HEAD(tls_device_gc_list);
 static LIST_HEAD(tls_device_list);
 static LIST_HEAD(tls_device_down_list);
 static DEFINE_SPINLOCK(tls_device_lock);
@@ -67,29 +65,17 @@ static void tls_device_free_ctx(struct tls_context *ctx)
 	tls_ctx_free(NULL, ctx);
 }
 
-static void tls_device_gc_task(struct work_struct *work)
+static void tls_device_tx_del_task(struct work_struct *work)
 {
-	struct tls_context *ctx, *tmp;
-	unsigned long flags;
-	LIST_HEAD(gc_list);
-
-	spin_lock_irqsave(&tls_device_lock, flags);
-	list_splice_init(&tls_device_gc_list, &gc_list);
-	spin_unlock_irqrestore(&tls_device_lock, flags);
-
-	list_for_each_entry_safe(ctx, tmp, &gc_list, list) {
-		struct net_device *netdev = ctx->netdev;
+	struct tls_offload_context_tx *offload_ctx =
+		container_of(work, struct tls_offload_context_tx, destruct_work);
+	struct tls_context *ctx = offload_ctx->ctx;
+	struct net_device *netdev = ctx->netdev;
 
-		if (netdev && ctx->tx_conf == TLS_HW) {
-			netdev->tlsdev_ops->tls_dev_del(netdev, ctx,
-							TLS_OFFLOAD_CTX_DIR_TX);
-			dev_put(netdev);
-			ctx->netdev = NULL;
-		}
-
-		list_del(&ctx->list);
-		tls_device_free_ctx(ctx);
-	}
+	netdev->tlsdev_ops->tls_dev_del(netdev, ctx, TLS_OFFLOAD_CTX_DIR_TX);
+	dev_put(netdev);
+	ctx->netdev = NULL;
+	tls_device_free_ctx(ctx);
 }
 
 static void tls_device_queue_ctx_destruction(struct tls_context *ctx)
@@ -103,16 +89,15 @@ static void tls_device_queue_ctx_destruction(struct tls_context *ctx)
 		return;
 	}
 
+	list_del(&ctx->list); /* Remove from tls_device_list / tls_device_down_list */
 	async_cleanup = ctx->netdev && ctx->tx_conf == TLS_HW;
 	if (async_cleanup) {
-		list_move_tail(&ctx->list, &tls_device_gc_list);
+		struct tls_offload_context_tx *offload_ctx = tls_offload_ctx_tx(ctx);
 
-		/* schedule_work inside the spinlock
+		/* queue_work inside the spinlock
 		 * to make sure tls_device_down waits for that work.
 		 */
-		schedule_work(&tls_device_gc_work);
-	} else {
-		list_del(&ctx->list);
+		queue_work(destruct_wq, &offload_ctx->destruct_work);
 	}
 	spin_unlock_irqrestore(&tls_device_lock, flags);
 
@@ -1115,6 +1100,9 @@ int tls_set_device_offload(struct sock *sk, struct tls_context *ctx)
 	start_marker_record->len = 0;
 	start_marker_record->num_frags = 0;
 
+	INIT_WORK(&offload_ctx->destruct_work, tls_device_tx_del_task);
+	offload_ctx->ctx = ctx;
+
 	INIT_LIST_HEAD(&offload_ctx->records_list);
 	list_add_tail(&start_marker_record->list, &offload_ctx->records_list);
 	spin_lock_init(&offload_ctx->lock);
@@ -1372,7 +1360,7 @@ static int tls_device_down(struct net_device *netdev)
 
 	up_write(&device_offload_lock);
 
-	flush_work(&tls_device_gc_work);
+	flush_workqueue(destruct_wq);
 
 	return NOTIFY_DONE;
 }
@@ -1413,12 +1401,23 @@ static struct notifier_block tls_dev_notifier = {
 
 int __init tls_device_init(void)
 {
-	return register_netdevice_notifier(&tls_dev_notifier);
+	int err;
+
+	destruct_wq = alloc_workqueue("ktls_device_destruct", 0, 0);
+	if (!destruct_wq)
+		return -ENOMEM;
+
+	err = register_netdevice_notifier(&tls_dev_notifier);
+	if (err)
+		destroy_workqueue(destruct_wq);
+
+	return err;
 }
 
 void __exit tls_device_cleanup(void)
 {
 	unregister_netdevice_notifier(&tls_dev_notifier);
-	flush_work(&tls_device_gc_work);
+	flush_workqueue(destruct_wq);
+	destroy_workqueue(destruct_wq);
 	clean_acked_data_flush();
 }
-- 
2.40.1



