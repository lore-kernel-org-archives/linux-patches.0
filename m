Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B0AF11C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:23:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F60FC433C9;
	Mon, 28 Aug 2023 10:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218211;
	bh=jQMpYP+TkuLMOmDQEIiw4iPtrs+K0krQpRV2ULu+owo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZU5YvcVFNaKYA2FjXqW5osPzr8j1OT/y6Ml+rslK/X60Ob8gwa4ff+DRH8VpqB7hd
	 oO5H16G7rNn5PQD5yR0mBYbKMhcH/vTMmI1kkyQycZQkuUw6bqlPlZ/Ed1EmDx6gv4
	 W//gKmVwDW2gEPnrzlihFLlLAGw+0qv7c+LmGEr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Ziyang Xuan <william.xuanziyang@huawei.com>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.4 109/129] can: raw: add missing refcount for memory leak fix
Date: Mon, 28 Aug 2023 12:13:08 +0200
Message-ID: <20230828101200.993327219@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101157.383363777@linuxfoundation.org>
References: <20230828101157.383363777@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Hartkopp <socketcan@hartkopp.net>

commit c275a176e4b69868576e543409927ae75e3a3288 upstream.

Commit ee8b94c8510c ("can: raw: fix receiver memory leak") introduced
a new reference to the CAN netdevice that has assigned CAN filters.
But this new ro->dev reference did not maintain its own refcount which
lead to another KASAN use-after-free splat found by Eric Dumazet.

This patch ensures a proper refcount for the CAN nedevice.

Fixes: ee8b94c8510c ("can: raw: fix receiver memory leak")
Reported-by: Eric Dumazet <edumazet@google.com>
Cc: Ziyang Xuan <william.xuanziyang@huawei.com>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://lore.kernel.org/r/20230821144547.6658-3-socketcan@hartkopp.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/raw.c |   35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -85,6 +85,7 @@ struct raw_sock {
 	int bound;
 	int ifindex;
 	struct net_device *dev;
+	netdevice_tracker dev_tracker;
 	struct list_head notifier;
 	int loopback;
 	int recv_own_msgs;
@@ -285,8 +286,10 @@ static void raw_notify(struct raw_sock *
 	case NETDEV_UNREGISTER:
 		lock_sock(sk);
 		/* remove current filters & unregister */
-		if (ro->bound)
+		if (ro->bound) {
 			raw_disable_allfilters(dev_net(dev), dev, sk);
+			netdev_put(dev, &ro->dev_tracker);
+		}
 
 		if (ro->count > 1)
 			kfree(ro->filter);
@@ -391,10 +394,12 @@ static int raw_release(struct socket *so
 
 	/* remove current filters & unregister */
 	if (ro->bound) {
-		if (ro->dev)
+		if (ro->dev) {
 			raw_disable_allfilters(dev_net(ro->dev), ro->dev, sk);
-		else
+			netdev_put(ro->dev, &ro->dev_tracker);
+		} else {
 			raw_disable_allfilters(sock_net(sk), NULL, sk);
+		}
 	}
 
 	if (ro->count > 1)
@@ -445,10 +450,10 @@ static int raw_bind(struct socket *sock,
 			goto out;
 		}
 		if (dev->type != ARPHRD_CAN) {
-			dev_put(dev);
 			err = -ENODEV;
-			goto out;
+			goto out_put_dev;
 		}
+
 		if (!(dev->flags & IFF_UP))
 			notify_enetdown = 1;
 
@@ -456,7 +461,9 @@ static int raw_bind(struct socket *sock,
 
 		/* filters set by default/setsockopt */
 		err = raw_enable_allfilters(sock_net(sk), dev, sk);
-		dev_put(dev);
+		if (err)
+			goto out_put_dev;
+
 	} else {
 		ifindex = 0;
 
@@ -467,18 +474,28 @@ static int raw_bind(struct socket *sock,
 	if (!err) {
 		if (ro->bound) {
 			/* unregister old filters */
-			if (ro->dev)
+			if (ro->dev) {
 				raw_disable_allfilters(dev_net(ro->dev),
 						       ro->dev, sk);
-			else
+				/* drop reference to old ro->dev */
+				netdev_put(ro->dev, &ro->dev_tracker);
+			} else {
 				raw_disable_allfilters(sock_net(sk), NULL, sk);
+			}
 		}
 		ro->ifindex = ifindex;
 		ro->bound = 1;
+		/* bind() ok -> hold a reference for new ro->dev */
 		ro->dev = dev;
+		if (ro->dev)
+			netdev_hold(ro->dev, &ro->dev_tracker, GFP_KERNEL);
 	}
 
- out:
+out_put_dev:
+	/* remove potential reference from dev_get_by_index() */
+	if (dev)
+		dev_put(dev);
+out:
 	release_sock(sk);
 	rtnl_unlock();
 


