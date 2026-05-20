Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F133FC5B0;
	Wed, 20 May 2026 17:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299969; cv=none; b=ixk0toxQeTe/pK+NYpUv87tGtj1CADPuWmxUWcTFMiNDTqw79XzGGRMCsbzv9GpXmu+uLbBttBqjnfQV6Tstw0GTadaWqCMI/rYozn6h5X7U6SHlBB9bVKXeamLe50CCKJcFfPjWMi1z67AcuQTKnBw1ClPtCnI1PcAn9kWlpQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299969; c=relaxed/simple;
	bh=WtOuvgI9nuDP7EN0lkRdDmL6k/OfdK25oMFoMLVgEzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f1XXFFvOkQhbV9jNLBMK5MbJXpCamq31lwe6LPlwBkF87io+kehBxDZQpejdPwSm4E6Z1FYh6LqCHHhiJsUFZikwkHteOFl1Tca+lU1PlDtucLq5qo8PWBRLH1oQF2jR+HYhWXTz6jpHRpNlB7+LJafagFd3z8AYdh1OpsN3wXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bUrnsunu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bUrnsunu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C5FE1F00893;
	Wed, 20 May 2026 17:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299965;
	bh=J8ekor1fDo/mnaITJgdbwVK2xw7992KJvvzXr6eSe7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bUrnsunu/8sDQ5RAJa+cX1eq69mMXWJOh+7Lyvwm23423Iksr96hGuP1gxDm5mGTn
	 GoIylh9DG0keUwzfq/FAtGvRZzVaGR2WmjZBzjmyT+lKHSuCW+p/n7HbyemZEVBC5a
	 +WmIqwETSRCBUKJI7bzHwKg/gQVz0j0oDWKPqpP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Tejun Heo <tj@kernel.org>,
	Andrea Righi <arighi@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 954/957] sched_ext: Pass held rq to SCX_CALL_OP() for core_sched_before
Date: Wed, 20 May 2026 18:23:57 +0200
Message-ID: <20260520162155.292541619@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

[ Upstream commit 4155fb489fa175ec74eedde7d02219cf2fe74303 ]

scx_prio_less() runs from core-sched's pick_next_task() path with rq
locked but invokes ops.core_sched_before() with NULL locked_rq, leaving
scx_locked_rq_state NULL. If the BPF callback calls a kfunc that
re-acquires rq based on scx_locked_rq() - e.g. scx_bpf_cpuperf_set(cpu)
- it re-acquires the already-held rq.

Pass task_rq(a).

Fixes: 7b0888b7cc19 ("sched_ext: Implement core-sched support")
Cc: stable@vger.kernel.org # v6.12+
Reported-by: Chris Mason <clm@meta.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
[ adapted call to use stable's single `sch`/`SCX_KF_REST` mask and `scx_rq_bypassing(task_rq(a))` signature ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -2522,7 +2522,7 @@ bool scx_prio_less(const struct task_str
 	if (SCX_HAS_OP(sch, core_sched_before) &&
 	    !scx_rq_bypassing(task_rq(a)))
 		return SCX_CALL_OP_2TASKS_RET(sch, SCX_KF_REST, core_sched_before,
-					      NULL,
+					      task_rq(a),
 					      (struct task_struct *)a,
 					      (struct task_struct *)b);
 	else


