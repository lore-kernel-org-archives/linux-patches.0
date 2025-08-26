Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9615F284B5B;
	Tue, 26 Aug 2025 11:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208569; cv=none; b=CdZsfu7aOZTs/OaVgJNZm+fNJ7xXA9D/4s+zzf6n6VRAMFYUNpkI6FkEOznQfzauE7/1iWjx2eZPqpb2ZCSiBE/qHwT3C9sY+mssE0cTgLOtHZCvlwlaTFMtPpileRQIL4GbVACWqJRW3o9KOHIrOzcW8gxYvDC9WcxvFgo86p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208569; c=relaxed/simple;
	bh=TbTZtA8AjrTp7ucGMuN/oi9v/115u1Df6QYuTCkmmaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ic1VsVUc8aLr7dOnrbYdLlymyiNFkI+iOwSVRPJInEHa2deti94SFNn2BtOkSlRO+psrXnv29OK4OnzQbsZCMDLsYEaFE51l9y3tTlbE+xHk6nMPQklsgsnjLJAhXhRgefWimgRWzkfVYHGhW9xdgrzVbjiU8El/HMQFxYGjbVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pcnMT47t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pcnMT47t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21690C4CEF1;
	Tue, 26 Aug 2025 11:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208569;
	bh=TbTZtA8AjrTp7ucGMuN/oi9v/115u1Df6QYuTCkmmaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pcnMT47tTDJRKiv3e+J4wJAFmdTcLpLc2FvYKOrkbLcgLwnuvDKcC+dygJlMSV5b0
	 i0gStO/8mx6N5j0YPoiXUizLzkjOytynVXkH6rmzXAvlZso8lcAM2G/jzOURf8HgNK
	 4JVPhRERm2hH/XjzkNuy4JywZLq230Mm+dZDuRcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Righi <arighi@nvidia.com>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.12 161/322] sched_ext: initialize built-in idle state before ops.init()
Date: Tue, 26 Aug 2025 13:09:36 +0200
Message-ID: <20250826110919.799414880@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

From: Andrea Righi <arighi@nvidia.com>

commit f0c6eab5e45c529f449fbc595873719e00de6d79 upstream.

A BPF scheduler may want to use the built-in idle cpumasks in ops.init()
before the scheduler is fully initialized, either directly or through a
BPF timer for example.

However, this would result in an error, since the idle state has not
been properly initialized yet.

This can be easily verified by modifying scx_simple to call
scx_bpf_get_idle_cpumask() in ops.init():

$ sudo scx_simple

DEBUG DUMP
===========================================================================

scx_simple[121] triggered exit kind 1024:
  runtime error (built-in idle tracking is disabled)
...

Fix this by properly initializing the idle state before ops.init() is
called. With this change applied:

$ sudo scx_simple
local=2 global=0
local=19 global=11
local=23 global=11
...

Fixes: d73249f88743d ("sched_ext: idle: Make idle static keys private")
Signed-off-by: Andrea Righi <arighi@nvidia.com>
Reviewed-by: Joel Fernandes <joelagnelf@nvidia.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
[ Backport to 6.12:
  - Original commit doesn't apply cleanly to 6.12 since d73249f88743d is
    not present.
  - This backport applies the same logical fix to prevent BPF scheduler
    failures while accessing idle cpumasks from ops.init(). ]
Signed-off-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -5220,6 +5220,13 @@ static int scx_ops_enable(struct sched_e
 	for_each_possible_cpu(cpu)
 		cpu_rq(cpu)->scx.cpuperf_target = SCX_CPUPERF_ONE;
 
+	if (!ops->update_idle || (ops->flags & SCX_OPS_KEEP_BUILTIN_IDLE)) {
+		reset_idle_masks();
+		static_branch_enable(&scx_builtin_idle_enabled);
+	} else {
+		static_branch_disable(&scx_builtin_idle_enabled);
+	}
+
 	/*
 	 * Keep CPUs stable during enable so that the BPF scheduler can track
 	 * online CPUs by watching ->on/offline_cpu() after ->init().
@@ -5287,13 +5294,6 @@ static int scx_ops_enable(struct sched_e
 	if (scx_ops.cpu_acquire || scx_ops.cpu_release)
 		static_branch_enable(&scx_ops_cpu_preempt);
 
-	if (!ops->update_idle || (ops->flags & SCX_OPS_KEEP_BUILTIN_IDLE)) {
-		reset_idle_masks();
-		static_branch_enable(&scx_builtin_idle_enabled);
-	} else {
-		static_branch_disable(&scx_builtin_idle_enabled);
-	}
-
 	/*
 	 * Lock out forks, cgroup on/offlining and moves before opening the
 	 * floodgate so that they don't wander into the operations prematurely.


