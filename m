Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621079;
	b=ozug09vEa02MbVOTpCzxu42TTX/pUGW7VziTGttFtj3fedc+n61bg+0xTvsJDQBKWgl4
	 3P05oEuRzoUouiGQ0CIzm07+5MSSCqaYAPTzngkgJpUDGFnZErzpkM53d+3XnaZL2yMUw
	 B+LoG8woOKp6pSjBK8EcYgAXAyWCBYBvzEFaBzYD4R60CpKPwBMt3NkyIgVjlR2odKHdX
	 phb9fIs0Qm4CuXpxIBAg6a4V36CSGjgC5MShS5hjvupShr/BqxH14F1wLdI0zPI8dGaRZ
	 tJBSJIleewGDZw1TfBW5e6oy6ozUlsb79mtpZVFpQLM8nyV/Suqhyvov29cifNvHnwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621079;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Sq2oR0a/wx+uRJzr+MhewbjSLXYEdiOzcFO4fl+XL9w=;
	b=Rdqn1NDXEhHVh1PbDTmo9ppzLtzBqQrzaWb30eAxBeM39sD1Uk/FAVrqKaNjswHYFYF4
	 q+11wCwNWiBDT6MaWKj2Em/EXXMsUYXyTPpgswy7HT4In2uVjs7FPXv4pJOPELkp7xKax
	 ABTIp1sxs4MS8ob/WxCYunKxJ4sYQq0QYwGJHzR23iEbhO7YyAYHbQHMN1l9uuFxdkjv7
	 EIxcv+EUjq1eRCEvAZfzi+Zcrqsn1Qg8FBLCxFdLEamC7vhga+yEzPsp7nvqN9qDIhpRT
	 iVThEndevLPSvLVlyQnqoLlCZDSDnOOk3eWGxgkNjMM6AFrxFF/bYxWD7XiXUvJJKYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DsBcmZ1b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81CCF606A31E;
	Wed, 25 Nov 2026 15:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DsBcmZ1b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C958F1F000C0;
	Wed, 25 Nov 2026 15:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621079;
	bh=Sq2oR0a/wx+uRJzr+MhewbjSLXYEdiOzcFO4fl+XL9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DsBcmZ1bcUPO/Baz6H0N/h0PcD3jk8BEPKCEmhnySqoO2EdnJ0VTpmPKDHSRtK8Xe
	 MDWgktAgp1L2SccpQyL7gvvrRzGTlx5TuTJFXlaMAS4LiyhZk0O4JLRbZ0NM3n+n3f
	 WANt18RYB3b1WqOIjrY0+KaK6wJPmnTpqir+KOn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 069/990] wifi: wext: Limit notifier event flushes to the devices netns
Date: Wed, 25 Nov 2026 15:23:56 +0100
Message-ID: <20261125143823.704816161@linuxfoundation.org>
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

From: Cosmin Ratiu <cratiu@nvidia.com>

[ Upstream commit 48c0045366bec142d053f7cf76fb9dd7127cd231 ]

With mlx5 netdev instance locking enabled, registering an IPoIB netdev
calls the WEXT notifier while holding the instance mutex. Its call to
wireless_nlevent_flush() takes net_rwsem to walk every namespace,
completing the following lockdep dependency cycle:

  netdev instance mutex -> net_rwsem (read) -> GID table mutex
    -> event_handler_rwsem (read) -> netdev instance mutex

RoCE GID enumeration takes the GID table mutex under net_rwsem. GID
updates dispatch events under the table mutex, taking event_handler_rwsem.
The IPoIB event handler takes the netdev instance mutex in
ipoib_queue_work() to traverse child interfaces.

The all-namespace walk originated in the single global worker servicing
per-namespace WEXT queues. The ordering fixes later reused that routine
in netdevice notifiers to prevent delayed WEXT RTM_NEWLINK messages from
following RTM_DELLINK or reporting stale interface flags. A notifier only
needs to drain the affected device's namespace; there is no reason for it
to walk and flush all namespaces.

Pass dev_net(dev) from both notifier callers and make the flush helper
operate on that namespace. Keep the all-namespace walk and net_rwsem in
the existing worker. This removes the instance-mutex -> net_rwsem
dependency while retaining synchronous flushing from the notifiers.

It may seem strange that the fix for a lock cycle across multiple
subsystems lies in a completely unrelated part of the code, but this
seemed the most justified lock cycle edge to break.

Fixes: 8f7b00307bf1 ("net/mlx5e: Convert mlx5 netdevs to instance locking")
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Link: https://patch.msgid.link/20261021144111.611840-1-cratiu@nvidia.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/iw_handler.h |  8 +++++---
 net/wireless/core.c      |  2 +-
 net/wireless/wext-core.c | 33 +++++++++++++++++----------------
 3 files changed, 23 insertions(+), 20 deletions(-)

diff --git a/include/net/iw_handler.h b/include/net/iw_handler.h
index b80e474cb0aa9..632618d9ff937 100644
--- a/include/net/iw_handler.h
+++ b/include/net/iw_handler.h
@@ -201,6 +201,8 @@
 #include <linux/wireless.h>		/* IOCTL user space API */
 #include <linux/if_ether.h>
 
+struct net;
+
 /***************************** VERSION *****************************/
 /*
  * This constant is used to know which version of the driver API is
@@ -411,10 +413,10 @@ struct iw_spy_data {
 void wireless_send_event(struct net_device *dev, unsigned int cmd,
 			 union iwreq_data *wrqu, const char *extra);
 #ifdef CONFIG_WEXT_CORE
-/* flush all previous wext events - if work is done from netdev notifiers */
-void wireless_nlevent_flush(void);
+/* Flush previous wext events in this netns from netdev notifiers. */
+void wireless_nlevent_flush(struct net *net);
 #else
-static inline void wireless_nlevent_flush(void) {}
+static inline void wireless_nlevent_flush(struct net *net) {}
 #endif
 
 /* We may need a function to send a stream of events to user space.
diff --git a/net/wireless/core.c b/net/wireless/core.c
index c7d4498682549..0661c432b4e58 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1762,7 +1762,7 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		return NOTIFY_DONE;
 	}
 
-	wireless_nlevent_flush();
+	wireless_nlevent_flush(dev_net(dev));
 
 	return NOTIFY_OK;
 }
diff --git a/net/wireless/wext-core.c b/net/wireless/wext-core.c
index 7b8e94214b072..7de96c3ffda8c 100644
--- a/net/wireless/wext-core.c
+++ b/net/wireless/wext-core.c
@@ -343,32 +343,28 @@ static const int compat_event_type_size[] = {
 
 /* IW event code */
 
-void wireless_nlevent_flush(void)
+void wireless_nlevent_flush(struct net *net)
 {
 	struct sk_buff *skb;
-	struct net *net;
 
-	down_read(&net_rwsem);
-	for_each_net(net) {
-		while ((skb = skb_dequeue(&net->wext_nlevents)))
-			rtnl_notify(skb, net, 0, RTNLGRP_LINK, NULL,
-				    GFP_KERNEL);
-	}
-	up_read(&net_rwsem);
+	while ((skb = skb_dequeue(&net->wext_nlevents)))
+		rtnl_notify(skb, net, 0, RTNLGRP_LINK, NULL, GFP_KERNEL);
 }
 EXPORT_SYMBOL_GPL(wireless_nlevent_flush);
 
 static int wext_netdev_notifier_call(struct notifier_block *nb,
 				     unsigned long state, void *ptr)
 {
+	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+
 	/*
-	 * When a netdev changes state in any way, flush all pending messages
-	 * to avoid them going out in a strange order, e.g. RTM_NEWLINK after
-	 * RTM_DELLINK, or with IFF_UP after without IFF_UP during dev_close()
-	 * or similar - all of which could otherwise happen due to delays from
-	 * schedule_work().
+	 * When a netdev changes state in any way, flush all pending messages in
+	 * its network namespace to avoid them going out in a strange order,
+	 * e.g. RTM_NEWLINK after RTM_DELLINK, or with IFF_UP after without
+	 * IFF_UP during dev_close() or similar - all of which could otherwise
+	 * happen due to delays from schedule_work().
 	 */
-	wireless_nlevent_flush();
+	wireless_nlevent_flush(dev_net(dev));
 
 	return NOTIFY_OK;
 }
@@ -411,7 +407,12 @@ subsys_initcall(wireless_nlevent_init);
 /* Process events generated by the wireless layer or the driver. */
 static void wireless_nlevent_process(struct work_struct *work)
 {
-	wireless_nlevent_flush();
+	struct net *net;
+
+	down_read(&net_rwsem);
+	for_each_net(net)
+		wireless_nlevent_flush(net);
+	up_read(&net_rwsem);
 }
 
 static DECLARE_WORK(wireless_nlevent_work, wireless_nlevent_process);
-- 
2.53.0



