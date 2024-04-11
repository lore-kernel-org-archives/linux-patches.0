Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01961145B1A;
	Thu, 11 Apr 2024 10:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831302; cv=none; b=gBkU44qVzti0yPuTBHc8SIkP/TnKB00g6VL55nXyg6k/VZO1eTlWw09PrUCdc04ZvR6n6wPnbIQSjAfUzT/zeQDgc6rFQK2kOBq95aS0KT8+iif0VjcpzYF+xwiCE5t4/p8Uw62QJZPmNNcbs0xlz+leEp2weM6ZkS0QM3so8gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831302; c=relaxed/simple;
	bh=zly6sxlopG6Qo7dhrUk48nIMfZdgyQZTsz8rA4eC3eY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DFlQdXJF8h/vzT7k9KiUOyQWwX4euY+73Ok+qtki0VERq5gaWf7ZgBv0iAvNPbn7ylC4IMninD7qzwKCyGFwbe/kGWTabx1yZ5Xke/tmdWXrSn1KmU5G8h5G36lfQnG/eV/0J/PPC/Irprq+rC/j3c1Pq6z8Ez7HmhuqX24MMzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1kgxFpdC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1kgxFpdC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31E6CC433C7;
	Thu, 11 Apr 2024 10:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831301;
	bh=zly6sxlopG6Qo7dhrUk48nIMfZdgyQZTsz8rA4eC3eY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1kgxFpdCM9Dcm+CpR9BIZpzMsYFk9bajKQb/zBFq73f4NQsR27N8mblpZjZ43Rudo
	 6ZhqpOeJmUy3rZygpC+T3stJSb9X1D1wQ6ffWk2UFSgHGO9rxWaTvmc9l1RPucmxrt
	 ICwCljkE+mgRkL2IalFFrZrUKTRpG2adAIqWw+Vs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manjunath Patil <manjunath.b.patil@oracle.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 077/114] RDMA/cm: add timeout to cm_destroy_id wait
Date: Thu, 11 Apr 2024 11:56:44 +0200
Message-ID: <20240411095419.212215678@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095416.853744210@linuxfoundation.org>
References: <20240411095416.853744210@linuxfoundation.org>
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

From: Manjunath Patil <manjunath.b.patil@oracle.com>

[ Upstream commit 96d9cbe2f2ff7abde021bac75eafaceabe9a51fa ]

Add timeout to cm_destroy_id, so that userspace can trigger any data
collection that would help in analyzing the cause of delay in destroying
the cm_id.

New noinline function helps dtrace/ebpf programs to hook on to it.
Existing functionality isn't changed except triggering a probe-able new
function at every timeout interval.

We have seen cases where CM messages stuck with MAD layer (either due to
software bug or faulty HCA), leading to cm_id getting stuck in the
following call stack. This patch helps in resolving such issues faster.

kernel: ... INFO: task XXXX:56778 blocked for more than 120 seconds.
...
	Call Trace:
	__schedule+0x2bc/0x895
	schedule+0x36/0x7c
	schedule_timeout+0x1f6/0x31f
 	? __slab_free+0x19c/0x2ba
	wait_for_completion+0x12b/0x18a
	? wake_up_q+0x80/0x73
	cm_destroy_id+0x345/0x610 [ib_cm]
	ib_destroy_cm_id+0x10/0x20 [ib_cm]
	rdma_destroy_id+0xa8/0x300 [rdma_cm]
	ucma_destroy_id+0x13e/0x190 [rdma_ucm]
	ucma_write+0xe0/0x160 [rdma_ucm]
	__vfs_write+0x3a/0x16d
	vfs_write+0xb2/0x1a1
	? syscall_trace_enter+0x1ce/0x2b8
	SyS_write+0x5c/0xd3
	do_syscall_64+0x79/0x1b9
	entry_SYSCALL_64_after_hwframe+0x16d/0x0

Signed-off-by: Manjunath Patil <manjunath.b.patil@oracle.com>
Link: https://lore.kernel.org/r/20240309063323.458102-1-manjunath.b.patil@oracle.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cm.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index ff58058aeadca..bf0df6ee4f785 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -34,6 +34,7 @@ MODULE_AUTHOR("Sean Hefty");
 MODULE_DESCRIPTION("InfiniBand CM");
 MODULE_LICENSE("Dual BSD/GPL");
 
+#define CM_DESTROY_ID_WAIT_TIMEOUT 10000 /* msecs */
 static const char * const ibcm_rej_reason_strs[] = {
 	[IB_CM_REJ_NO_QP]			= "no QP",
 	[IB_CM_REJ_NO_EEC]			= "no EEC",
@@ -1025,10 +1026,20 @@ static void cm_reset_to_idle(struct cm_id_private *cm_id_priv)
 	}
 }
 
+static noinline void cm_destroy_id_wait_timeout(struct ib_cm_id *cm_id)
+{
+	struct cm_id_private *cm_id_priv;
+
+	cm_id_priv = container_of(cm_id, struct cm_id_private, id);
+	pr_err("%s: cm_id=%p timed out. state=%d refcnt=%d\n", __func__,
+	       cm_id, cm_id->state, refcount_read(&cm_id_priv->refcount));
+}
+
 static void cm_destroy_id(struct ib_cm_id *cm_id, int err)
 {
 	struct cm_id_private *cm_id_priv;
 	struct cm_work *work;
+	int ret;
 
 	cm_id_priv = container_of(cm_id, struct cm_id_private, id);
 	spin_lock_irq(&cm_id_priv->lock);
@@ -1135,7 +1146,14 @@ static void cm_destroy_id(struct ib_cm_id *cm_id, int err)
 
 	xa_erase(&cm.local_id_table, cm_local_id(cm_id->local_id));
 	cm_deref_id(cm_id_priv);
-	wait_for_completion(&cm_id_priv->comp);
+	do {
+		ret = wait_for_completion_timeout(&cm_id_priv->comp,
+						  msecs_to_jiffies(
+						  CM_DESTROY_ID_WAIT_TIMEOUT));
+		if (!ret) /* timeout happened */
+			cm_destroy_id_wait_timeout(cm_id);
+	} while (!ret);
+
 	while ((work = cm_dequeue_work(cm_id_priv)) != NULL)
 		cm_free_work(work);
 
-- 
2.43.0



