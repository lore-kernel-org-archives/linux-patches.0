Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20DFF37754D;
	Wed, 20 May 2026 17:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296942; cv=none; b=iSGmVaT7pbzHhuELCTdAUOskdhbueCMKTF/q3ASmFJd9bcURsPENYCoqn+AUAgISVvWmSFWClFxTanXFqv8fcDc9se5pWktv+sl9VQJxcLvBYdzDYixo2V2Z7axWg8N/hwM4tmuD+Dx1aW5Ano5Fk533rnaoPb8xQkOeFymWO64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296942; c=relaxed/simple;
	bh=suITRy1kBr/HpxfUWm2cY+Rb8eMPN6wx5WZDgEac2+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZbkP7FFSuBgOszgQfY4/yNhRzw177vtHT4A33NLMjNtXM08OHAGhckVh0VVlxfPsvqINIc2cWVJsErqLCc+k5BG/p+XSneZ6gU/ecwodW0R0fKqxJckAvSHkcVNxh3aK5y/WVEmsNfxhKD2gP6Ck/AA7GZQT3ab7NOzj7gNd6G4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OeCpMUgy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OeCpMUgy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AECDA1F000E9;
	Wed, 20 May 2026 17:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296941;
	bh=uHnrM70um2b/0qjO6h+AUupfzMMZAFPQf8ycqonXsIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OeCpMUgy9TJQYzXrciq3GSsAJI52oc1vbE/N9qiTfrlDyoewPJyr1fKrrJPu2ZQ0O
	 97kyS6EH4h/uGM6vGawpS1BfeA0I/QWcfRW6D+qHxBxvvJiObmomQjX8R2euK8gvHk
	 O8QCgq6pyggD9JgHA7H2iIZqLU0AVmk+geeI73vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0989/1146] net/sched: sch_cake: annotate data-races in cake_dump_stats() (I)
Date: Wed, 20 May 2026 18:20:39 +0200
Message-ID: <20260520162210.614190797@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 44967ac3785ebef6442377708925181d4a0eb1c8 ]

cake_dump_stats() runs without qdisc spinlock being held.

In this first patch, I add READ_ONCE()/WRITE_ONCE() annotations
for the following fields:

- way_hits
- way_misses
- way_collisions
- sparse_flow_count
- decaying_flow_count

Other annotations are added in following patches, to ease code review.

Fixes: 046f6fd5daef ("sched: Add Common Applications Kept Enhanced (cake) qdisc")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: "Toke Høiland-Jørgensen" <toke@toke.dk>
Link: https://patch.msgid.link/20260427083606.459355-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_cake.c | 42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index 4ac6c36ca6e41..ac82fe7aafcb3 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -813,7 +813,7 @@ static u32 cake_hash(struct cake_tin_data *q, const struct sk_buff *skb,
 		     i++, k = (k + 1) % CAKE_SET_WAYS) {
 			if (q->tags[outer_hash + k] == flow_hash) {
 				if (i)
-					q->way_hits++;
+					WRITE_ONCE(q->way_hits, q->way_hits + 1);
 
 				if (!q->flows[outer_hash + k].set) {
 					/* need to increment host refcnts */
@@ -831,7 +831,7 @@ static u32 cake_hash(struct cake_tin_data *q, const struct sk_buff *skb,
 		for (i = 0; i < CAKE_SET_WAYS;
 			 i++, k = (k + 1) % CAKE_SET_WAYS) {
 			if (!q->flows[outer_hash + k].set) {
-				q->way_misses++;
+				WRITE_ONCE(q->way_misses, q->way_misses + 1);
 				allocate_src = cake_dsrc(flow_mode);
 				allocate_dst = cake_ddst(flow_mode);
 				goto found;
@@ -841,7 +841,7 @@ static u32 cake_hash(struct cake_tin_data *q, const struct sk_buff *skb,
 		/* With no empty queues, default to the original
 		 * queue, accept the collision, update the host tags.
 		 */
-		q->way_collisions++;
+		WRITE_ONCE(q->way_collisions, q->way_collisions + 1);
 		allocate_src = cake_dsrc(flow_mode);
 		allocate_dst = cake_ddst(flow_mode);
 
@@ -1917,11 +1917,11 @@ static s32 cake_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		if (!flow->set) {
 			list_add_tail(&flow->flowchain, &b->new_flows);
 		} else {
-			b->decaying_flow_count--;
+			WRITE_ONCE(b->decaying_flow_count, b->decaying_flow_count - 1);
 			list_move_tail(&flow->flowchain, &b->new_flows);
 		}
 		flow->set = CAKE_SET_SPARSE;
-		b->sparse_flow_count++;
+		WRITE_ONCE(b->sparse_flow_count, b->sparse_flow_count + 1);
 
 		flow->deficit = cake_get_flow_quantum(b, flow, q->config->flow_mode);
 	} else if (flow->set == CAKE_SET_SPARSE_WAIT) {
@@ -1929,7 +1929,7 @@ static s32 cake_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		 * in the bulk rotation.
 		 */
 		flow->set = CAKE_SET_BULK;
-		b->sparse_flow_count--;
+		WRITE_ONCE(b->sparse_flow_count, b->sparse_flow_count - 1);
 		b->bulk_flow_count++;
 
 		cake_inc_srchost_bulk_flow_count(b, flow, q->config->flow_mode);
@@ -2149,7 +2149,7 @@ static struct sk_buff *cake_dequeue(struct Qdisc *sch)
 		 */
 		if (flow->set == CAKE_SET_SPARSE) {
 			if (flow->head) {
-				b->sparse_flow_count--;
+				WRITE_ONCE(b->sparse_flow_count, b->sparse_flow_count - 1);
 				b->bulk_flow_count++;
 
 				cake_inc_srchost_bulk_flow_count(b, flow, q->config->flow_mode);
@@ -2192,27 +2192,27 @@ static struct sk_buff *cake_dequeue(struct Qdisc *sch)
 					cake_dec_srchost_bulk_flow_count(b, flow, q->config->flow_mode);
 					cake_dec_dsthost_bulk_flow_count(b, flow, q->config->flow_mode);
 
-					b->decaying_flow_count++;
+					WRITE_ONCE(b->decaying_flow_count, b->decaying_flow_count + 1);
 				} else if (flow->set == CAKE_SET_SPARSE ||
 					   flow->set == CAKE_SET_SPARSE_WAIT) {
-					b->sparse_flow_count--;
-					b->decaying_flow_count++;
+					WRITE_ONCE(b->sparse_flow_count, b->sparse_flow_count - 1);
+					WRITE_ONCE(b->decaying_flow_count, b->decaying_flow_count + 1);
 				}
 				flow->set = CAKE_SET_DECAYING;
 			} else {
 				/* remove empty queue from the flowchain */
 				list_del_init(&flow->flowchain);
 				if (flow->set == CAKE_SET_SPARSE ||
-				    flow->set == CAKE_SET_SPARSE_WAIT)
-					b->sparse_flow_count--;
-				else if (flow->set == CAKE_SET_BULK) {
+				    flow->set == CAKE_SET_SPARSE_WAIT) {
+					WRITE_ONCE(b->sparse_flow_count, b->sparse_flow_count - 1);
+				} else if (flow->set == CAKE_SET_BULK) {
 					b->bulk_flow_count--;
 
 					cake_dec_srchost_bulk_flow_count(b, flow, q->config->flow_mode);
 					cake_dec_dsthost_bulk_flow_count(b, flow, q->config->flow_mode);
-				} else
-					b->decaying_flow_count--;
-
+				} else {
+					WRITE_ONCE(b->decaying_flow_count, b->decaying_flow_count - 1);
+				}
 				flow->set = CAKE_SET_NONE;
 			}
 			goto begin;
@@ -3050,12 +3050,12 @@ static int cake_dump_stats(struct Qdisc *sch, struct gnet_dump *d)
 		PUT_TSTAT_U32(BASE_DELAY_US,
 			      ktime_to_us(ns_to_ktime(b->base_delay)));
 
-		PUT_TSTAT_U32(WAY_INDIRECT_HITS, b->way_hits);
-		PUT_TSTAT_U32(WAY_MISSES, b->way_misses);
-		PUT_TSTAT_U32(WAY_COLLISIONS, b->way_collisions);
+		PUT_TSTAT_U32(WAY_INDIRECT_HITS, READ_ONCE(b->way_hits));
+		PUT_TSTAT_U32(WAY_MISSES, READ_ONCE(b->way_misses));
+		PUT_TSTAT_U32(WAY_COLLISIONS, READ_ONCE(b->way_collisions));
 
-		PUT_TSTAT_U32(SPARSE_FLOWS, b->sparse_flow_count +
-					    b->decaying_flow_count);
+		PUT_TSTAT_U32(SPARSE_FLOWS, READ_ONCE(b->sparse_flow_count) +
+					    READ_ONCE(b->decaying_flow_count));
 		PUT_TSTAT_U32(BULK_FLOWS, b->bulk_flow_count);
 		PUT_TSTAT_U32(UNRESPONSIVE_FLOWS, b->unresponsive_flow_count);
 		PUT_TSTAT_U32(MAX_SKBLEN, b->max_skblen);
-- 
2.53.0



