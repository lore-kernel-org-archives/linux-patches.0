Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625870;
	b=EhklaRmLNsyw6hvpdDD7Sb4fXsnbeo+PzmaYtXEbGGMHATl+ONc5NmBiCVxVDvjhLeU3
	 AXgtwP74Sx2sTRyCDUVc5gDHfg0Ib87vPtxYdwJjtWulpxz68WqCz6jvcRTQ6WWA1x/fV
	 MTe5MKESph9duavqCJn+P6lqlR5kEIsJE7rzKbSkENG+MpzOjgsBQk/ofu+Lx2+eUWa4F
	 DEuHMIWhybTEbOCv6AP0cUIruR61grY5us3ANkIooJtb+qI7EpLf4qtu3x9/uM/jBqy2p
	 IAuH7/opVztZJNBjX3R5yerXJ1qkVnTA/nrzaPPPj+IL1aRGjPtvcTtsCvHW2+LfcFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625870;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qQj+m6wQaxPJRbox/969boMl3TtSx7sNF2T7qxK18Dk=;
	b=nWFgJ/uICniTP12GGr+rGhIy5LBFiKyZSmVgetKS3CQ2z+bbKv0AA1TClmV4Z9wk43pi
	 pdSk3gCTgDHAnG35y7/Hj8zYjM06NkzmqW7HoQZUNIXXtfDRDsZ4xr9JSSRErcMiNJEoT
	 sZjX9s1Q1i0zMZiLjJuR02q9/JfP/cCzN6+rLnISdk5sRAjA9ooQMYNGOu2I/iAP7vra3
	 aq6FR5wUj1YYmwn3x4+xOHek79/gKU4juX4M5WReL94khl5SuzlVIm/v8DbVYFlRZy207
	 DKLNa/x5UBMQSZeXRqyUX3xISLliOOprcSiegTArlv8A8anBJgsDgsqIVJvjfHgew/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pkMCT7LY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13404606A321;
	Wed, 25 Nov 2026 16:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pkMCT7LY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39ACD1F000CF;
	Wed, 25 Nov 2026 16:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625869;
	bh=qQj+m6wQaxPJRbox/969boMl3TtSx7sNF2T7qxK18Dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pkMCT7LY7D8TceAc2RZy0peNGhIkvn+35BEwk7/44CCAYIhtGjsyS/r3Az0hJjXBs
	 KKumXXSmxWnCiL4qjmntLm5ACWrTVrI/TNPnGcLIpyFERXV2XfXZswL9CvVEbtatUD
	 Fikv4rRMTYee4Q4jgd0roP1QK39vWshaa+U1I/fA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Ridong Chen <chenridong@xiaomi.com>,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.12 612/816] cgroup/cpuset: Dont revive invalid partition without active CPU on hotplug
Date: Wed, 25 Nov 2026 15:36:00 +0100
Message-ID: <20261125143903.344850250@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ridong Chen <chenridong@xiaomi.com>

commit acec9637e03ca54bd3c3a0c1a6ad5c6dfa07c0df upstream.

When a CPU hotplug leaves no CPU outside of the partitions for the top
cpuset, cpuset_handle_hotplug() clears subpartitions_cpus and gives all
the active CPUs back to the top cpuset. cpuset_hotplug_update_tasks()
then walks the hierarchy and invalidates the partitions, as
subpartitions_cpus is empty.

However, an invalid partition visited in the same walk may be revived
if its effective_xcpus is not empty. tasks_nocpu_error() doesn't catch
it when its CPUs are all offline but it has no task. Its CPUs are put
back into subpartitions_cpus, and the valid partitions visited after it
are no longer invalidated, as subpartitions_cpus is not empty any more.
The top cpuset is left with CPUs overlapping with these partitions.

It can be reproduced on a system with 8 CPUs:

  # cd /sys/fs/cgroup
  # echo +cpuset > cgroup.subtree_control
  # mkdir A1 B1
  # echo 1 > A1/cpuset.cpus
  # echo 1 > A1/cpuset.cpus.exclusive
  # echo 0,2-7 > B1/cpuset.cpus
  # echo root > B1/cpuset.cpus.partition
  # echo root > A1/cpuset.cpus.partition
  # cat A1/cpuset.cpus.partition
  root invalid (Parent unable to distribute cpu downstream)
  # echo 0 > /sys/devices/system/cpu/cpu1/online
  # cat A1/cpuset.cpus.partition B1/cpuset.cpus.partition
  root
  root
  # cat cpuset.cpus.effective
  0,2-7

A1 can't take CPU 1, the last CPU of the root cgroup which has tasks.
When CPU 1 is offlined, A1 is revived without any active CPU, and B1
stays valid while its CPUs are also in the effective CPUs of the root
cgroup, which triggers

  WARNING: kernel/cgroup/cpuset.c:919 at rebuild_sched_domains_locked

Only revive an invalid partition in hotplug if its effective_xcpus has
an active CPU, the same as what is required to create a partition with
tasks. With that, A1 and B1 are both invalidated in the above case.

Fixes: 0c7f293efc87 ("cgroup/cpuset: Add cpuset.cpus.exclusive.effective for v2")
Cc: stable@vger.kernel.org # v6.7+
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20261114083124.1340140-1-ridong.chen%40linux.dev?part=11
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
Reviewed-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/cpuset.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3884,10 +3884,10 @@ retry:
 		partcmd = partcmd_invalidate;
 	/*
 	 * On the other hand, an invalid partition root may be transitioned
-	 * back to a regular one with a non-empty effective xcpus.
+	 * back to a regular one if its effective xcpus has an active CPU.
 	 */
 	else if (is_partition_valid(parent) && is_partition_invalid(cs) &&
-		 !cpumask_empty(cs->effective_xcpus))
+		 cpumask_intersects(cs->effective_xcpus, cpu_active_mask))
 		partcmd = partcmd_update;
 
 	if (partcmd >= 0) {


