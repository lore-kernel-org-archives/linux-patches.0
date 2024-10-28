Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C8A15B10D;
	Mon, 28 Oct 2024 06:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097364; cv=none; b=fQTPQiwTQN3v6w7Rya5XkSTbXqdniTUu4D3xY8y5BYzhPcskUnT2jIXxIXR9hOfwl4+rmm58O4I/AsKBiuTvnqsBReZ11BV8qjXTLSs7b4mKYS/TbhmpH8MrRzXDrGzBQv45hvPV5sakYwRIBBaXHYgNoneJGfPxhd6rpRG0Kvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097364; c=relaxed/simple;
	bh=kOFQtrxy1srABEihrhCKzdULvYPMwkDzf2AJsrzbZZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lCZwM2QUD56jF6VTPWGvP0zH4rQjdHMIlvHdLI/BUCe4hUezSKiB+xLP+pL8qMbNVzGBT+CqWeMzH+pFpkl4i53Y3leS0H64sZxtv2iU2/JfFnNEhL1Yj7wrNqmxSMHAyQk23hSF83/oHvbAm+ktfiiLpEdgwARe9SqjfI36JL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IE/E0MIf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IE/E0MIf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDB64C4CEC3;
	Mon, 28 Oct 2024 06:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097364;
	bh=kOFQtrxy1srABEihrhCKzdULvYPMwkDzf2AJsrzbZZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IE/E0MIfxesqnC285yx9V4mhqlNFdKN8O2brFCG48FY1Mw+W9vvTlvuKjWy5GsaQj
	 OwlHgI72Er06G5TfUYPAnLxUsq9fVzoK+w6EEqFMkLrVrJs3ttw1koAbsu8GL76vWq
	 OyeP2RzkcK1QRe/ihSX1ozCCxMBzB9BS04o1cpDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 097/137] net: provide macros for commonly copied lockless queue stop/wake code
Date: Mon, 28 Oct 2024 07:25:34 +0100
Message-ID: <20241028062301.439299724@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit c91c46de6bbc1147ae5dfe046b87f5f3d6593215 ]

A lot of drivers follow the same scheme to stop / start queues
without introducing locks between xmit and NAPI tx completions.
I'm guessing they all copy'n'paste each other's code.
The original code dates back all the way to e1000 and Linux 2.6.19.

Smaller drivers shy away from the scheme and introduce a lock
which may cause deadlocks in netpoll.

Provide macros which encapsulate the necessary logic.

The macros do not prevent false wake ups, the extra barrier
required to close that race is not worth it. See discussion in:
https://lore.kernel.org/all/c39312a2-4537-14b4-270c-9fe1fbb91e89@gmail.com/

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 95ecba62e2fd ("net: fix races in netdev_tx_sent_queue()/dev_watchdog()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/networking/driver.rst |   6 ++
 include/linux/netdevice.h           |   1 +
 include/net/netdev_queues.h         | 144 ++++++++++++++++++++++++++++
 3 files changed, 151 insertions(+)
 create mode 100644 include/net/netdev_queues.h

diff --git a/Documentation/networking/driver.rst b/Documentation/networking/driver.rst
index 3040a74d421c7..870f933e4a1a1 100644
--- a/Documentation/networking/driver.rst
+++ b/Documentation/networking/driver.rst
@@ -67,6 +67,12 @@ and::
 	    TX_BUFFS_AVAIL(dp) > 0)
 		netif_wake_queue(dp->dev);
 
+Lockless queue stop / wake helper macros
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+.. kernel-doc:: include/net/netdev_queues.h
+   :doc: Lockless queue stopping / waking helpers.
+
 No exclusive ownership
 ----------------------
 
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 0373e09359905..8b67b266cce63 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3274,6 +3274,7 @@ static inline void netif_tx_wake_all_queues(struct net_device *dev)
 
 static __always_inline void netif_tx_stop_queue(struct netdev_queue *dev_queue)
 {
+	/* Must be an atomic op see netif_txq_try_stop() */
 	set_bit(__QUEUE_STATE_DRV_XOFF, &dev_queue->state);
 }
 
diff --git a/include/net/netdev_queues.h b/include/net/netdev_queues.h
new file mode 100644
index 0000000000000..5236d78bbdebb
--- /dev/null
+++ b/include/net/netdev_queues.h
@@ -0,0 +1,144 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_NET_QUEUES_H
+#define _LINUX_NET_QUEUES_H
+
+#include <linux/netdevice.h>
+
+/**
+ * DOC: Lockless queue stopping / waking helpers.
+ *
+ * The netif_txq_maybe_stop() and __netif_txq_completed_wake()
+ * macros are designed to safely implement stopping
+ * and waking netdev queues without full lock protection.
+ *
+ * We assume that there can be no concurrent stop attempts and no concurrent
+ * wake attempts. The try-stop should happen from the xmit handler,
+ * while wake up should be triggered from NAPI poll context.
+ * The two may run concurrently (single producer, single consumer).
+ *
+ * The try-stop side is expected to run from the xmit handler and therefore
+ * it does not reschedule Tx (netif_tx_start_queue() instead of
+ * netif_tx_wake_queue()). Uses of the ``stop`` macros outside of the xmit
+ * handler may lead to xmit queue being enabled but not run.
+ * The waking side does not have similar context restrictions.
+ *
+ * The macros guarantee that rings will not remain stopped if there's
+ * space available, but they do *not* prevent false wake ups when
+ * the ring is full! Drivers should check for ring full at the start
+ * for the xmit handler.
+ *
+ * All descriptor ring indexes (and other relevant shared state) must
+ * be updated before invoking the macros.
+ */
+
+#define netif_txq_try_stop(txq, get_desc, start_thrs)			\
+	({								\
+		int _res;						\
+									\
+		netif_tx_stop_queue(txq);				\
+		/* Producer index and stop bit must be visible		\
+		 * to consumer before we recheck.			\
+		 * Pairs with a barrier in __netif_txq_maybe_wake().	\
+		 */							\
+		smp_mb__after_atomic();					\
+									\
+		/* We need to check again in a case another		\
+		 * CPU has just made room available.			\
+		 */							\
+		_res = 0;						\
+		if (unlikely(get_desc >= start_thrs)) {			\
+			netif_tx_start_queue(txq);			\
+			_res = -1;					\
+		}							\
+		_res;							\
+	})								\
+
+/**
+ * netif_txq_maybe_stop() - locklessly stop a Tx queue, if needed
+ * @txq:	struct netdev_queue to stop/start
+ * @get_desc:	get current number of free descriptors (see requirements below!)
+ * @stop_thrs:	minimal number of available descriptors for queue to be left
+ *		enabled
+ * @start_thrs:	minimal number of descriptors to re-enable the queue, can be
+ *		equal to @stop_thrs or higher to avoid frequent waking
+ *
+ * All arguments may be evaluated multiple times, beware of side effects.
+ * @get_desc must be a formula or a function call, it must always
+ * return up-to-date information when evaluated!
+ * Expected to be used from ndo_start_xmit, see the comment on top of the file.
+ *
+ * Returns:
+ *	 0 if the queue was stopped
+ *	 1 if the queue was left enabled
+ *	-1 if the queue was re-enabled (raced with waking)
+ */
+#define netif_txq_maybe_stop(txq, get_desc, stop_thrs, start_thrs)	\
+	({								\
+		int _res;						\
+									\
+		_res = 1;						\
+		if (unlikely(get_desc < stop_thrs))			\
+			_res = netif_txq_try_stop(txq, get_desc, start_thrs); \
+		_res;							\
+	})								\
+
+
+/**
+ * __netif_txq_maybe_wake() - locklessly wake a Tx queue, if needed
+ * @txq:	struct netdev_queue to stop/start
+ * @get_desc:	get current number of free descriptors (see requirements below!)
+ * @start_thrs:	minimal number of descriptors to re-enable the queue
+ * @down_cond:	down condition, predicate indicating that the queue should
+ *		not be woken up even if descriptors are available
+ *
+ * All arguments may be evaluated multiple times.
+ * @get_desc must be a formula or a function call, it must always
+ * return up-to-date information when evaluated!
+ *
+ * Returns:
+ *	 0 if the queue was woken up
+ *	 1 if the queue was already enabled (or disabled but @down_cond is true)
+ *	-1 if the queue was left unchanged (@start_thrs not reached)
+ */
+#define __netif_txq_maybe_wake(txq, get_desc, start_thrs, down_cond)	\
+	({								\
+		int _res;						\
+									\
+		_res = -1;						\
+		if (likely(get_desc > start_thrs)) {			\
+			/* Make sure that anybody stopping the queue after \
+			 * this sees the new next_to_clean.		\
+			 */						\
+			smp_mb();					\
+			_res = 1;					\
+			if (unlikely(netif_tx_queue_stopped(txq)) &&	\
+			    !(down_cond)) {				\
+				netif_tx_wake_queue(txq);		\
+				_res = 0;				\
+			}						\
+		}							\
+		_res;							\
+	})
+
+#define netif_txq_maybe_wake(txq, get_desc, start_thrs)		\
+	__netif_txq_maybe_wake(txq, get_desc, start_thrs, false)
+
+/* subqueue variants follow */
+
+#define netif_subqueue_try_stop(dev, idx, get_desc, start_thrs)		\
+	({								\
+		struct netdev_queue *txq;				\
+									\
+		txq = netdev_get_tx_queue(dev, idx);			\
+		netif_txq_try_stop(txq, get_desc, start_thrs);		\
+	})
+
+#define netif_subqueue_maybe_stop(dev, idx, get_desc, stop_thrs, start_thrs) \
+	({								\
+		struct netdev_queue *txq;				\
+									\
+		txq = netdev_get_tx_queue(dev, idx);			\
+		netif_txq_maybe_stop(txq, get_desc, stop_thrs, start_thrs); \
+	})
+
+#endif
-- 
2.43.0



