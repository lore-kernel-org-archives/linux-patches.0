Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B3D7602D;
	Mon, 29 Jan 2024 17:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548622; cv=none; b=g7CNO3tkbNeDLaL/SuriEV3cdLtDJBU6d1Kvx/fEtYahuI96xI055Zd2X7Myxwe7XjHAS0hposdoKORWdS5/QQSa2IQ1NRT/WbxR/2EM6yu6tbucaKB4/8mhqL3xOkkPdK6p97kdaDW2tPNSRZII5FwhcLxSUdzLN7W0QCLeTs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548622; c=relaxed/simple;
	bh=1VTR4Td5OTDaWTRsWhV0wccDKIcVvulOjAuVs+3wTBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OVJ3NId3hn8ajFnDRwmenDqT3Ji+aRXmPFjfkz+8XLfHV/c5KA5NOUkCToLXIoxdvcKHJp47tuVww9Pwa3f08ZOWPUL0c+AZnB4Xq/f8L6Ckt2mz9FlBAvHdQipupTVM4UTpvEZ1gWi62RHuJuaMeDvUDmL1nQvxXdHSs0Uft7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SwxHNDeD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SwxHNDeD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 067AEC433C7;
	Mon, 29 Jan 2024 17:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548622;
	bh=1VTR4Td5OTDaWTRsWhV0wccDKIcVvulOjAuVs+3wTBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SwxHNDeDaGocnxWAnsYgc3xtshaab/HQ3gfUGVMHK0EaWvtYaJyn97QAwJkRXfeEB
	 DQcmBLEjSh3zIpOh7gTRRjiwpxHfUPBfB3bMz5BNZB1vK9FUqlRU/44+D6T/j7NVnw
	 cu8mReIBwh8exWHt018XjUOUrVN5DsucuQ8qM6ZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 274/331] thermal: intel: hfi: Refactor enabling code into helper functions
Date: Mon, 29 Jan 2024 09:05:38 -0800
Message-ID: <20240129170022.885929608@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>

[ Upstream commit 8a8b6bb93c704776c4b05cb517c3fa8baffb72f5 ]

In preparation for the addition of a suspend notifier, wrap the logic to
enable HFI and program its memory buffer into helper functions. Both the
CPU hotplug callback and the suspend notifier will use them.

This refactoring does not introduce functional changes.

Signed-off-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 97566d09fd02 ("thermal: intel: hfi: Add syscore callbacks for system-wide PM")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/intel/intel_hfi.c | 43 ++++++++++++++++---------------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff --git a/drivers/thermal/intel/intel_hfi.c b/drivers/thermal/intel/intel_hfi.c
index c69db6c90869..820613e293cd 100644
--- a/drivers/thermal/intel/intel_hfi.c
+++ b/drivers/thermal/intel/intel_hfi.c
@@ -347,6 +347,26 @@ static void init_hfi_instance(struct hfi_instance *hfi_instance)
 	hfi_instance->data = hfi_instance->hdr + hfi_features.hdr_size;
 }
 
+/* Caller must hold hfi_instance_lock. */
+static void hfi_enable(void)
+{
+	u64 msr_val;
+
+	rdmsrl(MSR_IA32_HW_FEEDBACK_CONFIG, msr_val);
+	msr_val |= HW_FEEDBACK_CONFIG_HFI_ENABLE_BIT;
+	wrmsrl(MSR_IA32_HW_FEEDBACK_CONFIG, msr_val);
+}
+
+static void hfi_set_hw_table(struct hfi_instance *hfi_instance)
+{
+	phys_addr_t hw_table_pa;
+	u64 msr_val;
+
+	hw_table_pa = virt_to_phys(hfi_instance->hw_table);
+	msr_val = hw_table_pa | HW_FEEDBACK_PTR_VALID_BIT;
+	wrmsrl(MSR_IA32_HW_FEEDBACK_PTR, msr_val);
+}
+
 /**
  * intel_hfi_online() - Enable HFI on @cpu
  * @cpu:	CPU in which the HFI will be enabled
@@ -364,8 +384,6 @@ void intel_hfi_online(unsigned int cpu)
 {
 	struct hfi_instance *hfi_instance;
 	struct hfi_cpu_info *info;
-	phys_addr_t hw_table_pa;
-	u64 msr_val;
 	u16 die_id;
 
 	/* Nothing to do if hfi_instances are missing. */
@@ -409,8 +427,6 @@ void intel_hfi_online(unsigned int cpu)
 	if (!hfi_instance->hw_table)
 		goto unlock;
 
-	hw_table_pa = virt_to_phys(hfi_instance->hw_table);
-
 	/*
 	 * Allocate memory to keep a local copy of the table that
 	 * hardware generates.
@@ -420,16 +436,6 @@ void intel_hfi_online(unsigned int cpu)
 	if (!hfi_instance->local_table)
 		goto free_hw_table;
 
-	/*
-	 * Program the address of the feedback table of this die/package. On
-	 * some processors, hardware remembers the old address of the HFI table
-	 * even after having been reprogrammed and re-enabled. Thus, do not free
-	 * the pages allocated for the table or reprogram the hardware with a
-	 * new base address. Namely, program the hardware only once.
-	 */
-	msr_val = hw_table_pa | HW_FEEDBACK_PTR_VALID_BIT;
-	wrmsrl(MSR_IA32_HW_FEEDBACK_PTR, msr_val);
-
 	init_hfi_instance(hfi_instance);
 
 	INIT_DELAYED_WORK(&hfi_instance->update_work, hfi_update_work_fn);
@@ -438,13 +444,8 @@ void intel_hfi_online(unsigned int cpu)
 
 	cpumask_set_cpu(cpu, hfi_instance->cpus);
 
-	/*
-	 * Enable the hardware feedback interface and never disable it. See
-	 * comment on programming the address of the table.
-	 */
-	rdmsrl(MSR_IA32_HW_FEEDBACK_CONFIG, msr_val);
-	msr_val |= HW_FEEDBACK_CONFIG_HFI_ENABLE_BIT;
-	wrmsrl(MSR_IA32_HW_FEEDBACK_CONFIG, msr_val);
+	hfi_set_hw_table(hfi_instance);
+	hfi_enable();
 
 unlock:
 	mutex_unlock(&hfi_instance_lock);
-- 
2.43.0



