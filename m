Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC80B471240;
	Tue, 21 Jul 2026 18:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656868; cv=none; b=ibLG68d9qwxewZ52NtmjSfdVunsMtKO5Rquyf2OmPTRkr0mUOjQOc2/h9JqP+6m8uduWuOCfjSIi+ub/hCz/FblCURh+FIrM/kUU3rBBOW6ym0NV4BOSn4Mnv/6Mds0Ex/eXfV7KbXWT6esFnoOEby4kq976Mk+yn6n6D/Dm3Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656868; c=relaxed/simple;
	bh=yd7kw9l0oOc+E4BNnhAOjBu9qpXTaN4SCl/rCEoJFLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MtkCj65B4cPugCvW/rhb/v8/MbbFypa4l1kgfSkgRsI5LCxeWyNS5tE58WHvMX3HegN3xvRQC/j523Q30CvhnuMRmjetPraYF1MydidrFl07G8qUNj8IdCrdBhGYCiqsp8T82thKk347PFaaS1yY0+xU/nsg8CoNsb93bt+xh2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M2Zu0qTB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M2Zu0qTB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47161F000E9;
	Tue, 21 Jul 2026 18:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656867;
	bh=BL/eC4Bfn+b2KtvejUgJhVf04hBVUEStwMya8GFKb/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M2Zu0qTBaqW7R7HEOCjD+rnCebmkS7QYDXHfCDp/CDcnKVdfu9o+EDhClCGChvSWq
	 aSCHoKSodhnLf35ZfeuvAuJ7QTuCB0s6nCm2ThgXoYW+V1iswtNi4T6YAzSkBLSre5
	 cD1prP0cenQya1sD2dCFE/gdVVUVYbrbAjS0NRfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aboorva Devarajan <aboorvad@linux.ibm.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0548/1611] powerpc/kexec: fix double get_cpu() imbalance in kexec_prepare_cpus
Date: Tue, 21 Jul 2026 17:11:04 +0200
Message-ID: <20260721152527.698710589@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 825ab8a88f18e6..58c13a59b93b58 100644
--- a/arch/powerpc/kexec/core_64.c
+++ b/arch/powerpc/kexec/core_64.c
@@ -169,7 +169,7 @@ static void kexec_prepare_cpus_wait(int wait_state)
 	int my_cpu, i, notified=-1;
 
 	hw_breakpoint_disable();
-	my_cpu = get_cpu();
+	my_cpu = raw_smp_processor_id();
 	/* Make sure each CPU has at least made it to the state we need.
 	 *
 	 * FIXME: There is a (slim) chance of a problem if not all of the CPUs
@@ -267,8 +267,6 @@ static void kexec_prepare_cpus(void)
 	/* after we tell the others to go down */
 	if (ppc_md.kexec_cpu_down)
 		ppc_md.kexec_cpu_down(0, 0);
-
-	put_cpu();
 }
 
 #else /* ! SMP */
-- 
2.53.0



