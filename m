Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B099C7BB16;
	Wed, 21 Feb 2024 13:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523521; cv=none; b=T2HOQHFSDDhEVIie7uh+TxfZsvmLx3rfH8yuXz3BQMeSla5sDh0xBwXZokCiaIlUCnIGnfFaqbkP4qnhj7hAyOnpLVS7LIFBY9d+LXNNr4m/HaITSASjq26jNCNypnF0OvRExjSL0ztbAMU++85gjiJVYm8nvoy2ZURhWkDp1tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523521; c=relaxed/simple;
	bh=vy9+LI9EQmigCDSjSRlUdp2oZX9GwwApKWOSS8PI7sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R0fmKAOXrLgR8tFpn4gt94v8oVwybt8X3JNIlsj3cdx548aCLs5GojcZIzmoA06p3wa1TRe3lPTvgbDcLIsfuPvT5ByclPaVUzcdqHV9wENOntOoKbFPNtSgSwZGxPsHT3G65pfsEX9a6qYXOpfr+69UIMp4p3Y8L4vR9rX/Zdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e/uqHcqM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e/uqHcqM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48CC7C433C7;
	Wed, 21 Feb 2024 13:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523519;
	bh=vy9+LI9EQmigCDSjSRlUdp2oZX9GwwApKWOSS8PI7sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e/uqHcqM9e3NHYOaTwX+qvMGm8v5EA0qFKCrvDRm0RCWbGOFJOIAqoa5kImnq/EPA
	 nSZRRn6/aplmodXnzfd2u9pLibpGxGQ4CRNlDJl7iNqWfp2Eyb3KOp0DoFj0PdJ8y/
	 AZkJ9SNyhBzhTanIDLh1TGqSLjsammh2ci8jE1Wk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH 5.15 461/476] sched/membarrier: reduce the ability to hammer on sys_membarrier
Date: Wed, 21 Feb 2024 14:08:32 +0100
Message-ID: <20240221130025.091533832@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -162,6 +162,8 @@
 	| MEMBARRIER_PRIVATE_EXPEDITED_SYNC_CORE_BITMASK		\
 	| MEMBARRIER_PRIVATE_EXPEDITED_RSEQ_BITMASK)
 
+static DEFINE_MUTEX(membarrier_ipi_mutex);
+
 static void ipi_mb(void *info)
 {
 	smp_mb();	/* IPIs should be serializing but paranoid. */
@@ -259,6 +261,7 @@ static int membarrier_global_expedited(v
 	if (!zalloc_cpumask_var(&tmpmask, GFP_KERNEL))
 		return -ENOMEM;
 
+	mutex_lock(&membarrier_ipi_mutex);
 	cpus_read_lock();
 	rcu_read_lock();
 	for_each_online_cpu(cpu) {
@@ -304,6 +307,8 @@ static int membarrier_global_expedited(v
 	 * rq->curr modification in scheduler.
 	 */
 	smp_mb();	/* exit from system call is not a mb */
+	mutex_unlock(&membarrier_ipi_mutex);
+
 	return 0;
 }
 
@@ -347,6 +352,7 @@ static int membarrier_private_expedited(
 	if (cpu_id < 0 && !zalloc_cpumask_var(&tmpmask, GFP_KERNEL))
 		return -ENOMEM;
 
+	mutex_lock(&membarrier_ipi_mutex);
 	cpus_read_lock();
 
 	if (cpu_id >= 0) {
@@ -419,6 +425,7 @@ out:
 	 * rq->curr modification in scheduler.
 	 */
 	smp_mb();	/* exit from system call is not a mb */
+	mutex_unlock(&membarrier_ipi_mutex);
 
 	return 0;
 }
@@ -460,6 +467,7 @@ static int sync_runqueues_membarrier_sta
 	 * between threads which are users of @mm has its membarrier state
 	 * updated.
 	 */
+	mutex_lock(&membarrier_ipi_mutex);
 	cpus_read_lock();
 	rcu_read_lock();
 	for_each_online_cpu(cpu) {
@@ -476,6 +484,7 @@ static int sync_runqueues_membarrier_sta
 
 	free_cpumask_var(tmpmask);
 	cpus_read_unlock();
+	mutex_unlock(&membarrier_ipi_mutex);
 
 	return 0;
 }


