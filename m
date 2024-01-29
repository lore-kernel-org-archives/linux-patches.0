Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21833158D9B;
	Mon, 29 Jan 2024 17:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548379; cv=none; b=VBrcOH8gZOnbdNpAVZS+1FAxsEyUMu6jeQ3/eVQ2PILKIPuhy+yXzjxIs9T23q7T2p9ntVAY/46/rbFYAjOCEd/BbwR6otx1ixxo5oDOmdZZXUXiWDgNmzccJMq5rPN3SCgieEm0OsnnkQqE7ekQV0clUuuHvARIMLx20XjW+rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548379; c=relaxed/simple;
	bh=cdU59OxyhQZRG/sYFKrFDdc+jKxtPfNAnm/xnuq/jtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WSsCw1IV5GrpxwY0b/doqa3qKIOZyt2uAzRR2cTW/ismtpkS2Ta9LJYmMi0D8OHAnqibXb+RY0lLxPFEOfTdJporn6CqY8JSvc0DA9JLN8W0itOCGEvMJUalIU6aIFpxhZrLBmzNHKGN11ESOsohcsSF6A3/RaR6RGPq/WzZDYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w/SyMC9o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w/SyMC9o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBD73C433F1;
	Mon, 29 Jan 2024 17:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548379;
	bh=cdU59OxyhQZRG/sYFKrFDdc+jKxtPfNAnm/xnuq/jtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w/SyMC9oo2f2O+A4J3+Zoj4Cn9aCKD33CtzaVGfzSDPRn1J3tMd2tKCt5h1aNSGME
	 1aKRrKzCirbhzBIeP4e7Laz7PQUsaPxrDLrL4KC90B3eezqovTBj5UErPzGEGZlM0M
	 Jzn/3+RozTI0nw58PC/pJk9eu3ZdbYtHxYkMpCpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 149/185] thermal: intel: hfi: Disable an HFI instance when all its CPUs go offline
Date: Mon, 29 Jan 2024 09:05:49 -0800
Message-ID: <20240129170003.373003894@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

From: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>

[ Upstream commit 1c53081d773c2cb4461636559b0d55b46559ceec ]

In preparation to support hibernation, add functionality to disable an HFI
instance during CPU offline. The last CPU of an instance that goes offline
will disable such instance.

The Intel Software Development Manual states that the operating system must
wait for the hardware to set MSR_IA32_PACKAGE_THERM_STATUS[26] after
disabling an HFI instance to ensure that it will no longer write on the HFI
memory. Some processors, however, do not ever set such bit. Wait a minimum
of 2ms to give time hardware to complete any pending memory writes.

Signed-off-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 97566d09fd02 ("thermal: intel: hfi: Add syscore callbacks for system-wide PM")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/intel/intel_hfi.c | 35 +++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/thermal/intel/intel_hfi.c b/drivers/thermal/intel/intel_hfi.c
index 1a014595ed49..5352fcb72ea3 100644
--- a/drivers/thermal/intel/intel_hfi.c
+++ b/drivers/thermal/intel/intel_hfi.c
@@ -24,6 +24,7 @@
 #include <linux/bitops.h>
 #include <linux/cpufeature.h>
 #include <linux/cpumask.h>
+#include <linux/delay.h>
 #include <linux/gfp.h>
 #include <linux/io.h>
 #include <linux/kernel.h>
@@ -358,6 +359,32 @@ static void hfi_set_hw_table(struct hfi_instance *hfi_instance)
 	wrmsrl(MSR_IA32_HW_FEEDBACK_PTR, msr_val);
 }
 
+/* Caller must hold hfi_instance_lock. */
+static void hfi_disable(void)
+{
+	u64 msr_val;
+	int i;
+
+	rdmsrl(MSR_IA32_HW_FEEDBACK_CONFIG, msr_val);
+	msr_val &= ~HW_FEEDBACK_CONFIG_HFI_ENABLE_BIT;
+	wrmsrl(MSR_IA32_HW_FEEDBACK_CONFIG, msr_val);
+
+	/*
+	 * Wait for hardware to acknowledge the disabling of HFI. Some
+	 * processors may not do it. Wait for ~2ms. This is a reasonable
+	 * time for hardware to complete any pending actions on the HFI
+	 * memory.
+	 */
+	for (i = 0; i < 2000; i++) {
+		rdmsrl(MSR_IA32_PACKAGE_THERM_STATUS, msr_val);
+		if (msr_val & PACKAGE_THERM_STATUS_HFI_UPDATED)
+			break;
+
+		udelay(1);
+		cpu_relax();
+	}
+}
+
 /**
  * intel_hfi_online() - Enable HFI on @cpu
  * @cpu:	CPU in which the HFI will be enabled
@@ -412,6 +439,10 @@ void intel_hfi_online(unsigned int cpu)
 	/*
 	 * Hardware is programmed with the physical address of the first page
 	 * frame of the table. Hence, the allocated memory must be page-aligned.
+	 *
+	 * Some processors do not forget the initial address of the HFI table
+	 * even after having been reprogrammed. Keep using the same pages. Do
+	 * not free them.
 	 */
 	hfi_instance->hw_table = alloc_pages_exact(hfi_features.nr_table_pages,
 						   GFP_KERNEL | __GFP_ZERO);
@@ -476,6 +507,10 @@ void intel_hfi_offline(unsigned int cpu)
 
 	mutex_lock(&hfi_instance_lock);
 	cpumask_clear_cpu(cpu, hfi_instance->cpus);
+
+	if (!cpumask_weight(hfi_instance->cpus))
+		hfi_disable();
+
 	mutex_unlock(&hfi_instance_lock);
 }
 
-- 
2.43.0



