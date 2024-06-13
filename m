Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C29E13D635;
	Thu, 13 Jun 2024 12:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280471; cv=none; b=SuuRqtSNOhQ3A29bDwMk9RX/aypqEa5+14SdNZUgHQ6UwgQUdcGAiMC4yFHO4s0bHS9opuZYg48K54A0Y8yIemJ26rI0PXiFU13NxxhOZGCEmidEqBUnCZr/KsO5pIM5VLIPbL4xbCP9qEJgtCy+9dkCx81y5lfjlQfKl8idxiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280471; c=relaxed/simple;
	bh=Cn/4wXCuUj6OXb/FxZcuM+tJfzWV7Pm+H4EjvneQ/OU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VdUCngWfJK53XDXS6Af0hJ7SqSNjjqP6LHqWI4T+Wu3o1l/fSMg+IqzRwpCO5xvXqyk5pqOxmGDTIK9rsaFBSQ2xpjks++aYZXRYX8KeIlKEKzpuwsmoU62E9OAV2B8+U0vOz+xpoG7RB+3GedsQ4eUUUCqOwypZZy1bnMcGA5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bVz/CMHt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bVz/CMHt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C659C2BBFC;
	Thu, 13 Jun 2024 12:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280470;
	bh=Cn/4wXCuUj6OXb/FxZcuM+tJfzWV7Pm+H4EjvneQ/OU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bVz/CMHtEjr5Ikzf9iwZ0S+PFTyHmadslA7z4MZJW9NFZutyw15JoieR+dBtLMas7
	 /7PYoKBINAFJcPBI9uhRHKo5LyCeoK8DhhEP7f1i8RTEgz28LWWzUV0sMLoDGHwSZp
	 JdF4InxLSisMpSxfPD42AyrTvTmCzPnlkxjSQQbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 064/137] LoongArch: Add all CPUs enabled by fdt to NUMA node 0
Date: Thu, 13 Jun 2024 13:34:04 +0200
Message-ID: <20240613113225.785305265@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

commit 3de9c42d02a79a5e09bbee7a4421ddc00cfd5c6d upstream.

NUMA enabled kernel on FDT based machine fails to boot because CPUs
are all in NUMA_NO_NODE and mm subsystem won't accept that.

Fix by adding them to default NUMA node at FDT parsing phase and move
numa_add_cpu(0) to a later point.

Cc: stable@vger.kernel.org
Fixes: 88d4d957edc7 ("LoongArch: Add FDT booting support from efi system table")
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/include/asm/numa.h |    1 +
 arch/loongarch/kernel/smp.c       |    5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/arch/loongarch/include/asm/numa.h
+++ b/arch/loongarch/include/asm/numa.h
@@ -56,6 +56,7 @@ extern int early_cpu_to_node(int cpu);
 static inline void early_numa_add_cpu(int cpuid, s16 node)	{ }
 static inline void numa_add_cpu(unsigned int cpu)		{ }
 static inline void numa_remove_cpu(unsigned int cpu)		{ }
+static inline void set_cpuid_to_node(int cpuid, s16 node)	{ }
 
 static inline int early_cpu_to_node(int cpu)
 {
--- a/arch/loongarch/kernel/smp.c
+++ b/arch/loongarch/kernel/smp.c
@@ -262,7 +262,6 @@ static void __init fdt_smp_setup(void)
 
 		if (cpuid == loongson_sysconf.boot_cpu_id) {
 			cpu = 0;
-			numa_add_cpu(cpu);
 		} else {
 			cpu = cpumask_next_zero(-1, cpu_present_mask);
 		}
@@ -272,6 +271,9 @@ static void __init fdt_smp_setup(void)
 		set_cpu_present(cpu, true);
 		__cpu_number_map[cpuid] = cpu;
 		__cpu_logical_map[cpu] = cpuid;
+
+		early_numa_add_cpu(cpu, 0);
+		set_cpuid_to_node(cpuid, 0);
 	}
 
 	loongson_sysconf.nr_cpus = num_processors;
@@ -453,6 +455,7 @@ void smp_prepare_boot_cpu(void)
 	set_cpu_possible(0, true);
 	set_cpu_online(0, true);
 	set_my_cpu_offset(per_cpu_offset(0));
+	numa_add_cpu(0);
 
 	rr_node = first_node(node_online_map);
 	for_each_possible_cpu(cpu) {


