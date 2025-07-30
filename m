Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53375635;
	Wed, 30 Jul 2025 09:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869222; cv=none; b=W0RUrzjdZIkOlEaNb4zrJBko+d7+utaBQ1aotwn5bkySScgVR4RWzXRCUkUjTN55ezVICFDm8oQo82w1HOKchZHBJhbz1nKdQrinemrbq5Q5xq3FDPgJ5K09ERcVOKRMg1xib91OMNg/Z63yfAbHf7asWdGPcOYSFRnKYvmxuZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869222; c=relaxed/simple;
	bh=YGRNjLnxUDRni/ADeHJTbCGTUiKInnIy/PqUhzF/5hw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h8pVoAq98El7ugec7LE3BELQ4Fje4RH220Gy/TkQoC6K+qE5oOlNWUtND36Hfi8gwiXYDwfqzwuZ/9thW5Bl6I2JomQX+tK0BSnwO+hhXgYrHaNcJLRKnBNiw99svBQcCQ9o5nc1tPUXb2fxcrv1sScJ/ALB1izMKBNxrqOJ/cA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ifKKmlrG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ifKKmlrG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22624C4CEF5;
	Wed, 30 Jul 2025 09:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869221;
	bh=YGRNjLnxUDRni/ADeHJTbCGTUiKInnIy/PqUhzF/5hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ifKKmlrGY8iHNA2lf54nWEdLGi0P0l7hAeZ2/NPLRvIGu5xfjU0YUwKFoxyi5veHI
	 VLRVdHYt/6+pg0DckYW1XdLaklCBGE+VdchcC7afDDOmOohIFd0uM9nH5xdrfZU+bx
	 qz6FeG5bmvQsBBons3j0+2qaqZPnoSNS4L/O4D1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Xiang Mei <xmei5@asu.edu>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 33/92] net/sched: sch_qfq: Avoid triggering might_sleep in atomic context in qfq_delete_class
Date: Wed, 30 Jul 2025 11:35:41 +0200
Message-ID: <20250730093232.035098422@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 2b1b025c31a33..51cc2cfb40936 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -536,9 +536,6 @@ static int qfq_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
 
 static void qfq_destroy_class(struct Qdisc *sch, struct qfq_class *cl)
 {
-	struct qfq_sched *q = qdisc_priv(sch);
-
-	qfq_rm_from_agg(q, cl);
 	gen_kill_estimator(&cl->rate_est);
 	qdisc_put(cl->qdisc);
 	kfree(cl);
@@ -559,10 +556,11 @@ static int qfq_delete_class(struct Qdisc *sch, unsigned long arg,
 
 	qdisc_purge_queue(cl->qdisc);
 	qdisc_class_hash_remove(&q->clhash, &cl->common);
-	qfq_destroy_class(sch, cl);
+	qfq_rm_from_agg(q, cl);
 
 	sch_tree_unlock(sch);
 
+	qfq_destroy_class(sch, cl);
 	return 0;
 }
 
@@ -1503,6 +1501,7 @@ static void qfq_destroy_qdisc(struct Qdisc *sch)
 	for (i = 0; i < q->clhash.hashsize; i++) {
 		hlist_for_each_entry_safe(cl, next, &q->clhash.hash[i],
 					  common.hnode) {
+			qfq_rm_from_agg(q, cl);
 			qfq_destroy_class(sch, cl);
 		}
 	}
-- 
2.39.5



