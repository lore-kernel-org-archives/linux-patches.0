Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F98439060B;
	Tue, 12 May 2026 17:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608327; cv=none; b=qN6pRQJzTdpD8SWUjSDnKe9t3bAOYUuLvXKUQptSGX6sV6p4JjZpPU3Od0jsqUxVPrfDN+CXZvOpfM5WrcgUWkrWAkHKO/SyeeKUBXfgKhPAoNJ+FO9hkFld6BlOoeE7isdkgfwiuC7Eo3JWaaY070+IrCqLpksk8QEYCwnmDso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608327; c=relaxed/simple;
	bh=KIbD8hINpCsFMf5YNCJJhdZkk+0ZmxrdzF4iYkAXGto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bcBhtoJCbe6YGoeabr3AWY3k8kloXojpZudWu8f4fb45VGkMcQ2v6NpKScr73OOKv+RnV6JmXRaPrNpDmqynaEt14QjL90V9SPRq+AbagaG5ljEUsxkgdGMUlgtWgMJdNADcCtZrT4nJDOKcwYnr6DK1bWUYvcgU2OitqTIzH1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G7ddUGp+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G7ddUGp+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7FA4C2BCB0;
	Tue, 12 May 2026 17:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608327;
	bh=KIbD8hINpCsFMf5YNCJJhdZkk+0ZmxrdzF4iYkAXGto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G7ddUGp+RPuIzer6WDqKkFyicP7UriEEn2fW663V0gOyLiJa5tRkBAsNUvrhHh4JR
	 SJjUdhbSwwiyHcWuwLlPiu3I1tGeuwTIxIHf5vdQ9n4w1YV5jSdXdUczBW3s9joPyg
	 /Hq9wYfzKi0Ijnjb70i7zFiBwzRtQSZY0ELyosx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Kelley <skelley@nvidia.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.18 008/270] ACPI: CPPC: Fix related_cpus inconsistency during CPU hotplug
Date: Tue, 12 May 2026 19:36:49 +0200
Message-ID: <20260512173938.631005527@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

From: Jinjie Ruan <ruanjinjie@huawei.com>

commit 75141a770f4f8225d316f6c7e146723a32e9720e upstream.

When concurrently bringing up and down two SMT threads of a physical
core, many warning call traces occur as below:

The issue timeline is as follows:

 1. When the system starts,
    cpufreq: CPU: 220, policy->related_cpus: 220-221, policy->cpus: 220-221

 2. Offline CPU 220 and CPU 221.

 3. Online CPU 220
    - CPU 221 is now offline, as acpi_get_psd_map() use
      for_each_online_cpu(), so the cpu_data->shared_cpu_map,
      policy->cpus, and related_cpus has only CPU 220.

    cpufreq: CPU: 220, policy->related_cpus: 220, policy->cpus: 220

 4. Offline CPU 220

 5. Online CPU 221, the below call trace occurs:
    - Since CPU 220 and CPU 221 share one policy, and
      policy->related_cpus = 220 after step 3, so CPU 221
      is not in policy->related_cpus but
      per_cpu(cpufreq_cpu_data, cpu221) is not NULL.

After reverting commit 56eb0c0ed345 ("ACPI: CPPC: Fix remaining
for_each_possible_cpu() to use online CPUs"), the issue disappeared.

The _PSD (P-State Dependency) defines the hardware-level dependency of
frequency control across CPU cores. Since this relationship is a physical
attribute of the hardware topology, it remains constant regardless of the
online or offline status of the CPUs.

Using for_each_online_cpu() in acpi_get_psd_map() is problematic. If a
CPU is offline, it will be excluded from the shared_cpu_map.
Consequently, if that CPU is brought online later, the kernel will fail
to recognize it as part of any shared frequency domain.

Switch back to for_each_possible_cpu() to ensure that all cores defined
in the ACPI tables are correctly mapped into their respective performance
domains from the start. This aligns with the logic of policy->related_cpus,
which must encompass all potentially available cores in the domain to
prevent logic gaps during CPU hotplug operations.

To resolve the original issue regarding the "nosmt" or "nosmt=force"
boot parameter, as send_pcc_cmd() function already does if (!desc)
continue, so reverting that loop back to for_each_possible_cpu() is ok,
only need to change the match_cpc_ptr NULL case in acpi_get_psd_map() to
continue as Sean suggested.

How to reproduce, on arm64 machine with SMT support which use acpi cppc
cpufreq driver:

	bash test.sh 220 & bash test.sh 221 &

	The test.sh is as below:
		while true
			do
			echo 0 > /sys/devices/system/cpu/cpu${1}/online
			sleep 0.5
			cat /sys/devices/system/cpu/cpu${1}/cpufreq/related_cpus
			echo 1 >  /sys/devices/system/cpu/cpu${1}/online
			cat /sys/devices/system/cpu/cpu${1}/cpufreq/related_cpus
		done

	CPU: 221 PID: 1119 Comm: cpuhp/221 Kdump: loaded Not tainted 6.6.0debug+ #5
	Hardware name: To be filled by O.E.M. S920X20/BC83AMDA01-7270Z, BIOS 20.39 09/04/2024
	pstate: a1400009 (NzCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
	pc : cpufreq_online+0x8ac/0xa90
	lr : cpuhp_cpufreq_online+0x18/0x30
	sp : ffff80008739bce0
	x29: ffff80008739bce0 x28: 0000000000000000 x27: ffff28400ca32200
	x26: 0000000000000000 x25: 0000000000000003 x24: ffffd483503ff000
	x23: ffffd483504051a0 x22: ffffd48350024a00 x21: 00000000000000dd
	x20: 000000000000001d x19: ffff28400ca32000 x18: 0000000000000000
	x17: 0000000000000020 x16: ffffd4834e6a3fc8 x15: 0000000000000020
	x14: 0000000000000008 x13: 0000000000000001 x12: 00000000ffffffff
	x11: 0000000000000040 x10: ffffd48350430728 x9 : ffffd4834f087c78
	x8 : 0000000000000001 x7 : ffff2840092bdf00 x6 : ffffd483504264f0
	x5 : ffffd48350405000 x4 : ffff283f7f95cc60 x3 : 0000000000000000
	x2 : ffff53bc2f94b000 x1 : 00000000000000dd x0 : 0000000000000000
	Call trace:
	 cpufreq_online+0x8ac/0xa90
	 cpuhp_cpufreq_online+0x18/0x30
	 cpuhp_invoke_callback+0x128/0x580
	 cpuhp_thread_fun+0x110/0x1b0
	 smpboot_thread_fn+0x140/0x190
	 kthread+0xec/0x100
	 ret_from_fork+0x10/0x20
	---[ end trace 0000000000000000 ]---

Cc: All applicable <stable@vger.kernel.org>
Fixes: 56eb0c0ed345 ("ACPI: CPPC: Fix remaining for_each_possible_cpu() to use online CPUs")
Co-developed-by: Sean Kelley <skelley@nvidia.com>
Signed-off-by: Sean Kelley <skelley@nvidia.com>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
[ rjw: Changelog edits ]
Link: https://patch.msgid.link/20260417040112.3727756-1-ruanjinjie@huawei.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/cppc_acpi.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -362,7 +362,7 @@ static int send_pcc_cmd(int pcc_ss_id, u
 end:
 	if (cmd == CMD_WRITE) {
 		if (unlikely(ret)) {
-			for_each_online_cpu(i) {
+			for_each_possible_cpu(i) {
 				struct cpc_desc *desc = per_cpu(cpc_desc_ptr, i);
 
 				if (!desc)
@@ -524,13 +524,13 @@ int acpi_get_psd_map(unsigned int cpu, s
 	else if (pdomain->coord_type == DOMAIN_COORD_TYPE_SW_ANY)
 		cpu_data->shared_type = CPUFREQ_SHARED_TYPE_ANY;
 
-	for_each_online_cpu(i) {
+	for_each_possible_cpu(i) {
 		if (i == cpu)
 			continue;
 
 		match_cpc_ptr = per_cpu(cpc_desc_ptr, i);
 		if (!match_cpc_ptr)
-			goto err_fault;
+			continue;
 
 		match_pdomain = &(match_cpc_ptr->domain_info);
 		if (match_pdomain->domain != pdomain->domain)


