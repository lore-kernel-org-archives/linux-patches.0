Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32D74F391B;
	Tue, 13 Oct 2026 11:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791891998; cv=none; b=KAcyVHdl8Ec03UpGQoEfSN6a4E9K1Qwy5vnKD8JpAu726tIUpz8kyIoPgCyKPSWoBO8f8uC1U3/wEYcbAehYrgEiV3wl5Hr/H/u5M2yb/dMiWttG5ZXulCKnN27v3raZtujwtkAUqEhlXYuDUwOpsLZrCSg+tbNJ+sB6sGALIh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791891998; c=relaxed/simple;
	bh=me4Kb6yWsfhG8mvfcDahGMD2nW7pmacGFghmPRhuA68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jhWq7oUaRovWLq+hwRLX0cD6g8UzvMTc/3rmKRV8wS3PT/uJWmp3BBhYpTy//nYjdXe2+d0Gb9RntvLGT15dqV03IMo/zV1QoXpdmF/pvrRPT+/+u8EHo2h3iVjsZcErbm+//8b5x8OMuYf3AthUKaL+eG/bEm6NfInGZcvdIhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r++LcISq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r++LcISq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 095291F000FF;
	Tue, 13 Oct 2026 11:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791891997;
	bh=yK7KLmRjaGGlMPLmFnFx1PTdTlwtWZEHlEN87VoTPCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r++LcISqVSl28kYoJs7LPUAcwGrKjXk3isGksHPPw7zDltRRFCEW5gB673vK0UuKo
	 JY2khy5Qb2Ym/BffBk/4pfyyDgNvshKOMLSlFWr3BBUeOCNDNsFN2x2TcKkvd0Q03l
	 17CeKl0bvq2Ix/a75dPh72QAC7N9rktxMPQXZ4J4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 7.2 026/281] cgroup/cpuset: Handle cpu hotplug race in guarantee_active_cpus()
Date: Tue, 13 Oct 2026 13:35:42 +0200
Message-ID: <20261013112855.685670977@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waiman Long <longman@redhat.com>

commit 23b1ab15ca91f2cffaf149d9bb0fafeb700c7db2 upstream.

With commit 2125c0034c5d ("cgroup/cpuset: Make cpuset hotplug processing
synchronous"), the cpuset hotplug operation becomes synchronous. That
commit also removes the code that handles race between cpuset_hotplug_work
and cpu hotplug notifier with the assumption that race is now gone.
Later commit 7a0aabd9ce69 ("cgroup/cpuset: Always use cpu_active_mask")
updates the cpuset code to always use cpu_active_mask instead of
cpu_online_mask in some places including guarantee_online_cpus() which
is renamed to guarantee_active_cpus() in that commit.

In the case of CPU offline operation, cpu_active_mask is updated
first in sched_cpu_deactivate() to remove the offline CPU before
cpuset_handle_hotplug() is called to update the effective_cpus of the
affected cpusets. The cpu_online_mask is updated after that near the end
of the offline operation to remove the offline CPU. As a result, the race
comes back and the top cpuset may not have any active CPU leading to NULL
pointer dereference during the race window when guarantee_active_cpus()
is called after cpu_active_mask is updated to remove the CPU to be torn
down but before cpuset_handle_hotplug() is able to properly update the
effective_cpus of the top cpuset.

Fix this by adding back the NULL cs check to avoid this problem.

Fixes: 7a0aabd9ce69 ("cgroup/cpuset: Always use cpu_active_mask")
Cc: stable@vger.kernel.org # v6.16+
Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Link: https://lore.kernel.org/lkml/CA+0ovChh3VjsKN1g+ZGjwwY2fGTpP7uD+aCCByLj5Qbymw=bfQ@mail.gmail.com
Signed-off-by: Waiman Long <longman@redhat.com>
Tested-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/cpuset.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -478,10 +478,26 @@ static void guarantee_active_cpus(struct
 	rcu_read_lock();
 	cs = task_cs(tsk);
 
-	while (!cpumask_intersects(cs->effective_cpus, pmask))
+	while (!cpumask_intersects(cs->effective_cpus, pmask)) {
 		cs = parent_cs(cs);
-
+		if (unlikely(!cs)) {
+			/*
+			 * The top cpuset doesn't have any active cpu as a
+			 * consequence of a race between its caller and the cpu
+			 * hotplug operation where cpu_active_mask is updated
+			 * asynchronously before cpuset_handle_hotplug() is
+			 * being called to adjust the effective_cpus of the
+			 * affected cpusets. But we know the top cpuset's
+			 * effective_cpus is on its way to be identical to
+			 * cpu_active_mask minus the exclusive CPUs dedicated
+			 * to other valid cpuset partitions. Just pass back
+			 * the filtered cpu_active_mask in this case.
+			 */
+			goto out_unlock;
+		}
+	}
 	cpumask_and(pmask, pmask, cs->effective_cpus);
+out_unlock:
 	rcu_read_unlock();
 }
 


