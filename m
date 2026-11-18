Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020814;
	b=t+YBcnGW7DdxukCFhbqQB937LWUX1pgyYOGAfpAM0FkuKJHrpNHg22lmeHN5bkI5p2Xb
	 y09Df2B5y0YNR1ErwBbb0MKVRyQel0NKOWPs3iyMoJjyGBtDND6SFsyUPnqlQ8P8vbO4B
	 JB1UdHRsRy5IXtI7E75RiSzYXcXcUgvLKGImxRkON8yHw/zUFkqRUo+lnT0+/l0vAI5qn
	 gQnzv0KgymonxxLUMdSlT7a4kAWbsrjWKY0aaJD1hhLsJhU4WbYEhWIuJPiOfJzzl9ar+
	 dNk/5NdVRvP/Ex75wg3C4tu7+H8mfVqQvnwFu/mZWBa1gMlC63cPEHP8t2uvxEnY/2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020814;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cYLrH0ONNiltt4h/HCiHQORaw777W84/7RjK2G4f8PQ=;
	b=NzPMWsV4TckBhb6GxR8dIfkDcM8Hn94w1QJlHVJ6gUDXZ4gAwSziyw0N6TZx4fdJTyTE
	 SqGwFSO7JysA3ryOyTv+MVKmkVOWMU42pt9dBr2ycRMlsTjMdtk+LrmqEmmp8gJc33kzy
	 pyLFn2fkV6GBfbFiSyyvAiF25gD5aVmpbebWPS0LMZvFRAoPNX7i0SebQGlTxyryAD2q4
	 1TwEaI5I+OKq7+Q0nd6wDg0tI9LGOlQUYO0a5oHuXu03eI/Ljh9T7480tEgtvadZgTFMF
	 VFZk0KEEkjqfeDIgFEvBCI0/PIpPnmx/Xy/Drw8TALTKXg7IPXKrT1YBuehi3iK2Yeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LeYe0XpB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3587360A5BCA;
	Wed, 18 Nov 2026 16:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LeYe0XpB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DE241F000C7;
	Wed, 18 Nov 2026 16:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020814;
	bh=cYLrH0ONNiltt4h/HCiHQORaw777W84/7RjK2G4f8PQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LeYe0XpB2gKVv+pE/Bwbsj71mWIjCQRs9qsIOGTbe59uYtKRoNA+fQ5JuLbVQA/VZ
	 mfMbtt1nBSBkyVfiA5a1hzuatn8Lcwr5EfsACZ+dStK1sZWQeSNdrAluguMztb7pCZ
	 l9Yrs8f/zDMXixu6kjEMVNvxS4v2q2fuCsJlM5E0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Andrea Righi <arighi@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2084/2651] sched_ext: Fix the running task keeping its protection into bypass
Date: Wed, 18 Nov 2026 15:55:24 +0100
Message-ID: <20261118150401.045706061@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

[ Upstream commit 30fb2b1e4d41a641a059f295a717ffa0e24307e7 ]

Protection ends when the scheduler enters bypass, so that bypass scheduling
can cut every task's slice. scx_bypass() clears it for the queued tasks by
cycling them, and strips the running task's in the same walk over
rq->scx.runnable_list. The running task is never on that list.
set_next_task_scx() takes it off and put_prev_task_scx() puts it back, so
the strip never runs. A protected running task then keeps its slice into
bypass, where the tick's attempts to cut it are refused.

Strip the running task's protection outside the walk.

Fixes: 9cfc6ab34a31 ("sched_ext: Add SCX_TASK_PROTECTED")
Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext/ext.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/ext/ext.c b/kernel/sched/ext/ext.c
index 84774147a1d5b..df445fdaeb6d6 100644
--- a/kernel/sched/ext/ext.c
+++ b/kernel/sched/ext/ext.c
@@ -6360,6 +6360,16 @@ void scx_bypass(struct scx_sched *sch, bool bypass)
 			continue;
 		}
 
+		/*
+		 * Bypass trumps protection. Cycling the queued tasks below
+		 * clears theirs. The current task isn't on the runnable list,
+		 * so strip its protection here.
+		 */
+		p = rq->curr;
+		if (bypass && p->sched_class == &ext_sched_class &&
+		    scx_is_descendant(scx_task_sched(p), sch))
+			scx_task_slice_ended(rq, p);
+
 		/*
 		 * The use of list_for_each_entry_safe_reverse() is required
 		 * because each task is going to be removed from and added back
@@ -6372,13 +6382,6 @@ void scx_bypass(struct scx_sched *sch, bool bypass)
 			if (!scx_is_descendant(scx_task_sched(p), sch))
 				continue;
 
-			/*
-			 * Bypass trumps protection. Cycling clears for queued
-			 * tasks but current task needs explicit stripping.
-			 */
-			if (bypass && task_current(rq, p))
-				scx_task_slice_ended(rq, p);
-
 			/* cycling deq/enq is enough, see the function comment */
 			scoped_guard (sched_change, p, DEQUEUE_SAVE | DEQUEUE_MOVE) {
 				/* nothing */ ;
-- 
2.53.0



