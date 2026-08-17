Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1993D3F9287;
	Mon, 17 Aug 2026 13:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786973882; cv=none; b=bCnRgGg8X+p6Ddf1NANy9g/HawxzpMrk2tf7FyPZzArHwWTs/rdbLR878oIm4tZaYr+Pg0Iirh22OT5G/B+rVW2nwu1HYxWeMvOe6uh93i31rZmeft72dXDrlI4TqSYRJHTf4sJVUXAJu4TnXudjQeJRoSSfGOPOCO16KwTJM/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786973882; c=relaxed/simple;
	bh=Pt1xOWfr4ORwdg9v1RMv2F42iq0fK2fC8MoybthM3h0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r+4ZDd8HFMxunpRYzcqYfNKINmHsgWm4MFNtjn74pN1qYZZfj1UcfYd6nPd/CAyXOXiIGloVgYnHWNUc/5CGOEmG7Hx6dapcnC+gqJTn61fhEZh9VCGZVAX41/ALr9W7xPcJbgLK92CfiN3jyJ3HLN1/7s3YDXujR0WWNHv41qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mB62HWqk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mB62HWqk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C2581F00A3D;
	Mon, 17 Aug 2026 13:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786973877;
	bh=FhteTHikJTy8n45/SstwAp9QF8eA8dgKp4XN1Tk1HGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mB62HWqkGE4VRB5PNoZ5q35Vl1udRgFtWBkCv8YOlIuyv2feh2c01MXSiYWLUJ1xX
	 kmNfnc9ZwM03rvHT2fBqlagoQETGhMPBXfw93b7S+k0HRsOxHQHfxqIUu7giTq8atC
	 ccTs/1Um0mW28e8MwPSKOaTLJuvQtBUfsJuC5K8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Andrea Righi <arighi@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 013/271] sched_ext: Reject setting disallow from init_task outside the enable path
Date: Mon, 17 Aug 2026 15:28:58 +0200
Message-ID: <20260817132537.310181777@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

[ Upstream commit 477869bfafea65492d23de62c1b5208147c09dd2 ]

The p->scx.disallow revert assumes the root enable path, where the switching
loop reads the reverted policy right afterwards and leaves the task off SCX.
The sub-scheduler disable path also reaches it when re-initializing the
returned tasks on a root parent. Nothing reads the policy there: the task is
enabled on root anyway and keeps running on the ext class with a silently
rewritten policy.

Kill the sched instead, matching the fork and non-root branches, and update
the disallow documentation, which equated !fork with the load path and
pointed at a stale debugfs path for nr_rejected.

Fixes: 337ec00b1d9c ("sched_ext: Implement cgroup sub-sched enabling and disabling")
Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched/ext.h | 10 +++++-----
 kernel/sched/ext.c        |  3 +++
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/include/linux/sched/ext.h b/include/linux/sched/ext.h
index 2129e18ada58b..31c810a3b808b 100644
--- a/include/linux/sched/ext.h
+++ b/include/linux/sched/ext.h
@@ -235,11 +235,11 @@ struct sched_ext_entity {
 	 * to %SCHED_EXT with -%EACCES.
 	 *
 	 * Can be set from ops.init_task() while the BPF scheduler is being
-	 * loaded (!scx_init_task_args->fork). If set and the task's policy is
-	 * already %SCHED_EXT, the task's policy is rejected and forcefully
-	 * reverted to %SCHED_NORMAL. The number of such events are reported
-	 * through /sys/kernel/debug/sched_ext::nr_rejected. Setting this flag
-	 * during fork is not allowed.
+	 * loaded. If set and the task's policy is already %SCHED_EXT, the
+	 * task's policy is rejected and forcefully reverted to %SCHED_NORMAL.
+	 * The number of such events are reported through
+	 * /sys/kernel/sched_ext/nr_rejected. Setting this flag from any other
+	 * ops.init_task() invocation, such as during fork, fails the scheduler.
 	 */
 	bool			disallow;	/* reject switching into SCX */
 
diff --git a/kernel/sched/ext.c b/kernel/sched/ext.c
index 5c780756e3623..6904d65d2b852 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -3581,6 +3581,9 @@ static int __scx_init_task(struct scx_sched *sch, struct task_struct *p, bool fo
 		} else if (unlikely(fork)) {
 			scx_error(sch, "ops.init_task() set task->scx.disallow for %s[%d] during fork",
 				  p->comm, p->pid);
+		} else if (unlikely(scx_enable_state() != SCX_ENABLING)) {
+			scx_error(sch, "ops.init_task() set task->scx.disallow for %s[%d] outside the enable path",
+				  p->comm, p->pid);
 		} else {
 			struct rq *rq;
 			struct rq_flags rf;
-- 
2.53.0



