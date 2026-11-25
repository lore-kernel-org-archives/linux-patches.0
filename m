Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622597;
	b=z9ELWKV/Ep1qlgJROEbHlxZOIjpLNn2EzNtiWl5PjNBOmP+LOumC3ChJJSvBeX7opzxv
	 ONH04dfuTDIPvGMlLiJttrYgdq9x4yWVfliTQP2H1pyT8guSRKLY7i/DAnkH+yrp6Qh12
	 7veRzqTAJFLRBy3cMGl6ljnRtgdCHwwus+Gxv/+m3+KY4H04wbbV/FWV2QPXEyohFTV60
	 XosBBRPA4cbGdBCjLLFfTm0ThS5g1sv+08arIuDCH8ns+iK3AQjitg/Cbh8pul1o6Jfo1
	 JHI/SsrCtpX/1PSaj4XO26qT0V5gvlEfRpoo+5HoSdxiMmou10X55FyaMpEVmhJjMeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622597;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=edhWjIWqZFcS0+NQxsc/hwcwVddW6ROj1QQK3gHSzXA=;
	b=oUgO+OkZNlJuLsZ7QybS4DWhCqORCErJPLaHAqdqcjXv4bEHXWGP7QP8P9QUg95I1qFj
	 oPaSU6ggbRsIX+aTiZ8fTs6+HKtQXOKbjsdvVHPJHrLT2YjneqRlP7zWgrpd+HzPJ701I
	 PWKhFLhfJeAP7pLx/XHL3E3hdPE/+FWU0reUrGWP2vO6GRWLb8xrM0oLAyhbxQhCaezhx
	 lLDs/cjQPd9GZwow426efwL7zuXpEYN3SCxdN24I1v7iaDCvjv8SNvjRmjR445V0yBhl3
	 0u+A++5LZFcTqFSFcAtBF+IgCsu/rxIoHF/8quYKSXvlQ57OrYOaQnQOmWP8247rOQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WZGCeH4U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4272F606A321;
	Wed, 25 Nov 2026 16:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WZGCeH4U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6313D1F000CA;
	Wed, 25 Nov 2026 16:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622596;
	bh=edhWjIWqZFcS0+NQxsc/hwcwVddW6ROj1QQK3gHSzXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WZGCeH4Uu2YtrvoVcE6lFNaSazlxiUmatAXIxRXUmjZKtFDrSWc+OwijHEsOnS4l1
	 vw0bNH1bQ2ouW7pE5cn2HekmqIYM74Ldd0h5q9qN/QncCVPGTwTiiYwaYA+ilvGTE9
	 yDKeS+lk5dvVHeixsfTF3m9t1v3Pc2QO0uhQvqJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaifeng Wang <kaifengw@google.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Bobby Eshleman <bobbyeshleman@meta.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 586/990] net: devmem: check uid and netns in net_devmem_get_binding()
Date: Wed, 25 Nov 2026 15:32:33 +0100
Message-ID: <20261125143835.818025786@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kaifeng Wang <kaifengw@google.com>

[ Upstream commit 3a82195416fd71fdd6cb4ff80f611ec28073be16 ]

NETDEV_CMD_BIND_TX is unprivileged, and dmabuf binding IDs are allocated
from a single global xarray. Currently net_devmem_get_binding() looks up
the binding by ID without checking whether the sending socket belongs to
the same user or network namespace that created the binding.

Record the creating netlink socket's network namespace and UID on the
binding, and verify both in net_devmem_get_binding() before checking the
route destination device. Return -EINVAL on mismatch so callers cannot
distinguish non-existent IDs from bindings owned by other users.

Fixes: bd61848900bf ("net: devmem: Implement TX path")
Signed-off-by: Kaifeng Wang <kaifengw@google.com>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Reviewed-by: Bobby Eshleman <bobbyeshleman@meta.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[ sashal: Kept this branch's simpler net_devmem_bind_dmabuf() signature, adding nl_sk without the vdev/niov_shift parameters or the netkit bind-device logic, and adjusted the struct hunk context. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/devmem.c      | 7 ++++++-
 net/core/devmem.h      | 5 +++++
 net/core/netdev-genl.c | 6 ++++--
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/net/core/devmem.c b/net/core/devmem.c
index 16ce197cb0faf..9b937d426cb9a 100644
--- a/net/core/devmem.c
+++ b/net/core/devmem.c
@@ -180,6 +180,7 @@ net_devmem_bind_dmabuf(struct net_device *dev,
 		       struct device *dma_dev,
 		       enum dma_data_direction direction,
 		       unsigned int dmabuf_fd, struct netdev_nl_sock *priv,
+		       const struct sock *nl_sk,
 		       struct netlink_ext_ack *extack)
 {
 	struct net_devmem_dmabuf_binding *binding;
@@ -207,6 +208,8 @@ net_devmem_bind_dmabuf(struct net_device *dev,
 	}
 
 	binding->dev = dev;
+	write_pnet(&binding->net, sock_net(nl_sk));
+	binding->uid = sk_uid(nl_sk);
 	xa_init_flags(&binding->bound_rxqs, XA_FLAGS_ALLOC);
 
 	refcount_set(&binding->ref, 1);
@@ -374,7 +377,9 @@ struct net_devmem_dmabuf_binding *net_devmem_get_binding(struct sock *sk,
 	int err = 0;
 
 	binding = net_devmem_lookup_dmabuf(dmabuf_id);
-	if (!binding || !binding->tx_vec) {
+	if (!binding || !binding->tx_vec ||
+	    !net_eq(sock_net(sk), read_pnet(&binding->net)) ||
+	    !uid_eq(sk_uid(sk), binding->uid)) {
 		err = -EINVAL;
 		goto out_err;
 	}
diff --git a/net/core/devmem.h b/net/core/devmem.h
index 101150d761af2..674279180dc8d 100644
--- a/net/core/devmem.h
+++ b/net/core/devmem.h
@@ -10,6 +10,7 @@
 #ifndef _NET_DEVMEM_H
 #define _NET_DEVMEM_H
 
+#include <net/net_namespace.h>
 #include <net/netmem.h>
 #include <net/netdev_netlink.h>
 
@@ -21,6 +22,8 @@ struct net_devmem_dmabuf_binding {
 	struct sg_table *sgt;
 	struct net_device *dev;
 	struct gen_pool *chunk_pool;
+	possible_net_t net;
+	kuid_t uid;
 	/* Protect dev */
 	struct mutex lock;
 
@@ -88,6 +91,7 @@ net_devmem_bind_dmabuf(struct net_device *dev,
 		       struct device *dma_dev,
 		       enum dma_data_direction direction,
 		       unsigned int dmabuf_fd, struct netdev_nl_sock *priv,
+		       const struct sock *nl_sk,
 		       struct netlink_ext_ack *extack);
 struct net_devmem_dmabuf_binding *net_devmem_lookup_dmabuf(u32 id);
 void net_devmem_unbind_dmabuf(struct net_devmem_dmabuf_binding *binding);
@@ -175,6 +179,7 @@ net_devmem_bind_dmabuf(struct net_device *dev,
 		       enum dma_data_direction direction,
 		       unsigned int dmabuf_fd,
 		       struct netdev_nl_sock *priv,
+		       const struct sock *nl_sk,
 		       struct netlink_ext_ack *extack)
 {
 	return ERR_PTR(-EOPNOTSUPP);
diff --git a/net/core/netdev-genl.c b/net/core/netdev-genl.c
index 77042ac6d0428..d42e4c4d7a7d3 100644
--- a/net/core/netdev-genl.c
+++ b/net/core/netdev-genl.c
@@ -1004,7 +1004,8 @@ int netdev_nl_bind_rx_doit(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	binding = net_devmem_bind_dmabuf(netdev, dma_dev, DMA_FROM_DEVICE,
-					 dmabuf_fd, priv, info->extack);
+					 dmabuf_fd, priv, NETLINK_CB(skb).sk,
+					 info->extack);
 	if (IS_ERR(binding)) {
 		err = PTR_ERR(binding);
 		goto err_rxq_bitmap;
@@ -1097,7 +1098,8 @@ int netdev_nl_bind_tx_doit(struct sk_buff *skb, struct genl_info *info)
 
 	dma_dev = netdev_queue_get_dma_dev(netdev, 0);
 	binding = net_devmem_bind_dmabuf(netdev, dma_dev, DMA_TO_DEVICE,
-					 dmabuf_fd, priv, info->extack);
+					 dmabuf_fd, priv, NETLINK_CB(skb).sk,
+					 info->extack);
 	if (IS_ERR(binding)) {
 		err = PTR_ERR(binding);
 		goto err_unlock_netdev;
-- 
2.53.0



