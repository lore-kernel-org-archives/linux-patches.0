Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A9C3EEAC7;
	Tue, 21 Jul 2026 19:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661202; cv=none; b=SLSKVvXl5jLVTTnsucJ56ZoGFlKZV0VLovoHstTv2eCuwTAxRx4u5yStoagLpyf4NBKiYQcH9fbzLw9g3tZ/CiEQqgE0zIhZtlbZhnn7kMLgEcIeZVNYnoL2CUP63rYj86OjWAnKFrfOvLhPRYxSd6R/9iBb+3R3HjyxYczuDBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661202; c=relaxed/simple;
	bh=iV9zAQYG53R3X5UajP/mlkE0Oxpq9DhUw1jLqb9mQhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hXQgTYOSAmqCjo54aH+w7UZsiQDSaA0uhVdy/1o+nnCp3YRBgqcd0mZz8d8j0uSVANxo8l3E8CxFJCpPN+EvLbnygPxYE7JGVfyXLhfr1UB7ryOeqvy3EA38oL+OJI3s8FgnSSbUWjmMJEY/n7y9aQWft9kGngI4/S1Ibd6EqLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DelJ1//b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DelJ1//b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F9F01F000E9;
	Tue, 21 Jul 2026 19:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661200;
	bh=xxmSRyoCfN5qMRFAZWqNd6RSxfSrlNorzZ57a0fKCfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DelJ1//buxnpsXkdzHk1asL1abNtGBgv8xZVn4rCm6qGcLDPkbU86A4c3Hnu598XG
	 2/q9S3ls/SypDE/MPKXIYKwC1kht3ZbGcd/W0apKJxi2VUuCcmG0uE7GrDeWVPrNKm
	 pehCUcx2BD6qUN9wYNyvQ2PdZ7RkF1Gn7c8mzt1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	lihuisong@huawei.com,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1269/2077] ACPI: processor_idle: Mark LPI enter functions as __cpuidle
Date: Tue, 21 Jul 2026 17:15:42 +0200
Message-ID: <20260721152622.749964955@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 956ca5d72c76504824c8eb601879da9476973e15 ]

When function tracing or Kprobes is enabled, entering an ACPI Low
Power Idle (LPI) state triggers the following RCU splat:

  RCU not on for: acpi_idle_lpi_enter+0x4/0xd8
  WARNING: CPU: 8 PID: 0 at include/linux/trace_recursion.h:162 function_trace_call+0x1e8/0x228

The acpi_idle_lpi_enter() function is invoked within the cpuidle
path after RCU has already been disabled for the current local CPU.
Consequently, ftrace's function_trace_call() expects RCU to be
actively watching before recording trace data, emitting a warning
if it is not.

Fix this by annotating acpi_idle_lpi_enter(), the generic __weak
stub, and the RISC-V implementation of acpi_processor_ffh_lpi_enter()
with __cpuidle. This moves these functions into the '.cpuidle.text'
section, implicitly disabling ftrace instrumentation (notrace) along
this sensitive path and preventing trace-induced RCU warnings during
idle entry.

Fixes: a36a7fecfe60 ("ACPI / processor_idle: Add support for Low Power Idle(LPI) states")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Acked-by: lihuisong@huawei.com
Link: https://patch.msgid.link/20260616072617.2272-1-lirongqing@baidu.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/processor_idle.c | 4 ++--
 drivers/acpi/riscv/cpuidle.c  | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 390ab5f1d31378..4482cf28f56aee 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1143,7 +1143,7 @@ static int acpi_processor_get_lpi_info(struct acpi_processor *pr)
 	return 0;
 }
 
-int __weak acpi_processor_ffh_lpi_enter(struct acpi_lpi_state *lpi)
+int __weak __cpuidle acpi_processor_ffh_lpi_enter(struct acpi_lpi_state *lpi)
 {
 	return -ENODEV;
 }
@@ -1156,7 +1156,7 @@ int __weak acpi_processor_ffh_lpi_enter(struct acpi_lpi_state *lpi)
  *
  * Return: 0 for success or negative value for error
  */
-static int acpi_idle_lpi_enter(struct cpuidle_device *dev,
+static int __cpuidle acpi_idle_lpi_enter(struct cpuidle_device *dev,
 			       struct cpuidle_driver *drv, int index)
 {
 	struct acpi_processor *pr;
diff --git a/drivers/acpi/riscv/cpuidle.c b/drivers/acpi/riscv/cpuidle.c
index 624f9bbdb58c47..c76dbabff702e6 100644
--- a/drivers/acpi/riscv/cpuidle.c
+++ b/drivers/acpi/riscv/cpuidle.c
@@ -66,7 +66,7 @@ int acpi_processor_ffh_lpi_probe(unsigned int cpu)
 	return acpi_cpu_init_idle(cpu);
 }
 
-int acpi_processor_ffh_lpi_enter(struct acpi_lpi_state *lpi)
+int __cpuidle acpi_processor_ffh_lpi_enter(struct acpi_lpi_state *lpi)
 {
 	u32 state = lpi->address;
 
-- 
2.53.0



