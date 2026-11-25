Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619957;
	b=f6fbpq3I1wC0FyVXop4QRXibW+2AZ21vOgAFzms4ir0rgHBCPKlk37TJnV3jUFcJMozY
	 MqfcKF4l1dki8IdLg+pxZsO9uGjHU9x/Zp2D6PLA+N2qRkBcSuNk3IWW1/PolAyOW19Va
	 jM5gqXEX9uRgkJx3tIJA6jSXq4+pRtom70ajQ7Z9lojCGUBx3S11leAHhDL6IA7iRsBBY
	 IOfqPDl5Z6pwYyo63ttYNxsVB1/DsJWqVN7iB1eXaYWYrcJIObX4WJOdXMDoqctBXt4J6
	 UxkXHpZuByWHEhsSZ7ZGVYIe9ZdJI2//5KNn33u1pcSHNu1RSdR2LkhWU+8wCplRaUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619957;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JZYKlR7hH3PyxkxfCR53dR38QdTEtBuZMfKQDNOV7eE=;
	b=VXoXlnW+KhB/JrOgaMh9meMtd97qATE8pTPPU4Hi4FEajY1N2fa59cDZsQnNhGxrLvqO
	 f1jGjgXgIu+Mzah0oXqAyE5irXO82PJapmtRjII06Ke0OF5fu8tlEzUed6fcYAGwjagZJ
	 CvHbc+fyjFg0WaeTr24aPCo02HB7iVx9Qs3eF3Yuz7BWQ0MUkYnjth7a+5+Sqs0l/Zu1U
	 aQHsWdxpjzdA9SBqz8N/jo9TbKh+yM3HhrS3fWixJBYvmPdsFG9ZR738BRl4dYkxiVeT2
	 NFg5j8kO+u/oqxA3ZAW5dZw8VhMoOUhzZ0abZlwlPZmc81tWNwUAW5cqwyyh/uvCw7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GpSde1Ru;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7AA606A321;
	Wed, 25 Nov 2026 15:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GpSde1Ru
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C461D1F000C0;
	Wed, 25 Nov 2026 15:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619957;
	bh=JZYKlR7hH3PyxkxfCR53dR38QdTEtBuZMfKQDNOV7eE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GpSde1Rub1hwgPBzisgKatWZ2+kRCmjy94UnVnXECan0VNZUe4ziZaocguKCX0HIJ
	 wmhkqJJV1ncm7SuAcbYGo+JmLAbm9nlgmeXyLT5sDlqk5Dpii3TecePQ4iIP8YvC4h
	 VtdcYRC5d3zXxLe2ypCC04B+qErIl15XQ2Cnjl6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Andrea Righi <arighi@nvidia.com>
Subject: [PATCH 7.3 0762/1005] sched_ext: Factor out drain_offline_rq()
Date: Wed, 25 Nov 2026 15:35:00 +0100
Message-ID: <20261125143839.596688804@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 1826e5aa068cf6c21791773f160b4a2ce5d5f9a5 upstream.

Factor drain_offline_rq() out of rq_offline_scx() so that the drain can move
to handle_hotplug() in the following patch, which removes the rq_online and
rq_offline hooks. The drain is the rescue flush and the re-enqueue of an
offline cpu's tasks onto its local DSQ. No functional change.

Cc: stable@vger.kernel.org # v6.12+
Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext/ext.c |   35 ++++++++++++++++++++---------------
 kernel/sched/sched.h   |    2 +-
 2 files changed, 21 insertions(+), 16 deletions(-)

--- a/kernel/sched/ext/ext.c
+++ b/kernel/sched/ext/ext.c
@@ -2157,7 +2157,7 @@ static void set_task_runnable(struct rq
 	}
 
 	/*
-	 * list_add_tail() must be used. scx_bypass() and rq_offline_scx()
+	 * list_add_tail() must be used. scx_bypass() and drain_offline_rq()
 	 * depend on tasks being appended to the runnable_list.
 	 */
 	list_add_tail(&p->scx.runnable_node, &rq->scx.runnable_list);
@@ -3806,6 +3806,24 @@ static void set_cpus_allowed_scx(struct
 		scx_call_op_set_cpumask(sch, task_rq(p), p, (struct cpumask *)p->cpus_ptr);
 }
 
+static void drain_offline_rq(struct rq *rq)
+{
+	struct task_struct *p, *n;
+
+	scx_rescue_flush(rq);
+
+	/*
+	 * An offline CPU no longer calls ops.dispatch(). Re-enqueue its tasks
+	 * onto the local DSQ so that they run here and balance_push() moves
+	 * them off.
+	 */
+	list_for_each_entry_safe_reverse(p, n, &rq->scx.runnable_list, scx.runnable_node) {
+		if (p->scx.dsq == &rq->scx.local_dsq)
+			continue;
+		guard(sched_change)(p, DEQUEUE_SAVE | DEQUEUE_MOVE | DEQUEUE_NOCLOCK);
+	}
+}
+
 static void handle_hotplug(struct rq *rq, bool online)
 {
 	struct scx_sched *sch = scx_root_protected();
@@ -3886,26 +3904,13 @@ static void rq_online_scx(struct rq *rq)
 
 static void rq_offline_scx(struct rq *rq)
 {
-	struct task_struct *p, *n;
-
 	rq->scx.flags &= ~SCX_RQ_ONLINE;
 
 	/* sched domain rebuilds call rq_offline with the CPU staying alive */
 	if (cpu_active(cpu_of(rq)))
 		return;
 
-	scx_rescue_flush(rq);
-
-	/*
-	 * An offline CPU no longer calls ops.dispatch(). Re-enqueue its tasks
-	 * onto the local DSQ so that they run here and balance_push() moves
-	 * them off.
-	 */
-	list_for_each_entry_safe_reverse(p, n, &rq->scx.runnable_list, scx.runnable_node) {
-		if (p->scx.dsq == &rq->scx.local_dsq)
-			continue;
-		guard(sched_change)(p, DEQUEUE_SAVE | DEQUEUE_MOVE | DEQUEUE_NOCLOCK);
-	}
+	drain_offline_rq(rq);
 }
 
 static bool check_rq_for_timeouts(struct rq *rq)
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -4247,7 +4247,7 @@ extern void balance_callbacks(struct rq
  * Typically this must be called while holding task_rq_lock, since most/all
  * properties are serialized under those locks. There are currently two
  * exceptions to this rule in sched/ext which only hold rq->lock: scx_bypass()
- * and rq_offline_scx().
+ * and drain_offline_rq().
  */
 
 /*


