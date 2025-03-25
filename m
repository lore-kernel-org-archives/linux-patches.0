Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1788267AEE;
	Tue, 25 Mar 2025 12:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905838; cv=none; b=CdeA4479sVUxqx9/TqaqcfAGpFmmsqxU6GtqqcJdswDQan/wkfiggLJTwKU+2rERGwehPYtFMwg0OloUFeaJjoKAQRtWwMUSbEKCPR1Uu8JH6FchmpIe6mJBDMCp+Xz77JaDaYey1auIwiDRsd/PY1OHv+c4Pia9IMPqUZgOmKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905838; c=relaxed/simple;
	bh=IX9Evmcz5mdJu5KQYfWk04UmCiTc1NrCj6MX9DrspB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LyaqaNtQLjXHcdXJTScYpnF8EQEkRGeIdlalv2mNr8WFwGzMavJBto1H5+8UO0H57CQ4qyXyQqRcMaCV1WeC+tJqXPDXCfof45s18L9yjsTBf8bA/FsMB+vjNVv7QI/GC/7laDKFG+1GyhJot/c7fVxCQDWZK5bjGUJLRT9AFnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nLBnEsju; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nLBnEsju"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DAE8C4CEE4;
	Tue, 25 Mar 2025 12:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905837;
	bh=IX9Evmcz5mdJu5KQYfWk04UmCiTc1NrCj6MX9DrspB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nLBnEsjuQteIxl217h+crBpPM33Bwlw6DxXQF050BVHAuxlOVjTtxWx5NgZkaZudr
	 bwYHHeHRIZz5FLakspoaRTASFDjhN8qB0vLcLiF0Q8TWhyaTAoqSLdGC6HuqwQ3icX
	 +EdcPe04sriE56bkLjF/moxmGes1n1i0aGWnhBfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Felix Moessbauer <felix.moessbauer@siemens.com>
Subject: [PATCH 6.1 190/198] netfilter: nft_counter: Use u64_stats_t for statistic.
Date: Tue, 25 Mar 2025 08:22:32 -0400
Message-ID: <20250325122201.634635061@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit 4a1d3acd6ea86075e77fcc1188c3fc372833ba73 upstream.

The nft_counter uses two s64 counters for statistics. Those two are
protected by a seqcount to ensure that the 64bit variable is always
properly seen during updates even on 32bit architectures where the store
is performed by two writes. A side effect is that the two counter (bytes
and packet) are written and read together in the same window.

This can be replaced with u64_stats_t. write_seqcount_begin()/ end() is
replaced with u64_stats_update_begin()/ end() and behaves the same way
as with seqcount_t on 32bit architectures. Additionally there is a
preempt_disable on PREEMPT_RT to ensure that a reader does not preempt a
writer.
On 64bit architectures the macros are removed and the reads happen
without any retries. This also means that the reader can observe one
counter (bytes) from before the update and the other counter (packets)
but that is okay since there is no requirement to have both counter from
the same update window.

Convert the statistic to u64_stats_t. There is one optimisation:
nft_counter_do_init() and nft_counter_clone() allocate a new per-CPU
counter and assign a value to it. During this assignment preemption is
disabled which is not needed because the counter is not yet exposed to
the system so there can not be another writer or reader. Therefore
disabling preemption is omitted and raw_cpu_ptr() is used to obtain a
pointer to a counter for the assignment.

Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Felix Moessbauer <felix.moessbauer@siemens.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_counter.c |   90 ++++++++++++++++++++++----------------------
 1 file changed, 46 insertions(+), 44 deletions(-)

--- a/net/netfilter/nft_counter.c
+++ b/net/netfilter/nft_counter.c
@@ -8,7 +8,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/seqlock.h>
+#include <linux/u64_stats_sync.h>
 #include <linux/netlink.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
@@ -17,6 +17,11 @@
 #include <net/netfilter/nf_tables_offload.h>
 
 struct nft_counter {
+	u64_stats_t	bytes;
+	u64_stats_t	packets;
+};
+
+struct nft_counter_tot {
 	s64		bytes;
 	s64		packets;
 };
@@ -25,25 +30,24 @@ struct nft_counter_percpu_priv {
 	struct nft_counter __percpu *counter;
 };
 
-static DEFINE_PER_CPU(seqcount_t, nft_counter_seq);
+static DEFINE_PER_CPU(struct u64_stats_sync, nft_counter_sync);
 
 static inline void nft_counter_do_eval(struct nft_counter_percpu_priv *priv,
 				       struct nft_regs *regs,
 				       const struct nft_pktinfo *pkt)
 {
+	struct u64_stats_sync *nft_sync;
 	struct nft_counter *this_cpu;
-	seqcount_t *myseq;
 
 	local_bh_disable();
 	this_cpu = this_cpu_ptr(priv->counter);
-	myseq = this_cpu_ptr(&nft_counter_seq);
-
-	write_seqcount_begin(myseq);
+	nft_sync = this_cpu_ptr(&nft_counter_sync);
 
-	this_cpu->bytes += pkt->skb->len;
-	this_cpu->packets++;
+	u64_stats_update_begin(nft_sync);
+	u64_stats_add(&this_cpu->bytes, pkt->skb->len);
+	u64_stats_inc(&this_cpu->packets);
+	u64_stats_update_end(nft_sync);
 
-	write_seqcount_end(myseq);
 	local_bh_enable();
 }
 
@@ -66,17 +70,16 @@ static int nft_counter_do_init(const str
 	if (cpu_stats == NULL)
 		return -ENOMEM;
 
-	preempt_disable();
-	this_cpu = this_cpu_ptr(cpu_stats);
+	this_cpu = raw_cpu_ptr(cpu_stats);
 	if (tb[NFTA_COUNTER_PACKETS]) {
-	        this_cpu->packets =
-			be64_to_cpu(nla_get_be64(tb[NFTA_COUNTER_PACKETS]));
+		u64_stats_set(&this_cpu->packets,
+			      be64_to_cpu(nla_get_be64(tb[NFTA_COUNTER_PACKETS])));
 	}
 	if (tb[NFTA_COUNTER_BYTES]) {
-		this_cpu->bytes =
-			be64_to_cpu(nla_get_be64(tb[NFTA_COUNTER_BYTES]));
+		u64_stats_set(&this_cpu->bytes,
+			      be64_to_cpu(nla_get_be64(tb[NFTA_COUNTER_BYTES])));
 	}
-	preempt_enable();
+
 	priv->counter = cpu_stats;
 	return 0;
 }
@@ -104,40 +107,41 @@ static void nft_counter_obj_destroy(cons
 }
 
 static void nft_counter_reset(struct nft_counter_percpu_priv *priv,
-			      struct nft_counter *total)
+			      struct nft_counter_tot *total)
 {
+	struct u64_stats_sync *nft_sync;
 	struct nft_counter *this_cpu;
-	seqcount_t *myseq;
 
 	local_bh_disable();
 	this_cpu = this_cpu_ptr(priv->counter);
-	myseq = this_cpu_ptr(&nft_counter_seq);
+	nft_sync = this_cpu_ptr(&nft_counter_sync);
+
+	u64_stats_update_begin(nft_sync);
+	u64_stats_add(&this_cpu->packets, -total->packets);
+	u64_stats_add(&this_cpu->bytes, -total->bytes);
+	u64_stats_update_end(nft_sync);
 
-	write_seqcount_begin(myseq);
-	this_cpu->packets -= total->packets;
-	this_cpu->bytes -= total->bytes;
-	write_seqcount_end(myseq);
 	local_bh_enable();
 }
 
 static void nft_counter_fetch(struct nft_counter_percpu_priv *priv,
-			      struct nft_counter *total)
+			      struct nft_counter_tot *total)
 {
 	struct nft_counter *this_cpu;
-	const seqcount_t *myseq;
 	u64 bytes, packets;
 	unsigned int seq;
 	int cpu;
 
 	memset(total, 0, sizeof(*total));
 	for_each_possible_cpu(cpu) {
-		myseq = per_cpu_ptr(&nft_counter_seq, cpu);
+		struct u64_stats_sync *nft_sync = per_cpu_ptr(&nft_counter_sync, cpu);
+
 		this_cpu = per_cpu_ptr(priv->counter, cpu);
 		do {
-			seq	= read_seqcount_begin(myseq);
-			bytes	= this_cpu->bytes;
-			packets	= this_cpu->packets;
-		} while (read_seqcount_retry(myseq, seq));
+			seq	= u64_stats_fetch_begin(nft_sync);
+			bytes	= u64_stats_read(&this_cpu->bytes);
+			packets	= u64_stats_read(&this_cpu->packets);
+		} while (u64_stats_fetch_retry(nft_sync, seq));
 
 		total->bytes	+= bytes;
 		total->packets	+= packets;
@@ -148,7 +152,7 @@ static int nft_counter_do_dump(struct sk
 			       struct nft_counter_percpu_priv *priv,
 			       bool reset)
 {
-	struct nft_counter total;
+	struct nft_counter_tot total;
 
 	nft_counter_fetch(priv, &total);
 
@@ -236,7 +240,7 @@ static int nft_counter_clone(struct nft_
 	struct nft_counter_percpu_priv *priv_clone = nft_expr_priv(dst);
 	struct nft_counter __percpu *cpu_stats;
 	struct nft_counter *this_cpu;
-	struct nft_counter total;
+	struct nft_counter_tot total;
 
 	nft_counter_fetch(priv, &total);
 
@@ -244,11 +248,9 @@ static int nft_counter_clone(struct nft_
 	if (cpu_stats == NULL)
 		return -ENOMEM;
 
-	preempt_disable();
-	this_cpu = this_cpu_ptr(cpu_stats);
-	this_cpu->packets = total.packets;
-	this_cpu->bytes = total.bytes;
-	preempt_enable();
+	this_cpu = raw_cpu_ptr(cpu_stats);
+	u64_stats_set(&this_cpu->packets, total.packets);
+	u64_stats_set(&this_cpu->bytes, total.bytes);
 
 	priv_clone->counter = cpu_stats;
 	return 0;
@@ -266,17 +268,17 @@ static void nft_counter_offload_stats(st
 				      const struct flow_stats *stats)
 {
 	struct nft_counter_percpu_priv *priv = nft_expr_priv(expr);
+	struct u64_stats_sync *nft_sync;
 	struct nft_counter *this_cpu;
-	seqcount_t *myseq;
 
 	local_bh_disable();
 	this_cpu = this_cpu_ptr(priv->counter);
-	myseq = this_cpu_ptr(&nft_counter_seq);
+	nft_sync = this_cpu_ptr(&nft_counter_sync);
 
-	write_seqcount_begin(myseq);
-	this_cpu->packets += stats->pkts;
-	this_cpu->bytes += stats->bytes;
-	write_seqcount_end(myseq);
+	u64_stats_update_begin(nft_sync);
+	u64_stats_add(&this_cpu->packets, stats->pkts);
+	u64_stats_add(&this_cpu->bytes, stats->bytes);
+	u64_stats_update_end(nft_sync);
 	local_bh_enable();
 }
 
@@ -285,7 +287,7 @@ void nft_counter_init_seqcount(void)
 	int cpu;
 
 	for_each_possible_cpu(cpu)
-		seqcount_init(per_cpu_ptr(&nft_counter_seq, cpu));
+		u64_stats_init(per_cpu_ptr(&nft_counter_sync, cpu));
 }
 
 struct nft_expr_type nft_counter_type;


