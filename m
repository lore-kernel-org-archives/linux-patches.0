Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E41A56458;
	Thu, 13 Jun 2024 12:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281328; cv=none; b=h+AnLwi/SGmfWlDHiocQRmJcTPh+yUTYbK7A5/mcVzOQ1Q8WQTi22PuqN1ceMw2AXAVgnFinQLH+z904Ace4HvzW7MMVTS3HdDe21beCLxyOcXmB5he7plbAOQsG11P4gW82gLbVerbQSeJu4/D03qsjEI1ECrqtRdBlwyNm5xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281328; c=relaxed/simple;
	bh=jYfhYQahXpUa5kT4p2nDL92MpOEFS2Lj5iZJWulfRyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b4OiRJwOOyE1gSK7pppsUmMHdMkICP/mQzA13QL9rEI0Gxj1qhuD8ydUohRRhhtIlExJhXaKdJhe31+F4PKAa4ym4c/oRv35X4edf9YkE7BR7/woDUDR6zclTFqBkQ2mUMEwze4VqMjGJKWytSk6xX9BA3jhKaQt1ZhCE7l6hAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QB2LheOL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QB2LheOL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A89DC32786;
	Thu, 13 Jun 2024 12:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281327;
	bh=jYfhYQahXpUa5kT4p2nDL92MpOEFS2Lj5iZJWulfRyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QB2LheOLdMZrstZRj2KMzFFx70MYEN8lOsWwCpMUm1QVUlKbpR/+il4FuM46SHz7h
	 Zv4AUbYyzsjlijT0kb04qy62HLwyfo0rJstTIJeHCXZy4rO1BZfPjpzUuKzkz0JSsu
	 Q+2lqHnAO0XgKZbUieGmnfG/uc17spWb6qFdp2LA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 217/317] media: cec: fix a deadlock situation
Date: Thu, 13 Jun 2024 13:33:55 +0200
Message-ID: <20240613113255.948765646@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit a9e6107616bb8108aa4fc22584a05e69761a91f7 ]

The cec_devnode struct has a lock meant to serialize access
to the fields of this struct. This lock is taken during
device node (un)registration and when opening or releasing a
filehandle to the device node. When the last open filehandle
is closed the cec adapter might be disabled by calling the
adap_enable driver callback with the devnode.lock held.

However, if during that callback a message or event arrives
then the driver will call one of the cec_queue_event()
variants in cec-adap.c, and those will take the same devnode.lock
to walk the open filehandle list.

This obviously causes a deadlock.

This is quite easy to reproduce with the cec-gpio driver since that
uses the cec-pin framework which generated lots of events and uses
a kernel thread for the processing, so when adap_enable is called
the thread is still running and can generate events.

But I suspect that it might also happen with other drivers if an
interrupt arrives signaling e.g. a received message before adap_enable
had a chance to disable the interrupts.

This patch adds a new mutex to serialize access to the fhs list.
When adap_enable() is called the devnode.lock mutex is held, but
not devnode.lock_fhs. The event functions in cec-adap.c will now
use devnode.lock_fhs instead of devnode.lock, ensuring that it is
safe to call those functions from the adap_enable callback.

This specific issue only happens if the last open filehandle is closed
and the physical address is invalid. This is not something that
happens during normal operation, but it does happen when monitoring
CEC traffic (e.g. cec-ctl --monitor) with an unconfigured CEC adapter.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc: <stable@vger.kernel.org>  # for v5.13 and up
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Stable-dep-of: 47c82aac10a6 ("media: cec: core: avoid recursive cec_claim_log_addrs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/cec/core/cec-adap.c | 38 +++++++++++++++++--------------
 drivers/media/cec/core/cec-api.c  |  6 +++++
 drivers/media/cec/core/cec-core.c |  3 +++
 include/media/cec.h               | 11 +++++++--
 4 files changed, 39 insertions(+), 19 deletions(-)

diff --git a/drivers/media/cec/core/cec-adap.c b/drivers/media/cec/core/cec-adap.c
index 78027f0310acd..d2a6fd8b65014 100644
--- a/drivers/media/cec/core/cec-adap.c
+++ b/drivers/media/cec/core/cec-adap.c
@@ -161,10 +161,10 @@ static void cec_queue_event(struct cec_adapter *adap,
 	u64 ts = ktime_get_ns();
 	struct cec_fh *fh;
 
-	mutex_lock(&adap->devnode.lock);
+	mutex_lock(&adap->devnode.lock_fhs);
 	list_for_each_entry(fh, &adap->devnode.fhs, list)
 		cec_queue_event_fh(fh, ev, ts);
-	mutex_unlock(&adap->devnode.lock);
+	mutex_unlock(&adap->devnode.lock_fhs);
 }
 
 /* Notify userspace that the CEC pin changed state at the given time. */
@@ -178,11 +178,12 @@ void cec_queue_pin_cec_event(struct cec_adapter *adap, bool is_high,
 	};
 	struct cec_fh *fh;
 
-	mutex_lock(&adap->devnode.lock);
-	list_for_each_entry(fh, &adap->devnode.fhs, list)
+	mutex_lock(&adap->devnode.lock_fhs);
+	list_for_each_entry(fh, &adap->devnode.fhs, list) {
 		if (fh->mode_follower == CEC_MODE_MONITOR_PIN)
 			cec_queue_event_fh(fh, &ev, ktime_to_ns(ts));
-	mutex_unlock(&adap->devnode.lock);
+	}
+	mutex_unlock(&adap->devnode.lock_fhs);
 }
 EXPORT_SYMBOL_GPL(cec_queue_pin_cec_event);
 
@@ -195,10 +196,10 @@ void cec_queue_pin_hpd_event(struct cec_adapter *adap, bool is_high, ktime_t ts)
 	};
 	struct cec_fh *fh;
 
-	mutex_lock(&adap->devnode.lock);
+	mutex_lock(&adap->devnode.lock_fhs);
 	list_for_each_entry(fh, &adap->devnode.fhs, list)
 		cec_queue_event_fh(fh, &ev, ktime_to_ns(ts));
-	mutex_unlock(&adap->devnode.lock);
+	mutex_unlock(&adap->devnode.lock_fhs);
 }
 EXPORT_SYMBOL_GPL(cec_queue_pin_hpd_event);
 
@@ -211,10 +212,10 @@ void cec_queue_pin_5v_event(struct cec_adapter *adap, bool is_high, ktime_t ts)
 	};
 	struct cec_fh *fh;
 
-	mutex_lock(&adap->devnode.lock);
+	mutex_lock(&adap->devnode.lock_fhs);
 	list_for_each_entry(fh, &adap->devnode.fhs, list)
 		cec_queue_event_fh(fh, &ev, ktime_to_ns(ts));
-	mutex_unlock(&adap->devnode.lock);
+	mutex_unlock(&adap->devnode.lock_fhs);
 }
 EXPORT_SYMBOL_GPL(cec_queue_pin_5v_event);
 
@@ -286,12 +287,12 @@ static void cec_queue_msg_monitor(struct cec_adapter *adap,
 	u32 monitor_mode = valid_la ? CEC_MODE_MONITOR :
 				      CEC_MODE_MONITOR_ALL;
 
-	mutex_lock(&adap->devnode.lock);
+	mutex_lock(&adap->devnode.lock_fhs);
 	list_for_each_entry(fh, &adap->devnode.fhs, list) {
 		if (fh->mode_follower >= monitor_mode)
 			cec_queue_msg_fh(fh, msg);
 	}
-	mutex_unlock(&adap->devnode.lock);
+	mutex_unlock(&adap->devnode.lock_fhs);
 }
 
 /*
@@ -302,12 +303,12 @@ static void cec_queue_msg_followers(struct cec_adapter *adap,
 {
 	struct cec_fh *fh;
 
-	mutex_lock(&adap->devnode.lock);
+	mutex_lock(&adap->devnode.lock_fhs);
 	list_for_each_entry(fh, &adap->devnode.fhs, list) {
 		if (fh->mode_follower == CEC_MODE_FOLLOWER)
 			cec_queue_msg_fh(fh, msg);
 	}
-	mutex_unlock(&adap->devnode.lock);
+	mutex_unlock(&adap->devnode.lock_fhs);
 }
 
 /* Notify userspace of an adapter state change. */
@@ -1559,6 +1560,7 @@ void __cec_s_phys_addr(struct cec_adapter *adap, u16 phys_addr, bool block)
 		/* Disabling monitor all mode should always succeed */
 		if (adap->monitor_all_cnt)
 			WARN_ON(call_op(adap, adap_monitor_all_enable, false));
+		/* serialize adap_enable */
 		mutex_lock(&adap->devnode.lock);
 		if (adap->needs_hpd || list_empty(&adap->devnode.fhs)) {
 			WARN_ON(adap->ops->adap_enable(adap, false));
@@ -1570,14 +1572,16 @@ void __cec_s_phys_addr(struct cec_adapter *adap, u16 phys_addr, bool block)
 			return;
 	}
 
+	/* serialize adap_enable */
 	mutex_lock(&adap->devnode.lock);
 	adap->last_initiator = 0xff;
 	adap->transmit_in_progress = false;
 
-	if ((adap->needs_hpd || list_empty(&adap->devnode.fhs)) &&
-	    adap->ops->adap_enable(adap, true)) {
-		mutex_unlock(&adap->devnode.lock);
-		return;
+	if (adap->needs_hpd || list_empty(&adap->devnode.fhs)) {
+		if (adap->ops->adap_enable(adap, true)) {
+			mutex_unlock(&adap->devnode.lock);
+			return;
+		}
 	}
 
 	if (adap->monitor_all_cnt &&
diff --git a/drivers/media/cec/core/cec-api.c b/drivers/media/cec/core/cec-api.c
index 893641ebc644b..899017a0e514e 100644
--- a/drivers/media/cec/core/cec-api.c
+++ b/drivers/media/cec/core/cec-api.c
@@ -586,6 +586,7 @@ static int cec_open(struct inode *inode, struct file *filp)
 		return err;
 	}
 
+	/* serialize adap_enable */
 	mutex_lock(&devnode->lock);
 	if (list_empty(&devnode->fhs) &&
 	    !adap->needs_hpd &&
@@ -624,7 +625,9 @@ static int cec_open(struct inode *inode, struct file *filp)
 	}
 #endif
 
+	mutex_lock(&devnode->lock_fhs);
 	list_add(&fh->list, &devnode->fhs);
+	mutex_unlock(&devnode->lock_fhs);
 	mutex_unlock(&devnode->lock);
 
 	return 0;
@@ -653,8 +656,11 @@ static int cec_release(struct inode *inode, struct file *filp)
 		cec_monitor_all_cnt_dec(adap);
 	mutex_unlock(&adap->lock);
 
+	/* serialize adap_enable */
 	mutex_lock(&devnode->lock);
+	mutex_lock(&devnode->lock_fhs);
 	list_del(&fh->list);
+	mutex_unlock(&devnode->lock_fhs);
 	if (cec_is_registered(adap) && list_empty(&devnode->fhs) &&
 	    !adap->needs_hpd && adap->phys_addr == CEC_PHYS_ADDR_INVALID) {
 		WARN_ON(adap->ops->adap_enable(adap, false));
diff --git a/drivers/media/cec/core/cec-core.c b/drivers/media/cec/core/cec-core.c
index ece236291f358..61139b0a08699 100644
--- a/drivers/media/cec/core/cec-core.c
+++ b/drivers/media/cec/core/cec-core.c
@@ -167,8 +167,10 @@ static void cec_devnode_unregister(struct cec_adapter *adap)
 		return;
 	}
 
+	mutex_lock(&devnode->lock_fhs);
 	list_for_each_entry(fh, &devnode->fhs, list)
 		wake_up_interruptible(&fh->wait);
+	mutex_unlock(&devnode->lock_fhs);
 
 	devnode->registered = false;
 	devnode->unregistered = true;
@@ -272,6 +274,7 @@ struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
 
 	/* adap->devnode initialization */
 	INIT_LIST_HEAD(&adap->devnode.fhs);
+	mutex_init(&adap->devnode.lock_fhs);
 	mutex_init(&adap->devnode.lock);
 
 	adap->kthread = kthread_run(cec_thread_func, adap, "cec-%s", name);
diff --git a/include/media/cec.h b/include/media/cec.h
index 208c9613c07eb..77346f757036d 100644
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -26,13 +26,17 @@
  * @dev:	cec device
  * @cdev:	cec character device
  * @minor:	device node minor number
+ * @lock:	lock to serialize open/release and registration
  * @registered:	the device was correctly registered
  * @unregistered: the device was unregistered
+ * @lock_fhs:	lock to control access to @fhs
  * @fhs:	the list of open filehandles (cec_fh)
- * @lock:	lock to control access to this structure
  *
  * This structure represents a cec-related device node.
  *
+ * To add or remove filehandles from @fhs the @lock must be taken first,
+ * followed by @lock_fhs. It is safe to access @fhs if either lock is held.
+ *
  * The @parent is a physical device. It must be set by core or device drivers
  * before registering the node.
  */
@@ -43,10 +47,13 @@ struct cec_devnode {
 
 	/* device info */
 	int minor;
+	/* serialize open/release and registration */
+	struct mutex lock;
 	bool registered;
 	bool unregistered;
+	/* protect access to fhs */
+	struct mutex lock_fhs;
 	struct list_head fhs;
-	struct mutex lock;
 };
 
 struct cec_adapter;
-- 
2.43.0



