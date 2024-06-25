Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF62D24B34;
	Tue, 25 Jun 2024 09:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309165; cv=none; b=WJqwu2rJ0MqhrsYUFHqSbNeffoC8rGZ+JXPYr2crUCuX7PJUhrA6glb7cepnRQbVEIo6S24JEvRmXRiego56d98jqbgef8BdkZF3v8815epoPwaLVU7j0Mbssidt2ia3U9bPdMHdftRMHkqJHJx4whbGIiDY8P5qam/m/J3TKwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309165; c=relaxed/simple;
	bh=MxO7U/tzN0JB5OS8pJ6Zs6Odj4rF3VmPAWhC2DWJyIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SpUwcxIMZKoBt8NaUl1VkWUVBW6phVT7gOAl7M6sBFFO2eyifYimULPR8j3Nmgco5F0teMz+gNh8cv4/Q46Ip8JISh4b4ulw+++8uHP2h+xDHp7bn6L3ow/pdif1AT6TQ47ncAdsLkSwgLfsJ1AWWwswhfd79gcTOUzc+u5O8VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G6pbPaoq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G6pbPaoq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 464C1C32781;
	Tue, 25 Jun 2024 09:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309165;
	bh=MxO7U/tzN0JB5OS8pJ6Zs6Odj4rF3VmPAWhC2DWJyIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G6pbPaoqi5YRh5T0CZZip/m6Hw0Ces28hwR8b0Y/wzB8i2S4WAb4Y/eoxaVlc2Ljp
	 3Al7kGMGRpRZWH4voG5KQo0z9PhnlNHgtRTKp2L0bsDQYCSGGg6EYXhNTh/sYcmFXu
	 Hk6baRuVD85UEZghkFsFoVBwWRWpjADdOW+m1crQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pedro Tammela <pctammela@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Vlad Buslov <vladbu@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 087/192] net/sched: act_api: rely on rcu in tcf_idr_check_alloc
Date: Tue, 25 Jun 2024 11:32:39 +0200
Message-ID: <20240625085540.515506977@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pedro Tammela <pctammela@mojatatu.com>

[ Upstream commit 4b55e86736d5b492cf689125da2600f59c7d2c39 ]

Instead of relying only on the idrinfo->lock mutex for
bind/alloc logic, rely on a combination of rcu + mutex + atomics
to better scale the case where multiple rtnl-less filters are
binding to the same action object.

Action binding happens when an action index is specified explicitly and
an action exists which such index exists. Example:
  tc actions add action drop index 1
  tc filter add ... matchall action drop index 1
  tc filter add ... matchall action drop index 1
  tc filter add ... matchall action drop index 1
  tc filter ls ...
     filter protocol all pref 49150 matchall chain 0 filter protocol all pref 49150 matchall chain 0 handle 0x1
     not_in_hw
           action order 1: gact action drop
            random type none pass val 0
            index 1 ref 4 bind 3

   filter protocol all pref 49151 matchall chain 0 filter protocol all pref 49151 matchall chain 0 handle 0x1
     not_in_hw
           action order 1: gact action drop
            random type none pass val 0
            index 1 ref 4 bind 3

   filter protocol all pref 49152 matchall chain 0 filter protocol all pref 49152 matchall chain 0 handle 0x1
     not_in_hw
           action order 1: gact action drop
            random type none pass val 0
            index 1 ref 4 bind 3

When no index is specified, as before, grab the mutex and allocate
in the idr the next available id. In this version, as opposed to before,
it's simplified to store the -EBUSY pointer instead of the previous
alloc + replace combination.

When an index is specified, rely on rcu to find if there's an object in
such index. If there's none, fallback to the above, serializing on the
mutex and reserving the specified id. If there's one, it can be an -EBUSY
pointer, in which case we just try again until it's an action, or an action.
Given the rcu guarantees, the action found could be dead and therefore
we need to bump the refcount if it's not 0, handling the case it's
in fact 0.

As bind and the action refcount are already atomics, these increments can
happen without the mutex protection while many tcf_idr_check_alloc race
to bind to the same action instance.

In case binding encounters a parallel delete or add, it will return
-EAGAIN in order to try again. Both filter and action apis already
have the retry machinery in-place. In case it's an unlocked filter it
retries under the rtnl lock.

Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
Link: https://lore.kernel.org/r/20231211181807.96028-2-pctammela@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: d864319871b0 ("net/sched: act_api: fix possible infinite loop in tcf_idr_check_alloc()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_api.c | 65 ++++++++++++++++++++++++++++++---------------
 1 file changed, 43 insertions(+), 22 deletions(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 9d3f26bf0440d..5d34852ca5003 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -816,6 +816,9 @@ EXPORT_SYMBOL(tcf_idr_cleanup);
  * its reference and bind counters, and return 1. Otherwise insert temporary
  * error pointer (to prevent concurrent users from inserting actions with same
  * index) and return 0.
+ *
+ * May return -EAGAIN for binding actions in case of a parallel add/delete on
+ * the requested index.
  */
 
 int tcf_idr_check_alloc(struct tc_action_net *tn, u32 *index,
@@ -824,43 +827,61 @@ int tcf_idr_check_alloc(struct tc_action_net *tn, u32 *index,
 	struct tcf_idrinfo *idrinfo = tn->idrinfo;
 	struct tc_action *p;
 	int ret;
+	u32 max;
 
-again:
-	mutex_lock(&idrinfo->lock);
 	if (*index) {
+again:
+		rcu_read_lock();
 		p = idr_find(&idrinfo->action_idr, *index);
+
 		if (IS_ERR(p)) {
 			/* This means that another process allocated
 			 * index but did not assign the pointer yet.
 			 */
-			mutex_unlock(&idrinfo->lock);
+			rcu_read_unlock();
 			goto again;
 		}
 
-		if (p) {
-			refcount_inc(&p->tcfa_refcnt);
-			if (bind)
-				atomic_inc(&p->tcfa_bindcnt);
-			*a = p;
-			ret = 1;
-		} else {
-			*a = NULL;
-			ret = idr_alloc_u32(&idrinfo->action_idr, NULL, index,
-					    *index, GFP_KERNEL);
-			if (!ret)
-				idr_replace(&idrinfo->action_idr,
-					    ERR_PTR(-EBUSY), *index);
+		if (!p) {
+			/* Empty slot, try to allocate it */
+			max = *index;
+			rcu_read_unlock();
+			goto new;
+		}
+
+		if (!refcount_inc_not_zero(&p->tcfa_refcnt)) {
+			/* Action was deleted in parallel */
+			rcu_read_unlock();
+			return -EAGAIN;
 		}
+
+		if (bind)
+			atomic_inc(&p->tcfa_bindcnt);
+		*a = p;
+
+		rcu_read_unlock();
+
+		return 1;
 	} else {
+		/* Find a slot */
 		*index = 1;
-		*a = NULL;
-		ret = idr_alloc_u32(&idrinfo->action_idr, NULL, index,
-				    UINT_MAX, GFP_KERNEL);
-		if (!ret)
-			idr_replace(&idrinfo->action_idr, ERR_PTR(-EBUSY),
-				    *index);
+		max = UINT_MAX;
 	}
+
+new:
+	*a = NULL;
+
+	mutex_lock(&idrinfo->lock);
+	ret = idr_alloc_u32(&idrinfo->action_idr, ERR_PTR(-EBUSY), index, max,
+			    GFP_KERNEL);
 	mutex_unlock(&idrinfo->lock);
+
+	/* N binds raced for action allocation,
+	 * retry for all the ones that failed.
+	 */
+	if (ret == -ENOSPC && *index == max)
+		ret = -EAGAIN;
+
 	return ret;
 }
 EXPORT_SYMBOL(tcf_idr_check_alloc);
-- 
2.43.0



