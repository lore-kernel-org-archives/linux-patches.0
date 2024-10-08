Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96AE1DEFF0;
	Tue,  8 Oct 2024 12:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391506; cv=none; b=RWi8D9OowralPTMDvIQWEVjQ9qs9kKWCC/0agPG/xmwm+08RFTAqp+zY/nuFkaVRNo8wq4u4QTDVlM6mnfylYhB6Ja+jv/c4wPuvLF7wmdon4Pg3H9V/63jSwdpCI1dohkHScRjXzK+0ywrIo/IpoyYYmUzo22BsOm1D+TjDmps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391506; c=relaxed/simple;
	bh=7Xo+JX/UbsJlacBsti5/l8brRORlCq4pzGp0lvYpRWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iHnfoutdFkrfl99u6XGVdVOaHv0XWQPjJeIDWJuduhhlJaELnRyGw0/IqU8b/M+xjrFrPSe3kMzdyFt+O7QkRLIEzw5647LmFftcn+4H7+0rnRCV1SEJt9FR5Pf7+tyCv9xogArTivdsOhDoqG1tYnORbHwl/XRFPASx3ZmQj3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D2/lI11r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D2/lI11r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5053CC4CEC7;
	Tue,  8 Oct 2024 12:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391506;
	bh=7Xo+JX/UbsJlacBsti5/l8brRORlCq4pzGp0lvYpRWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D2/lI11ro/inmfEaX7WgqKwXifDNIPuNd1SjHiB+Qbn+tKPRjVoXBqIypL4xuCmj5
	 ZmrPsrDNLiYCIq/bBRF9Zjy1+Q1SGCKjIbZt7Z1Q2+CwYQTIUgngibW3rS30xNu24d
	 Iz5k0oG04+GX8vqVWSrC/KyMaG+t7fwL91PJFfB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 135/558] netpoll: Ensure clean state on setup failures
Date: Tue,  8 Oct 2024 14:02:45 +0200
Message-ID: <20241008115707.677457884@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit ae5a0456e0b4cfd7e61619e55251ffdf1bc7adfb ]

Modify netpoll_setup() and __netpoll_setup() to ensure that the netpoll
structure (np) is left in a clean state if setup fails for any reason.
This prevents carrying over misconfigured fields in case of partial
setup success.

Key changes:
- np->dev is now set only after successful setup, ensuring it's always
  NULL if netpoll is not configured or if netpoll_setup() fails.
- np->local_ip is zeroed if netpoll setup doesn't complete successfully.
- Added DEBUG_NET_WARN_ON_ONCE() checks to catch unexpected states.
- Reordered some operations in __netpoll_setup() for better logical flow.

These changes improve the reliability of netpoll configuration, since it
assures that the structure is fully initialized or totally unset.

Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20240822111051.179850-2-leitao@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/netpoll.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index d657b042d5a04..930acc87c8c08 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -624,12 +624,9 @@ int __netpoll_setup(struct netpoll *np, struct net_device *ndev)
 	const struct net_device_ops *ops;
 	int err;
 
-	np->dev = ndev;
-	strscpy(np->dev_name, ndev->name, IFNAMSIZ);
-
 	if (ndev->priv_flags & IFF_DISABLE_NETPOLL) {
 		np_err(np, "%s doesn't support polling, aborting\n",
-		       np->dev_name);
+		       ndev->name);
 		err = -ENOTSUPP;
 		goto out;
 	}
@@ -647,7 +644,7 @@ int __netpoll_setup(struct netpoll *np, struct net_device *ndev)
 
 		refcount_set(&npinfo->refcnt, 1);
 
-		ops = np->dev->netdev_ops;
+		ops = ndev->netdev_ops;
 		if (ops->ndo_netpoll_setup) {
 			err = ops->ndo_netpoll_setup(ndev, npinfo);
 			if (err)
@@ -658,6 +655,8 @@ int __netpoll_setup(struct netpoll *np, struct net_device *ndev)
 		refcount_inc(&npinfo->refcnt);
 	}
 
+	np->dev = ndev;
+	strscpy(np->dev_name, ndev->name, IFNAMSIZ);
 	npinfo->netpoll = np;
 
 	/* last thing to do is link it to the net device structure */
@@ -675,6 +674,7 @@ EXPORT_SYMBOL_GPL(__netpoll_setup);
 int netpoll_setup(struct netpoll *np)
 {
 	struct net_device *ndev = NULL;
+	bool ip_overwritten = false;
 	struct in_device *in_dev;
 	int err;
 
@@ -739,6 +739,7 @@ int netpoll_setup(struct netpoll *np)
 			}
 
 			np->local_ip.ip = ifa->ifa_local;
+			ip_overwritten = true;
 			np_info(np, "local IP %pI4\n", &np->local_ip.ip);
 		} else {
 #if IS_ENABLED(CONFIG_IPV6)
@@ -755,6 +756,7 @@ int netpoll_setup(struct netpoll *np)
 					    !!(ipv6_addr_type(&np->remote_ip.in6) & IPV6_ADDR_LINKLOCAL))
 						continue;
 					np->local_ip.in6 = ifp->addr;
+					ip_overwritten = true;
 					err = 0;
 					break;
 				}
@@ -785,6 +787,9 @@ int netpoll_setup(struct netpoll *np)
 	return 0;
 
 put:
+	DEBUG_NET_WARN_ON_ONCE(np->dev);
+	if (ip_overwritten)
+		memset(&np->local_ip, 0, sizeof(np->local_ip));
 	netdev_put(ndev, &np->dev_tracker);
 unlock:
 	rtnl_unlock();
-- 
2.43.0



