Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10425415F36;
	Tue, 21 Jul 2026 18:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658194; cv=none; b=O0uxEoadGG9Mdw/kzAxEvYuteVkMjaBbqTAI1wmRx1Fedwe6GwoXHz0lmFTl+UEK4irXZyc6IsVminMUxTTrS6H1K3sPcBpKmlEfBtt0NJPKVf1B8Vqs/xf5CjyQvTC68lhKWPggKYHoxZ47J+HOgk8NeU4GZ1WX0AVbVzqwPi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658194; c=relaxed/simple;
	bh=V7CMRB2T0+NwFGa4brJE27zMydX4auOxhYU+1kxL1CU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k2b6JxNXwZTB+K6r1wLbYtiRrntc1sDBYH3V2aP6rafWU93eoECcsKyQ9laXJx+Vk3nM0vgeyQGqEGynMpc+mPNx1QZFSTvYDjn0UsHOFzUach9qwaN2Gvifceyb4ZQjRjVdQlTKixfhe2CyttbWg4uCaSNkWfedjI34WzFMOlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nyswRRku; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nyswRRku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 738471F000E9;
	Tue, 21 Jul 2026 18:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658192;
	bh=VuIT3FNl7BaPzU8S6o9TH3uHAu0vYCUq8KsZ7Jwjmn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nyswRRkugNGPvldgoxpkJWoz9QyFLpF7y5hjL68A3rmEX7femmriDm5ewJr+S6XhV
	 k/YCspC8sNvEh2x8mQT8l8uau6KNSH69SkJIH8u2b4qaFgZfp8r7yDv3pQYThCc+U1
	 cmQaJN18MjpeDZMKojFBhYlTy2ouvYCveN30yBt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zdi-disclosures@trendmicro.com,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1050/1611] net/sched: act_pedit: fix TOCTOU heap OOB write in tc offload
Date: Tue, 21 Jul 2026 17:19:26 +0200
Message-ID: <20260721152539.025158141@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index cb7b82f2cbc7fd..97754ea0a8279d 100644
--- a/include/net/tc_act/tc_pedit.h
+++ b/include/net/tc_act/tc_pedit.h
@@ -37,17 +37,15 @@ static inline bool is_tcf_pedit(const struct tc_action *a)
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
index 6afeeb6b590a2a..f948646985dde9 100644
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
index c0a5f5d78dacd9..5aa91fb145a270 100644
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
index a94de0cab29cc7..3b0a438977cd52 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3887,12 +3887,21 @@ int tc_setup_action(struct flow_action *flow_action,
 
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
 
@@ -3946,10 +3955,13 @@ unsigned int tcf_exts_num_actions(struct tcf_exts *exts)
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



