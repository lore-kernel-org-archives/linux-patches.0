Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F48337EB4;
	Wed, 17 Sep 2025 12:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112894; cv=none; b=sf0yZ9MuTcCrMTfrk6GscFTD7voqYxI+ZpD4rJp4jxTxdmwl5VFl6aTETPPQA9O+tIKYX4jwgHCveYH1FM/PdB61gxFpOx249cgIRGD25VZDoJD0F0Y+YWmp/+/uflCR6gMUeHapyN4WDTlt5QeCmKlx6oP47gBhEUvF/NnSg2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112894; c=relaxed/simple;
	bh=hnqr6iMPTPBRGl9ZNrEsu7kMOK8XYoWLNOnC9zkAuYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oa6VRipUihiXBY0XdUpcU8wbQdXBJet9/WuoR091TUGwHHWOkOKoGt6ztZW+KpXvtG0HU21h9zmLtsiNZ965rd9P51ZcCFGEisDCsTEV+xFChTZjJ3KIKDTqxCQNRcXx/OvZEcjXRiUPdrZN8otIrexs7j+gThrBXTQvKE95Im8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ci8nWZ8k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ci8nWZ8k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F8FBC4CEF5;
	Wed, 17 Sep 2025 12:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112894;
	bh=hnqr6iMPTPBRGl9ZNrEsu7kMOK8XYoWLNOnC9zkAuYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ci8nWZ8kidNgrJWwCb11oe4CMBtGRtdI/TCcjGabQr4fBPP+Rflbs6qhcZy440E2R
	 S9/cqGO/kH3E17a4dffELe7M31MAqOW1XSjUuQGes0Tu+oddchU2pEBKPWQh3nZpEA
	 gYtWjfQ5CH4488T55MYBbzDWlDGpGVhNJxeoJMuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kenneth R. Crudup" <kenny@panix.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.16 064/189] PM: EM: Add function for registering a PD without capacity update
Date: Wed, 17 Sep 2025 14:32:54 +0200
Message-ID: <20250917123353.437538523@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit e0423541477dfb684fbc6e6b5386054bc650f264 upstream.

The intel_pstate driver manages CPU capacity changes itself and it does
not need an update of the capacity of all CPUs in the system to be
carried out after registering a PD.

Moreover, in some configurations (for instance, an SMT-capable
hybrid x86 system booted with nosmt in the kernel command line) the
em_check_capacity_update() call at the end of em_dev_register_perf_domain()
always fails and reschedules itself to run once again in 1 s, so
effectively it runs in vain every 1 s forever.

To address this, introduce a new variant of em_dev_register_perf_domain(),
called em_dev_register_pd_no_update(), that does not invoke
em_check_capacity_update(), and make intel_pstate use it instead of the
original.

Fixes: 7b010f9b9061 ("cpufreq: intel_pstate: EAS support for hybrid platforms")
Closes: https://lore.kernel.org/linux-pm/40212796-734c-4140-8a85-854f72b8144d@panix.com/
Reported-by: Kenneth R. Crudup <kenny@panix.com>
Tested-by: Kenneth R. Crudup <kenny@panix.com>
Cc: 6.16+ <stable@vger.kernel.org> # 6.16+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/intel_pstate.c |  4 ++--
 include/linux/energy_model.h   | 10 ++++++++++
 kernel/power/energy_model.c    | 29 +++++++++++++++++++++++++----
 3 files changed, 37 insertions(+), 6 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index f366d35c5840..0d5d283a5429 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -1034,8 +1034,8 @@ static bool hybrid_register_perf_domain(unsigned int cpu)
 	if (!cpu_dev)
 		return false;
 
-	if (em_dev_register_perf_domain(cpu_dev, HYBRID_EM_STATE_COUNT, &cb,
-					cpumask_of(cpu), false))
+	if (em_dev_register_pd_no_update(cpu_dev, HYBRID_EM_STATE_COUNT, &cb,
+					 cpumask_of(cpu), false))
 		return false;
 
 	cpudata->pd_registered = true;
diff --git a/include/linux/energy_model.h b/include/linux/energy_model.h
index 7fa1eb3cc823..61d50571ad88 100644
--- a/include/linux/energy_model.h
+++ b/include/linux/energy_model.h
@@ -171,6 +171,9 @@ int em_dev_update_perf_domain(struct device *dev,
 int em_dev_register_perf_domain(struct device *dev, unsigned int nr_states,
 				const struct em_data_callback *cb,
 				const cpumask_t *cpus, bool microwatts);
+int em_dev_register_pd_no_update(struct device *dev, unsigned int nr_states,
+				 const struct em_data_callback *cb,
+				 const cpumask_t *cpus, bool microwatts);
 void em_dev_unregister_perf_domain(struct device *dev);
 struct em_perf_table *em_table_alloc(struct em_perf_domain *pd);
 void em_table_free(struct em_perf_table *table);
@@ -350,6 +353,13 @@ int em_dev_register_perf_domain(struct device *dev, unsigned int nr_states,
 {
 	return -EINVAL;
 }
+static inline
+int em_dev_register_pd_no_update(struct device *dev, unsigned int nr_states,
+				 const struct em_data_callback *cb,
+				 const cpumask_t *cpus, bool microwatts)
+{
+	return -EINVAL;
+}
 static inline void em_dev_unregister_perf_domain(struct device *dev)
 {
 }
diff --git a/kernel/power/energy_model.c b/kernel/power/energy_model.c
index ea7995a25780..8df55397414a 100644
--- a/kernel/power/energy_model.c
+++ b/kernel/power/energy_model.c
@@ -552,6 +552,30 @@ EXPORT_SYMBOL_GPL(em_cpu_get);
 int em_dev_register_perf_domain(struct device *dev, unsigned int nr_states,
 				const struct em_data_callback *cb,
 				const cpumask_t *cpus, bool microwatts)
+{
+	int ret = em_dev_register_pd_no_update(dev, nr_states, cb, cpus, microwatts);
+
+	if (_is_cpu_device(dev))
+		em_check_capacity_update();
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(em_dev_register_perf_domain);
+
+/**
+ * em_dev_register_pd_no_update() - Register a perf domain for a device
+ * @dev : Device to register the PD for
+ * @nr_states : Number of performance states in the new PD
+ * @cb : Callback functions for populating the energy model
+ * @cpus : CPUs to include in the new PD (mandatory if @dev is a CPU device)
+ * @microwatts : Whether or not the power values in the EM will be in uW
+ *
+ * Like em_dev_register_perf_domain(), but does not trigger a CPU capacity
+ * update after registering the PD, even if @dev is a CPU device.
+ */
+int em_dev_register_pd_no_update(struct device *dev, unsigned int nr_states,
+				 const struct em_data_callback *cb,
+				 const cpumask_t *cpus, bool microwatts)
 {
 	struct em_perf_table *em_table;
 	unsigned long cap, prev_cap = 0;
@@ -636,12 +660,9 @@ int em_dev_register_perf_domain(struct device *dev, unsigned int nr_states,
 unlock:
 	mutex_unlock(&em_pd_mutex);
 
-	if (_is_cpu_device(dev))
-		em_check_capacity_update();
-
 	return ret;
 }
-EXPORT_SYMBOL_GPL(em_dev_register_perf_domain);
+EXPORT_SYMBOL_GPL(em_dev_register_pd_no_update);
 
 /**
  * em_dev_unregister_perf_domain() - Unregister Energy Model (EM) for a device
-- 
2.51.0



