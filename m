Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE050343218;
	Tue, 26 Aug 2025 13:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216066; cv=none; b=uDC16ezXzbMSfXono6fnZF7de0cSM7M8H+tKZ92l2PdJsrfI/yDtsSbci7C1tc4sv9205xJ+anlKKAbLTqRdGyXaPvFu7EH7CZ/dQfqmxm6naAATa9lvbgW72za5X1FR9sKGtDEVaf7QkPxEsI+l5tkoq+V3mT84o/4tNy+bpck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216066; c=relaxed/simple;
	bh=cMeG3YjRogxCwUwuC8Rs6jvq1cbva3v8szEOSiJuhGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PZU+sxYpQZK8iKatqKOmXJcJe21Sidx0Eq5xga+tCRFqgjtTzPHH0F2TdoCnhlGc7ohcd6XiJY4klmK+UuMLzSa2Mqd0QekwWMLyRCdzZaF1p4ilIDdSnRmEqxatzb4L272Rn0cZpIcjyhqp+n6IFyopV2RvkvTLNZAiGmr74MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t20tW9z2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t20tW9z2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43124C4CEF1;
	Tue, 26 Aug 2025 13:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216066;
	bh=cMeG3YjRogxCwUwuC8Rs6jvq1cbva3v8szEOSiJuhGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t20tW9z2wkF0bw6vLgmzrSxqc4iF7aw4jrcFHUEcW13+SMOIWSTVfbJ/Niy5U7Caf
	 7aHUEeuzUbLd3eXsS2djsgnWY5Pzx4+UCKY5Qf1Sw2cpQNyu98wGRkBfSqF4xSbDq7
	 pUNsO/GUZ/5Sm6xnB5FH+98ENcsUBVm0h+Zet+ao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayi Li <lijiayi@kylinos.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.15 272/644] ACPI: processor: perflib: Fix initial _PPC limit application
Date: Tue, 26 Aug 2025 13:06:03 +0200
Message-ID: <20250826110953.110781008@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayi Li <lijiayi@kylinos.cn>

commit d33bd88ac0ebb49e7f7c8f29a8c7ee9eae85d765 upstream.

If the BIOS sets a _PPC frequency limit upfront, it will fail to take
effect due to a call ordering issue.  Namely, freq_qos_update_request()
is called before freq_qos_add_request() for the given request causing
the constraint update to be ignored.  The call sequence in question is
as follows:

cpufreq_policy_online()
  acpi_cpufreq_cpu_init()
    acpi_processor_register_performance()
      acpi_processor_get_performance_info()
        acpi_processor_get_platform_limit()
         freq_qos_update_request(&perflib_req) <- inactive QoS request
  blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
                               CPUFREQ_CREATE_POLICY)
    acpi_processor_notifier()
      acpi_processor_ppc_init()
        freq_qos_add_request(&perflib_req) <- QoS request activation

Address this by adding an acpi_processor_get_platform_limit() call
to acpi_processor_ppc_init(), after the perflib_req activation via
freq_qos_add_request(), which causes the initial _PPC limit to be
picked up as appropriate.  However, also ensure that the _PPC limit
will not be picked up in the cases when the cpufreq driver does not
call acpi_processor_register_performance() by adding a pr->performance
check to the related_cpus loop in acpi_processor_ppc_init().

Fixes: d15ce412737a ("ACPI: cpufreq: Switch to QoS requests instead of cpufreq notifier")
Signed-off-by: Jiayi Li <lijiayi@kylinos.cn>
Link: https://patch.msgid.link/20250721032606.3459369-1-lijiayi@kylinos.cn
[ rjw: Consolidate pr-related checks in acpi_processor_ppc_init() ]
[ rjw: Subject and changelog adjustments ]
Cc: 5.4+ <stable@vger.kernel.org> # 5.4+: 2d8b39a62a5d ACPI: processor: Avoid NULL pointer dereferences at init time
Cc: 5.4+ <stable@vger.kernel.org> # 5.4+: 3000ce3c52f8 cpufreq: Use per-policy frequency QoS
Cc: 5.4+ <stable@vger.kernel.org> # 5.4+: a1bb46c36ce3 ACPI: processor: Add QoS requests for all CPUs
Cc: 5.4+ <stable@vger.kernel.org> # 5.4+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/processor_perflib.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/acpi/processor_perflib.c
+++ b/drivers/acpi/processor_perflib.c
@@ -173,11 +173,14 @@ void acpi_processor_ppc_init(struct cpuf
 {
 	unsigned int cpu;
 
+	if (ignore_ppc == 1)
+		return;
+
 	for_each_cpu(cpu, policy->related_cpus) {
 		struct acpi_processor *pr = per_cpu(processors, cpu);
 		int ret;
 
-		if (!pr)
+		if (!pr || !pr->performance)
 			continue;
 
 		/*
@@ -193,6 +196,11 @@ void acpi_processor_ppc_init(struct cpuf
 		if (ret < 0)
 			pr_err("Failed to add freq constraint for CPU%d (%d)\n",
 			       cpu, ret);
+
+		ret = acpi_processor_get_platform_limit(pr);
+		if (ret)
+			pr_err("Failed to update freq constraint for CPU%d (%d)\n",
+			       cpu, ret);
 	}
 }
 


