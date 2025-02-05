Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D81771FF1BC;
	Wed,  5 Feb 2025 14:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767056; cv=none; b=nWdrNiQGfKj0jfmsh3ZYJETJQhWWwBXJ2IT4xEfhgAU+vjRgvR58atmM7y3I1/JA3YSQtB0+Mf59PdqpaqGUSe24La7NHxoVls+eBTYscj/5AEvw02tYFMzpNYbdndu/yFQFUJ16Wf8fZCN0owcM+k2U4hwVVyKdTbvjr/Qzh8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767056; c=relaxed/simple;
	bh=aCnfz/YQ98BnAMDambQfnfikojaNEsebvzEB+PbrTbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cyiHcnldawimIC5GCi7f5gt12aksOVJifYit4fbDMj8o1PPlktHR0HXLUP3sggQyii5c/fr5LbAgms8hzIaN7Dye3qYOu4JbsWB/u5d5hY0EKjvE2yMIa0RnkZTkMmdqefhMWS+3mDRwb8vZ3pS+ERYFf5B5dnGW4PZ6cjI82hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fDBSKUy0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fDBSKUy0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A96F4C4CED1;
	Wed,  5 Feb 2025 14:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767056;
	bh=aCnfz/YQ98BnAMDambQfnfikojaNEsebvzEB+PbrTbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fDBSKUy0oaPqFW1tN+1BRp8bTYr0rVvm0GfVxtPbQ4bxPfFYRFqH5RyEWx0uXovEs
	 JHsTsYYAF4PtsxGVssq7g+DKG9+vQlk4r0GNUf2AICmDwOUiAyush6MrU/rG+xeA+z
	 t1AVedyzByeRJXMHMS0ud3ZfRD/K4teEMlyyGRC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Joe Klein <joe.klein812@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 400/590] RDMA/rxe: Fix the warning "__rxe_cleanup+0x12c/0x170 [rdma_rxe]"
Date: Wed,  5 Feb 2025 14:42:35 +0100
Message-ID: <20250205134510.566907368@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhu Yanjun <yanjun.zhu@linux.dev>

[ Upstream commit edc4ef0e0154096d6c0cf5e06af6fc330dbad9d1 ]

The Call Trace is as below:
"
  <TASK>
  ? show_regs.cold+0x1a/0x1f
  ? __rxe_cleanup+0x12c/0x170 [rdma_rxe]
  ? __warn+0x84/0xd0
  ? __rxe_cleanup+0x12c/0x170 [rdma_rxe]
  ? report_bug+0x105/0x180
  ? handle_bug+0x46/0x80
  ? exc_invalid_op+0x19/0x70
  ? asm_exc_invalid_op+0x1b/0x20
  ? __rxe_cleanup+0x12c/0x170 [rdma_rxe]
  ? __rxe_cleanup+0x124/0x170 [rdma_rxe]
  rxe_destroy_qp.cold+0x24/0x29 [rdma_rxe]
  ib_destroy_qp_user+0x118/0x190 [ib_core]
  rdma_destroy_qp.cold+0x43/0x5e [rdma_cm]
  rtrs_cq_qp_destroy.cold+0x1d/0x2b [rtrs_core]
  rtrs_srv_close_work.cold+0x1b/0x31 [rtrs_server]
  process_one_work+0x21d/0x3f0
  worker_thread+0x4a/0x3c0
  ? process_one_work+0x3f0/0x3f0
  kthread+0xf0/0x120
  ? kthread_complete_and_exit+0x20/0x20
  ret_from_fork+0x22/0x30
  </TASK>
"
When too many rdma resources are allocated, rxe needs more time to
handle these rdma resources. Sometimes with the current timeout, rxe
can not release the rdma resources correctly.

Compared with other rdma drivers, a bigger timeout is used.

Fixes: 215d0a755e1b ("RDMA/rxe: Stop lookup of partially built objects")
Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Link: https://patch.msgid.link/20250110160927.55014-1-yanjun.zhu@linux.dev
Tested-by: Joe Klein <joe.klein812@gmail.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_pool.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_pool.c b/drivers/infiniband/sw/rxe/rxe_pool.c
index 67567d62195e8..d9cb682fd71f8 100644
--- a/drivers/infiniband/sw/rxe/rxe_pool.c
+++ b/drivers/infiniband/sw/rxe/rxe_pool.c
@@ -178,7 +178,6 @@ int __rxe_cleanup(struct rxe_pool_elem *elem, bool sleepable)
 {
 	struct rxe_pool *pool = elem->pool;
 	struct xarray *xa = &pool->xa;
-	static int timeout = RXE_POOL_TIMEOUT;
 	int ret, err = 0;
 	void *xa_ret;
 
@@ -202,19 +201,19 @@ int __rxe_cleanup(struct rxe_pool_elem *elem, bool sleepable)
 	 * return to rdma-core
 	 */
 	if (sleepable) {
-		if (!completion_done(&elem->complete) && timeout) {
+		if (!completion_done(&elem->complete)) {
 			ret = wait_for_completion_timeout(&elem->complete,
-					timeout);
+					msecs_to_jiffies(50000));
 
 			/* Shouldn't happen. There are still references to
 			 * the object but, rather than deadlock, free the
 			 * object or pass back to rdma-core.
 			 */
 			if (WARN_ON(!ret))
-				err = -EINVAL;
+				err = -ETIMEDOUT;
 		}
 	} else {
-		unsigned long until = jiffies + timeout;
+		unsigned long until = jiffies + RXE_POOL_TIMEOUT;
 
 		/* AH objects are unique in that the destroy_ah verb
 		 * can be called in atomic context. This delay
@@ -226,7 +225,7 @@ int __rxe_cleanup(struct rxe_pool_elem *elem, bool sleepable)
 			mdelay(1);
 
 		if (WARN_ON(!completion_done(&elem->complete)))
-			err = -EINVAL;
+			err = -ETIMEDOUT;
 	}
 
 	if (pool->cleanup)
-- 
2.39.5



