Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836033EA7B
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BTWZSuOT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 313BCC433C8;
	Wed, 15 Nov 2023 19:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076779;
	bh=Bx5AImiBGPfOHh+KPCLMC90trv1K+FNIpSe8G1gh/Lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BTWZSuOTXX8wQYjUxuKukk8UndlsrS/nfeocCd7EmdeCKC+1yTefNSFqQbhqTDtqs
	 GZZ1HmOA95TItpNXZwZcsvN74ZFEhkMx5AKD/dxemooj9EB4r3sYwwPOTmyJIIOvxG
	 iXdToBInKGm9VYMO6+taz4Ukg6lWr7yHm/GMDoi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Gross <jgross@suse.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sohil Mehta <sohil.mehta@intel.com>,
	Michael Kelley <mikelley@microsoft.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Zhang Rui <rui.zhang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 024/603] cpu/SMT: Make SMT control more robust against enumeration failures
Date: Wed, 15 Nov 2023 14:09:29 -0500
Message-ID: <20231115191614.850043169@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit d91bdd96b55cc3ce98d883a60f133713821b80a6 ]

The SMT control mechanism got added as speculation attack vector
mitigation. The implemented logic relies on the primary thread mask to
be set up properly.

This turns out to be an issue with XEN/PV guests because their CPU hotplug
mechanics do not enumerate APICs and therefore the mask is never correctly
populated.

This went unnoticed so far because by chance XEN/PV ends up with
smp_num_siblings == 2. So smt_hotplug_control stays at its default value
CPU_SMT_ENABLED and the primary thread mask is never evaluated in the
context of CPU hotplug.

This stopped "working" with the upcoming overhaul of the topology
evaluation which legitimately provides a fake topology for XEN/PV. That
sets smp_num_siblings to 1, which causes the core CPU hot-plug core to
refuse to bring up the APs.

This happens because smt_hotplug_control is set to CPU_SMT_NOT_SUPPORTED
which causes cpu_smt_allowed() to evaluate the unpopulated primary thread
mask with the conclusion that all non-boot CPUs are not valid to be
plugged.

Make cpu_smt_allowed() more robust and take CPU_SMT_NOT_SUPPORTED and
CPU_SMT_NOT_IMPLEMENTED into account. Rename it to cpu_bootable() while at
it as that makes it more clear what the function is about.

The primary mask issue on x86 XEN/PV needs to be addressed separately as
there are users outside of the CPU hotplug code too.

Fixes: 05736e4ac13c ("cpu/hotplug: Provide knobs to control SMT")
Reported-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Juergen Gross <jgross@suse.com>
Tested-by: Sohil Mehta <sohil.mehta@intel.com>
Tested-by: Michael Kelley <mikelley@microsoft.com>
Tested-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Zhang Rui <rui.zhang@intel.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20230814085112.149440843@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cpu.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 6de7c6bb74eee..1a189da3bdac5 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -659,11 +659,19 @@ static inline bool cpu_smt_thread_allowed(unsigned int cpu)
 #endif
 }
 
-static inline bool cpu_smt_allowed(unsigned int cpu)
+static inline bool cpu_bootable(unsigned int cpu)
 {
 	if (cpu_smt_control == CPU_SMT_ENABLED && cpu_smt_thread_allowed(cpu))
 		return true;
 
+	/* All CPUs are bootable if controls are not configured */
+	if (cpu_smt_control == CPU_SMT_NOT_IMPLEMENTED)
+		return true;
+
+	/* All CPUs are bootable if CPU is not SMT capable */
+	if (cpu_smt_control == CPU_SMT_NOT_SUPPORTED)
+		return true;
+
 	if (topology_is_primary_thread(cpu))
 		return true;
 
@@ -685,7 +693,7 @@ bool cpu_smt_possible(void)
 EXPORT_SYMBOL_GPL(cpu_smt_possible);
 
 #else
-static inline bool cpu_smt_allowed(unsigned int cpu) { return true; }
+static inline bool cpu_bootable(unsigned int cpu) { return true; }
 #endif
 
 static inline enum cpuhp_state
@@ -788,10 +796,10 @@ static int bringup_wait_for_ap_online(unsigned int cpu)
 	 * SMT soft disabling on X86 requires to bring the CPU out of the
 	 * BIOS 'wait for SIPI' state in order to set the CR4.MCE bit.  The
 	 * CPU marked itself as booted_once in notify_cpu_starting() so the
-	 * cpu_smt_allowed() check will now return false if this is not the
+	 * cpu_bootable() check will now return false if this is not the
 	 * primary sibling.
 	 */
-	if (!cpu_smt_allowed(cpu))
+	if (!cpu_bootable(cpu))
 		return -ECANCELED;
 	return 0;
 }
@@ -1741,7 +1749,7 @@ static int cpu_up(unsigned int cpu, enum cpuhp_state target)
 		err = -EBUSY;
 		goto out;
 	}
-	if (!cpu_smt_allowed(cpu)) {
+	if (!cpu_bootable(cpu)) {
 		err = -EPERM;
 		goto out;
 	}
-- 
2.42.0



