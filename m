Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB7F35C68A;
	Tue, 21 Jul 2026 21:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669207; cv=none; b=sQGxGnZPgnSI/OcP5iM5Qj7AsfACU0yc8p769QCCqH4lrAFYVzN1JADI9PVHv+o/hcTBh5AyU9W6MJEAi6blXbU5c3B6QiHBKPaSeNEbioyVLIjuiYTHUh3V2qRvdK05GUe1UvG91Fuy7YYo6EDDg+w0zRXHoaq4k1rT8B/g+kA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669207; c=relaxed/simple;
	bh=5GGWDc4YrNblkHdSIRuyWkZ6ea3Os0XEoa/4NFE5qKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WNbk/8mByU8Um2myX7fc/dImP/Tf5rz42bntYN7M1draYEfvF//U9VjG7jzcIICeuALPElJ3ndh6MV7e7mFp52ctarwtbdQChodja4ouxcaCK6ojD4ZfyDO4Q3n7W9ktGdua5nVm3o4ax+RgL9XSIgKtRtpHqV/Zd1IxRp++qRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AjiDwt35; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AjiDwt35"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D4CA1F000E9;
	Tue, 21 Jul 2026 21:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669205;
	bh=P7C6LYM9o7N0DKmxIPwYCrwHcRzcktv8zf7Xdw7tXAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AjiDwt35A/cd3g/XE/8qkqfghTjfgb5OPO5sFIRGPm1X3TZenqrXgd5e1UVeDqkk8
	 tb3QFz1f6oebF1F+Z/DPEIjjomKl8Q9W2gn304P4AWkZ7n2cBQs7Vq//UBRReWVCvX
	 B4WUPsPPQ8ckkdXX6HHYs6IywBkR4XxDsZPRRHbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aboorva Devarajan <aboorvad@linux.ibm.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0465/1067] powerpc/kexec: fix double get_cpu() imbalance in kexec_prepare_cpus
Date: Tue, 21 Jul 2026 17:17:46 +0200
Message-ID: <20260721152435.018466337@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index cda688bc5c9a8f..1d43ea88ff3d92 100644
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



