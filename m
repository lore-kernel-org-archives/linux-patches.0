Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A68EB248BB2;
	Wed, 15 Jan 2025 10:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938182; cv=none; b=hSjb1NqMQ6AwdCekk+Cp/Dn3br1NBRYbCNl+lxZcvpXP8mlZNUYMLMpNu/U1kNaoRKSU9rQKtLaHyhAzQb/3XX+jUfPu+kV/kAqo0p/elynCYen/r2rU8hJ2zu/fBWOt9+pMLhHlRrZu6dtN6BntVfwl3lm0HOHJW0Lc4hbeSnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938182; c=relaxed/simple;
	bh=agWNYXdCgOwv8MlnlzMBYWM/Sd3kJeDRRdhiJxEgBBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mv9bD7zOJsVcp7QQxAZS+IVr1pokqCbHZ4TT06UpFw/PisHNTXQNWO2EqwcdRJJB6R9qjoGsaFKp+1KvGOrCONCjyg+YpzMi4Nm8ZO3YawtBIfuhiTZxTklximjROHDgElUgXvaJGDg6BoRNDC9yw48jPZjTMKQ2iHMHUfj5MoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ik0dwO4/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ik0dwO4/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D566DC4CEDF;
	Wed, 15 Jan 2025 10:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938181;
	bh=agWNYXdCgOwv8MlnlzMBYWM/Sd3kJeDRRdhiJxEgBBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ik0dwO4//bl9jYJVsAY2qwNXsyte1KZMuF19wmMum4U2DmceVOcVgKgqULdZOnf6B
	 UpBrtMrZpHiDIOJDh9Q+ZHJtV0H4OUxpN4oJiMU1N75K0iz6ZFexOdTLyBBnvPhP/2
	 XlFqq7UMn928IhZ2t1dcp7SDSBuPDDq40uKNFTAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Changwoo Min <changwoo@igalia.com>,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 108/189] sched_ext: Replace rq_lock() to raw_spin_rq_lock() in scx_ops_bypass()
Date: Wed, 15 Jan 2025 11:36:44 +0100
Message-ID: <20250115103610.761184053@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

From: Changwoo Min <changwoo@igalia.com>

[ Upstream commit 6268d5bc10354fc2ab8d44a0cd3b042d49a0417e ]

scx_ops_bypass() iterates all CPUs to re-enqueue all the scx tasks.
For each CPU, it acquires a lock using rq_lock() regardless of whether
a CPU is offline or the CPU is currently running a task in a higher
scheduler class (e.g., deadline). The rq_lock() is supposed to be used
for online CPUs, and the use of rq_lock() may trigger an unnecessary
warning in rq_pin_lock(). Therefore, replace rq_lock() to
raw_spin_rq_lock() in scx_ops_bypass().

Without this change, we observe the following warning:

===== START =====
[    6.615205] rq->balance_callback && rq->balance_callback != &balance_push_callback
[    6.615208] WARNING: CPU: 2 PID: 0 at kernel/sched/sched.h:1730 __schedule+0x1130/0x1c90
=====  END  =====

Fixes: 0e7ffff1b811 ("scx: Fix raciness in scx_ops_bypass()")
Signed-off-by: Changwoo Min <changwoo@igalia.com>
Acked-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/ext.c b/kernel/sched/ext.c
index 40f915f893e2..81235942555a 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -4348,10 +4348,9 @@ static void scx_ops_bypass(bool bypass)
 	 */
 	for_each_possible_cpu(cpu) {
 		struct rq *rq = cpu_rq(cpu);
-		struct rq_flags rf;
 		struct task_struct *p, *n;
 
-		rq_lock(rq, &rf);
+		raw_spin_rq_lock(rq);
 
 		if (bypass) {
 			WARN_ON_ONCE(rq->scx.flags & SCX_RQ_BYPASSING);
@@ -4367,7 +4366,7 @@ static void scx_ops_bypass(bool bypass)
 		 * sees scx_rq_bypassing() before moving tasks to SCX.
 		 */
 		if (!scx_enabled()) {
-			rq_unlock(rq, &rf);
+			raw_spin_rq_unlock(rq);
 			continue;
 		}
 
@@ -4387,10 +4386,11 @@ static void scx_ops_bypass(bool bypass)
 			sched_enq_and_set_task(&ctx);
 		}
 
-		rq_unlock(rq, &rf);
-
 		/* resched to restore ticks and idle state */
-		resched_cpu(cpu);
+		if (cpu_online(cpu) || cpu == smp_processor_id())
+			resched_curr(rq);
+
+		raw_spin_rq_unlock(rq);
 	}
 unlock:
 	raw_spin_unlock_irqrestore(&__scx_ops_bypass_lock, flags);
-- 
2.39.5



