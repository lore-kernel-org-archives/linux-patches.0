Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A23D31E0F0;
	Mon, 27 Oct 2025 19:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591635; cv=none; b=lBG4c4xeBqJPTWapojYn0OoZoPF0MOwQFBqRVKViT1x3HGqLpnvxa6rhVOv6AS3FsQc7yDe2S/cT3F0bmgvjeYCIaCpYwTp4A/IWZYV+iNtz3cYPGJXVkH4d0zRdQIokHt8/r7Vn9NpDx3qu8XEG/4mSSyGMNdmMkdZSlMrrtKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591635; c=relaxed/simple;
	bh=aelxr1Om+kGoBE3fW3y9pviYPAEN0iLwBS/KUWCfMcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iz9ma6UWyH04u/5YjtOUEHu8hZTrLt8EXvta4VO5ldOyZug8ESHAlYUwPn7qdFSUTa3u5M5yALkza2aTV0KFQQzIuhjFk3bA8iNbzxIfCo6HkEqyuM6RMWxq3AJGmaBUMZBTNTRKWyl/qHCDquArlZ8hijjVHJwh7EC6xe7Y//k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EaraZPVn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EaraZPVn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F5FCC4CEF1;
	Mon, 27 Oct 2025 19:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591635;
	bh=aelxr1Om+kGoBE3fW3y9pviYPAEN0iLwBS/KUWCfMcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EaraZPVn4CVRPcoX6ulOSpW3E9EGAUhHm0LyvO/z+bca6549o0k9+a9024ZJ/fLa3
	 aDs5pDDMYmm3qdEwREWA9SptKDHjRVDC4HXJEqXc98iNC26626GOzPOQTvNEcgWzJd
	 e+RDBCFM3tPS8uqi+JnEWrI6CFPsioLdvLh2i7c8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 273/332] net: add ndo_fdb_del_bulk
Date: Mon, 27 Oct 2025 19:35:26 +0100
Message-ID: <20251027183532.072248828@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

From: Nikolay Aleksandrov <razor@blackwall.org>

[ Upstream commit 1306d5362a591493a2d07f685ed2cc480dcda320 ]

Add a new netdev op called ndo_fdb_del_bulk, it will be later used for
driver-specific bulk delete implementation dispatched from rtnetlink. The
first user will be the bridge, we need it to signal to rtnetlink from
the driver that we support bulk delete operation (NLM_F_BULK).

Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: bf29555f5bdc ("rtnetlink: Allow deleting FDB entries in user namespace")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdevice.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 06b37f45b67c9..d3a3e77a18df1 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1200,6 +1200,10 @@ struct netdev_net_notifier {
  *		      struct net_device *dev,
  *		      const unsigned char *addr, u16 vid)
  *	Deletes the FDB entry from dev coresponding to addr.
+ * int (*ndo_fdb_del_bulk)(struct ndmsg *ndm, struct nlattr *tb[],
+ *			   struct net_device *dev,
+ *			   u16 vid,
+ *			   struct netlink_ext_ack *extack);
  * int (*ndo_fdb_dump)(struct sk_buff *skb, struct netlink_callback *cb,
  *		       struct net_device *dev, struct net_device *filter_dev,
  *		       int *idx)
@@ -1452,6 +1456,11 @@ struct net_device_ops {
 					       struct net_device *dev,
 					       const unsigned char *addr,
 					       u16 vid);
+	int			(*ndo_fdb_del_bulk)(struct ndmsg *ndm,
+						    struct nlattr *tb[],
+						    struct net_device *dev,
+						    u16 vid,
+						    struct netlink_ext_ack *extack);
 	int			(*ndo_fdb_dump)(struct sk_buff *skb,
 						struct netlink_callback *cb,
 						struct net_device *dev,
-- 
2.51.0



