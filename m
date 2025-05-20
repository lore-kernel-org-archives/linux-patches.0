Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 974A62459ED;
	Tue, 20 May 2025 14:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749723; cv=none; b=dnCpeJQqizLxn8YjBPvljb/S4NQiKpTE7RY+dpz2xH3tnlg0EhWCTIyV0/G7DdEbElXXyMQJHBNJhQ1YvsNVhr2YPkc+I9Cli7B8OqC9P1OBrDi2cf8o6bTLR5BiqliUEtNHlBR4SHU8McWgzSw1Avf9K+rhw9kaVpOHX+yf1kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749723; c=relaxed/simple;
	bh=W6IUm+FRbrQYOImJ1m1bJihZb/0kOkgVznkiy97f0B4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lCLTqOZqwgtPusn9dBC+xzryRy7tQjo1FY7eHH18FoGBStAKiwcUiK6TexPcyuMkj+7hxBzW0eOWfso2uFz1vT/3WINLMDrovgCBnI3csgTKmEHsCu4u8BBYJB1cL12CkXYdNQrFeUb1y4i1v6Si9SaalqqKbcOQY0SZSzb4NKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RTNpoUlQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RTNpoUlQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F894C4CEEF;
	Tue, 20 May 2025 14:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749723;
	bh=W6IUm+FRbrQYOImJ1m1bJihZb/0kOkgVznkiy97f0B4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RTNpoUlQ6b2oSlV3Z5vHaBP+4HereoSVfH8nZjViUrUxiu15ZTokuYwb+AL4qVjRZ
	 Xuz5jepiTJcFQeYqRN/rRcWP56qoIsONHMzNa1TQ5dZMAunbvqdXvzQzr9s0LKh+kY
	 04b0Z5Nla4wSklaQg+k4tRkkwIsAVsLHpHbVPoLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Matt Johnston <matt@codeconstruct.com.au>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 039/117] mctp: no longer rely on net->dev_index_head[]
Date: Tue, 20 May 2025 15:50:04 +0200
Message-ID: <20250520125805.540508961@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 2d20773aec14996b6cc4db92d885028319be683d ]

mctp_dump_addrinfo() is one of the last users of
net->dev_index_head[] in the control path.

Switch to for_each_netdev_dump() for better scalability.

Use C99 for mctp_device_rtnl_msg_handlers[] to prepare
future RTNL removal from mctp_dump_addrinfo()

(mdev->addrs is not yet RCU protected)

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Matt Johnston <matt@codeconstruct.com.au>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Acked-by: Jeremy Kerr <jk@codeconstruct.com.au>
Link: https://patch.msgid.link/20241206223811.1343076-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: f11cf946c0a9 ("net: mctp: Don't access ifa_index when missing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mctp/device.c | 50 ++++++++++++++++++-----------------------------
 1 file changed, 19 insertions(+), 31 deletions(-)

diff --git a/net/mctp/device.c b/net/mctp/device.c
index 85cc5f31f1e7c..cdb18da96c4bc 100644
--- a/net/mctp/device.c
+++ b/net/mctp/device.c
@@ -20,8 +20,7 @@
 #include <net/sock.h>
 
 struct mctp_dump_cb {
-	int h;
-	int idx;
+	unsigned long ifindex;
 	size_t a_idx;
 };
 
@@ -115,43 +114,29 @@ static int mctp_dump_addrinfo(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	struct mctp_dump_cb *mcb = (void *)cb->ctx;
 	struct net *net = sock_net(skb->sk);
-	struct hlist_head *head;
 	struct net_device *dev;
 	struct ifaddrmsg *hdr;
 	struct mctp_dev *mdev;
-	int ifindex;
-	int idx = 0, rc;
+	int ifindex, rc;
 
 	hdr = nlmsg_data(cb->nlh);
 	// filter by ifindex if requested
 	ifindex = hdr->ifa_index;
 
 	rcu_read_lock();
-	for (; mcb->h < NETDEV_HASHENTRIES; mcb->h++, mcb->idx = 0) {
-		idx = 0;
-		head = &net->dev_index_head[mcb->h];
-		hlist_for_each_entry_rcu(dev, head, index_hlist) {
-			if (idx >= mcb->idx &&
-			    (ifindex == 0 || ifindex == dev->ifindex)) {
-				mdev = __mctp_dev_get(dev);
-				if (mdev) {
-					rc = mctp_dump_dev_addrinfo(mdev,
-								    skb, cb);
-					mctp_dev_put(mdev);
-					// Error indicates full buffer, this
-					// callback will get retried.
-					if (rc < 0)
-						goto out;
-				}
-			}
-			idx++;
-			// reset for next iteration
-			mcb->a_idx = 0;
-		}
+	for_each_netdev_dump(net, dev, mcb->ifindex) {
+		if (ifindex && ifindex != dev->ifindex)
+			continue;
+		mdev = __mctp_dev_get(dev);
+		if (!mdev)
+			continue;
+		rc = mctp_dump_dev_addrinfo(mdev, skb, cb);
+		mctp_dev_put(mdev);
+		if (rc < 0)
+			break;
+		mcb->a_idx = 0;
 	}
-out:
 	rcu_read_unlock();
-	mcb->idx = idx;
 
 	return skb->len;
 }
@@ -525,9 +510,12 @@ static struct notifier_block mctp_dev_nb = {
 };
 
 static const struct rtnl_msg_handler mctp_device_rtnl_msg_handlers[] = {
-	{THIS_MODULE, PF_MCTP, RTM_NEWADDR, mctp_rtm_newaddr, NULL, 0},
-	{THIS_MODULE, PF_MCTP, RTM_DELADDR, mctp_rtm_deladdr, NULL, 0},
-	{THIS_MODULE, PF_MCTP, RTM_GETADDR, NULL, mctp_dump_addrinfo, 0},
+	{.owner = THIS_MODULE, .protocol = PF_MCTP, .msgtype = RTM_NEWADDR,
+	 .doit = mctp_rtm_newaddr},
+	{.owner = THIS_MODULE, .protocol = PF_MCTP, .msgtype = RTM_DELADDR,
+	 .doit = mctp_rtm_deladdr},
+	{.owner = THIS_MODULE, .protocol = PF_MCTP, .msgtype = RTM_GETADDR,
+	 .dumpit = mctp_dump_addrinfo},
 };
 
 int __init mctp_device_init(void)
-- 
2.39.5



