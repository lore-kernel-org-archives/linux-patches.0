Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A5617C097;
	Wed, 21 Feb 2024 14:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525785; cv=none; b=jQ/HmYWjPGLUMHbVG4p3J2DbYdXGN9/1EDMkyXgXortOxRmvgwj83Pu0APzn3p7XrALfW7CXNjrU4Y3wj22OqO4M9S8QqkoZgvB0bfO+zJBq8i7307BsybzjyIBSZhGZd/5AHsH/HrE3rMt4mrLCXbJ9c9ijqRv94rbuR+W7eRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525785; c=relaxed/simple;
	bh=N7uts4nUbSQO8NeHtnXXzdP242E5lUzuSQJhjDRxHt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N1T8MtajRISPRYmzJ3h7UCCQeMc6ZQatNdofl7IiaBueGnrlUYEtseM3gZSb30cEwYG8ehZgjMJTCltzlGlF0iIlQP23j/QYBBR/ufmOHVu89b7DfMRnC/WXjCNZhUMyCFLPixYQIYxd7lYaBEKCnLtXWzbT8oDntV5saljbjzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r9d6wK1p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r9d6wK1p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEB73C433F1;
	Wed, 21 Feb 2024 14:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525785;
	bh=N7uts4nUbSQO8NeHtnXXzdP242E5lUzuSQJhjDRxHt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r9d6wK1pAEKMdHk8ItuK59cWcqs1qILGgJyQ5yAPCZ2RIev2TGjNDlTRkoI0O4hjM
	 F03cFvI9w2HfPBTJlle+fIczWlZdIW9CxmSoQlslXB8zMyE+9OzOA62XLhRD0JQA2s
	 zIjpaZm+YeSg90LxO9eojUggg7Af3DOn9PqtAD/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH 5.4 256/267] sched/membarrier: reduce the ability to hammer on sys_membarrier
Date: Wed, 21 Feb 2024 14:09:57 +0100
Message-ID: <20240221125948.290127023@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -25,6 +25,8 @@
 	| MEMBARRIER_CMD_REGISTER_PRIVATE_EXPEDITED			\
 	| MEMBARRIER_PRIVATE_EXPEDITED_SYNC_CORE_BITMASK)
 
+static DEFINE_MUTEX(membarrier_ipi_mutex);
+
 static void ipi_mb(void *info)
 {
 	smp_mb();	/* IPIs should be serializing but paranoid. */
@@ -97,6 +99,7 @@ static int membarrier_global_expedited(v
 	if (!zalloc_cpumask_var(&tmpmask, GFP_KERNEL))
 		return -ENOMEM;
 
+	mutex_lock(&membarrier_ipi_mutex);
 	cpus_read_lock();
 	rcu_read_lock();
 	for_each_online_cpu(cpu) {
@@ -143,6 +146,8 @@ static int membarrier_global_expedited(v
 	 * rq->curr modification in scheduler.
 	 */
 	smp_mb();	/* exit from system call is not a mb */
+	mutex_unlock(&membarrier_ipi_mutex);
+
 	return 0;
 }
 
@@ -178,6 +183,7 @@ static int membarrier_private_expedited(
 	if (!zalloc_cpumask_var(&tmpmask, GFP_KERNEL))
 		return -ENOMEM;
 
+	mutex_lock(&membarrier_ipi_mutex);
 	cpus_read_lock();
 	rcu_read_lock();
 	for_each_online_cpu(cpu) {
@@ -212,6 +218,7 @@ static int membarrier_private_expedited(
 	 * rq->curr modification in scheduler.
 	 */
 	smp_mb();	/* exit from system call is not a mb */
+	mutex_unlock(&membarrier_ipi_mutex);
 
 	return 0;
 }
@@ -253,6 +260,7 @@ static int sync_runqueues_membarrier_sta
 	 * between threads which are users of @mm has its membarrier state
 	 * updated.
 	 */
+	mutex_lock(&membarrier_ipi_mutex);
 	cpus_read_lock();
 	rcu_read_lock();
 	for_each_online_cpu(cpu) {
@@ -269,6 +277,7 @@ static int sync_runqueues_membarrier_sta
 
 	free_cpumask_var(tmpmask);
 	cpus_read_unlock();
+	mutex_unlock(&membarrier_ipi_mutex);
 
 	return 0;
 }


