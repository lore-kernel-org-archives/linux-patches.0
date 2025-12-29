Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D26332EA9;
	Mon, 29 Dec 2025 16:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025925; cv=none; b=WhXsuhdhD/5m9QRA28FSiw1xDU0armBixP14xsjZnZsAk1rIqc6oVRUdCRSza5dTsbbFoc38a6S5i8kFONmu1zTdfLkBk1F/Iqf9zIxNR5LBS7vwtBVYo2EpdsmPCZuqhPj2rStBLsHEJhY685hp2HJ+r7wthx76YdgltynNZnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025925; c=relaxed/simple;
	bh=3vtf5WN2VH/n4wDqe++MV2iLwpmyP2GHvxcVdmR9kbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YTYwlVLLVbjJfrzwk+3RVksLH6Ki3IVeTP50IJBI3x5y6bKqZGJhLiMuVfkfZK5dM++slbHVhTzvj2S+8+Y+xk9s08dmJ1BLGE+NxZvzxg5NZQFI1w4rhnAnCoh6gTVLOB9ZcPcDwQQaInuNXLQCMKc52BpaEZ2TOTE7X5xlwiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=muVt3iJH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="muVt3iJH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89DC3C4CEF7;
	Mon, 29 Dec 2025 16:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025924;
	bh=3vtf5WN2VH/n4wDqe++MV2iLwpmyP2GHvxcVdmR9kbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=muVt3iJHUMOuRSbcwdBvjovo0i+8TRPt7ZgMqrCJXwcciOoo1D1CcuY7+WWxhatfz
	 /2Q7MFOtQtIoClrQWcNe+dSlj1Y5TuGex2Rcd8ARszfOqKEOeD4WolSyeoQZ7Vro9p
	 tC8EoX+Ras3JHSU0ZRlPGnICS51/Ucfzh3lEEWAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sachin P Bappalige <sachinpb@linux.ibm.com>,
	Srikar Dronamraju <srikar@linux.ibm.com>,
	"Nysal Jan K.A." <nysal@linux.ibm.com>,
	Samir M <samir@linux.ibm.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.18 378/430] powerpc/kexec: Enable SMT before waking offline CPUs
Date: Mon, 29 Dec 2025 17:13:00 +0100
Message-ID: <20251229160738.229872549@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Nysal Jan K.A. <nysal@linux.ibm.com>

commit c2296a1e42418556efbeb5636c4fa6aa6106713a upstream.

If SMT is disabled or a partial SMT state is enabled, when a new kernel
image is loaded for kexec, on reboot the following warning is observed:

kexec: Waking offline cpu 228.
WARNING: CPU: 0 PID: 9062 at arch/powerpc/kexec/core_64.c:223 kexec_prepare_cpus+0x1b0/0x1bc
[snip]
 NIP kexec_prepare_cpus+0x1b0/0x1bc
 LR  kexec_prepare_cpus+0x1a0/0x1bc
 Call Trace:
  kexec_prepare_cpus+0x1a0/0x1bc (unreliable)
  default_machine_kexec+0x160/0x19c
  machine_kexec+0x80/0x88
  kernel_kexec+0xd0/0x118
  __do_sys_reboot+0x210/0x2c4
  system_call_exception+0x124/0x320
  system_call_vectored_common+0x15c/0x2ec

This occurs as add_cpu() fails due to cpu_bootable() returning false for
CPUs that fail the cpu_smt_thread_allowed() check or non primary
threads if SMT is disabled.

Fix the issue by enabling SMT and resetting the number of SMT threads to
the number of threads per core, before attempting to wake up all present
CPUs.

Fixes: 38253464bc82 ("cpu/SMT: Create topology_smt_thread_allowed()")
Reported-by: Sachin P Bappalige <sachinpb@linux.ibm.com>
Cc: stable@vger.kernel.org # v6.6+
Reviewed-by: Srikar Dronamraju <srikar@linux.ibm.com>
Signed-off-by: Nysal Jan K.A. <nysal@linux.ibm.com>
Tested-by: Samir M <samir@linux.ibm.com>
Reviewed-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20251028105516.26258-1-nysal@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kexec/core_64.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/arch/powerpc/kexec/core_64.c
+++ b/arch/powerpc/kexec/core_64.c
@@ -202,6 +202,23 @@ static void kexec_prepare_cpus_wait(int
 	mb();
 }
 
+
+/*
+ * The add_cpu() call in wake_offline_cpus() can fail as cpu_bootable()
+ * returns false for CPUs that fail the cpu_smt_thread_allowed() check
+ * or non primary threads if SMT is disabled. Re-enable SMT and set the
+ * number of SMT threads to threads per core.
+ */
+static void kexec_smt_reenable(void)
+{
+#if defined(CONFIG_SMP) && defined(CONFIG_HOTPLUG_SMT)
+	lock_device_hotplug();
+	cpu_smt_num_threads = threads_per_core;
+	cpu_smt_control = CPU_SMT_ENABLED;
+	unlock_device_hotplug();
+#endif
+}
+
 /*
  * We need to make sure each present CPU is online.  The next kernel will scan
  * the device tree and assume primary threads are online and query secondary
@@ -216,6 +233,8 @@ static void wake_offline_cpus(void)
 {
 	int cpu = 0;
 
+	kexec_smt_reenable();
+
 	for_each_present_cpu(cpu) {
 		if (!cpu_online(cpu)) {
 			printk(KERN_INFO "kexec: Waking offline cpu %d.\n",


