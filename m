Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035197;
	b=jgPWFWQibFVHfbB8fdp8ne9kAh5ev6MkqSLuL70RPzOnJ8TZ2bx8lyvGY1H8r22ftZu1
	 WzupV1mWFWTv+3Q0UMr4BPARqrWOUgei3YioSIj4jldu0tH7rFX0lOfpS4kzt9Sqiu5Jw
	 8zYbq2tVCuisKHiaKwFcO2guxyJ05C4EJrw/BbyoUDWqnBb4Z+G/KQcVErYTX6vcc3T8i
	 KxAPeFGBDfK74EJ/I+jnftZVT2LqWIw57Kelu5T0C+clLUyPKvTREbcvEiIbuBpCXQqUU
	 fTNGKGGIbNr4XlsIGwXDrjfoDbOyhzMVtedx9TE/u5w06a7yDmahxx/oGtJ9iR+4LkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035197;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kbJmqpX2XpcGpvmYbEJgpCrdNsJrlOyOuTMFOyd7dbw=;
	b=w+FwJbIE3zYq9G96YciKVgUmK25tZ4AdN5KxdzYxYrtI1fLL2DY6LZUhu5Nm0mHPgNOD
	 y8ITSiWB8nAYi2fZg6+WYUftZNz/oW0MVCSG6mOQO3lL2rjhBLrgSARrZ+WKcF736JRHc
	 amRvnS+0i/Ve9QzjzAX8RkK1Z05+JQOpb+QjNAJzB1HPOF7wH++4Cv9ZhVRA+rXEYMHEl
	 J9DFRHbAodsOk3iNvO4ZITOgvMLzNWrhWbug7OqpFpOG9gjlxW3OGx/BFUeyMuZR0KDUU
	 XD4XlKUbsbkML8M65Kpbl2/kR1eQuTHmY4qiocBg956pLwH0OC6NWV/Z0X6SUi2nP5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0xa7PDqE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742F7606A31C;
	Wed, 18 Nov 2026 20:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0xa7PDqE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8237D1F000C4;
	Wed, 18 Nov 2026 20:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035197;
	bh=kbJmqpX2XpcGpvmYbEJgpCrdNsJrlOyOuTMFOyd7dbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0xa7PDqE+eyuissqa99P4E/osBfRHzCA/tVNAk6PMP3pzJwuIxCC5wh7PT2U/SFLI
	 /ggWhGhISxxl1v+Kx6C6k0pjiaHQWzTRlFq6KnEmfjj8MiG9WtzqViT6SJ1KmK+3gM
	 +GYZGN9sTZew1R+klM5dXbb2H3AsaoC3l131PkOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 0638/3318] media: rc: Fix ABBA deadlock by making locks more fine grained
Date: Wed, 18 Nov 2026 15:21:00 +0100
Message-ID: <20261118150337.075821838@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Young <sean@mess.org>

commit c6d68866ad8aa1e957a3e5a6ede971148f1e3d59 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/rc-ir-raw.c |   39 ++++++++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 15 deletions(-)

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
@@ -288,13 +289,6 @@ static int change_protocol(struct rc_dev
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
@@ -632,15 +626,18 @@ int ir_raw_event_register(struct rc_dev
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
@@ -673,16 +670,19 @@ void ir_raw_event_unregister(struct rc_d
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
 			handler->raw_unregister(dev);
 
 	lirc_bpf_free(dev);
-
 	mutex_unlock(&ir_raw_handler_lock);
+
+	mutex_unlock(&ir_raw_client_lock);
 }
 
 /*
@@ -705,15 +705,24 @@ void ir_raw_handler_unregister(struct ir
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


