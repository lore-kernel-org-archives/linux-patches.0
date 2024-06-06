Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 392EC196C77;
	Thu,  6 Jun 2024 14:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683315; cv=none; b=ANXqdjf5hXMLnZT0BwG4D6noxZ2LaCAZHT4ds8Detpchl7cOHE//fIkRohFqHk8zwh+5IbMy1Z5lmpf0CIFf0KTBR37IDIF24Fy/bjYlQWhFdCGuJfQfh5RvUbbhAqmZIRD/II3Yb1veHkaERWXM0MpRhTC4SErV+Qoam5qNss4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683315; c=relaxed/simple;
	bh=bWnbB5u6WVc5K+2UwOX4RtiSlSmd+d5BYDY0fc5iSS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QORnoOKKt4ZfP5kb9cQpTOzRXvPa3VuH0+xooO8aE1fTCwv5twnD0ZJVzKvl2cl8FZ/OJ51rYrqhwAo7zUtI+T6TG7hefwLvu4ARSpjqAx7KgPDexwJn877woOhVTdVDF57LLMSgXkxm29bU247o67vEtnWqQJwW+RmN09jBvGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zY7CMHQJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zY7CMHQJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 160A5C4AF08;
	Thu,  6 Jun 2024 14:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683315;
	bh=bWnbB5u6WVc5K+2UwOX4RtiSlSmd+d5BYDY0fc5iSS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zY7CMHQJpBUYy7Co/6fElmd0DVC1/CsSvzGeNiW/znf6TCOP0d7o8GLc39f6jn1m+
	 6+k9YOsOTXWQzluW5+pFMpcDKszHN9l0cLv7oSstkZy8GHg1LuwIZRYP/pc3NxbdH1
	 IScrGhMU4HnuQ8meOoUpechbfp9odFiIZ5/x5Hww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Duoming Zhou <duoming@zju.edu.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 255/744] ax25: Use kernel universal linked list to implement ax25_dev_list
Date: Thu,  6 Jun 2024 15:58:47 +0200
Message-ID: <20240606131740.586617046@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit a7d6e36b9ad052926ba2ecba3a59d8bb67dabcb4 ]

The origin ax25_dev_list implements its own single linked list,
which is complicated and error-prone. For example, when deleting
the node of ax25_dev_list in ax25_dev_device_down(), we have to
operate on the head node and other nodes separately.

This patch uses kernel universal linked list to replace original
ax25_dev_list, which make the operation of ax25_dev_list easier.

We should do "dev->ax25_ptr = ax25_dev;" and "dev->ax25_ptr = NULL;"
while holding the spinlock, otherwise the ax25_dev_device_up() and
ax25_dev_device_down() could race.

Suggested-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/85bba3af651ca0e1a519da8d0d715b949891171c.1715247018.git.duoming@zju.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: b505e0319852 ("ax25: Fix reference count leak issues of ax25_dev")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ax25.h  |  3 +--
 net/ax25/ax25_dev.c | 40 +++++++++++++++-------------------------
 2 files changed, 16 insertions(+), 27 deletions(-)

diff --git a/include/net/ax25.h b/include/net/ax25.h
index 0d939e5aee4ec..c2a85fd3f5ea4 100644
--- a/include/net/ax25.h
+++ b/include/net/ax25.h
@@ -216,7 +216,7 @@ typedef struct {
 struct ctl_table;
 
 typedef struct ax25_dev {
-	struct ax25_dev		*next;
+	struct list_head	list;
 
 	struct net_device	*dev;
 	netdevice_tracker	dev_tracker;
@@ -330,7 +330,6 @@ int ax25_addr_size(const ax25_digi *);
 void ax25_digi_invert(const ax25_digi *, ax25_digi *);
 
 /* ax25_dev.c */
-extern ax25_dev *ax25_dev_list;
 extern spinlock_t ax25_dev_lock;
 
 #if IS_ENABLED(CONFIG_AX25)
diff --git a/net/ax25/ax25_dev.c b/net/ax25/ax25_dev.c
index 282ec581c0720..f16ee5c09d07a 100644
--- a/net/ax25/ax25_dev.c
+++ b/net/ax25/ax25_dev.c
@@ -22,11 +22,12 @@
 #include <net/sock.h>
 #include <linux/uaccess.h>
 #include <linux/fcntl.h>
+#include <linux/list.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
 #include <linux/init.h>
 
-ax25_dev *ax25_dev_list;
+static LIST_HEAD(ax25_dev_list);
 DEFINE_SPINLOCK(ax25_dev_lock);
 
 ax25_dev *ax25_addr_ax25dev(ax25_address *addr)
@@ -34,7 +35,7 @@ ax25_dev *ax25_addr_ax25dev(ax25_address *addr)
 	ax25_dev *ax25_dev, *res = NULL;
 
 	spin_lock_bh(&ax25_dev_lock);
-	for (ax25_dev = ax25_dev_list; ax25_dev != NULL; ax25_dev = ax25_dev->next)
+	list_for_each_entry(ax25_dev, &ax25_dev_list, list)
 		if (ax25cmp(addr, (const ax25_address *)ax25_dev->dev->dev_addr) == 0) {
 			res = ax25_dev;
 			ax25_dev_hold(ax25_dev);
@@ -59,7 +60,6 @@ void ax25_dev_device_up(struct net_device *dev)
 	}
 
 	refcount_set(&ax25_dev->refcount, 1);
-	dev->ax25_ptr     = ax25_dev;
 	ax25_dev->dev     = dev;
 	netdev_hold(dev, &ax25_dev->dev_tracker, GFP_KERNEL);
 	ax25_dev->forward = NULL;
@@ -85,8 +85,8 @@ void ax25_dev_device_up(struct net_device *dev)
 #endif
 
 	spin_lock_bh(&ax25_dev_lock);
-	ax25_dev->next = ax25_dev_list;
-	ax25_dev_list  = ax25_dev;
+	list_add(&ax25_dev->list, &ax25_dev_list);
+	dev->ax25_ptr     = ax25_dev;
 	spin_unlock_bh(&ax25_dev_lock);
 	ax25_dev_hold(ax25_dev);
 
@@ -111,32 +111,25 @@ void ax25_dev_device_down(struct net_device *dev)
 	/*
 	 *	Remove any packet forwarding that points to this device.
 	 */
-	for (s = ax25_dev_list; s != NULL; s = s->next)
+	list_for_each_entry(s, &ax25_dev_list, list)
 		if (s->forward == dev)
 			s->forward = NULL;
 
-	if ((s = ax25_dev_list) == ax25_dev) {
-		ax25_dev_list = s->next;
-		goto unlock_put;
-	}
-
-	while (s != NULL && s->next != NULL) {
-		if (s->next == ax25_dev) {
-			s->next = ax25_dev->next;
+	list_for_each_entry(s, &ax25_dev_list, list) {
+		if (s == ax25_dev) {
+			list_del(&s->list);
 			goto unlock_put;
 		}
-
-		s = s->next;
 	}
-	spin_unlock_bh(&ax25_dev_lock);
 	dev->ax25_ptr = NULL;
+	spin_unlock_bh(&ax25_dev_lock);
 	ax25_dev_put(ax25_dev);
 	return;
 
 unlock_put:
+	dev->ax25_ptr = NULL;
 	spin_unlock_bh(&ax25_dev_lock);
 	ax25_dev_put(ax25_dev);
-	dev->ax25_ptr = NULL;
 	netdev_put(dev, &ax25_dev->dev_tracker);
 	ax25_dev_put(ax25_dev);
 }
@@ -200,16 +193,13 @@ struct net_device *ax25_fwd_dev(struct net_device *dev)
  */
 void __exit ax25_dev_free(void)
 {
-	ax25_dev *s, *ax25_dev;
+	ax25_dev *s, *n;
 
 	spin_lock_bh(&ax25_dev_lock);
-	ax25_dev = ax25_dev_list;
-	while (ax25_dev != NULL) {
-		s        = ax25_dev;
-		netdev_put(ax25_dev->dev, &ax25_dev->dev_tracker);
-		ax25_dev = ax25_dev->next;
+	list_for_each_entry_safe(s, n, &ax25_dev_list, list) {
+		netdev_put(s->dev, &s->dev_tracker);
+		list_del(&s->list);
 		kfree(s);
 	}
-	ax25_dev_list = NULL;
 	spin_unlock_bh(&ax25_dev_lock);
 }
-- 
2.43.0



