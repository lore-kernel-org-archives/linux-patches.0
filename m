Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D323B2FCA;
	Sat, 12 Sep 2026 18:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238398; cv=none; b=HdHKa7e4DGKsBjRTdxkoXaotaGPlCK3jBEeIcG0fPzsOoLcBtepWriok7SV+UPx3llkyhoGlLHNvBYq4OdKYTpa+RRj1pBoeWaIhAYUhBcDgYdrPpweCDUfpOyHy9CSCbg23tXLTe6F3vQvQ45fLGTgbu7Uwu05T4M7O5Gj9/+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238398; c=relaxed/simple;
	bh=ReY2yjc5Ishz8irXJaudkooOxNXAB69GYYkJ0p+11uk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HGomiLKhckDDN0hT6Q9293toIgQNdkTeQ0i6A2qWDCuf1P20GxQJHwyJscLcT3fxzI0b6UN6xQKelQOuc+vIOYPpO3rHv7q8rYJX6OP18teg7ZCkWwoBBJuIfHADlUK8tK3uCGRshbISug5Bxasq6P4mRblNoSuWT+/9SwvMPhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pGxpuQ68; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pGxpuQ68"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AB091F00893;
	Sat, 12 Sep 2026 18:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238394;
	bh=ld2efpIZrSRQvrH1m7RPIZjxH7CxQxYoeMo9mqwrJc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pGxpuQ686FyT5jTnWffhx2UrRFWXxGprb9ZfvRnaJseQ7yFTImkGsRibbQWD/qPqY
	 w6bllFTdsA3t7Hiz1JDeCHOE+Hul6B+s9yMzuFdt55SOfbMPLs+uyiNPpoCrn1MsHe
	 mP0loun15KtWFpI4cqtVPGgMrSY0l1Upxkn78fxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 454/935] netdev: reshuffle netif_napi_add() APIs to allow dropping weight
Date: Sat, 12 Sep 2026 08:58:04 +0200
Message-ID: <20260912065537.240827366@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 58caed3dacb4354a25a1aa8d2febc3e9648ba1f4 ]

Most drivers should not have to worry about selecting the right
weight for their NAPI instances and pass NAPI_POLL_WEIGHT.
It'd be best if we didn't require the argument at all and selected
the default internally.

This change prepares the ground for such reshuffling, allowing
for a smooth transition. The following API should remain after
the next release cycle:
  netif_napi_add()
  netif_napi_add_weight()
  netif_napi_add_tx()
  netif_napi_add_tx_weight()
Where the _weight() variants take an explicit weight argument.
I opted for a _weight() suffix rather than a __ prefix, because
we use __ in places to mean that caller needs to also issue a
synchronize_net() call.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Link: https://lore.kernel.org/r/20220502232703.396351-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: c0a9a8586a63 ("staging: octeon: add missing napi_disable in cvm_oct_rx_shutdown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdevice.h | 50 ++++++++++++++++++++++++++-------------
 net/core/dev.c            |  6 ++---
 2 files changed, 36 insertions(+), 20 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index a08e187e056a0..5e5283487dc64 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2504,37 +2504,53 @@ static inline void *netdev_priv(const struct net_device *dev)
  */
 #define NAPI_POLL_WEIGHT 64
 
+void netif_napi_add_weight(struct net_device *dev, struct napi_struct *napi,
+			   int (*poll)(struct napi_struct *, int), int weight);
+
 /**
- *	netif_napi_add - initialize a NAPI context
- *	@dev:  network device
- *	@napi: NAPI context
- *	@poll: polling function
- *	@weight: default weight
+ * netif_napi_add() - initialize a NAPI context
+ * @dev:  network device
+ * @napi: NAPI context
+ * @poll: polling function
+ * @weight: default weight
  *
  * netif_napi_add() must be used to initialize a NAPI context prior to calling
  * *any* of the other NAPI-related functions.
  */
-void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
-		    int (*poll)(struct napi_struct *, int), int weight);
+static inline void
+netif_napi_add(struct net_device *dev, struct napi_struct *napi,
+	       int (*poll)(struct napi_struct *, int), int weight)
+{
+	netif_napi_add_weight(dev, napi, poll, weight);
+}
+
+static inline void
+netif_napi_add_tx_weight(struct net_device *dev,
+			 struct napi_struct *napi,
+			 int (*poll)(struct napi_struct *, int),
+			 int weight)
+{
+	set_bit(NAPI_STATE_NO_BUSY_POLL, &napi->state);
+	netif_napi_add_weight(dev, napi, poll, weight);
+}
+
+#define netif_tx_napi_add netif_napi_add_tx_weight
 
 /**
- *	netif_tx_napi_add - initialize a NAPI context
- *	@dev:  network device
- *	@napi: NAPI context
- *	@poll: polling function
- *	@weight: default weight
+ * netif_napi_add_tx() - initialize a NAPI context to be used for Tx only
+ * @dev:  network device
+ * @napi: NAPI context
+ * @poll: polling function
  *
  * This variant of netif_napi_add() should be used from drivers using NAPI
  * to exclusively poll a TX queue.
  * This will avoid we add it into napi_hash[], thus polluting this hash table.
  */
-static inline void netif_tx_napi_add(struct net_device *dev,
+static inline void netif_napi_add_tx(struct net_device *dev,
 				     struct napi_struct *napi,
-				     int (*poll)(struct napi_struct *, int),
-				     int weight)
+				     int (*poll)(struct napi_struct *, int))
 {
-	set_bit(NAPI_STATE_NO_BUSY_POLL, &napi->state);
-	netif_napi_add(dev, napi, poll, weight);
+	netif_napi_add_tx_weight(dev, napi, poll, NAPI_POLL_WEIGHT);
 }
 
 /**
diff --git a/net/core/dev.c b/net/core/dev.c
index 4aa21422e1d0a..8aac510303a68 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6975,8 +6975,8 @@ int dev_set_threaded(struct net_device *dev, bool threaded)
 }
 EXPORT_SYMBOL(dev_set_threaded);
 
-void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
-		    int (*poll)(struct napi_struct *, int), int weight)
+void netif_napi_add_weight(struct net_device *dev, struct napi_struct *napi,
+			   int (*poll)(struct napi_struct *, int), int weight)
 {
 	if (WARN_ON(test_and_set_bit(NAPI_STATE_LISTED, &napi->state)))
 		return;
@@ -7009,7 +7009,7 @@ void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
 	if (dev->threaded && napi_kthread_create(napi))
 		dev->threaded = 0;
 }
-EXPORT_SYMBOL(netif_napi_add);
+EXPORT_SYMBOL(netif_napi_add_weight);
 
 void napi_disable(struct napi_struct *n)
 {
-- 
2.53.0



