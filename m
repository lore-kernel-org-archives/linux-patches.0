Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609A22F12A4;
	Fri, 21 Nov 2025 13:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763730887; cv=none; b=sfcZmxnVpzndg9gpcLBOktePZBPmgMYNyIbBixE1T26baXxY5rZSCNNcQfFWCKnYBzGEnzUivsZK5/sd166BD1JhToO0CAQzNwZUeT6fgwogGAZbzSnaX49i9FEqO83yEcgewXp3JqDURcl0Xw2TY16cNounqWDsXv4xGiNfGz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763730887; c=relaxed/simple;
	bh=7yoQEkLcWs2ihlQqesdzEgRI3qosvM1akyNPsQ3CW+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cv06zFj7fMY4Ut6bjtooegQXZgLcZgz6PsfCGyoDGJwvPNXs5uZT0pjYqIdGtkVwIBVElocatuumCUZ1vMoehSE1ocHD5a4rlNNYDAbJVMNDm0ISlnm/yfqY5b+RfsSeCunCGP8it+HhL4mMCFh6i0QpYe+sd0EH8ne/WbQtsCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZO0hkt8Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZO0hkt8Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B799C4CEF1;
	Fri, 21 Nov 2025 13:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763730887;
	bh=7yoQEkLcWs2ihlQqesdzEgRI3qosvM1akyNPsQ3CW+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZO0hkt8Y+Doxj3+4BWGxfhiPEQKMBbTOouFI3D5n8bj5PKHGEpbGC0nqfY8nJeToM
	 dHa0NtKFyCASMXgFUnW9ml/q2sD5Yi/pttoAVKCeRz9JRXx5RZeWVgUzjuO4cbFWel
	 X6OEIYLE+VB+8pYkYb6VRa91uFb5hz465OxhEmzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 009/247] futex: Optimize per-cpu reference counting
Date: Fri, 21 Nov 2025 14:09:16 +0100
Message-ID: <20251121130154.933262638@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 4cb5ac2626b5704ed712ac1d46b9d89fdfc12c5d ]

Shrikanth noted that the per-cpu reference counter was still some 10%
slower than the old immutable option (which removes the reference
counting entirely).

Further optimize the per-cpu reference counter by:

 - switching from RCU to preempt;
 - using __this_cpu_*() since we now have preempt disabled;
 - switching from smp_load_acquire() to READ_ONCE().

This is all safe because disabling preemption inhibits the RCU grace
period exactly like rcu_read_lock().

Having preemption disabled allows using __this_cpu_*() provided the
only access to the variable is in task context -- which is the case
here.

Furthermore, since we know changing fph->state to FR_ATOMIC demands a
full RCU grace period we can rely on the implied smp_mb() from that to
replace the acquire barrier().

This is very similar to the percpu_down_read_internal() fast-path.

The reason this is significant for PowerPC is that it uses the generic
this_cpu_*() implementation which relies on local_irq_disable() (the
x86 implementation relies on it being a single memop instruction to be
IRQ-safe). Switching to preempt_disable() and __this_cpu*() avoids
this IRQ state swizzling. Also, PowerPC needs LWSYNC for the ACQUIRE
barrier, not having to use explicit barriers safes a bunch.

Combined this reduces the performance gap by half, down to some 5%.

Fixes: 760e6f7befba ("futex: Remove support for IMMUTABLE")
Reported-by: Shrikanth Hegde <sshegde@linux.ibm.com>
Tested-by: Shrikanth Hegde <sshegde@linux.ibm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: https://patch.msgid.link/20251106092929.GR4067720@noisy.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/futex/core.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/futex/core.c b/kernel/futex/core.c
index 125804fbb5cb1..2e77a6e5c8657 100644
--- a/kernel/futex/core.c
+++ b/kernel/futex/core.c
@@ -1680,10 +1680,10 @@ static bool futex_ref_get(struct futex_private_hash *fph)
 {
 	struct mm_struct *mm = fph->mm;
 
-	guard(rcu)();
+	guard(preempt)();
 
-	if (smp_load_acquire(&fph->state) == FR_PERCPU) {
-		this_cpu_inc(*mm->futex_ref);
+	if (READ_ONCE(fph->state) == FR_PERCPU) {
+		__this_cpu_inc(*mm->futex_ref);
 		return true;
 	}
 
@@ -1694,10 +1694,10 @@ static bool futex_ref_put(struct futex_private_hash *fph)
 {
 	struct mm_struct *mm = fph->mm;
 
-	guard(rcu)();
+	guard(preempt)();
 
-	if (smp_load_acquire(&fph->state) == FR_PERCPU) {
-		this_cpu_dec(*mm->futex_ref);
+	if (READ_ONCE(fph->state) == FR_PERCPU) {
+		__this_cpu_dec(*mm->futex_ref);
 		return false;
 	}
 
-- 
2.51.0



