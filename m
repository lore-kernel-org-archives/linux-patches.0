Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 992C212B7C
	for <patches@lists.linux.dev>; Thu, 29 Jun 2023 18:47:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E20DC433C9;
	Thu, 29 Jun 2023 18:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688064424;
	bh=KwJhJRMPcVtMuCcclKSBmy8Ae22JXVyH8g50wqBsRqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K6Rmz8KfD91OPC5mcWkApUEyvlggLJ97jaGBo8rZDTRxOX+HdnywmYlRyEVTTyBJD
	 ozUidipGgZoKfbxTv7xAFC4w1yC1nVzOzZOx0UJMbV/uBqoV/8KolOi+dTlFWPsPSv
	 s9O9nACvUH/sd59DH5cDARV0QBAZSkPMT08S2Irs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Battersby <tonyb@cybernetics.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.3 05/29] x86/smp: Dont access non-existing CPUID leaf
Date: Thu, 29 Jun 2023 20:43:35 +0200
Message-ID: <20230629184151.960818053@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230629184151.705870770@linuxfoundation.org>
References: <20230629184151.705870770@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tony Battersby <tonyb@cybernetics.com>

commit 9b040453d4440659f33dc6f0aa26af418ebfe70b upstream.

stop_this_cpu() tests CPUID leaf 0x8000001f::EAX unconditionally. Intel
CPUs return the content of the highest supported leaf when a non-existing
leaf is read, while AMD CPUs return all zeros for unsupported leafs.

So the result of the test on Intel CPUs is lottery.

While harmless it's incorrect and causes the conditional wbinvd() to be
issued where not required.

Check whether the leaf is supported before reading it.

[ tglx: Adjusted changelog ]

Fixes: 08f253ec3767 ("x86/cpu: Clear SME feature flag when not in use")
Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/3817d810-e0f1-8ef8-0bbd-663b919ca49b@cybernetics.com
Link: https://lore.kernel.org/r/20230615193330.322186388@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/process.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -756,6 +756,7 @@ struct cpumask cpus_stop_mask;
 
 void __noreturn stop_this_cpu(void *dummy)
 {
+	struct cpuinfo_x86 *c = this_cpu_ptr(&cpu_info);
 	unsigned int cpu = smp_processor_id();
 
 	local_irq_disable();
@@ -770,7 +771,7 @@ void __noreturn stop_this_cpu(void *dumm
 	 */
 	set_cpu_online(cpu, false);
 	disable_local_APIC();
-	mcheck_cpu_clear(this_cpu_ptr(&cpu_info));
+	mcheck_cpu_clear(c);
 
 	/*
 	 * Use wbinvd on processors that support SME. This provides support
@@ -784,7 +785,7 @@ void __noreturn stop_this_cpu(void *dumm
 	 * Test the CPUID bit directly because the machine might've cleared
 	 * X86_FEATURE_SME due to cmdline options.
 	 */
-	if (cpuid_eax(0x8000001f) & BIT(0))
+	if (c->extended_cpuid_level >= 0x8000001f && (cpuid_eax(0x8000001f) & BIT(0)))
 		native_wbinvd();
 
 	/*


