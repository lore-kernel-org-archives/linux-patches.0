Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13D23D34A6;
	Thu, 15 Jan 2026 17:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499994; cv=none; b=XGNhu0We9iNAEiIhbV7pvC7SxV1TbcjZu/lzi72NOVYNIWrC9nquXgAsacmg52WBv3JoKfZ4dcfkJzfA9ljRhVsG9Jaodn9ks7GQ9WxX5aKiSTuZJHW4061zMsBmTAq077IrGMY6stYYmX2kmjqlv5xq0ITWnn03k9CnjCpQFf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499994; c=relaxed/simple;
	bh=X3yx9f+/inpWTK/Bzvq3eSGjPIb2KjBs66r8Wg/C7wM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bRVof+M0VnmLH1RQ5B35iPo7Uy8RPjeqrTwaQ0cgAALX3qOewVRdSlpqwXEHbmayLNGxYb1KE77SH4P8ujl3EHGze3U87UGZ8OCadEJNFDjtz4RITBsLtKetWe0+cY0fssVWI4uELKGgcfM/t97kVSG+r9bU6g30VITddv2k/aM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RioEn5yS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RioEn5yS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1C32C116D0;
	Thu, 15 Jan 2026 17:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499994;
	bh=X3yx9f+/inpWTK/Bzvq3eSGjPIb2KjBs66r8Wg/C7wM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RioEn5ySLNpPvfHxkb1I79oiOK1N8vkoXKJwtQK3wAKQhWLdVdh6wgMyUmkTBcfo7
	 M6UYTHYJEUB3n2yliICD/rUFRHf3+fEEa5+J0/1io7hJ1Fk3zlf58RfitKP/nuZ21m
	 tNWSAaSNnklCgZm/4DN0SuHvOt1pvx12570BYKlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tariq Toukan <tariqt@nvidia.com>,
	Boris Pismenny <borisp@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Keerthana K <keerthana.kalyanasundaram@broadcom.com>
Subject: [PATCH 5.10 422/451] net: netdevice: Add operation ndo_sk_get_lower_dev
Date: Thu, 15 Jan 2026 17:50:23 +0100
Message-ID: <20260115164246.205553475@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tariq Toukan <tariqt@nvidia.com>

[ Upstream commit 719a402cf60311b1cdff3f6320abaecdcc5e46b7]

ndo_sk_get_lower_dev returns the lower netdev that corresponds to
a given socket.
Additionally, we implement a helper netdev_sk_get_lowest_dev() to get
the lowest one in chain.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Boris Pismenny <borisp@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Keerthana: Backported the patch to v5.10.y ]
Signed-off-by: Keerthana K <keerthana.kalyanasundaram@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/netdevice.h |    4 ++++
 net/core/dev.c            |   33 +++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1435,6 +1435,8 @@ struct net_device_ops {
 	struct net_device*	(*ndo_get_xmit_slave)(struct net_device *dev,
 						      struct sk_buff *skb,
 						      bool all_slaves);
+	struct net_device*	(*ndo_sk_get_lower_dev)(struct net_device *dev,
+							struct sock *sk);
 	netdev_features_t	(*ndo_fix_features)(struct net_device *dev,
 						    netdev_features_t features);
 	int			(*ndo_set_features)(struct net_device *dev,
@@ -2914,6 +2916,8 @@ int init_dummy_netdev(struct net_device
 struct net_device *netdev_get_xmit_slave(struct net_device *dev,
 					 struct sk_buff *skb,
 					 bool all_slaves);
+struct net_device *netdev_sk_get_lowest_dev(struct net_device *dev,
+					    struct sock *sk);
 struct net_device *dev_get_by_index(struct net *net, int ifindex);
 struct net_device *__dev_get_by_index(struct net *net, int ifindex);
 struct net_device *dev_get_by_index_rcu(struct net *net, int ifindex);
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8169,6 +8169,39 @@ struct net_device *netdev_get_xmit_slave
 }
 EXPORT_SYMBOL(netdev_get_xmit_slave);
 
+static struct net_device *netdev_sk_get_lower_dev(struct net_device *dev,
+						  struct sock *sk)
+{
+	const struct net_device_ops *ops = dev->netdev_ops;
+
+	if (!ops->ndo_sk_get_lower_dev)
+		return NULL;
+	return ops->ndo_sk_get_lower_dev(dev, sk);
+}
+
+/**
+ * netdev_sk_get_lowest_dev - Get the lowest device in chain given device and socket
+ * @dev: device
+ * @sk: the socket
+ *
+ * %NULL is returned if no lower device is found.
+ */
+
+struct net_device *netdev_sk_get_lowest_dev(struct net_device *dev,
+					    struct sock *sk)
+{
+	struct net_device *lower;
+
+	lower = netdev_sk_get_lower_dev(dev, sk);
+	while (lower) {
+		dev = lower;
+		lower = netdev_sk_get_lower_dev(dev, sk);
+	}
+
+	return dev;
+}
+EXPORT_SYMBOL(netdev_sk_get_lowest_dev);
+
 static void netdev_adjacent_add_links(struct net_device *dev)
 {
 	struct netdev_adjacent *iter;


