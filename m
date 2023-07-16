Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71358F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:57:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6992DC433C7;
	Sun, 16 Jul 2023 20:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689541069;
	bh=EV7DvH5ohIoIrD7esThuyEXLGDjyXa+WMDw0jmVhzT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e5Ipe7vTvpZf0lYgyCVBL3OCGyJXQEtfQ2GqZUBpbD5KHTGHHSVo9nvSDhOKA8fDS
	 Dm8vdo2My2C4FKHsODoQzKamz0/NgBa0diSUwAGqih9qIR2UmJ8n+WmVx7J9Q8r3tb
	 AMTSLBkNjT37OfnJNrH5tw7sXzAVt9QZ5lRFftz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Manuel Leiner <manuel.leiner@gmx.de>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 589/591] wireguard: queueing: use saner cpu selection wrapping
Date: Sun, 16 Jul 2023 21:52:08 +0200
Message-ID: <20230716194939.089777417@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit 7387943fa35516f6f8017a3b0e9ce48a3bef9faa upstream.

Using `% nr_cpumask_bits` is slow and complicated, and not totally
robust toward dynamic changes to CPU topologies. Rather than storing the
next CPU in the round-robin, just store the last one, and also return
that value. This simplifies the loop drastically into a much more common
pattern.

Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Cc: stable@vger.kernel.org
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Tested-by: Manuel Leiner <manuel.leiner@gmx.de>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireguard/queueing.c |    1 +
 drivers/net/wireguard/queueing.h |   25 +++++++++++--------------
 drivers/net/wireguard/receive.c  |    2 +-
 drivers/net/wireguard/send.c     |    2 +-
 4 files changed, 14 insertions(+), 16 deletions(-)

--- a/drivers/net/wireguard/queueing.c
+++ b/drivers/net/wireguard/queueing.c
@@ -28,6 +28,7 @@ int wg_packet_queue_init(struct crypt_qu
 	int ret;
 
 	memset(queue, 0, sizeof(*queue));
+	queue->last_cpu = -1;
 	ret = ptr_ring_init(&queue->ring, len, GFP_KERNEL);
 	if (ret)
 		return ret;
--- a/drivers/net/wireguard/queueing.h
+++ b/drivers/net/wireguard/queueing.h
@@ -117,20 +117,17 @@ static inline int wg_cpumask_choose_onli
 	return cpu;
 }
 
-/* This function is racy, in the sense that next is unlocked, so it could return
- * the same CPU twice. A race-free version of this would be to instead store an
- * atomic sequence number, do an increment-and-return, and then iterate through
- * every possible CPU until we get to that index -- choose_cpu. However that's
- * a bit slower, and it doesn't seem like this potential race actually
- * introduces any performance loss, so we live with it.
+/* This function is racy, in the sense that it's called while last_cpu is
+ * unlocked, so it could return the same CPU twice. Adding locking or using
+ * atomic sequence numbers is slower though, and the consequences of racing are
+ * harmless, so live with it.
  */
-static inline int wg_cpumask_next_online(int *next)
+static inline int wg_cpumask_next_online(int *last_cpu)
 {
-	int cpu = *next;
-
-	while (unlikely(!cpumask_test_cpu(cpu, cpu_online_mask)))
-		cpu = cpumask_next(cpu, cpu_online_mask) % nr_cpumask_bits;
-	*next = cpumask_next(cpu, cpu_online_mask) % nr_cpumask_bits;
+	int cpu = cpumask_next(*last_cpu, cpu_online_mask);
+	if (cpu >= nr_cpu_ids)
+		cpu = cpumask_first(cpu_online_mask);
+	*last_cpu = cpu;
 	return cpu;
 }
 
@@ -159,7 +156,7 @@ static inline void wg_prev_queue_drop_pe
 
 static inline int wg_queue_enqueue_per_device_and_peer(
 	struct crypt_queue *device_queue, struct prev_queue *peer_queue,
-	struct sk_buff *skb, struct workqueue_struct *wq, int *next_cpu)
+	struct sk_buff *skb, struct workqueue_struct *wq)
 {
 	int cpu;
 
@@ -173,7 +170,7 @@ static inline int wg_queue_enqueue_per_d
 	/* Then we queue it up in the device queue, which consumes the
 	 * packet as soon as it can.
 	 */
-	cpu = wg_cpumask_next_online(next_cpu);
+	cpu = wg_cpumask_next_online(&device_queue->last_cpu);
 	if (unlikely(ptr_ring_produce_bh(&device_queue->ring, skb)))
 		return -EPIPE;
 	queue_work_on(cpu, wq, &per_cpu_ptr(device_queue->worker, cpu)->work);
--- a/drivers/net/wireguard/receive.c
+++ b/drivers/net/wireguard/receive.c
@@ -524,7 +524,7 @@ static void wg_packet_consume_data(struc
 		goto err;
 
 	ret = wg_queue_enqueue_per_device_and_peer(&wg->decrypt_queue, &peer->rx_queue, skb,
-						   wg->packet_crypt_wq, &wg->decrypt_queue.last_cpu);
+						   wg->packet_crypt_wq);
 	if (unlikely(ret == -EPIPE))
 		wg_queue_enqueue_per_peer_rx(skb, PACKET_STATE_DEAD);
 	if (likely(!ret || ret == -EPIPE)) {
--- a/drivers/net/wireguard/send.c
+++ b/drivers/net/wireguard/send.c
@@ -318,7 +318,7 @@ static void wg_packet_create_data(struct
 		goto err;
 
 	ret = wg_queue_enqueue_per_device_and_peer(&wg->encrypt_queue, &peer->tx_queue, first,
-						   wg->packet_crypt_wq, &wg->encrypt_queue.last_cpu);
+						   wg->packet_crypt_wq);
 	if (unlikely(ret == -EPIPE))
 		wg_queue_enqueue_per_peer_tx(first, PACKET_STATE_DEAD);
 err:


