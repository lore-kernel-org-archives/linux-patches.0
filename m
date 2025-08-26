Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B692F49EA;
	Tue, 26 Aug 2025 14:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218593; cv=none; b=gsKZMtPraarubHNWLnAtG8GQxU1w67UdNS8z8YZzsn5ZU8L3jk1mzuPDYWJfkhJvMZo+/efW3zIfG7XLDTmo9PF8BG2mzBcwMkGO9LaWEQ6gkBRUbfRuFx2wpWiTgMZRjj2LTrTrbPcxXFqzYb0YCLr9zjSYQZ56gDlssApJ4FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218593; c=relaxed/simple;
	bh=uq+gB8W87yaOTY69Wx71wGW4N2E/7gTYTEbuiuu8jsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NagHgPGHL+wAohdIuuZZsCYXvd3myXkW0Y+q25zOX+oou/u+IWn2cmVPf78HVXoMLlRwvfURhbbNG0btqXI7/biLyhkt7+QvBGtfQKYZskeTGLgExISebo4Ongu83VmFBopjtpno1VxWYmet3T5GJ7mZyN95v6w0P1Wa32x79uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bft0pmqv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bft0pmqv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEAABC4CEF1;
	Tue, 26 Aug 2025 14:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218593;
	bh=uq+gB8W87yaOTY69Wx71wGW4N2E/7gTYTEbuiuu8jsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bft0pmqvpSJVhz3/FH2Oj5vCzngNYzZFvMFHAKtOhFAexTd5n96xrWD1EjsKF2pQO
	 v/d6PoET8hDYOCkZ9uL9FNCVVtoDvxebix6MA/PaqkhaDyxjBM6eTO7oiopEpEHLIz
	 rEUYmc3ya6H3J6KXA47aEOBva91tOUkzKO4lK5I0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Xiang Mei <xmei5@asu.edu>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 060/403] net/sched: sch_qfq: Avoid triggering might_sleep in atomic context in qfq_delete_class
Date: Tue, 26 Aug 2025 13:06:26 +0200
Message-ID: <20250826110907.523682040@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit cf074eca0065bc5142e6004ae236bb35a2687fdf ]

might_sleep could be trigger in the atomic context in qfq_delete_class.

qfq_destroy_class was moved into atomic context locked
by sch_tree_lock to avoid a race condition bug on
qfq_aggregate. However, might_sleep could be triggered by
qfq_destroy_class, which introduced sleeping in atomic context (path:
qfq_destroy_class->qdisc_put->__qdisc_destroy->lockdep_unregister_key
->might_sleep).

Considering the race is on the qfq_aggregate objects, keeping
qfq_rm_from_agg in the lock but moving the left part out can solve
this issue.

Fixes: 5e28d5a3f774 ("net/sched: sch_qfq: Fix race condition on qfq_aggregate")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Link: https://patch.msgid.link/4a04e0cc-a64b-44e7-9213-2880ed641d77@sabinyo.mountain
Reviewed-by: Cong Wang <xiyou.wangcong@gmail.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/20250717230128.159766-1-xmei5@asu.edu
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_qfq.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index 2a4331a084949..be04fcfcc5852 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -534,9 +534,6 @@ static int qfq_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
 
 static void qfq_destroy_class(struct Qdisc *sch, struct qfq_class *cl)
 {
-	struct qfq_sched *q = qdisc_priv(sch);
-
-	qfq_rm_from_agg(q, cl);
 	gen_kill_estimator(&cl->rate_est);
 	qdisc_put(cl->qdisc);
 	kfree(cl);
@@ -554,10 +551,11 @@ static int qfq_delete_class(struct Qdisc *sch, unsigned long arg)
 
 	qdisc_purge_queue(cl->qdisc);
 	qdisc_class_hash_remove(&q->clhash, &cl->common);
-	qfq_destroy_class(sch, cl);
+	qfq_rm_from_agg(q, cl);
 
 	sch_tree_unlock(sch);
 
+	qfq_destroy_class(sch, cl);
 	return 0;
 }
 
@@ -1507,6 +1505,7 @@ static void qfq_destroy_qdisc(struct Qdisc *sch)
 	for (i = 0; i < q->clhash.hashsize; i++) {
 		hlist_for_each_entry_safe(cl, next, &q->clhash.hash[i],
 					  common.hnode) {
+			qfq_rm_from_agg(q, cl);
 			qfq_destroy_class(sch, cl);
 		}
 	}
-- 
2.39.5



