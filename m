Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C552E3A8CC
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eXjYpmfw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10654C433C7;
	Wed, 15 Nov 2023 19:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076021;
	bh=04R9ZYZ7iOjqVfY477n9z28sDFVPfK2n9eVQ678WqaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eXjYpmfw1BjRYb1/Jsm4gzY4ywrTp/hbP0wkD6gSuoUKMztmk1OxzBDntPHG3ieXp
	 Z/rShrGH6Ums5fKtz2+WOeIFFgZAW2l1y6yAixISqFsG0J52B0/bv/PTam21sesgb5
	 CInZUX8FMgIvU7iMsTsgZzY2YmzUuL/rIGHdJ9SI=
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
Subject: [PATCH 6.5 025/550] cpu/SMT: Make SMT control more robust against enumeration failures
Date: Wed, 15 Nov 2023 14:10:09 -0500
Message-ID: <20231115191602.457259164@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
index 21864899c770a..26119d2154102 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -639,11 +639,19 @@ static inline bool cpu_smt_thread_allowed(unsigned int cpu)
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
 
@@ -665,7 +673,7 @@ bool cpu_smt_possible(void)
 EXPORT_SYMBOL_GPL(cpu_smt_possible);
 
 #else
-static inline bool cpu_smt_allowed(unsigned int cpu) { return true; }
+static inline bool cpu_bootable(unsigned int cpu) { return true; }
 #endif
 
 static inline enum cpuhp_state
@@ -768,10 +776,10 @@ static int bringup_wait_for_ap_online(unsigned int cpu)
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
@@ -1721,7 +1729,7 @@ static int cpu_up(unsigned int cpu, enum cpuhp_state target)
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



