Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F5D3BE156;
	Tue, 21 Jul 2026 21:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669586; cv=none; b=mtTDYXc9+4fi0piBnE6uGWx+JozPxExjrKGdCCQWN+HgY4E5alyBdQPXpEuflFt10aQuA6DJU4yh62UHElEhgcvc4s3yjDz3wW2CesWIViUwxp5Bg3aZMEFfAdTqbKue/ZkR9e4jsqg7WR/aE+v98RoAKD4K/7d0/rT2/95YMYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669586; c=relaxed/simple;
	bh=wgQBUsUBg6sc7laE0a2NYEmes3PkDgXTbYWab6ly9Wo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RXuSRyaYhU6FPXLHd5OW3EYYQsiF5htEC7vGDfMbu8iU8HjLDqtPu/8PZKJkF4UXYey6UiB86AeAvhamVz1SYpAARYWB0wcHJXlPlfHK+3s3fOa78tqzcxEPSa4Ze4yS9NkTwlA5ZD6VDgpL+wYFVHBbeRe7NT5C9J2Y3bYakq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qnAeS2On; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qnAeS2On"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BAC11F000E9;
	Tue, 21 Jul 2026 21:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669584;
	bh=rKbgV+dI/URbncWOmjgbZTlxbK3lOPiwfi8a9nTnLXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qnAeS2OnWomE9oAWIh3Q9ItevRwOXj4PeE3bQcUZtl1tvhro1AE09HJzl8qrYCjyI
	 g1pujyVbL9kYHO8NimJSpyJhRHcRYCqLDgu95Oygn/FVoiTClcylwfgbgWhhH1Yct6
	 t6A3I5K7qpidBGT5vMynayknUWOg3A3AdFLK8mcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raed Salem <raeds@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0567/1067] xfrm: add new packet offload flag
Date: Tue, 21 Jul 2026 17:19:28 +0200
Message-ID: <20260721152437.287472658@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit d14f28b8c1de668bab863bf5892a49c824cb110d ]

In the next patches, the xfrm core code will be extended to support
new type of offload - packet offload. In that mode, both policy and state
should be specially configured in order to perform whole offloaded data
path.

Full offload takes care of encryption, decryption, encapsulation and
other operations with headers.

As this mode is new for XFRM policy flow, we can "start fresh" with flag
bits and release first and second bit for future use.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Stable-dep-of: 68de007d5ac9 ("xfrm: annotate data-races around xfrm_policy_count[] and xfrm_policy_default[]")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xfrm.h        | 7 +++++++
 include/uapi/linux/xfrm.h | 6 ++++++
 net/xfrm/xfrm_device.c    | 3 +++
 net/xfrm/xfrm_user.c      | 2 ++
 4 files changed, 18 insertions(+)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index e36a63f5ae069e..dfae35ff762542 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -131,12 +131,19 @@ enum {
 	XFRM_DEV_OFFLOAD_OUT,
 };
 
+enum {
+	XFRM_DEV_OFFLOAD_UNSPECIFIED,
+	XFRM_DEV_OFFLOAD_CRYPTO,
+	XFRM_DEV_OFFLOAD_PACKET,
+};
+
 struct xfrm_dev_offload {
 	struct net_device	*dev;
 	netdevice_tracker	dev_tracker;
 	struct net_device	*real_dev;
 	unsigned long		offload_handle;
 	u8			dir : 2;
+	u8			type : 2;
 };
 
 struct xfrm_mode {
diff --git a/include/uapi/linux/xfrm.h b/include/uapi/linux/xfrm.h
index 4f84ea7ee14c90..23543c33fee823 100644
--- a/include/uapi/linux/xfrm.h
+++ b/include/uapi/linux/xfrm.h
@@ -519,6 +519,12 @@ struct xfrm_user_offload {
  */
 #define XFRM_OFFLOAD_IPV6	1
 #define XFRM_OFFLOAD_INBOUND	2
+/* Two bits above are relevant for state path only, while
+ * offload is used for both policy and state flows.
+ *
+ * In policy offload mode, they are free and can be safely reused.
+ */
+#define XFRM_OFFLOAD_PACKET	4
 
 struct xfrm_userpolicy_default {
 #define XFRM_USERPOLICY_UNSPEC	0
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 2535ee034a5c83..313c0eb3381f37 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -296,12 +296,15 @@ int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
 	else
 		xso->dir = XFRM_DEV_OFFLOAD_OUT;
 
+	xso->type = XFRM_DEV_OFFLOAD_CRYPTO;
+
 	err = dev->xfrmdev_ops->xdo_dev_state_add(x);
 	if (err) {
 		xso->dev = NULL;
 		xso->dir = 0;
 		xso->real_dev = NULL;
 		netdev_put(dev, &xso->dev_tracker);
+		xso->type = XFRM_DEV_OFFLOAD_UNSPECIFIED;
 
 		if (err != -EOPNOTSUPP) {
 			NL_SET_ERR_MSG(extack, "Device failed to offload this state");
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index d77511d7e832b4..2a6afca79bd3a7 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -947,6 +947,8 @@ static int copy_user_offload(struct xfrm_dev_offload *xso, struct sk_buff *skb)
 	xuo->ifindex = xso->dev->ifindex;
 	if (xso->dir == XFRM_DEV_OFFLOAD_IN)
 		xuo->flags = XFRM_OFFLOAD_INBOUND;
+	if (xso->type == XFRM_DEV_OFFLOAD_PACKET)
+		xuo->flags |= XFRM_OFFLOAD_PACKET;
 
 	return 0;
 }
-- 
2.53.0



