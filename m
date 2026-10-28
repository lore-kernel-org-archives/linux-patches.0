Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215535;
	b=tGU/JpcofTiJJSnztO40S/mZG/05d+9GNnhocFVB+xES5UD4ctMOd7lYNympLB7ZCCPU
	 AiDQakMnThaoPaQAS3t8WhtNv/UonaoKI+SYoMxKoL3WnAUxyegFMp8a/Q5MmwlAz8GeA
	 8K/rhnJzSHyol4lZbrJcHW6qEDShGKEZ0+wH6MlbH/Nut4rISoDdl8rf0a1BthS2GGtlB
	 Z0qaglwPKMN8eBsw07uRBTXURljaBgzovSchNZ2kfeMxKq9T/pQKWyhdCQZZGKJtlHboM
	 lTktLkFXBu0sIRyR5Kk6V0/qJbutHEQEcM3DKYITcCDQxMye1CFO3Z5vItoJAVbM4GQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215535;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R4YCNfjNyMfFhtIhy58xfwNqV4/2F0BhgAZHeaW2ZgA=;
	b=OdysLEbJgx7k2JeshXaBdKOhxafdGIJoiOkZWhpTtgBYUjuYzqxnq852lBW5HKi4D9qI
	 uNHFnsSbf+vuBApBLexgFBToqHhPBpK06CZzMRbPZX3mA0Q43sGvKQXHR5znMBpzLLnyK
	 XVPMPrWiKbJC5ER/DWLoCqeSEHzY2PP34u8rb4u63wTsYHRzpHRQpTtL83GgaHesWv0EO
	 vhS5/cdGS+qWUe1HK6U8FuqiiyhRqj/I5Pg87e1bCKZj4DT687737qBWAobuBa2NMpnCQ
	 o2k0/FR+tbrP2CTSZE0sFw0Lz9eJQ0HNE37P6jpGwDpPTkOdHddrX/fRk3dPaDYj5cQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hzB969W6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59724606A31A;
	Wed, 28 Oct 2026 19:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hzB969W6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B93C1F01825;
	Wed, 28 Oct 2026 19:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215535;
	bh=R4YCNfjNyMfFhtIhy58xfwNqV4/2F0BhgAZHeaW2ZgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hzB969W6SEIWXUDl1QV+KNZCCcjIQ1uHRg20i7lYGrXmqxhz4aTihVwyBMVa02DNv
	 nlUMPlAcfq+yY2hDR/RBXfxNGyIXRE88TG0xSSfMSivJ/7VfpGo6Z7BywnDbS9ahtm
	 w08xSNEglGhOgQ4hOmeXv3LlV2WNXA1bvzSiQhKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zdi-disclosures@trendmicro.com,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1227/1887] net/sched: act_pedit: fix TOCTOU heap OOB write in tc offload
Date: Wed, 28 Oct 2026 17:55:23 +0100
Message-ID: <20261028170527.346361988@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit 8b519cbcabe836a441369fbec1a8a6518a709251 ]

There is a TOCTOU race condition in flower lockless approach between sizing
a flow_rule buffer and filling it.
zdi-disclosures@trendmicro.com reports:
The cls_flower classifier operates with TCF_PROTO_OPS_DOIT_UNLOCKED
(fl_change runs without RTNL), while RTM_NEWACTION holds RTNL, so the
independent locking domains make the race reachable in practice.  KASAN
confirms:
  BUG: KASAN: slab-out-of-bounds in tcf_pedit_offload_act_setup+0x81b/0x930
  Write of size 4 at addr ffff888001f27520 by task poc-toctou/312
  The buggy address is located 0 bytes to the right of
   allocated 288-byte region [ffff888001f27400, ffff888001f27520)
   (cache kmalloc-512)

Note: The result is a heap OOB write attacker-controlled content into the
adjacent slab object (requires CAP_NET_ADMIN).

The fix introduces reading tcfp_nkeys under act->tcfa_lock in all places
using a new tcf_pedit_nkeys_locked() which replaces the old tcf_pedit_nkeys().
Additionally we close the remaining TOCTOU window between the sizing read and
the fill reads by more careful accounting.
Rather than silently truncating the key count, which leads to incorrect
action semantics offloaded to hardware and secondary OOB writes if
the remaining capacity is zero or consumed by prior actions, we enforce
remaining capacity checks and return -ENOSPC if the required space exceeds
the remaining capacity.

Fixes: 71d0ed7079df ("net/act_pedit: Support using offset relative to the conventional network headers")
Reported-by: zdi-disclosures@trendmicro.com
Tested-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20260701161912.125355-1-jhs@mojatatu.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tc_act/tc_pedit.h | 18 ++++++++----------
 net/sched/act_api.c           | 13 +++++++++----
 net/sched/act_pedit.c         | 11 ++++++++++-
 net/sched/cls_api.c           | 22 +++++++++++++++++-----
 4 files changed, 44 insertions(+), 20 deletions(-)

diff --git a/include/net/tc_act/tc_pedit.h b/include/net/tc_act/tc_pedit.h
index a26d4cd3b8d6f..fa4cd4fc36740 100644
--- a/include/net/tc_act/tc_pedit.h
+++ b/include/net/tc_act/tc_pedit.h
@@ -36,17 +36,15 @@ static inline bool is_tcf_pedit(const struct tc_action *a)
 	return false;
 }
 
-static inline int tcf_pedit_nkeys(const struct tc_action *a)
+/* Must be called with act->tcfa_lock held to ensure consistency of parallel
+ * reads of the same action's pedit keys (e.g. flow_offload count vs fill).
+ * Note, this is only used for pedit offload.
+ */
+static inline int tcf_pedit_nkeys_locked(const struct tc_action *a)
 {
-	struct tcf_pedit_parms *parms;
-	int nkeys;
-
-	rcu_read_lock();
-	parms = to_pedit_parms(a);
-	nkeys = parms->tcfp_nkeys;
-	rcu_read_unlock();
-
-	return nkeys;
+	lockdep_assert_held(&a->tcfa_lock);
+	return rcu_dereference_protected(to_pedit(a)->parms,
+					 lockdep_is_held(&a->tcfa_lock))->tcfp_nkeys;
 }
 
 static inline u32 tcf_pedit_htype(const struct tc_action *a, int index)
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 8aa291b835e9b..a24e8327e7e7b 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -147,10 +147,15 @@ static void offload_action_hw_count_dec(struct tc_action *act,
 
 static unsigned int tcf_offload_act_num_actions_single(struct tc_action *act)
 {
-	if (is_tcf_pedit(act))
-		return tcf_pedit_nkeys(act);
-	else
-		return 1;
+	unsigned int count;
+
+	if (is_tcf_pedit(act)) {
+		spin_lock_bh(&act->tcfa_lock);
+		count = tcf_pedit_nkeys_locked(act);
+		spin_unlock_bh(&act->tcfa_lock);
+		return count;
+	}
+	return 1;
 }
 
 static bool tc_act_skip_hw(u32 flags)
diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index 1d06873da8f12..e1be146b0463f 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -556,9 +556,18 @@ static int tcf_pedit_offload_act_setup(struct tc_action *act, void *entry_data,
 {
 	if (bind) {
 		struct flow_action_entry *entry = entry_data;
+		int nkeys = tcf_pedit_nkeys_locked(act);
 		int k;
 
-		for (k = 0; k < tcf_pedit_nkeys(act); k++) {
+		/* If the required keys exceed the remaining capacity return
+		 * -ENOSPC to abort the offload and fallback to software.
+		 */
+		if (nkeys > *index_inc) {
+			NL_SET_ERR_MSG_MOD(extack, "Not enough space to offload all pedit keys");
+			return -ENOSPC;
+		}
+
+		for (k = 0; k < nkeys; k++) {
 			switch (tcf_pedit_cmd(act, k)) {
 			case TCA_PEDIT_KEY_EX_CMD_SET:
 				entry->id = FLOW_ACTION_MANGLE;
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 9ee545b0364ad..44139ca96a1e7 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3631,12 +3631,21 @@ int tc_setup_action(struct flow_action *flow_action,
 
 		entry = &flow_action->entries[j];
 		spin_lock_bh(&act->tcfa_lock);
+
+		/* Abort the offload if we have exhausted the allocated capacity */
+		if (j >= flow_action->num_entries) {
+			NL_SET_ERR_MSG_MOD(extack, "Flow action buffer overflow");
+			err = -ENOSPC;
+			goto err_out_locked;
+		}
+
 		err = tcf_act_get_cookie(entry, act);
 		if (err)
 			goto err_out_locked;
 
-		index = 0;
-		err = tc_setup_offload_act(act, entry, &index, extack);
+		index = flow_action->num_entries - j;
+		err = tc_setup_offload_act(act, entry, &index,
+					   extack);
 		if (err)
 			goto err_out_locked;
 
@@ -3682,10 +3691,13 @@ unsigned int tcf_exts_num_actions(struct tcf_exts *exts)
 	int i;
 
 	tcf_exts_for_each_action(i, act, exts) {
-		if (is_tcf_pedit(act))
-			num_acts += tcf_pedit_nkeys(act);
-		else
+		if (is_tcf_pedit(act)) {
+			spin_lock_bh(&act->tcfa_lock);
+			num_acts += tcf_pedit_nkeys_locked(act);
+			spin_unlock_bh(&act->tcfa_lock);
+		} else {
 			num_acts++;
+		}
 	}
 	return num_acts;
 }
-- 
2.53.0



