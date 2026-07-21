Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44AAD403B13;
	Tue, 21 Jul 2026 20:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666908; cv=none; b=h64acEYjwxBsljIAYdOdH1CplooJwWSy55v16675cg6S9GIKbV8toxmX0wzPOblUxngr7h5fMLwNmOyGKERsmwZcJiSJfP9K6gvPjNDwDEZF6ow1J9EDwTbNoBAIq4ilQAWpE9BwEISg7ehYPBmOntFVoVuj/lCky+TCBUz3Xrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666908; c=relaxed/simple;
	bh=KXXtnnj1UHd9aSRT1G4aHUjGPOeHLAvdicTccyApGfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JzyBV3yu/K/q2u62vjzTmRgYJH46qjYfjb1YjKQ+VHQ0FMzi1K0WTYzuAoW/RDFqSeHScGMF+mt0a7wXiD4a8l94RjokWoswD3SoTPSYuasgq2aWfZNh/S5NWk4f4Ul53AGNbycUtjVSQLz5S98Whp+3Yf+moR60gjU9CU19xco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wi1kbVjS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wi1kbVjS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A97731F00A3A;
	Tue, 21 Jul 2026 20:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666906;
	bh=egzs9faS95q5fDGDdsg1FNaytnypnW7ehWWALO9G9qs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wi1kbVjSJsuZySpcrfBITHCJ55pKCnf1OshDiQTtqitN/9sKeOHFHFSKleJYS/k5j
	 KFN/E2WkcuFYQ2Mh7k5CX0Ny1KyZk3CmFxcdsq2OszgTYFYkmFmcIjRT50a9sioUoV
	 JfqarlBPunCP3U6ZYEgYESkTszV2Q2CTCU0nm+so=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zdi-disclosures@trendmicro.com,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0859/1266] net/sched: act_pedit: fix TOCTOU heap OOB write in tc offload
Date: Tue, 21 Jul 2026 17:21:36 +0200
Message-ID: <20260721152501.075069907@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 net/sched/act_pedit.c         | 13 +++++++++++--
 net/sched/cls_api.c           | 22 +++++++++++++++++-----
 4 files changed, 45 insertions(+), 21 deletions(-)

diff --git a/include/net/tc_act/tc_pedit.h b/include/net/tc_act/tc_pedit.h
index a26d4cd3b8d6f3..fa4cd4fc36740d 100644
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
index bed04ae3003c43..3b7e5fcdd4ff29 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -148,10 +148,15 @@ static void offload_action_hw_count_dec(struct tc_action *act,
 
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
index 80b2a1e9d5ceb9..f26f05fb10fe44 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -563,9 +563,18 @@ static int tcf_pedit_offload_act_setup(struct tc_action *act, void *entry_data,
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
@@ -602,7 +611,7 @@ static int tcf_pedit_offload_act_setup(struct tc_action *act, void *entry_data,
 			return -EOPNOTSUPP;
 		}
 
-		for (k = 1; k < tcf_pedit_nkeys(act); k++) {
+		for (k = 1; k < tcf_pedit_nkeys_locked(act); k++) {
 			if (cmd != tcf_pedit_cmd(act, k)) {
 				NL_SET_ERR_MSG_MOD(extack, "Unsupported pedit command offload");
 				return -EOPNOTSUPP;
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 2c3af83c01c4f6..e259ec6ed145de 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3808,12 +3808,21 @@ int tc_setup_action(struct flow_action *flow_action,
 
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
 		err = tcf_act_get_user_cookie(entry, act);
 		if (err)
 			goto err_out_locked;
 
-		index = 0;
-		err = tc_setup_offload_act(act, entry, &index, extack);
+		index = flow_action->num_entries - j;
+		err = tc_setup_offload_act(act, entry, &index,
+					   extack);
 		if (err)
 			goto err_out_locked;
 
@@ -3867,10 +3876,13 @@ unsigned int tcf_exts_num_actions(struct tcf_exts *exts)
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



