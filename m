Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB7F53E08;
	Mon,  8 Jan 2024 15:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ylrvrnHy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 551A2C433C8;
	Mon,  8 Jan 2024 15:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728463;
	bh=+Q5VFpxl30f7ZwS4DKspAysGfGR4Ww9OT3S0mnR7iAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ylrvrnHyWH0YghtGm+N7VjidqMYQgD+GyUDcWm2+2EmUwxO24zSLWs9P4jnyIjb1G
	 a7WDvjcWfcLeO9mo6jMGk6KcPY1dYtZb1H0uC4xkPjMyI3lhP0Yh1Tlz9cM3Up3zYf
	 27UrPOuBNzpJabE5pc931mBt3WEEWLPh3js/4h7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Laurent Dufour <ldufour@linux.ibm.com>,
	Zhang Rui <rui.zhang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 057/150] cpu/SMT: Create topology_smt_thread_allowed()
Date: Mon,  8 Jan 2024 16:35:08 +0100
Message-ID: <20240108153513.848789738@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
References: <20240108153511.214254205@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit 38253464bc821d6de6bba81bb1412ebb36f6cbd1 ]

Some architectures allows partial SMT states, i.e. when not all SMT threads
are brought online.

To support that, add an architecture helper which checks whether a given
CPU is allowed to be brought online depending on how many SMT threads are
currently enabled. Since this is only applicable to architecture supporting
partial SMT, only these architectures should select the new configuration
variable CONFIG_SMT_NUM_THREADS_DYNAMIC. For the other architectures, not
supporting the partial SMT states, there is no need to define
topology_cpu_smt_allowed(), the generic code assumed that all the threads
are allowed or only the primary ones.

Call the helper from cpu_smt_enable(), and cpu_smt_allowed() when SMT is
enabled, to check if the particular thread should be onlined. Notably,
also call it from cpu_smt_disable() if CPU_SMT_ENABLED, to allow
offlining some threads to move from a higher to lower number of threads
online.

[ ldufour: Slightly reword the commit's description ]
[ ldufour: Introduce CONFIG_SMT_NUM_THREADS_DYNAMIC ]

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Zhang Rui <rui.zhang@intel.com>
Link: https://lore.kernel.org/r/20230705145143.40545-7-ldufour@linux.ibm.com
Stable-dep-of: d91bdd96b55c ("cpu/SMT: Make SMT control more robust against enumeration failures")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/Kconfig |  3 +++
 kernel/cpu.c | 24 +++++++++++++++++++++++-
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index b60d271bf76a9..14273a6203dfc 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -34,6 +34,9 @@ config ARCH_HAS_SUBPAGE_FAULTS
 config HOTPLUG_SMT
 	bool
 
+config SMT_NUM_THREADS_DYNAMIC
+	bool
+
 config GENERIC_ENTRY
        bool
 
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 551468d9c5a85..c37f1758a4865 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -446,9 +446,23 @@ static int __init smt_cmdline_disable(char *str)
 }
 early_param("nosmt", smt_cmdline_disable);
 
+/*
+ * For Archicture supporting partial SMT states check if the thread is allowed.
+ * Otherwise this has already been checked through cpu_smt_max_threads when
+ * setting the SMT level.
+ */
+static inline bool cpu_smt_thread_allowed(unsigned int cpu)
+{
+#ifdef CONFIG_SMT_NUM_THREADS_DYNAMIC
+	return topology_smt_thread_allowed(cpu);
+#else
+	return true;
+#endif
+}
+
 static inline bool cpu_smt_allowed(unsigned int cpu)
 {
-	if (cpu_smt_control == CPU_SMT_ENABLED)
+	if (cpu_smt_control == CPU_SMT_ENABLED && cpu_smt_thread_allowed(cpu))
 		return true;
 
 	if (topology_is_primary_thread(cpu))
@@ -2294,6 +2308,12 @@ int cpuhp_smt_disable(enum cpuhp_smt_control ctrlval)
 	for_each_online_cpu(cpu) {
 		if (topology_is_primary_thread(cpu))
 			continue;
+		/*
+		 * Disable can be called with CPU_SMT_ENABLED when changing
+		 * from a higher to lower number of SMT threads per core.
+		 */
+		if (ctrlval == CPU_SMT_ENABLED && cpu_smt_thread_allowed(cpu))
+			continue;
 		ret = cpu_down_maps_locked(cpu, CPUHP_OFFLINE);
 		if (ret)
 			break;
@@ -2328,6 +2348,8 @@ int cpuhp_smt_enable(void)
 		/* Skip online CPUs and CPUs on offline nodes */
 		if (cpu_online(cpu) || !node_online(cpu_to_node(cpu)))
 			continue;
+		if (!cpu_smt_thread_allowed(cpu))
+			continue;
 		ret = _cpu_up(cpu, 0, CPUHP_ONLINE);
 		if (ret)
 			break;
-- 
2.43.0



