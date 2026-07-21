Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CDB1434E2F;
	Tue, 21 Jul 2026 22:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673847; cv=none; b=I4e4edaKAEU2IYulBAMTv3wKa3yNOcdG/eqai4gps4vDZmVRLadITxfYEdB7mwqYeyH0rY1V2fIPz4qX0EWt8kNYImgIUN6oeJjCxM4K4Vx3wXCmPoo6hNDL2JZdFCh2zLOQXIykJjkw5OwhE4XlYw7vQCJmJ9DvaiPK8uHUg/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673847; c=relaxed/simple;
	bh=1jyMiWP4dSYQ095E5R1oZQipTZ86truUoJT+JFLWA1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J0QQE2Hbl/k6SuWisO/Ges0klT7qhoMVf/Co4vE5kS5W9MgWyMfLGIGLXfogGsfPhEkjkenO+sbq24rRDCSjMF8jKJ2bGj4pVQKgc/bLM6f1mSVejWfJOs8U/xE8la9ED6iQ6W717he9v/YIL4FBl4k9GL23HG1YoZBg8kVmkO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=feU+7Nmt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="feU+7Nmt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 720201F000E9;
	Tue, 21 Jul 2026 22:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673845;
	bh=1ytCulUB42d6WDUwae25EkyFwcNg7akorvcf0Ac9JLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=feU+7Nmt1oAPTY7bULXZKsjh4VitpeYvX49CRFm9A3LKweA23ZHB5jco3kuuWcpEW
	 Vc5VEE8sT+3wE/LSTt1zjy8nm4b/aVqXRhif70vRDJ3/b0GuTDhETujPPH5VzgTUnL
	 r9NTY/ZW+FbF5ES0IejNgkEH2ZWpsnAoSWZi/jNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aboorva Devarajan <aboorvad@linux.ibm.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 274/699] powerpc/kexec: fix double get_cpu() imbalance in kexec_prepare_cpus
Date: Tue, 21 Jul 2026 17:20:33 +0200
Message-ID: <20260721152401.879755236@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aboorva Devarajan <aboorvad@linux.ibm.com>

[ Upstream commit 5c86f1c1f972761a04bf22f4c0618d1aa714185b ]

kexec_prepare_cpus_wait() calls get_cpu() internally to obtain the
current CPU id. kexec_prepare_cpus() calls kexec_prepare_cpus_wait()
twice -- once for KEXEC_STATE_IRQS_OFF and once for
KEXEC_STATE_REAL_MODE -- but only issues a single put_cpu() at the end,
leaving preempt_count elevated by one extra nesting level.

In practice the imbalance does not trigger a 'scheduling while atomic'
splat because the kexec path is a one-way trip: IRQs are already
disabled, no schedule() occurs after the leak, and
default_machine_kexec() overwrites preempt_count with HARDIRQ_OFFSET
before jumping into kexec_sequence() which never returns. However the
bookkeeping is still wrong.

kexec_prepare_cpus() calls local_irq_disable()/hard_irq_disable()
before invoking kexec_prepare_cpus_wait(), so the CPU is already pinned
and the get_cpu()/put_cpu() preempt_disable() bracketing is unnecessary.
Only the current CPU id is needed, so replace get_cpu() with
raw_smp_processor_id() and drop the now-unneeded put_cpu().

Fixes: 1fc711f7ffb0 ("powerpc/kexec: Fix race in kexec shutdown")
Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Reviewed-by: Shrikanth Hegde <sshegde@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260605082912.305100-4-aboorvad@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kexec/core_64.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/powerpc/kexec/core_64.c b/arch/powerpc/kexec/core_64.c
index 8a449b2d8715d8..348120e3c0ea53 100644
--- a/arch/powerpc/kexec/core_64.c
+++ b/arch/powerpc/kexec/core_64.c
@@ -163,7 +163,7 @@ static void kexec_prepare_cpus_wait(int wait_state)
 	int my_cpu, i, notified=-1;
 
 	hw_breakpoint_disable();
-	my_cpu = get_cpu();
+	my_cpu = raw_smp_processor_id();
 	/* Make sure each CPU has at least made it to the state we need.
 	 *
 	 * FIXME: There is a (slim) chance of a problem if not all of the CPUs
@@ -242,8 +242,6 @@ static void kexec_prepare_cpus(void)
 	/* after we tell the others to go down */
 	if (ppc_md.kexec_cpu_down)
 		ppc_md.kexec_cpu_down(0, 0);
-
-	put_cpu();
 }
 
 #else /* ! SMP */
-- 
2.53.0



