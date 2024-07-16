Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764C419E7E8;
	Tue, 16 Jul 2024 15:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144866; cv=none; b=QKM2Bw9hWsNRfp3ydw8d0oFSYMwxLCaL0wEbDyS1gbHIyNxUwEFUelMR7gf14Dx2aCUOU7I52tQ/4QqflsD4bqnTFpADuwo+YfL4JOQIv4bLZqXXmM2Tz/hV7pn4xK3p3AhPy1bI98DHBt9CqbtuBiknciMjSBlWV/DzGnJ2PG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144866; c=relaxed/simple;
	bh=T7bJbNRJWEKFPcoRGk673TXAsgUbHNiX6PPBsKej+P8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hY2zwlQl0vL5+TXok7QTEDjZFEJRQBybM32aLKRahx8fo5+j/XXeLZrbm/4dY2TXbYkPm7sLgQQfE9VQ5atjFNGFNPWJ3Gqq9DfiwF/KvqqzsWEesV3cotcTgij/ufnCuj4bGopO7EKNyf2ZkzhlnBiOqpnr0EGpkPbkQeO4uSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ui8wCIYI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ui8wCIYI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C5A9C116B1;
	Tue, 16 Jul 2024 15:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144866;
	bh=T7bJbNRJWEKFPcoRGk673TXAsgUbHNiX6PPBsKej+P8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ui8wCIYI2p7Ld8CxTZs0gLv0h34JGCG6yorVoVTWM9X5rmFWZUgswBsCy7ZC8AXZD
	 uweb4NwLm2hbSjt9lptzDeHYYsYAMB21IQV+NriWo0XTOEvp71d2DKc7N19twrkzQR
	 K4TAX1lvQ4YuovVTo06MgHJpARbAUAlbclfEi1xY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pedro Pinto <xten@osec.io>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Hyunwoo Kim <v4bel@theori.io>,
	Wongi Lee <qwerty@theori.io>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 021/143] bpf: Fix too early release of tcx_entry
Date: Tue, 16 Jul 2024 17:30:17 +0200
Message-ID: <20240716152756.805773143@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 1cb6f0bae50441f4b4b32a28315853b279c7404e ]

Pedro Pinto and later independently also Hyunwoo Kim and Wongi Lee reported
an issue that the tcx_entry can be released too early leading to a use
after free (UAF) when an active old-style ingress or clsact qdisc with a
shared tc block is later replaced by another ingress or clsact instance.

Essentially, the sequence to trigger the UAF (one example) can be as follows:

  1. A network namespace is created
  2. An ingress qdisc is created. This allocates a tcx_entry, and
     &tcx_entry->miniq is stored in the qdisc's miniqp->p_miniq. At the
     same time, a tcf block with index 1 is created.
  3. chain0 is attached to the tcf block. chain0 must be connected to
     the block linked to the ingress qdisc to later reach the function
     tcf_chain0_head_change_cb_del() which triggers the UAF.
  4. Create and graft a clsact qdisc. This causes the ingress qdisc
     created in step 1 to be removed, thus freeing the previously linked
     tcx_entry:

     rtnetlink_rcv_msg()
       => tc_modify_qdisc()
         => qdisc_create()
           => clsact_init() [a]
         => qdisc_graft()
           => qdisc_destroy()
             => __qdisc_destroy()
               => ingress_destroy() [b]
                 => tcx_entry_free()
                   => kfree_rcu() // tcx_entry freed

  5. Finally, the network namespace is closed. This registers the
     cleanup_net worker, and during the process of releasing the
     remaining clsact qdisc, it accesses the tcx_entry that was
     already freed in step 4, causing the UAF to occur:

     cleanup_net()
       => ops_exit_list()
         => default_device_exit_batch()
           => unregister_netdevice_many()
             => unregister_netdevice_many_notify()
               => dev_shutdown()
                 => qdisc_put()
                   => clsact_destroy() [c]
                     => tcf_block_put_ext()
                       => tcf_chain0_head_change_cb_del()
                         => tcf_chain_head_change_item()
                           => clsact_chain_head_change()
                             => mini_qdisc_pair_swap() // UAF

There are also other variants, the gist is to add an ingress (or clsact)
qdisc with a specific shared block, then to replace that qdisc, waiting
for the tcx_entry kfree_rcu() to be executed and subsequently accessing
the current active qdisc's miniq one way or another.

The correct fix is to turn the miniq_active boolean into a counter. What
can be observed, at step 2 above, the counter transitions from 0->1, at
step [a] from 1->2 (in order for the miniq object to remain active during
the replacement), then in [b] from 2->1 and finally [c] 1->0 with the
eventual release. The reference counter in general ranges from [0,2] and
it does not need to be atomic since all access to the counter is protected
by the rtnl mutex. With this in place, there is no longer a UAF happening
and the tcx_entry is freed at the correct time.

Fixes: e420bed02507 ("bpf: Add fd-based tcx multi-prog infra with link support")
Reported-by: Pedro Pinto <xten@osec.io>
Co-developed-by: Pedro Pinto <xten@osec.io>
Signed-off-by: Pedro Pinto <xten@osec.io>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Hyunwoo Kim <v4bel@theori.io>
Cc: Wongi Lee <qwerty@theori.io>
Cc: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://lore.kernel.org/r/20240708133130.11609-1-daniel@iogearbox.net
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tcx.h       | 13 +++++++++----
 net/sched/sch_ingress.c | 12 ++++++------
 2 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/include/net/tcx.h b/include/net/tcx.h
index 04be9377785d7..0a5f40a91c42f 100644
--- a/include/net/tcx.h
+++ b/include/net/tcx.h
@@ -13,7 +13,7 @@ struct mini_Qdisc;
 struct tcx_entry {
 	struct mini_Qdisc __rcu *miniq;
 	struct bpf_mprog_bundle bundle;
-	bool miniq_active;
+	u32 miniq_active;
 	struct rcu_head rcu;
 };
 
@@ -124,11 +124,16 @@ static inline void tcx_skeys_dec(bool ingress)
 	tcx_dec();
 }
 
-static inline void tcx_miniq_set_active(struct bpf_mprog_entry *entry,
-					const bool active)
+static inline void tcx_miniq_inc(struct bpf_mprog_entry *entry)
 {
 	ASSERT_RTNL();
-	tcx_entry(entry)->miniq_active = active;
+	tcx_entry(entry)->miniq_active++;
+}
+
+static inline void tcx_miniq_dec(struct bpf_mprog_entry *entry)
+{
+	ASSERT_RTNL();
+	tcx_entry(entry)->miniq_active--;
 }
 
 static inline bool tcx_entry_is_active(struct bpf_mprog_entry *entry)
diff --git a/net/sched/sch_ingress.c b/net/sched/sch_ingress.c
index c2ef9dcf91d2d..cc6051d4f2ef8 100644
--- a/net/sched/sch_ingress.c
+++ b/net/sched/sch_ingress.c
@@ -91,7 +91,7 @@ static int ingress_init(struct Qdisc *sch, struct nlattr *opt,
 	entry = tcx_entry_fetch_or_create(dev, true, &created);
 	if (!entry)
 		return -ENOMEM;
-	tcx_miniq_set_active(entry, true);
+	tcx_miniq_inc(entry);
 	mini_qdisc_pair_init(&q->miniqp, sch, &tcx_entry(entry)->miniq);
 	if (created)
 		tcx_entry_update(dev, entry, true);
@@ -121,7 +121,7 @@ static void ingress_destroy(struct Qdisc *sch)
 	tcf_block_put_ext(q->block, sch, &q->block_info);
 
 	if (entry) {
-		tcx_miniq_set_active(entry, false);
+		tcx_miniq_dec(entry);
 		if (!tcx_entry_is_active(entry)) {
 			tcx_entry_update(dev, NULL, true);
 			tcx_entry_free(entry);
@@ -257,7 +257,7 @@ static int clsact_init(struct Qdisc *sch, struct nlattr *opt,
 	entry = tcx_entry_fetch_or_create(dev, true, &created);
 	if (!entry)
 		return -ENOMEM;
-	tcx_miniq_set_active(entry, true);
+	tcx_miniq_inc(entry);
 	mini_qdisc_pair_init(&q->miniqp_ingress, sch, &tcx_entry(entry)->miniq);
 	if (created)
 		tcx_entry_update(dev, entry, true);
@@ -276,7 +276,7 @@ static int clsact_init(struct Qdisc *sch, struct nlattr *opt,
 	entry = tcx_entry_fetch_or_create(dev, false, &created);
 	if (!entry)
 		return -ENOMEM;
-	tcx_miniq_set_active(entry, true);
+	tcx_miniq_inc(entry);
 	mini_qdisc_pair_init(&q->miniqp_egress, sch, &tcx_entry(entry)->miniq);
 	if (created)
 		tcx_entry_update(dev, entry, false);
@@ -302,7 +302,7 @@ static void clsact_destroy(struct Qdisc *sch)
 	tcf_block_put_ext(q->egress_block, sch, &q->egress_block_info);
 
 	if (ingress_entry) {
-		tcx_miniq_set_active(ingress_entry, false);
+		tcx_miniq_dec(ingress_entry);
 		if (!tcx_entry_is_active(ingress_entry)) {
 			tcx_entry_update(dev, NULL, true);
 			tcx_entry_free(ingress_entry);
@@ -310,7 +310,7 @@ static void clsact_destroy(struct Qdisc *sch)
 	}
 
 	if (egress_entry) {
-		tcx_miniq_set_active(egress_entry, false);
+		tcx_miniq_dec(egress_entry);
 		if (!tcx_entry_is_active(egress_entry)) {
 			tcx_entry_update(dev, NULL, false);
 			tcx_entry_free(egress_entry);
-- 
2.43.0



