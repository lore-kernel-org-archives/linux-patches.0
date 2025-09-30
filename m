Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE3CF2F6167;
	Tue, 30 Sep 2025 15:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244842; cv=none; b=OtW4UpGLTW6gFtEwLKmhHPxbj8KoTreXr64Uc94Z58Jj5VdnCa/ZpZFNj8FSgR1jFUfNwIYHqf14r7TCmhuMyiT7zpBIBc+ZiOnszUc4GJOluX5H0f3nGilILEeY9qmwmsr9M3iiBd+avVo6zvaELNb/pGPhokXoXUg0HFGAIKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244842; c=relaxed/simple;
	bh=SLMzTJFwLi5C8+ul/zAgqW9He5fNA01k8Zocl5AKfAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lVNCH+xrFoR7Jz1QBtCfjmmArJTPe0G1BLaexpT2OEqXY/mDf7E6CuFAKtr9lhSExgVqLmdWFxjTXYZWDn2ivv02GCNzLvvU5jc54VrXg78iaal7lw7iDoBKpKsT3tWtYDqrDYEBTeUXfb2Nw6jyiAzEovNb7qmTpYKAHalENTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fMYGf8oR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fMYGf8oR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C401C4CEF0;
	Tue, 30 Sep 2025 15:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244842;
	bh=SLMzTJFwLi5C8+ul/zAgqW9He5fNA01k8Zocl5AKfAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fMYGf8oRHVI3OXG4C/bMvP/0YVlj0iXx/qN5gHkU1zzZk9rTefBR22S+tyUUNsPse
	 YLQVNZM0MTEF/cTvVnQhYgodLoAupjDI3Lni87uGmNLEZc0FPrP1bY+IM/15h2xi3I
	 vEjv0zZR3tMXBuXtXsVa/5JTpIxMc6Wk8S4mTBjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Loehle <christian.loehle@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>
Subject: [PATCH 6.16 131/143] x86/topology: Implement topology_is_core_online() to address SMT regression
Date: Tue, 30 Sep 2025 16:47:35 +0200
Message-ID: <20250930143836.453138761@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 2066f00e5b2dc061fb6d8c88fadaebc97f11feaa upstream.

Christian reported that commit a430c11f4015 ("intel_idle: Rescan "dead" SMT
siblings during initialization") broke the use case in which both 'nosmt'
and 'maxcpus' are on the kernel command line because it onlines primary
threads, which were offline due to the maxcpus limit.

The initially proposed fix to skip primary threads in the loop is
inconsistent. While it prevents the primary thread to be onlined, it then
onlines the corresponding hyperthread(s), which does not really make sense.

The CPU iterator in cpuhp_smt_enable() contains a check which excludes all
threads of a core, when the primary thread is offline. The default
implementation is a NOOP and therefore not effective on x86.

Implement topology_is_core_online() on x86 to address this issue. This
makes the behaviour consistent between x86 and PowerPC.

Fixes: a430c11f4015 ("intel_idle: Rescan "dead" SMT siblings during initialization")
Fixes: f694481b1d31 ("ACPI: processor: Rescan "dead" SMT siblings during initialization")
Closes: https://lore.kernel.org/linux-pm/724616a2-6374-4ba3-8ce3-ea9c45e2ae3b@arm.com/
Reported-by: Christian Loehle <christian.loehle@arm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Tested-by: Christian Loehle <christian.loehle@arm.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/12740505.O9o76ZdvQC@rafael.j.wysocki
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/topology.h | 10 ++++++++++
 arch/x86/kernel/cpu/topology.c  | 13 +++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 6c79ee7c0957..21041898157a 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -231,6 +231,16 @@ static inline bool topology_is_primary_thread(unsigned int cpu)
 }
 #define topology_is_primary_thread topology_is_primary_thread
 
+int topology_get_primary_thread(unsigned int cpu);
+
+static inline bool topology_is_core_online(unsigned int cpu)
+{
+	int pcpu = topology_get_primary_thread(cpu);
+
+	return pcpu >= 0 ? cpu_online(pcpu) : false;
+}
+#define topology_is_core_online topology_is_core_online
+
 #else /* CONFIG_SMP */
 static inline int topology_phys_to_logical_pkg(unsigned int pkg) { return 0; }
 static inline int topology_max_smt_threads(void) { return 1; }
diff --git a/arch/x86/kernel/cpu/topology.c b/arch/x86/kernel/cpu/topology.c
index e35ccdc84910..6073a16628f9 100644
--- a/arch/x86/kernel/cpu/topology.c
+++ b/arch/x86/kernel/cpu/topology.c
@@ -372,6 +372,19 @@ unsigned int topology_unit_count(u32 apicid, enum x86_topology_domains which_uni
 	return topo_unit_count(lvlid, at_level, apic_maps[which_units].map);
 }
 
+#ifdef CONFIG_SMP
+int topology_get_primary_thread(unsigned int cpu)
+{
+	u32 apic_id = cpuid_to_apicid[cpu];
+
+	/*
+	 * Get the core domain level APIC id, which is the primary thread
+	 * and return the CPU number assigned to it.
+	 */
+	return topo_lookup_cpuid(topo_apicid(apic_id, TOPO_CORE_DOMAIN));
+}
+#endif
+
 #ifdef CONFIG_ACPI_HOTPLUG_CPU
 /**
  * topology_hotplug_apic - Handle a physical hotplugged APIC after boot
-- 
2.51.0



