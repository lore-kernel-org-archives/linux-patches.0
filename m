Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A0734FF79;
	Tue, 16 Jun 2026 18:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635904; cv=none; b=rJ16qJqCaIdbPyn1uJ5+TCM/PldyNE7yQLts/fR2yLkExf7N58Vapvbqt6DYqFMKP5YIdENVN731IyBwJEBUDgEzCTKLZGGyoLNH/ZxqAuBvIoqYnpAZ/ay6aToVR+7PQMKEREdiz70uKr0Qs62ABlupBgslnRm0jdt2j3NJ1Fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635904; c=relaxed/simple;
	bh=+h2OUJLSvJSVwKqOQA8GRZU9+UMR1nZNck8uLNp4smk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fA4mVrt1nawHVQ3sZUqMoQSOnc5lhkzkoYyIcll4qua1YWnBVDRPKmSnnQ83B72JwPP5j1xOdLlwpGczVQHOrVGFEvECfac0by2wHPW+3GzZ1l9DDWDDiVgrqflWnZjIktIZldcqOjZyIom3htQe/2+RGFfrgcEPIkuj5zQUP60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l0KwGH2+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l0KwGH2+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 136331F000E9;
	Tue, 16 Jun 2026 18:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635903;
	bh=x6pYfwyaV36MAqeug3LbB+MCWfmWaol6NcELhscJPhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l0KwGH2+M5n3xYiP4Ca2J02guaTVSGvf0+nDVfY9nnKD5tuDopF2koAHD6YgNiLfy
	 12ikiLDO+/njJrM8dOWU7pdiomsW/Apw8auH4+BbN3z7vjATHwV7h0XIOjai8yHwRl
	 Xctn981xU3kKZo/Cf1FnTAgYbDVMi+bOu0a8SJNg=
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
Subject: [PATCH 5.10 138/342] net/sched: act_api: use RCU with deferred freeing for action lifecycle
Date: Tue, 16 Jun 2026 20:27:14 +0530
Message-ID: <20260616145054.617155311@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 2c88b8af3cdbe1..bbc4ab5e04f7d1 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -41,6 +41,7 @@ struct tc_action {
 	struct tc_cookie	__rcu *act_cookie;
 	struct tcf_chain	__rcu *goto_chain;
 	u32			tcfa_flags;
+	struct rcu_head         tcfa_rcu;
 	u8			hw_stats;
 	u8			used_hw_stats;
 	bool			used_hw_stats_valid;
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index bf98bb602a9de7..c724eea8cf8c52 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -93,11 +93,6 @@ struct tcf_chain *tcf_action_set_ctrlact(struct tc_action *a, int action,
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
@@ -110,7 +105,7 @@ static void free_tcf(struct tc_action *p)
 	if (chain)
 		tcf_chain_put_by_act(chain);
 
-	kfree(p);
+	kfree_rcu(p, tcfa_rcu);
 }
 
 static void tcf_action_cleanup(struct tc_action *p)
-- 
2.53.0



