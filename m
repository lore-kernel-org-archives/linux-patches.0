Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B36E352ED2F;
	Wed, 23 Sep 2026 14:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173315; cv=none; b=Bug0Jc6La6AtvRykisM+pDAt5XTyCnmV11zaxFn9ifyFpwJ7QV3JoBkWJjlCiTwX2UBTTx2z46dIZTWsRh/oUukzy+Bz1In64RgGu3WwPQrb6r5t9J8+O7p2dBSQ4pBO1ABHml6QsqariBSFxSnJ+2EFLOuSUE02LnKdlliV858=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173315; c=relaxed/simple;
	bh=5K81c/Moi/NBkUwxnKgxspi4RzeoK7BkAImSWSm7aFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FlK20RdC5jZ+fNfokzgx6qBQG5DcOwoEBR1q12NidTr4dgzAFT4riGov+DEg0Gx+rh3zuV9BngD2lpoED01cRCM8F2Zy5qPtkokfwDaiEUnNwCOsNG6UsL7rLFb3wykt4MXEsD6VkjjAegHlbc0ZAaiXpP+YheAt5WwESQwXP+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i9XyPZ6w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i9XyPZ6w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B59E81F000FF;
	Wed, 23 Sep 2026 14:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173313;
	bh=5OMurgFa3oCGtiz7YCQRWxiAhf+KmwEOhG5HyXGjEYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i9XyPZ6wj4Uen4hUnJUDFL8CQ+IO2HLjerKVm5EZ6l3QXkf+64tAMN5g2WpQyBe7Y
	 X1oW+l4JBowLSuj4yT5ndkh5i1qCq3fkRXTu6lrmgA/P5D6ezqzBvb6aT8Up2XLuGs
	 aWgzo1xVpw3bXkoDh+hVIsttHG4xe9ikK5zmeDqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 207/438] net: pass dst via net_device_path in dev_fill_forward_path()
Date: Wed, 23 Sep 2026 16:03:48 +0200
Message-ID: <20260923140650.128956932@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 0ad8404e776698de4dac5cc0df3be68d344e741c ]

Add dst_entry to tunnel device path, this will allow us to remove
a duplicated route lookup.

This is a preparation patch to retrieve the tunnel route directly
from the .fill_forward_path. This new dst_entry in the tunnel will be
used by a follow up patch.

Since dst_release() works fine on NULL interface, this is still
noop until the flowtable starts using this.

Add a new dev_fill_forward_path_release() function to drop the refcount
on the tunnel device route and use it in case of error out. Export it so
to drop the refcount on the tunnel route at a later stage.

Adjust existing drivers that recycle dev_fill_forward_path() to call
dev_fill_forward_path_release() for safety reasons.

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 150dba2c69e9 ("net: remove WARN_ON_ONCE() from the dev_fill_forward_path() loop check")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_ppe.c      | 10 ++++--
 .../net/ethernet/mediatek/mtk_ppe_offload.c   | 10 ++++--
 include/linux/netdevice.h                     |  2 ++
 net/core/dev.c                                | 36 ++++++++++++++++---
 4 files changed, 47 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/airoha/airoha_ppe.c b/drivers/net/ethernet/airoha/airoha_ppe.c
index f6396925722d0..c8fd95e800937 100644
--- a/drivers/net/ethernet/airoha/airoha_ppe.c
+++ b/drivers/net/ethernet/airoha/airoha_ppe.c
@@ -293,14 +293,18 @@ static int airoha_ppe_get_wdma_info(struct net_device *dev, const u8 *addr,
 		return err;
 
 	path = &stack.path[stack.num_paths - 1];
-	if (path->type != DEV_PATH_MTK_WDMA)
-		return -EINVAL;
+	if (path->type != DEV_PATH_MTK_WDMA) {
+		err = -EINVAL;
+		goto err_out;
+	}
 
 	info->idx = path->mtk_wdma.wdma_idx;
 	info->bss = path->mtk_wdma.bss;
 	info->wcid = path->mtk_wdma.wcid;
+err_out:
+	dev_fill_forward_path_release(&stack);
 
-	return 0;
+	return err;
 }
 
 static int airoha_get_dsa_port(struct net_device **dev)
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
index cc8c4ef8038f3..771d9118f94ad 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
@@ -108,16 +108,20 @@ mtk_flow_get_wdma_info(struct net_device *dev, const u8 *addr, struct mtk_wdma_i
 		return err;
 
 	path = &stack.path[stack.num_paths - 1];
-	if (path->type != DEV_PATH_MTK_WDMA)
-		return -1;
+	if (path->type != DEV_PATH_MTK_WDMA) {
+		err = -EINVAL;
+		goto err_out;
+	}
 
 	info->wdma_idx = path->mtk_wdma.wdma_idx;
 	info->queue = path->mtk_wdma.queue;
 	info->bss = path->mtk_wdma.bss;
 	info->wcid = path->mtk_wdma.wcid;
 	info->amsdu = path->mtk_wdma.amsdu;
+err_out:
+	dev_fill_forward_path_release(&stack);
 
-	return 0;
+	return err;
 }
 
 
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 8840b126979ff..d325027b03705 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -894,6 +894,7 @@ struct net_device_path {
 			u8		h_dest[ETH_ALEN];
 		} encap;
 		struct {
+			struct dst_entry *dst;
 			union {
 				struct in_addr	src_v4;
 				struct in6_addr	src_v6;
@@ -3424,6 +3425,7 @@ int dev_get_iflink(const struct net_device *dev);
 int dev_fill_metadata_dst(struct net_device *dev, struct sk_buff *skb);
 int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
 			  struct net_device_path_stack *stack);
+void dev_fill_forward_path_release(struct net_device_path_stack *stack);
 struct net_device *dev_get_by_name(struct net *net, const char *name);
 struct net_device *dev_get_by_name_rcu(struct net *net, const char *name);
 struct net_device *__dev_get_by_name(struct net *net, const char *name);
diff --git a/net/core/dev.c b/net/core/dev.c
index e68463e7310a0..2b493f4c2f0cb 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -748,6 +748,27 @@ static struct net_device_path *dev_fwd_path(struct net_device_path_stack *stack)
 	return &stack->path[stack->num_paths];
 }
 
+void dev_fill_forward_path_release(struct net_device_path_stack *stack)
+{
+	struct net_device_path *path;
+	int k;
+
+	if (stack->num_paths == 0)
+		return;
+
+	for (k = stack->num_paths - 1; k >= 0; k--) {
+		path = &stack->path[k];
+		switch (path->type) {
+		case DEV_PATH_TUN:
+			dst_release(path->tun.dst);
+			break;
+		default:
+			break;
+		}
+	}
+}
+EXPORT_SYMBOL_GPL(dev_fill_forward_path_release);
+
 int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
 			  struct net_device_path_stack *stack)
 {
@@ -764,16 +785,16 @@ int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
 		last_dev = ctx.dev;
 		path = dev_fwd_path(stack);
 		if (!path)
-			return -1;
+			goto err_out;
 
 		memset(path, 0, sizeof(struct net_device_path));
 		ret = ctx.dev->netdev_ops->ndo_fill_forward_path(&ctx, path);
 		if (ret < 0)
-			return -1;
+			goto err_out;
 
 		stack->num_paths++;
 		if (WARN_ON_ONCE(last_dev == ctx.dev))
-			return -1;
+			goto err_out;
 	}
 
 	if (!ctx.dev)
@@ -781,12 +802,17 @@ int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
 
 	path = dev_fwd_path(stack);
 	if (!path)
-		return -1;
+		goto err_out;
+
 	path->type = DEV_PATH_ETHERNET;
 	path->dev = ctx.dev;
 	stack->num_paths++;
 
-	return ret;
+	return 0;
+err_out:
+	dev_fill_forward_path_release(stack);
+
+	return -1;
 }
 EXPORT_SYMBOL_GPL(dev_fill_forward_path);
 
-- 
2.53.0



