Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0BB828DF5E;
	Wed,  7 May 2025 19:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644439; cv=none; b=qffDCTBjLEOFGYj+aPS8Y9Z84Rc/uWdqmt74jfhFnQvnhBBUckjdTbIHlHj8WoLwzdgQ7uFilC30l3FI6NyH2zH/H65+37+82Q/d2tpweYmcdJD6WozKvP/OOPbScK3U9h7r73gZsm4am9HFwiMgqvUpZfU+d3rggJRQjW11lrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644439; c=relaxed/simple;
	bh=c+TVHIreOgIrravS373t4Nul60viPlb5xLUdZdBMqps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nJ52rXNloTIoKB3xHxPSpNA9we0vHuzoYCX3qmK0p5k2CqgfgrGHtWB9QTBYxkharysqN3VI9Q1fTdsoohyEp6Un4NMn0NCVkIFh3612shCQnnb44rGRSbLKBVN5sPVHRgzwWcnDAzHGIw0nOK3DCP4pRo7iy8KEg1yTYCYy+fY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eT6mPxjT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eT6mPxjT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA534C4CEF1;
	Wed,  7 May 2025 19:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644439;
	bh=c+TVHIreOgIrravS373t4Nul60viPlb5xLUdZdBMqps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eT6mPxjTDMgq3s0PnXX9ROjftwad+kfPZ1a8emUf3f1ytY1+IlH5MonzBvcIwMFxY
	 7zqqRAS4PjdNeRhy653pNYppPY/9l8CXAwUqhUgyKJ8y60/TUsEiwAXa9zRCFMqPCV
	 GlCXWq86k2qmEC5xRjOBexUr+L8j17n+bPP85C20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shouye Liu <shouyeliu@tencent.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.12 043/164] platform/x86/intel-uncore-freq: Fix missing uncore sysfs during CPU hotplug
Date: Wed,  7 May 2025 20:38:48 +0200
Message-ID: <20250507183822.628222484@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -146,15 +146,13 @@ static int uncore_event_cpu_online(unsig
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
@@ -163,7 +161,14 @@ static int uncore_event_cpu_online(unsig
 	data->die_id = topology_die_id(cpu);
 	data->domain_id = UNCORE_DOMAIN_ID_INVALID;
 
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


