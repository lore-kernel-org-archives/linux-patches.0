Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384BF299A94;
	Tue, 26 Aug 2025 14:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217669; cv=none; b=dsw/4UyllP7+qHexGRDjmb/ObLi45ZgqZW5LYCyQUnp5EAXLlAAUTxfHjGAfFvRjIo2RPgEYgR4g4xatydXELocdOd8y3WUTduCAq+WrJaVz8pHBQdL7v4gPkU4OrpX9npfRqbTetM0lYnSwp0uh89BAoq2qzkOihNGV8hlVsIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217669; c=relaxed/simple;
	bh=xBf2r3cZqZLQTw0+l1s0COfgz2tLDngl/7FsCdVj0vI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DFkXGvVpiOMCV/OsT4FCQwsAnOUbg44FFElBvwDWN9RI4fx/wej0BAcqM1AwtITTu+S7++uF2Ms+g3gMmU5O5EZ716+rXnbOhAKBYd7uGGs11qQmOjiHPsZzG1hrp8OM6vjGwPghPRqfYs8TNZ+2utbIVNAger85qX+0TgsSA5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LRnGdg13; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LRnGdg13"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF848C113CF;
	Tue, 26 Aug 2025 14:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217669;
	bh=xBf2r3cZqZLQTw0+l1s0COfgz2tLDngl/7FsCdVj0vI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LRnGdg13klg5SozK53OEwv5dgmfAI+6aGGH6fDBx5Tdi2PdLgpWIAY8FfDVNwGsMe
	 3OfFjIZ/3KMxNn4/NVHFWf3CA7zDm7InXXJMAie6sIhPlRwKQTvtCbQ2f2zpG0SY9D
	 QWwyJXgmIvWCmX5AIv1bi9it5v+QV47J1lraNuBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayi Li <lijiayi@kylinos.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.10 203/523] ACPI: processor: perflib: Fix initial _PPC limit application
Date: Tue, 26 Aug 2025 13:06:53 +0200
Message-ID: <20250826110929.453637438@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -176,11 +176,14 @@ void acpi_processor_ppc_init(struct cpuf
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
@@ -196,6 +199,11 @@ void acpi_processor_ppc_init(struct cpuf
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
 


