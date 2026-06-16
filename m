Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A93A8477E36;
	Tue, 16 Jun 2026 16:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629111; cv=none; b=HPGKMjWrY0AmETBulVIaSHbvI+yBiKQtYnaWUFV7I6QzAxbVDChvznYu1WJaKEJiHBN+MVu1UZL4mRGevo3ubJnSwATZZhPvTmiwZ68eq/MSsujjDCYF1YQScOVnZJg+K+/N+1FeJnD0/khqw6QnGTbNFHl6Pe6k1Y1FhnT08gU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629111; c=relaxed/simple;
	bh=UgrPeee+Wm/OBECb+DB7XUVQQ5wJdwkKoLFS3esjwvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vEKszXTJaGP8innDc/8WYUldblCa8f5veaFuTnBbBYlDcn+wum4GAsraVOncMqvCzd74/rK+JYiHcWDYU65TAGGiCwNJroI7fbZKrHxaI2wh7Zu9qySp2xWfK54jdCxBfvZJQ3x2flbRXdLGye+6pTdbM39SVzMXpspEBL/BmrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1tpHE+EK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1tpHE+EK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 785AB1F000E9;
	Tue, 16 Jun 2026 16:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629110;
	bh=dhd5XPR8zmn46ygLux5TobZwNL7kGagkPvvwiJU7Tb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1tpHE+EKZvkHfan3RiYJunkvC6zNxy4880Tbv8lHmkRGrazFY3dLjVXRW0dvUnuql
	 C4Ma6IXC9ueIx6dnbdRVRBvNJiW/zuY5zn3URwWu5MTkoWNx6ycM5nCn7MzkYZXY4s
	 yu0IpGbSFioghJSN3LeMvS36XXckhH5gsNfB/qFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Anastasov <ja@ssi.bg>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 216/452] ipvs: clear the svc scheduler ptr early on edit
Date: Tue, 16 Jun 2026 20:27:23 +0530
Message-ID: <20260616145129.134782058@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

From: Julian Anastasov <ja@ssi.bg>

[ Upstream commit 193989cc6d80dd8e0460fb3992e69fa03bf0ff9b ]

ip_vs_edit_service() while unbinding the old scheduler clears
the svc->scheduler ptr after the scheduler module initiates
RCU callbacks. This can cause packets to use the old
scheduler at the time when svc->sched_data is already freed
after RCU grace period.

Fix it by clearing the ptr early in ip_vs_unbind_scheduler(),
before the done_service method schedules any RCU callbacks.

Also, if the new scheduler fails to initialize when replacing
the old scheduler, try to restore the old scheduler while still
returning the error code.

Link: https://sashiko.dev/#/patchset/20260519015506.634185-1-rosenp%40gmail.com
Fixes: 05f00505a89a ("ipvs: fix crash if scheduler is changed")
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip_vs.h              |  3 +--
 net/netfilter/ipvs/ip_vs_ctl.c   | 13 ++++++++-----
 net/netfilter/ipvs/ip_vs_sched.c | 14 +++++++-------
 3 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index ff406ef4fd4aab..d70268cf1af82e 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -1506,8 +1506,7 @@ int register_ip_vs_scheduler(struct ip_vs_scheduler *scheduler);
 int unregister_ip_vs_scheduler(struct ip_vs_scheduler *scheduler);
 int ip_vs_bind_scheduler(struct ip_vs_service *svc,
 			 struct ip_vs_scheduler *scheduler);
-void ip_vs_unbind_scheduler(struct ip_vs_service *svc,
-			    struct ip_vs_scheduler *sched);
+void ip_vs_unbind_scheduler(struct ip_vs_service *svc);
 struct ip_vs_scheduler *ip_vs_scheduler_get(const char *sched_name);
 void ip_vs_scheduler_put(struct ip_vs_scheduler *scheduler);
 struct ip_vs_conn *
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 25f586fab2bcc9..27b7552b1e2481 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -1496,7 +1496,7 @@ ip_vs_add_service(struct netns_ipvs *ipvs, struct ip_vs_service_user_kern *u,
 	if (ret_hooks >= 0)
 		ip_vs_unregister_hooks(ipvs, u->af);
 	if (svc != NULL) {
-		ip_vs_unbind_scheduler(svc, sched);
+		ip_vs_unbind_scheduler(svc);
 		ip_vs_service_free(svc);
 	}
 	ip_vs_scheduler_put(sched);
@@ -1558,9 +1558,8 @@ ip_vs_edit_service(struct ip_vs_service *svc, struct ip_vs_service_user_kern *u)
 	old_sched = rcu_dereference_protected(svc->scheduler, 1);
 	if (sched != old_sched) {
 		if (old_sched) {
-			ip_vs_unbind_scheduler(svc, old_sched);
-			RCU_INIT_POINTER(svc->scheduler, NULL);
-			/* Wait all svc->sched_data users */
+			ip_vs_unbind_scheduler(svc);
+			/* Wait all svc->scheduler/sched_data users */
 			synchronize_rcu();
 		}
 		/* Bind the new scheduler */
@@ -1568,6 +1567,10 @@ ip_vs_edit_service(struct ip_vs_service *svc, struct ip_vs_service_user_kern *u)
 			ret = ip_vs_bind_scheduler(svc, sched);
 			if (ret) {
 				ip_vs_scheduler_put(sched);
+				/* Try to restore the old_sched */
+				if (old_sched &&
+				    !ip_vs_bind_scheduler(svc, old_sched))
+					old_sched = NULL;
 				goto out;
 			}
 		}
@@ -1624,7 +1627,7 @@ static void __ip_vs_del_service(struct ip_vs_service *svc, bool cleanup)
 
 	/* Unbind scheduler */
 	old_sched = rcu_dereference_protected(svc->scheduler, 1);
-	ip_vs_unbind_scheduler(svc, old_sched);
+	ip_vs_unbind_scheduler(svc);
 	ip_vs_scheduler_put(old_sched);
 
 	/* Unbind persistence engine, keep svc->pe */
diff --git a/net/netfilter/ipvs/ip_vs_sched.c b/net/netfilter/ipvs/ip_vs_sched.c
index d4903723be7e90..49b2e5d2b2c837 100644
--- a/net/netfilter/ipvs/ip_vs_sched.c
+++ b/net/netfilter/ipvs/ip_vs_sched.c
@@ -57,19 +57,19 @@ int ip_vs_bind_scheduler(struct ip_vs_service *svc,
 /*
  *  Unbind a service with its scheduler
  */
-void ip_vs_unbind_scheduler(struct ip_vs_service *svc,
-			    struct ip_vs_scheduler *sched)
+void ip_vs_unbind_scheduler(struct ip_vs_service *svc)
 {
-	struct ip_vs_scheduler *cur_sched;
+	struct ip_vs_scheduler *sched;
 
-	cur_sched = rcu_dereference_protected(svc->scheduler, 1);
-	/* This check proves that old 'sched' was installed */
-	if (!cur_sched)
+	sched = rcu_dereference_protected(svc->scheduler, 1);
+	if (!sched)
 		return;
 
+	/* Reset the scheduler before initiating any RCU callbacks */
+	rcu_assign_pointer(svc->scheduler, NULL);
+	smp_wmb();	/* paired with smp_rmb() in ip_vs_schedule() */
 	if (sched->done_service)
 		sched->done_service(svc);
-	/* svc->scheduler can be set to NULL only by caller */
 }
 
 
-- 
2.53.0



