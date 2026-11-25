Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625446;
	b=rMV6u8ISejaczxVODc+FjtCtLtL0Ao50ZgbneLpceRjJBVB3v0FHmF/TDdmHrPsFALBc
	 DfBBtncwZ2GFVWG+UGCgD4Tr6lp9oFuAVAm9T3NKpaEJ3mZ1a6lj33OO8Uj2MQoz1QBTk
	 3hqp1CyFLUNzePztuJltmoCFDnAlBngHjUNFeNIELAc2L8qGpjaPwTvgp5S48Is/08DPS
	 kAldEeu884JEMNAnHd2ym1GdjeRtUDwzFIAfpdOWddiAMRCrGiF494307BpQTf23TFJIY
	 xQvPgHnBTWzLKx2gN2zyBtMobbqhmfSSbvJJy+HaYC/ZSam3SqgcW3hS+lcREnN/1aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625446;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9IUpnfx51Mr+TsXyGweMuMzhX/LNu5i8fYC04ozdWbs=;
	b=3TOuMIwed4Ddlhq80K5Hx9v89SHhOYAnNqv231UBJBNrMjCfplzHaT/c8gFyt7mmAwwD
	 etdleGZCGYub2Jhyv1f1wonw3281AFwE88+pak48Ls2VTLgHLjhXdsmXLh5lv/31Y9pSQ
	 EwsInR/ngL88Zk6Hi8LWmo2Z5j7eIlgk7q3+kg1fs9jx5ykJMwpDxsUcYT5oChjAyKIGU
	 Q+HXEpQ6x33GwyxjLDwYHMsjE6JDrIhxn88eX9rdmJ8xbJarG2h5OybIYopEak/cx3/dM
	 10/7KxoxUHDjXRzD8yYXHo5BXQtw4DmHnvesbIupSyD7SmRlL4rtX8XXQRg0HBUBkRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hS5ambyB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408B8606A31E;
	Wed, 25 Nov 2026 16:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hS5ambyB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40E381F000CA;
	Wed, 25 Nov 2026 16:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625445;
	bh=9IUpnfx51Mr+TsXyGweMuMzhX/LNu5i8fYC04ozdWbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hS5ambyBZevJ1YJD48LExKVG1TJzTshulInLWrQraJ1x2yMf+cs1oHhj3N+c169SE
	 mUM1ZCKNiYO+74dma+9xTwSqjARBDzL/d3ocfkE2llt9pEVKRW23xmQwRNDYTKG/dH
	 Aw8PDcg1DmNs6R6OUlSeMyxIF5kIB5n+wCj9QjXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 512/816] bpf, cpumap: Hold the device of frames in the queue
Date: Wed, 25 Nov 2026 15:34:20 +0100
Message-ID: <20261125143901.036258011@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit f99351272933ba2e1221484a5e53b7a5d2c035f0 ]

A frame that is redirected to another CPU waits in the queue of the cpumap
entry with a plain pointer to the device it came from, and an skb from
generic XDP with skb->dev.  Nothing keeps that device.  Closing and
unregistering it waits for its NAPI and for RCU, but not for the kthread
of the entry.  If the kthread is late by more than that, since its CPU is
busy with something of a higher priority, it builds skbs for a device that
has been freed and hands them to the stack:

  BUG: KASAN: use-after-free in dev_gro_receive+0x1f51/0x2b30
  Read of size 8 at addr ffff88800a7340b0 by task cpumap/1/map:1/54

Take a reference to the device for each entry of the queue.  The kthread
cannot drop it at the end of the batch, since its GRO node may keep the skb
for longer.  Let it note the devices and drop the references behind a full
GRO flush, which it does whenever the queue is empty, and from now on also
when it has noted about 2048 of them.

A device whose frames are stuck in a queue is now unregistered only when
the kthread has got to them.  RTNL is not held meanwhile, but if the device
goes with its network namespace, the cleanup of all namespaces waits.

Fixes: 1c601d829ab0 ("bpf: cpumap xdp_buff to skb conversion and allocation")
Fixes: 11941f8a8536 ("bpf: cpumap: Implement generic cpumap")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017230950.802052-8-alexei.starovoitov@gmail.com
[ sashal: Sized the held-device array to CPUMAP_BATCH (8) instead of upstream's 2048, and drop the references right after netif_receive_skb_list(), since this tree's cpumap has no GRO. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/cpumap.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index a2f46785ac3b3..c3a994112a470 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -44,6 +44,7 @@
  */
 
 #define CPU_MAP_BULK_SIZE 8  /* 8 == one cacheline on 64-bit archs */
+#define CPUMAP_BATCH 8
 struct bpf_cpu_map_entry;
 struct bpf_cpu_map;
 
@@ -71,6 +72,13 @@ struct bpf_cpu_map_entry {
 
 	struct completion kthread_running;
 	struct rcu_work free_work;
+
+	/*
+	 * Every frame and skb in the queue holds a reference to its device.
+	 * The kthread keeps it until the batch has been handed to the stack.
+	 */
+	struct net_device *held[CPUMAP_BATCH];
+	u32 nr_held;
 };
 
 struct bpf_cpu_map {
@@ -126,9 +134,11 @@ static void __cpu_map_ring_cleanup(struct ptr_ring *ring)
 		WARN_ON_ONCE(1);
 		if (unlikely(__ptr_test_bit(0, &ptr))) {
 			__ptr_clear_bit(0, &ptr);
+			dev_put(((struct sk_buff *)ptr)->dev);
 			kfree_skb(ptr);
 			continue;
 		}
+		dev_put(((struct xdp_frame *)ptr)->dev_rx);
 		xdp_return_frame(ptr);
 	}
 }
@@ -232,8 +242,6 @@ static int cpu_map_bpf_prog_run_xdp(struct bpf_cpu_map_entry *rcpu,
 	return nframes;
 }
 
-#define CPUMAP_BATCH 8
-
 static int cpu_map_bpf_prog_run(struct bpf_cpu_map_entry *rcpu, void **frames,
 				int xdp_n, struct xdp_cpumap_stats *stats,
 				struct list_head *list)
@@ -314,10 +322,12 @@ static int cpu_map_kthread_run(void *data)
 				struct sk_buff *skb = f;
 
 				__ptr_clear_bit(0, &skb);
+				rcpu->held[rcpu->nr_held++] = skb->dev;
 				list_add_tail(&skb->list, &list);
 				continue;
 			}
 
+			rcpu->held[rcpu->nr_held++] = ((struct xdp_frame *)f)->dev_rx;
 			frames[xdp_n++] = f;
 			page = virt_to_page(f);
 
@@ -362,6 +372,8 @@ static int cpu_map_kthread_run(void *data)
 					 sched, &stats);
 
 		netif_receive_skb_list(&list);
+		while (rcpu->nr_held)
+			dev_put(rcpu->held[--rcpu->nr_held]);
 		local_bh_enable(); /* resched point, may call do_softirq() */
 	}
 	__set_current_state(TASK_RUNNING);
@@ -686,12 +698,14 @@ static void bq_flush_to_queue(struct xdp_bulk_queue *bq)
 
 	for (i = 0; i < bq->count; i++) {
 		struct xdp_frame *xdpf = bq->q[i];
-		int err;
 
-		err = __ptr_ring_produce(q, xdpf);
-		if (err) {
+		if (__ptr_ring_full(q)) {
 			drops++;
 			xdp_return_frame_rx_napi(xdpf);
+		} else {
+			/* The device cannot go before the flush, from now on it can */
+			dev_hold(xdpf->dev_rx);
+			__ptr_ring_produce(q, xdpf);
 		}
 		processed++;
 	}
@@ -749,11 +763,15 @@ int cpu_map_generic_redirect(struct bpf_cpu_map_entry *rcpu,
 
 	__skb_pull(skb, skb->mac_len);
 	skb_set_redirected(skb, false);
+	dev_hold(skb->dev);
 	__ptr_set_bit(0, &skb);
 
 	ret = ptr_ring_produce(rcpu->queue, skb);
-	if (ret < 0)
+	if (ret < 0) {
+		__ptr_clear_bit(0, &skb);
+		dev_put(skb->dev);
 		goto trace;
+	}
 
 	wake_up_process(rcpu->kthread);
 trace:
-- 
2.53.0



