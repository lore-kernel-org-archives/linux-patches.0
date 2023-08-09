Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E41CE171A6
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:02:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6696BC433C8;
	Wed,  9 Aug 2023 11:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578921;
	bh=0vIWfL4YBb/DOhwa7H1jBUpkwOSYe1H/k7bcsN3MC5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=piZTD1It4UTNqwuF6HPCPgEQ1lhhH6lWOHS6oWpFUPZa8/sb7T8wJ1cYzyN2HwaWk
	 IpdVQhc7PlwZsemDHG8xQZoN3wktQY/SwPSCkdHjf328OysB6+ztaWAqeTw8LXci7U
	 hsavFfCWcYFH1w/qJHkL6KWmbRh8qSbV63+qWrMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Ashok Raj <ashok.raj@intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 4.14 003/204] x86/smp: Use dedicated cache-line for mwait_play_dead()
Date: Wed,  9 Aug 2023 12:39:01 +0200
Message-ID: <20230809103642.671195573@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.552405807@linuxfoundation.org>
References: <20230809103642.552405807@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Thomas Gleixner <tglx@linutronix.de>

commit f9c9987bf52f4e42e940ae217333ebb5a4c3b506 upstream.

Monitoring idletask::thread_info::flags in mwait_play_dead() has been an
obvious choice as all what is needed is a cache line which is not written
by other CPUs.

But there is a use case where a "dead" CPU needs to be brought out of
MWAIT: kexec().

This is required as kexec() can overwrite text, pagetables, stacks and the
monitored cacheline of the original kernel. The latter causes MWAIT to
resume execution which obviously causes havoc on the kexec kernel which
results usually in triple faults.

Use a dedicated per CPU storage to prepare for that.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Ashok Raj <ashok.raj@intel.com>
Reviewed-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230615193330.434553750@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/smpboot.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -94,6 +94,17 @@ DEFINE_PER_CPU_READ_MOSTLY(cpumask_var_t
 DEFINE_PER_CPU_READ_MOSTLY(struct cpuinfo_x86, cpu_info);
 EXPORT_PER_CPU_SYMBOL(cpu_info);
 
+struct mwait_cpu_dead {
+	unsigned int	control;
+	unsigned int	status;
+};
+
+/*
+ * Cache line aligned data for mwait_play_dead(). Separate on purpose so
+ * that it's unlikely to be touched by other CPUs.
+ */
+static DEFINE_PER_CPU_ALIGNED(struct mwait_cpu_dead, mwait_cpu_dead);
+
 /* Logical package management. We might want to allocate that dynamically */
 static int *physical_to_logical_pkg __read_mostly;
 static unsigned long *physical_package_map __read_mostly;;
@@ -1638,10 +1649,10 @@ static bool wakeup_cpu0(void)
  */
 static inline void mwait_play_dead(void)
 {
+	struct mwait_cpu_dead *md = this_cpu_ptr(&mwait_cpu_dead);
 	unsigned int eax, ebx, ecx, edx;
 	unsigned int highest_cstate = 0;
 	unsigned int highest_subcstate = 0;
-	void *mwait_ptr;
 	int i;
 
 	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD)
@@ -1675,13 +1686,6 @@ static inline void mwait_play_dead(void)
 			(highest_subcstate - 1);
 	}
 
-	/*
-	 * This should be a memory location in a cache line which is
-	 * unlikely to be touched by other processors.  The actual
-	 * content is immaterial as it is not actually modified in any way.
-	 */
-	mwait_ptr = &current_thread_info()->flags;
-
 	wbinvd();
 
 	while (1) {
@@ -1693,9 +1697,9 @@ static inline void mwait_play_dead(void)
 		 * case where we return around the loop.
 		 */
 		mb();
-		clflush(mwait_ptr);
+		clflush(md);
 		mb();
-		__monitor(mwait_ptr, 0, 0);
+		__monitor(md, 0, 0);
 		mb();
 		__mwait(eax, 0);
 		/*


