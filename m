Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C120738C437;
	Tue, 16 Jun 2026 15:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781622771; cv=none; b=jXFoTijlwjueHsrMxwRoBQVAFubGdJBed8O8SPUFyc+lImrEGwz/1fiv7bdx+vVrTePnbPsiPI4Xjsx3i3G2frlh3PUDcoAeavR4KNNQ8yfYAqLAXcMatKnurwyhBiWzmHPehuDF6eItLl8d8FxVMTVcXi9YaoozsWg7Mq1MybI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781622771; c=relaxed/simple;
	bh=5sdri9brhyorLjoQcE8F01j4qp1BpTiM5D8p6vNZzFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X8XPZyUbpkYkFvxZsFMBTtOC2Gj39JvN2HDS7P4LZ3WlL1cKX3Iq+34xV+YELTX9i5Y3ypJhS8LM7ZwRmuRcOArVtTgOOzDVQPVFMiYhWllWLnamX2fNecWFJ+L0bRiY4AUCyi6v+b4Y1U1ImmdIjym5cZFkQtj3WLaXifbmPo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cRA0RsgA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cRA0RsgA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E8381F000E9;
	Tue, 16 Jun 2026 15:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781622770;
	bh=KrKLhki369VE6a+fZ7gL671ZaRDaECN+YVKU23CJLRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cRA0RsgAerOrBBo5RlpiYGWEvI/YOjFz+in8WZL+2A176QVU3yoFX8wErPP2LxoKG
	 hLijhglyrCYt+GlA8Q1UyNfxminC02RK4xgkzYi1iCcuXkLBh3Cg9ahv4tY6nHpdB3
	 qd3BgBb7STltu6h8q8E6AO/pxcU5ZsRr1E0TT/HU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Kyle Zeng <kylebot@openai.com>,
	Victor Nogueira <victor@mojatatu.com>,
	syzbot@syzkaller.appspotmail.com,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Eric Dumazet <edumazet@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 026/378] net/sched: act_api: use RCU with deferred freeing for action lifecycle
Date: Tue, 16 Jun 2026 20:24:17 +0530
Message-ID: <20260616145111.225926326@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit 5057e1aca011e51ef51498c940ef96f3d3e8a305 ]

When NEWTFILTER and DELFILTER are run concurrently it is possible to create a
race with an associated action.

Let's illustrate with CPU0 running NEWTFILTER and CPU1 running DELFILTER:

 0: mutex_lock() <-- holds the idr lock
 0: rcu_read_lock()
 0: p = idr_find(idr, index) <-- action p is valid (RCU protects IDR)
 0: mutex_unlock() <-- releases the idr lock
 1: refcount_dec_and_mutex_lock() <-- refcnt 1->0, mutex held
 1: idr_remove(idr, index) <-- Action removed from IDR
 1: mutex_unlock() <-- mutex released allowing us to delete the action
 1: tcf_action_cleanup(p); kfree(p) <-- Kfrees p immediately, no deferral
 0: refcount_inc_not_zero(&p->tcfa_refcnt) <-- ouch, UAF p points to freed memory

This patch fixes the race condition between NEWTFILTER and DELFILTER by
adding struct rcu_head to tc_action used in the deferral and introducing a
call_rcu() in the delete path to defer the final kfree().

Note: this is a revert of commit d7fb60b9cafb ("net_sched: get rid of tcfa_rcu")
but also modernization/simplification to directly use kfree_rcu().

Let's illustrate the new restored code path:

 0: rcu_read_lock()
 1: refcount_dec_and_mutex_lock() <-- refcnt 1->0, mutex held
 1: idr_remove(idr, index)
 1: mutex_unlock()
 1: call_rcu(&p->tcfa_rcu, tcf_action_rcu_free) <-- defer kfree after grace period
 0: p = idr_find(idr, index)
 0: refcount_inc_not_zero(&p->tcfa_refcnt) <-- fails, refcnt already 0
 1: rcu_read_unlock() <-- release so freeing can run after grace period

After CPU1 calls idr_remove(), the object is no longer reachable through the IDR.
CPU0's subsequent idr_find() will return NULL, and even if it still held a
stale pointer, the immediate kfree() is now deferred until after the RCU grace
period, so no UAF can occur.

Fixes: d7fb60b9cafb ("net_sched: get rid of tcfa_rcu")
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Reported-by: Kyle Zeng <kylebot@openai.com>
Tested-by: Victor Nogueira <victor@mojatatu.com>
Tested-by: syzbot@syzkaller.appspotmail.com
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Tested-by: Kyle Zeng <kylebot@openai.com>
Reviewed-by: Pedro Tammela <pctammela@mojatatu.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Victor Nogueira <victor@mojatatu.com>
Link: https://patch.msgid.link/20260531160812.68020-1-jhs@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/act_api.h | 1 +
 net/sched/act_api.c   | 7 +------
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index d11b791079302f..fd2967ee08f7a6 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -45,6 +45,7 @@ struct tc_action {
 	struct tc_cookie	__rcu *user_cookie;
 	struct tcf_chain	__rcu *goto_chain;
 	u32			tcfa_flags;
+	struct rcu_head         tcfa_rcu;
 	u8			hw_stats;
 	u8			used_hw_stats;
 	bool			used_hw_stats_valid;
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 332fd9695e54a1..04ea11c90e0330 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -112,11 +112,6 @@ struct tcf_chain *tcf_action_set_ctrlact(struct tc_action *a, int action,
 }
 EXPORT_SYMBOL(tcf_action_set_ctrlact);
 
-/* XXX: For standalone actions, we don't need a RCU grace period either, because
- * actions are always connected to filters and filters are already destroyed in
- * RCU callbacks, so after a RCU grace period actions are already disconnected
- * from filters. Readers later can not find us.
- */
 static void free_tcf(struct tc_action *p)
 {
 	struct tcf_chain *chain = rcu_dereference_protected(p->goto_chain, 1);
@@ -129,7 +124,7 @@ static void free_tcf(struct tc_action *p)
 	if (chain)
 		tcf_chain_put_by_act(chain);
 
-	kfree(p);
+	kfree_rcu(p, tcfa_rcu);
 }
 
 static void offload_action_hw_count_set(struct tc_action *act,
-- 
2.53.0



