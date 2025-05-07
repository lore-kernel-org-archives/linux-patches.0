Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C55114A4C7;
	Wed,  7 May 2025 18:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643479; cv=none; b=UiCY4u8624naUHc63rbDZvO3d1dCGcKBrmnhfFOkZNSK1x9VKT9vWnYM2ioQATjfVfS6GDZPLK0pGYT3ER/yZy+b86sp6RkXo5lQWLGZs3KvwNIP9P0YfE/8ua9uKfNO25uJrC7JxckAH6TYcthwihd1xa9KCPC6i1nOawqI3PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643479; c=relaxed/simple;
	bh=2vzXoLuIFRMYLcK2HJ/QtVXxoWl6xgBrJA80Hbky1/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EHp3JKAtPbvzM5pOFYMIpBor8CjZys6ilBHpns+Ao/RX0xsPKLTuIWXAibjGSYmv+xlM0Frtzb61DWlVlDcV7lKdNShDjPur3w5FMjzEHdhZP0wVoae745LGJ4mJaXEa8xgLhhm7o38xlL9tJgdx8y2Yl/ikL2cq9Rnca3gn2PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=avfXKcnN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="avfXKcnN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1A64C4CEE2;
	Wed,  7 May 2025 18:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643479;
	bh=2vzXoLuIFRMYLcK2HJ/QtVXxoWl6xgBrJA80Hbky1/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=avfXKcnNCIZzZOzJH/5FXFYGtPLDtvuAfC4IwgHAiDzVB6FYX/ToXW+J6uMTbGz0C
	 SbcRQO5HnNe6KfSBApWBzQ1BQIrt1NLq2blQt8nV33qfst4hMRbqF/Z06xSTlwNAKw
	 yknFN4kG1h77E+JAQLegPnLfw4vSOh/+ZjcMjUyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shouye Liu <shouyeliu@tencent.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.1 18/97] platform/x86/intel-uncore-freq: Fix missing uncore sysfs during CPU hotplug
Date: Wed,  7 May 2025 20:38:53 +0200
Message-ID: <20250507183807.716606904@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183806.987408728@linuxfoundation.org>
References: <20250507183806.987408728@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shouye Liu <shouyeliu@tencent.com>

commit 8d6955ed76e8a47115f2ea1d9c263ee6f505d737 upstream.

In certain situations, the sysfs for uncore may not be present when all
CPUs in a package are offlined and then brought back online after boot.

This issue can occur if there is an error in adding the sysfs entry due
to a memory allocation failure. Retrying to bring the CPUs online will
not resolve the issue, as the uncore_cpu_mask is already set for the
package before the failure condition occurs.

This issue does not occur if the failure happens during module
initialization, as the module will fail to load in the event of any
error.

To address this, ensure that the uncore_cpu_mask is not set until the
successful return of uncore_freq_add_entry().

Fixes: dbce412a7733 ("platform/x86/intel-uncore-freq: Split common and enumeration part")
Signed-off-by: Shouye Liu <shouyeliu@tencent.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250417032321.75580-1-shouyeliu@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel/uncore-frequency/uncore-frequency.c |   13 ++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/platform/x86/intel/uncore-frequency/uncore-frequency.c
+++ b/drivers/platform/x86/intel/uncore-frequency/uncore-frequency.c
@@ -121,15 +121,13 @@ static int uncore_event_cpu_online(unsig
 {
 	struct uncore_data *data;
 	int target;
+	int ret;
 
 	/* Check if there is an online cpu in the package for uncore MSR */
 	target = cpumask_any_and(&uncore_cpu_mask, topology_die_cpumask(cpu));
 	if (target < nr_cpu_ids)
 		return 0;
 
-	/* Use this CPU on this die as a control CPU */
-	cpumask_set_cpu(cpu, &uncore_cpu_mask);
-
 	data = uncore_get_instance(cpu);
 	if (!data)
 		return 0;
@@ -137,7 +135,14 @@ static int uncore_event_cpu_online(unsig
 	data->package_id = topology_physical_package_id(cpu);
 	data->die_id = topology_die_id(cpu);
 
-	return uncore_freq_add_entry(data, cpu);
+	ret = uncore_freq_add_entry(data, cpu);
+	if (ret)
+		return ret;
+
+	/* Use this CPU on this die as a control CPU */
+	cpumask_set_cpu(cpu, &uncore_cpu_mask);
+
+	return 0;
 }
 
 static int uncore_event_cpu_offline(unsigned int cpu)


