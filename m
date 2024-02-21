Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF0D7F7D6;
	Wed, 21 Feb 2024 14:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524866; cv=none; b=rf9k/r6vo0d0qs+LRjSzwA++e05BeodoJRCNpVJJzbOZgazyaHiAYeVg2HfVw+lypaOFYvUbF7TBLVK/plTjICRa62D9s4p4tEBz5fHP8SfgI/DVTKJiKWuACgvGegW7nvyfvvHwBNUtOdP+8tLmZrR6bXcUwhlMqI7Y8RY38EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524866; c=relaxed/simple;
	bh=zj6OODDNS0LXvHAFmwgIbBP48DWfPmwuJhzy+dLOjEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KFFoSFFZiWCfwP33kFYfVkTlohactYGalHQTDS+K3/mMYkM7H9R1sDSph84ya4+0I0qUFyhZ0MxtGpcPIoe9F/TVP/Hq2Zno2WbgYLJGkQzlMz215TDVrhmxWHFwZ/AaT5v2fCg4/XmKjCA8Y9yDROwMrN2WDsrisPL1ZD/JmEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MoUoNc7l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MoUoNc7l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 325B3C433C7;
	Wed, 21 Feb 2024 14:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524866;
	bh=zj6OODDNS0LXvHAFmwgIbBP48DWfPmwuJhzy+dLOjEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MoUoNc7lfgCxCDTE1tv0VvaM69u/CZhcRK2JnJF6EY3v0grShaAzhPfJDESa1ps0j
	 UVk0IeTTpzIYdqLEfp31N0YPcDfwcTNgmgS7Sq6IBgmvnbvhMsJ2pyyn+5+jsNtRbZ
	 Y1ImpinFCrMvontTmMGpCV1m24UUa8VAGhEzlqz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH 5.10 370/379] sched/membarrier: reduce the ability to hammer on sys_membarrier
Date: Wed, 21 Feb 2024 14:09:09 +0100
Message-ID: <20240221130006.007379036@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linuxfoundation.org>

commit 944d5fe50f3f03daacfea16300e656a1691c4a23 upstream.

On some systems, sys_membarrier can be very expensive, causing overall
slowdowns for everything.  So put a lock on the path in order to
serialize the accesses to prevent the ability for this to be called at
too high of a frequency and saturate the machine.

Reviewed-and-tested-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Acked-by: Borislav Petkov <bp@alien8.de>
Fixes: 22e4ebb97582 ("membarrier: Provide expedited private command")
Fixes: c5f58bd58f43 ("membarrier: Provide GLOBAL_EXPEDITED command")
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ converted to explicit mutex_*() calls - cleanup.h is not in this stable
  branch - gregkh ]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/membarrier.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/kernel/sched/membarrier.c
+++ b/kernel/sched/membarrier.c
@@ -34,6 +34,8 @@
 	| MEMBARRIER_PRIVATE_EXPEDITED_SYNC_CORE_BITMASK		\
 	| MEMBARRIER_PRIVATE_EXPEDITED_RSEQ_BITMASK)
 
+static DEFINE_MUTEX(membarrier_ipi_mutex);
+
 static void ipi_mb(void *info)
 {
 	smp_mb();	/* IPIs should be serializing but paranoid. */
@@ -119,6 +121,7 @@ static int membarrier_global_expedited(v
 	if (!zalloc_cpumask_var(&tmpmask, GFP_KERNEL))
 		return -ENOMEM;
 
+	mutex_lock(&membarrier_ipi_mutex);
 	cpus_read_lock();
 	rcu_read_lock();
 	for_each_online_cpu(cpu) {
@@ -165,6 +168,8 @@ static int membarrier_global_expedited(v
 	 * rq->curr modification in scheduler.
 	 */
 	smp_mb();	/* exit from system call is not a mb */
+	mutex_unlock(&membarrier_ipi_mutex);
+
 	return 0;
 }
 
@@ -208,6 +213,7 @@ static int membarrier_private_expedited(
 	if (cpu_id < 0 && !zalloc_cpumask_var(&tmpmask, GFP_KERNEL))
 		return -ENOMEM;
 
+	mutex_lock(&membarrier_ipi_mutex);
 	cpus_read_lock();
 
 	if (cpu_id >= 0) {
@@ -280,6 +286,7 @@ out:
 	 * rq->curr modification in scheduler.
 	 */
 	smp_mb();	/* exit from system call is not a mb */
+	mutex_unlock(&membarrier_ipi_mutex);
 
 	return 0;
 }
@@ -321,6 +328,7 @@ static int sync_runqueues_membarrier_sta
 	 * between threads which are users of @mm has its membarrier state
 	 * updated.
 	 */
+	mutex_lock(&membarrier_ipi_mutex);
 	cpus_read_lock();
 	rcu_read_lock();
 	for_each_online_cpu(cpu) {
@@ -337,6 +345,7 @@ static int sync_runqueues_membarrier_sta
 
 	free_cpumask_var(tmpmask);
 	cpus_read_unlock();
+	mutex_unlock(&membarrier_ipi_mutex);
 
 	return 0;
 }


