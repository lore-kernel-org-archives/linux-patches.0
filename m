Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052070;
	b=o6EhTOafmmL8tLPTFaIGDMwFsdBWWDR5HwvsTSvZhnHwPR9u6TgUDpLRqd+ggXbT1f13
	 NfIZCBZ38pcQdeVsZShmJymbemzEqJjNx327UkuNJX1jWa768WLypei+5cLVVYUqBwsoy
	 18JLNgykOi8vx5s8NyREKA/PVI6WH9sTJq5jL7a0yUQrFa0KpR97/6KPVL60eJ58lJ4W0
	 ISGSRZ+jAZa05Ad16RG7J4GaD9kgs32PNfh9+2JsTJ+FSQJI2FBLSU5M4ti6FmyT6b9u1
	 kHOoCPvYzJRHJGuscV0DlDutP6Bm2RpQx1FOe/GdhJioFnkzq/dFMQzxhSQbxIhhJcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052070;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ITlX+0tN3CvE7ERUSaWV9t0VkQrUH64cI30bQuDftNk=;
	b=Q3yY4eM7EyCk27u+X91X31B1wsQyzzGG+FT0rKxuz85A/uIClnvnnQH6SlkYBgrZf4jM
	 niRCTrvY0s+0XUVF6ha3EKtvQ05rbSqdeKFkjWU61vpBrXgCxLsK89RPI4k3jhvbK1vT5
	 8tf7YrSm0IG5SY0tPXhbqUmWUB8Z15gAnm/LcGE+piV/wdBSA4xX+nlz2Mip2+KPMSXgt
	 iylg/ii4KW4Eruwj7R2zhSBc/3uhzybJwwRa38NAiIG0LzZF3Jfd6xKHQb2ntCmx/ejiE
	 B1QyO8TFKzWyCe5Vu4TLJQAJLhR33E85rh7otYKhqZZivnqgmoH8c+3f8NC+he3MCew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y+ADeaiQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04949606A320;
	Thu, 19 Nov 2026 01:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y+ADeaiQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 522741F000C4;
	Thu, 19 Nov 2026 01:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052069;
	bh=ITlX+0tN3CvE7ERUSaWV9t0VkQrUH64cI30bQuDftNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y+ADeaiQLuFOwFZ/wHgOvGcjgmgm2Wvtj54j72kqtx9M7B6TUcYXuj7cKmHf+l8cj
	 8n4XEp8iOH/vsaRDvaR+12aBu+QAbSFzhFFf8t6tnlkZN+mki0Z5RwcVZeNwPmHcq6
	 fCyvIPpqVXcDdK+7Slcd7FvKC0ZIzmFM7a01h8D8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0434/2214] media: rc: Fix ABBA deadlock by making locks more fine grained
Date: Wed, 18 Nov 2026 15:35:10 +0100
Message-ID: <20261118150028.357836279@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Young <sean@mess.org>

[ Upstream commit c6d68866ad8aa1e957a3e5a6ede971148f1e3d59 ]

The ir_raw_event_unregister() function takes the ir_raw_handler_lock
first and then the rc_dev->lock. Other functions like change_protocol
do this in the reverse order.

This means that an ir decoder module unload and writing to the protocol
sysfs file can cause a deadlock.

ir_raw_handler_lock protects the client list, amongst other things.
Split this out into a separate lock so we can ensure the locking
order is always the same.

Fixes: 93cffffc18f6 ("[media] media: rc: fix decoder module unloading")
Signed-off-by: Sean Young <sean@mess.org>
Cc: stable@vger.kernel.org
Acked-by: Hans Verkuil <hverkuil+cisco@kernel.org>
[ sashal: adjusted ir_raw_event_unregister() context for del_timer_sync() and the existing teardown sequence ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/rc-ir-raw.c | 38 +++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index c65bba4ec4739..304cc47e781ed 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -10,7 +10,8 @@
 #include <linux/sched.h>
 #include "rc-core-priv.h"
 
-/* Used to keep track of IR raw clients, protected by ir_raw_handler_lock */
+/* Used to keep track of IR raw clients, protected by ir_raw_client_lock */
+static DEFINE_MUTEX(ir_raw_client_lock);
 static LIST_HEAD(ir_raw_client_list);
 
 /* Used to handle IR raw handler extensions */
@@ -290,13 +291,6 @@ static int change_protocol(struct rc_dev *dev, u64 *rc_proto)
 	return 0;
 }
 
-static void ir_raw_disable_protocols(struct rc_dev *dev, u64 protocols)
-{
-	mutex_lock(&dev->lock);
-	dev->enabled_protocols &= ~protocols;
-	mutex_unlock(&dev->lock);
-}
-
 /**
  * ir_raw_gen_manchester() - Encode data with Manchester (bi-phase) modulation.
  * @ev:		Pointer to pointer to next free event. *@ev is incremented for
@@ -634,15 +628,18 @@ int ir_raw_event_register(struct rc_dev *dev)
 {
 	struct task_struct *thread;
 
+	/* Holding dev->lock could result in a dead-lock */
+	lockdep_assert_not_held(&dev->lock);
+
 	thread = kthread_run(ir_raw_event_thread, dev->raw, "rc%u", dev->minor);
 	if (IS_ERR(thread))
 		return PTR_ERR(thread);
 
 	dev->raw->thread = thread;
 
-	mutex_lock(&ir_raw_handler_lock);
+	mutex_lock(&ir_raw_client_lock);
 	list_add_tail(&dev->raw->list, &ir_raw_client_list);
-	mutex_unlock(&ir_raw_handler_lock);
+	mutex_unlock(&ir_raw_client_lock);
 
 	return 0;
 }
@@ -666,8 +663,10 @@ void ir_raw_event_unregister(struct rc_dev *dev)
 	kthread_stop(dev->raw->thread);
 	del_timer_sync(&dev->raw->edge_handle);
 
-	mutex_lock(&ir_raw_handler_lock);
+	mutex_lock(&ir_raw_client_lock);
 	list_del(&dev->raw->list);
+
+	mutex_lock(&ir_raw_handler_lock);
 	list_for_each_entry(handler, &ir_raw_handler_list, list)
 		if (handler->raw_unregister &&
 		    (handler->protocols & dev->enabled_protocols))
@@ -683,6 +682,8 @@ void ir_raw_event_unregister(struct rc_dev *dev)
 	 * "device gone" is checked.
 	 */
 	mutex_unlock(&ir_raw_handler_lock);
+
+	mutex_unlock(&ir_raw_client_lock);
 }
 
 /*
@@ -705,15 +706,24 @@ void ir_raw_handler_unregister(struct ir_raw_handler *ir_raw_handler)
 	struct ir_raw_event_ctrl *raw;
 	u64 protocols = ir_raw_handler->protocols;
 
+	mutex_lock(&ir_raw_client_lock);
+
 	mutex_lock(&ir_raw_handler_lock);
 	list_del(&ir_raw_handler->list);
+	atomic64_andnot(protocols, &available_protocols);
+	mutex_unlock(&ir_raw_handler_lock);
+
 	list_for_each_entry(raw, &ir_raw_client_list, list) {
+		mutex_lock(&raw->dev->lock);
+		mutex_lock(&ir_raw_handler_lock);
 		if (ir_raw_handler->raw_unregister &&
 		    (raw->dev->enabled_protocols & protocols))
 			ir_raw_handler->raw_unregister(raw->dev);
-		ir_raw_disable_protocols(raw->dev, protocols);
+		raw->dev->enabled_protocols &= ~protocols;
+		mutex_unlock(&ir_raw_handler_lock);
+		mutex_unlock(&raw->dev->lock);
 	}
-	atomic64_andnot(protocols, &available_protocols);
-	mutex_unlock(&ir_raw_handler_lock);
+
+	mutex_unlock(&ir_raw_client_lock);
 }
 EXPORT_SYMBOL(ir_raw_handler_unregister);
-- 
2.53.0



