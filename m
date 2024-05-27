Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778BE17727;
	Mon, 27 May 2024 19:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838245; cv=none; b=gm06c0kdfLmCol9EZ45X7CQ84OUSQt2eykK0As9MmTSS/y50rT2c5cQ+VSwASLAryDXYo9kyownC6GM5Eblb4B+MgEGl8MmaBwf/+IpdNoXKEJ/Qnv8/cpHjpbvyTLZr3CJBUvZ/wsn5OTF1oqOu+hMCNxuNL+rMStfGt1DzPvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838245; c=relaxed/simple;
	bh=NVGMUXAAxd2sI73F4d4n/t+KVM+pMQN6tOgZdtDa1BM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rkzTP09waX22ZDFkz/wS2MwLPV1j2+Yn+DC6uovXwquQ9zDqUOb6Ys6boE8jff61D6j4Vlscq4Ne6pBNG1AOdC02/ypb4vdCOgfTjPr0UhXaUTtNmNJ56Cx8mGckEwhTFABMaqF0rOjSe3SEPIiKpvQIE//HlNd6WcaqG/M9Gcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U/P8+Tmm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U/P8+Tmm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E232C2BBFC;
	Mon, 27 May 2024 19:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838245;
	bh=NVGMUXAAxd2sI73F4d4n/t+KVM+pMQN6tOgZdtDa1BM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U/P8+TmmHqg6jH+32oL+H/BtC6uWEhjLkgUgVmOuUc2EE2JdtDAdLbDr3osBA16Rt
	 LY0hM1P6m1UynwLzLjgvXNgA6BmtvZ88914INcOk90p6NPDttD4Bali323ZMELAppM
	 CRxriIn0TQinM+cFSFN0fIKFd2b0bR1TNBt0bcPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Duoming Zhou <duoming@zju.edu.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 321/493] ax25: Use kernel universal linked list to implement ax25_dev_list
Date: Mon, 27 May 2024 20:55:23 +0200
Message-ID: <20240527185640.776759663@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



