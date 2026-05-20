Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15559371048;
	Wed, 20 May 2026 18:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301582; cv=none; b=EvaioPJ84Q7iOVYooEYbEBt7YkvOYyaSoMsWqGfQdHtSlL1r+aZMw4E/neLW7x632fdwxLj4jyo6I/TlrAs7CRI6xQ07KEcu4e2fATnH7E8A6hpwDrr2DG35gAOH6QmkmCYWi/WGH41hBQbaWFyGVQ2LGNPlD6tj8+JvjqVslsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301582; c=relaxed/simple;
	bh=XPv4AmUbp4V6m4JUO8swVpUwv73Y965yICTo8ubQkZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o1UFdKGdpf6y077u5Gu+Nt2WxpQX0mOHiwSUB7TdZ2qSDkGyEAaSefpIXtMtB6+eqa4Vb/X0hojmsyulh4tZN+e7/Ge1Rehqz4BnoBsX+sJKGyOXmtBT6YYwXBppptXOtfPuQwcNe3vEx0q8MywWS0FxGGFvVnS5XkVxWMp/9Uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yQj4LG+2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yQj4LG+2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 790481F00894;
	Wed, 20 May 2026 18:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301581;
	bh=tOTA3E3CvzzvCVfO7CIRr7RFytFZBBTer4HEmotKIOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yQj4LG+2KHSlJlu+lmfPYcl0fmrdKs0nClGeJb4iQUqiZhD7ZVy0ioaCm30+rwGQs
	 VxcElIcClYEWngJacSgSq4j4LEwlgBm4RPwVo6XU6YGlHFJ7eXNlPz3r1vyWwB4mLX
	 kha9Y57tt7GhnLQAdEbPqZiqngLdgbjIUhlrgP3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 607/666] netpoll: Extract IPv6 address retrieval function
Date: Wed, 20 May 2026 18:23:38 +0200
Message-ID: <20260520162124.425612704@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 6ad7969a361cbec5822285fb39203678ff462b64 ]

Extract the IPv6 address retrieval logic from netpoll_setup() into
a dedicated helper function netpoll_take_ipv6() to improve code
organization and readability.

The function handles obtaining the local IPv6 address from the
network device, including proper address type matching between
local and remote addresses (link-local vs global), and includes
appropriate error handling when IPv6 is not supported or no
suitable address is available.

Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250618-netpoll_ip_ref-v1-3-c2ac00fe558f@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 76b93a810757 ("netpoll: pass buffer size to egress_dev() to avoid MAC truncation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/netpoll.c | 76 +++++++++++++++++++++++++++-------------------
 1 file changed, 44 insertions(+), 32 deletions(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index b754341db50fe..59cb4d4d28e10 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -721,6 +721,47 @@ static void netpoll_wait_carrier(struct netpoll *np, struct net_device *ndev,
 	}
 }
 
+/*
+ * Take the IPv6 from ndev and populate local_ip structure in netpoll
+ */
+static int netpoll_take_ipv6(struct netpoll *np, struct net_device *ndev)
+{
+	char buf[MAC_ADDR_STR_LEN + 1];
+	int err = -EDESTADDRREQ;
+	struct inet6_dev *idev;
+
+	if (!IS_ENABLED(CONFIG_IPV6)) {
+		np_err(np, "IPv6 is not supported %s, aborting\n",
+		       egress_dev(np, buf));
+		return -EINVAL;
+	}
+
+	idev = __in6_dev_get(ndev);
+	if (idev) {
+		struct inet6_ifaddr *ifp;
+
+		read_lock_bh(&idev->lock);
+		list_for_each_entry(ifp, &idev->addr_list, if_list) {
+			if (!!(ipv6_addr_type(&ifp->addr) & IPV6_ADDR_LINKLOCAL) !=
+				!!(ipv6_addr_type(&np->remote_ip.in6) & IPV6_ADDR_LINKLOCAL))
+				continue;
+			/* Got the IP, let's return */
+			np->local_ip.in6 = ifp->addr;
+			err = 0;
+			break;
+		}
+		read_unlock_bh(&idev->lock);
+	}
+	if (err) {
+		np_err(np, "no IPv6 address for %s, aborting\n",
+		       egress_dev(np, buf));
+		return err;
+	}
+
+	np_info(np, "local IPv6 %pI6c\n", &np->local_ip.in6);
+	return 0;
+}
+
 /*
  * Take the IPv4 from ndev and populate local_ip structure in netpoll
  */
@@ -815,41 +856,12 @@ int netpoll_setup(struct netpoll *np)
 			err = netpoll_take_ipv4(np, ndev);
 			if (err)
 				goto put;
-			ip_overwritten = true;
 		} else {
-#if IS_ENABLED(CONFIG_IPV6)
-			struct inet6_dev *idev;
-
-			err = -EDESTADDRREQ;
-			idev = __in6_dev_get(ndev);
-			if (idev) {
-				struct inet6_ifaddr *ifp;
-
-				read_lock_bh(&idev->lock);
-				list_for_each_entry(ifp, &idev->addr_list, if_list) {
-					if (!!(ipv6_addr_type(&ifp->addr) & IPV6_ADDR_LINKLOCAL) !=
-					    !!(ipv6_addr_type(&np->remote_ip.in6) & IPV6_ADDR_LINKLOCAL))
-						continue;
-					np->local_ip.in6 = ifp->addr;
-					ip_overwritten = true;
-					err = 0;
-					break;
-				}
-				read_unlock_bh(&idev->lock);
-			}
-			if (err) {
-				np_err(np, "no IPv6 address for %s, aborting\n",
-				       egress_dev(np, buf));
+			err = netpoll_take_ipv6(np, ndev);
+			if (err)
 				goto put;
-			} else
-				np_info(np, "local IPv6 %pI6c\n", &np->local_ip.in6);
-#else
-			np_err(np, "IPv6 is not supported %s, aborting\n",
-			       egress_dev(np, buf));
-			err = -EINVAL;
-			goto put;
-#endif
 		}
+		ip_overwritten = true;
 	}
 
 	err = __netpoll_setup(np, ndev);
-- 
2.53.0



