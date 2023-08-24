Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221D4111A2
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 14:51:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99ECCC433C7;
	Thu, 24 Aug 2023 14:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692888719;
	bh=S7eWyoexnjSjdsMrNsfC0x+fHeG3kk13cPeigUe4818=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M7h+JoNZPk5y0Yfr0EqZzIigfQEhrZCgTeio3dHjmvNvSPP1k5/3PzPiwc/ipC4/+
	 5/fj7RJ74lmRYUvjnr3KUgTlke6Jn/eKkjHbH0dZKB+0uI8FZrIl1n4ulDIFg0E57p
	 X/CONaCy5lLuI4YWHnfDbXaqf/ixO3undU6fhoqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tariq Toukan <tariqt@nvidia.com>,
	Maxim Mikityanskiy <maximmi@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 006/139] net/tls: Perform immediate device ctx cleanup when possible
Date: Thu, 24 Aug 2023 16:48:49 +0200
Message-ID: <20230824145023.864815494@linuxfoundation.org>
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

[ Upstream commit 113671b255ee3b9f5585a6d496ef0e675e698698 ]

TLS context destructor can be run in atomic context. Cleanup operations
for device-offloaded contexts could require access and interaction with
the device callbacks, which might sleep. Hence, the cleanup of such
contexts must be deferred and completed inside an async work.

For all others, this is not necessary, as cleanup is atomic. Invoke
cleanup immediately for them, avoiding queueing redundant gc work.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 6b47808f223c ("net: tls: avoid discarding data on record close")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_device.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index cf75969375cfa..19ba57245777b 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -95,19 +95,29 @@ static void tls_device_gc_task(struct work_struct *work)
 static void tls_device_queue_ctx_destruction(struct tls_context *ctx)
 {
 	unsigned long flags;
+	bool async_cleanup;
 
 	spin_lock_irqsave(&tls_device_lock, flags);
-	if (unlikely(!refcount_dec_and_test(&ctx->refcount)))
-		goto unlock;
+	if (unlikely(!refcount_dec_and_test(&ctx->refcount))) {
+		spin_unlock_irqrestore(&tls_device_lock, flags);
+		return;
+	}
 
-	list_move_tail(&ctx->list, &tls_device_gc_list);
+	async_cleanup = ctx->netdev && ctx->tx_conf == TLS_HW;
+	if (async_cleanup) {
+		list_move_tail(&ctx->list, &tls_device_gc_list);
 
-	/* schedule_work inside the spinlock
-	 * to make sure tls_device_down waits for that work.
-	 */
-	schedule_work(&tls_device_gc_work);
-unlock:
+		/* schedule_work inside the spinlock
+		 * to make sure tls_device_down waits for that work.
+		 */
+		schedule_work(&tls_device_gc_work);
+	} else {
+		list_del(&ctx->list);
+	}
 	spin_unlock_irqrestore(&tls_device_lock, flags);
+
+	if (!async_cleanup)
+		tls_device_free_ctx(ctx);
 }
 
 /* We assume that the socket is already connected */
-- 
2.40.1



