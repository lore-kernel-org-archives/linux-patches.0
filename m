Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FAFF525D
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:31:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4374DC433CB;
	Sun, 17 Sep 2023 19:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694979115;
	bh=PgtadTjTrMYEGD+5jucQb9LJHRzWDph8QcG7hFsboX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HZPxQjgD8SUbhaM4+opYguKn3zWeHiXQUDiO4aKWej0IokVuOjNzgGysM9OP8XK+Z
	 p9o0Vq+60N00jsa4jHevdnht7zBK7N8zaTYTJP7N7hGs1Q5vAFZriNDpT9NtAK/msO
	 TIah6m+FQZOPIcyLb8tZ8ko7kEU/YMw/gCd06S/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Russell Currey <ruscur@russell.cc>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 193/406] powerpc/pseries: Rework lppaca_shared_proc() to avoid DEBUG_PREEMPT
Date: Sun, 17 Sep 2023 21:10:47 +0200
Message-ID: <20230917191106.295905431@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191101.035638219@linuxfoundation.org>
References: <20230917191101.035638219@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell Currey <ruscur@russell.cc>

[ Upstream commit eac030b22ea12cdfcbb2e941c21c03964403c63f ]

lppaca_shared_proc() takes a pointer to the lppaca which is typically
accessed through get_lppaca().  With DEBUG_PREEMPT enabled, this leads
to checking if preemption is enabled, for example:

  BUG: using smp_processor_id() in preemptible [00000000] code: grep/10693
  caller is lparcfg_data+0x408/0x19a0
  CPU: 4 PID: 10693 Comm: grep Not tainted 6.5.0-rc3 #2
  Call Trace:
    dump_stack_lvl+0x154/0x200 (unreliable)
    check_preemption_disabled+0x214/0x220
    lparcfg_data+0x408/0x19a0
    ...

This isn't actually a problem however, as it does not matter which
lppaca is accessed, the shared proc state will be the same.
vcpudispatch_stats_procfs_init() already works around this by disabling
preemption, but the lparcfg code does not, erroring any time
/proc/powerpc/lparcfg is accessed with DEBUG_PREEMPT enabled.

Instead of disabling preemption on the caller side, rework
lppaca_shared_proc() to not take a pointer and instead directly access
the lppaca, bypassing any potential preemption checks.

Fixes: f13c13a00512 ("powerpc: Stop using non-architected shared_proc field in lppaca")
Signed-off-by: Russell Currey <ruscur@russell.cc>
[mpe: Rework to avoid needing a definition in paca.h and lppaca.h]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20230823055317.751786-4-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/lppaca.h        | 11 +++++++++--
 arch/powerpc/platforms/pseries/lpar.c    | 10 +---------
 arch/powerpc/platforms/pseries/lparcfg.c |  4 ++--
 arch/powerpc/platforms/pseries/setup.c   |  2 +-
 drivers/cpuidle/cpuidle-pseries.c        |  8 +-------
 5 files changed, 14 insertions(+), 21 deletions(-)

diff --git a/arch/powerpc/include/asm/lppaca.h b/arch/powerpc/include/asm/lppaca.h
index 5d509ba0550b5..1412e643122e4 100644
--- a/arch/powerpc/include/asm/lppaca.h
+++ b/arch/powerpc/include/asm/lppaca.h
@@ -45,6 +45,7 @@
 #include <asm/types.h>
 #include <asm/mmu.h>
 #include <asm/firmware.h>
+#include <asm/paca.h>
 
 /*
  * The lppaca is the "virtual processor area" registered with the hypervisor,
@@ -123,14 +124,20 @@ struct lppaca {
  */
 #define LPPACA_OLD_SHARED_PROC		2
 
-static inline bool lppaca_shared_proc(struct lppaca *l)
+#ifdef CONFIG_PPC_PSERIES
+/*
+ * All CPUs should have the same shared proc value, so directly access the PACA
+ * to avoid false positives from DEBUG_PREEMPT.
+ */
+static inline bool lppaca_shared_proc(void)
 {
+	struct lppaca *l = local_paca->lppaca_ptr;
+
 	if (!firmware_has_feature(FW_FEATURE_SPLPAR))
 		return false;
 	return !!(l->__old_status & LPPACA_OLD_SHARED_PROC);
 }
 
-#ifdef CONFIG_PPC_PSERIES
 #define get_lppaca()	(get_paca()->lppaca_ptr)
 #endif
 
diff --git a/arch/powerpc/platforms/pseries/lpar.c b/arch/powerpc/platforms/pseries/lpar.c
index 28396a7e77d6f..68f3b082245e0 100644
--- a/arch/powerpc/platforms/pseries/lpar.c
+++ b/arch/powerpc/platforms/pseries/lpar.c
@@ -637,16 +637,8 @@ static const struct proc_ops vcpudispatch_stats_freq_proc_ops = {
 
 static int __init vcpudispatch_stats_procfs_init(void)
 {
-	/*
-	 * Avoid smp_processor_id while preemptible. All CPUs should have
-	 * the same value for lppaca_shared_proc.
-	 */
-	preempt_disable();
-	if (!lppaca_shared_proc(get_lppaca())) {
-		preempt_enable();
+	if (!lppaca_shared_proc())
 		return 0;
-	}
-	preempt_enable();
 
 	if (!proc_create("powerpc/vcpudispatch_stats", 0600, NULL,
 					&vcpudispatch_stats_proc_ops))
diff --git a/arch/powerpc/platforms/pseries/lparcfg.c b/arch/powerpc/platforms/pseries/lparcfg.c
index d3517e498512f..a7d4e25ae82a1 100644
--- a/arch/powerpc/platforms/pseries/lparcfg.c
+++ b/arch/powerpc/platforms/pseries/lparcfg.c
@@ -205,7 +205,7 @@ static void parse_ppp_data(struct seq_file *m)
 	           ppp_data.active_system_procs);
 
 	/* pool related entries are appropriate for shared configs */
-	if (lppaca_shared_proc(get_lppaca())) {
+	if (lppaca_shared_proc()) {
 		unsigned long pool_idle_time, pool_procs;
 
 		seq_printf(m, "pool=%d\n", ppp_data.pool_num);
@@ -529,7 +529,7 @@ static int pseries_lparcfg_data(struct seq_file *m, void *v)
 		   partition_potential_processors);
 
 	seq_printf(m, "shared_processor_mode=%d\n",
-		   lppaca_shared_proc(get_lppaca()));
+		   lppaca_shared_proc());
 
 #ifdef CONFIG_PPC_BOOK3S_64
 	seq_printf(m, "slb_size=%d\n", mmu_slb_size);
diff --git a/arch/powerpc/platforms/pseries/setup.c b/arch/powerpc/platforms/pseries/setup.c
index 0eac9ca782c21..822be2680b792 100644
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -800,7 +800,7 @@ static void __init pSeries_setup_arch(void)
 	if (firmware_has_feature(FW_FEATURE_LPAR)) {
 		vpa_init(boot_cpuid);
 
-		if (lppaca_shared_proc(get_lppaca())) {
+		if (lppaca_shared_proc()) {
 			static_branch_enable(&shared_processor);
 			pv_spinlocks_init();
 		}
diff --git a/drivers/cpuidle/cpuidle-pseries.c b/drivers/cpuidle/cpuidle-pseries.c
index ff164dec8422e..f4cf3ade03db8 100644
--- a/drivers/cpuidle/cpuidle-pseries.c
+++ b/drivers/cpuidle/cpuidle-pseries.c
@@ -409,13 +409,7 @@ static int __init pseries_idle_probe(void)
 		return -ENODEV;
 
 	if (firmware_has_feature(FW_FEATURE_SPLPAR)) {
-		/*
-		 * Use local_paca instead of get_lppaca() since
-		 * preemption is not disabled, and it is not required in
-		 * fact, since lppaca_ptr does not need to be the value
-		 * associated to the current CPU, it can be from any CPU.
-		 */
-		if (lppaca_shared_proc(local_paca->lppaca_ptr)) {
+		if (lppaca_shared_proc()) {
 			cpuidle_state_table = shared_states;
 			max_idle_state = ARRAY_SIZE(shared_states);
 		} else {
-- 
2.40.1



