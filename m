Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044824;
	b=hG9hb/lqy754JazErATKbGbVN+tsTTcJp98E8+7HrGvDvFOXNCXDiPxASMtS7RDItkgp
	 WceoE99yRj3apQozc9mSP6diz+CU5M+L3DYNqDAhJKC9bVgzsmQI2MwS8CDJnJLLyG2bW
	 BrYX+memS895/aAI+JIutNHuCzE3GwS0dTlEGYry9eMIeGGxU3DRz82iqFpyxQ7IBNiVx
	 lZutvk/u/dgBIxsUxkmEK+/lPg2kTOM3Z/paA7M4ssQ3SVInsflhfojtBDepk1JcU6Zsn
	 ONvu3df+svCNKmgD5gK57FOB0pbrZyNqh3Bcuaea8xMrxw6iYf2svTMs54j/Z7FdmrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044824;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TKM8z9GdZAwOL6vt3O5PPrAc8kV/IK5DUGu19nmolIU=;
	b=CYb9b8SpgVEk5549RzcrHycHdiqJ/TUlQbX4Gu2S/kefQzmA0HuhbqH7rdax5EqdbCeR
	 rqwW9pNttAbGRgei3xQ/3okSQ2qzeYB9Ws35+lYfCIfElADYN+yiM8pPhp8IY2CWHNUT9
	 DoMfMO6902v8XcUQ5F0r0lbygMtEl1aWLxVIHwgpOXVCNXps4qDXLYRKspY9rZC3Um4RF
	 Owrg4dybG2007M4tiBCm46bS1WayM1c3jrjawnTyIIxgVOjz37pkHtXK2GqIBAxtSj9+u
	 o15EovWp3UxmrMREnMoCvW6nWiYxuG+l5qk3lMkaI3dVrJOfPUmMgHSevWdtyLjVWrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g7ZoAyxL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A1260A263D;
	Wed, 18 Nov 2026 23:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g7ZoAyxL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 002DF1F000C5;
	Wed, 18 Nov 2026 23:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044824;
	bh=TKM8z9GdZAwOL6vt3O5PPrAc8kV/IK5DUGu19nmolIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g7ZoAyxLb3JbPMqGeWpJigCv4epI1WE0I8uIwlhuBbaD12Lj3UVLVWBoXEph9ow/c
	 mvUQJ/gnmaMDtxcs1xZYI6I8PwMjyu2yiGkWFYJK7I/tf1gK3BfLOYTVhybIdnGIWx
	 XsJiUczuKeb8Ju8VmXtaEh9nj0Tm5zCk57ZsYYH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0705/2857] media: rc: Fix ABBA deadlock by making locks more fine grained
Date: Wed, 18 Nov 2026 15:28:59 +0100
Message-ID: <20261118150226.938074069@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Retained ir_raw_event_free(dev) before releasing ir_raw_handler_lock to preserve the existing cleanup layout. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/rc-ir-raw.c | 38 +++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index 16e33d7eaaa2d..d1c551aec63ca 100644
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
@@ -288,13 +289,6 @@ static int change_protocol(struct rc_dev *dev, u64 *rc_proto)
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
@@ -632,15 +626,18 @@ int ir_raw_event_register(struct rc_dev *dev)
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
@@ -664,8 +661,10 @@ void ir_raw_event_unregister(struct rc_dev *dev)
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
@@ -681,6 +680,8 @@ void ir_raw_event_unregister(struct rc_dev *dev)
 	 * "device gone" is checked.
 	 */
 	mutex_unlock(&ir_raw_handler_lock);
+
+	mutex_unlock(&ir_raw_client_lock);
 }
 
 /*
@@ -703,15 +704,24 @@ void ir_raw_handler_unregister(struct ir_raw_handler *ir_raw_handler)
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



